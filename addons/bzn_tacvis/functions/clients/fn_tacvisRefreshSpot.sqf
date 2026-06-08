params ["_target", "_expiry"];

// Runs on every client (remoteExec to 0). Broadcast by ANY TacVis user who
// currently has line-of-sight on an already-spotted unit (see fn_tacvisAlwaysOn)
// to push its expiry back out — "while your team can see it, the mark holds."
// Idempotent and race-safe: only ever extends an entry's expiry (max), so an
// out-of-order/late remoteExec can't shorten a fresher timer set by someone else.
// Mirrors fn_tacvisAddSpot's merge so both paths keep BZN_tacvis_spotted in the
// same [unit, expiry] shape as BZN_tacvis_radar/BZN_tacvis_threat.
if (!hasInterface) exitWith {};                  // skip dedicated server / HC
if (isNil "BZN_tacvis_spotted") then { BZN_tacvis_spotted = []; };

private _idx = BZN_tacvis_spotted findIf { (_x select 0) == _target };
if (_idx >= 0) then {
    BZN_tacvis_spotted set [_idx, [_target, _expiry max ((BZN_tacvis_spotted select _idx) select 1)]];
} else {
    BZN_tacvis_spotted pushBack [_target, _expiry];
};
