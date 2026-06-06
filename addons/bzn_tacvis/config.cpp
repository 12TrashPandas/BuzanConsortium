class CfgPatches {
    class bzn_tacvis {
        name = "BZN TacVis";
        units[] = {};
        weapons[] = {};
        requiredVersion = 2.0;
        requiredAddons[] = {"cba_settings"};
        author = "Buzan Consortium Mod Team";
        version = "1.0.0";
    };
};

#include "config\CfgFunctions.hpp"

// Register CBA Addon Options via CBA's Extended preInit so they exist in both
// missions AND the Eden editor (BIS CfgFunctions preInit does not run in 3DEN).
class Extended_PreInit_EventHandlers
{
    class bzn_tacvis
    {
        init = "call compile preprocessFileLineNumbers 'z\bzn\addons\bzn_tacvis\XEH_preInit.sqf'";
    };
};

class RscTitles
{
	titles[] = {};
};

class CfgSounds
{
	sounds[] = {};

	#include "config\VTO_tacvis_fx.hpp"
};
