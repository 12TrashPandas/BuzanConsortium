if (isDedicated or !local player) exitWith {};

// -------------------------------------------------------------------------
// Device / vehicle lists are CBA settings (see XEH_preInit.sqf, category
// "BZN VISOR"). CBA populates these globals in preInit, before this
// postInit runs. The defensive defaults below keep the addon inert (rather
// than erroring) if CBA is ever unavailable.
// -------------------------------------------------------------------------
if (isNil "BZN_visor_devices")          then { BZN_visor_devices = []; };
if (isNil "BZN_visor_vehicles")         then { BZN_visor_vehicles = []; };
if (isNil "BZN_visor_squadHealth_panel")    then { BZN_visor_squadHealth_panel = true; };
if (isNil "BZN_visor_squadHealth_position") then { BZN_visor_squadHealth_position = "BR"; };
if (isNil "BZN_visor_squadHealth_dui")      then { BZN_visor_squadHealth_dui = true; };
if (isNil "BZN_visor_fade_infantry")        then { BZN_visor_fade_infantry = 1000; };
if (isNil "BZN_visor_fade_vehicle")         then { BZN_visor_fade_vehicle = 5000; };
if (isNil "BZN_visor_scale_range")          then { BZN_visor_scale_range = 5000; };
if (isNil "BZN_visor_scale_min")            then { BZN_visor_scale_min = 0.5; };

// User-facing display toggles (bound to keybinds below; persist across refreshes
// since they're independent of equipment-based activation).
BZN_visor_userEnabled         = true;   // master overlay on/off
BZN_visor_hideFriendlyMarkers = false;  // hide tags for friendly-side units

// Runtime flags
BZN_visor_friendly_active = false;
BZN_visor_uplink_active   = false;  // drives the persistent "slaved to drone" hint while connected
BZN_visor_detailView_active   = true;  // runtime: "Toggle Detail Mode" keybind — ON (default) renders the designator text; OFF strips every tag down to its bare hexagon

// Render pools
BZN_visor_pool_friendly = [];   // friendlies + Zeus-marked enemies (always-on)
BZN_visor_uavOperators  = [];   // shared [uav, operatorName, expiry] — who's remotely connected to a friendly drone

// PoC squad health tracking (see fn_visorAlwaysOn.sqf) — dead units leave
// their group instantly, so a live "units group player" scan alone can't
// keep listing them as KIA on the squad health HUD (fn_visorSquadHUD.sqf).
// BZN_visor_squadRoster snapshots who was in the squad last cycle so the
// AlwaysOn loop can notice the drop-out and record the body in
// BZN_visor_squadDead as [body, expiry]. A KIA line lingers for
// BZN_visor_squadDead_duration seconds, then ages out so it doesn't sit in
// the readout forever (also cleans up a body the engine deletes).
BZN_visor_squadRoster       = [];
BZN_visor_squadDead         = [];
BZN_visor_squadDead_duration = 60;  // seconds a KIA squadmate stays listed

// Zeus-marked targets — persistent 3D tags; [unit, expiry, spotter, lines]
// tuples fed exclusively by the Zeus "Mark Target (VISOR)" module
// (fn_visorZeusMark.sqf). expiry -1 = untimed (mark holds until the target
// dies); lines = up to three [text, colourIndex] context rows configured in
// the module's dialog. Pruned on death/expiry.
BZN_visor_spotted = [];

// Hint section global — the master hint loop (spawned below) renders this via
// hintSilent. Kept as a write-then-render slot (rather than hinting inline)
// so any future subsystem hints can join the aggregator without fighting over
// the shared hint display.
BZN_visor_hint_uplink = "";  // UAV uplink / restored notice (postInit uplink loop)

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

// True only when the player is PERSONALLY wearing a VISOR device (a
// whitelisted helmet or goggles) — deliberately excludes the approved-vehicle
// path. Zeus target marks are gated on this: an approved vehicle grants the
// friendly IFF picture, but actually seeing the marked-target feed takes the
// kit on your own head, so every user needs the equipment to read marks.
BZN_fnc_visor_hasPersonalDevice = {
    headgear player in BZN_visor_devices
    or { goggles player in BZN_visor_devices }
};

