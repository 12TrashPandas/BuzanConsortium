// -------------------------------------------------------------------------
// Shared squad-health classifier — defined here in Extended_PreInit so it
// exists on EVERY machine (all clients AND the dedicated server), because
// health is published by whoever OWNS each unit: the client broadcast loop
// (fn_VISORpostInit) for player-owned units, and the server broadcast loop
// (fn_visorServerHealth) for AI local to the server. Returns
// 0 healthy / 1 damaged / 2 critical / 3 dead.
//
// With ACE the states are deliberately narrow and actionable:
//   CRIT = cardiac arrest ONLY — the "drop everything, CPR now" signal.
//          Checked first, so it wins even though an arrested unit is also
//          unconscious (otherwise the uncon->WND rule below would mask it).
//   WND  = active bleeding OR unconscious — a downed teammate reads WND even
//          once bandaged/stable, so a still-unconscious body never shows OK.
//          Pain, bruises, and residual damage on a conscious unit are still
//          ignored (a patched-up, awake squadmate reads OK again).
// Without ACE there's no bleeding/arrest model, so a vanilla fallback maps
// incapacitated (unconscious) and structural damage to WND.
// -------------------------------------------------------------------------
BZN_visor_aceMedicalLoaded = isClass (configFile >> "CfgPatches" >> "ace_medical");
BZN_fnc_visor_squadHealthState = {
    params ["_u"];
    if (!alive _u) exitWith { 3 };
    if (BZN_visor_aceMedicalLoaded) then {
        if (_u getVariable ["ace_medical_inCardiacArrest", false]) exitWith { 2 };
        if (
            (_u getVariable ["ace_medical_woundBleeding", 0]) > 0
            or { _u getVariable ["ACE_isUnconscious", false] }
        ) exitWith { 1 };
        0
    } else {
        if (lifeState _u == "INCAPACITATED") exitWith { 1 };
        if (damage _u > 0.35) exitWith { 1 };
        0
    };
};

// CBA Addon Options registered via CBA Extended_PreInit (runs in missions AND the
// Eden editor), so the settings appear in Addon Options in both contexts. EDITBOX
// values are strings; the callback parses the array literal into the runtime
// global and re-evaluates capabilities. isGlobal = 1 enables server/mission override.
if (isNil "CBA_settings_fnc_init") exitWith {
    diag_log "[BZN VISOR] CBA settings unavailable - settings not registered.";
};

// Default device whitelist: every BZN wearable this repo defines (armor
// addon) — all FAST helmet variants, all Recon Hood variants, and the ESS
// goggle facewear. One combined list: the device check accepts a match on
// either the headgear or the goggles slot. Server/mission can still override
// via Addon Options (isGlobal = 1 below); note CBA only applies this default
// where the setting has never been saved — a client/server with an older
// saved value must "Reset to default" in Addon Options to pick it up.
private _defaultDevices = [
    // [Bzn] FASTMT helmets (addons\armor\data\helmets\FAST)
    "Bzn_helmet_fastmt_urban",
    "Bzn_helmet_fastmt_urban_tan",
    "Bzn_helmet_fastmt_woodland",
    "Bzn_helmet_fastmt_jungle",
    "Bzn_helmet_fastmt_black",
    "Bzn_helmet_fastmt_white",
    "Bzn_helmet_fastmt_cover_urban",
    "Bzn_helmet_fastmt_cover_urban_tan",
    "Bzn_helmet_fastmt_cover_arid",
    "Bzn_helmet_fastmt_cover_woodland",
    "Bzn_helmet_fastmt_cover_jungle",
    "Bzn_helmet_fastmt_cover_maritime",
    "Bzn_helmet_fastmt_cover_winter",
    // [Bzn] Recon Hoods (addons\armor\data\helmets\Recon-Cloak)
    "Bzn_helmet_reconcloak_urban",
    "Bzn_helmet_reconcloak_jungle",
    "Bzn_helmet_reconcloak_desert",
    "Bzn_helmet_reconcloak_winter",
    "Bzn_helmet_reconcloak_woodland",
    "Bzn_helmet_reconcloak_maritime",
    // Bzn ESS goggle facewear (addons\armor\data\facewear\cup_ess)
    "Bzn_G_ESS_BLK_Scarf_Face_Urban",
    "Bzn_G_ESS_BLK_Scarf_Face_Custom_Witch"
];
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

