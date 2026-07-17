// CBA Addon Options registered via CBA Extended_PreInit (runs in missions AND the
// Eden editor), so the settings appear in Addon Options in both contexts. EDITBOX
// values are strings; the callback parses the array literal into the runtime
// global and refreshes the action set. isGlobal = 1 enables server/mission override.
if (isNil "CBA_settings_fnc_init") exitWith {
    diag_log "[BZN VISOR] CBA settings unavailable - settings not registered.";
};

private _defaultDevices  = [];
private _defaultVehicles = [];

[
    "BZN_visor_devices_str", "EDITBOX",
    ["Devices (always-on)", "Array literal of helmet and goggle classnames that grant the always-on friendly display."],
    "BZN VISOR",
    str _defaultDevices,
    1,
    { params ["_value"]; BZN_visor_devices = parseSimpleArray _value; if (!isNil "BZN_fnc_visor_refresh") then { call BZN_fnc_visor_refresh }; }
] call CBA_settings_fnc_init;

[
    "BZN_visor_vehicles_str", "EDITBOX",
    ["Approved vehicles", "Array literal of vehicle classnames that grant the always-on display while mounted, regardless of headgear."],
    "BZN VISOR",
    str _defaultVehicles,
    1,
    { params ["_value"]; BZN_visor_vehicles = parseSimpleArray _value; if (!isNil "BZN_fnc_visor_refresh") then { call BZN_fnc_visor_refresh }; }
] call CBA_settings_fnc_init;

[
    "BZN_visor_zeusMark_duration", "SLIDER",
    ["Zeus mark duration (s)", "How long a unit marked via the Zeus 'Mark Enemy (VISOR)' module stays tagged 'MARKED' on everyone's VISOR display before the mark expires."],
    "BZN VISOR",
    [10, 600, 60, 0],
    1, // server-forced — a Zeus-placed mark's lifetime should be consistent for the whole team
    { params ["_value"]; BZN_visor_zeusMark_duration = _value; }
] call CBA_settings_fnc_init;

[
    "BZN_visor_squadHealth_enabled", "CHECKBOX",
    ["Squad health indicator (PoC)", "Shows a fixed on-screen squad roster panel with a colour-coded health state per member: green healthy, yellow wounded, red critical, grey KIA (ACE medical-driven). A separate UI element in a corner of your screen — the 3D IFF tags are unaffected. Personal display preference."],
    "BZN VISOR",
    true,
    0, // personal display preference, like the clustering sliders below — never server-forced
    { params ["_value"]; BZN_visor_squadHealth_enabled = _value; }
] call CBA_settings_fnc_init;

[
    "BZN_visor_squadHealth_position", "LIST",
    ["Squad health indicator position", "Which screen corner the squad health panel sits in. Top right can momentarily overlap VISOR hint notifications (drone uplink notice, debug display) — pick another corner if you use those."],
    "BZN VISOR",
    [["BL", "BR", "TL", "TR"], ["Bottom left", "Bottom right", "Top left", "Top right"], 1],
    0, // personal display preference, same rationale as the checkbox above
    { params ["_value"]; BZN_visor_squadHealth_position = _value; }
] call CBA_settings_fnc_init;

[
    "BZN_visor_cluster_minDistance", "SLIDER",
    ["Tag clustering range (m)", "How far away nearby same-side contacts need to be from you before their tags collapse into a single grouped summary instead of rendering individually. Applies on foot and in ground vehicles. Lower it to declutter sooner; raise it (or max it out) to always see every contact's full tag."],
    "BZN VISOR",
    [0, 500, 100, 0],
    0, // purely a personal display/declutter preference — doesn't affect gameplay balance, so it's a local per-player choice like the scroll-menu toggle above
    { params ["_value"]; BZN_visor_cluster_minDistance = _value; }
] call CBA_settings_fnc_init;

[
    "BZN_visor_cluster_minDistance_air", "SLIDER",
    ["Tag clustering range, air/drone (m)", "Same as 'Tag clustering range', but used instead whenever you're aircrew or slaved to a UAV/UGV feed — looking down from altitude bunches contacts together on screen at much greater distances, so this defaults much higher (2 km) than the ground-level range."],
    "BZN VISOR",
    [0, 5000, 2000, 0],
    0, // same rationale as the ground-level slider above — personal display preference, not balance
    { params ["_value"]; BZN_visor_cluster_minDistance_air = _value; }
] call CBA_settings_fnc_init;

[
    "BZN_visor_debug", "CHECKBOX",
    ["Debug mode", "Shows a live spotted-list hint (expiry values per target) and logs each AddSpot/RefreshSpot call to RPT. Enable on one client to diagnose timer or sharing anomalies. Personal/local only — does not affect other players."],
    "BZN VISOR",
    false,
    0, // developer diagnostic tool — strictly per-player, never server-forced
    { params ["_value"]; BZN_visor_debug = _value; }
] call CBA_settings_fnc_init;
