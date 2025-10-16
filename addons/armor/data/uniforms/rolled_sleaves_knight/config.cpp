//The code for the uniforms is probably not the minimum it could be, feel free to experiment with removing stuff and see if it still works.
class CfgPatches
{
	class bzn_rs_knight
	{
		author="Bzn Mod Dev Team, Yandere";
		addonRootClass="bzn_uniforms";
		requiredAddons[]=
		{
			"bzn_rs",
		};
		units[]=
		{
			"Bzn_Field_Uniform_RS_Urban_Knight",
			"Bzn_Field_Uniform_RS_Winter_Knight",
			"Bzn_Field_Uniform_RS_Woodland_Knight",
			"Bzn_Field_Uniform_RS_Jungle_Knight",
			"Bzn_Field_Uniform_RS_Desert_Knight",
			"Bzn_Field_Uniform_RS_Maritime_Knight",
			"Bzn_Field_Uniform_Urban_Knight",
			"Bzn_Field_Uniform_Winter_Knight",
			"Bzn_Field_Uniform_Woodland_Knight",
			"Bzn_Field_Uniform_Jungle_Knight",
			"Bzn_Field_Uniform_Desert_Knight",
			"Bzn_Field_Uniform_Maritime_Knight",
			"Bzn_WI_Soldier_F_K",
			"Bzn_WI_Soldier_F_K_Woodland",
			"Bzn_WI_Soldier_F_K_Desert",
			"Bzn_WI_Soldier_F_K_Jungle",
			"Bzn_WI_Soldier_F_K_Winter",
			"Bzn_WI_Soldier_F_K_Maritime"
		};
		weapons[]=
		{
			"Bzn_W_I_CombatUniform_Knight",
			"Bzn_W_I_CombatUniform_Woodland_Knight",
			"Bzn_W_I_CombatUniform_Jungle_Knight",
			"Bzn_W_I_CombatUniform_Winter_Knight",
			"Bzn_W_I_CombatUniform_Desert_Knight",
			"Bzn_W_I_CombatUniform_Maritime_Knight",
			"Bzn_Field_Uniform_RS_F_Urban_Knight",
			"Bzn_Field_Uniform_RS_F_Winter_Knight",
			"Bzn_Field_Uniform_RS_F_Woodland_Knight",
			"Bzn_Field_Uniform_RS_F_Jungle_Knight",
			"Bzn_Field_Uniform_RS_F_Desert_Knight",
			"Bzn_Field_Uniform_RS_F_Maritime_Knight",
			"Bzn_Field_Uniform_F_K_Urban",
			"Bzn_Field_Uniform_F_K_Winter",
			"Bzn_Field_Uniform_F_K_Woodland",
			"Bzn_Field_Uniform_F_K_Jungle",
			"Bzn_Field_Uniform_F_K_Desert",
			"Bzn_Field_Uniform_F_K_Maritime"
		};
	};
};

class CfgVehicles
{
	class Bzn_WI_Soldier_F;

	//Female AAF Conversion
	class Bzn_WI_Soldier_F_K : Bzn_WI_Soldier_F
	{
		author="Yandere";
		_generalMacro="I_soldier_F";
		scope=2;
		scopeArsenal=2;
		scopeCurator=2;
		model="\Max_WS\WB_GEN_Commander_FG.p3d";
		editorSubcategory="Women_S";
		displayName="RifleWoman";
		uniformAccessories[]={};
		nakedUniform="max_female_U";
		uniformClass="Bzn_W_I_CombatUniform";
		class eventhandlers
		{
			init="P = [_this select 0] execVM ""max_WS\scripts\Identity.sqf"";";
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\urban\uniform_urban_k.paa"
		};
	};

