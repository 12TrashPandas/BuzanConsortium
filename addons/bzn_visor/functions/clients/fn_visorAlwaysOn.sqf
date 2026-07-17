if (isDedicated or !local player) exitWith {};

while { BZN_visor_friendly_active } do {

    if (!alive player) then {
        BZN_visor_pool_friendly = [];
        sleep 1;
    } else {
        private _pool = [];

        // Friendly/allied ground units (500 m on foot, 1.5 km when airborne) plus
        // friendly aircraft out to the longer air range (IFF for flying contacts).
        private _obsVeh     = objectParent player;
        private _groundRange = [500, BZN_visor_ground_air_range] select ((!isNull _obsVeh) and { _obsVeh isKindOf "Air" });
        private _scan = (player nearEntities [["CAManbase", "Car", "Motorcycle", "Tank", "Ship"], _groundRange])
                      + (player nearEntities [["Air"], BZN_visor_air_range]);
        {
            if (alive _x and _x != player and (side _x) getFriend (side player) >= 0.8) then {
                _pool pushBackUnique _x;
            };
        } forEach _scan;

        // Drop dead/expired marks and add live, unexpired Zeus-marked
        // enemies. BZN_visor_spotted holds [unit, expiry, spotter] entries,
        // fed exclusively by the Zeus "Mark Enemy (VISOR)" module
        // (fn_visorZeusMark.sqf via fn_visorAddSpot.sqf). There is no
        // LOS-based refresh anymore — a mark simply expires on its fixed
        // Zeus-set timer.
        BZN_visor_spotted = BZN_visor_spotted select { (time <= (_x select 1)) and { !isNull (_x select 0) } and { alive (_x select 0) } };
        { _pool pushBackUnique (_x select 0) } forEach BZN_visor_spotted;

        // ---- PoC squad health: dead-squadmate tracking ---------------------
        // A unit leaves `group player` the instant it dies, so a live scan of
        // the group alone can never keep reporting a fresh corpse. Compare
        // this cycle's roster against last cycle's: anyone who was in the
        // squad last time and is now dead (but their body still exists) gets
        // pushed into BZN_visor_squadDead so the squad health HUD
        // (fn_visorSquadHUD.sqf) can keep listing them as KIA instead of
        // silently dropping the line. Roster is then refreshed to the live
        // squad. Purely bookkeeping for the HUD — nothing here feeds the 3D
        // render pool; squad members render (or don't) under the exact same
        // IFF rules as any other friendly.
        {
            if (!alive _x and { !isNull _x }) then {
                BZN_visor_squadDead pushBackUnique _x;
            };
        } forEach BZN_visor_squadRoster;
        BZN_visor_squadRoster = (units group player) - [player];

        // Prune bodies that got deleted/cleaned up by the mission/engine.
        BZN_visor_squadDead = BZN_visor_squadDead select { !isNull _x };

        BZN_visor_pool_friendly = _pool;

        // Debug hint — writes to BZN_visor_hint_debug (picked up by the
        // master hint aggregator in fn_VISORpostInit). Shows live
        // Zeus-marked list with expiry values. Also logs to RPT each cycle
        // for offline diagnosis.
        if (!isNil "BZN_visor_debug" and { BZN_visor_debug }) then {
            private _dLines = [
                "<t size='0.75' color='#ffff00'>■ VISOR Debug ■</t>",
                // Machine identity — lets you match debug screenshots from different players
                format ["<t size='0.65'>%1 | %2 | srv=%3 | t=%4s</t>",
                    netId player, name player, ["N","Y"] select isServer, round time],
                // Device flag — confirms whether this client has VISOR active
                format ["<t size='0.65'>dev=%1  zeus_dur=%2s</t>",
                    ["N","Y"] select (call BZN_fnc_visor_hasDevice),
                    BZN_visor_zeusMark_duration],
                format ["<t size='0.65'>spotted=%1</t>", count BZN_visor_spotted]
            ];

            // Per-marked unit: remain, spotter
            {
                _x params ["_u", "_exp", ["_who", "?"]];
                private _rem = round(_exp - time);
                _dLines pushBack format ["<t size='0.6'>  %1: %2s (by %3)</t>", name _u, _rem, _who];
            } forEach BZN_visor_spotted;

            BZN_visor_hint_debug = _dLines joinString "<br/>";
            diag_log format ["[BZN VISOR Debug] spotted=%1",
                (BZN_visor_spotted apply { [name (_x select 0), round((_x select 1) - time), _x select 2] })];
        } else {
            BZN_visor_hint_debug = "";
        };
    };

    sleep 2;
};

BZN_visor_pool_friendly = [];
BZN_visor_friendly_active = false;
