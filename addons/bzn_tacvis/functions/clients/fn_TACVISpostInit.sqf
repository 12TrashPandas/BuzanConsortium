if (isDedicated or !local player) exitWith {};

BZN_tacvis_debug = true;

// -------------------------------------------------------------------------
// Device / CQC / vehicle lists are CBA settings (see config/cba_settings.hpp,
// category "BZN TacVis"). CBA populates these globals in preInit, before this
// postInit runs. The defensive defaults below keep the addon inert (rather
// than erroring) if CBA is ever unavailable.
// -------------------------------------------------------------------------
if (isNil "BZN_tacvis_devices")     then { BZN_tacvis_devices = []; };
if (isNil "BZN_tacvis_devices_cqc") then { BZN_tacvis_devices_cqc = []; };
if (isNil "BZN_tacvis_vehicles")    then { BZN_tacvis_vehicles = []; };

// Runtime flags
BZN_tacvis_friendly_active = false;
BZN_tacvis_CQC_active      = false;
BZN_tacvis_CQC_cooldown    = false;
BZN_tacvis_spot_cooldown   = false;
BZN_tacvis_radar_active    = false;
BZN_tacvis_threat_active   = false;
BZN_tacvis_radar_range     = 6000;   // metres; radar contact scan radius
BZN_tacvis_air_range       = 5000;   // metres; display/IFF range for flying vehicles
BZN_tacvis_ground_air_range = 1500;  // metres; ground-unit display range when the observer is airborne

// Render pools
BZN_tacvis_pool_friendly = [];   // friendlies + spotted enemies (always-on)
BZN_tacvis_pool_CQC      = [];   // nearby enemies (CQC mode only)
BZN_tacvis_radar         = [];   // shared [unit, expiry] radar contacts (from any operator)
BZN_tacvis_threat        = [];   // local [unit, expiry] hostile-civilian alarm markers

// Spotted enemies — persistent 3D tags; plain list of units, pruned on death.
BZN_tacvis_spotted = [];

// Action IDs
BZN_tacvis_spot_action = -1;
BZN_tacvis_CQC_action  = -1;

// Draw3D event handler ID (-1 = not running, -2 = being initialised)
BZN_tacvis_Display = -1;

// -------------------------------------------------------------------------
// Helpers (stored as global vars so event handlers can call them)
// -------------------------------------------------------------------------

BZN_fnc_tacvis_inApprovedVehicle = {
    private _veh = objectParent player;
    (!isNull _veh) and { (typeOf _veh) in BZN_tacvis_vehicles }
};

// True if the given vehicle's config declares an ACTIVE radar. Checks the legacy
// radarType flag (old-style active radar) and the sensor-overhaul
// SensorsManagerComponent for an active radar sensor component specifically
// (passive radar / RWR does not count).
BZN_fnc_tacvis_vehicleHasRadar = {
    params ["_veh"];
    if (isNull _veh) exitWith { false };
    private _cfg = configOf _veh;
    if (getNumber (_cfg >> "radarType") > 0) exitWith { true };
    private _found = false;
    {
        if (((configName _x) find "ActiveRadar") >= 0) exitWith { _found = true };
    } forEach ("true" configClasses (_cfg >> "Components" >> "SensorsManagerComponent" >> "Components"));
    _found
};

BZN_fnc_tacvis_hasDevice = {
    headgear player in BZN_tacvis_devices
    or goggles player in BZN_tacvis_devices
    or (call BZN_fnc_tacvis_inApprovedVehicle)
};

BZN_fnc_tacvis_hasCQCDevice = {
    headgear player in BZN_tacvis_devices_cqc or goggles player in BZN_tacvis_devices_cqc
};

BZN_fnc_tacvis_removeActions = {
    {
        if ((player actionParams _x) select 0 in ["Spot Target", "Toggle CQC"]) then {
            player removeAction _x;
        };
    } forEach actionIDs player;
    BZN_tacvis_spot_action = -1;
    BZN_tacvis_CQC_action  = -1;
};

BZN_fnc_tacvis_startRender = {
    if (BZN_tacvis_Display == -1) then {
        BZN_tacvis_Display = -2; // sentinel: init in progress
        [] spawn BZN_fnc_tacvisRenderEngine;
    };
};

