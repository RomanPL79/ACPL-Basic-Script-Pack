if (!isserver) exitwith {};

acpl_ied_touchoff = {
	private ["_ied","_trigger","_random","_unit"];
		
	_ied = _this select 0;
	_unit = _this select 1;
	_trigger = _this select 2;
		
	_random = random 100;
		
	_unit setvariable ["acpl_ied_ready",false,true];
	[_unit] spawn acpl_ied_playanim;
	sleep 5;
		
	if ((acpl_ied_failed <= _random) AND !([_ied,_trigger] call acpl_ied_jammed)) then {
		if (_trigger in acpl_ied_trigger_phone) then {
			private ["_sleep"];
			
			_sleep = 12 + (random 3);
			sleep (_sleep - 1);
			[_ied,"acpl_ied_nokia_sound"] remoteExec ["say3D",0];
			sleep 1;
			[_ied, 0] call ace_explosives_fnc_scriptedExplosive;
		};
		if (_trigger in acpl_ied_trigger_clacker) then {
			private ["_sleep"];
				
			_sleep = 1 + (random 1);
			sleep (_sleep - 0.5);
			[_ied,"acpl_ied_trigger"] remoteExec ["say3D",0];
			sleep 0.5;
			[_ied, 0] call ace_explosives_fnc_scriptedExplosive;
		};
		_unit setvariable ["acpl_ied_active",(_unit getVariable "acpl_ied_active") - [_ied],true];
	} else {
		if (_trigger in acpl_ied_trigger_phone) then {
			private ["_sleep"];
				
			_sleep = 12 + (random 3);
			[_ied,"acpl_ied_nokia_sound_full"] remoteExec ["say3D",0];
			sleep _sleep;
		};
		if (_trigger in acpl_ied_trigger_clacker) then {
			private ["_sleep"];
				
			_sleep = 1 + (random 1);
			[_ied,"acpl_ied_trigger"] remoteExec ["say3D",0];
			sleep _sleep;
		};
	};
		
	sleep 2;
	_unit setvariable ["acpl_ied_ready",true,true];
};
publicvariable "acpl_touchoff";
	
acpl_ied_worth = {
	private ["_center","_distance","_enemy","_return","_list","_unit","_courage","_knowsabout","_vehs","_knowsabout_veh"];
		
	_center = _this select 0;
	_distance = _this select 1;
	_enemy = _this select 2;
	_unit = _this select 3;
	_courage = _unit skill "courage";
	_list = [];
	_knowsabout = [];
	_vehs = [];
	_knowsabout_veh = [];
		
	{
		if (_x distance _center <= _distance) then {
			private ["_side"];
				
			_side = side _x;
			if (_side in _enemy) then {
				_list = _list + [_x];
				if (vehicle _x != _x) then {
					_vehs = _vehs + [vehicle _x];
				};
			};
		};
	} foreach allunits;
	{
		if (_unit knowsAbout _x > 1) then {
			_knowsabout = _knowsabout + [_x];
		};
	} foreach _list;
	{
		if (_unit knowsAbout _x > 1) then {
			_knowsabout_veh = _knowsabout_veh + [_x];
		};
	} foreach _vehs;
		
	_return = count _knowsabout * acpl_ied_worth_modifier * _courage + count _knowsabout_veh * 2 * acpl_ied_worth_modifier * _courage;
		
	_return
};
publicvariable "acpl_ied_worth";
	
acpl_ied_abletotouchoff = {
	private ["_unit","_trigger","_return"];
		
	_unit = _this select 0;
	_trigger = _this select 1;
	_return = true;
		
	if (_unit getvariable "ace_captives_ishandcuffed") then {_return = false;};
	if (_unit getvariable "ace_isunconscious") then {_return = false;};
	if (!(_trigger in items _unit)) then {_return = false;};
		
	_return
};
publicvariable "acpl_ied_abletotouchoff";
	
