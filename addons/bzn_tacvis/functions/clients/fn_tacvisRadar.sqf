if (isDedicated or !local player) exitWith {};

// While occupying an active-radar platform, detect non-friendly vehicles and
// broadcast them to ALL clients (shared awareness). Each client renders them
// range-limited by the normal display fade, so teammates only see a contact if
// it is within their own range. Uses nearTargets (the crew/vehicle sensor
// knowledge that the active radar feeds), not an omniscient proximity scan.
// Local-only display is intentionally gone now: contacts are team-shared.

while { BZN_tacvis_radar_active } do {
    private _veh = objectParent player;

    // isVehicleRadarOn reflects the crew's actual radar power switch (Ctrl+R) —
    // having radar-capable equipment isn't enough; contacts should only be
    // gathered/shared while the set is actually switched on.
    if (alive player and !isNull _veh and { [_veh] call BZN_fnc_tacvis_vehicleHasRadar } and { isVehicleRadarOn _veh }) then {
        private _expiry   = time + 3;   // rolling expiry, refreshed each scan
        private _contacts = [];
        {
            if (count _x > 4) then {
                private _obj = _x select 4;
                if (
                    !isNull _obj
                    and { alive _obj }
                    and { _obj isKindOf "AllVehicles" }
                    and { !(_obj isKindOf "CAManbase") }
                    and { _obj != _veh }
                    and { (side _obj) getFriend (side player) < 0.8 }
                ) then {
                    _contacts pushBack [_obj, _expiry];
                };
            };
        } forEach (player nearTargets BZN_tacvis_radar_range);

        // Share this operator's contacts with the team. remoteExec target 0
        // does NOT reliably loop back to the calling machine on non-host
        // clients (see fn_tacvisSpot.sqf's documented workaround) — a
        // broadcast-only call here meant the radar operator themselves could
        // end up never seeing the very contacts their own scope picked up.
        // Calling locally guarantees the operator's own pool always matches
        // what they just shared with everyone else.
        if (_contacts isNotEqualTo []) then {
            [_contacts] call BZN_fnc_tacvisAddRadar;
            [_contacts] remoteExec ["BZN_fnc_tacvisAddRadar", 0];
        };
    };

    sleep 1;
};
