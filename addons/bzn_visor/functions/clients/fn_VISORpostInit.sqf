if (isDedicated or !local player) exitWith {};

// -------------------------------------------------------------------------
// Device / vehicle lists are CBA settings (see XEH_preInit.sqf, category
// "BZN VISOR"). CBA populates these globals in preInit, before this
// postInit runs. The defensive defaults below keep the addon inert (rather
// than erroring) if CBA is ever unavailable.
// -------------------------------------------------------------------------
if (isNil "BZN_visor_devices")          then { BZN_visor_devices = []; };
if (isNil "BZN_visor_vehicles")         then { BZN_visor_vehicles = []; };
if (isNil "BZN_visor_cluster_minDistance")     then { BZN_visor_cluster_minDistance = 100; };
if (isNil "BZN_visor_cluster_minDistance_air") then { BZN_visor_cluster_minDistance_air = 2000; };
if (isNil "BZN_visor_zeusMark_duration") then { BZN_visor_zeusMark_duration = 60; };
if (isNil "BZN_visor_squadHealth_enabled")  then { BZN_visor_squadHealth_enabled = true; };
if (isNil "BZN_visor_squadHealth_position") then { BZN_visor_squadHealth_position = "BR"; };

// User-facing display toggles (bound to keybinds below; persist across refreshes
// since they're independent of equipment-based activation).
BZN_visor_userEnabled         = true;   // master overlay on/off
BZN_visor_hideFriendlyMarkers = false;  // hide tags for friendly-side units

// Runtime flags
BZN_visor_friendly_active = false;
BZN_visor_uplink_active   = false;  // drives the persistent "slaved to drone" hint while connected
BZN_visor_air_range       = 5000;   // metres; display/IFF range for flying vehicles
BZN_visor_ground_air_range = 1500;  // metres; ground-unit display range when the observer is airborne
BZN_visor_cluster_radius      = 12;   // metres; max spacing to group same-side/type contacts into one tag
BZN_visor_cluster_threshold   = 3;    // minimum group size before collapsing to a single summary tag
BZN_visor_stagger_offset      = 0.35; // metres; vertical separation applied to small ungrouped clusters
BZN_visor_lookAt_radius       = 5.5;  // metres; constant linear "you're looking at them" tolerance around the target's centre-mass — derived into a per-target angle (radius / distance) so the trigger zone stays roughly the same physical size at 40m and at 400m, rather than ballooning outward at range like a fixed-angle cone would
BZN_visor_detailView_active   = false; // runtime: "Toggle Detail View" keybind — forces every tag to render in full
// BZN_visor_cluster_minDistance(_air) are CBA sliders (see XEH_preInit.sqf) —
// the isNil defaults above cover the case where CBA settings are unavailable.

// Render pools
BZN_visor_pool_friendly = [];   // friendlies + Zeus-marked enemies (always-on)
BZN_visor_uavOperators  = [];   // shared [uav, operatorName, expiry] — who's remotely connected to a friendly drone

// PoC squad health tracking (see fn_visorAlwaysOn.sqf) — dead units leave
// their group instantly, so a live "units group player" scan alone can't
// keep listing them as KIA on the squad health HUD (fn_visorSquadHUD.sqf).
// BZN_visor_squadRoster snapshots who was in the squad last cycle so the
// AlwaysOn loop can notice the drop-out and record the body here;
// BZN_visor_squadDead is pruned of null/deleted bodies each cycle.
BZN_visor_squadRoster = [];
BZN_visor_squadDead   = [];

// Zeus-marked enemies — persistent 3D tags; [unit, expiry, spotter] tuples,
// fed exclusively by the Zeus "Mark Enemy (VISOR)" module
// (fn_visorZeusMark.sqf), pruned on death/expiry.
BZN_visor_spotted = [];

// Hint section globals — each subsystem writes its raw HTML string here; the
// master hint loop (spawned below) combines them into one hintSilent call so
// the uplink notice and debug display don't fight over the shared hint
// display slot.
BZN_visor_hint_uplink = "";  // UAV uplink / restored notice (postInit uplink loop)
BZN_visor_hint_debug  = "";  // live spotted-list debug display (fn_visorAlwaysOn)

// Draw3D event handler ID (-1 = not running, -2 = being initialised)
BZN_visor_Display = -1;

// -------------------------------------------------------------------------
// Helpers (stored as global vars so event handlers can call them)
// -------------------------------------------------------------------------

BZN_fnc_visor_inApprovedVehicle = {
    private _veh = objectParent player;
    (!isNull _veh) and { (typeOf _veh) in BZN_visor_vehicles }
};

BZN_fnc_visor_hasDevice = {
    headgear player in BZN_visor_devices
    or goggles player in BZN_visor_devices
    or (call BZN_fnc_visor_inApprovedVehicle)
};

