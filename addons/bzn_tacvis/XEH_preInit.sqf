// CBA Addon Options registered via CBA Extended_PreInit (runs in missions AND the
// Eden editor), so the settings appear in Addon Options in both contexts. EDITBOX
// values are strings; the callback parses the array literal into the runtime
// global and refreshes the action set. isGlobal = 1 enables server/mission override.
if (isNil "CBA_settings_fnc_init") exitWith {
    diag_log "[BZN TacVis] CBA settings unavailable - settings not registered.";
};

private _defaultDevices  = ["CUP_H_PMC_Beanie_Winter","CUP_H_PMC_Beanie_Headphones_Winter","Aegis_H_Helmet_FASTMT_blk_F","Aegis_H_Helmet_FASTMT_Cover_blk_F","Aegis_H_Helmet_FASTMT_Cover_rgr_F","Aegis_H_Helmet_FASTMT_Cover_tan_F","Aegis_H_Helmet_FASTMT_cbr_F","Aegis_H_Helmet_FASTMT_rgr_F","Aegis_H_Helmet_FASTMT_Headset_blk_F","Aegis_H_Helmet_FASTMT_Headset_cbr_F","Aegis_H_Helmet_FASTMT_Headset_rgr_F","Aegis_H_Helmet_FASTMT_Headset_tan_F","Aegis_H_Helmet_FASTMT_tan_F","H_HelmetCrew_I","lxWS_H_HelmetCrew_I","H_HelmetCrew_I_I","CUP_H_CVCH_des","CUP_H_PMC_Beanie_Headphones_Khaki","CUP_H_PMC_Beanie_Khaki","CUP_H_PMC_Beanie_Headphones_Black","CUP_H_PMC_Beanie_Black","H_Watchcap_blk","H_Watchcap_cbr","H_Watchcap_cbr_hs","H_Watchcap_khk_hs","H_Watchcap_red","H_Watchcap_blk_hs","H_Watchcap_camo_hs","H_Watchcap_khk","H_Watchcap_camo","H_Watchcap_sgg","Aegis_H_Milcap_nohs_gry_F","CUP_H_FR_BandanaGreen","H_Booniehat_khk","H_Booniehat_khk_hs","H_Booniehat_tan","H_Booniehat_tan_headset","H_Booniehat_oli","H_Booniehat_oli_headset","CUP_H_PMC_Cap_Grey","CUP_H_PMC_Cap_Back_Grey","CUP_H_PMC_Cap_Back_EP_Grey","CUP_H_PMC_Cap_Back_PRR_Grey","CUP_H_PMC_Cap_EP_Grey","CUP_H_PMC_Cap_PRR_Grey","CUP_H_PMC_Cap_Back_Tan","CUP_H_PMC_Cap_Back_EP_Tan","CUP_H_PMC_Cap_Back_PRR_Tan","CUP_H_PMC_Cap_EP_Tan","CUP_H_PMC_Cap_PRR_Tan","CUP_H_PMC_Cap_Tan","Aegis_H_MilCap_nohs_blk","Aegis_H_Milcap_nohs_blue_F","Aegis_H_Milcap_nohs_grn_F","Aegis_H_MilCap_tachs_blk_F","Aegis_H_MilCap_tachs_grn_F","Aegis_H_MilCap_tachs_tan_F","Aegis_H_MilCap_nohs_tan","H_PilotHelmetHeli_B","H_PilotHelmetHeli_O","H_CrewHelmetHeli_O","H_CrewHelmetHeli_B","CUP_G_PMC_Facewrap_Winter_Glasses_Ember","CUP_G_PMC_Facewrap_Winter_Glasses_Dark","CUP_G_PMC_Facewrap_Winter_Glasses_Dark_Headset","CUP_G_ESS_KHK_Facewrap_White","CUP_G_ESS_BLK_Scarf_White_GPS_Beard_Blonde","CUP_G_ESS_BLK_Scarf_White_GPS_Beard","CUP_G_ESS_BLK_Scarf_White_GPS","CUP_G_ESS_BLK_Scarf_White_Beard_Blonde","CUP_G_ESS_BLK_Scarf_White_Beard","CUP_G_ESS_BLK_Scarf_White","CUP_G_ESS_BLK_Scarf_Face_White","CUP_G_White_Scarf_Shades_GPS","CUP_G_White_Scarf_Shades_GPS_Beard","CUP_G_White_Scarf_Shades_GPS_Beard_Blonde","CUP_G_White_Scarf_Shades","CUP_G_Scarf_Face_White","CUP_G_White_Scarf_Shades_Beard","CUP_G_White_Scarf_Shades_Beard_Blonde","CUP_G_White_Scarf_GPS","CUP_G_White_Scarf_GPS_Beard","CUP_G_White_Scarf_GPS_Beard_Blonde","CUP_G_White_Scarf_Shades_GPSCombo","CUP_G_White_Scarf_Shades_GPSCombo_Beard","CUP_G_White_Scarf_Shades_GPSCombo_Beard_Blonde","CUP_G_ESS_BLK_Scarf_Face_White_GPS","Aegis_NV_G_scrimNet_under_black_F","Aegis_NV_G_scrimNet_black_F","Aegis_G_Armband_OPF_F","Aegis_G_Armband_Medic_F","G_Aviator","G_Spectacles_Tinted","CUP_PMC_G_thug","G_Tactical_Yellow","G_Tactical_Camo","G_Tactical_Black","G_Headset_Tactical_khk","G_Headset_Tactical_grn","G_Headset_Tactical","G_Tactical_Clear","CUP_G_Tan_Scarf_Shades_GPSCombo_Beard","CUP_G_Tan_Scarf_Shades_GPSCombo_Beard_Blonde","CUP_G_Grn_Scarf_Shades_GPSCombo_Beard_Blonde","CUP_G_Grn_Scarf_Shades_GPSCombo_Beard","CUP_G_Tan_Scarf_Shades_GPSCombo","CUP_G_Grn_Scarf_Shades_GPSCombo","CUP_G_Tan_Scarf_GPS_Beard","CUP_G_Tan_Scarf_GPS_Beard_Blonde","CUP_G_Grn_Scarf_GPS_Beard","CUP_G_Grn_Scarf_GPS_Beard_Blonde","CUP_G_Tan_Scarf_GPS","CUP_G_Grn_Scarf_GPS","CUP_G_WatchGPSCombo","Aegis_G_Condor_EyePro_F","G_Squares","G_Squares_Tinted","G_Sport_Greenblack","G_Sport_Blackred","G_Sport_Checkered","G_Sport_BlackWhite","G_Sport_Blackyellow","G_Sport_Red","G_Spectacles","G_Shemag_white","G_Shemag_tan","G_Shemag_tactical","G_Shemag_shades","G_Shemag_red","G_Shemag_oli","G_Shemag_khk","CUP_G_Beard_Shades_Blonde","CUP_G_Beard_Shades_Black","G_Shades_Yellowred","G_Shades_Red","G_Shades_Green","G_Shades_Blue","G_Shades_Black","Aegis_G_scrimNet_under_sand_F","Aegis_G_scrimNet_black_F","Aegis_G_scrimNet_olive_F","Aegis_G_scrimNet_sand_F","Aegis_G_scrimNet_under_black_F","Aegis_G_scrimNet_under_olive_F","CUP_G_Tan_Scarf_Shades_Beard","CUP_G_Tan_Scarf_Shades_Beard_Blonde","CUP_G_Grn_Scarf_Shades_Beard","CUP_G_Grn_Scarf_Shades_Beard_Blonde","CUP_G_Tan_Scarf_Shades","CUP_G_Grn_Scarf_Shades","CUP_G_TK_RoundGlasses_gold","CUP_G_TK_RoundGlasses_blk","CUP_G_TK_RoundGlasses","CUP_G_Oakleys_Embr","CUP_G_Oakleys_Drk","CUP_G_Oakleys_Clr","CUP_G_Scarf_Face_Blk","CUP_G_Scarf_Face_Grn","CUP_G_Scarf_Face_Red","CUP_G_Scarf_Face_Tan","G_Lady_Blue","CUP_G_PMC_RadioHeadset_Glasses","CUP_G_PMC_RadioHeadset_Glasses_Ember","CUP_G_PMC_RadioHeadset_Glasses_Dark","CUP_G_RUS_Ratnik_6M21_Summer","CUP_G_RUS_Ratnik_6M21_Desert","CUP_G_RUS_Ratnik_6M2_Summer","CUP_G_RUS_Ratnik_6M2_Desert","CUP_G_Tan_Scarf_Shades_GPS_Beard","CUP_G_Tan_Scarf_Shades_GPS_Beard_Blonde","CUP_G_Grn_Scarf_Shades_GPS_Beard_Blonde","CUP_G_Grn_Scarf_Shades_GPS_Beard","CUP_G_Tan_Scarf_Shades_GPS","CUP_G_Grn_Scarf_Shades_GPS","CUP_G_PMC_Facewrap_Tropical_Glasses_Ember","CUP_G_PMC_Facewrap_Tropical_Glasses_Dark","CUP_G_PMC_Facewrap_Tropical_Glasses_Dark_Headset","CUP_G_PMC_Facewrap_Tan_Glasses_Ember","CUP_G_PMC_Facewrap_Tan_Glasses_Dark","CUP_G_PMC_Facewrap_Tan_Glasses_Dark_Headset","CUP_G_PMC_Facewrap_Black_Glasses_Ember","CUP_G_PMC_Facewrap_Black_Glasses_Dark","CUP_G_PMC_Facewrap_Black_Glasses_Dark_Headset","CUP_G_ESS_KHK_Scarf_Tan_GPS_Beard_Blonde","CUP_G_ESS_KHK_Scarf_Tan_GPS_Beard","CUP_G_ESS_BLK_Scarf_Grn_GPS_Beard_Blonde","CUP_G_ESS_BLK_Scarf_Grn_GPS_Beard","CUP_G_ESS_KHK_Scarf_Face_Tan_GPS","CUP_G_ESS_BLK_Scarf_Face_Grn_GPS","CUP_G_ESS_KHK_Scarf_Tan_GPS","CUP_G_ESS_BLK_Scarf_Grn_GPS","CUP_G_ESS_KHK_Scarf_Tan_Beard","CUP_G_ESS_KHK_Scarf_Tan_Beard_Blonde","CUP_G_ESS_BLK_Scarf_Blk_Beard_Blonde","CUP_G_ESS_BLK_Scarf_Blk_Beard","CUP_G_ESS_BLK_Scarf_Grn_Beard","CUP_G_ESS_BLK_Scarf_Grn_Beard_Blonde","CUP_G_ESS_BLK_Scarf_Red_Beard_Blonde","CUP_G_ESS_KHK_Scarf_Face_Tan","CUP_G_ESS_BLK_Scarf_Face_Red","CUP_G_ESS_BLK_Scarf_Face_Grn","CUP_G_ESS_BLK_Scarf_Face_Blk","CUP_G_ESS_BLK_Scarf_Red_Beard","CUP_G_ESS_BLK_Facewrap_Black_GPS","CUP_G_ESS_BLK_Scarf_Blk","CUP_G_ESS_BLK_Scarf_Grn","CUP_G_ESS_BLK_Scarf_Red","CUP_G_ESS_KHK_Scarf_Tan","CUP_G_ESS_RGR_Facewrap_Tropical","CUP_G_ESS_KHK_Facewrap_Tan","CUP_G_ESS_RGR_Facewrap_Ranger","CUP_G_ESS_BLK_Facewrap_Black","CUP_G_ESS_KHK","CUP_G_ESS_KHK_Ember","CUP_G_ESS_KHK_Dark","CUP_G_ESS_RGR","CUP_G_ESS_CBR_Facewrap_Red","CUP_G_ESS_RGR_Facewrap_Skull","CUP_G_ESS_RGR_Ember","CUP_G_ESS_RGR_Dark","CUP_G_ESS_CBR","CUP_G_ESS_CBR_Ember","CUP_G_ESS_CBR_Dark","CUP_G_ESS_BLK","CUP_G_ESS_BLK_Ember","CUP_G_ESS_BLK_Dark","G_Combat_lxWS","G_Glasses_white_RF","G_Glasses_black_RF","G_Combat","G_Combat_Goggles_blk_F","G_Combat_Goggles_tna_F","G_Cigarette","G_Bandanna_Syndikat2","Aegis_NV_G_scrimNet_under_olive_F","Aegis_NV_G_scrimNet_under_sand_F","Aegis_NV_G_scrimNet_sand_F","Aegis_NV_G_scrimNet_olive_F","Aegis_NV_G_Armband_OPF_F","Aegis_NV_G_Armband_Medic_F","Aegis_NV_G_Armband_Medic_alt_F","Bzn_G_ESS_BLK_Scarf_Face_Urban","Bzn_G_ESS_BLK_Scarf_Face_Custom_Witch","G_Balaclava_light_blk_F","G_Balaclava_light_G_blk_F","G_CBRN_B","G_CBRN_B_black","G_CBRN_B_blue","G_CBRN_B_green","G_CBRN_C_blue"];
private _defaultCQC      = ["CUP_H_PMC_Beanie_Winter"];
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
