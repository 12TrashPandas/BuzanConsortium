if (isDedicated or !local player) exitWith {};
if (BZN_tacvis_spot_cooldown) exitWith {};

// Requires a TacVis device AND a valid aim reference — optics on foot, a
// vehicle turret seat, or a connected UAV feed (see BZN_fnc_tacvis_canSpot).
// Safety net — the scroll action's condition already enforces this, but state
// can change between opening the menu and selecting the entry.
if !(call BZN_fnc_tacvis_hasDevice) exitWith {};
if !(call BZN_fnc_tacvis_canSpot) exitWith {
    cutText ["Aim through optics to spot", "PLAIN DOWN", 0.5, false];
};

// Find target: whichever hostile within range is nearest to dead-center of the
// crosshair (tight angular cone around the camera's aim direction). This is
// deliberately NOT cursorTarget — that depends on the AI "knowsAbout" knowledge
// system, which is unreliable for resolving player-controlled units at range/
// through optics (especially in dedicated MP), and was locking the spot onto a
// fixed nearest-enemy fallback rather than whatever was actually being aimed at.
// weaponDirection reports the actual bore/sight axis of the equipped weapon —
// i.e. exactly where the crosshair/reticle points — and is consistent across
// every view mode (ironsights, scopes, binos, vehicle turrets). This is far more
// reliable than deriving a look direction from positionCameraToWorld, which can
// degenerate depending on the active camera/view mode and silently never match.
// Remote UAV terminal operation: the operator's body stays put while their
// "aim" is whatever the drone's sensor is looking at. getConnectedUAV returns
// the UAV/UGV object (or objNull if not piloting one remotely) — when
// connected, spot from the drone's gunner/driver eyes + weaponDirection
// (the sensor turret's occupant) and scan from the drone's position, so units
// can be spotted via the drone feed rather than wherever the operator's body
// happens to be aiming on the ground.
private _uav = getConnectedUAV player;

// The camera IS the sight picture in every mode that matters here — ADS optics,
// vehicle turret feeds, and UAV terminal screens all render through
// positionCameraToWorld, so the screen-center direction is exactly "what the
// crosshair/feed is resting on," independent of armament. This sidesteps
// weaponDirection's documented limits: per the BIS forums it only resolves a
// vehicle's PRIMARY turret weapon (useless for commanders/secondary gunners —
// "not possible to get the direction of a commander's M2 on an M1 Abrams"), and
// it degenerates to a zero vector for unarmed sensor/recon turrets (currentWeapon
// == ""), silently breaking the dot-product match below. currentWeapon player /
// player weaponDirection also has nothing to do with where a turret is aimed —
// it reflects whatever personal sidearm/rifle the seated crewman happens to hold.
private _camPos = positionCameraToWorld [0, 0, 0];
private _aimDir = vectorNormalized ((positionCameraToWorld [0, 0, 1]) vectorDiff _camPos);

private _originPos = eyePos player;
private _scanFrom  = player;

if (!isNull _uav) then {
    private _operator = gunner _uav;
    if (isNull _operator) then { _operator = driver _uav };
    if (isNull _operator) exitWith {}; // no crewed seat to derive sensor aim from — bail

    _originPos = eyePos _operator;
    _scanFrom  = _uav;
};

if (!isNil "BZN_tacvis_debug" and { BZN_tacvis_debug }) then {
    diag_log format [
        "[BZN TacVis DEBUG] %1 spot scan: uav=%2 weapon='%3' originPos=%4 aimDir=%5 candidates=%6",
        name player, !isNull _uav, currentWeapon player, _originPos, _aimDir,
        count ((_scanFrom nearEntities [["CAManbase", "Car", "Motorcycle", "Tank", "Ship", "Air"], 500]) select {
            alive _x and _x != player and _x != _uav and (side _x) getFriend (side player) <= 0.3
        })
    ];
};

