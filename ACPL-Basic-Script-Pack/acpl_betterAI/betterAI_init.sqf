private [];

//ACPL BetterAI
//v1.1a

if (!isserver) exitwith {};

waitUntil {acpl_fncs_initied};

acpl_betterAI_inited = false;

acpl_betterAI_doneunits = [];
publicvariable "acpl_betterAI_doneunits";

acpl_betterAI_donegroups = [];
publicvariable "acpl_betterAI_donegroups";

acpl_betterAI_morale_done = [];
publicvariable "acpl_betterAI_morale_done";

[] execVM "acpl_configs\weapons.sqf";

sleep 5;

if (acpl_betterAI_morale_enabled) then {
	acpl_betterAI_morale_west = acpl_betterAI_startmorale_blue;
	acpl_betterAI_morale_east = acpl_betterAI_startmorale_red;
	acpl_betterAI_morale_resistance = acpl_betterAI_startmorale_green;
};

acpl_betterAI_loop = {
	while {true} do {
		{
			if (!(_x in acpl_betterAI_doneunits)) then {
				_x setvariable ["acpl_betterAI_see_enemy_info",false,true];
				_x setvariable ["acpl_betterAI_see_body",false,true];
				_x setvariable ["acpl_betterAI_group",group _x,true];
				_x setvariable ["acpl_betterAI_role",getText ( configfile >> "CfgVehicles" >> typeof _x >> "Role"),true];
				_x addEventHandler ["Killed", {
					params ["_unit", "_killer", "_instigator", "_useEffects"];
					
					_unit removeAllEventHandlers "killed";
					[_killer] call acpl_betterAI_killedenemy;
				}];
				
				acpl_betterAI_doneunits = acpl_betterAI_doneunits + [_x];
				publicvariable "acpl_betterAI_doneunits";
			};
			
			if ([_x,[_x] call acpl_check_enemy,acpl_betterAI_detection] call acpl_check_knowsaboutenemy) then {
				_null = [_x] spawn acpl_betterAI_see_enemy;
			} else {
				if (_x getvariable "acpl_betterAI_see_enemy_info") then {_x setvariable ["acpl_betterAI_see_enemy_info",false,true];};
			};
			if ([_x,acpl_betterAI_detection] call acpl_check_seebody) then {
				_null = [_x] spawn acpl_betterAI_see_body;
			} else {
				if (_x getvariable "acpl_betterAI_see_body") then {_x setvariable ["acpl_betterAI_see_body",false,true];};
			};
		} foreach allunits;
		
		{
			if (side _x == civilian) then {} else {
				if (!(_x in acpl_betterAI_donegroups)) then {
					_x setvariable ["acpl_betterAI_group_units",units _x,true];
					
					if (acpl_betterAI_morale_enabled AND !(_x in acpl_betterAI_morale_done)) then {
						if ((count (units _x)) > 0) then {
							if (side _x == WEST) then {_x setvariable ["acpl_betterAI_group_morale",acpl_betterAI_morale_west,true];};
							if (side _x == EAST) then {_x setvariable ["acpl_betterAI_group_morale",acpl_betterAI_morale_east,true];};
							if (side _x == RESISTANCE) then {_x setvariable ["acpl_betterAI_group_morale",acpl_betterAI_morale_resistance,true];};
							
							_x setvariable ["acpl_betterAI_morale_changed",false,true];
							_x setvariable ["acpl_betterAI_group_start_num",(count (units _x)),true];
							_x setvariable ["acpl_betterAI_group_last_num",(count (units _x)),true];
							_x setvariable ["acpl_betterAI_group_start_leader",leader _x,true];
							_x setvariable ["acpl_betterAI_group_last_leader",leader _x,true];
							_x setvariable ["acpl_betterAI_group_groupsnear",0,true];
							_x setvariable ["acpl_betterAI_group_groupsnear_lastmodifier",0,true];
							
							_x setvariable ["acpl_betterAI_excluded",false,true];
							
							acpl_betterAI_morale_done = acpl_betterAI_morale_done + [_x];
							publicvariable "acpl_betterAI_morale_done";
						} else {
							_x setvariable ["acpl_betterAI_excluded",true,true];
							
							acpl_betterAI_morale_done = acpl_betterAI_morale_done + [_x];
							publicvariable "acpl_betterAI_morale_done";
						};
					};
					
					acpl_betterAI_donegroups = acpl_betterAI_donegroups + [_x];
					publicvariable "acpl_betterAI_donegroups";
				};
				
				if (acpl_betterAI_morale_enabled) then {
					if (_x getvariable "acpl_betterAI_morale_changed") then {
						[_x] spawn acpl_betterAI_calculate_skill;
						[side _x] spawn acpl_betterAI_calculate_sidemorale;
					};
					
					if (([_x] call acpl_betterAI_friendlygroupsnear) OR (!([_x] call acpl_betterAI_friendlygroupsnear) AND (_x getvariable "acpl_betterAI_group_groupsnear_lastmodifier" != 0))) then {
						private ["_modifiers", "_modify", "_morale"];
						
						_modifiers = [_x] call acpl_betterAI_check_groupnear;
						_morale = _x getvariable "acpl_betterAI_group_morale";
						
						_modify = 0;
						if ((count _modifiers) > 0) then {
							private ["_count"];
							
							{_modify = _modify + _x;} foreach _modifiers;
							_count = (count _modifiers) / acpl_betterAI_countgroups_modifier;
							_modify = _modify / _count;
						};
						if (_x getvariable "acpl_betterAI_group_groupsnear_lastmodifier" == 0) then {
							_x setvariable ["acpl_betterAI_group_morale",_morale + _modify,true];
							_x setvariable ["acpl_betterAI_group_groupsnear_lastmodifier",_modify,true];
						} else {
							_x setvariable ["acpl_betterAI_group_morale",_morale + _modify - (_x getvariable "acpl_betterAI_group_groupsnear_lastmodifier"),true];
							_x setvariable ["acpl_betterAI_group_groupsnear_lastmodifier",_modify,true];
						};
						_x setvariable ["acpl_betterAI_morale_changed",true,true];
					};
					
					if ((leader _x) != (_x getvariable "acpl_betterAI_group_last_leader")) then {
						if (_x getvariable "acpl_betterAI_group_last_leader" == _x getvariable "acpl_betterAI_group_start_leader") then {
							private ["_morale"];
							
							_morale = (_x getvariable "acpl_betterAI_group_morale") - ((acpl_betterAI_morale_lostleader * 1.5) * (_x getvariable "acpl_betterAI_group_morale"));
							_x setvariable ["acpl_betterAI_group_morale",_morale,true];
							
							_x setvariable ["acpl_betterAI_morale_changed",true,true];
						} else {
							private ["_morale"];
							
							_morale = (_x getvariable "acpl_betterAI_group_morale") - (acpl_betterAI_morale_lostleader * (_x getvariable "acpl_betterAI_group_morale"));
							_x setvariable ["acpl_betterAI_group_morale",_morale,true];
							
							_x setvariable ["acpl_betterAI_morale_changed",true,true];
						};
						
						_x setvariable ["acpl_betterAI_group_last_leader",leader _x,true];
					};
					
					if ((count (units _x)) != (_x getvariable "acpl_betterAI_group_last_num")) then {
						private ["_change"];
						
						_change = (_x getvariable "acpl_betterAI_group_last_num") - (count (units _x));
						if ((_x getvariable "acpl_betterAI_group_last_num") == (_x getvariable "acpl_betterAI_group_start_num")) then {
							private ["_modifier", "_morale"];
							
							_modifier = ((acpl_betterAI_lostunit_modifier * 1.5) * (_x getvariable "acpl_betterAI_group_morale"));
							_morale = (_x getvariable "acpl_betterAI_group_morale") - (_modifier * _change);
							
							_x setvariable ["acpl_betterAI_group_morale",_morale,true];
							_x setvariable ["acpl_betterAI_group_last_num",(count (units _x)),true];
							
							_x setvariable ["acpl_betterAI_morale_changed",true,true];
						} else {
							private ["_modifier", "_morale"];
							
							_modifier = (acpl_betterAI_lostunit_modifier * (_x getvariable "acpl_betterAI_group_morale"));
							_morale = (_x getvariable "acpl_betterAI_group_morale") - (_modifier * _change);
							
							_x setvariable ["acpl_betterAI_group_morale",_morale,true];
							_x setvariable ["acpl_betterAI_group_last_num",(count (units _x)),true];
							
							_x setvariable ["acpl_betterAI_morale_changed",true,true];
						};
					};
				};
			};
		} foreach allGroups;
		sleep 1;
	};
};
publicvariable "acpl_betterAI_loop";