	class Bzn_WI_Soldier_F_K_Maritime : Bzn_WI_Soldier_F_K
	{
		author="Yandere";
		_generalMacro="I_soldier_F";
		scope=2;
		scopeArsenal=2;
		scopeCurator=2;
		model="\Max_WS\WB_GEN_Commander_FG.p3d";
		editorSubcategory="Women_S";
		displayName="RifleWoman";
		uniformAccessories[]={};
		nakedUniform="max_female_U";
		uniformClass="Bzn_W_I_CombatUniform";
		class eventhandlers
		{
			init="P = [_this select 0] execVM ""max_WS\scripts\Identity.sqf"";";
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\maritime\uniform_maritime_k.paa"
		};
	};

	class Bzn_WI_Soldier_F_K_Woodland : Bzn_WI_Soldier_F_K
	{
		author="Yandere";
		_generalMacro="I_soldier_F";
		scope=2;
		scopeArsenal=2;
		scopeCurator=2;
		model="\Max_WS\WB_GEN_Commander_FG.p3d";
		editorSubcategory="Women_S";
		displayName="RifleWoman";
		uniformAccessories[]={};
		nakedUniform="max_female_U";
		uniformClass="Bzn_W_I_CombatUniform_Woodland";
		class eventhandlers
		{
			init="P = [_this select 0] execVM ""max_WS\scripts\Identity.sqf"";";
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\woodland\uniform_woodland_k.paa"
		};
	};

	class Bzn_WI_Soldier_F_K_Desert : Bzn_WI_Soldier_F_K
	{
		author="Yandere";
		_generalMacro="I_soldier_F";
		scope=2;
		scopeArsenal=2;
		scopeCurator=2;
		model="\Max_WS\WB_GEN_Commander_FG.p3d";
		editorSubcategory="Women_S";
		displayName="RifleWoman";
		uniformAccessories[]={};
		nakedUniform="max_female_U";
		uniformClass="Bzn_W_I_CombatUniform_Desert";
		class eventhandlers
		{
			init="P = [_this select 0] execVM ""max_WS\scripts\Identity.sqf"";";
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\desert\uniform_desert_k.paa"
		};
	};

	class Bzn_WI_Soldier_F_K_Jungle : Bzn_WI_Soldier_F_K
	{
		author="Yandere";
		_generalMacro="I_soldier_F";
		scope=2;
		scopeArsenal=2;
		scopeCurator=2;
		model="\Max_WS\WB_GEN_Commander_FG.p3d";
		editorSubcategory="Women_S";
		displayName="RifleWoman";
		uniformAccessories[]={};
		nakedUniform="max_female_U";
		uniformClass="Bzn_W_I_CombatUniform_Jungle";
		class eventhandlers
		{
			init="P = [_this select 0] execVM ""max_WS\scripts\Identity.sqf"";";
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\jungle\uniform_jungle_k.paa"
		};
	};

	class Bzn_WI_Soldier_F_K_Winter : Bzn_WI_Soldier_F_K
	{
		author="Yandere";
		_generalMacro="I_soldier_F";
		scope=2;
		scopeArsenal=2;
		scopeCurator=2;
		model="\Max_WS\WB_GEN_Commander_FG.p3d";
		editorSubcategory="Women_S";
		displayName="RifleWoman";
		uniformAccessories[]={};
		nakedUniform="max_female_U";
		uniformClass="Bzn_W_I_CombatUniform_Winter";
		class eventhandlers
		{
			init="P = [_this select 0] execVM ""max_WS\scripts\Identity.sqf"";";
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\winter\uniform_winter_k.paa"
		};
	};

