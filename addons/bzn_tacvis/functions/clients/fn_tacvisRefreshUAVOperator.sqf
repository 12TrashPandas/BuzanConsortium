params ["_uav", "_name", "_expiry"];

// Runs on every client (remoteExec to 0). Broadcast once a second by whoever is
// currently remotely connected to a friendly drone (see the UAV-uplink loop in
// fn_TACVISpostInit.sqf) — there's no native "who is connected to this UAV"
// query, so the operator announces themselves to the team instead. Short
// per-broadcast expiry means a disconnect (or dropped connection) clears the
// entry on its own within a couple seconds, with no explicit teardown needed.
// Same idempotent [thing, ..., expiry]-tuple shape/merge as
// BZN_tacvis_radar/_spotted/_threat.
if (!hasInterface) exitWith {};
if (isNil "BZN_tacvis_uavOperators") then { BZN_tacvis_uavOperators = []; };

private _idx = BZN_tacvis_uavOperators findIf { (_x select 0) == _uav };
if (_idx >= 0) then {
    BZN_tacvis_uavOperators set [_idx, [_uav, _name, _expiry max ((BZN_tacvis_uavOperators select _idx) select 2)]];
} else {
    BZN_tacvis_uavOperators pushBack [_uav, _name, _expiry];
};