// (Zeus mark duration is no longer a CBA setting — the "Mark Target (VISOR)"
// module opens a configuration dialog on placement where the curator sets the
// timer, or disables it, per mark.)

[
    "BZN_visor_fade_infantry", "SLIDER",
    ["Infantry fade range (m)", "How far out infantry tags stay visible — tags fade with distance and disappear around this range."],
    "BZN VISOR",
    [100, 3000, 1000, 0],
    0, // personal display preference — never server-forced
    { params ["_value"]; BZN_visor_fade_infantry = _value; }
] call CBA_settings_fnc_init;

[
    "BZN_visor_fade_vehicle", "SLIDER",
    ["Vehicle fade range (m)", "How far out vehicle, aircraft, and ship tags stay visible — tags fade with distance and disappear around this range. Defaults much higher than infantry so friendly air keeps its IFF at realistic contact ranges."],
    "BZN VISOR",
    [100, 10000, 5000, 0],
    0, // same rationale as the infantry slider above
    { params ["_value"]; BZN_visor_fade_vehicle = _value; }
] call CBA_settings_fnc_init;

[
    "BZN_visor_scale_range", "SLIDER",
    ["Tag shrink range (m)", "Tags shrink progressively with (zoom-adjusted) distance, reaching their minimum size at this range. Zooming an optic onto a distant contact counts as being that much closer, growing its tag back."],
    "BZN VISOR",
    [500, 10000, 5000, 0],
    0, // personal display preference — never server-forced
    { params ["_value"]; BZN_visor_scale_range = _value; }
] call CBA_settings_fnc_init;

[
    "BZN_visor_scale_min", "SLIDER",
    ["Tag minimum scale", "How small a tag gets at (and beyond) the shrink range — 0.5 = half size. Set it to 1 to disable distance shrinking entirely."],
    "BZN VISOR",
    [0.1, 1, 0.5, 2],
    0, // same rationale as the shrink-range slider above
    { params ["_value"]; BZN_visor_scale_min = _value; }
] call CBA_settings_fnc_init;

[
    "BZN_visor_squadHealth_panel", "CHECKBOX",
    ["Squad health panel (standalone)", "Shows VISOR's own fixed on-screen squad roster panel with a colour-coded health state per member: green healthy, yellow wounded, red critical, grey KIA (ACE medical-driven). Independent of the DUI integration below — run either, both, or neither."],
    "BZN VISOR",
    true,
    0, // personal display preference — never server-forced
    { params ["_value"]; BZN_visor_squadHealth_panel = _value; }
] call CBA_settings_fnc_init;

[
    "BZN_visor_squadHealth_dui", "CHECKBOX",
    ["Squad health -> DUI Squad Radar", "If diwako's DUI - Squad Radar is loaded, appends a colour-coded status to squadmates' names in DUI's list — the name itself keeps DUI's normal unit colour, only the status word is coloured: green ' - OK' healthy, yellow ' - WND' wounded, red ' - CRIT' critical, grey ' - KIA'. Does nothing when DUI isn't running."],
    "BZN VISOR",
    true,
    0, // personal display preference — DUI's HUD is per-player anyway
    { params ["_value"]; BZN_visor_squadHealth_dui = _value; }
] call CBA_settings_fnc_init;

[
    "BZN_visor_squadHealth_position", "LIST",
    ["Squad health indicator position", "Which screen corner the squad health panel sits in. Top right can momentarily overlap VISOR hint notifications (drone uplink notice) — pick another corner if you use those."],
    "BZN VISOR",
    [["BL", "BR", "TL", "TR"], ["Bottom left", "Bottom right", "Top left", "Top right"], 1],
    0, // personal display preference, same rationale as the checkbox above
    { params ["_value"]; BZN_visor_squadHealth_position = _value; }
] call CBA_settings_fnc_init;

// The old per-player tag-clustering sliders and the developer debug checkbox
// were dropped (along with the clustering system itself) to keep Addon
// Options down to the handful of settings players actually need.
