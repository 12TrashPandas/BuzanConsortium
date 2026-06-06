params ["_contacts"];

// Runs on every client (remoteExec to 0) to merge a radar operator's detected
// contacts into the shared, time-stamped radar list. Each entry is [unit, expiry];
// mission time is synced, so the operator-computed expiry is valid everywhere.
if (!hasInterface) exitWith {};                  // skip dedicated server / HC
if (isNil "BZN_tacvis_radar") then { BZN_tacvis_radar = []; };

// Drop expired entries, then add or refresh each incoming contact.
BZN_tacvis_radar = BZN_tacvis_radar select { time <= (_x select 1) };

{
    _x params ["_u", "_exp"];
    private _idx = BZN_tacvis_radar findIf { (_x select 0) == _u };
    if (_idx >= 0) then {
        BZN_tacvis_radar set [_idx, [_u, _exp]];
    } else {
        BZN_tacvis_radar pushBack [_u, _exp];
    };
} forEach _contacts;
