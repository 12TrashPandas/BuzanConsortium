if (isDedicated or !local player) exitWith {};

// While occupying an active-radar platform, detect non-friendly vehicles and
// broadcast them to ALL clients (shared awareness). Each client renders them
// range-limited by the normal display fade, so teammates only see a contact if
// it is within their own range. Uses nearTargets (the crew/vehicle sensor
// knowledge that the active radar feeds), not an omniscient proximity scan.
// Local-only display is intentionally gone now: contacts are team-shared.

while { BZN_tacvis_radar_active } do {
    private _veh = objectParent player;

    if (alive player and !isNull _veh and { [_veh] call BZN_fnc_tacvis_vehicleHasRadar }) then {
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

        // Share this operator's contacts with everyone (0 includes self).
        if (_contacts isNotEqualTo []) then {
            _contacts remoteExec ["BZN_fnc_tacvisAddRadar", 0];
        };
    };

    sleep 1;
};
