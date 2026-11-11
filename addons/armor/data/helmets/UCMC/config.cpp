class CfgPatches
{
	class bzn_ucmc
	{
		author="Bzn Mod Dev Team, Yandere";
		addonRootClass="bzn_helmets";
		requiredAddons[]=
		{
			"TKE_UCN"
		};
		units[]={};
		weapons[]={"bzn_helm_ach",};
	};
};

class CfgWeapons
{
	class TKE_UCMCHelm;
	class bzn_helm_ach : TKE_UCMCHelm
	{
		author = "Bzn Mod Dev Team";
		scope = 2;
		displayName = "[BZN] ACH-22/50";
		picture="z\addons\armor\data\BuzanPatch.paa";
		hiddenSelectionsTextures[] = {"z\bzn\addons\armor\data\helmets\UCMC\urban\P3D__tke_ucmchelm_co.paa___tke_ucmchelm.rvmat_CO.paa"};
	};
};
