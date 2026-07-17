params ["_logic", "_units", "_activated"];
if (!_activated) exitWith {};

// Zeus module: "Mark Enemy (VISOR)". Placed directly onto a unit in the Zeus
// interface (attachedTo _logic) to add that unit to the shared
// BZN_visor_spotted pool for the configured duration — the sole feed into
// that pool now that all player-driven marking (Spot Target, radar, CQC,
// threat watch) has been removed.
private _target = attachedTo _logic;

// Fallback: curator dropped the module near a unit rather than directly on
// it. Search a small radius for the nearest alive CAManbase or vehicle,
// excluding invisible Zeus/curator bodies (VirtualMan_F and derivatives).
if (isNull _target) then {
    private _candidates = (getPos _logic) nearEntities [["CAManbase", "Car", "Motorcycle", "Tank", "Ship", "Air"], 10];
    _candidates = _candidates select { alive _x and { !(_x isKindOf "VirtualMan_F") } };
    // sort can't compare object elements, so order via BIS_fnc_sortBy instead.
    _candidates = [_candidates, [], { _x distance _logic }, "ASCEND"] call BIS_fnc_sortBy;
    if (_candidates isNotEqualTo []) then { _target = _candidates select 0 };
};

if (isNull _target) exitWith {
    // No unit found — tell the curator and clean up the module. There's no
    // reliable "which curator placed this" handle on the logic, so broadcast
    // to every client: BIS_fnc_showCuratorFeedbackMessage only renders when a
    // curator display is actually open, so non-Zeus players see nothing.
    ["Mark Enemy (VISOR): place the module on a unit"] remoteExec ["BIS_fnc_showCuratorFeedbackMessage", -2];
    deleteVehicle _logic;
};

private _expiry = time + (missionNamespace getVariable ["BZN_visor_zeusMark_duration", 60]);

// remoteExec target 0 does not reliably loop back to the calling machine on
// non-host clients (documented pattern throughout this addon) — call locally
// AND broadcast. BZN_fnc_visorAddSpot is idempotent, so the duplicate local
// call is harmless.
[_target, _expiry, "ZEUS"] call BZN_fnc_visorAddSpot;
[_target, _expiry, "ZEUS"] remoteExec ["BZN_fnc_visorAddSpot", 0];

deleteVehicle _logic;