[] spawn acpl_betterAI_loop;

acpl_betterAI_killedenemy = {
	private ["_group", "_modifier", "_morale"];
	
	_group = group (_this select 0);
	
	_modifier = (acpl_betterAI_kill_modifier * (_group getvariable "acpl_betterAI_group_morale"));
	_morale = (_group getvariable "acpl_betterAI_group_morale") + _modifier;
	_group setvariable ["acpl_betterAI_group_morale",_morale,true];
	
	_group setvariable ["acpl_betterAI_morale_changed",true,true];
};
publicvariable "acpl_betterAI_killedenemy";

acpl_betterAI_check_groupnear = {
	private ["_group", "_return"];
	
	_group = _this select 0;
	_return = [];
	
	{
		if ((side _x == side _group) AND ((leader _x) distance (leader _group) <= acpl_betterAI_groups_distance) AND !(_x getvariable "acpl_betterAI_excluded")) then {
			private ["_distance", "_modifier"];
			
			_distance = (leader _x) distance (leader _group);
			_modifier = (_distance / (acpl_betterAI_groups_distance / acpl_betterAI_groups_modifier));
			
			_return = _return + [_modifier];
		};
	} foreach allGroups;
	
	_return
};
publicvariable "acpl_betterAI_check_groupnear";

acpl_betterAI_friendlygroupsnear = {
	private ["_return", "_group"];
	
	_group = _this select 0;
	_return = false;
	
	{
		if ((side _x == side _group) AND ((leader _x) distance (leader _group) <= acpl_betterAI_groups_distance) AND !(_x getvariable "acpl_betterAI_excluded")) then {_return = true;}; 
	} foreach allgroups;
	
	_return
};
publicvariable "acpl_betterAI_friendlygroupsnear";