acpl_ied_broken_ied = {
	private ["_return","_random","_trigger"];
		
	_trigger = _this select 0;
		
	_return = true;
	_random = random 100;
		
	if (_trigger in acpl_ied_trigger_phone) then {
		if (acpl_ied_broken_chance >= _random) then {_return = false;};
	};
	if (_trigger in acpl_ied_trigger_clacker) then {
		if ((acpl_ied_broken_chance / 2) >= _random) then {_return = false;};
	};
		
	_return
};
publicvariable "acpl_ied_abletotouchoff";
	
acpl_ied_jammed = {
	private ["_ied","_trigger","_return"];
		
	_ied = _this select 0;
	_trigger = _this select 1;
	_return = false;
		
		
	if (_trigger in acpl_ied_trigger_phone) then {
		{
			if ((_ied distance _x <= acpl_ied_jammer_distance) AND (_x getvariable "acpl_ied_phone_jammer_active")) then {
				if (_ied distance _x <= acpl_ied_jammer_effective_distance) then {
					private ["_random"];
						
					_random = random 100;
					if (_random <= acpl_ied_jammer_effectivity) then {_return = true;[_x] spawn acpl_ied_jammer_giveinfo;};
				} else {
					private ["_random","_effectivity"];
					
					_random = random 100;
					_effectivity = (_ied distance _x) / (acpl_ied_jammer_distance - acpl_ied_jammer_effective_distance) * acpl_ied_jammer_effectivity;
					if (_random <= _effectivity) then {_return = true;[_x] spawn acpl_ied_jammer_giveinfo;};
				};
			};
		} foreach acpl_ied_jammers;
	};
	if (_trigger in acpl_ied_trigger_clacker) then {
				{
			if ((_ied distance _x <= acpl_ied_jammer_distance) AND (_x getvariable "acpl_ied_clacker_jammer_active")) then {
				if (_ied distance _x <= acpl_ied_jammer_effective_distance) then {
					private ["_random"];
						
					_random = random 100;
					if (_random <= (acpl_ied_jammer_effectivity - acpl_ied_jammer_effectivity/4)) then {_return = true;[_x] spawn acpl_ied_jammer_giveinfo;};
				} else {
					private ["_random","_effectivity"];
					
					_random = random 100;
					_effectivity = (_ied distance _x) / (acpl_ied_jammer_distance - acpl_ied_jammer_effective_distance) * (acpl_ied_jammer_effectivity - acpl_ied_jammer_effectivity/4);
					if (_random <= _effectivity) then {_return = true;[_x] spawn acpl_ied_jammer_giveinfo;};
				};
			};
		} foreach acpl_ied_jammers;
	};
		
	_return
};
publicvariable "acpl_ied_jammed";
	
acpl_ied_jammer_giveinfo = {
	private ["_unit"];
		
	_unit = _this select 0;
		
	{
		["Zablokowano sygna³!"] remoteExec ["systemchat",_x];
	} foreach crew _unit;
};
publicvariable "acpl_ied_jammed";
	
acpl_ied_playanim = {
	private ["_unit"];
		
	_unit = _this select 0;
		
	if (_unit getvariable "acpl_ied_civ") then {
		[_unit,"Acts_Kore_IdleNoWeapon_in"] remoteExec ["switchMove",0];
		sleep 2;
		[_unit,"Acts_Kore_TalkingOverRadio_in"] remoteExec ["switchMove",0];
		sleep 2.5;
		[_unit,"Acts_Kore_TalkingOverRadio_out"] remoteExec ["switchMove",0];
		sleep 1.5;
		[_unit,"Acts_Kore_IdleNoWeapon_out"] remoteExec ["switchMove",0];
		sleep 2;
		[_unit,""] remoteExec ["switchMove",0];
	};
};
publicvariable "acpl_ied_playanim";

acpl_ied = true;
publicvariable "acpl_ied";

if (acpl_fnc_debug) then {["ACPL FNCS IED LOADED"] remoteExec ["systemchat",0];};