// True when a given UNIT carries VISOR — used to gate friendly IFF so only
// equipped friendlies transmit their identity/position (an unequipped
// teammate is invisible on the display, same "you need the kit" rule that
// applies to everyone). Infantry: a whitelisted helmet or goggles. Vehicles:
// an approved (whitelisted) type, or any crew member personally equipped.
// VIP/HVT-flagged units and Zeus-marked targets bypass this in the render
// filter — they're deliberately always shown regardless of gear.
BZN_fnc_visor_unitHasDevice = {
    params ["_u"];
    if (_u isKindOf "CAManbase") exitWith {
        headgear _u in BZN_visor_devices or { goggles _u in BZN_visor_devices }
    };
    (typeOf _u in BZN_visor_vehicles)
    or { (crew _u) findIf { headgear _x in BZN_visor_devices or { goggles _x in BZN_visor_devices } } >= 0 }
};

// Removes our DUI status suffix from a unit AND repairs DUI's nametag cache.
// DUI's namelist re-reads diwako_dui_main_customName each refresh (so clearing
// it fixes the list), but its 3D-nametag cache loop SKIPS dead units, leaving
// the corpse's nametag frozen at our last suffixed value ("- OK"/"- WND").
// So we also overwrite DUI's cached nametag string (diwako_dui_nametags_name)
// directly with the clean name — DUI won't touch it again on a dead unit, so
// it sticks. Both plural/singular spellings are set to stay robust across DUI
// versions; writing an unused variable is harmless.
BZN_fnc_visor_duiClear = {
    params ["_u"];
    if (isNull _u) exitWith {};
    private _clean = _u getVariable ["ACE_Name", name _u];
    _u setVariable ["diwako_dui_main_customName", nil];
    _u setVariable ["diwako_dui_nametags_name", _clean];
    _u setVariable ["diwako_dui_nametag_name", _clean];
    _u setVariable ["BZN_visor_dui_owned", nil];
};

// (BZN_fnc_visor_squadHealthState — the shared 0/1/2/3 classifier — is
// defined in XEH_preInit.sqf so it also exists on the dedicated server for
// its own health broadcast; see fn_visorServerHealth.)

