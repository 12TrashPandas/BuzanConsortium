class CfgPatches {
    class bzn_tacvis {
        name = "BZN TacVis";
        units[] = {};
        weapons[] = {};
        requiredVersion = 2.0;
        requiredAddons[] = {};
        author = "Buzan Consortium Mod Team";
        version = "1.0.0";
    };
};

#include "config\CfgFunctions.hpp"

class RscTitles
{
	titles[] = {};
};

class CfgSounds
{
	sounds[] = {};

	#include "config\VTO_tacvis_fx.hpp"
};
