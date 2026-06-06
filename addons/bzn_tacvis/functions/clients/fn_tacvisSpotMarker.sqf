params ["_markerName", "_pos", "_expiryTime"];

// This runs on every machine (remoteExec to 0), so each creates its OWN local
// marker — using global createMarker from every client would collide on the name.
if (getMarkerPos _markerName isEqualTo [0, 0, 0]) then {
    createMarkerLocal [_markerName, _pos];
} else {
    _markerName setMarkerPosLocal _pos;
};

_markerName setMarkerShapeLocal "ICON";
_markerName setMarkerTypeLocal "mil_triangle";
_markerName setMarkerColorLocal "ColorRed";
_markerName setMarkerAlphaLocal 0.85;
_markerName setMarkerTextLocal "SPOTTED";

// Auto-delete locally when the spot expires
[_markerName, _expiryTime] spawn {
    params ["_name", "_expiry"];
    waitUntil { time >= _expiry };
    deleteMarkerLocal _name;
};