	class Bzn_Field_Uniform_RS_Urban;
	class Bzn_Field_Uniform_RS_Urban_Knight : Bzn_Field_Uniform_RS_Urban
	{
		author="Yandere";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\urban\uniform_urban_k.paa"
		};
	};


	class Bzn_Field_Uniform_RS_Winter_Knight : Bzn_Field_Uniform_RS_Urban_Knight
	{
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\winter\uniform_winter_k.paa"
		};

	};

	class Bzn_Field_Uniform_RS_Desert_Knight : Bzn_Field_Uniform_RS_Urban_Knight
	{
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\desert\uniform_desert_k.paa"
		};
	};

	class Bzn_Field_Uniform_RS_Jungle_Knight : Bzn_Field_Uniform_RS_Urban_Knight
	{
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\jungle\uniform_jungle_k.paa"
		};
	};

	class Bzn_Field_Uniform_RS_Woodland_Knight : Bzn_Field_Uniform_RS_Urban_Knight
	{
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\woodland\uniform_woodland_k.paa"
		};
	};

	class Bzn_Field_Uniform_RS_Maritime_Knight : Bzn_Field_Uniform_RS_Urban_Knight
	{
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\maritime\uniform_maritime_k.paa"
		};
	};

	class Bzn_Field_Uniform_Urban;
	class Bzn_Field_Uniform_Urban_Knight : Bzn_Field_Uniform_Urban
	{
		author="Yandere";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\urban\uniform_urban_k.paa"
		};
	};

	class Bzn_Field_Uniform_Winter_Knight : Bzn_Field_Uniform_Urban_Knight
	{
		author="Yandere";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\winter\uniform_winter_k.paa"
		};
	};

	class Bzn_Field_Uniform_Woodland_Knight : Bzn_Field_Uniform_Urban_Knight
	{
		author="Yandere";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\woodland\uniform_woodland_k.paa"
		};
	};

	class Bzn_Field_Uniform_Jungle_Knight : Bzn_Field_Uniform_Urban_Knight
	{
		author="Yandere";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\jungle\uniform_jungle_k.paa"
		};
	};

	class Bzn_Field_Uniform_Desert_Knight : Bzn_Field_Uniform_Urban_Knight
	{
		author="Yandere";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\desert\uniform_desert_k.paa"
		};
	};

	class Bzn_Field_Uniform_Maritime_Knight : Bzn_Field_Uniform_Urban_Knight
	{
		author="Yandere";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\maritime\uniform_maritime_k.paa"
		};
	};
};

