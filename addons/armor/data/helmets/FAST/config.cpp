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
			"\z\bzn\addons\armor\data\helmets\FAST\data\H_HelmetFASTMT_urban_CO.paa"
		};
	};

	class Bzn_helmet_fastmt_urban2 : Bzn_helmet_fastmt_urban
	{
		displayName="[Bzn] FASTMT Urban 2";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\helmets\FAST\data\H_HelmetFASTMT_urban2_CO.paa"
		};
	};

	class Bzn_helmet_fastmt_urban2_tan : Bzn_helmet_fastmt_urban
	{
		displayName="[Bzn] FASTMT Urban 2 Tan";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\helmets\FAST\data\H_HelmetFASTMT_urban2_tan_CO.paa"
		};
	};

	class Bzn_helmet_fastmt_cover_urban : Aegis_H_Helmet_FASTMT_Cover_tan_F
	{
		author="Yandere";
		displayName="[Bzn] FASTMT Urban (Cover)";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\helmets\FAST\data\H_HelmetFASTMT_urban_CO.paa",
			"\z\bzn\addons\armor\data\helmets\FAST\data\H_HelmetFASTMT_Cover_urban_CO.paa",
			"\A3_Aegis\Characters_F_Aegis\Headgear\Data\H_HeadsetWest_tan_CO.paa"
		};
	};

	class Bzn_helmet_fastmt_cover_urban2 : Bzn_helmet_fastmt_cover_urban
	{
		displayName="[Bzn] FASTMT Urban2 (Cover)";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\helmets\FAST\data\H_HelmetFASTMT_urban2_CO.paa",
			"\z\bzn\addons\armor\data\helmets\FAST\data\H_HelmetFASTMT_Cover_urban2_CO.paa",
			"\A3_Aegis\Characters_F_Aegis\Headgear\Data\H_HeadsetWest_tan_CO.paa"
		};
	};

	class Bzn_helmet_fastmt_cover_urban2_tan : Bzn_helmet_fastmt_cover_urban
	{
		displayName="[Bzn] FASTMT Urban2 (Cover)";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\helmets\FAST\data\H_HelmetFASTMT_urban2_tan_CO.paa",
			"\z\bzn\addons\armor\data\helmets\FAST\data\H_HelmetFASTMT_Cover_urban2_tan_CO.paa",
			"\A3_Aegis\Characters_F_Aegis\Headgear\Data\H_HeadsetWest_tan_CO.paa"
		};
	};
};
