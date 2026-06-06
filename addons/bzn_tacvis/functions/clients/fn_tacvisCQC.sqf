if (isDedicated or !local player) exitWith {};
if (BZN_tacvis_CQC_cooldown) exitWith {};

// Toggle off if already running — the active scan loop handles cleanup.
if (BZN_tacvis_CQC_active) exitWith {
    BZN_tacvis_CQC_active = false;
};

// -------------------------------------------------------------------------
// Activate CQC
// -------------------------------------------------------------------------
BZN_tacvis_CQC_active = true;
playSound "vto_tacvis_sound_on";

private _scanRange  = 50 + random [-5, 0, 5];
private _startTime  = time;
private _maxTime    = 30;
private _maxUnits   = 10;

// Main scan loop
while {
    BZN_tacvis_CQC_active
    and time < _startTime + _maxTime
    and alive player
    and (headgear player in BZN_tacvis_devices_cqc or goggles player in BZN_tacvis_devices_cqc)
} do {
    private _near = player nearEntities [["CAManbase", "Car", "Motorcycle", "Tank", "Air", "Ship"], _scanRange];
    _near = _near select { alive _x and _x != player };

    if (count _near > _maxUnits) then {
        _near = [_near, [], { player distance _x }, "ASCEND"] call BIS_fnc_sortBy;
        _near resize _maxUnits;
    };

    BZN_tacvis_pool_CQC = _near;
    playSound "vto_tacvis_sound_beep";

    hintSilent parseText format [
        "<t size='1.3' color='#ff3030'>TACVIS CQC</t><br/><t size='1.1'>Active: %1s</t>",
        ceil (_startTime + _maxTime - time)
    ];

    sleep 1;
};

// -------------------------------------------------------------------------
// Deactivate
// -------------------------------------------------------------------------
BZN_tacvis_CQC_active = false;
BZN_tacvis_pool_CQC   = [];
playSound "vto_tacvis_sound_off";

// Remove CQC action and start cooldown
{
    if ((player actionParams _x) select 0 == "Toggle CQC") then { player removeAction _x };
} forEach actionIDs player;
BZN_tacvis_CQC_action = -1;

BZN_tacvis_CQC_cooldown = true;
private _cooldownDuration = round (random [60, 90, 180]);

[_cooldownDuration] spawn {
    private _end = time + (_this select 0);
    while { time < _end } do {
        hintSilent parseText format [
            "<t size='1.3' color='#ff3030'>TACVIS CQC</t><br/><t size='1.1'>Cooldown: %1s</t>",
            ceil (_end - time)
        ];
        sleep 1;
    };
    BZN_tacvis_CQC_cooldown = false;
    hintSilent parseText "<t size='1.3' color='#30ff30'>TACVIS CQC</t><br/><t size='1.1'>Ready</t>";
    sleep 3;
    hintSilent "";
    if (alive player and (headgear player in BZN_tacvis_devices_cqc or goggles player in BZN_tacvis_devices_cqc)) then {
        BZN_tacvis_CQC_action = player addAction [
            "Toggle CQC",
            { [] spawn BZN_fnc_tacvisCQC },
            [], 1.4, false, true, "", "true"
        ];
    };
};
