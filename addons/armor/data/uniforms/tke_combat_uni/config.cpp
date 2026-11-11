class CfgPatches
{
	class bzn_tke
	{
		author="Bzn Mod Dev Team, Yandere";
		addonRootClass="bzn_uniforms";
		requiredAddons[]=
		{
			"A3_Characters_F","TKE_Uniform_Revamp","TKE_Dress"
		};
		units[]={
			"bzn_tke_combatuni_f_urabn","B_Uniform_ParadeUniform_01_BZN_F",
		};
		weapons[]={
			"bzn_combatuni_U_B","U_B_ParadeUniform_01_BZN_F",
		};
	};
};

class CfgVehicles
{
	class TKE_CombatUni_base;

	class bzn_tke_combatuni_f_urabn : TKE_CombatUni_base
	{
		author = "Bzn Mod Dev Team";
		scope=2;
		scopecurator=2;
		scopearsenal=2;
		hiddenSelections[]=
		{
			"camo","camo1"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\tke_combat_uni\BznTKECombatUniBottom_CO.paa",// Path to your own textures
			"\z\bzn\addons\armor\data\uniforms\tke_combat_uni\BznTKECombatUniTop_CO.paa"// Path to your own textures
		};
		side=1;
		displayName="[BZN] UCCU-50 (Urban)";
		backpack="";
		uniformClass="bzn_combatuni_U_B";
	};

	class B_Uniform_ParadeUniform_01_UCFA_F;
	class B_Uniform_ParadeUniform_01_BZN_F : B_Uniform_ParadeUniform_01_UCFA_F
	{
		author = "Bzn Mod Dev Team";
		scope = 1;
		uniformClass = "U_B_ParadeUniform_01_BZN_F";
		hiddenSelectionsTextures[] = {"\z\bzn\addons\armor\data\uniforms\tke_combat_uni\ParadeUniform_01_BZN_CO.paa","","TKE_Dress\Textures\ParadeUniform_Decorated_01_UCN_CO.paa"};
	};
};

class CfgWeapons
{
	class TKE_CombatUni_U_OP;
	class ItemInfo;

	class bzn_combatuni_U_B : TKE_CombatUni_U_OP
	{
		author="Bzn Mod Dev Team";
		scope=2;
		allowedSlots[]=
		{
			"BACKPACK_SLOT"
		};
		displayName="[BZN] UCCU-50";
		picture="z\bzn\addons\armor\data\BuzanPatch.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_blufor_soldier";
		class ItemInfo: ItemInfo
		{
			uniformModel="-";
			uniformClass="bzn_tke_combatuni_f_urabn";
			containerClass="Supply90";
			mass=80;
		};
	};

	class U_B_ParadeUniform_01_UCFA_F;
	class UniformItem;
	class U_B_ParadeUniform_01_BZN_F : U_B_ParadeUniform_01_UCFA_F
	{
		author = "Bzn Mod Dev Team";
		scope = 2;
		scopearsenal = 2;
		displayName = "[BZN] Dress Uniform";
		picture = "z\bzn\addons\armor\data\BuzanPatch.paa";
		DLC = "BZN";
		class ItemInfo: UniformItem
		{
			uniformModel = "-";
			uniformClass = "B_Uniform_ParadeUniform_01_BZN_F";
			containerClass = "Supply20";
			mass = 30;
		};
	};
};
