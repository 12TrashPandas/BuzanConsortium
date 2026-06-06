if (isDedicated or !local player) exitWith {};

BZN_tacvis_debug = false;

// -------------------------------------------------------------------------
// Device arrays — populate these with your unit's actual classnames.
// BZN_tacvis_devices:     always-on friendly display + spot action.
// BZN_tacvis_devices_cqc: CQC scroll-wheel toggle (separate, smaller list).
// -------------------------------------------------------------------------
BZN_tacvis_devices = ["CUP_H_PMC_Beanie_Winter","CUP_H_PMC_Beanie_Headphones_Winter","Aegis_H_Helmet_FASTMT_blk_F","Aegis_H_Helmet_FASTMT_Cover_blk_F","Aegis_H_Helmet_FASTMT_Cover_rgr_F","Aegis_H_Helmet_FASTMT_Cover_tan_F","Aegis_H_Helmet_FASTMT_cbr_F","Aegis_H_Helmet_FASTMT_rgr_F","Aegis_H_Helmet_FASTMT_Headset_blk_F","Aegis_H_Helmet_FASTMT_Headset_cbr_F","Aegis_H_Helmet_FASTMT_Headset_rgr_F","Aegis_H_Helmet_FASTMT_Headset_tan_F","Aegis_H_Helmet_FASTMT_tan_F","H_HelmetCrew_I","lxWS_H_HelmetCrew_I","H_HelmetCrew_I_I","CUP_H_CVCH_des","CUP_H_PMC_Beanie_Headphones_Khaki","CUP_H_PMC_Beanie_Khaki","CUP_H_PMC_Beanie_Headphones_Black","CUP_H_PMC_Beanie_Black","H_Watchcap_blk","H_Watchcap_cbr","H_Watchcap_cbr_hs","H_Watchcap_khk_hs","H_Watchcap_red","H_Watchcap_blk_hs","H_Watchcap_camo_hs","H_Watchcap_khk","H_Watchcap_camo","H_Watchcap_sgg","Aegis_H_Milcap_nohs_gry_F","CUP_H_FR_BandanaGreen","H_Booniehat_khk","H_Booniehat_khk_hs","H_Booniehat_tan","H_Booniehat_tan_headset","H_Booniehat_oli","H_Booniehat_oli_headset","CUP_H_PMC_Cap_Grey","CUP_H_PMC_Cap_Back_Grey","CUP_H_PMC_Cap_Back_EP_Grey","CUP_H_PMC_Cap_Back_PRR_Grey","CUP_H_PMC_Cap_EP_Grey","CUP_H_PMC_Cap_PRR_Grey","CUP_H_PMC_Cap_Back_Tan","CUP_H_PMC_Cap_Back_EP_Tan","CUP_H_PMC_Cap_Back_PRR_Tan","CUP_H_PMC_Cap_EP_Tan","CUP_H_PMC_Cap_PRR_Tan","CUP_H_PMC_Cap_Tan","Aegis_H_MilCap_nohs_blk","Aegis_H_Milcap_nohs_blue_F","Aegis_H_Milcap_nohs_grn_F","Aegis_H_MilCap_tachs_blk_F","Aegis_H_MilCap_tachs_grn_F","Aegis_H_MilCap_tachs_tan_F","Aegis_H_MilCap_nohs_tan","H_PilotHelmetHeli_B","H_PilotHelmetHeli_O","H_CrewHelmetHeli_O","H_CrewHelmetHeli_B","CUP_G_PMC_Facewrap_Winter_Glasses_Ember","CUP_G_PMC_Facewrap_Winter_Glasses_Dark","CUP_G_PMC_Facewrap_Winter_Glasses_Dark_Headset","CUP_G_ESS_KHK_Facewrap_White","CUP_G_ESS_BLK_Scarf_White_GPS_Beard_Blonde","CUP_G_ESS_BLK_Scarf_White_GPS_Beard","CUP_G_ESS_BLK_Scarf_White_GPS","CUP_G_ESS_BLK_Scarf_White_Beard_Blonde","CUP_G_ESS_BLK_Scarf_White_Beard","CUP_G_ESS_BLK_Scarf_White","CUP_G_ESS_BLK_Scarf_Face_White","CUP_G_White_Scarf_Shades_GPS","CUP_G_White_Scarf_Shades_GPS_Beard","CUP_G_White_Scarf_Shades_GPS_Beard_Blonde","CUP_G_White_Scarf_Shades","CUP_G_Scarf_Face_White","CUP_G_White_Scarf_Shades_Beard","CUP_G_White_Scarf_Shades_Beard_Blonde","CUP_G_White_Scarf_GPS","CUP_G_White_Scarf_GPS_Beard","CUP_G_White_Scarf_GPS_Beard_Blonde","CUP_G_White_Scarf_Shades_GPSCombo","CUP_G_White_Scarf_Shades_GPSCombo_Beard","CUP_G_White_Scarf_Shades_GPSCombo_Beard_Blonde","CUP_G_ESS_BLK_Scarf_Face_White_GPS","Aegis_NV_G_scrimNet_under_black_F","Aegis_NV_G_scrimNet_black_F","Aegis_G_Armband_OPF_F","Aegis_G_Armband_Medic_F","G_Aviator","G_Spectacles_Tinted","CUP_PMC_G_thug","G_Tactical_Yellow","G_Tactical_Camo","G_Tactical_Black","G_Headset_Tactical_khk","G_Headset_Tactical_grn","G_Headset_Tactical","G_Tactical_Clear","CUP_G_Tan_Scarf_Shades_GPSCombo_Beard","CUP_G_Tan_Scarf_Shades_GPSCombo_Beard_Blonde","CUP_G_Grn_Scarf_Shades_GPSCombo_Beard_Blonde","CUP_G_Grn_Scarf_Shades_GPSCombo_Beard","CUP_G_Tan_Scarf_Shades_GPSCombo","CUP_G_Grn_Scarf_Shades_GPSCombo","CUP_G_Tan_Scarf_GPS_Beard","CUP_G_Tan_Scarf_GPS_Beard_Blonde","CUP_G_Grn_Scarf_GPS_Beard","CUP_G_Grn_Scarf_GPS_Beard_Blonde","CUP_G_Tan_Scarf_GPS","CUP_G_Grn_Scarf_GPS","CUP_G_WatchGPSCombo","Aegis_G_Condor_EyePro_F","G_Squares","G_Squares_Tinted","G_Sport_Greenblack","G_Sport_Blackred","G_Sport_Checkered","G_Sport_BlackWhite","G_Sport_Blackyellow","G_Sport_Red","G_Spectacles","G_Shemag_white","G_Shemag_tan","G_Shemag_tactical","G_Shemag_shades","G_Shemag_red","G_Shemag_oli","G_Shemag_khk","CUP_G_Beard_Shades_Blonde","CUP_G_Beard_Shades_Black","G_Shades_Yellowred","G_Shades_Red","G_Shades_Green","G_Shades_Blue","G_Shades_Black","Aegis_G_scrimNet_under_sand_F","Aegis_G_scrimNet_black_F","Aegis_G_scrimNet_olive_F","Aegis_G_scrimNet_sand_F","Aegis_G_scrimNet_under_black_F","Aegis_G_scrimNet_under_olive_F","CUP_G_Tan_Scarf_Shades_Beard","CUP_G_Tan_Scarf_Shades_Beard_Blonde","CUP_G_Grn_Scarf_Shades_Beard","CUP_G_Grn_Scarf_Shades_Beard_Blonde","CUP_G_Tan_Scarf_Shades","CUP_G_Grn_Scarf_Shades","CUP_G_TK_RoundGlasses_gold","CUP_G_TK_RoundGlasses_blk","CUP_G_TK_RoundGlasses","CUP_G_Oakleys_Embr","CUP_G_Oakleys_Drk","CUP_G_Oakleys_Clr","CUP_G_Scarf_Face_Blk","CUP_G_Scarf_Face_Grn","CUP_G_Scarf_Face_Red","CUP_G_Scarf_Face_Tan","G_Lady_Blue","CUP_G_PMC_RadioHeadset_Glasses","CUP_G_PMC_RadioHeadset_Glasses_Ember","CUP_G_PMC_RadioHeadset_Glasses_Dark","CUP_G_RUS_Ratnik_6M21_Summer","CUP_G_RUS_Ratnik_6M21_Desert","CUP_G_RUS_Ratnik_6M2_Summer","CUP_G_RUS_Ratnik_6M2_Desert","CUP_G_Tan_Scarf_Shades_GPS_Beard","CUP_G_Tan_Scarf_Shades_GPS_Beard_Blonde","CUP_G_Grn_Scarf_Shades_GPS_Beard_Blonde","CUP_G_Grn_Scarf_Shades_GPS_Beard","CUP_G_Tan_Scarf_Shades_GPS","CUP_G_Grn_Scarf_Shades_GPS","CUP_G_PMC_Facewrap_Tropical_Glasses_Ember","CUP_G_PMC_Facewrap_Tropical_Glasses_Dark","CUP_G_PMC_Facewrap_Tropical_Glasses_Dark_Headset","CUP_G_PMC_Facewrap_Tan_Glasses_Ember","CUP_G_PMC_Facewrap_Tan_Glasses_Dark","CUP_G_PMC_Facewrap_Tan_Glasses_Dark_Headset","CUP_G_PMC_Facewrap_Black_Glasses_Ember","CUP_G_PMC_Facewrap_Black_Glasses_Dark","CUP_G_PMC_Facewrap_Black_Glasses_Dark_Headset","CUP_G_ESS_KHK_Scarf_Tan_GPS_Beard_Blonde","CUP_G_ESS_KHK_Scarf_Tan_GPS_Beard","CUP_G_ESS_BLK_Scarf_Grn_GPS_Beard_Blonde","CUP_G_ESS_BLK_Scarf_Grn_GPS_Beard","CUP_G_ESS_KHK_Scarf_Face_Tan_GPS","CUP_G_ESS_BLK_Scarf_Face_Grn_GPS","CUP_G_ESS_KHK_Scarf_Tan_GPS","CUP_G_ESS_BLK_Scarf_Grn_GPS","CUP_G_ESS_KHK_Scarf_Tan_Beard","CUP_G_ESS_KHK_Scarf_Tan_Beard_Blonde","CUP_G_ESS_BLK_Scarf_Blk_Beard_Blonde","CUP_G_ESS_BLK_Scarf_Blk_Beard","CUP_G_ESS_BLK_Scarf_Grn_Beard","CUP_G_ESS_BLK_Scarf_Grn_Beard_Blonde","CUP_G_ESS_BLK_Scarf_Red_Beard_Blonde","CUP_G_ESS_KHK_Scarf_Face_Tan","CUP_G_ESS_BLK_Scarf_Face_Red","CUP_G_ESS_BLK_Scarf_Face_Grn","CUP_G_ESS_BLK_Scarf_Face_Blk","CUP_G_ESS_BLK_Scarf_Red_Beard","CUP_G_ESS_BLK_Facewrap_Black_GPS","CUP_G_ESS_BLK_Scarf_Blk","CUP_G_ESS_BLK_Scarf_Grn","CUP_G_ESS_BLK_Scarf_Red","CUP_G_ESS_KHK_Scarf_Tan","CUP_G_ESS_RGR_Facewrap_Tropical","CUP_G_ESS_KHK_Facewrap_Tan","CUP_G_ESS_RGR_Facewrap_Ranger","CUP_G_ESS_BLK_Facewrap_Black","CUP_G_ESS_KHK","CUP_G_ESS_KHK_Ember","CUP_G_ESS_KHK_Dark","CUP_G_ESS_RGR","CUP_G_ESS_CBR_Facewrap_Red","CUP_G_ESS_RGR_Facewrap_Skull","CUP_G_ESS_RGR_Ember","CUP_G_ESS_RGR_Dark","CUP_G_ESS_CBR","CUP_G_ESS_CBR_Ember","CUP_G_ESS_CBR_Dark","CUP_G_ESS_BLK","CUP_G_ESS_BLK_Ember","CUP_G_ESS_BLK_Dark","G_Combat_lxWS","G_Glasses_white_RF","G_Glasses_black_RF","G_Combat","G_Combat_Goggles_blk_F","G_Combat_Goggles_tna_F","G_Cigarette","G_Bandanna_Syndikat2","Aegis_NV_G_scrimNet_under_olive_F","Aegis_NV_G_scrimNet_under_sand_F","Aegis_NV_G_scrimNet_sand_F","Aegis_NV_G_scrimNet_olive_F","Aegis_NV_G_Armband_OPF_F","Aegis_NV_G_Armband_Medic_F","Aegis_NV_G_Armband_Medic_alt_F","Bzn_G_ESS_BLK_Scarf_Face_Urban","Bzn_G_ESS_BLK_Scarf_Face_Custom_Witch","G_Balaclava_light_blk_F","G_Balaclava_light_G_blk_F","G_CBRN_B","G_CBRN_B_black","G_CBRN_B_blue","G_CBRN_B_green","G_CBRN_C_blue"];
BZN_tacvis_devices_cqc = ["CUP_H_PMC_Beanie_Winter"];