// Display-side resolver — the value teammates should SEE (used by the squad
// HUD / DUI feed). ACE medical variables are managed on the machine where a
// unit is local and aren't all network-broadcast, so reading them directly
// for a REMOTE teammate returns stale/default data — the root cause of the
// squad medical readout drifting out of sync. Death is universally known via
// `alive`; a locally-owned unit is computed live; a remote unit reads the
// value its owner publishes on the broadcast loop below (see the "Squad
// health broadcast" spawn), falling back to a live read until the first
// publish lands.
BZN_fnc_visor_squadHealthDisplay = {
    params ["_u"];
    if (!alive _u) exitWith { 3 };
    if (local _u) exitWith { [_u] call BZN_fnc_visor_squadHealthState };
    _u getVariable ["BZN_visor_healthState", [_u] call BZN_fnc_visor_squadHealthState]
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
// transition), so nothing would re-evaluate capabilities or raise the uplink
// notice. Poll the connection and force a refresh exactly when it changes.
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

// DUI-integration safety: the instant a unit we've suffixed dies, clear our
// status and repair DUI's frozen nametag cache (see BZN_fnc_visor_duiClear).
// This is the backstop for an INSTANT kill — a unit killed while still "up"
// (e.g. a headshot at "- OK") never passes through the down-state clear in the
// HUD loop, so DUI's cache loop would otherwise freeze "- OK" on the corpse's
// 3D nametag. We only touch units WE suffixed (BZN_visor_dui_owned), so a
// mission's own DUI custom names are never clobbered. Local only.
addMissionEventHandler ["EntityKilled", {
    params ["_killed"];
    if (!isNull _killed and { _killed getVariable ["BZN_visor_dui_owned", false] }) then {
        [_killed] call BZN_fnc_visor_duiClear;
    };
}];

// -------------------------------------------------------------------------
// Squad health broadcast — publish the health state of every unit THIS
// machine owns (the local player, plus any AI they lead) as a public
// variable, so teammates read a consistent value instead of the stale ACE
// medical variables a remote client would otherwise see (see
// BZN_fnc_visor_squadHealthDisplay). Polls every 2 s so a state change
// (someone starts bleeding, arrests, or recovers) propagates within a couple
// seconds, with a 10 s keepalive rebroadcast so a freshly-connected or
// resynced client fills in even when nothing has changed.
// -------------------------------------------------------------------------
[] spawn {
    private _nextKeepalive = 0;
    while { true } do {
        private _keepalive = time >= _nextKeepalive;
        if (_keepalive) then { _nextKeepalive = time + 10 };
        {
            if (local _x and { alive _x }) then {
                private _state = [_x] call BZN_fnc_visor_squadHealthState;
                // Last broadcast value stashed locally on the unit (not
                // public) so we only re-broadcast on an actual change or the
                // periodic keepalive — a bare setVariablePublic every cycle
                // would be needless network chatter.
                if (_keepalive or { (_x getVariable ["BZN_visor_healthState_last", -1]) != _state }) then {
                    _x setVariable ["BZN_visor_healthState", _state, true];
                    _x setVariable ["BZN_visor_healthState_last", _state];
                };
            };
        } forEach (units group player);
        sleep 2;
    };
};

// -------------------------------------------------------------------------
// Fire Team Lead designation — a toggle entry in ACE's Team Management menu
// (the same place team colours are assigned, which DUI reads). Sets the
// broadcast BZN_visor_FTL variable the render engine's role-suffix chain
// consumes (" - FTL", second priority behind SQL). Registered on both the
// interaction (point at a teammate) and self-interaction menus; the class
// action is added with inheritance so every CAManbase descendant gets it.
// Skipped gracefully when ACE's interact menu isn't loaded.
// -------------------------------------------------------------------------
if (!isNil "ace_interact_menu_fnc_createAction") then {
    private _ftlAction = [
        "BZN_visor_toggleFTL",
        "Designate Fire Team Lead",
        "",
        {
            params ["_target"];
            private _new = !(_target getVariable ["BZN_visor_FTL", false]);
            // Public broadcast — every client's VISOR renders the suffix.
            _target setVariable ["BZN_visor_FTL", _new, true];
            hint format ["%1 is %2 Fire Team Lead", name _target, ["no longer", "now"] select _new];
        },
        {
            params ["_target"];
            alive _target and { _target isKindOf "CAManbase" }
        }
    ] call ace_interact_menu_fnc_createAction;

    ["CAManbase", 0, ["ACE_MainActions", "ACE_TeamManagement"], _ftlAction, true] call ace_interact_menu_fnc_addActionToClass;
    ["CAManbase", 1, ["ACE_SelfActions", "ACE_TeamManagement"], _ftlAction, true] call ace_interact_menu_fnc_addActionToClass;
};

// Zeus "Mark Target (VISOR)" module — placement is caught HERE, client-side,
// via CuratorObjectPlaced (which fires on the placing curator's own machine,
// the only place the configuration dialog can actually open — the module's
// server-side function path can't do UI, so the module class declares no
// function at all). Curator rights can be granted/revoked mid-mission
// (#adminLogged Zeus, mission scripting), so poll for the assigned curator
// logic and hook it whenever it appears/changes.
[] spawn {
    private _hooked = objNull;
    while { true } do {
        private _cur = getAssignedCuratorLogic player;
        if (!isNull _cur and { _cur != _hooked }) then {
            _cur addEventHandler ["CuratorObjectPlaced", {
                params ["", "_obj"];
                if (typeOf _obj == "bzn_visor_moduleZeusMark") then {
                    [_obj] spawn BZN_fnc_visorZeusMark;
                };
            }];
            _hooked = _cur;
        };
        sleep 5;
    };
};

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
    ["Toggle Detail Mode", "ON (default): tags render their designator text — type line, names, and role suffixes. OFF: every tag strips down to just its IFF hexagon, no text at all."],
    {
        BZN_visor_detailView_active = !BZN_visor_detailView_active;
        cutText [format ["VISOR detail mode: %1", ["OFF", "ON"] select BZN_visor_detailView_active], "PLAIN DOWN", 0.5, false];
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
// Master hint aggregator — renders the hint_* globals via a single hintSilent
// call so future subsystem hints can share the slot without fighting over it
// (currently only the UAV uplink notice writes one). Only calls hintSilent
// when there's content, and clears exactly once when the last section empties.
// -------------------------------------------------------------------------
[] spawn {
    private _wasShowing = false;
    while { alive player } do {
        private _sections = [];
        if (BZN_visor_hint_uplink != "") then { _sections pushBack BZN_visor_hint_uplink };
        if (_sections isNotEqualTo []) then {
            hintSilent parseText (_sections joinString "<br/>");
            _wasShowing = true;
        } else {
            if (_wasShowing) then { hintSilent ""; _wasShowing = false; };
        };
        sleep 0.25;
    };
};
