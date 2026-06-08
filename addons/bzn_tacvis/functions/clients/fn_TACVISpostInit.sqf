if (isDedicated or !local player) exitWith {};

BZN_tacvis_debug = true;

// -------------------------------------------------------------------------
// Device / CQC / vehicle lists are CBA settings (see config/cba_settings.hpp,
// category "BZN TacVis"). CBA populates these globals in preInit, before this
// postInit runs. The defensive defaults below keep the addon inert (rather
// than erroring) if CBA is ever unavailable.
// -------------------------------------------------------------------------
if (isNil "BZN_tacvis_devices")          then { BZN_tacvis_devices = []; };
if (isNil "BZN_tacvis_devices_cqc")      then { BZN_tacvis_devices_cqc = []; };
if (isNil "BZN_tacvis_vehicles")         then { BZN_tacvis_vehicles = []; };
if (isNil "BZN_tacvis_spot_showAction")  then { BZN_tacvis_spot_showAction = true; };

// User-facing display toggles (bound to keybinds below; persist across refreshes
// since they're independent of equipment-based activation).
BZN_tacvis_userEnabled         = true;   // master overlay on/off
BZN_tacvis_hideFriendlyMarkers = false;  // hide tags for friendly-side units

// Runtime flags
BZN_tacvis_friendly_active = false;
BZN_tacvis_CQC_active      = false;
BZN_tacvis_CQC_cooldown    = false;
BZN_tacvis_spot_cooldown   = false;
BZN_tacvis_marker_cooldown = false;
BZN_tacvis_radar_active    = false;
BZN_tacvis_threat_active   = false;
BZN_tacvis_uplink_active   = false;  // drives the persistent "slaved to drone" hint while connected
BZN_tacvis_radar_range     = 6000;   // metres; radar contact scan radius
BZN_tacvis_air_range       = 5000;   // metres; display/IFF range for flying vehicles
BZN_tacvis_ground_air_range = 1500;  // metres; ground-unit display range when the observer is airborne
BZN_tacvis_spot_duration   = 35;     // seconds; how long a "SPOTTED" tag persists without refresh

// Render pools
BZN_tacvis_pool_friendly = [];   // friendlies + spotted enemies (always-on)
BZN_tacvis_pool_CQC      = [];   // nearby enemies (CQC mode only)
BZN_tacvis_radar         = [];   // shared [unit, expiry] radar contacts (from any operator)
BZN_tacvis_threat        = [];   // local [unit, expiry] hostile-civilian alarm markers
BZN_tacvis_uavOperators  = [];   // shared [uav, operatorName, expiry] — who's remotely connected to a friendly drone

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

