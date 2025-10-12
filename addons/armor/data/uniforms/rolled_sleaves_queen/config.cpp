//The code for the uniforms is probably not the minimum it could be, feel free to experiment with removing stuff and see if it still works.
class CfgPatches
{
	class bzn_rs_queen
	{
		author="Bzn Mod Dev Team, Yandere";
		addonRootClass="bzn_uniforms";
		requiredAddons[]=
		{
			"bzn_rs",
		};
		units[]=
		{
			"Bzn_Field_Uniform_RS_Urban_Queen",
			"Bzn_Field_Uniform_RS_Winter_Queen",
			"Bzn_Field_Uniform_RS_Woodland_Queen",
			"Bzn_Field_Uniform_RS_Jungle_Queen",
			"Bzn_Field_Uniform_RS_Desert_Queen",
			"Bzn_Field_Uniform_RS_Maritime_Queen",
			"Bzn_Field_Uniform_Urban_Queen",
			"Bzn_Field_Uniform_Winter_Queen",
			"Bzn_Field_Uniform_Woodland_Queen",
			"Bzn_Field_Uniform_Jungle_Queen",
			"Bzn_Field_Uniform_Desert_Queen",
			"Bzn_Field_Uniform_Maritime_Queen",
			"Bzn_WI_Soldier_F_Q",
			"Bzn_WI_Soldier_F_Q_Woodland",
			"Bzn_WI_Soldier_F_Q_Desert",
			"Bzn_WI_Soldier_F_Q_Jungle",
			"Bzn_WI_Soldier_F_Q_Winter",
			"Bzn_WI_Soldier_F_Q_Maritime"
		};
		weapons[]=
		{
			"Bzn_W_I_CombatUniform_Queen",
			"Bzn_W_I_CombatUniform_Woodland_Queen",
			"Bzn_W_I_CombatUniform_Jungle_Queen",
			"Bzn_W_I_CombatUniform_Winter_Queen",
			"Bzn_W_I_CombatUniform_Desert_Queen",
			"Bzn_W_I_CombatUniform_Maritime_Queen",
			"Bzn_Field_Uniform_RS_F_Urban_Queen",
			"Bzn_Field_Uniform_RS_F_Winter_Queen",
			"Bzn_Field_Uniform_RS_F_Woodland_Queen",
			"Bzn_Field_Uniform_RS_F_Jungle_Queen",
			"Bzn_Field_Uniform_RS_F_Desert_Queen",
			"Bzn_Field_Uniform_RS_F_Maritime_Queen",
			"Bzn_Field_Uniform_F_Q_Urban",
			"Bzn_Field_Uniform_F_Q_Winter",
			"Bzn_Field_Uniform_F_Q_Woodland",
			"Bzn_Field_Uniform_F_Q_Jungle",
			"Bzn_Field_Uniform_F_Q_Desert",
			"Bzn_Field_Uniform_F_Q_Maritime"
		};
	};
};

class CfgVehicles
{
	class Bzn_WI_Soldier_F;

