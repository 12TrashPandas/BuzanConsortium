if (isDedicated or !local player) exitWith {};

while { BZN_tacvis_friendly_active } do {

    if (!alive player) then {
        BZN_tacvis_pool_friendly = [];
        sleep 1;
    } else {
        private _pool = [];

        // All friendly/allied units within 500 m
        {
            if (alive _x and _x != player and (side _x) getFriend (side player) >= 0.8) then {
                _pool pushBackUnique _x;
            };
        } forEach (player nearEntities [["CAManbase", "Car", "Motorcycle", "Tank", "Air", "Ship"], 500]);

        // Prune expired spots and add still-active spotted enemies
        BZN_tacvis_spotted = BZN_tacvis_spotted select { time <= (_x select 1) };
        {
            if (alive (_x select 0)) then { _pool pushBackUnique (_x select 0) };
        } forEach BZN_tacvis_spotted;

        BZN_tacvis_pool_friendly = _pool;
    };

    sleep 2;
};

BZN_tacvis_pool_friendly = [];
BZN_tacvis_friendly_active = false;
