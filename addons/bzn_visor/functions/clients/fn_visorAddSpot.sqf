params ["_target", "_expiry", ["_spotter", "?"]];

// Runs on every client (remoteExec to 0) to register/refresh a Zeus-marked
// enemy's 3D tag. BZN_visor_spotted holds [unit, expiry, spotter] entries.
// The sole feed into this pool is the Zeus "Mark Enemy (VISOR)" module
// (fn_visorZeusMark.sqf) — there is no player-driven spotting and no
// LOS-based refresh; the expiry is computed once by fn_visorZeusMark
// (`time + BZN_visor_zeusMark_duration`, a CBA-configurable setting) and
// broadcast as-is, rather than each receiving client recomputing it locally:
// `time` drifts slightly between clients under latency/packet loss, so a
// per-receiver recompute was producing a visibly different countdown on
// different machines for what should be the same mark ("desync in timer").
// The tag shows (per client) while the unit is alive, within display range,
// and unexpired; it simply fades once its fixed timer runs out — nothing
// refreshes it early. There is no map marker for marks — the 3D tag is the
// only indicator.
if (!hasInterface) exitWith {};                  // skip dedicated server / HC

if (!isNil "BZN_visor_debug" and { BZN_visor_debug }) then {
    diag_log format ["[BZN VISOR] AddSpot on %1: target=%2 expiry=%3 remain=%4s",
        name player, _target, _expiry, round(_expiry - time)];
};

if (isNil "BZN_visor_spotted") then { BZN_visor_spotted = []; };

// Drop expired/dead entries, then add or refresh this target. Idempotent —
// remoteExec target 0 plus the caller's own local call means this can run
// twice for the same mark; findIf below merges rather than duplicating.
BZN_visor_spotted = BZN_visor_spotted select { (time <= (_x select 1)) and { !isNull (_x select 0) } and { alive (_x select 0) } };

private _idx = BZN_visor_spotted findIf { (_x select 0) == _target };
if (_idx >= 0) then {
    private _existing = BZN_visor_spotted select _idx;
    BZN_visor_spotted set [_idx, [_target, _expiry max (_existing select 1), _existing select 2]];
} else {
    BZN_visor_spotted pushBack [_target, _expiry, _spotter];
};
