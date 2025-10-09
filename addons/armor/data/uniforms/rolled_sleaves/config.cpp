//The code for the uniforms is probably not the minimum it could be, feel free to experiment with removing stuff and see if it still works.
class CfgPatches
{
	class bzn_rs
	{
		author="Bzn Mod Dev Team, Yandere";
		addonRootClass="bzn_uniforms";
		requiredAddons[]=
		{
			"bzn_uniforms",
			"A3_Characters_F",
			"Max_WS"
		};
		units[]=
		{
			"Bzn_Field_Uniform_RS_Urban",
			"Bzn_Field_Uniform_RS_Winter",
			"Bzn_Field_Uniform_RS_Woodland",
			"Bzn_Field_Uniform_RS_Jungle",
			"Bzn_Field_Uniform_RS_Desert",
			"Bzn_Field_Uniform_RS_Maritime",
			"Bzn_Field_Uniform_Urban",
			"Bzn_Field_Uniform_Winter",
			"Bzn_Field_Uniform_Woodland",
			"Bzn_Field_Uniform_Jungle",
			"Bzn_Field_Uniform_Desert",
			"Bzn_Field_Uniform_Maritime",
			"Bzn_WI_Soldier_F",
			"Bzn_WI_Soldier_F_Woodland",
			"Bzn_WI_Soldier_F_Desert",
			"Bzn_WI_Soldier_F_Jungle",
			"Bzn_WI_Soldier_F_Winter",
			"Bzn_WI_Soldier_F_Maritime"
		};
		weapons[]=
		{
			"Bzn_W_I_CombatUniform",
			"Bzn_W_I_CombatUniform_Woodland",
			"Bzn_W_I_CombatUniform_Jungle",
			"Bzn_W_I_CombatUniform_Winter",
			"Bzn_W_I_CombatUniform_Desert",
			"Bzn_W_I_CombatUniform_Maritime",
			"Bzn_Field_Uniform_RS_F_Urban",
			"Bzn_Field_Uniform_RS_F_Winter",
			"Bzn_Field_Uniform_RS_F_Woodland",
			"Bzn_Field_Uniform_RS_F_Jungle",
			"Bzn_Field_Uniform_RS_F_Desert",
			"Bzn_Field_Uniform_RS_F_Maritime",
			"Bzn_Field_Uniform_F_Urban",
			"Bzn_Field_Uniform_F_Winter",
			"Bzn_Field_Uniform_F_Woodland",
			"Bzn_Field_Uniform_F_Jungle",
			"Bzn_Field_Uniform_F_Desert",
			"Bzn_Field_Uniform_F_Maritime"
		};
	};
};

class CfgVehicles
{
	class I_soldier_F;
	class I_Soldier_lite_F;

	//Female AAF Conversion
	class WI_soldier_F;
	class Bzn_WI_Soldier_F : WI_soldier_F
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
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\urban\uniform_urban.paa"
		};
	};

	class Bzn_WI_Soldier_F_Maritime : WI_soldier_F
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
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\maritime\uniform_maritime.paa"
		};
	};

	class Bzn_WI_Soldier_F_Woodland : Bzn_WI_Soldier_F
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
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\woodland\uniform_woodland.paa"
		};
	};

	class Bzn_WI_Soldier_F_Desert : Bzn_WI_Soldier_F
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
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\desert\uniform_desert.paa"
		};
	};

	class Bzn_WI_Soldier_F_Jungle : Bzn_WI_Soldier_F
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
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\jungle\uniform_jungle.paa"
		};
	};

	class Bzn_WI_Soldier_F_Winter : Bzn_WI_Soldier_F
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
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\winter\uniform_winter.paa"
		};
	};

	class Bzn_Field_Uniform_RS_Urban : I_Soldier_lite_F
	{
		author="Yandere";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\urban\uniform_urban.paa"
		};
	};


	class Bzn_Field_Uniform_RS_Winter : Bzn_Field_Uniform_RS_Urban
	{
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\winter\uniform_winter.paa"
		};

	};

	class Bzn_Field_Uniform_RS_Desert : Bzn_Field_Uniform_RS_Urban
	{
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\desert\uniform_desert.paa"
		};
	};

	class Bzn_Field_Uniform_RS_Jungle : Bzn_Field_Uniform_RS_Urban
	{
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\jungle\uniform_jungle.paa"
		};
	};

	class Bzn_Field_Uniform_RS_Woodland : Bzn_Field_Uniform_RS_Urban
	{
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\woodland\uniform_woodland.paa"
		};
	};

	class Bzn_Field_Uniform_RS_Maritime : Bzn_Field_Uniform_RS_Urban
	{
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\maritime\uniform_maritime.paa"
		};
	};

	class Bzn_Field_Uniform_Urban : I_soldier_F
	{
		author="Yandere";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\urban\uniform_urban.paa"
		};
	};

	class Bzn_Field_Uniform_Winter : Bzn_Field_Uniform_Urban
	{
		author="Yandere";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\winter\uniform_winter.paa"
		};
	};

	class Bzn_Field_Uniform_Woodland : Bzn_Field_Uniform_Urban
	{
		author="Yandere";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\woodland\uniform_woodland.paa"
		};
	};

	class Bzn_Field_Uniform_Jungle : Bzn_Field_Uniform_Urban
	{
		author="Yandere";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\jungle\uniform_jungle.paa"
		};
	};

	class Bzn_Field_Uniform_Desert : Bzn_Field_Uniform_Urban
	{
		author="Yandere";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\desert\uniform_desert.paa"
		};
	};

	class Bzn_Field_Uniform_Maritime : Bzn_Field_Uniform_Urban
	{
		author="Yandere";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\maritime\uniform_maritime.paa"
		};
	};
};