// True while the player has a valid aim reference to actually spot through —
// an optic/binos on foot, a turret/gunner seat, or a connected UAV feed.
// cameraView == "GUNNER" is the documented BIS signal for "actively
// zoomed/aiming through optics (RMB)" and covers foot + turret seats alike;
// drones get an unconditional pass since the feed IS the operator's viewpoint
// the instant they connect (no separate "raise the sight" state to check).
//
// This is ONLY consulted by fn_tacvisSpot.sqf at the moment of use — NOT used
// to gate the scroll-menu entry's visibility (that stays always-on, cooldown/
// showAction permitting). cameraView genuinely oscillates GUNNER<->INTERNAL
// for ~0.5-0.8s mid-aim in certain turret sights; a per-frame addAction
// condition built on it flickered the entry on/off in lockstep, and there's no
// debounce window that fixes an oscillating signal without trading flicker for
// sluggishness. A one-shot check at execution time has no such problem — it
// either reads true or false for that single button-press, and a stray false
// reading just produces the "Aim through optics to spot" feedback once.
BZN_fnc_tacvis_canSpot = {
    if (!isNull (getConnectedUAV player)) exitWith { true };
    cameraView == "GUNNER"
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
    // The scroll-menu entry is opt-out (BZN_tacvis_spot_showAction CBA checkbox)
    // — it's unreachable while piloting a UAV through a terminal (self-action
    // menus can't render against a redirected camera/controls), so the universal
    // BZN_tacvis_spotTarget keybind below exists as the always-reachable path;
    // some users may prefer to hide the redundant menu entry entirely.
    //
    // Visibility is gated on cooldown ONLY — deliberately NOT on canSpot
    // (the "are you aiming?" check). cameraView == "GUNNER" genuinely
    // oscillates GUNNER<->INTERNAL for ~0.5-0.8s mid-aim in certain turret
    // sights, and a per-frame addAction condition built on it flickered the
    // entry on/off in lockstep — no debounce window "fixes" an oscillating
    // signal without trading flicker for sluggishness. The aim requirement is
    // still fully enforced — fn_tacvisSpot.sqf checks canSpot at the moment of
    // use and shows "Aim through optics to spot" if you're not actually
    // sighted in — it's just a one-shot check there, not a per-frame gate, so
    // a stray oscillation can't cause visible flicker.
    if (_hasDev) then {
        if (BZN_tacvis_spot_showAction) then {
            BZN_tacvis_spot_action = player addAction [
                "Spot Target",
                { [] spawn BZN_fnc_tacvisSpot },
                [], 1.5, false, true, "",
                "!BZN_tacvis_spot_cooldown"
            ];
        };
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

// UAV terminal connect/disconnect doesn't fire ANY of the event handlers below
// (Put/Take/InventoryClosed/GetInMan/GetOutMan all stay silent across that
// transition — confirmed: hasDevice was satisfied on the ground beforehand, yet
// "Spot Target" never appeared while piloting). The action registry can go
// stale across that transition with nothing to re-evaluate it. Poll the
// connection and force a refresh exactly when it changes.
[] spawn {
    // Track CONNECTION STATE (isNull), not the object reference itself —
    // getConnectedUAV apparently hands back a fresh "invalid" object handle
    // on every call while disconnected. All such handles report isNull true
    // and print as <NULL-object>, but they are NOT guaranteed to compare ==
    // equal to each other (deleted/invalid object handles retain distinct
    // identities). Comparing _uav != _lastUAV directly therefore evaluated
    // "changed" on nearly every single poll even though the player never
    // connected to anything — silently forcing BZN_fnc_tacvis_refresh (and
    // its remove/re-add of the Spot Target action) roughly once a second,
    // which is what was actually causing the persistent menu-entry flicker
    // (confirmed via RPT: refresh firing in lockstep with this loop's 1 s
    // cadence, action ID incrementing every time, regardless of cameraView).
    private _wasConnected = false;
    while { true } do {
        private _uav = getConnectedUAV player;
        private _isConnected = !isNull _uav;
        if (_isConnected != _wasConnected) then {
            // Spotting/tracking is derived from wherever the camera/sensor
            // actually is (see fn_tacvisSpot / fn_tacvisAlwaysOn's _originPos
            // derivation) — while connected to a drone, that's the DRONE's
            // feed, not the operator's body sitting at the terminal. Surface
            // that clearly (top-right hint, matching fn_tacvisCQC's styling/
            // placement) so players don't wonder why looking around with their
            // own eyes isn't refreshing/generating spots while piloting.
            if (_isConnected) then {
                // hintSilent is a shared display slot — a single call gets
                // clobbered by the next unrelated hint (CQC's per-second
                // countdown, vanilla system hints, etc.). Keep this notice
                // genuinely "always on" for the whole connection by re-asserting
                // it once a second for as long as the player stays connected.
                BZN_tacvis_uplink_active = true;
                [] spawn {
                    while { BZN_tacvis_uplink_active } do {
                        private _uavNow = getConnectedUAV player;
                        if (isNull _uavNow) exitWith {};

                        hintSilent parseText
                            "<t size='1.3' color='#30a0ff'>TACVIS UPLINK</t><br/><t size='1.1'>Slaved to drone feed — tracking now follows the drone's view, not your own</t>";

                        // No native "who is connected to this UAV" query exists
                        // (getConnectedUAV only works operator -> drone), so the
                        // operator announces themselves to the team once a
                        // second; fn_tacvisRenderEngine displays it on the
                        // drone's friendly tag. Short expiry (vs. the 1 s
                        // cadence) means a disconnect clears it on its own
                        // within a couple seconds — no explicit teardown needed.
                        [_uavNow, name player, time + 3] remoteExec ["BZN_fnc_tacvisRefreshUAVOperator", 0];

                        sleep 1;
                    };
                };
            } else {
                BZN_tacvis_uplink_active = false;
                hintSilent parseText
                    "<t size='1.3' color='#30ff30'>TACVIS UPLINK</t><br/><t size='1.1'>Restored to personal view</t>";
                [] spawn { sleep 5; hintSilent "" };
            };

            _wasConnected = _isConnected;
            call BZN_fnc_tacvis_refresh;
        };
        sleep 1;
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

// -------------------------------------------------------------------------
// Keybinds — user-facing display toggles. CBA_fnc_addKeybind both registers
// and updates, so re-running this on every mission start (postInit) is safe.
// DIK codes given as raw scan-code numbers (defineDIKCodes.inc is a game-VFS
// path HEMTT's static checker can't resolve): F8 = 0x42 (66), F9 = 0x43 (67).
// -------------------------------------------------------------------------
["BZN TacVis", "BZN_tacvis_toggleDisplay",
    ["Toggle TacVis Display", "Turns the entire BZN TacVis 3D overlay on/off"],
    {
        BZN_tacvis_userEnabled = !BZN_tacvis_userEnabled;
        cutText [format ["TacVis display: %1", ["OFF", "ON"] select BZN_tacvis_userEnabled], "PLAIN DOWN", 0.5, false];
        true
    },
    { false },
    [66, [false, true, false]] // ALT+F8
] call CBA_fnc_addKeybind;

["BZN TacVis", "BZN_tacvis_toggleFriendlyMarkers",
    ["Toggle Friendly Markers", "Hides/shows BZN TacVis tags for friendly-side units only"],
    {
        BZN_tacvis_hideFriendlyMarkers = !BZN_tacvis_hideFriendlyMarkers;
        cutText [format ["TacVis friendly markers: %1", ["SHOWN", "HIDDEN"] select BZN_tacvis_hideFriendlyMarkers], "PLAIN DOWN", 0.5, false];
        true
    },
    { false },
    [67, [false, true, false]] // ALT+F9
] call CBA_fnc_addKeybind;

// Universal spot trigger — fires BZN_fnc_tacvisSpot directly, bypassing the
// scroll-wheel self-action menu entirely. The menu entry has proven unreachable
// while remotely piloting a UAV through a terminal (camera/controls redirected
// away from the player's own character), so this is the only path that reliably
// works there; it doubles as a faster trigger on foot/in vehicles too. No
// default key — both ALT+F8/F9 are taken by the toggles above and a
// combat-usable spot key shouldn't be guessed; bind it via Controls > Addons.
["BZN TacVis", "BZN_tacvis_spotTarget",
    ["Spot Target", "Marks the hostile under your reticle/feed for your team. Works on foot, in vehicle turrets, and while piloting UAVs — anywhere the scroll-wheel menu option might not be reachable."],
    {
        if (BZN_tacvis_spot_cooldown) exitWith { false };
        if !(call BZN_fnc_tacvis_hasDevice) exitWith { false };
        [] spawn BZN_fnc_tacvisSpot;
        true
    },
    { false }
] call CBA_fnc_addKeybind;

if (BZN_tacvis_debug) then { systemChat "BZN TacVis - Initialized" };
