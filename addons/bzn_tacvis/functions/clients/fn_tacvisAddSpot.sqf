params ["_target", "_expiry"];

// Runs on every client (remoteExec to 0) to register/refresh a spotted enemy's
// 3D tag. BZN_tacvis_spotted holds [unit, expiry] entries — the same shared,
// time-stamped shape as BZN_tacvis_radar/BZN_tacvis_threat. The expiry is
// computed ONCE by the spotter (fn_tacvisSpot) and broadcast as-is — mirroring
// fn_tacvisRefreshSpot's pattern — rather than each receiving client
// recomputing `time + BZN_tacvis_spot_duration` locally: `time` drifts
// slightly between clients under latency/packet loss, so a per-receiver
// recompute was producing a visibly different countdown on different machines
// for what should be the same spot ("desync in timer"). The tag shows
// (per client) while the unit is alive, within display range, and unexpired;
// BZN_tacvis_spot_duration controls how long it persists without a refresh
// (see fn_tacvisAlwaysOn, which re-broadcasts the expiry via fn_tacvisRefreshSpot
// for as long as ANY TacVis user keeps line-of-sight on the target). Separate
// from the map marker, which fades after 10 s (fn_tacvisSpot/fn_tacvisSpotMarker).
if (!hasInterface) exitWith {};                  // skip dedicated server / HC

if (!isNil "BZN_tacvis_debug" and { BZN_tacvis_debug }) then {
    diag_log format ["[BZN TacVis DEBUG] AddSpot received on %1 for target %2", name player, _target];
};

if (isNil "BZN_tacvis_spotted") then { BZN_tacvis_spotted = []; };

// Drop expired/dead entries, then add or refresh this target (mirrors
// fn_tacvisAddRadar's idempotent merge).
BZN_tacvis_spotted = BZN_tacvis_spotted select { (time <= (_x select 1)) and { !isNull (_x select 0) } and { alive (_x select 0) } };

private _idx = BZN_tacvis_spotted findIf { (_x select 0) == _target };
if (_idx >= 0) then {
    BZN_tacvis_spotted set [_idx, [_target, _expiry max ((BZN_tacvis_spotted select _idx) select 1)]];
} else {
    BZN_tacvis_spotted pushBack [_target, _expiry];
};
