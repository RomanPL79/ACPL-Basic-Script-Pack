private ["_unit","_ied","_trigger","_enemies","_time_spotted","_time_trigger","_time_wait","_time_touchoff","_not_broken","_civilian"];

_unit = _this select 0;
_ied = _this select 1;
_trigger = _this select 2;
_civilian = _this select 3;

if (!isserver) exitwith {};

//_nul = [this,ied,"ACE_Cellphone",true] execVM "acpl_fncs\acpl_ied_create.sqf";
//1.0

if (isNil "acpl_fncs_initied") then {acpl_fncs_initied = false};

waitUntil {acpl_fncs_initied};

_enemies = [_unit] call acpl_check_enemy;

_unit setvariable ["acpl_ied_ready",true,true];

if (!(_trigger in items _unit)) then {_unit additem _trigger};

if (isNil {_unit getVariable "acpl_ied_active"}) then {_unit setvariable ["acpl_ied_active",[],true];};
if (isNil {_unit getVariable "acpl_ied_civ"}) then {_unit setvariable ["acpl_ied_civ",false,true];};

_unit setvariable ["acpl_ied_active",(_unit getVariable "acpl_ied_active") + [_ied],true];

_time_spotted = 0;
_time_trigger = true;
_time_wait = 0;
_time_touchoff = 0;

_not_broken = [_trigger] call acpl_ied_broken_ied;

if ((_civilian) AND !(_unit getVariable "acpl_ied_civ")) then {
	_unit setvariable ["acpl_ied_civ",true,true];
	_nul = [_unit,"up",false,true,acpl_ied_noiedsretreat] execVM "acpl_fncs\dostop.sqf";
};

while {(alive _unit) AND (alive _ied)} do {
	if ([_ied,acpl_ied_distance,_enemies,_unit] call acpl_enemyinrange) then {
		private ["_worth"];
		
		_worth = [_ied,acpl_ied_distance,_enemies,_unit] call acpl_ied_worth;
		if (_time_trigger) then {
			_time_trigger = false;
			_time_spotted = time;
		};
		_time_wait = acpl_ied_time / _worth;
		_time_touchoff = _time_spotted + _time_wait/2 + (random _time_wait/2);
		systemchat str(_not_broken);
		systemchat str(_time_touchoff);
		if ((time >= _time_touchoff) AND ([_unit,_trigger] call acpl_ied_abletotouchoff) AND (_unit getvariable "acpl_ied_ready")) then {
			if (_not_broken) then {[_ied,_unit,_trigger] spawn acpl_ied_touchoff;};
		};
	} else {
		_time_trigger = true;
		_time_wait = 0;
		_time_touchoff = 0;
		_time_spotted = 0;
	};
	
	sleep 1;
};