// PoC squad health readout — classifies a squadmate for the render engine.
// Returns 0 healthy / 1 damaged / 2 critical / 3 dead. Reads ACE medical's
// unit variables directly when ace_medical is loaded (cheap, no function
// calls per frame); lifeState/damage keep it meaningful in a vanilla fallback.
BZN_fnc_visor_squadHealthState = {
    params ["_u"];
    if (!alive _u) exitWith { 3 };
    if (
        _u getVariable ["ACE_isUnconscious", false]
        or { _u getVariable ["ace_medical_inCardiacArrest", false] }
        or { lifeState _u == "INCAPACITATED" }
    ) exitWith { 2 };
    if (
        (_u getVariable ["ace_medical_woundBleeding", 0]) > 0
        or { (_u getVariable ["ace_medical_pain", 0]) > 0.2 }
        or { damage _u > 0.2 }
    ) exitWith { 1 };
    0
};

BZN_fnc_visor_startRender = {
    if (BZN_visor_Display == -1) then {
        BZN_visor_Display = -2; // sentinel: init in progress
        [] spawn BZN_fnc_visorRenderEngine;
    };
};

BZN_fnc_visor_stopAll = {
    BZN_visor_friendly_active = false;
    BZN_visor_pool_friendly   = [];
    if (BZN_visor_Display >= 0) then {
        removeMissionEventHandler ["Draw3D", BZN_visor_Display];
        BZN_visor_Display = -1;
    };
};

// Single source of truth: evaluates current capabilities (VISOR device or
// approved vehicle) and starts/stops the overlay + friendly-scan loop to
// match. Safe to call repeatedly.
BZN_fnc_visor_refresh = {
    private _hasDev = call BZN_fnc_visor_hasDevice;

    // Nothing applies — tear everything down and bail.
    if (!_hasDev) exitWith { call BZN_fnc_visor_stopAll };

    // Any capability needs the 3D overlay running.
    call BZN_fnc_visor_startRender;

    // Always-on friendly IFF display.
    if (!BZN_visor_friendly_active) then {
        BZN_visor_friendly_active = true;
        [] spawn BZN_fnc_visorAlwaysOn;
    };
};

// UAV terminal connect/disconnect doesn't fire ANY of the event handlers below
// (Put/Take/InventoryClosed/GetInMan/GetOutMan all stay silent across that
// transition). The action registry can go stale across that transition with
// nothing to re-evaluate it. Poll the connection and force a refresh exactly
// when it changes.
[] spawn {
    // Track CONNECTION STATE (isNull), not the object reference itself —
    // getConnectedUAV apparently hands back a fresh "invalid" object handle
    // on every call while disconnected. All such handles report isNull true
    // and print as <NULL-object>, but they are NOT guaranteed to compare ==
    // equal to each other (deleted/invalid object handles retain distinct
    // identities). Comparing _uav != _lastUAV directly therefore evaluated
    // "changed" on nearly every single poll even though the player never
    // connected to anything — silently forcing BZN_fnc_visor_refresh roughly
    // once a second. Track isConnected instead.
    private _wasConnected = false;
    while { true } do {
        private _uav = getConnectedUAV player;
        private _isConnected = !isNull _uav;
        if (_isConnected != _wasConnected) then {
            // Tracking is derived from wherever the camera/sensor actually
            // is (see fn_visorAlwaysOn's friendly-scan origin) — while
            // connected to a drone, that's the DRONE's feed, not the
            // operator's body sitting at the terminal. Surface that clearly
            // (top-right hint) so players don't wonder why looking around
            // with their own eyes doesn't affect the drone's view.
            if (_isConnected) then {
                // hintSilent is a shared display slot — a single call gets
                // clobbered by the next unrelated hint. Keep this notice
                // genuinely "always on" for the whole connection by
                // re-asserting it once a second for as long as the player
                // stays connected.
                BZN_visor_uplink_active = true;
                [] spawn {
                    while { BZN_visor_uplink_active } do {
                        private _uavNow = getConnectedUAV player;
                        if (isNull _uavNow) exitWith {};

                        BZN_visor_hint_uplink =
                            "<t size='1.3' color='#30a0ff'>VISOR UPLINK</t><br/><t size='1.1'>Slaved to drone feed — tracking now follows the drone's view, not your own</t>";

                        // No native "who is connected to this UAV" query
                        // exists (getConnectedUAV only works operator ->
                        // drone), so the operator announces themselves to
                        // the team once a second; fn_visorRenderEngine
                        // displays it on the drone's friendly tag. Short
                        // expiry (vs. the 1 s cadence) means a disconnect
                        // clears it on its own within a couple seconds — no
                        // explicit teardown needed.
                        //
                        // remoteExec target 0 does not reliably loop back to
                        // the calling machine on non-host clients — call
                        // locally too so the operator's own view of who's
                        // flying stays consistent with what they just told
                        // the team, same as everyone else's.
                        private _uavOpExpiry = time + 3;
                        [_uavNow, name player, _uavOpExpiry] call BZN_fnc_visorRefreshUAVOperator;
                        [_uavNow, name player, _uavOpExpiry] remoteExec ["BZN_fnc_visorRefreshUAVOperator", 0];

                        sleep 1;
                    };
                };
            } else {
                BZN_visor_uplink_active = false;
                BZN_visor_hint_uplink =
                    "<t size='1.3' color='#30ff30'>VISOR UPLINK</t><br/><t size='1.1'>Restored to personal view</t>";
                [] spawn { sleep 5; BZN_visor_hint_uplink = "" };
            };

            _wasConnected = _isConnected;
            call BZN_fnc_visor_refresh;
        };
        sleep 1;
    };
};

