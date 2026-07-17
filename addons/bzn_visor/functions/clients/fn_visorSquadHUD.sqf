if (isDedicated or !local player) exitWith {};

// Fixed screen-space squad health HUD (PoC) — a small corner panel listing
// every member of the player's current group (you first, then squadmates,
// then tracked KIA bodies — see fn_visorAlwaysOn.sqf's roster diff) with a
// colour-coded health state from BZN_fnc_visor_squadHealthState (ACE
// medical driven; vanilla lifeState/damage fallback).
//
// Deliberately NOT part of the 3D IFF overlay: squad health is a "how is my
// team doing" readout you want in a stable, glanceable spot on screen, not
// scattered across the world wherever your squadmates happen to be standing.
// Rendered via a dedicated RscTitles layer (see BZN_visor_squadHealthHUD in
// config.cpp) holding one structured-text control that this loop retextures
// and repositions each second. cutRsc layers survive most UI churn but get
// wiped by respawn/other title effects, so the loop re-cuts whenever the
// stashed control handle goes null rather than trusting a one-shot setup.
//
// Which corner it sits in is the player's choice — "Squad health indicator
// position" in Addon Options (BZN_visor_squadHealth_position: BL/BR/TL/TR).
// The panel is right-aligned in the right-hand corners so its ragged edge
// hugs the screen edge instead of pointing into it.

private _layer = "BZN_visor_squadHealthHUD" call BIS_fnc_rscLayer;

while { true } do {
    private _ctrl = uiNamespace getVariable ["BZN_visor_squadHealthHUD_ctrl", controlNull];

    // (Re-)create the title layer if it's missing — first run, after respawn,
    // or after anything else wiped the RscTitles layer.
    if (isNull _ctrl) then {
        _layer cutRsc ["BZN_visor_squadHealthHUD", "PLAIN", 0, false];
        _ctrl = uiNamespace getVariable ["BZN_visor_squadHealthHUD_ctrl", controlNull];
    };

    if (!isNull _ctrl) then {
        // Visible only while the squad-health option is on AND VISOR itself
        // is up (device/vehicle grant active + master display toggle) — this
        // is a VISOR readout, not a freestanding squad monitor.
        private _show = BZN_visor_squadHealth_enabled
            and { BZN_visor_userEnabled }
            and { BZN_visor_friendly_active }
            and { alive player };

        if (!_show) then {
            _ctrl ctrlSetStructuredText parseText "";
        } else {
            private _corner    = missionNamespace getVariable ["BZN_visor_squadHealth_position", "BR"];
            private _right     = _corner in ["BR", "TR"];
            private _alignAttr = ["", "align='right' "] select _right;

            // You first, then the rest of the group, then tracked KIA bodies
            // (dead units leave the group instantly — fn_visorAlwaysOn's
            // roster diff keeps their bodies listed so the HUD still reports
            // them as KIA instead of silently dropping the line).
            private _members = [player] + ((units group player) - [player]);
            { _members pushBackUnique _x } forEach BZN_visor_squadDead;

            private _lines = [format ["<t %1size='1.1' color='#73d1ff' font='PuristaSemiBold'>SQUAD</t>", _alignAttr]];
            {
                private _health = [_x] call BZN_fnc_visor_squadHealthState;
                // KIA is mid-grey, not true black — this floats over the 3D
                // scene with no backing panel, so black would vanish at night.
                private _color = ["#26e633", "#ffd91a", "#ff2619", "#4d4d4d"] select _health;
                private _state = ["", " WOUNDED", " CRITICAL", " KIA"] select _health;
                _lines pushBack format [
                    "<t %1size='1' color='%2'>■ %3%4</t>",
                    _alignAttr, _color, name _x, _state
                ];
            } forEach _members;

            // Width first (text height depends on wrap width), then measure,
            // then anchor to the chosen corner — bottom corners grow upward
            // so the list never slides off screen as the squad grows.
            private _w      = 0.25;
            private _margin = 0.008;
            _ctrl ctrlSetPosition [0, 0, _w, 0.3];
            _ctrl ctrlCommit 0;
            _ctrl ctrlSetStructuredText parseText (_lines joinString "<br/>");
            private _h = ctrlTextHeight _ctrl;
            private _x = [safezoneX + _margin, safezoneX + safezoneW - _w - _margin] select _right;
            private _y = [safezoneY + _margin, safezoneY + safezoneH - _h - _margin] select (_corner in ["BL", "BR"]);
            _ctrl ctrlSetPosition [_x, _y, _w, _h];
            _ctrl ctrlCommit 0;
        };
    };

    sleep 1;
};