private _candidates = (_scanFrom nearEntities [["CAManbase", "Car", "Motorcycle", "Tank", "Ship", "Air"], 500]) select {
    alive _x and _x != player and _x != _uav and (side _x) getFriend (side player) <= 0.3
};

private _target  = objNull;
// cos is monotonically decreasing over [0, 180] degrees, so a HIGHER dot product
// means a SMALLER angle — comparing dot products directly avoids feeding acos a
// value that floating-point rounding can push fractionally outside [-1, 1]
// (which returns NaN, making every "< angle" comparison silently false forever).
private _bestDot = cos 3; // degrees — tight cone matching precise optics aim

{
    private _dirToTarget = vectorNormalized ((eyePos _x) vectorDiff _originPos);
    private _dot         = _aimDir vectorDotProduct _dirToTarget;
    if (_dot > _bestDot) then {
        _bestDot = _dot;
        _target  = _x;
    };
} forEach _candidates;

if (!isNil "BZN_tacvis_debug" and { BZN_tacvis_debug }) then {
    diag_log format [
        "[BZN TacVis DEBUG] %1 spot result: target=%2 bestDot=%3 (need > %4)",
        name player, _target, _bestDot, cos 3
    ];
};

if (isNull _target) exitWith {};

// Line-of-sight check: ray from the spotting platform's eyes to the target's
// eyes, ignoring both. Anything in between (terrain, walls, objects) blocks the
// spot. Ignore `vehicle player`/the UAV itself (rather than just `player`) so
// the ray isn't blocked by your own aircraft/drone body.
private _losFrom = if (!isNull _uav) then { _uav } else { vehicle player };
private _los = (lineIntersectsSurfaces [_originPos, eyePos _target, _losFrom, _target]) isEqualTo [];
if (!_los) exitWith {
    cutText ["No line of sight", "PLAIN DOWN", 0.5, false];
};

// The 3D world tag is persistent (shown until the target dies or leaves display
// range); only the team map marker fades, after 10 s.
private _markerExpiry = time + 10;
private _markerName    = format ["BZN_spot_%1", netId _target];
private _pos           = getPos _target;

// Share with everyone (coop): persistent 3D tag (the unit is added to
// BZN_tacvis_spotted on every client). remoteExec target 0 is documented to
// include the calling machine, but that loop-back has proven unreliable for
// non-host clients on dedicated servers (confirmed: the spotter's own machine
// never received its own broadcast). Both functions are idempotent
// (pushBackUnique / getMarkerPos-guarded createMarkerLocal), so calling
// directly here as well is harmless on machines where the loop-back does work.
if (!isNil "BZN_tacvis_debug" and { BZN_tacvis_debug }) then {
    diag_log format [
        "[BZN TacVis DEBUG] %1 pre-call types: AddSpot=%2 SpotMarker=%3",
        name player, typeName BZN_fnc_tacvisAddSpot, typeName BZN_fnc_tacvisSpotMarker
    ];
};

[_target] call BZN_fnc_tacvisAddSpot;
[_target] remoteExec ["BZN_fnc_tacvisAddSpot", 0];

// Map marker has its own 30 s cooldown, separate from the spot action's
// cooldown — placing the persistent 3D tag is unaffected, only the marker drop.
if (!BZN_tacvis_marker_cooldown) then {
    [_markerName, _pos, _markerExpiry] call BZN_fnc_tacvisSpotMarker;
    [_markerName, _pos, _markerExpiry] remoteExec ["BZN_fnc_tacvisSpotMarker", 0];

    BZN_tacvis_marker_cooldown = true;
    [] spawn {
        sleep 30;
        BZN_tacvis_marker_cooldown = false;
    };
};

playSound "vto_tacvis_sound_beep";
cutText ["Target Spotted", "PLAIN DOWN", 1, false];

// 1-second per-use cooldown
BZN_tacvis_spot_cooldown = true;
[] spawn {
    sleep 1;
    BZN_tacvis_spot_cooldown = false;
};
