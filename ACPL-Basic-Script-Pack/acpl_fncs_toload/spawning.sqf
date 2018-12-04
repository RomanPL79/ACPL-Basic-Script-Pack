if (!isserver) exitwith {};

acpl_check_assigned_vehs = {
	private ["_group","_assignes","_vehicles","_return"];
	
	_group = _this select 0;
	
	//v1.0
	
	_assignes = [];
	_units = units _group;
	{_assignes = _assignes + [assignedVehicle _x];} foreach _units;
	_vehicles = [];
	{
		if (!(_x in _vehicles)) then {
			_vehicles = _vehicles + [_x];
		};
	} foreach _assignes;
	
	_return = _vehicles;
	
	_return
};
publicvariable "acpl_check_assigned_vehs";

acpl_check_eq = {
	private ["_unit","_return","_face","_h_items","_s_items","_p_items","_h_weap","_s_weap","_p_weap","_items","_goggles","_headgear","_b_items","_backpack","_v_items","_vest","_uniform","_u_items"];
	
	_unit = _this select 0;
	_return = [];
	
	_uniform = uniform _unit;
	_u_items = uniformItems _unit;
	_vest = vest _unit;
	_v_items = vestItems _unit;
	_backpack = backpack _unit;
	_b_items = backpackitems _unit;
	_headgear = headgear _unit;
	_goggles = goggles _unit;
	_items = assignedItems _unit;
	
	_p_weap = primaryweapon _unit;
	_s_weap = secondaryweapon _unit;
	_h_weap = handgunWeapon _unit;
	
	_p_items = primaryweaponitems _unit;
	_s_items = secondaryweaponitems _unit;
	_h_items = handgunitems _unit;
	
	_face = face _unit;
	
	_return = [_uniform, _u_items, _vest, _v_items, _backpack, _b_items, _headgear, _goggles, _items, _p_weap, _s_weap, _h_weap, _p_items, _s_items, _h_items, _face];
	
	_return
};
publicvariable "acpl_check_eq";

acpl_add_eq = {
	private ["_unit","_info","_face","_h_items","_s_items","_p_items","_h_weap","_s_weap","_p_weap","_items","_goggles","_headgear","_b_items","_backpack","_v_items","_vest","_uniform","_u_items"];
	
	_unit = _this select 0;
	_info = _this select 1;
	
	_uniform = _info select 0;
	_u_items = _info select 1;
	_vest = _info select 2;
	_v_items = _info select 3;
	_backpack = _info select 4;
	_b_items = _info select 5;
	_headgear = _info select 6;
	_goggles = _info select 7;
	_items = _info select 8;
	
	_p_weap = _info select 9;
	_s_weap = _info select 10;
	_h_weap = _info select 11;
	
	_p_items = _info select 12;
	_s_items = _info select 13;
	_h_items = _info select 14;
	
	_face = _info select 15;
	
	[_unit] call acpl_remove_eq;
	
	_unit forceadduniform _uniform;
	{_unit additemtouniform _x;} foreach _u_items;
	_unit addvest _vest;
	{_unit additemtovest _x;} foreach _v_items;
	_unit addbackpack _backpack;
	{_unit additemtobackpack _x;} foreach _b_items;
	_unit addheadgear _headgear;
	_unit addgoggles _goggles;
	_unit addweapon _p_weap;
	_unit addweapon _s_weap;
	_unit addweapon _h_weap;
	{_unit addprimaryweaponitem _x;} foreach _p_items;
	{_unit addsecondaryweaponitem _x;} foreach _s_items;
	{_unit addhandgunitem _x;} foreach _h_items;
	{_unit linkItem _x;} forEach _items;
	[_unit, _face] remoteExec ["setface",0,true];
};
publicvariable "acpl_add_eq";

acpl_remove_eq = {
	private ["_unit"];
	
	_unit = _this select 0;
	
	removeallweapons _unit;
	removeuniform _unit;
	removevest _unit;
	removebackpack _unit;
	removeheadgear _unit;
	removegoggles _unit;
	{_unit unlinkItem _x;} foreach assignedItems _unit;
};
publicvariable "acpl_remove_eq";

acpl_check_info = {
	private ["_list","_return"];
	
	_list = _this select 0;
	_vehicles = _this select 1;
	
	//v1.0
	
	_return = [];
	
	{
		private ["_role","_type","_pos","_dir","_unit","_num","_veh_id","_eq"];
		
		_type = typeof _x;
		_role = assignedVehicleRole _x;
		_pos = [(getpos _x) select 0,(getpos _x) select 1,(getpos _x) select 2];
		_dir = direction _x;
		
		_veh_id = -1;
		_eq = [_x] call acpl_check_eq;
		
		_unit = _x;
		_num = 0;
		
		{
			if (vehicle _unit == _x) then {
				_veh_id = _num;
			};
			
			_num = _num + 1;
		} foreach _vehicles;
		
		_return = _return + [[_type,_pos,_dir,_role,_veh_id,_eq]];
	} foreach _list;
	
	_return
};
publicvariable "acpl_check_info";

