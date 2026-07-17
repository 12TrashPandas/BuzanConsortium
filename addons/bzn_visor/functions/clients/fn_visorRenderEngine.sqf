if (isDedicated) exitWith {};

BZN_visor_Display = addMissionEventHandler ["Draw3D", {

    if (!BZN_visor_userEnabled) exitWith {};

    // Live Zeus-marked contacts (expiry-filtered). Marks are shared across
    // clients (broadcast by fn_visorZeusMark via fn_visorAddSpot); rendering
    // is still range-limited by the alpha fade below, so teammates only see
    // marks within their own range.
    private _spottedTuples = BZN_visor_spotted select { (time <= (_x select 1)) and { !isNull (_x select 0) } and { alive (_x select 0) } };
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
        // Friendly-side and civilian AI are background noise — there's no
        // tactical reason to tag every bot teammate or bystander civilian.
        // Player-controlled units are always tagged (that's the whole IFF
        // point of the display), Zeus-marked contacts are always tactically
        // relevant regardless of side, and VIP-flagged units stay visible no
        // matter their side or AI/player status — that's the entire point of
        // flagging someone "don't take off the board."
        and {
            !(_x isKindOf "CAManbase")
            or { isPlayer _x }
            or { _x getVariable ["BZN_visor_VIP", false] }
            or { _x getVariable ["BZN_visor_HVT", false] }
            or { _x in _spottedObjs }
        }
        // "Friendly markers" toggle hides only units that read as friendly to
        // the player — Zeus-marked contacts (always hostile/neutral by
        // definition) are unaffected.
        and { !BZN_visor_hideFriendlyMarkers or { ((side _x) getFriend (side player) < 0.8) } }
    };

    // Throttled diagnostic — "not seeing HVT/VIP" can mean the unit never made
    // it into _pool (wrong flag, dead, out of any pool's range) or that it's in
    // _pool but something downstream (alpha fade, cluster/hidden state) is
    // suppressing the tag — this answers the first question so the second can
    // be checked separately via the per-unit HVT/VIP log further down.
    if (!isNil "BZN_visor_debug" and { BZN_visor_debug }) then {
        if (isNil "BZN_visor_hvtVipPoolDebug_next") then { BZN_visor_hvtVipPoolDebug_next = 0; };
        if (diag_tickTime > BZN_visor_hvtVipPoolDebug_next) then {
            BZN_visor_hvtVipPoolDebug_next = diag_tickTime + 1;
            private _flagged = (allUnits + allDeadMen) select {
                (_x getVariable ["BZN_visor_HVT", false]) or (_x getVariable ["BZN_visor_VIP", false])
            };
            {
                diag_log format [
                    "[BZN VISOR DEBUG] HVT/VIP flagged unit: unit=%1 isHVT=%2 isVIP=%3 alive=%4 dist=%5 inPool=%6",
                    _x,
                    (_x getVariable ["BZN_visor_HVT", false]),
                    (_x getVariable ["BZN_visor_VIP", false]),
                    alive _x,
                    round (player distance _x),
                    (_x in _pool)
                ];
            } forEach _flagged;
            if (count _flagged == 0) then {
                diag_log "[BZN VISOR DEBUG] HVT/VIP flagged unit: none found in mission (no unit has BZN_visor_HVT or BZN_visor_VIP set true)";
            };
        };
    };

    // Observer airborne? Ground units then display out to the longer air-observer
    // range instead of 1 km (computed once per frame).
    private _obsVeh = objectParent player;
    private _inAir  = (!isNull _obsVeh) and { _obsVeh isKindOf "Air" };

    // Aircrew and drone operators look down on contacts from far above —
    // everything reads "close together" on screen at ranges where a ground
    // observer would see plainly separated tags. Use the wider air/drone
    // clustering range (BZN_visor_cluster_minDistance_air, default 2 km)
    // whenever the observer is airborne or slaved to a UAV/UGV feed, so
    // clutter still collapses at the ranges that actually matter from above.
    private _clusterMinDistance = [BZN_visor_cluster_minDistance, BZN_visor_cluster_minDistance_air] select (_inAir or { BZN_visor_uplink_active });

    // ---- Cluster nearby infantry contacts ----------------------------------
    // A tight squad standing together at engagement range would otherwise
    // stack N full 5-line tags on the same screen position — illegible.
    // Greedily group alive, same-side INFANTRY pool members within
    // BZN_visor_cluster_radius of each other (order-dependent approximation —
    // fine for this purpose, far cheaper than true nearest-neighbour
    // clustering and the pool is small). Groups at/above
    // BZN_visor_cluster_threshold collapse into ONE summary tag drawn at
    // the group's centroid (by its first member only — see _isHidden below);
    // smaller groups still render individually but get a small vertical
    // stagger (BZN_visor_stagger_offset) so 2-3 overlapping tags stay readable.
    //
    // Vehicles/air/sea/drones are deliberately never grouped — there are
    // rarely enough of them in one spot to overlap, and operators/crew/status
    // detail is exactly what you want to keep visible individually for those.
    // Launcher-armed infantry are also excluded from grouping/being grouped —
    // they're a priority threat and need their own always-visible tag.
    private _typeBucket = {
        params ["_u"];
        if (_u isKindOf "CAManbase")                 exitWith { "INFANTRY" };
        if (unitIsUAV _u)                            exitWith { "DRONE" };
        if (_u isKindOf "Air")                       exitWith { "AIR" };
        if (_u isKindOf "Ship")                      exitWith { "SEA" };
        if (_u isKindOf "Car" or _u isKindOf "Tank") exitWith { "GROUND" };
        "OTHER"
    };

    // Priority-individual infantry — launcher carriers, HVT, and VIP — never
    // join or lead a cluster. Folding any of these into an "INFANTRY xN"
    // summary would bury exactly the contact you most need to keep an eye on.
    private _clusterExempt = {
        params ["_u"];
        (secondaryWeapon _u != "")
        or (_u getVariable ["BZN_visor_HVT", false])
        or (_u getVariable ["BZN_visor_VIP", false])
    };

    private _assigned = [];
    private _groups   = [];
    {
        private _seed = _x;
        if !(_seed in _assigned) then {
            private _members = [_seed];
            _assigned pushBack _seed;
            // Only cluster contacts the observer is far enough from — up close,
            // individual tags are still readable and players want full per-unit
            // detail; clustering is purely a long-range declutter measure.
            // Excludes priority-individual infantry — see _clusterExempt above.
            if (
                alive _seed
                and { ([_seed] call _typeBucket) == "INFANTRY" }
                and { ! ([_seed] call _clusterExempt) }
                and { player distance _seed >= _clusterMinDistance }
            ) then {
                {
                    if (!(_x in _assigned) and { alive _x } and {
                        ((side _x) isEqualTo (side _seed))
                        and { ([_x] call _typeBucket) == "INFANTRY" }
                        and { ! ([_x] call _clusterExempt) }
                        and { _seed distance _x <= BZN_visor_cluster_radius }
                    }) then {
                        _members pushBack _x;
                        _assigned pushBack _x;
                    };
                } forEach _pool;
            };
            _groups pushBack _members;
        };
    } forEach _pool;

    // Flat lookup so the draw loop can find each unit's group + position
    // within it in one findIf (group membership is exclusive, so this is safe).
    private _memberInfo = [];
    {
        private _group = _x;
        { _memberInfo pushBack [_x, _group, _forEachIndex] } forEach _group;
    } forEach _groups;

    // ---- "Looked at" detail gating -----------------------------------------
    // Clustering declutters at range, but close-quarters firefights still stack
    // full 5-line tags on every nearby rifleman. So: ordinary infantry render
    // with just their hex + ARMED/UNARMED (plus the MARKED line, so timers
    // stay visible) until you're directly looking at them — then,
    // and ONLY then, their tag expands to full detail. At most one tag is
    // "expanded" this way at a time (whichever sits nearest dead-centre of
    // your sightline, within BZN_visor_lookAt_radius metres of the target).
    //
    // HVT-flagged (`BZN_visor_HVT`), VIP-flagged (`BZN_visor_VIP` — see the
    // PROTECT/TAKE ALIVE override below), and launcher-carrying infantry are
    // exempt — they're priority individuals and always show in full. Vehicles,
    // aircraft, ships, and drones are unaffected too — they're rarely numerous
    // enough to clutter and their crew/operator detail is exactly what you want
    // glanceable. The "Toggle Detail View" keybind permanently overrides all
    // of this, showing every tag in full.
    private _hideableInfantry = _pool select {
        _x isKindOf "CAManbase"
        and { alive _x }
        and { !(_x getVariable ["BZN_visor_HVT", false]) }
        and { !(_x getVariable ["BZN_visor_VIP", false]) }
        // Hostile/neutral launcher carriers stay exempt — they're the
        // priority-threat callout that should never collapse to a reduced
        // tag. Friendly launcher gunners aren't a threat though, so they're
        // allowed to gate down like any other teammate (their reduced tag
        // still reads "LAUNCHER" via _minimalLabel, so you don't lose track
        // of who's carrying the team's AT/AA).
        and {
            secondaryWeapon _x == ""
            or { (side _x) getFriend (side player) >= 0.8 or side player == side _x }
        }
    };

    private _lookedAtUnit = objNull;
    if (!BZN_visor_detailView_active) then {
        // Angular-cone technique — far more reliable than projecting to screen-space and comparing
        // against an assumed [0.5, 0.5] centre, which drifts off the true
        // sightline with FOV/aspect-ratio/optic zoom and was the reason this
        // gating wasn't reliably triggering. positionCameraToWorld gives the
        // actual camera bore axis and stays consistent across every view mode
        // (ironsights, scopes, third-person, vehicle turrets, UAV feeds).
        private _camPos  = positionCameraToWorld [0, 0, 0];
        private _aimDir  = vectorNormalized ((positionCameraToWorld [0, 0, 1]) vectorDiff _camPos);
        private _bestDot = -1;
        private _bestNeededDot = 1;
        {
            // eyePos (head height) made you aim noticeably above someone's
            // visual centre to register — players naturally settle their
            // crosshair on a person's torso/centre-mass when "looking at"
            // them, not their eyes specifically (that precision is what
            // precise aim is for). Splitting the
            // difference between eye and foot height approximates that
            // centre-mass point and tracks correctly across every stance.
            private _aimPoint    = ((eyePos _x) vectorAdd (getPosASLVisual _x)) vectorMultiply 0.5;
            private _toTarget    = _aimPoint vectorDiff _camPos;
            private _rangeToAim  = vectorMagnitude _toTarget;
            private _dirToTarget = _toTarget vectorMultiply (1 / _rangeToAim);
            private _dot         = _aimDir vectorDotProduct _dirToTarget;
            // A FIXED angle cone gets wider in absolute terms the further
            // away the target is (an 8-degree cone is ~5.6m across at 40m
            // but ~28m at 200m) — so at range you could trigger "looking at"
            // someone while your reticle sat metres off them in open air.
            // Deriving the required angle from a constant linear radius
            // (BZN_visor_lookAt_radius, in metres) keeps the actual "you're
            // on them" tolerance the same size at every distance instead.
            private _neededDot = cos (atan (BZN_visor_lookAt_radius / _rangeToAim));
            if (_dot > _neededDot and { _dot > _bestDot }) then {
                _bestDot       = _dot;
                _bestNeededDot = _neededDot;
                _lookedAtUnit  = _x;
            };
        } forEach _hideableInfantry;

        // Throttled diagnostic — Draw3D fires every frame, so this would
        // otherwise flood the RPT. Gate it to once a second behind the
        // BZN_visor_debug flag, so the look-at gate can be inspected in
        // the field if it's still misbehaving.
        if (!isNil "BZN_visor_debug" and { BZN_visor_debug }) then {
            if (isNil "BZN_visor_lookAtDebug_next") then { BZN_visor_lookAtDebug_next = 0; };
            if (diag_tickTime > BZN_visor_lookAtDebug_next) then {
                BZN_visor_lookAtDebug_next = diag_tickTime + 1;
                diag_log format [
                    "[BZN VISOR DEBUG] lookAt: hideable=%1 lookedAt=%2 bestDot=%3 (need > %4, radius=%5m)",
                    count _hideableInfantry, _lookedAtUnit, _bestDot, _bestNeededDot, BZN_visor_lookAt_radius
                ];
            };
        };
    };

    {
        private _unit = _x;

        private _miIdx        = _memberInfo findIf { (_x select 0) == _unit };
        private _group        = (_memberInfo select _miIdx) select 1;
        private _indexInGroup = (_memberInfo select _miIdx) select 2;
        private _groupSize    = count _group;
        private _bucket       = [_unit] call _typeBucket;
        // Only the first member of a large group draws — as one consolidated
        // tag covering the whole group. The rest are skipped outright.
        private _isClusterTag = (_groupSize >= BZN_visor_cluster_threshold) and { _indexInGroup == 0 };
        private _isHidden     = (_groupSize >= BZN_visor_cluster_threshold) and { _indexInGroup > 0 };

        // Reduced tag (hex + ARMED/UNARMED + status/timer line only) for any
        // ordinary infantry that isn't the one tag you're directly looking at —
        // see the "Looked at" pre-pass above. Never applies to cluster tags
        // (already a declutter measure in their own right).
        private _isDetailHidden = !BZN_visor_detailView_active and !_isClusterTag and { _unit in _hideableInfantry } and { _unit != _lookedAtUnit };

        if (!_isHidden) then {

        // ---- Stance-based Z offset ----------------------------------------
        private _textOffsetX = -0.2;
        private _textOffsetY =  0;
        private _textOffsetZ =  0;

        switch (stance _unit) do {
            case "STAND"     : { _textOffsetZ = 1.2 };
            case "CROUCH"    : { _textOffsetZ = 1.2 / 2 };
            case "PRONE"     : { _textOffsetZ = 1.2 / 5 };
            case "UNDEFINED" : { _textOffsetZ = 1.2 };
            case ""          : { _textOffsetZ = 0 };
        };

        // Sub-threshold overlapping groups (2 up to the cluster threshold):
        // stagger each member's text vertically so they don't fully overlap.
        if (_groupSize > 1 and { _groupSize < BZN_visor_cluster_threshold }) then {
            _textOffsetZ = _textOffsetZ + (_indexInGroup * BZN_visor_stagger_offset);
        };

        // ---- Text offset direction (avoid overlapping the model) -----------
        private _dirRelOffset = _unit getRelDir player;

        switch (true) do {
            case (_dirRelOffset >= 0   and _dirRelOffset <= 45)  : { _textOffsetX = -0.2; _textOffsetY =  0 };
            case (_dirRelOffset >  45  and _dirRelOffset <= 90)  : { _textOffsetX =  0;   _textOffsetY =  0.2 };
            case (_dirRelOffset >  90  and _dirRelOffset <= 135) : { _textOffsetX =  0.2; _textOffsetY =  0.2 };
            case (_dirRelOffset >  135 and _dirRelOffset <= 180) : { _textOffsetX =  0.2; _textOffsetY =  0 };
            case (_dirRelOffset >  180 and _dirRelOffset <= 225) : { _textOffsetX =  0.2; _textOffsetY =  0 };
            case (_dirRelOffset >  225 and _dirRelOffset <= 270) : { _textOffsetX =  0.2; _textOffsetY = -0.2 };
            case (_dirRelOffset >  270 and _dirRelOffset <= 315) : { _textOffsetX =  0;   _textOffsetY = -0.2 };
            case (_dirRelOffset >  315 and _dirRelOffset <= 360) : { _textOffsetX = -0.2; _textOffsetY =  0 };
        };

        // ---- World-space draw positions -----------------------------------
        private _targetPosition = _unit modelToWorldVisual [_textOffsetX, _textOffsetY, _textOffsetZ + 0.05];

        // Consolidated cluster tag: draw at the centroid of every member's
        // position (using this same per-unit offset) rather than just the
        // representative's — keeps the tag visually "covering" the group.
        if (_isClusterTag) then {
            private _sumPos = [0, 0, 0];
            { _sumPos = _sumPos vectorAdd (_x modelToWorldVisual [_textOffsetX, _textOffsetY, _textOffsetZ + 0.05]) } forEach _group;
            _targetPosition = _sumPos vectorMultiply (1 / _groupSize);
        };

        private _playerPosition = positionCameraToWorld [0, 0, 0];
        private _distance       = _targetPosition distance _playerPosition;
        private _fov            = getObjectFOV player;
        private _dir            = _targetPosition vectorDiff _playerPosition;
        private _playerDir      = _playerPosition vectorFromTo positionCameraToWorld [0, 0, 1];
        private _cross          = _playerDir vectorCrossProduct vectorUp player;
        private _drawUpNormal   = vectorNormalized (_cross vectorCrossProduct _dir);
        private _drawUp         = _drawUpNormal vectorMultiply (0.01 * _distance);
        private _fovCoeff       = (1 - _fov) * 0.006;
        private _painCoeff      = 0;

        switch (true) do {
            case (_fov > 0.75  and _fov < 1)    : { _painCoeff = 1.66 };
            case (_fov >= 0.25 and _fov <= 0.75) : { _painCoeff = 1.88 };
            case (_fov > 0.107 and _fov < 0.25)  : { _painCoeff = 2.75 };
            case (_fov <= 0.25 and _fov > 0.05)  : { _painCoeff = 5 };
            case (_fov <= 0.05 and _fov >= 0.03) : { _painCoeff = 12.5 };
            case (_fov < 0.03  and _fov >= 0.01) : { _painCoeff = 17.5 };
            case (_fov < 0.01  and _fov >= 0.005): { _painCoeff = 66 };
            case (_fov < 0.005)                  : { _painCoeff = 133 };
        };

        _painCoeff = _painCoeff * 1.1;

        switch (_fov < 1) do {
            case true : {
                private _div = (2 + (_painCoeff - (_fov * _painCoeff * 2))) - _fovCoeff * 100;
                _drawUp set [0, (_drawUp select 0) / _div];
                _drawUp set [1, (_drawUp select 1) / _div];
                _drawUp set [2, (_drawUp select 2) / _div];
            };
            case false : {
                _drawUp set [0, (_drawUp select 0) / 0.75 * _fov];
                _drawUp set [1, (_drawUp select 1) / 0.75 * _fov];
                _drawUp set [2, (_drawUp select 2) / 0.75 * _fov];
            };
        };

        private _drawDown     = _drawUp vectorMultiply -1;
        private _drawDown2    = _drawUp vectorMultiply -2;
        private _drawPosUp    = _targetPosition vectorAdd _drawUp;
        private _drawPosDown  = _targetPosition vectorAdd _drawDown;
        private _drawPosDown2 = _targetPosition vectorAdd _drawDown2;

        private _size1 = 0.021 + _fovCoeff;
        private _size2 = 0.022 + _fovCoeff;
        private _size3 = 0.021 + _fovCoeff;
        private _size4 = 0.0175 + _fovCoeff;
        private _size5 = 0.015 + _fovCoeff;

        private _HexSize     = [1.88, 1.88];
        private _HexPosition = _unit modelToWorldVisual [0, 0, _textOffsetZ];

        if (_isClusterTag) then {
            private _sumHex = [0, 0, 0];
            { _sumHex = _sumHex vectorAdd (_x modelToWorldVisual [0, 0, _textOffsetZ]) } forEach _group;
            _HexPosition = _sumHex vectorMultiply (1 / _groupSize);
        };

        // ---- Colours ------------------------------------------------------
        // Flying targets fade over the air range; ground targets fade over 1 km
        // normally, or the longer ground-from-air range when the observer is airborne.
        private _fadeRange      = [[1000, BZN_visor_ground_air_range] select _inAir, BZN_visor_air_range] select (_unit isKindOf "Air");
        private _alpha          = 0.95 - (player distance _unit) / _fadeRange;
        // HALO/UNSC-style pale cyan for friendly IFF — tints the WHITE hex
        // texture rather than using a dedicated green/blue .paa (there isn't
        // one; tinting the green texture blue would muddy the hue, tinting
        // white gives a clean arbitrary colour).
        private _colorFRIENDLY  = [0.45, 0.82, 1, _alpha];
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
        private _messageCENTER = format ["%1_", toUpper _nameUnit];
        private _messageUP     = format ["%1 m", round (player distance _unit)];

        // Countdown to fade-out — a Zeus mark's expiry is fixed at placement
        // time (BZN_visor_zeusMark_duration) and never refreshed, so this
        // simply counts down to zero. Hoisted out of the switch below so the
        // small standalone timer line (_messageDOWN3, drawn under the
        // ARMED/HOSTILE/INJURED line) can reuse it without re-deriving it or
        // drifting out of sync with the MARKED line.
        private _spotRemain = -1;

        private _messageDOWN = mapGridPosition _unit;
        switch (true) do {
            case (_unit in _spottedObjs) : {
                _color3 = _colorRED;
                private _idx = _spottedTuples findIf { (_x select 0) == _unit };
                _spotRemain = if (_idx >= 0) then { ceil ((_spottedTuples select _idx select 1) - time) } else { 0 };
                _messageDOWN = format ["MARKED | %1 | %2s", _messageDOWN, _spotRemain];
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
            _messageCENTER = "HVT - ELIMINATE_";
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
            _messageCENTER = format ["VIP - %1_", _vipLabel];
            _color2 = _colorVIP;
        };

        // Throttled diagnostic — once a second per flagged unit (not every
        // frame) behind BZN_visor_debug, so "flagged but not showing" can be
        // told apart from "never made it into the render pool at all" (the
        // latter would mean this block never runs for that unit — check the
        // pool-filter log line instead, which fires regardless of flags).
        if ((_isHVT or _isVIP) and { !isNil "BZN_visor_debug" and { BZN_visor_debug } }) then {
            private _dbgKey = format ["BZN_visor_hvtVipDebug_next_%1", netId _unit];
            if (isNil _dbgKey) then { missionNamespace setVariable [_dbgKey, 0] };
            if (diag_tickTime > (missionNamespace getVariable [_dbgKey, 0])) then {
                missionNamespace setVariable [_dbgKey, diag_tickTime + 1];
                diag_log format [
                    "[BZN VISOR DEBUG] HVT/VIP tag: unit=%1 isHVT=%2 isVIP=%3 hideable=%4 detailHidden=%5 cluster=%6 hidden=%7 messageCENTER='%8' color2=%9",
                    _unit, _isHVT, _isVIP, (_unit in _hideableInfantry), _isDetailHidden, _isClusterTag, _isHidden, _messageCENTER, _color2
                ];
            };
        };

        private _messageDOWN2 = "";
        private _d2a = "";
        private _d2b = "";
        private _d2c = "";

        // Small standalone countdown under the ARMED/HOSTILE/INJURED line —
        // a compact "about to drop off tracking" cue for spotted hostiles,
        // separate from the fuller "SPOTTED | grid | Xs" line above so it
        // reads at a glance without parsing the whole status string.
        private _messageDOWN3 = if (_spotRemain >= 0) then { format ["%1s", _spotRemain] } else { "" };

        if (_unit isKindOf "CAManbase") then {
            switch (alive _unit) do {
                case true : {
                    private _isFriendly = (side _unit) getFriend (side player) >= 0.8 or side player == side _unit;
                    _d2a = if (currentWeapon _unit != "") then { "ARMED" } else { "UNARMED" };
                    // Launcher carriers are a priority threat (AT/AA) — flag them
                    // distinctly so they stand out from rifle-armed infantry at a
                    // glance (also kept out of clustering — see pre-pass above).
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
        // as the full view's detail line. For friendly, non-launcher infantry
        // though, swap in their name instead — the full view already shows it
        // via _messageCENTER (see "name _unit" substitution above), but the
        // reduced view hides that line entirely, so showing it here is the
        // only way to identify a friendly without expanding their tag, and
        // "are they armed" tells you nothing useful about a teammate anyway.
        private _minimalLabel = _d2a;
        if (
            _unit isKindOf "CAManbase"
            and { alive _unit }
            and { secondaryWeapon _unit == "" }
            and { (side _unit) getFriend (side player) >= 0.8 or side player == side _unit }
            and { name _unit != "" }
        ) then {
            _minimalLabel = name _unit;
        };

        _messageDOWN2 = format ["%1%2%3", _d2a, _d2b, _d2c];

        // ---- Cluster-tag override: replace the representative's per-unit
        // messages with one summary covering the whole squad — "INFANTRY xN",
        // worst-case status (MARKED), and aggregated detail (ARMED/HOSTILE/
        // INJURED). Mirrors the per-unit infantry logic above but reduced to
        // "does ANY member meet this condition" across the group. Only
        // infantry ever cluster (see pre-pass above), so this doesn't need
        // to handle vehicle/air/sea/drone aggregation.
        if (_isClusterTag) then {
            _messageCENTER = format ["%1 x%2_", toUpper _bucket, _groupSize];

            private _anySpotted = false;
            private _anyArmed   = false;
            private _anyHostile = false;
            private _anyInjured = false;
            private _maxRemain  = 0;

            {
                private _m = _x;
                if (_m in _spottedObjs) then {
                    _anySpotted = true;
                    private _sIdx = _spottedTuples findIf { (_x select 0) == _m };
                    if (_sIdx >= 0) then {
                        _maxRemain = _maxRemain max (ceil ((_spottedTuples select _sIdx select 1) - time));
                    };
                };
                if (rating _m < 0 or { (_m targetKnowledge player select 3) > 0 }) then { _anyHostile = true };
                if (currentWeapon _m != "") then { _anyArmed   = true };
                if (damage _m > 0.333)      then { _anyInjured = true };
            } forEach _group;

            _messageDOWN = mapGridPosition _unit;
            if (_anySpotted) then {
                _messageDOWN = format ["MARKED | %1 | %2s", _messageDOWN, _maxRemain];
                _color3 = _colorRED;
            };

            _messageDOWN2 = (["UNARMED", "ARMED"] select _anyArmed)
                + (["", " | HOSTILE"] select _anyHostile)
                + (["", " | INJURED"] select _anyInjured);
            if (_anyHostile) then { _color4 = _colorRED };
        };

        // ---- Draw ---------------------------------------------------------
        drawIcon3D [_Hex, _color2, _HexPosition, _HexSize select 0, _HexSize select 1, 0, "", 0, _size1, "PuristaSemiBold", "left", false];
        if (_isDetailHidden) then {
            // Reduced tag: hex, a single status word — ARMED/UNARMED/
            // LAUNCHER, or a friendly's name (see _minimalLabel above) —
            // and, for marked hostiles, the small drop-off countdown so
            // you can still tell a mark is about to fade without expanding
            // the tag. Distance, grid reference, and the fuller MARKED line
            // stay reserved for the full/"looked at" and Toggle Detail View
            // renders — that's still clutter at this level; look directly
            // at the contact to see it all.
            drawIcon3D ["", _color2, _targetPosition, 0, 0, 0, _minimalLabel, 0, _size2, "PuristaSemiBold", "left", false];
            if (_messageDOWN3 != "") then {
                drawIcon3D ["", _color3, _drawPosDown, 0, 0, 0, _messageDOWN3, 0, _size5, "PuristaSemiBold", "left", false];
            };
        } else {
            drawIcon3D ["", _color1, _drawPosUp,      0, 0, 0, _messageUP,     0, _size1, "PuristaSemiBold", "left", false];
            drawIcon3D ["", _color2, _targetPosition, 0, 0, 0, _messageCENTER, 0, _size2, "PuristaSemiBold", "left", false];
            drawIcon3D ["", _color3, _drawPosDown,    0, 0, 0, _messageDOWN,   0, _size3, "PuristaSemiBold", "left", false];
            drawIcon3D ["", _color4, _drawPosDown2,   0, 0, 0, _messageDOWN2,  0, _size4, "PuristaSemiBold", "left", false];
            // No standalone _messageDOWN3 countdown here — _messageDOWN
            // already spells out "MARKED | grid | Xs" in full at this
            // detail level, so a second "Xs" beneath ARMED would just be
            // the same number twice (see the minimal-view branch above for
            // where the standalone countdown actually earns its place — it
            // has no MARKED line to ride along with there).
        };

        }; // !_isHidden
    } forEach _pool;
}];
