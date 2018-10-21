private ["_unit","_enemy"];

if (!isserver) exitwith {};

_unit = _this select 0;
_enemy = _this select 1;

while {(alive _unit) AND (_unit getvariable "acpl_dostop")} do {
	if ([_unit,_enemy] call acpl_dostop_runaway_risk) then {
		_unit setvariable ["acpl_dostop",false,true];
	};
	if ((acpl_ied_noiedsretreat) AND (count (_unit getvariable "acpl_ied_active") == 0)) then {
		_unit setvariable ["acpl_dostop",false,true];
	};
	sleep 15;
};