	//Female AAF Conversion
	class Bzn_WI_Soldier_F_Q : Bzn_WI_Soldier_F
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
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\urban\uniform_urban_q.paa"
		};
	};

	class Bzn_WI_Soldier_F_Q_Maritime : Bzn_WI_Soldier_F_Q
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
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\maritime\uniform_maritime_q.paa"
		};
	};

	class Bzn_WI_Soldier_F_Q_Woodland : Bzn_WI_Soldier_F_Q
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
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\woodland\uniform_woodland_q.paa"
		};
	};

	class Bzn_WI_Soldier_F_Q_Desert : Bzn_WI_Soldier_F_Q
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
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\desert\uniform_desert_q.paa"
		};
	};

	class Bzn_WI_Soldier_F_Q_Jungle : Bzn_WI_Soldier_F_Q
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
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\jungle\uniform_jungle_q.paa"
		};
	};

	class Bzn_WI_Soldier_F_Q_Winter : Bzn_WI_Soldier_F_Q
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
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\winter\uniform_winter_q.paa"
		};
	};

	class Bzn_Field_Uniform_RS_Urban;
	class Bzn_Field_Uniform_RS_Urban_Queen : Bzn_Field_Uniform_RS_Urban
	{
		author="Yandere";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\urban\uniform_urban_q.paa"
		};
	};


	class Bzn_Field_Uniform_RS_Winter_Queen : Bzn_Field_Uniform_RS_Urban_Queen
	{
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\winter\uniform_winter_q.paa"
		};

	};

	class Bzn_Field_Uniform_RS_Desert_Queen : Bzn_Field_Uniform_RS_Urban_Queen
	{
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\desert\uniform_desert_q.paa"
		};
	};

	class Bzn_Field_Uniform_RS_Jungle_Queen : Bzn_Field_Uniform_RS_Urban_Queen
	{
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\jungle\uniform_jungle_q.paa"
		};
	};

	class Bzn_Field_Uniform_RS_Woodland_Queen : Bzn_Field_Uniform_RS_Urban_Queen
	{
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\woodland\uniform_woodland_q.paa"
		};
	};

	class Bzn_Field_Uniform_RS_Maritime_Queen : Bzn_Field_Uniform_RS_Urban_Queen
	{
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\maritime\uniform_maritime_q.paa"
		};
	};

	class Bzn_Field_Uniform_Urban;
	class Bzn_Field_Uniform_Urban_Queen : Bzn_Field_Uniform_Urban
	{
		author="Yandere";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\urban\uniform_urban_q.paa"
		};
	};

	class Bzn_Field_Uniform_Winter_Queen : Bzn_Field_Uniform_Urban_Queen
	{
		author="Yandere";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\winter\uniform_winter_q.paa"
		};
	};

	class Bzn_Field_Uniform_Woodland_Queen : Bzn_Field_Uniform_Urban_Queen
	{
		author="Yandere";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\woodland\uniform_woodland_q.paa"
		};
	};

	class Bzn_Field_Uniform_Jungle_Queen : Bzn_Field_Uniform_Urban_Queen
	{
		author="Yandere";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\jungle\uniform_jungle_q.paa"
		};
	};

	class Bzn_Field_Uniform_Desert_Queen : Bzn_Field_Uniform_Urban_Queen
	{
		author="Yandere";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\desert\uniform_desert_q.paa"
		};
	};

	class Bzn_Field_Uniform_Maritime_Queen : Bzn_Field_Uniform_Urban_Queen
	{
		author="Yandere";
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\maritime\uniform_maritime_q.paa"
		};
	};
};

