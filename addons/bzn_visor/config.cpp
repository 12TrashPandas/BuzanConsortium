class CfgPatches {
	class bzn_visor {
		name = "BZN VISOR";
		units[] = {"bzn_visor_moduleZeusMark"};
		weapons[] = {};
		requiredVersion = 2.0;
		requiredAddons[] = {"cba_settings", "A3_Modules_F"};
		author = "Buzan Consortium Mod Team";
		version = "1.0.0";
	};
};

#include "config\CfgFunctions.hpp"

class CfgFactionClasses {
	class NO_CATEGORY;
	class bzn_visor_zeusCategory: NO_CATEGORY {
		displayName = "BZN VISOR";
	};
};

class CfgVehicles {
	class Module_F;
	class bzn_visor_moduleZeusMark: Module_F {
		author = "Buzan Consortium Mod Team";
		scope = 1;          // hidden from Eden asset list
		scopeCurator = 2;   // visible/placeable in Zeus
		displayName = "Mark Enemy (VISOR)";
		category = "bzn_visor_zeusCategory";
		function = "BZN_fnc_visorZeusMark";
		functionPriority = 1;
		isGlobal = 0;
		isTriggerActivated = 0;
		isDisposable = 1;
	};
};

// Register CBA Addon Options via CBA's Extended preInit so they exist in both
// missions AND the Eden editor (BIS CfgFunctions preInit does not run in 3DEN).
class Extended_PreInit_EventHandlers
{
	class bzn_visor
	{
		init = "call compile preprocessFileLineNumbers 'z\bzn\addons\bzn_visor\XEH_preInit.sqf'";
	};
};

class RscTitles
{
	titles[] = {};

	// Fixed screen-space squad health HUD (PoC) — one structured-text control
	// that fn_visorSquadHUD.sqf retextures and repositions every second. The
	// onLoad stashes the control handle in uiNamespace so the update loop can
	// find it (and re-cut the layer if respawn/other titles ever wipe it).
	class BZN_visor_squadHealthHUD
	{
		idd = -1;
		duration = 1e+011; // effectively permanent; lifecycle is managed by the update loop
		fadeIn = 0;
		fadeOut = 0;
		onLoad = "uiNamespace setVariable ['BZN_visor_squadHealthHUD_ctrl', (_this select 0) displayCtrl 1100];";
		class controls
		{
			class SquadHealthText
			{
				idc = 1100;
				type = 13; // CT_STRUCTURED_TEXT
				style = 0;
				x = 0; y = 0; w = 0.25; h = 0.1; // placeholder — repositioned at runtime per the corner setting
				size = 0.04;
				text = "";
				colorBackground[] = {0, 0, 0, 0};
				class Attributes
				{
					align = "left";
					color = "#ffffff";
					font = "PuristaMedium";
					shadow = 1;
				};
			};
		};
	};
};

class CfgSounds
{
	sounds[] = {};

	#include "config\VTO_visor_fx.hpp"
};
