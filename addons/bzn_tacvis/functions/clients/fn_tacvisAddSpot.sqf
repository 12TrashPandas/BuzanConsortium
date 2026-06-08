params ["_target"];

// Runs on every client (remoteExec to 0) to register a spotted enemy as a
// PERSISTENT 3D tag. BZN_tacvis_spotted is a plain list of units; the tag shows
// (per client) while the unit is alive and within display range (render alpha),
// and is dropped only when the unit dies. No time expiry — the map marker, which
// fades after 10 s, is handled separately in fn_tacvisSpot/fn_tacvisSpotMarker.
if (!hasInterface) exitWith {};                  // skip dedicated server / HC

if (!isNil "BZN_tacvis_debug" and { BZN_tacvis_debug }) then {
    diag_log format ["[BZN TacVis DEBUG] AddSpot received on %1 for target %2", name player, _target];
};

if (isNil "BZN_tacvis_spotted") then { BZN_tacvis_spotted = []; };

// Drop dead/null entries, then add this target (deduped).
BZN_tacvis_spotted = BZN_tacvis_spotted select { !isNull _x and { alive _x } };
BZN_tacvis_spotted pushBackUnique _target;