// Approved vehicles — while mounted in one of these, the player gets the
// always-on display + spot action regardless of headgear/goggles (matched by
// exact vehicle classname, like the device arrays).
BZN_tacvis_vehicles = [];

// Runtime flags
BZN_tacvis_friendly_active = false;
BZN_tacvis_CQC_active      = false;
BZN_tacvis_CQC_cooldown    = false;
BZN_tacvis_spot_cooldown   = false;

// Render pools
BZN_tacvis_pool_friendly = [];   // friendlies + spotted enemies (always-on)
BZN_tacvis_pool_CQC      = [];   // nearby enemies (CQC mode only)

// Spotted enemies: [[unit, expiryTime, markerName], ...]
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

BZN_fnc_tacvis_addActions = {
    call BZN_fnc_tacvis_removeActions;

    if (call BZN_fnc_tacvis_hasDevice) then {
        call BZN_fnc_tacvis_startRender;

        if (!BZN_tacvis_friendly_active) then {
            BZN_tacvis_friendly_active = true;
            [] spawn BZN_fnc_tacvisAlwaysOn;
        };

        BZN_tacvis_spot_action = player addAction [
            "Spot Target",
            { [] spawn BZN_fnc_tacvisSpot },
            [], 1.5, false, true, "",
            "!BZN_tacvis_spot_cooldown && (cameraView == 'GUNNER')"
        ];
    };

    if (call BZN_fnc_tacvis_hasCQCDevice and !BZN_tacvis_CQC_cooldown) then {
        call BZN_fnc_tacvis_startRender;
        BZN_tacvis_CQC_action = player addAction [
            "Toggle CQC",
            { [] spawn BZN_fnc_tacvisCQC },
            [], 1.4, false, true, "", "true"
        ];
    };
};