class CfgWeapons
{
	class Bzn_W_I_CombatUniform;
	class UniformItem;
	class Bzn_W_I_CombatUniform_Knight : Bzn_W_I_CombatUniform
	{
		author="Yandere";
		scope=2;
		displayName="Combat Fatigues Woman [Bzn] (Urban, Knight)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_universal_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\urban\uniform_urban_k.paa",
		};
		class ItemInfo: UniformItem
		{
			uniformModel="-";
			uniformClass="Bzn_WI_Soldier_F_K";
			containerClass="Supply40";
			mass=40;
		};
		class XtdGearInfos
		{
			model="Bzn_W_I_CombatUniform";
			element="Knight";
			camo="Urban";
		};
	};

	class Bzn_W_I_CombatUniform_Maritime_Knight : Bzn_W_I_CombatUniform_Knight
	{
		author="Yandere";
		scope=2;
		displayName="Combat Fatigues Woman [Bzn] (Maritime, Knight)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_universal_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\maritime\uniform_maritime_k.paa",
		};
		class ItemInfo: UniformItem
		{
			uniformModel="-";
			uniformClass="Bzn_WI_Soldier_F_K_Maritime";
			containerClass="Supply40";
			mass=40;
		};
	};

	class Bzn_W_I_CombatUniform_Woodland_Knight : Bzn_W_I_CombatUniform_Knight
	{
		author="Yandere";
		scope=2;
		displayName="Combat Fatigues Woman [Bzn] (Woodland, Knight)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_universal_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\woodland\uniform_woodland_k.paa",
		};
		class ItemInfo: UniformItem
		{
			uniformModel="-";
			uniformClass="Bzn_WI_Soldier_F_K_Woodland";
			containerClass="Supply40";
			mass=40;
		};
	};

	class Bzn_W_I_CombatUniform_Desert_Knight : Bzn_W_I_CombatUniform_Knight
	{
		author="Yandere";
		scope=2;
		displayName="Combat Fatigues Woman [Bzn] (Desert, Knight)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_universal_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\desert\uniform_desert_k.paa",
		};
		class ItemInfo: UniformItem
		{
			uniformModel="-";
			uniformClass="Bzn_WI_Soldier_F_K_Desert";
			containerClass="Supply40";
			mass=40;
		};
	};

	class Bzn_W_I_CombatUniform_Jungle_Knight : Bzn_W_I_CombatUniform_Knight
	{
		author="Yandere";
		scope=2;
		displayName="Combat Fatigues Woman [Bzn] (Jungle, Knight)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_universal_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\jungle\uniform_jungle_k.paa",
		};
		class ItemInfo: UniformItem
		{
			uniformModel="-";
			uniformClass="Bzn_WI_Soldier_F_K_Jungle";
			containerClass="Supply40";
			mass=40;
		};
	};

	class Bzn_W_I_CombatUniform_Winter_Knight : Bzn_W_I_CombatUniform_Knight
	{
		author="Yandere";
		scope=2;
		displayName="Combat Fatigues Woman [Bzn] (Winter, Knight)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_universal_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\winter\uniform_winter_k.paa",
		};
		class ItemInfo: UniformItem
		{
			uniformModel="-";
			uniformClass="Bzn_WI_Soldier_F_K_Winter";
			containerClass="Supply40";
			mass=40;
		};
	};

	class Bzn_Field_Uniform_RS_F_Urban;
	class Bzn_Field_Uniform_RS_F_Urban_Knight : Bzn_Field_Uniform_RS_F_Urban
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Urban, Rolled Up, Gloves, Knight)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\urban\uniform_urban_k.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_RS_Urban_Knight";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};


	class Bzn_Field_Uniform_RS_F_Winter_Knight : Bzn_Field_Uniform_RS_F_Urban_Knight
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Winter, Rolled Up, Gloves, Knight)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\winter\uniform_winter_k.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_RS_Winter_Knight";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_RS_F_Desert_Knight : Bzn_Field_Uniform_RS_F_Urban_Knight
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Desert, Rolled Up, Gloves, Knight)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\desert\uniform_desert_k.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_RS_Desert_Knight";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_RS_F_Jungle_Knight : Bzn_Field_Uniform_RS_F_Urban_Knight
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Jungle, Rolled Up, Gloves, Knight)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\jungle\uniform_jungle_k.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_RS_Jungle_Knight";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_RS_F_Woodland_Knight : Bzn_Field_Uniform_RS_F_Urban_Knight
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Woodland, Rolled Up, Gloves, Knight)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\woodland\uniform_woodland_k.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_RS_Woodland_Knight";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_RS_F_Maritime_Knight : Bzn_Field_Uniform_RS_F_Urban_Knight
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Maritime, Rolled Up, Gloves, Knight)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\maritime\uniform_maritime_k.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_RS_Maritime_Knight";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_F_Urban;
	class Bzn_Field_Uniform_F_Urban_Knight : Bzn_Field_Uniform_F_Urban
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Urban, Knight)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\urban\uniform_urban_k.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_Urban_Knight";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_F_Winter_Knight : Bzn_Field_Uniform_RS_F_Urban
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Winter, Knight)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\winter\uniform_winter_k.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_Winter_Knight";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_F_Desert_Knight : Bzn_Field_Uniform_RS_F_Urban
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Desert, Knight)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\desert\uniform_desert_k.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_Desert_Knight";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_F_Jungle_Knight : Bzn_Field_Uniform_RS_F_Urban
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Jungle, Knight)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\jungle\uniform_jungle_k.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_Jungle_Knight";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_F_Woodland_Knight : Bzn_Field_Uniform_RS_F_Urban
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Woodland, Knight)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\woodland\uniform_woodland_k.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_Woodland_Knight";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_F_Maritime_Knight : Bzn_Field_Uniform_RS_F_Urban
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Maritime, Knight)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_knight\maritime\uniform_maritime_k.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_Maritime_Knight";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};
};
