private ["_unit","_tp","_pos_tp","_direction_tp","_pos_unit","_direction_unit"];

_unit = _this select 0;
_tp = _this select 1;

if (!isserver) exitwith {};

if (isNil "acpl_safestart_inited") then {acpl_safestart_inited = false};

waitUntil {acpl_safestart_inited};

//_nul = [this,unit] execVM "acpl_fncs\acpl_safestart.sqf";
//v1.0

acpl_safestart_units = acpl_safestart_units + [_unit];
publicvariable "acpl_safestart_units";

[_tp,true] remoteExec ["hideobjectglobal",0];
[_tp,"ALL"] remoteExec ["disableAI",0];

_pos_tp = [(getPosATL _tp) select 0,(getPosATL _tp) select 1,(getPosATL _tp) select 2 + 0.5];
_direction_tp = getDir _tp;

_pos_unit = [(getPosATL _unit) select 0,(getPosATL _unit) select 1,(getPosATL _unit) select 2 + 0.5];
_direction_unit = getDir _unit;

if (vehicle _unit == _unit) then {
	_veh = false;
	_unit setvariable ["acpl_safestart_veh",false,true];
	_unit setvariable ["acpl_safestart_vehicle",[],true];
	_unit setvariable ["acpl_safestart_role",[],true];
} else {
	_veh = true;
	_unit setvariable ["acpl_safestart_vehicle",vehicle _unit,true];
	_unit setvariable ["acpl_safestart_veh",true,true];
	_unit setvariable ["acpl_safestart_role",assignedVehicleRole _unit,true];
};

_unit setvariable ["acpl_safestart_pos",_pos_unit,true];
_unit setvariable ["acpl_safestart_dir",_direction_unit,true];

[_unit,false] remoteExec ["allowdamage",0];
[_unit,_pos_tp] remoteExec ["setPosATL",0];
[_unit,_direction_tp] remoteExec ["setDir",0];
