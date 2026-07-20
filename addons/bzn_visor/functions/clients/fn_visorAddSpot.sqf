params ["_target", "_expiry", ["_spotter", "?"], ["_lines", []]];

// Runs on every client (remoteExec to 0) to register a Zeus-marked target's
// 3D tag. BZN_visor_spotted holds [unit, expiry, spotter, lines] entries:
//   expiry  — mission time the mark fades, or -1 for an untimed mark that
//             holds until the target dies. Computed once by the marking
//             curator's dialog (fn_visorZeusMark.sqf) and broadcast as-is —
//             mission `time` is synced, and a per-receiver recompute would
//             drift the countdown between clients.
//   lines   — up to three [text, colourIndex] context rows (0 Red / 1 Blue /
//             2 Yellow) typed into the module's dialog; empty texts are
//             skipped at render time.
// The broadcast is deliberately one-shot and untracked: no JIP queue, no
// refresh — clients that join later simply won't have the mark.
if (!hasInterface) exitWith {};                  // skip dedicated server / HC

if (isNil "BZN_visor_spotted") then { BZN_visor_spotted = []; };

// Drop expired/dead entries (untimed -1 marks only prune on death), then add
// or REPLACE this target's entry — replacing (rather than merging expiries)
// makes re-placing the module on a unit the way a curator "edits" its mark.
BZN_visor_spotted = BZN_visor_spotted select {
    ((_x select 1) < 0 or { time <= (_x select 1) })
    and { !isNull (_x select 0) }
    and { alive (_x select 0) }
};

private _idx = BZN_visor_spotted findIf { (_x select 0) == _target };
if (_idx >= 0) then {
    BZN_visor_spotted set [_idx, [_target, _expiry, _spotter, _lines]];
} else {
    BZN_visor_spotted pushBack [_target, _expiry, _spotter, _lines];
};