acpl_betterAI_enemydetected = {
	private ["_side", "_trigger", "_return", "_bodies"];
	
	_side = _this select 0;
	_trigger = _this select 1;
	if (isNil {_this select 2}) then {_bodies = true;} else {_bodies = _this select 2;};
	_return = false;
	
	{
		if ((side _x == _side) AND (alive _x)) then {
			if (_x getvariable "acpl_betterAI_see_enemy_info") then {_return = true;};
			if (_bodies AND (_x getvariable "acpl_betterAI_see_body")) then {_return = true;};
		};
	} foreach allunits;
	
	_return
};
publicvariable "acpl_betterAI_enemydetected";

acpl_betterAI_calculate_sidemorale = {
	private ["_side"];
	
	_side = _this select 0;
	
	if (_side == WEST) then {
		private ["_num", "_g_num"];
		
		_num = 0;
		_g_num = 0;
		{
			if ((side _x == WEST) AND !(_x getvariable "acpl_betterAI_excluded")) then {
				_num = _num + (_x getvariable "acpl_betterAI_group_morale");
				_g_num = _g_num + 1;
			};
		} foreach allGroups;
		
		acpl_betterAI_morale_west = (_num / _g_num);
	};
	if (_side == EAST) then {
		private ["_num", "_g_num"];
		
		_num = 0;
		_g_num = 0;
		{
			if ((side _x == EAST) AND !(_x getvariable "acpl_betterAI_excluded")) then {
				_num = _num + (_x getvariable "acpl_betterAI_group_morale");
				_g_num = _g_num + 1;
			};
		} foreach allGroups;
		
		acpl_betterAI_morale_east = (_num / _g_num);
	};
	if (_side == RESISTANCE) then {
		private ["_num", "_g_num"];
		
		_num = 0;
		_g_num = 0;
		{
			if ((side _x == RESISTANCE) AND !(_x getvariable "acpl_betterAI_excluded")) then {
				_num = _num + (_x getvariable "acpl_betterAI_group_morale");
				_g_num = _g_num + 1;
			};
		} foreach allGroups;
		
		acpl_betterAI_morale_resistance = (_num / _g_num);
	};
};
publicvariable "acpl_betterAI_calculate_sidemorale";

