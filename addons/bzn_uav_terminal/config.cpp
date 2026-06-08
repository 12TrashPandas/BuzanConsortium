class CfgPatches {
    class bzn_uav_terminal {
        name = "BZN UAV Terminals";
        units[] = {};
        weapons[] = {"Bzn_UavTerminal_B", "Bzn_UavTerminal_O", "Bzn_UavTerminal_I"};
        requiredVersion = 2.0;
        requiredAddons[] = {"cba_common"};
        author = "Buzan Consortium Mod Team";
        version = "1.0.0";
    };
};

#include "config\CfgFunctions.hpp"

class CfgWeapons {
    class B_UavTerminal;
    class O_UavTerminal;
    class I_UavTerminal;

    class Bzn_UavTerminal_B: B_UavTerminal {
        author = "Buzan Consortium Mod Team";
        scope = 2;
        displayName = "UAV Terminal (Buzan, BLUFOR)";
        descriptionShort = "Buzan Consortium-issue BLUFOR UAV control terminal. Also recognised by cTab as a tactical tablet.";
    };

    class Bzn_UavTerminal_O: O_UavTerminal {
        author = "Buzan Consortium Mod Team";
        scope = 2;
        displayName = "UAV Terminal (Buzan, OPFOR)";
        descriptionShort = "Buzan Consortium-issue OPFOR UAV control terminal. Also recognised by cTab as a tactical tablet.";
    };

    class Bzn_UavTerminal_I: I_UavTerminal {
        author = "Buzan Consortium Mod Team";
        scope = 2;
        displayName = "UAV Terminal (Buzan, Independent)";
        descriptionShort = "Buzan Consortium-issue Independent UAV control terminal. Also recognised by cTab as a tactical tablet.";
    };
};