// -------------------------------------------------------------------------
// Initial check + event handlers (everything routes through refresh)
// -------------------------------------------------------------------------
call BZN_fnc_visor_refresh;

// Fixed screen-space squad health HUD (PoC) — its own self-managing loop
// (see fn_visorSquadHUD.sqf): visibility is gated internally on the Addon
// Option + VISOR being active, so it's started unconditionally here rather
// than routed through refresh like the equipment-gated systems above.
[] spawn BZN_fnc_visorSquadHUD;

player addEventHandler ["Put", {
    params ["_unit", "_container", "_item"];
    if (_item in BZN_visor_devices) then { call BZN_fnc_visor_refresh };
}];

player addEventHandler ["Take", {
    params ["_unit", "_container", "_item"];
    if (_item in BZN_visor_devices) then { call BZN_fnc_visor_refresh };
}];

player addEventHandler ["InventoryClosed", { call BZN_fnc_visor_refresh }];
player addEventHandler ["GetInMan",        { call BZN_fnc_visor_refresh }];
player addEventHandler ["GetOutMan",       { call BZN_fnc_visor_refresh }];

// -------------------------------------------------------------------------
// Keybinds — user-facing display toggles. CBA_fnc_addKeybind both registers
// and updates, so re-running this on every mission start (postInit) is safe.
// DIK codes given as raw scan-code numbers (defineDIKCodes.inc is a game-VFS
// path HEMTT's static checker can't resolve): F8 = 0x42 (66), F9 = 0x43 (67).
// -------------------------------------------------------------------------
["BZN VISOR", "BZN_visor_toggleDisplay",
    ["Toggle VISOR Display", "Turns the entire BZN VISOR 3D overlay on/off"],
    {
        BZN_visor_userEnabled = !BZN_visor_userEnabled;
        cutText [format ["VISOR display: %1", ["OFF", "ON"] select BZN_visor_userEnabled], "PLAIN DOWN", 0.5, false];
        true
    },
    { false },
    [66, [false, true, false]] // ALT+F8
] call CBA_fnc_addKeybind;

["BZN VISOR", "BZN_visor_toggleDetailView",
    ["Toggle Detail View", "Overrides the close-range 'looked at' tag gating — while active, every infantry tag always renders in full (distance, type, status, ARMED/HOSTILE/INJURED), not just whichever one you're looking at."],
    {
        BZN_visor_detailView_active = !BZN_visor_detailView_active;
        cutText [format ["VISOR detail view: %1", ["OFF", "ON"] select BZN_visor_detailView_active], "PLAIN DOWN", 0.5, false];
        true
    },
    { false }
] call CBA_fnc_addKeybind;

["BZN VISOR", "BZN_visor_toggleFriendlyMarkers",
    ["Toggle Friendly Markers", "Hides/shows BZN VISOR tags for friendly-side units only"],
    {
        BZN_visor_hideFriendlyMarkers = !BZN_visor_hideFriendlyMarkers;
        cutText [format ["VISOR friendly markers: %1", ["SHOWN", "HIDDEN"] select BZN_visor_hideFriendlyMarkers], "PLAIN DOWN", 0.5, false];
        true
    },
    { false },
    [67, [false, true, false]] // ALT+F9
] call CBA_fnc_addKeybind;

// -------------------------------------------------------------------------
// Master hint aggregator — single hintSilent call per frame combining the
// UAV uplink notice and debug display so subsystems don't fight over the
// shared display slot. Each subsystem writes its raw HTML to its hint_*
// global; this loop combines and renders them. Only calls hintSilent when
// content changes.
// -------------------------------------------------------------------------
[] spawn {
    private _wasShowing = false;
    while { alive player } do {
        private _sections = [];
        if (BZN_visor_hint_uplink != "") then { _sections pushBack BZN_visor_hint_uplink };
        if (BZN_visor_hint_debug  != "") then { _sections pushBack BZN_visor_hint_debug };
        if (_sections isNotEqualTo []) then {
            hintSilent parseText (_sections joinString "<br/>");
            _wasShowing = true;
        } else {
            if (_wasShowing) then { hintSilent ""; _wasShowing = false; };
        };
        sleep 0.25;
    };
};

if (!isNil "BZN_visor_debug" and { BZN_visor_debug }) then { systemChat "BZN VISOR - Initialized" };
