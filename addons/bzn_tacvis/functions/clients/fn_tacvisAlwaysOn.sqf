if (isDedicated or !local player) exitWith {};

while { BZN_tacvis_friendly_active } do {

    if (!alive player) then {
        BZN_tacvis_pool_friendly = [];
        sleep 1;
    } else {
        private _pool = [];

        // Friendly/allied ground units (500 m on foot, 1.5 km when airborne) plus
        // friendly aircraft out to the longer air range (IFF for flying contacts).
        private _obsVeh     = objectParent player;
        private _groundRange = [500, BZN_tacvis_ground_air_range] select ((!isNull _obsVeh) and { _obsVeh isKindOf "Air" });
        private _scan = (player nearEntities [["CAManbase", "Car", "Motorcycle", "Tank", "Ship"], _groundRange])
                      + (player nearEntities [["Air"], BZN_tacvis_air_range]);
        {
            if (alive _x and _x != player and (side _x) getFriend (side player) >= 0.8) then {
                _pool pushBackUnique _x;
            };
        } forEach _scan;

        // Drop dead spots (persistent otherwise) and add live spotted enemies.
        BZN_tacvis_spotted = BZN_tacvis_spotted select { !isNull _x and { alive _x } };
        { _pool pushBackUnique _x } forEach BZN_tacvis_spotted;

        BZN_tacvis_pool_friendly = _pool;
    };

    sleep 2;
};

BZN_tacvis_pool_friendly = [];
BZN_tacvis_friendly_active = false;
