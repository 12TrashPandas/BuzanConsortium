if (!isServer) exitWith {};

// Server-side squad health broadcast — the server counterpart to the client
// broadcast loop in fn_VISORpostInit. It publishes BZN_visor_healthState for
// the units the SERVER owns: AI squadmates that share a group with a player
// and are local to the server (the standard dedicated-server case, where AI
// in a player's group is server-local). Their ACE medical variables are only
// accurate here, so the server is the authoritative publisher for them, and
// each client's display resolver (BZN_fnc_visor_squadHealthDisplay) reads the
// broadcast value for units it doesn't own.
//
// Player-owned units — and AI led by a player, which become local to that
// player — are already published by that owning client, so this loop only
// touches server-local AI (the `local && !isPlayer` filter). On a listen
// server the host is both server and client, so a host-led AI could be
// published by both loops; that's the same value written twice, harmless.
//
// Cadence matches the client loop: poll every 2 s and broadcast on change,
// with a 10 s keepalive so newly-connected clients fill in without waiting
// for a state change.

[] spawn {
    private _nextKeepalive = 0;
    while { true } do {
        private _keepalive = time >= _nextKeepalive;
        if (_keepalive) then { _nextKeepalive = time + 10 };
        {
            private _grp = _x;
            // Only groups that actually contain a player — no point
            // publishing health for the mission's ambient/enemy AI.
            if ((units _grp) findIf { isPlayer _x } >= 0) then {
                {
                    if (local _x and { !isPlayer _x } and { alive _x }) then {
                        private _state = [_x] call BZN_fnc_visor_squadHealthState;
                        if (_keepalive or { (_x getVariable ["BZN_visor_healthState_last", -1]) != _state }) then {
                            _x setVariable ["BZN_visor_healthState", _state, true];
                            _x setVariable ["BZN_visor_healthState_last", _state];
                        };
                    };
                } forEach (units _grp);
            };
        } forEach allGroups;
        sleep 2;
    };
};
