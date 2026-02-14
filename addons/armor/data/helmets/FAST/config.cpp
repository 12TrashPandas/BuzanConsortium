class CfgPatches
{
	class bzn_fast
	{
		author="Bzn Mod Dev Team, Yandere";
		addonRootClass="bzn_helmets";
		requiredAddons[]=
		{
			"A3_Aegis_Characters_F_Aegis_Headgear" //Aegis Headgear
		};
		units[]={};
	};
};

class CfgWeapons
{
	class Aegis_H_Helmet_FASTMT_tan_F;
	class Aegis_H_Helmet_FASTMT_Cover_tan_F;

	class Bzn_helmet_fastmt_urban : Aegis_H_Helmet_FASTMT_tan_F
	{
		author="Yandere";
		displayName="[Bzn] FASTMT Urban";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\helmets\FAST\data\H_HelmetFASTMT_urban2_CO.paa"
		};
	};

	class Bzn_helmet_fastmt_urban_tan : Bzn_helmet_fastmt_urban
	{
		displayName="[Bzn] FASTMT Urban, Tan";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\helmets\FAST\data\H_HelmetFASTMT_urban2_tan_CO.paa"
		};
	};

	class Bzn_helmet_fastmt_woodland : Bzn_helmet_fastmt_urban
	{
		displayName="[Bzn] FASTMT Woodland";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\helmets\FAST\data\H_HelmetFASTMT_woodland_CO.paa"
		};
	};

	class Bzn_helmet_fastmt_jungle : Bzn_helmet_fastmt_urban
	{
		displayName="[Bzn] FASTMT Jungle";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\helmets\FAST\data\H_HelmetFASTMT_jungle_CO.paa"
		};
	};

	class Bzn_helmet_fastmt_black : Bzn_helmet_fastmt_urban
	{
		displayName="[Bzn] FASTMT Black";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\helmets\FAST\data\H_HelmetFASTMT_black_CO.paa"
		};
	};

	class Bzn_helmet_fastmt_cover_urban : Aegis_H_Helmet_FASTMT_Cover_tan_F
	{
		displayName="[Bzn] FASTMT Urban (Cover)";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\helmets\FAST\data\H_HelmetFASTMT_urban2_CO.paa",
			"\z\bzn\addons\armor\data\helmets\FAST\data\H_HelmetFASTMT_Cover_urban_CO.paa",
			"\A3_Aegis\Characters_F_Aegis\Headgear\Data\H_HeadsetWest_tan_CO.paa"
		};
	};

	class Bzn_helmet_fastmt_cover_urban_tan : Bzn_helmet_fastmt_cover_urban
	{
		displayName="[Bzn] FASTMT Urban (Cover, Tan)";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\helmets\FAST\data\H_HelmetFASTMT_urban2_tan_CO.paa",
			"\z\bzn\addons\armor\data\helmets\FAST\data\H_HelmetFASTMT_Cover_urban_CO.paa",
			"\A3_Aegis\Characters_F_Aegis\Headgear\Data\H_HeadsetWest_tan_CO.paa"
		};
	};

	class Bzn_helmet_fastmt_cover_arid : Bzn_helmet_fastmt_cover_urban_tan
	{
		displayName="[Bzn] FASTMT Arid (Cover, Tan)";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\helmets\FAST\data\H_HelmetFASTMT_urban2_tan_CO.paa",
			"\z\bzn\addons\armor\data\helmets\FAST\data\H_HelmetFASTMT_Cover_arid_CO.paa",
			"\A3_Aegis\Characters_F_Aegis\Headgear\Data\H_HeadsetWest_tan_CO.paa"
		};
	};

	class Bzn_helmet_fastmt_cover_woodland : Bzn_helmet_fastmt_cover_urban_tan
	{
		displayName="[Bzn] FASTMT Woodland (Cover)";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\helmets\FAST\data\H_HelmetFASTMT_woodland_CO.paa",
			"\z\bzn\addons\armor\data\helmets\FAST\data\H_HelmetFASTMT_Cover_woodland_CO.paa",
			"\A3_Aegis\Characters_F_Aegis\Headgear\Data\H_HeadsetWest_oli_CO.paa"
		};
	};

	class Bzn_helmet_fastmt_cover_jungle : Bzn_helmet_fastmt_cover_urban_tan
	{
		displayName="[Bzn] FASTMT Jungle (Cover)";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\helmets\FAST\data\H_HelmetFASTMT_jungle_CO.paa",
			"\z\bzn\addons\armor\data\helmets\FAST\data\H_HelmetFASTMT_Cover_jungle_CO.paa",
			"\A3_Aegis\Characters_F_Aegis\Headgear\Data\H_HeadsetWest_oli_CO.paa"
		};
	};

	class Bzn_helmet_fastmt_cover_maritime : Bzn_helmet_fastmt_cover_urban_tan
	{
		displayName="[Bzn] FASTMT Maritime (Cover)";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\helmets\FAST\data\H_HelmetFASTMT_black_CO.paa",
			"\z\bzn\addons\armor\data\helmets\FAST\data\H_HelmetFASTMT_Cover_maritime_CO.paa",
			"\A3_Aegis\Characters_F_Aegis\Headgear\Data\H_HeadsetWest_blk_CO.paa"
		};
	};
};