class CfgWeapons
{
	class Bzn_W_I_CombatUniform;
	class UniformItem;
	class Bzn_W_I_CombatUniform_Queen : Bzn_W_I_CombatUniform
	{
		author="Yandere";
		scope=2;
		displayName="Combat Fatigues Woman [Bzn] (Urban, Queen)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_universal_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\urban\uniform_urban_q.paa",
		};
		class ItemInfo: UniformItem
		{
			uniformModel="-";
			uniformClass="Bzn_WI_Soldier_F_Q";
			containerClass="Supply40";
			mass=40;
		};
	};

	class Bzn_W_I_CombatUniform_Maritime_Queen : Bzn_W_I_CombatUniform_Queen
	{
		author="Yandere";
		scope=2;
		displayName="Combat Fatigues Woman [Bzn] (Maritime, Queen)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_universal_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\maritime\uniform_maritime_q.paa",
		};
		class ItemInfo: UniformItem
		{
			uniformModel="-";
			uniformClass="Bzn_WI_Soldier_F_Q_Maritime";
			containerClass="Supply40";
			mass=40;
		};
	};

	class Bzn_W_I_CombatUniform_Woodland_Queen : Bzn_W_I_CombatUniform_Queen
	{
		author="Yandere";
		scope=2;
		displayName="Combat Fatigues Woman [Bzn] (Woodland, Queen)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_universal_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\woodland\uniform_woodland_q.paa",
		};
		class ItemInfo: UniformItem
		{
			uniformModel="-";
			uniformClass="Bzn_WI_Soldier_F_Q_Woodland";
			containerClass="Supply40";
			mass=40;
		};
	};

	class Bzn_W_I_CombatUniform_Desert_Queen : Bzn_W_I_CombatUniform_Queen
	{
		author="Yandere";
		scope=2;
		displayName="Combat Fatigues Woman [Bzn] (Desert, Queen)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_universal_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\desert\uniform_desert_q.paa",
		};
		class ItemInfo: UniformItem
		{
			uniformModel="-";
			uniformClass="Bzn_WI_Soldier_F_Q_Desert";
			containerClass="Supply40";
			mass=40;
		};
	};

	class Bzn_W_I_CombatUniform_Jungle_Queen : Bzn_W_I_CombatUniform_Queen
	{
		author="Yandere";
		scope=2;
		displayName="Combat Fatigues Woman [Bzn] (Jungle, Queen)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_universal_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\jungle\uniform_jungle_q.paa",
		};
		class ItemInfo: UniformItem
		{
			uniformModel="-";
			uniformClass="Bzn_WI_Soldier_F_Q_Jungle";
			containerClass="Supply40";
			mass=40;
		};
	};

	class Bzn_W_I_CombatUniform_Winter_Queen : Bzn_W_I_CombatUniform_Queen
	{
		author="Yandere";
		scope=2;
		displayName="Combat Fatigues Woman [Bzn] (Winter, Queen)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_universal_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\jungle\uniform_winter.paa",
		};
		class ItemInfo: UniformItem
		{
			uniformModel="-";
			uniformClass="Bzn_WI_Soldier_F_Q_Winter";
			containerClass="Supply40";
			mass=40;
		};
	};

	class Bzn_Field_Uniform_RS_F_Urban;
	class Bzn_Field_Uniform_RS_F_Urban_Queen : Bzn_Field_Uniform_RS_F_Urban
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Urban, Rolled Up, Gloves, Queen)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\urban\uniform_urban_q.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_RS_Urban_Queen";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};


	class Bzn_Field_Uniform_RS_F_Winter_Queen : Bzn_Field_Uniform_RS_F_Urban_Queen
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Winter, Rolled Up, Gloves, Queen)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\winter\uniform_winter_q.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_RS_Winter_Queen";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_RS_F_Desert_Queen : Bzn_Field_Uniform_RS_F_Urban_Queen
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Desert, Rolled Up, Gloves, Queen)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\desert\uniform_desert_q.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_RS_Desert_Queen";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_RS_F_Jungle_Queen : Bzn_Field_Uniform_RS_F_Urban_Queen
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Jungle, Rolled Up, Gloves, Queen)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\jungle\uniform_jungle_q.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_RS_Jungle_Queen";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_RS_F_Woodland_Queen : Bzn_Field_Uniform_RS_F_Urban_Queen
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Woodland, Rolled Up, Gloves, Queen)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\woodland\uniform_woodland_q.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_RS_Woodland_Queen";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_RS_F_Maritime_Queen : Bzn_Field_Uniform_RS_F_Urban_Queen
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Maritime, Rolled Up, Gloves, Queen)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\maritime\uniform_maritime_q.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_RS_Maritime_Queen";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_F_Urban;
	class Bzn_Field_Uniform_F_Urban_Queen : Bzn_Field_Uniform_F_Urban
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Urban, Queen)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\urban\uniform_urban_q.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_Urban_Queen";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_F_Winter_Queen : Bzn_Field_Uniform_RS_F_Urban
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Winter, Queen)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\winter\uniform_winter_q.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_Winter_Queen";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_F_Desert_Queen : Bzn_Field_Uniform_RS_F_Urban
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Desert, Queen)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\desert\uniform_desert_q.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_Desert_Queen";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_F_Jungle_Queen : Bzn_Field_Uniform_RS_F_Urban
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Jungle, Queen)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\jungle\uniform_jungle_q.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_Jungle_Queen";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_F_Woodland_Queen : Bzn_Field_Uniform_RS_F_Urban
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Woodland, Queen)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_queen\woodland\uniform_woodland_q.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_Woodland_Queen";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};

	class Bzn_Field_Uniform_F_Maritime_Queen : Bzn_Field_Uniform_RS_F_Urban
	{
		author="Yandere";
		scope=2;
		displayName="Field Uniform [Bzn] (Maritime, Queen)";
		picture="\A3\characters_f_beta\data\ui\icon_U_IR_CrewUniform_rucamo_ca.paa";
		model="\A3\Characters_F\Common\Suitpacks\suitpack_original_F.p3d";
		hiddenSelections[]=
		{
			"camo1",
			"insignia"
		};
		hiddenSelectionsTextures[]=
		{
			"\z\bzn\addons\armor\data\uniforms\rolled_sleaves_q\maritime\uniform_maritime_q.paa"
		};
		class ItemInfo: UniformItem
		{
			uniformClass="Bzn_Field_Uniform_Maritime_Queen";
			mass=40;
			containerClass="Supply40";
			uniformModel="-";
		};
	};
};