BZN_fnc_tacvis_stopAll = {
    call BZN_fnc_tacvis_removeActions;
    BZN_tacvis_friendly_active = false;
    BZN_tacvis_CQC_active      = false;
    BZN_tacvis_radar_active    = false;
    BZN_tacvis_threat_active   = false;
    BZN_tacvis_pool_friendly   = [];
    BZN_tacvis_pool_CQC        = [];
    BZN_tacvis_threat          = [];
    if (BZN_tacvis_Display >= 0) then {
        removeMissionEventHandler ["Draw3D", BZN_tacvis_Display];
        BZN_tacvis_Display = -1;
    };
};

// Single source of truth: evaluates current capabilities (TacVis device,
// approved vehicle, CQC helmet, radar vehicle) and starts/stops the overlay,
// loops and actions to match. Safe to call repeatedly.
BZN_fnc_tacvis_refresh = {
    call BZN_fnc_tacvis_removeActions;

    private _hasDev   = call BZN_fnc_tacvis_hasDevice;
    private _hasCQC   = call BZN_fnc_tacvis_hasCQCDevice;
    private _veh      = objectParent player;
    private _hasRadar = (!isNull _veh) and { (typeOf _veh) in BZN_tacvis_vehicles } and { [_veh] call BZN_fnc_tacvis_vehicleHasRadar };

    // Nothing applies — tear everything down and bail.
    if (!_hasDev and !_hasCQC and !_hasRadar) exitWith { call BZN_fnc_tacvis_stopAll };

    // Any capability needs the 3D overlay running.
    call BZN_fnc_tacvis_startRender;

    // Always-on friendly IFF display: any TacVis user OR active-radar operator.
    // (Radar contacts are non-friendly only and live in a separate pool, so they
    // never replace friendlies.)
    if (_hasDev or _hasRadar) then {
        if (!BZN_tacvis_friendly_active) then {
            BZN_tacvis_friendly_active = true;
            [] spawn BZN_fnc_tacvisAlwaysOn;
        };
    } else {
        BZN_tacvis_friendly_active = false;
        BZN_tacvis_pool_friendly   = [];
    };

    // Spot action + hostile-civilian threat watch for TacVis device users.
    if (_hasDev) then {
        BZN_tacvis_spot_action = player addAction [
            "Spot Target",
            { [] spawn BZN_fnc_tacvisSpot },
            [], 1.5, false, true, "",
            "!BZN_tacvis_spot_cooldown && (cameraView == 'GUNNER')"
        ];
        if (!BZN_tacvis_threat_active) then {
            BZN_tacvis_threat_active = true;
            [] spawn BZN_fnc_tacvisThreatWatch;
        };
    } else {
        BZN_tacvis_threat_active = false;
    };

    // CQC scroll-wheel toggle.
    if (_hasCQC and !BZN_tacvis_CQC_cooldown) then {
        BZN_tacvis_CQC_action = player addAction [
            "Toggle CQC",
            { [] spawn BZN_fnc_tacvisCQC },
            [], 1.4, false, true, "", "true"
        ];
    };

    // Radar contact scan (vehicle with radar).
    if (_hasRadar) then {
        if (!BZN_tacvis_radar_active) then {
            BZN_tacvis_radar_active = true;
            [] spawn BZN_fnc_tacvisRadar;
        };
    } else {
        // Stop our own scan, but keep the shared list — it holds other operators'
        // contacts and self-expires.
        BZN_tacvis_radar_active = false;
    };
};

// -------------------------------------------------------------------------
// Initial check + event handlers (everything routes through refresh)
// -------------------------------------------------------------------------
call BZN_fnc_tacvis_refresh;

player addEventHandler ["Put", {
    params ["_unit", "_container", "_item"];
    if (_item in BZN_tacvis_devices or _item in BZN_tacvis_devices_cqc) then { call BZN_fnc_tacvis_refresh };
}];

player addEventHandler ["Take", {
    params ["_unit", "_container", "_item"];
    if (_item in BZN_tacvis_devices or _item in BZN_tacvis_devices_cqc) then { call BZN_fnc_tacvis_refresh };
}];

player addEventHandler ["InventoryClosed", { call BZN_fnc_tacvis_refresh }];
player addEventHandler ["GetInMan",        { call BZN_fnc_tacvis_refresh }];
player addEventHandler ["GetOutMan",       { call BZN_fnc_tacvis_refresh }];

if (BZN_tacvis_debug) then { systemChat "BZN TacVis - Initialized" };
