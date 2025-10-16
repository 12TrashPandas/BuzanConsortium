class CfgPatches
{
	class bzn_aax
	{
		author="bzn Mod Dev Team, Yandere";
		requiredAddons[]=
		{
			"bzn_armor",
			"aceax_gearinfo", // Ace Arsenal Extended
			"bzn_rs",
			"bzn_rs_queen",
			"bzn_rs_knight"
		};
		units[]={};
		skipWhenMissingDependencies = 1;
	};
};

class XtdGearModels
{
	#include "data\aax_models.hpp"
};

class XtdGearInfos
{
	#include "data\aax_infos.hpp"
};
