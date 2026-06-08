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

        // Drop dead/expired spots and add live, unexpired spotted enemies.
        // BZN_tacvis_spotted holds [unit, expiry] entries (see fn_tacvisAddSpot/
        // fn_tacvisRefreshSpot) — same shared time-stamped shape as
        // BZN_tacvis_radar/BZN_tacvis_threat.
        BZN_tacvis_spotted = BZN_tacvis_spotted select { (time <= (_x select 1)) and { !isNull (_x select 0) } and { alive (_x select 0) } };
        { _pool pushBackUnique (_x select 0) } forEach BZN_tacvis_spotted;

        // Keep "SPOTTED" intel alive while ANYONE on the team can still see the
        // target — not just the original spotter. Any TacVis device user with
        // raw line-of-sight on an already-spotted unit re-broadcasts its expiry,
        // so a held position keeps the mark fresh while a target that breaks
        // contact with the whole team naturally fades out after
        // BZN_tacvis_spot_duration. Piggybacks on this loop's existing 2 s
        // cadence/iteration — no extra polling added.
        if (call BZN_fnc_tacvis_hasDevice) then {
            // Mirrors fn_tacvisSpot.sqf's _originPos/_losFrom/_uav-operator
            // derivation exactly. Plain eyePos player + ignoring only `player`
            // was the bug: for vehicle crew the eyes sit INSIDE the hull, so the
            // ray to the target gets blocked by the vehicle's own geometry —
            // spots decayed even while the gunner clearly had the target in
            // their sight. `vehicle player` returns the unit itself when on
            // foot (so the ignore-list collapses to just the player, same as
            // before) or the vehicle when mounted (so its own hull is ignored —
            // exactly how fn_tacvisSpot's LOS check already handles this).
            // UAV operators get the drone's sensor position/body instead, since
            // their body stays put on the ground while their "eyes" are remote.
            private _uav       = getConnectedUAV player;
            private _originPos = eyePos player;
            private _losFrom   = vehicle player;

            if (!isNull _uav) then {
                private _operator = gunner _uav;
                if (isNull _operator) then { _operator = driver _uav };
                if (!isNull _operator) then {
                    _originPos = eyePos _operator;
                    _losFrom   = _uav;
                };
            };

            {
                _x params ["_u"];
                if (
                    (_originPos distance _u <= 500)
                    and { (lineIntersectsSurfaces [_originPos, eyePos _u, _losFrom, _u]) isEqualTo [] }
                ) then {
                    [_u, time + BZN_tacvis_spot_duration] remoteExec ["BZN_fnc_tacvisRefreshSpot", 0];
                };
            } forEach BZN_tacvis_spotted;
        };

        BZN_tacvis_pool_friendly = _pool;
    };

    sleep 2;
};

BZN_tacvis_pool_friendly = [];
BZN_tacvis_friendly_active = false;
