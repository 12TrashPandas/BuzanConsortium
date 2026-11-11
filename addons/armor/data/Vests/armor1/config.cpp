class CfgPatches
{
	class bzn_tke_vests
	{
		author="Bzn Mod Dev Team, Yandere";
		addonRootClass="bzn_vests";
		requiredAddons[]=
		{
			"A3_Characters_F","TKE_UCN"
		};
		weapons[]={
			"bzn_armor_urban","bzn_armor_urban_ns","bzn_armor_urban_3_1","bzn_armor_urban_3_2","bzn_armor_urban_4_1","bzn_armor_urban_4_2","bzn_armor_urban_1","bzn_armor_urban_5_1","bzn_armor_urban_5_2","bzn_armor_urban_6_1","bzn_armor_urban_6_2","bzn_armor_urban_6_3","bzn_armor_urban_6_4"
		};
	};
};

class CfgWeapons
{
	class TKE_UCMCArmour1;
	class bzn_armor_urban_1 : TKE_UCMCArmour1
	{
		author = "Bzn Mod Dev Team";
		scope = 2;
		displayName = "[BZN] AIBA Standard Issue (Urban)";
		picture = "\z\addons\armor\data\BuzanPatch.paa";
		hiddenSelections[] = {"camo","camo1"};
		hiddenSelectionsTextures[] = {"\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmor_Co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCArmourP_co.paa"};
	};

	class TKE_UCMCArmour2_1;
	class bzn_armor_urban : TKE_UCMCArmour2_1
	{
		author = "Bzn Mod Dev Team";
		scope = 2;
		displayName = "[BZN] AIBA Heavy Vest (Urban)";
		picture = "\z\addons\armor\data\BuzanPatch.paa";
		hiddenSelections[] = {"camo","camo1","camo2","camo3","camo4","camo5","camo6"};
		hiddenSelectionsTextures[] = {"\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmor_Co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCArmourP_co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCPouches_co.paa","\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmorAddon_Co.paa","\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmorAddon_Co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCArmourP_co.paa","\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmor_Co.paa"};
	};

	class TKE_UCMCArmour2_2;
	class bzn_armor_urban_ns : TKE_UCMCArmour2_2
	{
		author = "Bzn Mod Dev Team";
		scope = 2;
		displayName = "[BZN] AIBA Vest (Urban)";
		picture = "\z\addons\armor\data\BuzanPatch.paa";
		hiddenSelections[] = {"camo","camo1","camo2","camo3"};
		hiddenSelectionsTextures[] = {"\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmor_Co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCArmourP_co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCPouches_co.paa",""};
	};

	class TKE_UCMCArmour3_1;
	class bzn_armor_urban_3_1 : TKE_UCMCArmour3_1
	{
		author = "Bzn Mod Dev Team";
		scope = 2;
		displayName = "[BZN] AIBA Vest V2 (Urban)";
		picture = "\z\addons\armor\data\BuzanPatch.paa";
		hiddenSelections[] = {"camo","camo1","camo2","camo3"};
		hiddenSelectionsTextures[] = {"\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmor_Co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCArmourP_co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCPouches_co.paa",""};
	};

	class TKE_UCMCArmour3_2;
	class bzn_armor_urban_3_2 : TKE_UCMCArmour3_2
	{
		author = "Bzn Mod Dev Team";
		scope = 2;
		displayName = "[BZN] AIBA Heavy Vest V2 (Urban)";
		picture = "\z\addons\armor\data\BuzanPatch.paa";
		hiddenSelections[] = {"camo","camo1","camo2","camo3","camo4","camo5","camo6"};
		hiddenSelectionsTextures[] = {"\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmor_Co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCArmourP_co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCPouches_co.paa","\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmorAddon_Co.paa","\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmorAddon_Co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCArmourP_co.paa","\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmor_Co.paa"};
	};

	class TKE_UCMCArmour4_1;
	class bzn_armor_urban_4_1 : TKE_UCMCArmour4_1
	{
		author = "Bzn Mod Dev Team";
		scope = 2;
		displayName = "[BZN] AIBA Heavy Vest V3 (Urban)";
		picture = "z\addons\armor\data\BuzanPatch.paa";
		hiddenSelections[] = {"camo","camo1","camo2","camo3","camo4","camo5","camo6","camo7","camo8"};
		hiddenSelectionsTextures[] = {"\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmor_Co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCArmourP_co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCPouches_co.paa","\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmorAddon_Co.paa","\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmorAddon_Co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCArmourP_co.paa","\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmor_Co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCNExtras_co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_BinoUCN_co.paa"};
	};

