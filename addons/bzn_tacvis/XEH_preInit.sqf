// CBA Addon Options registered via CBA Extended_PreInit (runs in missions AND the
// Eden editor), so the settings appear in Addon Options in both contexts. EDITBOX
// values are strings; the callback parses the array literal into the runtime
// global and refreshes the action set. isGlobal = 1 enables server/mission override.
if (isNil "CBA_settings_fnc_init") exitWith {
    diag_log "[BZN TacVis] CBA settings unavailable - settings not registered.";
};

private _defaultDevices  = [];
private _defaultCQC      = [];
private _defaultJTAC     = [];
private _defaultVehicles = [];

[
    "BZN_tacvis_devices_str", "EDITBOX",
    ["Devices (always-on + spot)", "Array literal of helmet and goggle classnames that grant the always-on friendly display and the spot action."],
    "BZN TacVis",
    str _defaultDevices,
    1,
    { params ["_value"]; BZN_tacvis_devices = parseSimpleArray _value; if (!isNil "BZN_fnc_tacvis_refresh") then { call BZN_fnc_tacvis_refresh }; }
] call CBA_settings_fnc_init;

[
    "BZN_tacvis_devices_cqc_str", "EDITBOX",
    ["CQC devices", "Array literal of classnames that additionally grant the CQC scroll-wheel toggle."],
    "BZN TacVis",
    str _defaultCQC,
    1,
    { params ["_value"]; BZN_tacvis_devices_cqc = parseSimpleArray _value; if (!isNil "BZN_fnc_tacvis_refresh") then { call BZN_fnc_tacvis_refresh }; }
] call CBA_settings_fnc_init;

[
    "BZN_tacvis_devices_jtac_str", "EDITBOX",
    ["JTAC devices", "Array literal of classnames that additionally grant the always-on JTAC SITREP overlay (grid-by-grid contact breakdown). Leave empty to restrict it to nobody, or mirror the main device list to grant it to every TacVis user."],
    "BZN TacVis",
    str _defaultJTAC,
    1,
    { params ["_value"]; BZN_tacvis_devices_jtac = parseSimpleArray _value; if (!isNil "BZN_fnc_tacvis_refresh") then { call BZN_fnc_tacvis_refresh }; }
] call CBA_settings_fnc_init;

[
    "BZN_tacvis_vehicles_str", "EDITBOX",
    ["Approved vehicles", "Array literal of vehicle classnames that grant always-on and spot while mounted, regardless of headgear."],
    "BZN TacVis",
    str _defaultVehicles,
    1,
    { params ["_value"]; BZN_tacvis_vehicles = parseSimpleArray _value; if (!isNil "BZN_fnc_tacvis_refresh") then { call BZN_fnc_tacvis_refresh }; }
] call CBA_settings_fnc_init;

[
    "BZN_tacvis_spot_showAction", "CHECKBOX",
    ["Show 'Spot Target' in scroll menu", "Adds a scroll-wheel 'Spot Target' entry alongside the keybind. Disable if you'd rather rely solely on the keybind (e.g. the menu entry isn't reachable while piloting a UAV through a terminal — the keybind always works)."],
    "BZN TacVis",
    true,
    0, // personal UI preference, not a balance/whitelist concern — left as a per-player local choice (unlike the device/vehicle whitelists above, which are forced)
    { params ["_value"]; BZN_tacvis_spot_showAction = _value; if (!isNil "BZN_fnc_tacvis_refresh") then { call BZN_fnc_tacvis_refresh }; }
] call CBA_settings_fnc_init;

[
    "BZN_tacvis_cluster_minDistance", "SLIDER",
    ["Tag clustering range (m)", "How far away nearby same-side contacts need to be from you before their tags collapse into a single grouped summary instead of rendering individually. Applies on foot and in ground vehicles. Lower it to declutter sooner; raise it (or max it out) to always see every contact's full tag."],
    "BZN TacVis",
    [0, 500, 100, 0],
    0, // purely a personal display/declutter preference — doesn't affect gameplay balance, so it's a local per-player choice like the scroll-menu toggle above
    { params ["_value"]; BZN_tacvis_cluster_minDistance = _value; }
] call CBA_settings_fnc_init;

[
    "BZN_tacvis_cluster_minDistance_air", "SLIDER",
    ["Tag clustering range, air/drone (m)", "Same as 'Tag clustering range', but used instead whenever you're aircrew or slaved to a UAV/UGV feed — looking down from altitude bunches contacts together on screen at much greater distances, so this defaults much higher (2 km) than the ground-level range."],
    "BZN TacVis",
    [0, 5000, 2000, 0],
    0, // same rationale as the ground-level slider above — personal display preference, not balance
    { params ["_value"]; BZN_tacvis_cluster_minDistance_air = _value; }
] call CBA_settings_fnc_init;
