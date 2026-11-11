class CfgPatches
{
	class bzn_facewear_urban
	{
		author="Bzn Mod Dev Team, Yandere";
		addonRootClass="bzn_facewear";
		requiredAddons[]= {
			"bzn_armor",
		};
		units[]={};
		weapons[]={};
	};
};

class CfgGlasses
{
	class JCA_G_FaceMask_01_glasses_sand_F;

	class bzn_g_facemask_01_glasses_urban : JCA_G_FaceMask_01_glasses_sand_F
	{
		author = "Bzn Mod Dev Team";
		scope = 2;
		displayName = "Tactical Face Mask (Urban, Glasses)";
		picture = "\facewear_f_JCA_IE\data\G_FaceMask_01\UI\icon_G_FaceMask_01_glasses_sand_F_ca.paa";
		hiddenSelectionsTextures[] = {"z\bzn\addons\armor\data\facewear\urban\g_balaclava_01_urban_CO.paa","z\bzn\addons\armor\data\facewear\urban\g_glasses_urban_blue_CA.paa"};
	};

	class bzn_g_facemask_01_glasses_urban_clear : JCA_G_FaceMask_01_glasses_sand_F
	{
		author = "Bzn Mod Dev Team";
		scope = 2;
		displayName = "Tactical Face Mask (Urban, Glasses [clear])";
		picture = "\facewear_f_JCA_IE\data\G_FaceMask_01\UI\icon_G_FaceMask_01_glasses_sand_F_ca.paa";
		hiddenSelectionsTextures[] = {"z\bzn\addons\armor\data\facewear\urban\g_balaclava_01_urban_CO.paa","z\bzn\addons\armor\data\facewear\urban\g_glasses_urban_blue_clear_CA.paa"};
	};
};
