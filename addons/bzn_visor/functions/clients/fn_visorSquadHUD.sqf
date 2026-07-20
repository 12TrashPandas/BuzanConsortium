if (isDedicated or !local player) exitWith {};

// Squad health readout (PoC) — one 1 s loop deriving every squad member's
// health state (BZN_fnc_visor_squadHealthDisplay: the network-consistent
// resolver — live for locally-owned units, the owner's broadcast value for
// remote teammates; ACE medical driven with a vanilla lifeState/damage
// fallback) and feeding TWO independently-toggleable outputs:
//
//   1. The STANDALONE corner panel ("Squad health panel (standalone)" Addon
//      Option) — a fixed screen-space roster rendered via a dedicated
//      RscTitles layer (BZN_visor_squadHealthHUD in config.cpp) holding one
//      structured-text control this loop retextures/repositions. cutRsc
//      layers get wiped by respawn/other title effects, so the loop re-cuts
//      whenever the stashed control handle goes null. Corner is the player's
//      choice ("Squad health indicator position": BL/BR/TL/TR; right-hand
//      corners right-align the text so the ragged edge hugs the screen edge).
//
//   2. The DUI (Squad Radar) integration ("Squad health -> DUI Squad Radar"
//      Addon Option) — sets the member's DUI name to their real name plus a
//      colour-coded status suffix: DUI reads diwako_dui_main_customName and
//      inserts it RAW into its structured-text entry, and Arma structured
//      text allows nested <t> tags, so "Name<t color='#ffd91a'> - WND</t>"
//      renders the name in DUI's own unit colour with only the status word
//      recoloured — the unit's team colour is never touched.
//
//      The base name is ALWAYS derived fresh from ACE_Name/name — never read
//      back from diwako_dui_main_customName — so our own suffix can never be
//      captured and re-appended (which used to double it into "Name - CRIT -
//      WND") OR get frozen on a dead/left unit (which left corpses stuck
//      showing a stale status). On cleanup we simply clear our override and
//      DUI falls back to its own name. Trade-off: while a member is in the
//      squad we override any mission-set DUI custom name with their real
//      name — acceptable, and far more robust than trying to preserve and
//      restore a value we also write to. Local setVariable only.
//
// Both outputs only run while VISOR itself is up (device/vehicle grant +
// master display toggle) — this is a VISOR readout, not a freestanding
// squad monitor.

private _layer     = "BZN_visor_squadHealthHUD" call BIS_fnc_rscLayer;
private _duiLoaded = isClass (configFile >> "CfgPatches" >> "diwako_dui_main");

// Units whose DUI name we've overridden — so leavers / aged-out KIA / a
// toggled-off integration get their override cleared.
private _duiTouched = [];

