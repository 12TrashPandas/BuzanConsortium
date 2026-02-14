class CfgPatches
{
	class bzn_cup_ess
	{
		author="Bzn Mod Dev Team, Yandere";
		addonRootClass="bzn_helmets";
		requiredAddons[]=
		{
			"CUP_Creatures_Military_USArmy", //CUP_Units -> US_Army
		};
		units[]={};
	};
};

class CfgGlasses
{
	class CUP_G_ESS_BLK_Scarf_Face_White;
	class Bzn_G_ESS_BLK_Scarf_Face_Urban : CUP_G_ESS_BLK_Scarf_Face_White
	{
		author="Yandere";
		dlc="Bzn Armor";
		displayname = "ESS Goggles w/ Neckscarf Face (Urban)";
		hiddenSelectionsTextures[] = {"\CUP\Creatures\People\Military\CUP_Creatures_People_Military_USArmy\data\h_gear_01_blk_co.paa","\CUP\Creatures\People\Military\CUP_Creatures_People_Military_USArmy\data\glass_clear_ca.paa","\z\bzn\addons\armor\data\facewear\cup_ess\shemagh_face_urban_co.paa"};
	};

	class Bzn_G_ESS_BLK_Scarf_Face_Custom_Witch : Bzn_G_ESS_BLK_Scarf_Face_Urban
	{
		displayname = "ESS Goggles w/ Neckscarf Face (Witch)";
		hiddenSelectionsTextures[] = {"\CUP\Creatures\People\Military\CUP_Creatures_People_Military_USArmy\data\h_gear_01_blk_co.paa","\CUP\Creatures\People\Military\CUP_Creatures_People_Military_USArmy\data\glass_clear_ca.paa","\z\bzn\addons\armor\data\facewear\cup_ess\shemagh_face_custom_witch_co.paa"};
	};
};
