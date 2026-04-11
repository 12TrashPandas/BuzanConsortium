class CfgPatches
{
	class bzn_recon_hood
	{
		author="Bzn Mod Dev Team, Yandere";
		addonRootClass="bzn_helmets";
		requiredAddons[]=
		{
			"ReconCloaks_Characters_Headgear" //Jams
		};
		units[]={"Bzn_helmet_reconcloak_U","Bzn_helmet_reconcloak_J","Bzn_helmet_reconcloak_D","Bzn_helmet_reconcloak_W","Bzn_helmet_reconcloak_Wd","Bzn_helmet_reconcloak_M"};
		weapons[]={"Bzn_helmet_reconcloak_urban","Bzn_helmet_reconcloak_jungle","Bzn_helmet_reconcloak_desert","Bzn_helmet_reconcloak_winter","Bzn_helmet_reconcloak_woodland","Bzn_helmet_reconcloak_maritime"};
	};
};

class CfgVehicles
{
	class Headgear_ReconCloaks_H_Hood_hex;

	class Bzn_helmet_reconcloak_U : Headgear_ReconCloaks_H_Hood_hex
	{
		scope = 2;
		scopeCurator = 2;
		displayName = "[Bzn] Recon Hood (Urban)";
		author = "Yandere";
		editorCategory = "EdCat_Equipment";
		editorSubcategory = "EdSubcat_Hats";
		vehicleClass = "ItemsHeadgear";
		model = "\A3\Weapons_F\DummyCap.p3d";
		class TransportItems
		{
			class _xx_ReconCloaks_H_Hood_urban
			{
				name = "Bzn_helmet_reconcloak_urban";
				count = 1;
			};
		};
	};

	class Bzn_helmet_reconcloak_J : Bzn_helmet_reconcloak_U
	{
		displayName = "[Bzn] Recon Hood (Jungle)";
		class TransportItems
		{
			class _xx_ReconCloaks_H_Hood_jungle
			{
				name = "Bzn_helmet_reconcloak_jungle";
				count = 1;
			};
		};
	};

	class Bzn_helmet_reconcloak_D : Bzn_helmet_reconcloak_U
	{
		displayName = "[Bzn] Recon Hood (Desert)";
		class TransportItems
		{
			class _xx_ReconCloaks_H_Hood_desert
			{
				name = "Bzn_helmet_reconcloak_desert";
				count = 1;
			};
		};
	};

	class Bzn_helmet_reconcloak_W : Bzn_helmet_reconcloak_U
	{
		displayName = "[Bzn] Recon Hood (Winter)";
		class TransportItems
		{
			class _xx_ReconCloaks_H_Hood_winter
			{
				name = "Bzn_helmet_reconcloak_winter";
				count = 1;
			};
		};
	};

	class Bzn_helmet_reconcloak_Wd : Bzn_helmet_reconcloak_U
	{
		displayName = "[Bzn] Recon Hood (Woodland)";
		class TransportItems
		{
			class _xx_ReconCloaks_H_Hood_woodland
			{
				name = "Bzn_helmet_reconcloak_woodland";
				count = 1;
			};
		};
	};

	class Bzn_helmet_reconcloak_M : Bzn_helmet_reconcloak_U
	{
		displayName = "[Bzn] Recon Hood (Maritime)";
		class TransportItems
		{
			class _xx_ReconCloaks_H_Hood_maritime
			{
				name = "Bzn_helmet_reconcloak_maritime";
				count = 1;
			};
		};
	};
};

class CfgWeapons
{
	class ReconCloaks_H_Hood_oli;
	class ItemInfo;

	class Bzn_helmet_reconcloak_urban : ReconCloaks_H_Hood_oli
	{
		author = "Yandere";
		scope = 2;
		displayName = "Recon Hood (Urban)";
		picture = "\ReconCloaks\reconcloaks_characters\Headgear\Data\icon\H_ReconCloak_oli_ico_CA.paa";
		hiddenSelectionsTextures[] = {"\z\bzn\addons\armor\data\helmets\Recon-Cloak\data\urban_CO.paa"};
		class ItemInfo: ItemInfo
		{
			mass=50;
			uniformModel="\ReconCloaks\reconcloaks_characters\Headgear\H_ReconCloak.p3d";
			modelSides[]={3,1};
			class HitpointsProtectionInfo
			{
				class Head
				{
					hitpointName="HitHead";
					armor=10;
					passThrough=0.5;
				};
			};
		};
	};

	class Bzn_helmet_reconcloak_jungle : Bzn_helmet_reconcloak_urban
	{
		author = "Yandere";
		scope = 2;
		displayName = "Recon Hood (Jungle)";
		picture = "\ReconCloaks\reconcloaks_characters\Headgear\Data\icon\H_ReconCloak_oli_ico_CA.paa";
		hiddenSelectionsTextures[] = {"\z\bzn\addons\armor\data\helmets\Recon-Cloak\data\jungle_CO.paa"};
	};

	class Bzn_helmet_reconcloak_desert : Bzn_helmet_reconcloak_urban
	{
		author = "Yandere";
		scope = 2;
		displayName = "Recon Hood (Desert)";
		picture = "\ReconCloaks\reconcloaks_characters\Headgear\Data\icon\H_ReconCloak_oli_ico_CA.paa";
		hiddenSelectionsTextures[] = {"\z\bzn\addons\armor\data\helmets\Recon-Cloak\data\desert_CO.paa"};
	};

	class Bzn_helmet_reconcloak_winter : Bzn_helmet_reconcloak_urban
	{
		author = "Yandere";
		scope = 2;
		displayName = "Recon Hood (Winter)";
		picture = "\ReconCloaks\reconcloaks_characters\Headgear\Data\icon\H_ReconCloak_oli_ico_CA.paa";
		hiddenSelectionsTextures[] = {"\z\bzn\addons\armor\data\helmets\Recon-Cloak\data\winter_CO.paa"};
	};

	class Bzn_helmet_reconcloak_woodland : Bzn_helmet_reconcloak_urban
	{
		author = "Yandere";
		scope = 2;
		displayName = "Recon Hood (Woodland)";
		picture = "\ReconCloaks\reconcloaks_characters\Headgear\Data\icon\H_ReconCloak_oli_ico_CA.paa";
		hiddenSelectionsTextures[] = {"\z\bzn\addons\armor\data\helmets\Recon-Cloak\data\woodland_CO.paa"};
	};

	class Bzn_helmet_reconcloak_maritime : Bzn_helmet_reconcloak_urban
	{
		author = "Yandere";
		scope = 2;
		displayName = "Recon Hood (Maritime)";
		picture = "\ReconCloaks\reconcloaks_characters\Headgear\Data\icon\H_ReconCloak_oli_ico_CA.paa";
		hiddenSelectionsTextures[] = {"\z\bzn\addons\armor\data\helmets\Recon-Cloak\data\maritime_CO.paa"};
	};
};
