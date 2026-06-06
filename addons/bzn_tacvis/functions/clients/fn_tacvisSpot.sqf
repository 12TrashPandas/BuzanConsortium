if (isDedicated or !local player) exitWith {};
if (BZN_tacvis_spot_cooldown) exitWith {};

// Requires a TacVis device AND the player to be looking through optics
// (cameraView "GUNNER" = ADS scope / iron sights / binocular zoom). Safety net —
// the scroll action's condition already enforces this, but state can change
// between opening the menu and selecting the entry.
if !(call BZN_fnc_tacvis_hasDevice) exitWith {};
if (cameraView != "GUNNER") exitWith {
    cutText ["Aim through optics to spot", "PLAIN DOWN", 0.5, false];
};

// Find target: cursor target first, then nearest enemy in 500 m
private _target = cursorTarget;

if (isNull _target or !alive _target or (side _target) getFriend (side player) > 0.3) then {
    private _near = (player nearEntities [["CAManbase"], 500]) select {
        alive _x and _x != player and (side _x) getFriend (side player) <= 0.3
    };
    _target = if (_near isNotEqualTo []) then { _near select 0 } else { objNull };
};

if (isNull _target or !alive _target) exitWith {};

// Line-of-sight check: ray from the player's eyes to the target's eyes,
// ignoring both. Anything in between (terrain, walls, objects) blocks the spot.
// Ignore `vehicle player` rather than `player` so the ray isn't blocked by your
// own aircraft/vehicle when spotting from a gunner seat (on foot they're equal).
private _los = (lineIntersectsSurfaces [eyePos player, eyePos _target, vehicle player, _target]) isEqualTo [];
if (!_los) exitWith {
    cutText ["No line of sight", "PLAIN DOWN", 0.5, false];
};

// The 3D world tag is persistent (shown until the target dies or leaves display
// range); only the team map marker fades, after 10 s.
private _markerExpiry = time + 10;
private _markerName    = format ["BZN_spot_%1", netId _target];
private _pos           = getPos _target;

// Share with everyone (coop): persistent 3D tag (the unit is added to
// BZN_tacvis_spotted on every client) + a 10 s team map marker. 0 includes self.
[_target] remoteExec ["BZN_fnc_tacvisAddSpot", 0];
[_markerName, _pos, _markerExpiry] remoteExec ["BZN_fnc_tacvisSpotMarker", 0];

playSound "vto_tacvis_sound_beep";
cutText ["Target Spotted", "PLAIN DOWN", 1, false];

// 10-second per-use cooldown
BZN_tacvis_spot_cooldown = true;
[] spawn {
    sleep 10;
    BZN_tacvis_spot_cooldown = false;
};