acpl_check_info_vehs = {
	private ["_list","_return"];
	
	_list = _this select 0;
	
	//v1.0
	
	_return = [];
	
	{
		private ["_type","_pos","_dir"];
		
		_type = typeof _x;
		if (_type != "") then {
			_pos = [(getpos _x) select 0,(getpos _x) select 1,(getpos _x) select 2];
			_dir = direction _x;
			_return = _return + [[_type,_pos,_dir]];
		};
	} foreach _list;
	
	_return
};
publicvariable "acpl_check_info_vehs";

acpl_get_waypoints = {
	private ["_group","_return","_wps","_wp"];
	
	//v1.0
	
	_group = _this select 0;
	
	_return = [];
	
	_wps = count (waypoints _group);
	_wp = 0;
	for "_i" from 1 to _wps do {
		private ["_type","_pos","_beh","_com","_cr","_from","_speed","_time","_done"];
		
		_type = waypointType [_group,_wp];
		_pos = waypointPosition [_group,_wp];
		_beh = waypointBehaviour [_group,_wp];
		_com = waypointCombatMode [_group,_wp];
		_cr = waypointCompletionRadius [_group,_wp];
		_from = waypointFormation [_group,_wp];
		_speed = waypointSpeed [_group,_wp];
		_time = waypointTimeout [_group,_wp];
		
		_done = [[_pos,_type,_beh,_com,_cr,_from,_speed,_time]];
		_return = _return + _done;
		
		_wp = _wp + 1;
	};
	
	_return
};
publicvariable "acpl_get_waypoints";

acpl_spawn_newgroup = {
	private ["_side","_inf","_veh","_type","_c_inf","_c_veh","_grp","_s_vehs","_return"];
	
	//v1.1
		
	_side = _this select 0;
	_inf = _this select 1;
	_veh = _this select 2;
	
	_c_inf = count _inf;
	_c_veh = count _veh;
	
	_s_vehs = [];
	
	_grp = createGroup _side;
	_return = _grp;
	
	if (_c_veh > 0) then {
		{
			private ["_v","_class","_spawn_point","_dir"];
			
			_class = _x select 0;
			_spawn_point = _x select 1;
			_dir = _x select 2;
			
			_v = createVehicle [_class, _spawn_point, [], 0];
			_v setdir _dir;
			
			_s_vehs = _s_vehs + [_v];
		} foreach _veh;
	};
	if (_c_inf > 0) then {
		{
			private ["_unit","_class","_spawn_point","_dir","_type","_veh_id","_veh","_eq"];
			
			_class = _x select 0;
			_spawn_point = _x select 1;
			_dir = _x select 2;
			_type = _x select 3;
			_veh_id = _x select 4;
			_eq = _x select 5;
			
			_unit = _grp createUnit [_class, _spawn_point, [], 0, "NONE"];
			_unit setdir _dir;
			[_unit, _eq] call acpl_add_eq;
			if (_veh_id >= 0) then {
				_veh = _s_vehs select _veh_id;
				
				if (count _type > 0) then {
					if (_type select 0 == "driver") then {
						_unit moveInDriver _veh;
					};
					if (_type select 0 == "cargo") then {
						_unit moveInCargo _veh;
					};
					if (_type select 0 == "turret") then {
						_unit moveInTurret [_veh,(_type select 1)];
					};
				};
			};
		} foreach _inf;
	};
	
	_return
};
publicvariable "acpl_spawn_newgroup";

acpl_spawn_addwaypoints = {
	private ["_grp","_waypoints"];

	_grp = _this select 0;
	_waypoints = _this select 1;
	
	//v1.1
	
	{
		private ["_pos","_complete","_type","_formation","_behaviour","_combatmode","_speed","_wp","_time"];
		
		_pos = _x select 0;
		_type = _x select 1;
		_behaviour = _x select 2;
		_combatmode = _x select 3;
		_complete = _x select 4;
		_formation = _x select 5;
		_speed = _x select 6;
		_time = _x select 7;
		
		_wp = _grp addWaypoint [_pos, 0];
		_wp setWaypointCompletionRadius _complete;
		_wp setWaypointType _type;
		_wp setWaypointFormation _formation;
		_wp setWaypointBehaviour _behaviour;
		_wp setWaypointCombatMode _combatmode;
		_wp setWaypointSpeed _speed;
		_wp setWaypointTimeout _time;
	} forEach _waypoints;
};
publicvariable "acpl_spawn_addwaypoints";

acpl_spawning = true;
publicvariable "acpl_spawning";

if (acpl_fnc_debug) then {["ACPL FNCS SPAWNING LOADED"] remoteExec ["systemchat",0];};