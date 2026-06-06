if (isDedicated) exitWith {};

BZN_tacvis_Display = addMissionEventHandler ["Draw3D", {

    // Combine both pools; pushBackUnique avoids double-rendering a unit
    // that is simultaneously friendly and CQC-detected (e.g. player's own side).
    private _pool = [];
    { _pool pushBackUnique _x } forEach (BZN_tacvis_pool_friendly + BZN_tacvis_pool_CQC);

    // Don't tag idle neutral/civilian vehicles — only show a vehicle if it is
    // infantry, has its engine running, or is clearly hostile/friendly.
    _pool = _pool select {
        (_x isKindOf "CAManbase")
        or { isEngineOn _x }
        or { (side _x) getFriend (side player) <= 0.3 }
        or { (side _x) getFriend (side player) >= 0.8 }
    };

    {
        private _unit = _x;

        // ---- Stance-based Z offset ----------------------------------------
        private _textOffsetX = -0.2;
        private _textOffsetY =  0;
        private _textOffsetZ =  0;

        switch (stance _unit) do {
            case "STAND"     : { _textOffsetZ = 1.35 };
            case "CROUCH"    : { _textOffsetZ = 1.35 / 2 };
            case "PRONE"     : { _textOffsetZ = 1.35 / 5 };
            case "UNDEFINED" : { _textOffsetZ = 1.35 };
            case ""          : { _textOffsetZ = 0 };
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

        private _HexSize     = [1.88, 1.88];
        private _HexPosition = _unit modelToWorldVisual [0, 0, _textOffsetZ];

        // ---- Colours ------------------------------------------------------
        private _alpha          = 0.95 - (player distance _unit) / 1000;
        private _colorGREEN     = [0, 0.75, 0, _alpha];
        private _colorGREENdark = [0, 0.55, 0, _alpha];
        private _colorRED       = [0.75, 0, 0, _alpha];
        private _colorORANGE    = [1, 0.8, 0, _alpha];
        private _colorORANGEdark= [0.8, 0.6, 0, _alpha];
        private _colorWHITEdark = [0.871, 0.871, 0.871, _alpha];

        private _HexBase   = "z\bzn\addons\bzn_tacvis\TacVis_UI\";
        private _HexWHITE  = _HexBase + "VTO_tacvis_hexWhite.paa";
        private _HexRED    = _HexBase + "VTO_tacvis_hexRed.paa";
        private _HexGREEN  = _HexBase + "VTO_tacvis_hexGreen.paa";
        private _HexORANGE = _HexBase + "VTO_tacvis_hexOrange.paa";

        private _Hex    = _HexWHITE;
        private _color1 = _colorORANGE;
        private _color2 = _colorORANGEdark;
        private _color3 = _colorWHITEdark;
        private _color4 = _colorWHITEdark;

        switch (true) do {
            case ((side _unit) getFriend (side player) >= 0.8 or side player == side _unit) : {
                _color2 = _colorGREEN; _Hex = _HexGREEN;
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
                if (_unit isKindOf "Car" or _unit isKindOf "Tank") then {
                    _nameUnit = "VEHICLE";
                    switch (side _unit) do {
                        case sideAmbientLife : { _nameUnit = "WILDLIFE";        _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                        case sideUnknown         : { _nameUnit = "UNKNOWN VEHICLE"; _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                        case civilian            : { _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                        case sideEmpty           : { _nameUnit = "UNKNOWN VEHICLE"; _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                    };
                    if ({alive _x} count crew _unit == 0) then { _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                };
                if (_unit isKindOf "Air") then {
                    _nameUnit = "AIRCRAFT";
                    switch (side _unit) do {
                        case sideAmbientLife : { _nameUnit = "WILDLIFE";         _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                        case sideUnknown         : { _nameUnit = "UNKNOWN AIRCRAFT"; _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                        case civilian            : { _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                        case sideEmpty           : { _nameUnit = "UNKNOWN AIRCRAFT"; _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                    };
                    if ({alive _x} count crew _unit == 0) then { _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                };
                if (_unit isKindOf "Ship") then {
                    _nameUnit = "SHIP";
                    switch (side _unit) do {
                        case sideAmbientLife : { _nameUnit = "WILDLIFE";    _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                        case sideUnknown         : { _nameUnit = "UNKNOWN SHIP"; _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                        case civilian            : { _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                        case sideEmpty           : { _nameUnit = "UNKNOWN SHIP"; _color2 = _colorWHITEdark; _Hex = _HexWHITE };
                    };
                    if ({alive _x} count crew _unit == 0) then { _color2 = _colorWHITEdark; _Hex = _HexWHITE };
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

        private _messageDOWN = mapGridPosition _unit;
        if (BZN_tacvis_spotted findIf { (_x select 0) == _unit } >= 0) then {
            _color3 = _colorRED;
            _messageDOWN = format ["SPOTTED | %1", _messageDOWN];
        };

        private _messageDOWN2 = "";
        private _d2a = "";
        private _d2b = "";
        private _d2c = "";

        if (_unit isKindOf "CAManbase") then {
            switch (alive _unit) do {
                case true : {
                    _d2a = if (currentWeapon _unit != "") then { "ARMED" } else { "UNARMED" };
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
            if (rating _unit < 0 or (_unit targetKnowledge player) select 3 > 0) then {
                _d2a = " | HOSTILE"; _color4 = _colorRED;
            };
        };

        _messageDOWN2 = format ["%1%2%3", _d2a, _d2b, _d2c];

        // ---- Draw ---------------------------------------------------------
        drawIcon3D [_Hex, _color2, _HexPosition, _HexSize select 0, _HexSize select 1, 0, "", 0, _size1, "PuristaSemiBold", "left", false];
        drawIcon3D ["", _color1, _drawPosUp,      0, 0, 0, _messageUP,     0, _size1, "PuristaSemiBold", "left", false];
        drawIcon3D ["", _color2, _targetPosition, 0, 0, 0, _messageCENTER, 0, _size2, "PuristaSemiBold", "left", false];
        drawIcon3D ["", _color3, _drawPosDown,    0, 0, 0, _messageDOWN,   0, _size3, "PuristaSemiBold", "left", false];
        drawIcon3D ["", _color4, _drawPosDown2,   0, 0, 0, _messageDOWN2,  0, _size4, "PuristaSemiBold", "left", false];

    } forEach _pool;
}];