acpl_betterAI_calculate_skill = {
	private ["_group", "_morale"];
	
	_group = _this select 0;
	_morale = _group getvariable "acpl_betterAI_group_morale";
	
	if (_group getvariable "acpl_betterAI_excluded") then {} else {
		{
			private ["_AimAcc", "_AimSha", "_AimSpe", "_SpoDis", "_SpoTim", "_Gen", "_Cou", "_Rel"];
			
			waitUntil {_x in acpl_msc_done};
			
			_AimAcc = (_x getVariable "acpl_msc_AimAcc") - ((_x getVariable "acpl_msc_AimAcc") * (_morale / 100));
			if (_AimAcc >= (acpl_betterAI_morale_changer * (_x getVariable "acpl_msc_AimAcc"))) then {
				_AimAcc = (_x getVariable "acpl_msc_AimAcc") - (acpl_betterAI_morale_changer * (_x getVariable "acpl_msc_AimAcc"));
			} else {
				_AimAcc = (_x getVariable "acpl_msc_AimAcc") - _AimAcc;
			};
			_x setSkill ["aimingAccuracy", _AimAcc];
			
			_AimSha = (_x getVariable "acpl_msc_AimSha") - ((_x getVariable "acpl_msc_AimSha") * (_morale / 100));
			if (_AimSha >= (acpl_betterAI_morale_changer * (_x getVariable "acpl_msc_AimSha"))) then {
				_AimSha = (_x getVariable "acpl_msc_AimSha") - (acpl_betterAI_morale_changer * (_x getVariable "acpl_msc_AimSha"));
			} else {
				_AimSha = (_x getVariable "acpl_msc_AimSha") - _AimSha;
			};
			_x setSkill ["aimingShake", _AimSha];
			
			_AimSpe = (_x getVariable "acpl_msc_AimSpe") - ((_x getVariable "acpl_msc_AimSpe") * (_morale / 100));
			if (_AimSpe >= (acpl_betterAI_morale_changer * (_x getVariable "acpl_msc_AimSpe"))) then {
				_AimSpe = (_x getVariable "acpl_msc_AimSpe") - (acpl_betterAI_morale_changer * (_x getVariable "acpl_msc_AimSpe"));
			} else {
				_AimSpe = (_x getVariable "acpl_msc_AimSpe") - _AimSpe;
			};
			_x setSkill ["aimingSpeed", _AimSpe];
			
			_SpoDis = (_x getVariable "acpl_msc_SpoDis") - ((_x getVariable "acpl_msc_SpoDis") * (_morale / 100));
			if (_SpoDis >= (acpl_betterAI_morale_changer * (_x getVariable "acpl_msc_SpoDis"))) then {
				_SpoDis = (_x getVariable "acpl_msc_SpoDis") - (acpl_betterAI_morale_changer * (_x getVariable "acpl_msc_SpoDis"));
			} else {
				_SpoDis = (_x getVariable "acpl_msc_SpoDis") - _SpoDis;
			};
			_x setSkill ["spotDistance", _SpoDis];
			
			_SpoTim = (_x getVariable "acpl_msc_SpoTim") - ((_x getVariable "acpl_msc_SpoTim") * (_morale / 100));
			if (_SpoTim >= (acpl_betterAI_morale_changer * (_x getVariable "acpl_msc_SpoTim"))) then {
				_SpoTim = (_x getVariable "acpl_msc_SpoTim") - (acpl_betterAI_morale_changer * (_x getVariable "acpl_msc_SpoTim"));
			} else {
				_SpoTim = (_x getVariable "acpl_msc_SpoTim") - _SpoTim;
			};
			_x setSkill ["spotTime", _SpoTim];
			
			_Gen = (_x getVariable "acpl_msc_Gen") - ((_x getVariable "acpl_msc_Gen") * (_morale / 100));
			if (_Gen >= (acpl_betterAI_morale_changer * (_x getVariable "acpl_msc_Gen"))) then {
				_Gen = (_x getVariable "acpl_msc_Gen") - (acpl_betterAI_morale_changer * (_x getVariable "acpl_msc_Gen"));
			} else {
				_Gen = (_x getVariable "acpl_msc_Gen") - _Gen;
			};
			_x setSkill ["general", _Gen];
			
			_Cou = (_x getVariable "acpl_msc_Cou") - ((_x getVariable "acpl_msc_Cou") * (_morale / 100));
			if (_Cou >= (acpl_betterAI_morale_changer * (_x getVariable "acpl_msc_Cou"))) then {
				_Cou = (_x getVariable "acpl_msc_Cou") - (acpl_betterAI_morale_changer * (_x getVariable "acpl_msc_Cou"));
			} else {
				_Cou = (_x getVariable "acpl_msc_Cou") - _Cou;
			};
			_x setSkill ["courage", _Cou];
			
			_Rel = (_x getVariable "acpl_msc_Rel") - ((_x getVariable "acpl_msc_Rel") * (_morale / 100));
			if (_Rel >= (acpl_betterAI_morale_changer * (_x getVariable "acpl_msc_Rel"))) then {
				_Rel = (_x getVariable "acpl_msc_Rel") - (acpl_betterAI_morale_changer * (_x getVariable "acpl_msc_Rel"));
			} else {
				_Rel = (_x getVariable "acpl_msc_Rel") - _Rel;
			};
			_x setSkill ["reloadSpeed", _Rel];
		} foreach (units _group);
	};
};
publicvariable "acpl_betterAI_calculate_skill";