	class TKE_UCMCArmour4_2;
	class bzn_armor_urban_4_2 : TKE_UCMCArmour4_2
	{
		author = "Bzn Mod Dev Team";
		scope = 2;
		displayName = "[BZN] AIBA Vest V3 (Urban)";
		picture = "\z\addons\armor\data\BuzanPatch.paa";
		hiddenSelections[] = {"camo","camo1","camo2","camo3","camo7","camo8"};
		hiddenSelectionsTextures[] = {"\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmor_Co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCArmourP_co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCPouches_co.paa","","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCNExtras_co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_BinoUCN_co.paa"};
	};

	class TKE_UCMCArmour5_1;
	class bzn_armor_urban_5_1 : TKE_UCMCArmour5_1
	{
		author = "Bzn Mod Dev Team";
		scope = 2;
		displayName = "[BZN] AIBA Heavy Vest V4 (Urban)";
		picture = "\z\addons\armor\data\BuzanPatch.paa";
		hiddenSelections[] = {"camo","camo1","camo2","camo3","camo4","camo5","camo6"};
		hiddenSelectionsTextures[] = {"\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmor_Co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCArmourP_co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCPouches_co.paa","\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmorAddon_Co.paa","\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmorAddon_Co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCArmourP_co.paa","\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmor_Co.paa"};
	};

	class TKE_UCMCArmour5_2;
	class bzn_armor_urban_5_2 : TKE_UCMCArmour5_2
	{
		author = "Bzn Mod Dev Team";
		scope = 2;
		displayName = "[BZN] AIBA Vest V4 (Urban)";
		picture = "\z\addons\armor\data\BuzanPatch.paa";
		hiddenSelections[] = {"camo","camo1","camo2","camo3"};
		hiddenSelectionsTextures[] = {"\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmor_Co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCArmourP_co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCPouches_co.paa",""};
	};

	class TKE_UCMCArmour6_1;
	class bzn_armor_urban_6_1 : TKE_UCMCArmour6_1
	{
		author = "Bzn Mod Dev Team";
		scope = 2;
		displayName = "[BZN] AIBA Medium Vest V1 (Urban)";
		picture = "\z\addons\armor\data\BuzanPatch.paa";
		hiddenSelectionsTextures[] = {"\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmor_Co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCArmourP_co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCPouches_co.paa","","\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmorAddon_Co.paa"};
	};

	class TKE_UCMCArmour6_2;
	class bzn_armor_urban_6_2 : TKE_UCMCArmour6_2
	{
		author = "Bzn Mod Dev Team";
		scope = 2;
		displayName = "[BZN] AIBA Medium Vest V2 (Urban)";
		picture = "\z\addons\armor\data\BuzanPatch.paa";
		hiddenSelectionsTextures[] = {"\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmor_Co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCArmourP_co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCPouches_co.paa","","\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmorAddon_Co.paa"};
	};

	class TKE_UCMCArmour6_3;
	class bzn_armor_urban_6_3 : TKE_UCMCArmour6_3
	{
		author = "Bzn Mod Dev Team";
		scope = 2;
		displayName = "[BZN] AIBA Medium Vest V3 (Urban)";
		picture = "\z\addons\armor\data\BuzanPatch.paa";
		hiddenSelectionsTextures[] = {"\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmor_Co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCArmourP_co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCPouches_co.paa","","\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmorAddon_Co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCNExtras_co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_BinoUCN_co.paa"};
	};

	class TKE_UCMCArmour6_4;
	class bzn_armor_urban_6_4 : TKE_UCMCArmour6_4
	{
		author = "Bzn Mod Dev Team";
		scope = 2;
		displayName = "[BZN] AIBA Medium Vest V4 (Urban)";
		picture = "\z\addons\armor\data\BuzanPatch.paa";
		hiddenSelectionsTextures[] = {"\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmor_Co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCArmourP_co.paa","\TKE_Kuiper_Engagements\TKE_UCN\data\TKE_UCMCPouches_co.paa","","\z\bzn\addons\armor\data\Vests\armor1\urban\BznArmorAddon_Co.paa"};
	};
};
