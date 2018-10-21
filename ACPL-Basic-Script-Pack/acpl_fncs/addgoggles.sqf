private ["_unit","_classname"];

_unit = _this select 0;
_classname = _this select 1;

//_nul = [this,"classname"] execVM "acpl_fncs\addgoggles.sqf";
//v1.0

[_unit] remoteExec ["removeGoggles",_unit,true];
[_unit,_classname] remoteExec ["addGoggles",_unit,true];