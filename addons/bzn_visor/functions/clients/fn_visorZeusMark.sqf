if (!hasInterface) exitWith {};

// Zeus "Mark Target (VISOR)" — dialog controller. Invoked on the PLACING
// curator's own machine by the CuratorObjectPlaced handler in
// fn_VISORpostInit.sqf (a server-side module function can't open UI, which is
// why the module class declares no function). Opens the configuration dialog
// (BZN_visor_ZeusMarkDialog, config.cpp): up to three free-text context
// lines with a Red/Blue/Yellow colour each, plus an optional expiry timer.
//
// On MARK, the result is broadcast ONCE to every currently connected player
// (remoteExec 0) and then deliberately forgotten — no JIP queue, no LOS or
// refresh tracking, no later sync. Players who join after a mark is placed
// simply won't see it; re-place the module if it matters. The module logic
// deletes itself on every exit path (MARK, CANCEL, ESC).
params ["_logic"];

BZN_visor_zeusMark_logic = _logic;

// deleteVehicle only runs where the object is LOCAL. Curator-placed logic
// isn't reliably server-local across configs, so target the object itself —
// remoteExec routes to whichever machine actually owns it.
if (!createDialog "BZN_visor_ZeusMarkDialog") exitWith {
    if (!isNull _logic) then { [_logic] remoteExec ["deleteVehicle", _logic] };
};

private _display = uiNamespace getVariable ["BZN_visor_zeusMarkDisplay", displayNull];
if (isNull _display) exitWith {
    if (!isNull _logic) then { [_logic] remoteExec ["deleteVehicle", _logic] };
};

// Colour choice per line — index is what gets broadcast (0 Red / 1 Blue / 2
// Yellow), matching the mark-line palette in fn_visorRenderEngine.sqf.
{
    private _combo = _display displayCtrl _x;
    _combo lbAdd "Red";
    _combo lbAdd "Blue";
    _combo lbAdd "Yellow";
    _combo lbSetCurSel 0;
} forEach [1701, 1702, 1703];

(_display displayCtrl 1801) cbSetChecked true;

(_display displayCtrl 1900) ctrlAddEventHandler ["ButtonClick", {
    params ["_ctrl"];
    private _display = ctrlParent _ctrl;
    private _logic   = BZN_visor_zeusMark_logic;

    // Resolve the target at confirm time — by now any drop-on-unit attachment
    // has long since settled while the curator was filling in the dialog.
    private _target = attachedTo _logic;
    if (isNull _target) then {
        private _candidates = (getPos _logic) nearEntities [["CAManbase", "Car", "Motorcycle", "Tank", "Ship", "Air"], 10];
        _candidates = _candidates select { alive _x and { !(_x isKindOf "VirtualMan_F") } };
        // sort can't compare object elements, so order via BIS_fnc_sortBy.
        _candidates = [_candidates, [], { _x distance _logic }, "ASCEND"] call BIS_fnc_sortBy;
        if (_candidates isNotEqualTo []) then { _target = _candidates select 0 };
    };

    if (isNull _target) then {
        ["Mark Target (VISOR): no unit found near the module"] call BIS_fnc_showCuratorFeedbackMessage;
    } else {
        private _lines = [];
        {
            _x params ["_editIdc", "_comboIdc"];
            _lines pushBack [ctrlText (_display displayCtrl _editIdc), 0 max lbCurSel (_display displayCtrl _comboIdc)];
        } forEach [[1601, 1701], [1602, 1702], [1603, 1703]];

        // -1 = untimed: the mark stays until the target dies (or the mission ends).
        private _expiry = -1;
        if (cbChecked (_display displayCtrl 1801)) then {
            private _secs = parseNumber ctrlText (_display displayCtrl 1802);
            if (_secs <= 0) then { _secs = 60 };
            _expiry = time + _secs;
        };

        // Local call + broadcast — remoteExec 0 doesn't reliably loop back to
        // the caller on non-host clients (documented pattern in this addon);
        // AddSpot replaces any existing entry for the unit, so re-marking is
        // also how you "edit" a mark.
        [_target, _expiry, "ZEUS", _lines] call BZN_fnc_visorAddSpot;
        [_target, _expiry, "ZEUS", _lines] remoteExec ["BZN_fnc_visorAddSpot", 0];
    };

    _display closeDisplay 1;
}];

(_display displayCtrl 1901) ctrlAddEventHandler ["ButtonClick", {
    params ["_ctrl"];
    (ctrlParent _ctrl) closeDisplay 2;
}];

// Every way out of the dialog (MARK, CANCEL, ESC) lands here — clean up the
// placed module logic. deleteVehicle must run where the logic is local, so
// target the object itself (remoteExec routes to its owner); deleting an
// already-deleted object is a no-op.
_display displayAddEventHandler ["Unload", {
    private _logic = BZN_visor_zeusMark_logic;
    if (!isNull _logic) then { [_logic] remoteExec ["deleteVehicle", _logic] };
    BZN_visor_zeusMark_logic = objNull;
}];
