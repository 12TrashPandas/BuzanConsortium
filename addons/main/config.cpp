#include "script_version.hpp"

class CfgPatches
{
	class bzn_main
	{
		name="main";
		author="Buzan Consortium Mod Team";
		requiredAddons[]=
		{
			"bzn_armor",
			"bzn_aax",
		};
		units[]={};
		VERSION_CONFIG;
	};
};

class CfgSettings
{
	class CBA{
		class versioning {// https://github.com/CBATeam/CBA_A3/wiki/Versioning-System
			class bzn_main {
				main_addon = "bzn_main";
			};
		};
	};
};
