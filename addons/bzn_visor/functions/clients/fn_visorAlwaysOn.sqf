if (isDedicated or !local player) exitWith {};

while { BZN_visor_friendly_active } do {

    if (!alive player) then {
        BZN_visor_pool_friendly = [];
        sleep 1;
    } else {
        private _pool = [];

        // Friendly/allied units within the player-configurable fade ranges
        // ("Infantry/Vehicle fade range" Addon Options). Collection uses the
        // larger of the two so nothing that could still render gets missed;
        // the render engine's per-type alpha fade then draws each contact
        // out to its own class's range.
        private _scanRange = BZN_visor_fade_infantry max BZN_visor_fade_vehicle;
        private _scan = player nearEntities [["CAManbase", "Car", "Motorcycle", "Tank", "Ship", "Air"], _scanRange];
        {
            if (alive _x and _x != player and (side _x) getFriend (side player) >= 0.8) then {
                _pool pushBackUnique _x;
            };
        } forEach _scan;

        // Drop dead/expired marks and add live Zeus-marked targets.
        // BZN_visor_spotted holds [unit, expiry, spotter, lines] entries fed
        // exclusively by the Zeus "Mark Target (VISOR)" module dialog
        // (fn_visorZeusMark.sqf via fn_visorAddSpot.sqf). expiry -1 = untimed
        // — such marks only prune when the target dies; timed ones fade on
        // their curator-set timer. No LOS/refresh mechanic either way.
        BZN_visor_spotted = BZN_visor_spotted select {
            ((_x select 1) < 0 or { time <= (_x select 1) })
            and { !isNull (_x select 0) }
            and { alive (_x select 0) }
        };
        { _pool pushBackUnique (_x select 0) } forEach BZN_visor_spotted;

        // ---- PoC squad health: dead-squadmate tracking ---------------------
        // A unit leaves `group player` the instant it dies, so a live scan of
        // the group alone can never keep reporting a fresh corpse. Compare
        // this cycle's roster against last cycle's: anyone who was in the
        // squad last time and is now dead (but their body still exists) gets
        // recorded in BZN_visor_squadDead as [body, expiry] so the squad
        // health HUD (fn_visorSquadHUD.sqf) can keep listing them as KIA for
        // a while instead of silently dropping the line. Roster is then
        // refreshed to the live squad. Purely bookkeeping for the HUD —
        // nothing here feeds the 3D render pool; squad members render (or
        // don't) under the exact same IFF rules as any other friendly.
        {
            private _deadBody = _x;
            if (!alive _deadBody and { !isNull _deadBody } and { (BZN_visor_squadDead findIf { (_x select 0) isEqualTo _deadBody }) < 0 }) then {
                BZN_visor_squadDead pushBack [_deadBody, time + BZN_visor_squadDead_duration];
            };
        } forEach BZN_visor_squadRoster;
        BZN_visor_squadRoster = (units group player) - [player];

        // Drop bodies deleted by the engine OR aged past the KIA linger window
        // — so KIA lines clear on their own instead of sitting in the squad
        // readout forever.
        BZN_visor_squadDead = BZN_visor_squadDead select { !isNull (_x select 0) and { time < (_x select 1) } };

        BZN_visor_pool_friendly = _pool;
    };

    sleep 2;
};

BZN_visor_pool_friendly = [];
BZN_visor_friendly_active = false;