class CfgWeapons
{
	class U_I_CombatUniform;
	class UniformItem;
	class U_I_CombatUniform_shortsleeve;
	class WU_I_CombatUniform;

	class Bzn_W_I_CombatUniform : WU_I_CombatUniform
	{
		author="Yandere";
		scope=2;
		displayName="Combat Fatigues Woman [Bzn] (Urban)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_universal_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\urban\uniform_urban.paa",
		};
		class ItemInfo: UniformItem
		{
			uniformModel="-";
			uniformClass="Bzn_WI_Soldier_F";
			containerClass="Supply40";
			mass=40;
		};
	};

	class Bzn_W_I_CombatUniform_Maritime : WU_I_CombatUniform
	{
		author="Yandere";
		scope=2;
		displayName="Combat Fatigues Woman [Bzn] (Maritime)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_universal_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\maritime\uniform_maritime.paa",
		};
		class ItemInfo: UniformItem
		{
			uniformModel="-";
			uniformClass="Bzn_WI_Soldier_F_Maritime";
			containerClass="Supply40";
			mass=40;
		};
	};

	class Bzn_W_I_CombatUniform_Woodland : WU_I_CombatUniform
	{
		author="Yandere";
		scope=2;
		displayName="Combat Fatigues Woman [Bzn] (Woodland)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_universal_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\woodland\uniform_woodland.paa",
		};
		class ItemInfo: UniformItem
		{
			uniformModel="-";
			uniformClass="Bzn_WI_Soldier_F_Woodland";
			containerClass="Supply40";
			mass=40;
		};
	};

	class Bzn_W_I_CombatUniform_Desert : WU_I_CombatUniform
	{
		author="Yandere";
		scope=2;
		displayName="Combat Fatigues Woman [Bzn] (Desert)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_universal_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\desert\uniform_desert.paa",
		};
		class ItemInfo: UniformItem
		{
			uniformModel="-";
			uniformClass="Bzn_WI_Soldier_F_Desert";
			containerClass="Supply40";
			mass=40;
		};
	};

	class Bzn_W_I_CombatUniform_Jungle : WU_I_CombatUniform
	{
		author="Yandere";
		scope=2;
		displayName="Combat Fatigues Woman [Bzn] (Jungle)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_universal_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\jungle\uniform_jungle.paa",
		};
		class ItemInfo: UniformItem
		{
			uniformModel="-";
			uniformClass="Bzn_WI_Soldier_F_Jungle";
			containerClass="Supply40";
			mass=40;
		};
	};

	class Bzn_W_I_CombatUniform_Winter : WU_I_CombatUniform
	{
		author="Yandere";
		scope=2;
		displayName="Combat Fatigues Woman [Bzn] (Winter)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_universal_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\jungle\uniform_jungle.paa",
		};
		class ItemInfo: UniformItem
		{
			uniformModel="-";
			uniformClass="Bzn_WI_Soldier_F_Winter";
			containerClass="Supply40";
			mass=40;
		};
	};

	class Bzn_Field_Uniform_RS_F_Urban : U_I_CombatUniform_shortsleeve
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Urban, Rolled Up, Gloves)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\urban\uniform_urban.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_RS_Urban";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};


	class Bzn_Field_Uniform_RS_F_Winter : Bzn_Field_Uniform_RS_F_Urban
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Winter, Rolled Up, Gloves)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\winter\uniform_winter.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_RS_Winter";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_RS_F_Desert : Bzn_Field_Uniform_RS_F_Urban
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Desert, Rolled Up, Gloves)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\desert\uniform_desert.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_RS_Desert";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_RS_F_Jungle : Bzn_Field_Uniform_RS_F_Urban
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Jungle, Rolled Up, Gloves)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\jungle\uniform_jungle.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_RS_Jungle";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_RS_F_Woodland : Bzn_Field_Uniform_RS_F_Urban
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Woodland, Rolled Up, Gloves)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\woodland\uniform_woodland.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_RS_Woodland";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_RS_F_Maritime : Bzn_Field_Uniform_RS_F_Urban
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Maritime, Rolled Up, Gloves)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\maritime\uniform_maritime.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_RS_Maritime";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_F_Urban : U_I_CombatUniform
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Urban)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\urban\uniform_urban.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_Urban";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_F_Winter : Bzn_Field_Uniform_RS_F_Urban
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Winter)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\winter\uniform_winter.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_Winter";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_F_Desert : Bzn_Field_Uniform_RS_F_Urban
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Desert)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\desert\uniform_desert.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_Desert";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_F_Jungle : Bzn_Field_Uniform_RS_F_Urban
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Jungle)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\jungle\uniform_jungle.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_Jungle";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_F_Woodland : Bzn_Field_Uniform_RS_F_Urban
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Woodland)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\woodland\uniform_woodland.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_Woodland";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_F_Maritime : Bzn_Field_Uniform_RS_F_Urban
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Maritime)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves\maritime\uniform_maritime.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_Maritime";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};
};
