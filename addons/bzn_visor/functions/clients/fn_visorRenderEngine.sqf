if (isDedicated) exitWith {};

BZN_visor_Display = addMissionEventHandler ["Draw3D", {

    if (!BZN_visor_userEnabled) exitWith {};

    // Live Zeus-marked contacts (expiry-filtered; expiry -1 = untimed, only
    // pruned on death). Tuples are [unit, expiry, spotter, lines] — lines
    // being the up-to-three [text, colourIndex] context rows the curator
    // typed into the module dialog. Marks are shared across clients
    // (broadcast once by fn_visorZeusMark via fn_visorAddSpot); rendering is
    // still range-limited by the alpha fade below.
    private _spottedTuples = BZN_visor_spotted select {
        ((_x select 1) < 0 or { time <= (_x select 1) })
        and { !isNull (_x select 0) }
        and { alive (_x select 0) }
    };
    // Marks require the viewer to PERSONALLY wear a VISOR device (helmet/
    // goggles) — an approved vehicle alone grants the friendly IFF picture
    // but not the marked-target feed, so every user needs the kit to read
    // marks. Drop all marks for this frame if it's off: they then never
    // enter the pool, never draw a hex, and never draw their context lines.
    if !(call BZN_fnc_visor_hasPersonalDevice) then { _spottedTuples = [] };
    private _spottedObjs   = _spottedTuples apply { _x select 0 };
    // Friendly drones' remote operators — self-announced (see the UAV-uplink
    // loop in fn_VISORpostInit.sqf); kept tuple-shaped [uav, name, expiry] so
    // a dropped connection ages out on its own within a couple seconds.
    private _uavOperatorTuples = if (isNil "BZN_visor_uavOperators") then { [] } else {
        BZN_visor_uavOperators select { (time <= (_x select 2)) and { !isNull (_x select 0) } }
    };

    // Combine all pools; pushBackUnique avoids double-rendering. Zeus-marked
    // enemies arrive via pool_friendly (merged in by fn_visorAlwaysOn) and
    // are also tracked directly via _spottedObjs below.
    private _pool = [];
    { _pool pushBackUnique _x } forEach BZN_visor_pool_friendly;

    // Vehicles are only tagged if marked or a crewed allied vehicle.
    // Empty/unmanned vehicles report side civilian (which reads as friendly), so
    // the friendly branch requires real crew and a non-civilian side. Infantry kept.
    _pool = _pool select {
        // Exclude Zeus/curator placeholder bodies (VirtualCurator_F and other
        // invisible Game Master entities all derive from VirtualMan_F) — these
        // can otherwise slip into scans and render as stray "UNKNOWN" tags.
        !(_x isKindOf "VirtualMan_F")
        and (
            (_x isKindOf "CAManbase")
            or { _x in _spottedObjs }
            or {
                ((side _x) getFriend (side player) >= 0.8)
                and { side _x != civilian }
                and { ({alive _x} count crew _x) > 0 }
            }
        )
        // All friendly-side infantry are tagged — players AND AI alike. Buzan
        // runs PvE co-op, so allied NPCs are real teammates the IFF picture
        // has to include, not background noise (an isPlayer-only gate here is
        // exactly why "no friendly tags on NPCs" bugs get reported). Civilians
        // stay untagged (side civilian reads friendly via getFriend, hence the
        // explicit side check), Zeus-marked contacts are always tactically
        // relevant regardless of side, and VIP/HVT-flagged units stay visible
        // no matter their side — that's the entire point of flagging someone
        // "don't take off the board."
        and {
            !(_x isKindOf "CAManbase")
            or { ((side _x) getFriend (side player) >= 0.8) and { side _x != civilian } }
            or { _x getVariable ["BZN_visor_VIP", false] }
            or { _x getVariable ["BZN_visor_HVT", false] }
            or { _x in _spottedObjs }
        }
        // Equipment gate: a friendly is only shown if it carries VISOR itself
        // (see BZN_fnc_visor_unitHasDevice) — an unequipped teammate doesn't
        // transmit and stays invisible, the same "you need the kit" rule that
        // applies to viewers. Zeus-marked targets and VIP/HVT-flagged units
        // bypass this: a curator/mission deliberately put them on the board,
        // so they show regardless of gear.
        and {
            (_x in _spottedObjs)
            or { _x getVariable ["BZN_visor_VIP", false] }
            or { _x getVariable ["BZN_visor_HVT", false] }
            or { [_x] call BZN_fnc_visor_unitHasDevice }
        }
        // "Friendly markers" toggle hides only units that read as friendly to
        // the player — Zeus-marked contacts (always hostile/neutral by
        // definition) are unaffected.
        and { !BZN_visor_hideFriendlyMarkers or { ((side _x) getFriend (side player) < 0.8) } }
    };

    // Chassis bucket for the vehicle designator type line further down
    // (BZN AIR / BZN SEA / BZN GRND). This used to feed an infantry
    // clustering pass too — that whole system was removed once the pool
    // became effectively friendlies-only (hostiles now only appear as
    // cluster-exempt Zeus marks), leaving it aggregating nothing but
    // teammates into hostile-flavoured "INFANTRY xN | ARMED" summaries.
    // The compact two-line designators carry the declutter load on their own.
    private _typeBucket = {
        params ["_u"];
        if (_u isKindOf "CAManbase")                 exitWith { "INFANTRY" };
        if (unitIsUAV _u)                            exitWith { "DRONE" };
        if (_u isKindOf "Air")                       exitWith { "AIR" };
        if (_u isKindOf "Ship")                      exitWith { "SEA" };
        if (_u isKindOf "Car" or _u isKindOf "Tank") exitWith { "GROUND" };
        "OTHER"
    };

    // ---- Compact-tag classification ----------------------------------------
    // Ordinary infantry render the compact designator only (hex bracketed by
    // type line and name/status word) — the fuller distance/grid/status
    // stack would be noise on every rifleman. HVT-flagged (`BZN_visor_HVT`),
    // VIP-flagged (`BZN_visor_VIP` — see the PROTECT/TAKE ALIVE override
    // below), Zeus-marked, and hostile launcher-carrying infantry are exempt
    // — they're priority individuals and always show in full. Vehicles,
    // aircraft, ships, and drones are unaffected too — they're rarely
    // numerous enough to clutter and their crew/operator detail is exactly
    // what you want glanceable. The "Toggle Detail Mode" keybind sits above
    // all of this: switched OFF, no text renders at all — bare hexagons only.
    private _hideableInfantry = _pool select {
        _x isKindOf "CAManbase"
        and { alive _x }
        and { !(_x getVariable ["BZN_visor_HVT", false]) }
        and { !(_x getVariable ["BZN_visor_VIP", false]) }
        // Zeus-marked targets always render in full — a curator marked them
        // precisely so everyone keeps eyes (and the mark's context lines) on
        // them; gating that down to a reduced tag would defeat the point.
        and { !(_x in _spottedObjs) }
        // Hostile/neutral launcher carriers stay exempt — they're the
        // priority-threat callout that should never collapse to a reduced
        // tag. Friendly launcher gunners aren't a threat though, so they
        // stay compact like any other teammate (their designator carries the
        // " - AT" name suffix, so you don't lose track of the team's AT/AA).
        and {
            secondaryWeapon _x == ""
            or { (side _x) getFriend (side player) >= 0.8 or side player == side _x }
        }
    };

    {
        private _unit = _x;

        private _bucket = [_unit] call _typeBucket;

        // Compact designator for ordinary infantry (see the classification
        // pre-pass above). Only consulted while Detail Mode is ON — OFF
        // renders bare hexagons, no text at all.
        private _isDetailHidden = _unit in _hideableInfantry;

        // Hex-only vehicles: a vehicle/aircraft/ship that ISN'T on the
        // approved-vehicles whitelist shows just its IFF hexagon — no type,
        // crew/OP, or status text. Only whitelisted platforms (VISOR-equipped
        // by definition) earn a full readout. Zeus-marked, HVT, and VIP
        // platforms are exempt — a curator/mission deliberately called them
        // out, so their tag always shows in full.
        private _hexOnly = !(_unit isKindOf "CAManbase")
            and { !((typeOf _unit) in BZN_visor_vehicles) }
            and { !(_unit in _spottedObjs) }
            and { !(_unit getVariable ["BZN_visor_HVT", false]) }
            and { !(_unit getVariable ["BZN_visor_VIP", false]) };

        // ---- Stance-based Z offset ----------------------------------------
        // HALO-drone-feed styling: the hex designator anchors at CHEST height
        // with the "BZN INF" type line floating above it and the name below —
        // a centred stack that doesn't need the old "shift the text sideways
        // to dodge the model" logic.
        private _textOffsetZ = 0;

        switch (stance _unit) do {
            case "STAND"     : { _textOffsetZ = 1.25 };
            case "CROUCH"    : { _textOffsetZ = 0.9 };
            case "PRONE"     : { _textOffsetZ = 0.35 };
            case "UNDEFINED" : { _textOffsetZ = 1.25 };
            case ""          : { _textOffsetZ = 0 };
        };

        // ---- World-space draw positions -----------------------------------
        // ONE shared anchor for the hex AND the text stack. Any constant
        // world-space offset between them (there used to be a +0.05 m nudge on
        // the text) subtends a growing screen offset as the camera closes in —
        // at 2 m it dwarfs the distance-scaled line gaps and shoves the whole
        // text stack off the hex. Identical anchors + gap-multiple offsets
        // keep the layout locked at every range.
        private _targetPosition = _unit modelToWorldVisual [0, 0, _textOffsetZ];

        // ---- Constant screen-space line spacing ----------------------------
        // The line gap is a world-space vector, but its length is derived from
        // camera distance × current FOV so it always subtends the SAME
        // fraction of the screen: visible world height at distance D is
        // proportional to D × fov (fov being Arma's tangent-style zoom value
        // from getObjectFOV), so gap = k × D × fov projects to a fixed screen
        // step at any range and any optic zoom. drawIcon3D text is already
        // screen-constant, so lines can never drift together and overlap the
        // way the old per-FOV-bracket lookup-table heuristic allowed.
        // Direction comes straight from the camera's own up axis
        // (positionCameraToWorld basis), which stays correct while leaning,
        // in vehicle seats, and on UAV feeds alike.
        private _camPos   = positionCameraToWorld [0, 0, 0];
        private _fov      = getObjectFOV player;
        private _fovCoeff = (1 - _fov) * 0.006;
        private _camUp    = vectorNormalized ((positionCameraToWorld [0, 1, 0]) vectorDiff _camPos);
        private _camDist  = _targetPosition distance _camPos;

        // Progressive long-range shrink: the whole designator (hex, text, and
        // line spacing together, so the layout keeps its proportions) scales
        // linearly from full size up close down to the configured minimum at
        // the configured range, clamped there ("Tag shrink range" / "Tag
        // minimum scale" Addon Options; defaults half size at 5 km, minimum
        // 1 disables shrinking). From a heli/jet the sky would otherwise
        // fill with full-size designators; at range they now read as
        // smaller, quieter contacts.
        // Keyed off APPARENT distance — actual distance scaled by current
        // zoom relative to the ~0.75 default FOV — so zooming an optic onto a
        // distant contact grows its tag back toward full size: what you see
        // through the glass matches what you'd see standing that much closer.
        private _distScale = linearConversion [0, BZN_visor_scale_range, _camDist * (_fov / 0.75), 1, BZN_visor_scale_min, true];

        // 0.022 clears the hex comfortably — the type/name lines sit one step
        // out and were touching the hex edges at the old 0.016 step.
        private _drawUp   = _camUp vectorMultiply (0.022 * _camDist * _fov * _distScale);

        // Text stacks around the chest-anchored hex: the "BZN INF" type line
        // sits one step ABOVE it (distance rides a step higher in the full
        // view), the name below, then grid/MARKED and the status detail line
        // descending. The below-hex slots are pulled UP by 0.35 of a step:
        // drawIcon3D text hangs downward from its anchor point, so a line one
        // step above the hex reads visually tight against it while a line one
        // step below drifts away — the bias makes the gaps symmetric while
        // keeping full one-step spacing between the descending lines.
        private _drawPosUp    = _targetPosition vectorAdd _drawUp;
        private _drawPosUp2   = _targetPosition vectorAdd (_drawUp vectorMultiply 2);
        private _drawPosDown  = _targetPosition vectorAdd (_drawUp vectorMultiply -0.65);
        private _drawPosDown2 = _targetPosition vectorAdd (_drawUp vectorMultiply -1.65);
        private _drawPosDown3 = _targetPosition vectorAdd (_drawUp vectorMultiply -2.65);

        private _size1 = (0.021  + _fovCoeff) * _distScale;
        private _size2 = (0.022  + _fovCoeff) * _distScale;
        private _size3 = (0.021  + _fovCoeff) * _distScale;
        private _size4 = (0.0175 + _fovCoeff) * _distScale;
        private _size5 = (0.015  + _fovCoeff) * _distScale;

        // Compact HALO-style marker — small enough to read as a designator
        // on the chest rather than a splash covering the torso. Drawn at
        // EXACTLY the shared anchor (see _targetPosition above) so the hex
        // and text stack can never drift apart as the camera closes in.
        private _HexSize     = [0.8 * _distScale, 0.8 * _distScale];
        private _HexPosition = _targetPosition;

        // ---- Colours ------------------------------------------------------
        // Tags fade with distance and vanish around the player-configurable
        // per-class range ("Infantry/Vehicle fade range" Addon Options) —
        // infantry read one slider, everything with a chassis the other.
        private _fadeRange      = [BZN_visor_fade_vehicle, BZN_visor_fade_infantry] select (_unit isKindOf "CAManbase");
        private _alpha          = 0.95 - (player distance _unit) / _fadeRange;
        // HALO/UNSC-style bright cyan for friendly IFF (think ODST drone-feed
        // designators) — tints the WHITE hex texture rather than using a
        // dedicated blue .paa (there isn't one; tinting white gives a clean
        // arbitrary colour).
        private _colorFRIENDLY  = [0.3, 0.9, 1, _alpha];
        private _colorRED       = [0.75, 0, 0, _alpha];
        private _colorORANGE    = [1, 0.8, 0, _alpha];
        private _colorORANGEdark= [0.8, 0.6, 0, _alpha];
        private _colorWHITEdark = [0.871, 0.871, 0.871, _alpha];
        private _colorVIP       = [0.1, 0.4, 1, _alpha]; // deep royal blue — distinct from both HOSTILE red and the new pale-cyan FRIENDLY, and from HVT violet
        private _colorHVT       = [0.65, 0.25, 1, _alpha]; // distinct violet — "priority kill target" callout, never confused with VIP's protect-blue or neutral orange

        private _HexBase   = "z\bzn\addons\bzn_visor\VISOR_UI\";
        private _HexWHITE  = _HexBase + "VTO_visor_hexWhite.paa";
        private _HexRED    = _HexBase + "VTO_visor_hexRed.paa";
        private _HexORANGE = _HexBase + "VTO_visor_hexOrange.paa";

        private _Hex    = _HexWHITE;
        private _color1 = _colorORANGE;
        private _color2 = _colorORANGEdark;
        private _color3 = _colorWHITEdark;
        private _color4 = _colorWHITEdark;

        switch (true) do {
            case ((side _unit) getFriend (side player) >= 0.8 or side player == side _unit) : {
                _color2 = _colorFRIENDLY; _Hex = _HexWHITE;
                _color1 = _colorFRIENDLY; // distance line matches the cyan designator instead of neutral orange
            };
            case ((side _unit) getFriend (side player) <= 0.3) : {
                _color2 = _colorRED; _Hex = _HexRED;
            };
            case ((side _unit) getFriend (side player) > 0.3 and (side _unit) getFriend (side player) < 0.8) : {
                _color2 = _colorORANGE; _Hex = _HexORANGE;
            };
        };

        // ---- Unit type label ----------------------------------------------
        private _nameUnit = "UNKNOWN";

        switch (alive _unit) do {
            case true : {
                if (_unit isKindOf "CAManbase") then {
                    switch (side _unit) do {
                        case west         : { _nameUnit = "INFANTRY" };
                        case east         : { _nameUnit = "INFANTRY" };
                        case independent         : { _nameUnit = "INFANTRY" };
                        case sideAmbientLife : { _nameUnit = "WILDLIFE";  _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                        case sideUnknown      : { _nameUnit = "UNKNOWN";   _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                        case civilian         : { _nameUnit = "CIVILIAN";  _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                        case sideEmpty        : { _nameUnit = "UNKNOWN";   _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                    };
                    if (name _unit != "" and side _unit == side player) then { _nameUnit = name _unit };
                };
                // Drones (UAV/UGV/UUV) get their own category regardless of chassis —
                // unitIsUAV checks the actual config trait rather than inheritance, so
                // it correctly catches ground/air/sea drones alike before the
                // chassis-based branches below would otherwise label them VEHICLE/
                // AIRCRAFT/SHIP.
                if (unitIsUAV _unit) then {
                    _nameUnit = format ["DRONE - %1", getText (configOf _unit >> "displayName")];
                    switch (side _unit) do {
                        case sideAmbientLife : { _nameUnit = "WILDLIFE";      _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                        case sideUnknown         : { _nameUnit = "UNKNOWN DRONE"; _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                        case civilian            : { _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                        case sideEmpty           : { _nameUnit = "UNKNOWN DRONE"; _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                    };
                    if ({alive _x} count crew _unit == 0) then { _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                } else {
                    if (_unit isKindOf "Car" or _unit isKindOf "Tank") then {
                        _nameUnit = format ["GROUND - %1", getText (configOf _unit >> "displayName")];
                        switch (side _unit) do {
                            case sideAmbientLife : { _nameUnit = "WILDLIFE";        _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                            case sideUnknown         : { _nameUnit = "UNKNOWN VEHICLE"; _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                            case civilian            : { _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                            case sideEmpty           : { _nameUnit = "UNKNOWN VEHICLE"; _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                        };
                        if ({alive _x} count crew _unit == 0) then { _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                    };
                    if (_unit isKindOf "Air") then {
                        _nameUnit = format ["AIR - %1", getText (configOf _unit >> "displayName")];
                        switch (side _unit) do {
                            case sideAmbientLife : { _nameUnit = "WILDLIFE";         _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                            case sideUnknown         : { _nameUnit = "UNKNOWN AIRCRAFT"; _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                            case civilian            : { _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                            case sideEmpty           : { _nameUnit = "UNKNOWN AIRCRAFT"; _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                        };
                        if ({alive _x} count crew _unit == 0) then { _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                    };
                    if (_unit isKindOf "Ship") then {
                        _nameUnit = format ["SEA - %1", getText (configOf _unit >> "displayName")];
                        switch (side _unit) do {
                            case sideAmbientLife : { _nameUnit = "WILDLIFE";    _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                            case sideUnknown         : { _nameUnit = "UNKNOWN SHIP"; _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                            case civilian            : { _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                            case sideEmpty           : { _nameUnit = "UNKNOWN SHIP"; _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                        };
                        if ({alive _x} count crew _unit == 0) then { _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                    };
                };
            };
            case false : {
                _color2 = _colorWHITEdark; _Hex = _HexWHITE;
                _nameUnit = if (_unit isKindOf "CAManbase") then { "DECEASED" } else { "DESTROYED" };
            };
        };

        // ---- Messages -----------------------------------------------------
        // (No trailing "_" padding here anymore — that was a spacing hack for
        // the old left-aligned layout; centred text would render it literally.)
        private _messageCENTER = toUpper _nameUnit;
        private _messageUP     = format ["%1 m", round (player distance _unit)];

        // Zeus mark: pull this unit's tuple (if any) for the curator's custom
        // context lines and the optional expiry. Timed marks show a countdown
        // on the MARKED line; untimed marks (expiry -1) just show the grid.
        // The mark also forces the hostile-red hex regardless of the target's
        // reported side — "Mark Target" means the curator wants THIS one on
        // everyone's display as a called target, even if it's (still) reading
        // as a civilian or neutral to the engine.
        private _markLines = [];

        private _messageDOWN = mapGridPosition _unit;
        switch (true) do {
            case (_unit in _spottedObjs) : {
                _color3 = _colorRED;
                _color2 = _colorRED;
                _Hex    = _HexRED;
                private _idx = _spottedTuples findIf { (_x select 0) == _unit };
                if (_idx >= 0) then {
                    private _tuple  = _spottedTuples select _idx;
                    private _expiry = _tuple select 1;
                    _markLines = _tuple param [3, []];
                    _messageDOWN = if (_expiry >= 0) then {
                        format ["MARKED | %1 | %2s", _messageDOWN, ceil (_expiry - time)]
                    } else {
                        format ["MARKED | %1", _messageDOWN]
                    };
                };
            };
        };

        // HVT override — same idea as the VIP override directly below, but for
        // a "priority kill target" callout: a unit the mission has flagged as
        // worth singling out (mission-side: `_unit setVariable
        // ["BZN_visor_HVT", true]`) gets a "HVT - ELIMINATE" label in a
        // distinct violet, replacing the usual type name — unlike VIP, the
        // call here never varies with side, since "priority kill target"
        // means the same thing whether they're hostile or (rarely) your own.
        // Deliberately a separate colour/word from VIP/PROTECT — that one
        // means "keep alive," this one doesn't carry that connotation either way.
        private _isHVT = _unit getVariable ["BZN_visor_HVT", false];
        if (_isHVT) then {
            _messageCENTER = "HVT - ELIMINATE";
            _color2 = _colorHVT;
        };

        // VIP override — takes final say over the centre line: this is a
        // "don't take this one off the board" callout, more important than
        // the type label or even MARKED (which still shows below via
        // _messageDOWN, so the rest of the picture isn't lost). Friendly/
        // neutral VIPs read "PROTECT" (keep them alive); anyone on a side
        // hostile to the player reads "TAKE ALIVE" (capture, don't kill) —
        // same getFriend threshold the hex-colour switch above uses.
        private _isVIP = _unit getVariable ["BZN_visor_VIP", false];
        if (_isVIP) then {
            private _vipLabel = ["PROTECT", "TAKE ALIVE"] select ((side _unit) getFriend (side player) <= 0.3);
            _messageCENTER = format ["VIP - %1", _vipLabel];
            _color2 = _colorVIP;
        };

        private _messageDOWN2 = "";
        private _d2a = "";
        private _d2b = "";
        private _d2c = "";

        if (_unit isKindOf "CAManbase") then {
            switch (alive _unit) do {
                case true : {
                    private _isFriendly = (side _unit) getFriend (side player) >= 0.8 or side player == side _unit;
                    _d2a = if (currentWeapon _unit != "") then { "ARMED" } else { "UNARMED" };
                    // Launcher carriers are a priority threat (AT/AA) — flag them
                    // distinctly so they stand out from rifle-armed infantry at a
                    // glance.
                    // Friendly launcher gunners aren't a threat to call out in red —
                    // a plain white "LAUNCHER" is enough to know who's carrying the
                    // team's AT/AA so you don't mistake them for a rifleman.
                    if (secondaryWeapon _unit != "") then {
                        if (_isFriendly) then {
                            _d2a = "LAUNCHER"; _color4 = _colorWHITEdark;
                        } else {
                            _d2a = _d2a + " | LAUNCHER"; _color4 = _colorRED;
                        };
                    };
                    if (rating _unit < 0 or (_unit targetKnowledge player) select 3 > 0) then {
                        _d2b = " | HOSTILE"; _color4 = _colorRED;
                    };
                    if (damage _unit > 0.333) then { _d2c = " | INJURED" };
                };
                case false : {
                    private _bodyParts = (getAllHitPointsDamage _unit) select 1;
                    private _dmgParts  = (getAllHitPointsDamage _unit) select 2;
                    private _maxDmg    = selectMax _dmgParts;
                    private _part      = _bodyParts select (_dmgParts find _maxDmg);

                    switch (_part) do {
                        default            { _d2b = "TORSO" };
                        case "face_hub" : { _d2b = "HEAD" };
                        case "neck"     : { _d2b = "NECK" };
                        case "head"     : { _d2b = "HEAD" };
                        case "pelvis"   : { _d2b = "PELVIS" };
                        case "spine1"   : { _d2b = "SPINE" };
                        case "spine2"   : { _d2b = "SPINE" };
                        case "spine3"   : { _d2b = "SPINE" };
                        case "body"     : { _d2b = "TORSO" };
                        case "arms"     : { _d2b = "ARMS" };
                        case "hands"    : { _d2b = "ARMS" };
                        case "legs"     : { _d2b = "LEGS" };
                    };
                    _d2a = "FATAL WOUND TO THE ";
                };
            };
        } else {
            _d2a = if (isEngineOn _unit) then { "ENGINE ON" } else { "ENGINE OFF" };
            if (speed _unit > 0.1) then { _d2b = " | MOVING" };
            private _isHostileVeh = (rating _unit < 0 or (_unit targetKnowledge player) select 3 > 0);
            if (_isHostileVeh) then {
                _d2a = " | HOSTILE"; _color4 = _colorRED;
            };

            if (unitIsUAV _unit) then {
                // Friendly drones: show who's remotely flying it, if anyone —
                // see _uavOperatorTuples above (self-announced; no native
                // reverse query for "who is connected to this UAV" exists).
                // The AI driver/gunner seats aren't meaningful here — the
                // remote operator IS the relevant "who's running this."
                // Hostile drones never reveal their operator — that's intel
                // the team would have to earn, not get for free off the tag.
                private _opIdx = _uavOperatorTuples findIf { (_x select 0) == _unit };
                if (_opIdx >= 0 and {!_isHostileVeh}) then {
                    _d2c = format [" | OP: %1", (_uavOperatorTuples select _opIdx) select 1];
                };
            } else {
                // Crewed vehicles: name the key seats (Driver/Gunner/Commander)
                // individually — passengers are summarized as a headcount only
                // (a bus full of named tags would be unreadable noise).
                // Dedupe by occupant: small vehicles often have the same
                // person filling multiple roles (e.g. driver == gunner).
                private _crew = [];
                {
                    _x params ["_role", "_occupant"];
                    if (!isNull _occupant and { alive _occupant }) then {
                        private _idx = _crew findIf { (_x select 0) == _occupant };
                        if (_idx >= 0) then {
                            _crew set [_idx, [_occupant, ((_crew select _idx) select 1) + "/" + _role]];
                        } else {
                            _crew pushBack [_occupant, _role];
                        };
                    };
                } forEach [["D", driver _unit], ["G", gunner _unit], ["C", commander _unit]];

                // Hostile crews stay anonymous — naming whoever's driving/
                // gunning a hostile vehicle would be free intel the team
                // hasn't earned (matches the hostile-drone rule above).
                if (count _crew > 0 and {!_isHostileVeh}) then {
                    private _names = _crew apply { format ["%1 (%2)", name (_x select 0), _x select 1] };
                    _d2c = format [" | OP: %1", _names joinString ", "];
                };

                // `crew` returns every alive occupant (key seats + turrets +
                // cargo); subtracting the deduped D/G/C set leaves a clean
                // "everyone else" headcount.
                private _passengerCount = ({ alive _x } count crew _unit) - (count _crew);
                if (_passengerCount > 0) then {
                    _d2c = _d2c + format [" | P: %1", _passengerCount];
                };
            };
        };

        // Reduced-tag label: defaults to the same ARMED/UNARMED/LAUNCHER word
        // as the full view's detail line. Friendly infantry instead get the
        // HALO-drone-feed two-liner — a small "BZN INF" type line with the
        // name under it (think "UNSC INF / 3-1 BRAVO") — since "are they
        // armed" tells you nothing useful about a teammate, but who they are
        // does.
        //
        // Role suffixes ride on the name so specialists stay findable at a
        // glance — and exactly ONE ever renders, highest priority first
        // (a squad lead who's also a medic just reads SQL):
        //   SQL  — squad lead, Arma's own designation (group leader; solo
        //          one-man groups don't count)
        //   FTL  — fire team lead, designated via ACE Team Management
        //          ("Designate Fire Team Lead" — see fn_VISORpostInit.sqf;
        //          broadcast BZN_visor_FTL variable)
        //   Med  — medic permissions (ACE medic class, or the vanilla
        //          medic/attendant trait, which ACE honours too)
        //   Expl — explosive specialist (ACE_isEOD or vanilla trait)
        //   Engi — engineer permissions (ACE_isEngineer or vanilla trait)
        //   AT   — carrying a launcher (live inventory check)
        // The ACE engineer/EOD variables can be a bool OR a 0/1/2 level
        // depending on how the mission set them — both shapes are handled.
        private _minimalLabel = _d2a;
        private _minimalType  = "";
        if (
            _unit isKindOf "CAManbase"
            and { alive _unit }
            and { (side _unit) getFriend (side player) >= 0.8 or side player == side _unit }
        ) then {
            _minimalType = "BZN INF";
            if (name _unit != "") then {
                _minimalLabel = name _unit;

                private _isSQL  = (leader group _unit == _unit) and { count units group _unit > 1 };
                private _isFTL  = _unit getVariable ["BZN_visor_FTL", false];
                private _isMed  = (_unit getVariable ["ace_medical_medicClass", 0]) >= 1
                    or { _unit getUnitTrait "medic" };
                private _eodV   = _unit getVariable ["ACE_isEOD", _unit getUnitTrait "explosiveSpecialist"];
                private _isExpl = (_eodV isEqualType true and { _eodV })
                    or { _eodV isEqualType 0 and { _eodV >= 1 } };
                private _engiV  = _unit getVariable ["ACE_isEngineer", _unit getUnitTrait "engineer"];
                private _isEngi = (_engiV isEqualType true and { _engiV })
                    or { _engiV isEqualType 0 and { _engiV >= 1 } };
                private _isAT   = secondaryWeapon _unit != "";

                private _roleIdx = [_isSQL, _isFTL, _isMed, _isExpl, _isEngi, _isAT] findIf { _x };
                if (_roleIdx >= 0) then {
                    _minimalLabel = _minimalLabel + ([" - SQL", " - FTL", " - Med", " - Expl", " - Engi", " - AT"] select _roleIdx);
                };
            };
        };

        // Whitelisted, player-crewed friendly vehicles get the equivalent
        // designator type line by chassis — BZN AIR / BZN SEA / BZN GRND.
        // AI-only crews and non-whitelisted vehicles keep the plain tag; the
        // type line marks "one of OURS with one of US aboard", mirroring how
        // BZN INF marks the wearer of a whitelisted device.
        if (
            !(_unit isKindOf "CAManbase")
            and { alive _unit }
            and { (typeOf _unit) in BZN_visor_vehicles }
            and { (side _unit) getFriend (side player) >= 0.8 }
            and { ((crew _unit) findIf { isPlayer _x and { alive _x } }) >= 0 }
        ) then {
            _minimalType = switch (_bucket) do {
                case "AIR" : { "BZN AIR" };
                case "SEA" : { "BZN SEA" };
                default    { "BZN GRND" };
            };
        };

        _messageDOWN2 = format ["%1%2%3", _d2a, _d2b, _d2c];

        // ---- Draw ---------------------------------------------------------
        // HALO-drone-feed layout: chest-anchored hex with every text line
        // centre-aligned and bracketed/stacked around it. The hex ALWAYS
        // draws — it's the IFF core. All text is gated behind Detail Mode
        // (the "Toggle Detail Mode" keybind, ON by default): switched OFF,
        // the display strips down to bare colour-coded hexagons only.
        drawIcon3D [_Hex, _color2, _HexPosition, _HexSize select 0, _HexSize select 1, 0, "", 0, _size1, "PuristaSemiBold", "center", false];
        if (BZN_visor_detailView_active and { !_hexOnly }) then {
        if (_isDetailHidden) then {
            // Compact designator. Friendlies: the "BZN INF" type line with
            // the name (+ role suffixes) under it (see _minimalType above).
            // Hostiles/neutrals: the single ARMED/UNARMED/LAUNCHER word.
            // Distance, grid reference, and the fuller status lines never
            // show for rank-and-file infantry — the detailed stack is
            // reserved for the exempt categories (marked/HVT/VIP/hostile
            // launchers/vehicles — see the _hideableInfantry pre-pass above).
            if (_minimalType != "") then {
                // Friendly two-liner bracketing the hex: type above, name
                // below — both at the same small size for a uniform designator.
                drawIcon3D ["", _color2, _drawPosUp,   0, 0, 0, _minimalType,  0, _size5, "PuristaSemiBold", "center", false];
                drawIcon3D ["", _color2, _drawPosDown, 0, 0, 0, _minimalLabel, 0, _size5, "PuristaSemiBold", "center", false];
            } else {
                drawIcon3D ["", _color2, _drawPosDown, 0, 0, 0, _minimalLabel, 0, _size2, "PuristaSemiBold", "center", false];
            };
        } else {
            // Zeus-marked target with curator-typed context: distance above,
            // red hex, then the custom colour-coded lines with the MARKED/
            // grid line at the bottom. The curator's callout IS the tag — the
            // usual type/name and ARMED/HOSTILE rows are replaced entirely.
            private _markRows = _markLines select { (_x param [0, ""]) != "" };
            if (_markRows isNotEqualTo []) then {
                private _markPalette = [
                    [0.95, 0.2,  0.2,  _alpha],  // 0 = Red
                    [0.3,  0.6,  1,    _alpha],  // 1 = Blue
                    [1,    0.85, 0.1,  _alpha]   // 2 = Yellow
                ];
                drawIcon3D ["", _color1, _drawPosUp, 0, 0, 0, _messageUP, 0, _size1, "PuristaSemiBold", "center", false];
                // Same -0.35 upward bias as the fixed _drawPosDown* slots, so
                // the first context line hugs the hex symmetrically too.
                private _row = 1;
                {
                    _x params ["_txt", ["_ci", 0]];
                    drawIcon3D ["", _markPalette param [_ci, _markPalette select 0], _targetPosition vectorAdd (_drawUp vectorMultiply -(_row - 0.35)), 0, 0, 0, _txt, 0, _size4, "PuristaSemiBold", "center", false];
                    _row = _row + 1;
                } forEach _markRows;
                drawIcon3D ["", _color3, _targetPosition vectorAdd (_drawUp vectorMultiply -(_row - 0.35)), 0, 0, 0, _messageDOWN, 0, _size3, "PuristaSemiBold", "center", false];
            } else {
                // Friendly infantry/vehicles keep the type line above the hex
                // in the full view too (so expanding a tag doesn't rearrange
                // it) — the distance line just steps one slot higher.
                if (_minimalType != "") then {
                    drawIcon3D ["", _color1, _drawPosUp2, 0, 0, 0, _messageUP,   0, _size1, "PuristaSemiBold", "center", false];
                    drawIcon3D ["", _color2, _drawPosUp,  0, 0, 0, _minimalType, 0, _size5, "PuristaSemiBold", "center", false];
                } else {
                    drawIcon3D ["", _color1, _drawPosUp, 0, 0, 0, _messageUP, 0, _size1, "PuristaSemiBold", "center", false];
                };
                drawIcon3D ["", _color2, _drawPosDown,  0, 0, 0, _messageCENTER, 0, _size2, "PuristaSemiBold", "center", false];
                drawIcon3D ["", _color3, _drawPosDown2, 0, 0, 0, _messageDOWN,   0, _size3, "PuristaSemiBold", "center", false];
                drawIcon3D ["", _color4, _drawPosDown3, 0, 0, 0, _messageDOWN2,  0, _size4, "PuristaSemiBold", "center", false];
            };
        };
        }; // Detail Mode gate
    } forEach _pool;
}];
