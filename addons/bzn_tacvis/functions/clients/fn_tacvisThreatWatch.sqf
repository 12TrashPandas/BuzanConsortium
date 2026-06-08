if (isDedicated or !local player) exitWith {};

// Watches nearby people for a civilian that changes side to one that is hostile
// to the player (e.g. an insurgent revealing). When such a unit is within alarm
// range it fires a one-time alert: a notification sound + a short-lived red 3D
// marker (BZN_tacvis_threat, drawn by the render engine).
//
// Medical note: downed friendlies become civilian and only ever revert to the
// player's side, so they never match the civilian -> non-player transition and
// never trigger this. Side state is tracked locally on each unit.

private _trackRange = 50;   // metres; range we watch for side changes
private _alarmRange = 10;   // metres; range at which a revealed hostile alarms

while { BZN_tacvis_threat_active } do {
    if (alive player) then {
        private _pSide = playerSide;

        // Drop expired alarm markers.
        BZN_tacvis_threat = BZN_tacvis_threat select { time <= (_x select 1) };

        {
            private _u    = _x;
            private _cur  = side _u;
            private _prev = _u getVariable ["BZN_tacvis_lastSide", sideUnknown];

            // Civilian -> a side that is actually hostile to the player = reveal.
            // (Civilian reads as friendly, so a hostile getFriend implies the side
            // genuinely changed to an enemy faction.)
            if (_prev == civilian and { (_cur getFriend _pSide) <= 0.3 }) then {
                _u setVariable ["BZN_tacvis_hostileRevealed", true];
            };
            _u setVariable ["BZN_tacvis_lastSide", _cur];

            // One-time alarm when a revealed unit comes within alarm range.
            if (
                (_u getVariable ["BZN_tacvis_hostileRevealed", false])
                and { !(_u getVariable ["BZN_tacvis_alarmed", false]) }
                and { alive _u }
                and { (player distance _u) <= _alarmRange }
            ) then {
                _u setVariable ["BZN_tacvis_alarmed", true];
                BZN_tacvis_threat pushBack [_u, time + 8];
                playSound "vto_tacvis_sound_beep";
                cutText [">>NEARBY THREAT IDENTIFIED<<", "PLAIN DOWN", 2.5, false];
            };
        } forEach (player nearEntities [["CAManbase"], _trackRange]);
    };

    sleep 1;
};

BZN_tacvis_threat = [];
