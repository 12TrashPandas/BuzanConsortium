if (isDedicated or !local player) exitWith {};

// Persistent grid-by-grid SITREP overlay — same "always refresh a shared hint
// slot" approach as the UPLINK notice (see the drone-connect loop in
// fn_TACVISpostInit.sqf): aggregates every team-spotted and radar contact (the
// same BZN_tacvis_spotted/BZN_tacvis_radar pools the always-on display already
// tracks and prunes) into a compact "what's where" breakdown per 10-digit grid
// reference — how many infantry (and how many of THOSE are carrying launchers,
// the same priority-threat callout the 3D tags highlight individually) and how
// many vehicles sit in each square, nearest grid first.
//
// Hostile-civilian threat-watch contacts are deliberately left out — those are
// personal proximity alarms for armed civilians wandering near the player (see
// fn_tacvisThreatWatch.sqf), not the kind of organised, location-based picture
// a JTAC-style report aggregates; folding them in would also misclassify
// civilian-side units as military "INF"/"VEH" contacts.
while { BZN_tacvis_jtac_active } do {

    if (!alive player) then {
        sleep 1;
    } else {
        // Same prune-then-collect shape fn_tacvisAlwaysOn uses for these two
        // shared, time-stamped [unit, expiry] pools — keeps this loop's view
        // consistent with what the 3D tags are currently showing.
        BZN_tacvis_spotted = BZN_tacvis_spotted select { (time <= (_x select 1)) and { !isNull (_x select 0) } and { alive (_x select 0) } };
        BZN_tacvis_radar   = BZN_tacvis_radar   select { (time <= (_x select 1)) and { !isNull (_x select 0) } };

        private _contacts = [];
        { _contacts pushBackUnique (_x select 0) } forEach BZN_tacvis_spotted;
        { _contacts pushBackUnique (_x select 0) } forEach BZN_tacvis_radar;
        _contacts = _contacts select { alive _x };

        if (_contacts isEqualTo []) then {
            hintSilent parseText "<t size='1.3' color='#ffa030'>TACVIS JTAC</t><br/><t size='1.05'>No contacts reported</t>";
        } else {
            // Bucket contacts by grid reference: [grid, nearestDist, infCount, launcherCount, vehCount].
            // Vehicles/aircraft/ships/drones all fall into the "VEH" bucket —
            // a JTAC breakdown cares whether a square holds armour/air to call
            // in on, not the type-by-type detail the individual 3D tags show.
            private _grids = [];
            {
                private _unit = _x;
                private _grid = mapGridPosition _unit;
                private _idx  = _grids findIf { (_x select 0) == _grid };
                if (_idx < 0) then {
                    _grids pushBack [_grid, 1e6, 0, 0, 0, 0, 0];
                    _idx = (count _grids) - 1;
                };
                private _entry = _grids select _idx;
                _entry set [1, (_entry select 1) min (player distance _unit)];
                if (_unit isKindOf "CAManbase") then {
                    _entry set [2, (_entry select 2) + 1];
                    if (secondaryWeapon _unit != "") then {
                        _entry set [3, (_entry select 3) + 1];
                    };
                } else {
                    // Same AIR/SEA/GROUND split the cluster pre-pass uses
                    // (_typeBucket above) — kept separate here too, since
                    // "armour in the open" and "a chopper inbound" call for
                    // very different responses.
                    private _vehIdx = if (_unit isKindOf "Air") then { 4 } else { [6, 5] select (_unit isKindOf "Ship") };
                    _entry set [_vehIdx, (_entry select _vehIdx) + 1];
                };
            } forEach _contacts;

            // Nearest grid first — the squares closest to the observer are
            // the ones most likely to need an immediate call.
            _grids = [_grids, [], { _x select 1 }, "ASCEND"] call BIS_fnc_sortBy;

            private _lines = [];
            {
                private _grid      = _x select 0;
                private _inf       = _x select 2;
                private _launchers = _x select 3;
                private _air       = _x select 4;
                private _wtr       = _x select 5;
                private _gnd       = _x select 6;

                private _parts = [];
                if (_inf > 0) then {
                    _parts pushBack (
                        if (_launchers > 0)
                        then { format ["INF x%1 (%2x LAUNCHER)", _inf, _launchers] }
                        else { format ["INF x%1", _inf] }
                    );
                };
                if (_gnd > 0) then { _parts pushBack format ["GND x%1", _gnd] };
                if (_air > 0) then { _parts pushBack format ["AIR x%1", _air] };
                if (_wtr > 0) then { _parts pushBack format ["WTR x%1", _wtr] };

                _lines pushBack format [
                    "<t size='1.05' color='#30a0ff'>GRID %1</t><t size='1.05' color='#e0e0e0'> — %2</t>",
                    _grid, (_parts joinString " | ")
                ];
            } forEach _grids;

            hintSilent parseText (
                "<t size='1.3' color='#ffa030'>TACVIS JTAC</t><br/>" + (_lines joinString "<br/>")
            );
        };
    };

    sleep 2;
};

hintSilent "";
BZN_tacvis_jtac_active = false;
