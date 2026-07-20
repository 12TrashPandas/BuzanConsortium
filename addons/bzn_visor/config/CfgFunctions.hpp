class CfgFunctions {
	class BZN {
		class BZN_visor_modCategory {
			file = "z\bzn\addons\bzn_visor\functions\clients";

			class VISORpostInit {
				postInit = 1;
			};
			class visorAlwaysOn {};
			class visorAddSpot {};
			class visorRefreshUAVOperator {};
			class visorRenderEngine {};
			class visorSquadHUD {};
			class visorZeusMark {};
		};

		class BZN_visor_serverCategory {
			file = "z\bzn\addons\bzn_visor\functions\server";

			// Runs on all machines but no-ops off the server (isServer guard).
			class visorServerHealth {
				postInit = 1;
			};
		};
	};
};