BZN_fnc_tacvis_stopAll = {
    call BZN_fnc_tacvis_removeActions;
    BZN_tacvis_friendly_active = false;
    BZN_tacvis_CQC_active      = false;
    BZN_tacvis_pool_friendly   = [];
    BZN_tacvis_pool_CQC        = [];
    if (BZN_tacvis_Display >= 0) then {
        removeMissionEventHandler ["Draw3D", BZN_tacvis_Display];
        BZN_tacvis_Display = -1;
    };
};

// -------------------------------------------------------------------------
// Initial equip check
// -------------------------------------------------------------------------
if (call BZN_fnc_tacvis_hasDevice or call BZN_fnc_tacvis_hasCQCDevice) then {
    call BZN_fnc_tacvis_addActions;
};

// -------------------------------------------------------------------------
// Equipment event handlers
// -------------------------------------------------------------------------
player addEventHandler ["Put", {
    params ["_unit", "_container", "_item"];
    if (_item in BZN_tacvis_devices or _item in BZN_tacvis_devices_cqc) then {
        if (!(call BZN_fnc_tacvis_hasDevice) and !(call BZN_fnc_tacvis_hasCQCDevice)) then {
            call BZN_fnc_tacvis_stopAll;
        };
    };
}];

player addEventHandler ["Take", {
    params ["_unit", "_container", "_item"];
    if (_item in BZN_tacvis_devices or _item in BZN_tacvis_devices_cqc) then {
        call BZN_fnc_tacvis_addActions;
    };
}];

player addEventHandler ["InventoryClosed", {
    params ["_unit"];
    if (call BZN_fnc_tacvis_hasDevice or call BZN_fnc_tacvis_hasCQCDevice) then {
        call BZN_fnc_tacvis_addActions;
    } else {
        call BZN_fnc_tacvis_stopAll;
    };
}];

// Mounting/dismounting an approved vehicle changes hasDevice but fires no
// inventory event, so re-evaluate on get in/out.
BZN_fnc_tacvis_refresh = {
    if (call BZN_fnc_tacvis_hasDevice or call BZN_fnc_tacvis_hasCQCDevice) then {
        call BZN_fnc_tacvis_addActions;
    } else {
        call BZN_fnc_tacvis_stopAll;
    };
};
player addEventHandler ["GetInMan",  { call BZN_fnc_tacvis_refresh }];
player addEventHandler ["GetOutMan", { call BZN_fnc_tacvis_refresh }];

if (BZN_tacvis_debug) then { systemChat "BZN TacVis - Initialized" };
