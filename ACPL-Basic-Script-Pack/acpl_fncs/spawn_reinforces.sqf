private ["_wait","_groups","_groups_count","_spawn_fnc"];

//_nul = [wait,howmany,groups] execVM "acpl_fncs\spawn_reinforces.sqf";
//v1.1

_wait = _this select 0;
_groups_count = _this select 1;
_groups = _this select 2;

acpl_groups_used = [];
publicvariable "acpl_groups_used";

sleep ((_wait/2) + random (_wait/2));
for "_i" from 1 to _groups_count do {
	private ["_groups2","_grp","_v1","_v2","_name"];
	_groups2 = _groups - acpl_groups_used;
	_grp = _groups2 select floor(random(count _groups2));
	_v1 = _grp select 0;
	_v2 = _grp select 1;
	_name = [_v1 select 0,_v1 select 1,_v1 select 2] call acpl_spawn_newgroup;
	sleep 1;
	[_name,_v2] call acpl_spawn_addwaypoints;
	acpl_groups_used = acpl_groups_used + [_grp];
	publicvariable "acpl_groups_used";
	sleep 15;
};