while { true } do {
    private _ctrl = uiNamespace getVariable ["BZN_visor_squadHealthHUD_ctrl", controlNull];

    // (Re-)create the title layer if it's missing — first run, after respawn,
    // or after anything else wiped the RscTitles layer.
    if (isNull _ctrl) then {
        _layer cutRsc ["BZN_visor_squadHealthHUD", "PLAIN", 0, false];
        _ctrl = uiNamespace getVariable ["BZN_visor_squadHealthHUD_ctrl", controlNull];
    };

    private _visorUp   = BZN_visor_userEnabled and { BZN_visor_friendly_active } and { alive player };
    private _showPanel = _visorUp and { BZN_visor_squadHealth_panel };
    private _duiActive = _visorUp and { _duiLoaded } and { BZN_visor_squadHealth_dui };

    if (!_showPanel and { !isNull _ctrl }) then {
        _ctrl ctrlSetStructuredText parseText "";
    };

    private _members = [];
    if (_showPanel or _duiActive) then {
        // You first, then the rest of the group, then tracked KIA bodies
        // (dead units leave the group instantly — fn_visorAlwaysOn's roster
        // diff keeps their bodies listed, [body, expiry], so the readout
        // still reports them as KIA until they age out of the linger window).
        _members = [player] + ((units group player) - [player]);
        { _members pushBackUnique (_x select 0) } forEach BZN_visor_squadDead;

        private _corner    = missionNamespace getVariable ["BZN_visor_squadHealth_position", "BR"];
        private _right     = _corner in ["BR", "TR"];
        private _alignAttr = ["", "align='right' "] select _right;

        // Header cyan matches the 3D IFF designator colour ([0.3,0.9,1] = #4DE6FF).
        private _lines = [format ["<t %1size='1.1' color='#4de6ff' font='PuristaSemiBold'>SQUAD</t>", _alignAttr]];

        {
            private _unit   = _x;
            private _health = [_unit] call BZN_fnc_visor_squadHealthDisplay;
            // KIA is mid-grey, not true black — the panel floats over the 3D
            // scene with no backing, so black would vanish at night.
            private _hex   = ["#26e633", "#ffd91a", "#ff2619", "#4d4d4d"] select _health;
            // Short state words so long names + state stay glanceable.
            // Panel: healthy members show no suffix (the green square
            // already says it). DUI: healthy members read " - OK" instead —
            // there's no colour-coded square in DUI's list, so an explicit
            // green OK is the healthy signal there.
            private _state = ["", " - WND", " - CRIT", " - KIA"] select _health;

            if (_showPanel) then {
                // Dash-joined so the state reads as part of the member's line
                // ("■ Name - CRIT"), not a word that wraps onto its own row.
                _lines pushBack format [
                    "<t %1size='1' color='%2'>■ %3%4</t>",
                    _alignAttr, _hex, name _unit, _state
                ];
            };

            if (_duiActive) then {
                // Show the status suffix for every ALIVE member — OK / WND /
                // CRIT, including downed (unconscious) and cardiac-arrest
                // casualties, so the radar list stays informative rather than
                // going blank when someone drops. On DEATH we clear it AND
                // repair DUI's frozen nametag cache (see BZN_fnc_visor_duiClear
                // — DUI's cache loop skips dead units, so a corpse would
                // otherwise keep our last suffix on its 3D nametag). KIA shows
                // on the standalone panel.
                if (alive _unit) then {
                    _duiTouched pushBackUnique _unit;
                    _unit setVariable ["BZN_visor_dui_owned", true];
                    // Base derived fresh from the real name every cycle — never
                    // read back from our own output (see the rationale up top).
                    private _base     = _unit getVariable ["ACE_Name", name _unit];
                    private _duiState = [" - OK", " - WND", " - CRIT"] select _health;
                    _unit setVariable ["diwako_dui_main_customName", format ["%1<t color='%2'>%3</t>", _base, _hex, _duiState]];
                } else {
                    if (_unit getVariable ["BZN_visor_dui_owned", false]) then {
                        [_unit] call BZN_fnc_visor_duiClear;
                    };
                    _duiTouched = _duiTouched - [_unit];
                };
            };
        } forEach _members;

        if (_showPanel and { !isNull _ctrl }) then {
            // Width first (text height depends on wrap width), then measure,
            // then anchor to the chosen corner — bottom corners grow upward
            // so the list never slides off screen as the squad grows. Wide
            // enough that "■ <long name> - CRIT" stays on one line.
            private _w      = 0.3;
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

    // Override cleanup: integration off entirely, or an overridden unit is no
    // longer shown (left the squad, aged out of the KIA window, or its body
    // was deleted) — clear our DUI name override (DUI falls back to its own
    // name) and stop tracking it.
    if (_duiTouched isNotEqualTo []) then {
        private _stale = _duiTouched select { !_duiActive or { isNull _x } or { !(_x in _members) } };
        { [_x] call BZN_fnc_visor_duiClear } forEach _stale;
        _duiTouched = _duiTouched - _stale;
    };

    sleep 1;
};
