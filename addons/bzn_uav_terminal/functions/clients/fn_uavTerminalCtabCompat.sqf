/*
 * Author: Buzan Consortium Mod Team
 *
 * Makes cTab recognise the Buzan UAV terminals (Bzn_UavTerminal_B/O/I) as
 * tablet devices, alongside its own ItemcTab/ItemAndroid/ItemMicroDAGR.
 *
 * cTab has no whitelist setting or base-class check for this - cTab_fnc_checkGear
 * does a hardcoded exact-classname match against the unit's gear (see
 * Riouken/cTab functions/fn_checkGear.sqf). We wrap that function so every
 * call also searches for our classnames. This is a function-patch: fragile by
 * nature - if a future cTab build renames/restructures cTab_fnc_checkGear, the
 * waitUntil below simply times out and this becomes a no-op (terminals keep
 * working as terminals, they just won't be picked up by cTab).
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

[
    { !isNil "cTab_fnc_checkGear" },
    {
        if (!isNil "BZN_uavTerminal_ctabPatched") exitWith {};
        BZN_uavTerminal_ctabPatched = true;

        BZN_uavTerminal_ctabClassnames = ["Bzn_UavTerminal_B", "Bzn_UavTerminal_O", "Bzn_UavTerminal_I"];
        BZN_uavTerminal_ctabCheckGear_orig = cTab_fnc_checkGear;

        cTab_fnc_checkGear = {
            params ["_unit", ["_search", []]];
            [_unit, (_search + BZN_uavTerminal_ctabClassnames)] call BZN_uavTerminal_ctabCheckGear_orig
        };
    },
    [],
    30
] call CBA_fnc_waitUntilAndExecute;
