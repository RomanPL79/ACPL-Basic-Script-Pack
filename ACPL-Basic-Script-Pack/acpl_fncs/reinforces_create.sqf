private ["_groups","_name"];

//_nul = [[_grp1,_grp2],"name"] execVM "acpl_fncs\reinforces_create.sqf";
//v1.0

_groups = _this select 0;
_name = _this select 1;

if (!isserver) exitwith {};

waitUntil {acpl_fncs_initied};

missionNamespace setvariable [_name,[],true];

{
	private ["_side","_units","_typesof","_vehicles","_inf","_vehs","_wps"];
	_side = side _x;
	_units = units _x;
	_wps = [_x] call acpl_get_waypoints;
	_vehicles = [_x] call acpl_check_assigned_vehs;
	_inf = [_units,_vehicles] call acpl_check_info;
	_vehs = [_vehicles] call acpl_check_info_vehs;
	
	_done = [[_side,_inf,_vehs],_wps];
	missionNamespace setvariable [_name,(missionNamespace getvariable _name) + [_done],true];
	
	{deletevehicle _x;} foreach _units;
	{deletevehicle _x;} foreach _vehicles;
} foreach _groups;

