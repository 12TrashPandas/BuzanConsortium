class CfgPatches {
	class bzn_visor {
		name = "BZN VISOR";
		units[] = {"bzn_visor_moduleZeusMark"};
		weapons[] = {};
		requiredVersion = 2.0;
		requiredAddons[] = {"cba_settings", "A3_Modules_F"};
		author = "[BZN] Disqordant";
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
		author = "[BZN] Disqordant";
		scope = 1;          // hidden from Eden asset list
		scopeCurator = 2;   // visible/placeable in Zeus
		displayName = "Mark Target (VISOR)";
		category = "bzn_visor_zeusCategory";
		// No module function: placement is caught client-side on the placing
		// curator's machine via a CuratorObjectPlaced handler (see
		// fn_VISORpostInit.sqf), which opens the configuration dialog below —
		// the server-side module-function path can't open UI.
		function = "";
		isGlobal = 0;
		isTriggerActivated = 0;
		isDisposable = 0; // the dialog flow deletes the logic itself (OK, Cancel, or ESC)
	};
};

// -------------------------------------------------------------------------
// Zeus "Mark Target (VISOR)" configuration dialog — opened on the placing
// curator's machine when the module is dropped (see fn_visorZeusMark.sqf).
// Three free-text context lines with a Red/Blue/Yellow colour choice each,
// plus an optional expiry timer. Base Rsc classes come from A3 ui_f.
// -------------------------------------------------------------------------
class RscText;
class RscEdit;
class RscCombo;
class RscCheckBox;
class RscButton;

class BZN_visor_ZeusMarkDialog
{
	idd = 46600;
	movingEnable = 0;
	onLoad = "uiNamespace setVariable ['BZN_visor_zeusMarkDisplay', _this select 0];";

	class controlsBackground
	{
		class Background: RscText
		{
			idc = -1;
			x = 0.30; y = 0.22; w = 0.40; h = 0.50;
			colorBackground[] = {0, 0, 0, 0.85};
		};
		class Title: RscText
		{
			idc = -1;
			text = "MARK TARGET (VISOR)";
			x = 0.31; y = 0.23; w = 0.38; h = 0.05;
			colorText[] = {0.3, 0.9, 1, 1};
		};
	};

	class controls
	{
		class Line1Label: RscText { idc = -1; text = "Line 1"; x = 0.31; y = 0.30; w = 0.08; h = 0.04; };
		class Line1Edit:  RscEdit { idc = 1601; x = 0.39; y = 0.30; w = 0.19; h = 0.04; };
		class Line1Color: RscCombo { idc = 1701; x = 0.59; y = 0.30; w = 0.10; h = 0.04; };

		class Line2Label: RscText { idc = -1; text = "Line 2"; x = 0.31; y = 0.36; w = 0.08; h = 0.04; };
		class Line2Edit:  RscEdit { idc = 1602; x = 0.39; y = 0.36; w = 0.19; h = 0.04; };
		class Line2Color: RscCombo { idc = 1702; x = 0.59; y = 0.36; w = 0.10; h = 0.04; };

		class Line3Label: RscText { idc = -1; text = "Line 3"; x = 0.31; y = 0.42; w = 0.08; h = 0.04; };
		class Line3Edit:  RscEdit { idc = 1603; x = 0.39; y = 0.42; w = 0.19; h = 0.04; };
		class Line3Color: RscCombo { idc = 1703; x = 0.59; y = 0.42; w = 0.10; h = 0.04; };

		class TimerCheck: RscCheckBox { idc = 1801; x = 0.31; y = 0.50; w = 0.04; h = 0.04; };
		class TimerLabel: RscText { idc = -1; text = "Timed mark — expires after (seconds):"; x = 0.36; y = 0.50; w = 0.24; h = 0.04; };
		class TimerSeconds: RscEdit { idc = 1802; text = "60"; x = 0.61; y = 0.50; w = 0.08; h = 0.04; };

		class OkButton: RscButton
		{
			idc = 1900;
			text = "MARK";
			x = 0.31; y = 0.62; w = 0.18; h = 0.05;
		};
		class CancelButton: RscButton
		{
			idc = 1901;
			text = "CANCEL";
			x = 0.51; y = 0.62; w = 0.18; h = 0.05;
		};
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