acpl_betterAI_see_enemy = {
	private ["_unit","_side","_enemy","_sleep","_skill"];
	
	_unit = _this select 0;
	_side = side _unit;
	_enemy = [_unit] call acpl_check_enemy;
	
	if (isPlayer _unit) exitwith {};

	_skill = ((_unit skill "spotTime") * 10);
	_sleep = acpl_betterAI_detection_time + (acpl_betterAI_detection_time / _skill);

	sleep _sleep;
	if ((alive _unit) AND ([_unit,_enemy,acpl_betterAI_detection] call acpl_check_knowsaboutenemy)) then {
		_unit setvariable ["acpl_betterAI_see_enemy_info",true,true];
	};
};
publicvariable "acpl_betterAI_see_enemy";

acpl_betterAI_see_body = {
	private ["_unit","_side","_enemy","_sleep","_skill"];
	
	_unit = _this select 0;
	
	if (isPlayer _unit) exitwith {};

	_skill = ((_unit skill "spotTime") * 10);
	_sleep = acpl_betterAI_detection_time + (acpl_betterAI_detection_time / _skill);

	sleep _sleep;
	if ((alive _unit) AND ([_unit,acpl_betterAI_detection] call acpl_check_seebody)) then {
		_unit setvariable ["acpl_betterAI_see_body",true,true];
	};
};
publicvariable "acpl_betterAI_see_body";

acpl_betterAI_inited = true;