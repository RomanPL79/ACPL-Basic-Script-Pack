if (!isserver) exitwith {};

acpl_check_seebody = {
	private ["_unit", "_detection", "_return"];
	
	_unit = _this select 0;
	if (isNil {_this select 1}) then {_detection = 1;} else {_detection = _this select 1;};
	_return = false;
	
	{
		if (_unit knowsAbout _x > _detection) then {_return = true;};
	} foreach allDead;
	{
		if ((_unit getvariable "ace_isunconscious") AND (_unit knowsAbout _x > _detection)) then {_return = true;};
	} foreach allunits;
	
	_return
};
publicvariable "acpl_check_seebody";

acpl_check_knowsaboutenemy = {
	private ["_unit", "_enemy", "_return", "_detection"];
	
	_unit = _this select 0;
	if (isNil {_this select 1}) then {_enemy = [_unit] call acpl_check_enemy;} else {_enemy = _this select 1;};
	if (isNil {_this select 2}) then {_detection = 1;} else {_detection = _this select 2;};
	
	_return = false;
	
	{
		if (side _x in _enemy) then {
			if (_unit knowsAbout _x > _detection) then {_return = true;}; 
		};
	} foreach allunits;
	
	_return
};
publicvariable "acpl_check_knowsaboutenemy";

acpl_calculate_posfromdir = {
	private ["_center","_dir","_distance","_return"];
	
	_center = _this select 0;
	_dir = _this select 1;
	if (isNil {_this select 2}) then {_distance = 250;} else {_distance = _this select 2;};
	_return = [0,0];
	
	if ((_dir >= 337.5) AND (_dir < 22.5)) then {
		_return = [(_center select 0),(_center select 1) + _distance];
	};
	if ((_dir >= 25.5) AND (_dir < 67.5)) then {
		_return = [(_center select 0) + _distance, (_center select 1) + _distance];
	};
	if ((_dir >= 67.5) AND (_dir < 112.5)) then {
		_return = [(_center select 0) + _distance, (_center select 1)];
	};
	if ((_dir >= 112.5) AND (_dir < 157.5)) then {
		_return = [(_center select 0) + _distance, (_center select 1) - _distance];
	};
	if ((_dir >= 157.5) AND (_dir < 202.5)) then {
		_return = [(_center select 0), (_center select 1) - _distance];
	};
	if ((_dir >= 202.5) AND (_dir < 247.5)) then {
		_return = [(_center select 0) - _distance, (_center select 1) - _distance];
	};
	if ((_dir >= 247.5) AND (_dir < 292.5)) then {
		_return = [(_center select 0) - _distance, (_center select 1)];
	};
	if ((_dir >= 292.5) AND (_dir < 337.5)) then {
		_return = [(_center select 0) - _distance, (_center select 1) + _distance];
	};
	
	_return
};
publicvariable "acpl_calculate_posfromdir";

acpl_check_enemy = {
	private ["_unit","_side","_enemy","_blue","_green","_red"];
	
	_unit = _this select 0;
	_side = side _unit;
	
	_blue = _side getFriend west;
	_red = _side getFriend east;
	_green = _side getFriend resistance;
	
	_enemy = [];
	if (_blue < 0.6) then {_enemy = _enemy + [WEST];};
	if (_red < 0.6) then {_enemy = _enemy + [EAST];};
	if (_green < 0.6) then {_enemy = _enemy + [RESISTANCE];};
	
	_enemy
};
publicvariable "acpl_check_enemy";

acpl_check_enemy_side = {
	private ["_side","_enemy","_blue","_green","_red"];
	
	_side = _this select 0;
	
	_blue = _side getFriend west;
	_red = _side getFriend east;
	_green = _side getFriend resistance;
	
	_enemy = [];
	if (_blue < 0.6) then {_enemy = _enemy + [WEST];};
	if (_red < 0.6) then {_enemy = _enemy + [EAST];};
	if (_green < 0.6) then {_enemy = _enemy + [RESISTANCE];};
	
	_enemy
};
publicvariable "acpl_check_enemy_side";

acpl_enemyinrange = {
	private ["_center","_distance","_enemy","_return","_unit"];
	
	_center = _this select 0;
	_distance = _this select 1;
	_enemy = _this select 2;
	_unit = _this select 3;
	_return = false;
	
	{
		if (_x distance _center <= _distance) then {
			private ["_side"];
			
			_side = side _x;
			if ((_side in _enemy) AND (_unit knowsAbout _x > 1)) then {_return = true;};
		};
	} foreach allunits;
	
	_return
};
publicvariable "acpl_enemyinrange";

acpl_dostop_weap_risk = {
	private ["_unit","_enemy","_distance","_list","_chance","_random","_courage"];
	
	_unit = _this select 0;
	_enemy = _this select 1;
	_distance = acpl_dostop_weap_distance;
	_list = [];
	_return = false;
	_courage = _unit skill "courage";
	
	{
		if (_x distance _unit <= _distance) then {
			private ["_side"];
			
			_side = side _x;
			if ((_side in _enemy) AND (_unit knowsAbout _x > 1)) then {
				_list = _list + [_x];
			};
		};
	} foreach allunits;
	
	if (count _list > 0) then {_chance = acpl_dostop_weap_chance / (count _list) * _courage;} else {_chance = acpl_dostop_weap_chance * _courage;};
	_random = random 100;
	
	if (_chance >= _random) then {_return = true;};
	
	_return
};
publicvariable "acpl_dostop_weap_risk";

acpl_dostop_runaway_risk = {
	private ["_unit","_enemy","_distance","_someone","_chance","_random","_courage","_dis","_multiplier"];
	
	_unit = _this select 0;
	_enemy = _this select 1;
	_distance = acpl_dostop_retreat_distance;
	_someone = false;
	_return = false;
	_courage = _unit skill "courage";
	_dis = _distance;
	
	{
		if (_x distance _unit <= _distance) then {
			private ["_side"];
			
			_side = side _x;
			if ((_side in _enemy) AND (_unit knowsAbout _x > 1)) then {
				_someone = true;
				if (_dis > _x distance _unit) then {_dis = _x distance _unit};
			};
		};
	} foreach allunits;
	
	_multiplier = _distance / _dis;
	_chance = acpl_dostop_retreat_chance * _multiplier / _courage;
	_random = random 100;
	
	if ((_chance >= _random) AND _someone) then {_return = true;};
	
	_return
};
publicvariable "acpl_dostop_runaway_risk";

acpl_check_onground = {
	private ["_list","_return"];
	
	_list = _this select 0;
	_return = true;
	
	{
		if ((alive _x) AND !(isTouchingGround (vehicle _x))) then {_return = false;};
	} foreach _list;
	
	_return
};
publicvariable "acpl_check_onground";

acpl_AI_check_funcs = true;
publicvariable "acpl_AI_check_funcs";

if (acpl_fnc_debug) then {["ACPL FNCS AI FUNCTIONS LOADED"] remoteExec ["systemchat",0];};