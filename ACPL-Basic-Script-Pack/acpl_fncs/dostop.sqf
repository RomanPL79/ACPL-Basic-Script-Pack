private ["_unit","_position","_enableduckig","_start_dir","_s_num","_hideweapon","_canrun","_enemy","_dowatch_dir","_anim","_anim_choosen","_enemy","_animation","_run","_getlow"];

_unit = _this select 0;
_position = _this select 1;
_enableduckig = _this select 2;
if (isNil {_this select 3}) then {_hideweapon = false;} else {_hideweapon = _this select 3;};
if (isNil {_this select 4}) then {_canrun = false;} else {_canrun = _this select 4;};
if (isNil {_this select 5}) then {_run = false;} else {_run = _this select 5;};
if (isNil {_this select 6}) then {_getlow = false;} else {_getlow = _this select 6;};

//_nul = [this,"up",true,false,false,false,false] execVM "acpl_fncs\dostop.sqf";
//v1.9

if (!isserver) exitwith {};

_start_dir = getDir _unit;

waitUntil {acpl_fncs_initied};

_dowatch_dir = [getpos _unit, _start_dir] call acpl_calculate_posfromdir;

_unit setvariable ["acpl_dostop",true,true];
_unit setvariable ["acpl_dostop_lower",false,true];
if (_position == "up") then {_unit setvariable ["acpl_dostop_pos",2,true];};
if (_position == "middle") then {_unit setvariable ["acpl_dostop_pos",1,true];};
if (_position == "down") then {_unit setvariable ["acpl_dostop_pos",0,true];};

_s_num = _unit getvariable "acpl_dostop_pos";

_enemy = [_unit] call acpl_check_enemy;

if (_hideweapon) then {
	private ["_weapons"];
	
	_weapons = weapons _unit;
	_nul = [_unit,_weapons,_enemy] execVM "acpl_fncs\AI\hideweapon.sqf";
};

if (_canrun) then {
	_nul = [_unit,_enemy] execVM "acpl_fncs\AI\runaway.sqf";
};

_unit setunitpos _position;
_unit setVariable ["VCOM_NOAI",true];
_unit setVariable ["Vcm_Disable",true];
[_unit,"PATH"] remoteExec ["DisableAI",0];
[_unit,"AUTOCOMBAT"] remoteExec ["DisableAI",0];
_unit domove (position _unit);
sleep 1;
_unit dowatch _dowatch_dir;
if (_enableduckig) then {_nul = [_unit] execVM "acpl_fncs\AI\reload_duck.sqf";};

while {(alive _unit)} do {
	if (_unit getvariable "acpl_dostop") then {
		if ((_s_num != (_unit getvariable "acpl_dostop_pos")) OR (unitPos _unit != _position)) then {
			if ((_unit getvariable "acpl_dostop_pos") == 0) then {_unit setunitpos "down";};
			if ((_unit getvariable "acpl_dostop_pos") == 1) then {_unit setunitpos "middle";};
			if ((_unit getvariable "acpl_dostop_pos") == 2) then {_unit setunitpos "up";};
		};
		if (_run) then {
			if (([_unit,_enemy,acpl_betterAI_detection] call acpl_check_knowsaboutenemy) OR ([_unit,acpl_betterAI_detection] call acpl_check_seebody)) then {
				_unit setvariable ["acpl_dostop",false,true];
			};
		};
		if (_getlow) then {
			if ((([_unit,_enemy,acpl_betterAI_detection] call acpl_check_knowsaboutenemy) OR ([_unit,acpl_betterAI_detection] call acpl_check_seebody)) AND !(_unit getvariable "acpl_dostop_lower")) then {
				_unit setvariable ["acpl_dostop_lower",true,true];
				if (_unit getvariable "acpl_dostop_pos" > 0) then {
					_unit setvariable ["acpl_dostop_pos",(_unit getvariable "acpl_dostop_pos") - 1,true];
				};
			};
		};
		_unit dowatch _dowatch_dir;
		sleep 1;
	} else {
		[_unit,"PATH"] remoteExec ["EnableAI",0];
		[_unit,"AUTOCOMBAT"] remoteExec ["EnableAI",0];
		_unit setunitpos "AUTO";
		_unit dofollow (leader (group _unit));
		sleep 60;
		_unit setVariable ["VCOM_NOAI",false,true];
		_unit setVariable ["Vcm_Disable",false,true];
		if (true) exitwith {};
	};
};