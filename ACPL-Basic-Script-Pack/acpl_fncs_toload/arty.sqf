if (!isserver) exitwith {};

acpl_arty_make_correction = {
	private ["_return","_value_x","_value_y","_unit"];
	
	_unit = _this select 0;
	_return = _unit getvariable "acpl_arty_correction";
	_value_x = _this select 1;
	_value_y = _this select 2;
	
	_return = [(_return select 0) + _value_x,(_return select 1) + _value_y];
	
	_return
};
publicvariable "acpl_arty_make_correction";

acpl_arty_addbateries = {
	private ["_unit", "_var", "_batts"];
	
	_unit = _this select 0;
	_var = _unit getvariable "acpl_arty_batteries_added";
	_batts = acpl_arty_bateries;
	
	{
		if (!((_x select 0) in _var)) then {
			private ["_action"];
			
			_action = _x select 1;
			[[(_unit), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_battery"], _action],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
			_unit setvariable ["acpl_arty_batteries_added",(_unit getvariable "acpl_arty_batteries_added") + [(_x select 0)],true];
		};
	} foreach _batts;
};
publicvariable "acpl_arty_make_correction";

acpl_arty_getcursor_pos = {
	private ["_unit"];
	
	_unit = _this select 0;
	while {!(_unit getvariable "acpl_arty_wait") AND !(_unit getvariable "acpl_arty_cancel")} do {
		private ["_pos"];
		
		_pos = (findDisplay 12 displayCtrl 51) ctrlMapScreenToWorld getMousePosition;
		_unit setVariable ["acpl_arty_cursor_pos",_pos,true];
		sleep 0.01;
	};
};
publicvariable "acpl_arty_getcursor_pos";

acpl_arty_check_lastmarkers = {
	params ["_unit", "_battery"];
	private ["_markers"];
	
	_markers = [];
	_markers_u = _unit getvariable "acpl_arty_markers";
	_markers_b = _battery getvariable "acpl_arty_markers";;
	
	if ((count _markers_u) > 0) then {
		{
			if (_x in _markers_u) then {_markers = _markers + [_x];};
		} foreach _markers_b;
	};
	
	_markers
};
publicvariable "acpl_arty_check_lastmarkers";

acpl_arty_takecoordinates = {
	private ["_markers", "_exit", "_unit", "_type", "_color", "_name", "_grid", "_text", "_battery", "_battery_name", "_time", "_date", "_h", "_m", "_m1_pos", "_ammo", "_rnds", "_name2", "_area", "_classname"];
	
	_unit = _this select 0;
	_type = _unit getvariable "acpl_arty_typeoffire";
	
	_exit = false;
	
	_unit setVariable ["acpl_arty_iscalling",true,true];
	_unit setVariable ["acpl_arty_wait",false,true];
	
	if (side _unit == WEST) then {_color = "ColorBlue";};
	if (side _unit == EAST) then {_color = "ColorRed";};
	if (side _unit == RESISTANCE) then {_color = "ColorGreen";};
	
	if ((_unit getvariable "acpl_arty_ammo") == "") exitwith {["Nie wybrano amunicji!"] remoteExec ["hint",_unit];_unit setVariable ["acpl_arty_iscalling",false,true];};
	if (((_unit getvariable "acpl_arty_chosen") getvariable "acpl_arty_battery_busy")) exitwith {["Wybrana bateria jest aktualnie zajêta!"] remoteExec ["hint",_unit];_unit setVariable ["acpl_arty_iscalling",false,true];_exit = true;};
	
	_area = [];
	
	[[true, true]] remoteExec ["openMap",_unit];
	
	if (_type == 0) then {
		_name = ("acpl_arty_marker_id_" + str(acpl_arty_marker_id));
		
		acpl_arty_marker_id = acpl_arty_marker_id + 1;
		publicvariable "acpl_arty_marker_id";
		
		["Zaznacz miejsce które chcesz ostrzelaæ"] remoteExec ["hint",_unit];
		["player setVariable [""acpl_arty_pos"",_pos,true];player setVariable [""acpl_arty_wait"",true,true];"] remoteExec ["onMapSingleClick",_unit];
		
		waitUntil {(_unit getvariable "acpl_arty_wait") OR (_unit getvariable "acpl_arty_cancel")};
		_unit setVariable ["acpl_arty_wait",false,true];
		
		if (_unit getvariable "acpl_arty_cancel") exitwith {
			_unit setVariable ["acpl_arty_cancel",false,true];
			[""] remoteExec ["onMapSingleClick",_unit];
			["Anulowano wzywanie ostrza³u"] remoteExec ["hint",_unit];
			[[true, false]] remoteExec ["openMap",_unit];
			_exit = true;
		};
		
		_m1_pos = (_unit getvariable "acpl_arty_pos");
		
		if ((_unit getvariable "acpl_arty_ammo") == "") exitwith {["Nie wybrano amunicji!"] remoteExec ["hint",_unit];_unit setVariable ["acpl_arty_iscalling",false,true];};
		
		["Zaznaczono pozycje"] remoteExec ["hint",_unit];
		[""] remoteExec ["onMapSingleClick",_unit];
		_grid = mapGridPosition (_unit getVariable "acpl_arty_pos");
		
		_battery = _unit getvariable "acpl_arty_chosen";
		_battery_name = _battery getvariable "acpl_arty_battery_name";
		
		_rnds = _unit getvariable "acpl_arty_rounds";
		_ammo = _unit getvariable "acpl_arty_ammo";
		
		_date = date;
		_h = _date select 3;
		_m = _date select 4;
		_time = (str(_h) + ":" + str(_m));
		
		_text = (_grid + ", " + _time + ", " + _battery_name + ", ostrza³ punktowy, iloœæ pocisków: " + str(_rnds) + ", rodzaj pocisków: " + toUpper(_ammo));
		
		_markers = [_unit, _battery] call acpl_arty_check_lastmarkers;
	};
	if (_type == 1) then {
		_name = ("acpl_arty_marker_id_" + str(acpl_arty_marker_id));
		
		acpl_arty_marker_id = acpl_arty_marker_id + 1;
		publicvariable "acpl_arty_marker_id";
		
		_name2 = ("acpl_arty_marker_id_" + str(acpl_arty_marker_id));
		
		acpl_arty_marker_id = acpl_arty_marker_id + 1;
		publicvariable "acpl_arty_marker_id";
		
		["Zaznacz miejsce w którym ma rozpoczynaæ siê linia ostrza³u"] remoteExec ["hint",_unit];
		["player setVariable [""acpl_arty_pos"",_pos,true];player setVariable [""acpl_arty_wait"",true,true];"] remoteExec ["onMapSingleClick",_unit];
		
		waitUntil {(_unit getvariable "acpl_arty_wait") OR (_unit getvariable "acpl_arty_cancel")};
		_unit setVariable ["acpl_arty_wait",false,true];
		
		if (_unit getvariable "acpl_arty_cancel") exitwith {
			_unit setVariable ["acpl_arty_cancel",false,true];
			[""] remoteExec ["onMapSingleClick",_unit];
			["Anulowano wzywanie ostrza³u"] remoteExec ["hint",_unit];
			[[true, false]] remoteExec ["openMap",_unit];
			_exit = true;
		};
		
		_m1_pos = (_unit getvariable "acpl_arty_pos");
		
		if (_unit getvariable "acpl_arty_rounds" < 2) exitwith {
			["Wybrano zbyt ma³o pocisków"] remoteExec ["hint",_unit];
		};
		
		[[_unit],acpl_arty_getcursor_pos] remoteExec ["spawn",_unit];
		
		[_name2, _unit, _m1_pos] spawn {
			private ["_name2", "_unit", "_pos1", "_battery"];
			
			_name2 = _this select 0;
			_unit = _this select 1;
			_pos1 = _this select 2;
			_battery = _unit getvariable "acpl_arty_chosen";
			
			[[_name2, _pos1]] remoteExec ["createMarkerLocal",_unit, true];
			[_name2, "RECTANGLE"] remoteExec ["setMarkerShapeLocal",_unit, true];
			[_name2, "ColorYellow"] remoteExec ["setMarkerColorLocal",_unit, true];
			[_name2, "SolidFull"] remoteExec ["setMarkerBrushLocal",_unit, true];
			
			while {!(_unit getvariable "acpl_arty_wait") AND !(_unit getvariable "acpl_arty_cancel")} do {
				private ["_pos2", "_center", "_angle", "_distance"];
				
				_pos2 = _unit getvariable "acpl_arty_cursor_pos";
				_center = [((_pos1 select 0)-(((_pos1 select 0)-(_pos2 select 0))/2)),((_pos1 select 1)-(((_pos1 select 1)-(_pos2 select 1))/2))];
				_angle = ((_pos2 select 0)-(_pos1 select 0)) atan2 ((_pos2 select 1)-(_pos1 select 1));
				_distance = (_pos1 distance _pos2)/2;
				
				[_name2, _center] remoteExec ["setMarkerPosLocal",_unit, true];
				[_name2, _angle] remoteExec ["setMarkerDirLocal",_unit, true];
				[_name2, [2,_distance]] remoteExec ["setMarkerSizeLocal",_unit, true];
				
				sleep 0.01;
				
				_battery setvariable ["acpl_arty_area",[_center, _pos1, _pos2],true];
			};
			
			if (_unit getvariable "acpl_arty_cancel") exitwith {
				deleteMarkerLocal _name2;
			};
			
			_unit setVariable ["acpl_arty_wait",false,true];
		};
		
		["Zaznaczono pocz¹tek lini, zaznacz gdzie ma koñczyæ siê linia ostrza³u"] remoteExec ["hint",_unit];
		waitUntil {(_unit getvariable "acpl_arty_wait") OR (_unit getvariable "acpl_arty_cancel")};
		
		if (_unit getvariable "acpl_arty_cancel") exitwith {
			_unit setVariable ["acpl_arty_cancel",false,true];
			[""] remoteExec ["onMapSingleClick",_unit];
			["Anulowano wzywanie ostrza³u"] remoteExec ["hint",_unit];
			[[true, false]] remoteExec ["openMap",_unit];
			_exit = true;
		};
		
		["Zaznaczono koniec lini"] remoteExec ["hint",_unit];
		
		_grid = mapGridPosition _m1_pos;
		
		_battery = _unit getvariable "acpl_arty_chosen";
		_battery_name = _battery getvariable "acpl_arty_battery_name";
		
		_rnds = _unit getvariable "acpl_arty_rounds";
		_ammo = _unit getvariable "acpl_arty_ammo";
		
		_date = date;
		_h = _date select 3;
		_m = _date select 4;
		_time = (str(_h) + ":" + str(_m));
		
		_text = (_grid + ", " + _time + ", " + _battery_name + ", ostrza³ liniowy, iloœæ pocisków: " + str(_rnds) + ", rodzaj pocisków: " + toUpper(_ammo));
		
		[""] remoteExec ["onMapSingleClick",_unit];
		
		_markers = [_unit, _battery] call acpl_arty_check_lastmarkers;
		
		_unit setVariable ["acpl_arty_markers",(_unit getvariable "acpl_arty_markers") + [_name2],true];
		_battery setVariable ["acpl_arty_markers",(_battery getvariable "acpl_arty_markers") + [_name2],true];
	};
	if (_type == 2) then {
		_name = ("acpl_arty_marker_id_" + str(acpl_arty_marker_id));
		
		acpl_arty_marker_id = acpl_arty_marker_id + 1;
		publicvariable "acpl_arty_marker_id";
		
		_name2 = ("acpl_arty_marker_id_" + str(acpl_arty_marker_id));
		
		acpl_arty_marker_id = acpl_arty_marker_id + 1;
		publicvariable "acpl_arty_marker_id";
		
		["Zaznacz œrodek strefy ostrza³u"] remoteExec ["hint",_unit];
		["player setVariable [""acpl_arty_pos"",_pos,true];player setVariable [""acpl_arty_wait"",true,true];"] remoteExec ["onMapSingleClick",_unit];
		
		waitUntil {(_unit getvariable "acpl_arty_wait") OR (_unit getvariable "acpl_arty_cancel")};
		_unit setVariable ["acpl_arty_wait",false,true];
		
		if (_unit getvariable "acpl_arty_cancel") exitwith {
			_unit setVariable ["acpl_arty_cancel",false,true];
			[""] remoteExec ["onMapSingleClick",_unit];
			["Anulowano wzywanie ostrza³u"] remoteExec ["hint",_unit];
			[[true, false]] remoteExec ["openMap",_unit];
			_exit = true;
		};
		
		_ammo = _unit getvariable "acpl_arty_ammo";
		
		_m1_pos = (_unit getvariable "acpl_arty_pos");
		
		if (_unit getvariable "acpl_arty_rounds" < 2) exitwith {
			["Wybrano zbyt ma³o pocisków"] remoteExec ["hint",_unit];
		};
		
		[[_unit],acpl_arty_getcursor_pos] remoteExec ["spawn",_unit];
		
		_m1_pos = (_unit getvariable "acpl_arty_pos");
		
		[_name2, _unit, _m1_pos] spawn {
			private ["_name2", "_unit", "_pos1", "_battery", "_distance_y", "_distance_x", "_angle"];
			
			_name2 = _this select 0;
			_unit = _this select 1;
			_pos1 = _this select 2;
			_battery = _unit getvariable "acpl_arty_chosen";
			
			_distance_y = 0;
			
			[[_name2, _pos1]] remoteExec ["createMarkerLocal",_unit, true];
			[_name2, "ELLIPSE"] remoteExec ["setMarkerShapeLocal",_unit, true];
			[_name2, "ColorYellow"] remoteExec ["setMarkerColorLocal",_unit, true];
			[_name2, "Grid"] remoteExec ["setMarkerBrushLocal",_unit, true];
			
			while {!(_unit getvariable "acpl_arty_wait") AND !(_unit getvariable "acpl_arty_cancel")} do {
				private ["_pos2", "_distance"];
				
				_pos2 = _unit getvariable "acpl_arty_cursor_pos";
				_angle = ((_pos2 select 0)-(_pos1 select 0)) atan2 ((_pos2 select 1)-(_pos1 select 1));
				_distance = (_pos1 distance _pos2);
				
				[_name2, _angle] remoteExec ["setMarkerDirLocal",_unit, true];
				[_name2, [2,_distance]] remoteExec ["setMarkerSizeLocal",_unit, true];
				
				_distance_y = _distance;
				
				sleep 0.01;
			};
			
			if (_unit getvariable "acpl_arty_cancel") exitwith {
				deleteMarkerLocal _name2;
			};
			
			_unit setVariable ["acpl_arty_wait",false,true];
			[[_unit],acpl_arty_getcursor_pos] remoteExec ["spawn",_unit];
			
			while {!(_unit getvariable "acpl_arty_wait") AND !(_unit getvariable "acpl_arty_cancel")} do {
				private ["_pos2", "_distance"];
				
				_pos2 = _unit getvariable "acpl_arty_cursor_pos";
				_distance = (_pos1 distance _pos2);
				_distance_x = _distance;
				
				[_name2, [_distance,_distance_y]] remoteExec ["setMarkerSizeLocal",_unit, true];
				
				sleep 0.01;
			};
			
			_battery setvariable ["acpl_arty_area",[_pos1, _distance_x, _distance_y, _angle],true];
			
			if (_unit getvariable "acpl_arty_cancel") exitwith {
				deleteMarkerLocal _name2;
			};
			
			_unit setVariable ["acpl_arty_wait",false,true];
		};
		
		["Zaznaczono œrodek strefy, zaznacz jej d³ugoœæ"] remoteExec ["hint",_unit];
		waitUntil {(_unit getvariable "acpl_arty_wait") OR (_unit getvariable "acpl_arty_cancel")};
		
		if (_unit getvariable "acpl_arty_cancel") exitwith {
			_unit setVariable ["acpl_arty_cancel",false,true];
			[""] remoteExec ["onMapSingleClick",_unit];
			["Anulowano wzywanie ostrza³u"] remoteExec ["hint",_unit];
			[[true, false]] remoteExec ["openMap",_unit];
			_exit = true;
		};
		
		sleep 0.1;
		
		["Zaznaczono d³ugoœæ strefy, zaznacz jej szerokoœæ"] remoteExec ["hint",_unit];
		
		waitUntil {(_unit getvariable "acpl_arty_wait") OR (_unit getvariable "acpl_arty_cancel")};
		
		if (_unit getvariable "acpl_arty_cancel") exitwith {
			_unit setVariable ["acpl_arty_cancel",false,true];
			[""] remoteExec ["onMapSingleClick",_unit];
			["Anulowano wzywanie ostrza³u"] remoteExec ["hint",_unit];
			[[true, false]] remoteExec ["openMap",_unit];
			_exit = true;
		};
		
		["Zaznaczono szerokoœæ strefy"] remoteExec ["hint",_unit];
		
		_grid = mapGridPosition _m1_pos;
		
		_battery = _unit getvariable "acpl_arty_chosen";
		_battery_name = _battery getvariable "acpl_arty_battery_name";
		
		_rnds = _unit getvariable "acpl_arty_rounds";
		_ammo = _unit getvariable "acpl_arty_ammo";
		
		_date = date;
		_h = _date select 3;
		_m = _date select 4;
		_time = (str(_h) + ":" + str(_m));
		
		_text = (_grid + ", " + _time + ", " + _battery_name + ", ostrza³ obszarowy, iloœæ pocisków: " + str(_rnds) + ", rodzaj pocisków: " + toUpper(_ammo));
		
		[""] remoteExec ["onMapSingleClick",_unit];
		
		_markers = [_unit, _battery] call acpl_arty_check_lastmarkers;
		
		_unit setVariable ["acpl_arty_markers",(_unit getvariable "acpl_arty_markers") + [_name2],true];
		_battery setVariable ["acpl_arty_markers",(_battery getvariable "acpl_arty_markers") + [_name2],true];
	};
	
	[[true, false]] remoteExec ["openMap",_unit];
	_unit setVariable ["acpl_arty_iscalling",false,true];
	
	if (((_unit getvariable "acpl_arty_chosen") getvariable "acpl_arty_battery_busy")) exitwith {["Wybrana bateria jest aktualnie zajêta!"] remoteExec ["hint",_unit];_unit setVariable ["acpl_arty_iscalling",false,true];_exit = true;};
	
	if (_exit) exitwith {
		_unit setVariable ["acpl_arty_cancel",false,true];
		[[true, false]] remoteExec ["openMap",_unit];
	};
	
	if (_ammo == "he") then {
		if (_rnds > (_battery getvariable "acpl_arty_he_rounds")) exitwith {
			["Bateria nie ma wystarczaj¹cej iloœci pocisków!"] remoteExec ["hint",_unit];
			_unit setVariable ["acpl_arty_iscalling",false,true];
			_exit = true;
		};
		_classname = _battery getvariable "acpl_arty_he_class";
		_battery setvariable ["acpl_arty_he_rounds",(_battery getvariable "acpl_arty_he_rounds") - _rnds,true];
	};
	if (_ammo == "smoke") then {
		if (_rnds > (_battery getvariable "acpl_arty_smoke_rounds")) exitwith {
			["Bateria nie ma wystarczaj¹cej iloœci pocisków!"] remoteExec ["hint",_unit];
			_unit setVariable ["acpl_arty_iscalling",false,true];
			_exit = true;
		};
		_classname = _battery getvariable "acpl_arty_smoke_class";
		_battery setvariable ["acpl_arty_smoke_rounds",(_battery getvariable "acpl_arty_smoke_rounds") - _rnds,true];
	};
	if (_ammo == "lg") then {
		if (_rnds > (_battery getvariable "acpl_arty_lg_rounds")) exitwith {
			["Bateria nie ma wystarczaj¹cej iloœci pocisków!"] remoteExec ["hint",_unit];
			_unit setVariable ["acpl_arty_iscalling",false,true];
			_exit = true;
		};
		_classname = _battery getvariable "acpl_arty_lg_class";
		_battery setvariable ["acpl_arty_lg_class",(_battery getvariable "acpl_arty_lg_class") - _rnds,true];
	};
	if (_ammo == "flare") then {
		if (_rnds > (_battery getvariable "acpl_arty_flare_rounds")) exitwith {
			["Bateria nie ma wystarczaj¹cej iloœci pocisków!"] remoteExec ["hint",_unit];
			_unit setVariable ["acpl_arty_iscalling",false,true];
			_exit = true;
		};
		_classname = _battery getvariable "acpl_arty_flare_class";
		_battery setvariable ["acpl_arty_flare_rounds",(_battery getvariable "acpl_arty_flare_rounds") - _rnds,true];
	};
	if (_ammo == "cluster") then {
		if (_rnds > (_battery getvariable "acpl_arty_cluster_rounds")) exitwith {
			["Bateria nie ma wystarczaj¹cej iloœci pocisków!"] remoteExec ["hint",_unit];
			_unit setVariable ["acpl_arty_iscalling",false,true];
			_exit = true;
		};
		_classname = _battery getvariable "acpl_arty_cluster_class";
		_battery setvariable ["acpl_arty_cluster_rounds",(_battery getvariable "acpl_arty_cluster_rounds") - _rnds,true];
	};
	if (_ammo == "mine") then {
		if (_rnds > (_battery getvariable "acpl_arty_mine_rounds")) exitwith {
			["Bateria nie ma wystarczaj¹cej iloœci pocisków!"] remoteExec ["hint",_unit];
			_unit setVariable ["acpl_arty_iscalling",false,true];
			_exit = true;
		};
		_classname = _battery getvariable "acpl_arty_mine_class";
		_battery setvariable ["acpl_arty_mine_rounds",(_battery getvariable "acpl_arty_mine_rounds") - _rnds,true];
	};
	if (_ammo == "atmine") then {
		if (_rnds > (_battery getvariable "acpl_arty_atmine_rounds")) exitwith {
			["Bateria nie ma wystarczaj¹cej iloœci pocisków!"] remoteExec ["hint",_unit];
			_unit setVariable ["acpl_arty_iscalling",false,true];
			_exit = true;
		};
		_classname = _battery getvariable "acpl_arty_atmine_class";
		_battery setvariable ["acpl_arty_atmine_rounds",(_battery getvariable "acpl_arty_atmine_rounds") - _rnds,true];
	};
	if (_ammo == "guided") then {
		if (_rnds > (_battery getvariable "acpl_arty_guided_rounds")) exitwith {
			["Bateria nie ma wystarczaj¹cej iloœci pocisków!"] remoteExec ["hint",_unit];
			_unit setVariable ["acpl_arty_iscalling",false,true];
			_exit = true;
		};
		_classname = _battery getvariable "acpl_arty_guided_class";
		_battery setvariable ["acpl_arty_guided_rounds",(_battery getvariable "acpl_arty_guided_rounds") - _rnds,true];
	};
		
	if (!(_m1_pos inRangeOfArtillery [[_battery], _classname])) exitwith {["Wyznaczona pozycja znajduje siê poza zasiêgiem artylerii!"] remoteExec ["hint",_unit];_unit setVariable ["acpl_arty_iscalling",false,true];_exit = true;};
	
	if (_exit) exitwith {
		_unit setVariable ["acpl_arty_cancel",false,true];
		[[true, false]] remoteExec ["openMap",_unit];
	};
	
	[[_name, _m1_pos]] remoteExec ["createMarkerLocal",_unit, true];
	[_name, "ICON"] remoteExec ["setMarkerShapeLocal",_unit, true];
	[_name, _color] remoteExec ["setMarkerColorLocal",_unit, true];
	[_name, "mil_destroy"] remoteExec ["setMarkerTypeLocal",_unit, true];
	[_name, _text] remoteExec ["setMarkerTextLocal",_unit, true];
	
	_unit setVariable ["acpl_arty_markers",(_unit getvariable "acpl_arty_markers") + [_name],true];
	_battery setVariable ["acpl_arty_markers",(_battery getvariable "acpl_arty_markers") + [_name],true];
	
	sleep 0.02;
	
	if (_type == 0) then {
		[_unit, _battery, false, _m1_pos, 0, [_rnds, _ammo]] spawn acpl_arty_openfire;
	};
	if (_type == 1) then {
		_area = _battery getvariable "acpl_arty_area";
		[_unit, _battery, true, _area, 1, [_rnds, _ammo]] spawn acpl_arty_openfire;
	};
	if (_type == 2) then {
		_area = _battery getvariable "acpl_arty_area";
		[_unit, _battery, true, _area, 2, [_rnds, _ammo]] spawn acpl_arty_openfire;
	};
	
	if ((count _markers) > 0) then {
		{
			[_x] remoteExec ["deleteMarkerLocal",_unit, true];
			_unit setVariable ["acpl_arty_markers",(_unit getvariable "acpl_arty_markers") - [_x],true];
			_battery setVariable ["acpl_arty_markers",(_battery getvariable "acpl_arty_markers") - [_x],true];
		} foreach _markers;
	};
	
	_unit setVariable ["acpl_arty_cancel",false,true];
};
publicvariable "acpl_arty_takecoordinates";

acpl_arty_sendinfo = {
	params ["_unit", "_battery", "_type", "_ammo", "_rnds", "_pos", ["_cor", false], ["_cor_pos", [0,0]]];
	private ["_name", "_name_unit", "_grid", "_tof", "_return", "_eta", "_dis", "_classname"];
	
	_name = _battery getvariable "acpl_arty_battery_name";
	_name_unit = groupId (group _unit);
	
	if (_ammo == "he") then {_classname = _battery getvariable "acpl_arty_he_class";};
	if (_ammo == "smoke") then {_classname = _battery getvariable "acpl_arty_smoke_class";};
	if (_ammo == "lg") then {_classname = _battery getvariable "acpl_arty_lg_class";};
	if (_ammo == "flare") then {_classname = _battery getvariable "acpl_arty_flare_class";};
	if (_ammo == "cluster") then {_classname = _battery getvariable "acpl_arty_cluster_class";};
	if (_ammo == "mine") then {_classname = _battery getvariable "acpl_arty_mine_class";};
	if (_ammo == "atmine") then {_classname = _battery getvariable "acpl_arty_atmine_class";};
	if (_ammo == "guided") then {_classname = _battery getvariable "acpl_arty_guided_class";};
	
	if (_type == 0) then {
		_grid = mapGridPosition _pos;
		_tof = "punktowy";
		
		_eta = _battery getArtilleryETA [_pos, _classname];
		
		_return = ("Ostrza³ " + _tof + ", pozycja " + _grid + ", pociski typu " + toUpper(_ammo) + ", iloœæ pocisków: " + str(_rnds));
	};
	if (_type == 1) then {
		_grid = mapGridPosition (_pos select 1);
		_grid2 = mapGridPosition (_pos select 2);
		_tof = "liniowy";
		
		_eta = _battery getArtilleryETA [(_pos select 0), _classname];
		
		_return = ("Ostrza³ " + _tof + ", od pozycji " + _grid + ", do pozycji " + _grid2 + ", pociski typu " + toUpper(_ammo) + ", iloœæ pocisków: " + str(_rnds));
	};
	if (_type == 2) then {
		_grid = mapGridPosition (_pos select 0);
		_dis = (((_pos select 1) toFixed 0) + "m d³ugoœci i " + ((_pos select 2) toFixed 0) + "m szerokoœci");
		_tof = "obszarowy";
		
		_eta = _battery getArtilleryETA [(_pos select 0), _classname];
		
		_return = ("Ostrza³ " + _tof + ", pozycja " + _grid + ", rozrzut " + _dis + ", pociski typu " + toUpper(_ammo) + ", iloœæ pocisków: " + str(_rnds));
	};
	
	if (_cor) then {
		private ["_pos_x", "_pos_y", "_info_x", "_info_y", "_info"];
		
		_pos_x = _cor_pos select 0;
		_pos_y = _cor_pos select 1;
		
		if (_pos_x < 0) then {_info_x = (str(-_pos_x) + "m W");} else {_info_x = (str(_pos_x) + "m E");};
		if (_pos_y < 0) then {_info_y = (str(-_pos_y) + "m S");} else {_info_y = (str(_pos_y) + "m N");};
		
		_info = (_info_x + ", " + _info_y);
		
		_return = (_return + ", poprawka: " + _info);
	};
	
	[_unit, toUpper(_name) + ", tutaj " + toUpper(_name_unit) + ", zg³oœ, odbiór."] remoteExec ["sidechat",_unit];
	sleep 3;
	[_battery, toUpper(_name_unit) + ", tutaj " + toUpper(_name) + ", zg³aszam, odbiór."] remoteExec ["sidechat",_unit];
	sleep 3;
	[_unit, toUpper(_name) + " potrzebuje wsparcia ogniowego, przygotuj siê do odebrania informacji, odbiór."] remoteExec ["sidechat",_unit];
	sleep 5;
	[_battery, "Tutaj " + toUpper(_name) + ", gotów, odbiór."] remoteExec ["sidechat",_unit];
	sleep 3;
	[_unit, _return + ". Jak przyj¹³? Odbiór."] remoteExec ["sidechat",_unit];
	sleep 8;
	[_battery, "Tutaj " + toUpper(_name) + ", przyj¹³em, wykonuje. ETA " + (_eta toFixed 0) + "s, odbiór."] remoteExec ["sidechat",_unit];
	_battery setvariable ["acpl_arty_wait", false, true];
	sleep 4;
	[_unit, "Tutaj " + toUpper(_name_unit) + ", przyj¹³em, odbiór."] remoteExec ["sidechat",_unit];
	
	sleep (_eta - 4);
	[_battery, "Splash."] remoteExec ["sidechat",_unit];
};
publicvariable "acpl_arty_sendinfo";

acpl_arty_sendammo = {
	params ["_unit"];
	private ["_battery", "_name", "_name_unit"];
	
	_battery = _unit getvariable "acpl_arty_chosen";
	_name = _battery getvariable "acpl_arty_battery_name";
	_name_unit = groupId (group _unit);
	
	[_unit, toUpper(_name) + ", tutaj " + toUpper(_name_unit) + ", zg³oœ, odbiór."] remoteExec ["sidechat",_unit];
	sleep 3;
	[_battery, toUpper(_name_unit) + ", tutaj " + toUpper(_name) + ", zg³aszam, odbiór."] remoteExec ["sidechat",_unit];
	sleep 3;
	[_unit, toUpper(_name) + " podaj swój stan amunicji, odbiór."] remoteExec ["sidechat",_unit];
	sleep 5;
	[_battery, toUpper(_name_unit) + " oczekuj."] remoteExec ["sidechat",_unit];
	sleep 3;
	
	if (_battery getVariable "acpl_arty_he") then {
		private ["_rnds"];
		
		_rnds = _battery getVariable "acpl_arty_he_rounds";
		[_battery, "Iloœæ pocisków typu HE: " + str(_rnds)] remoteExec ["sidechat",_unit];
		sleep 3;
	};
	if (_battery getVariable "acpl_arty_smoke") then {
		private ["_rnds"];
		
		_rnds = _battery getVariable "acpl_arty_smoke_rounds";
		[_battery, "Iloœæ pocisków typu SMOKE: " + str(_rnds)] remoteExec ["sidechat",_unit];
		sleep 3;
	};
	if (_battery getVariable "acpl_arty_flare") then {
		private ["_rnds"];
		
		_rnds = _battery getVariable "acpl_arty_flare_rounds";
		[_battery, "Iloœæ pocisków typu FLARE: " + str(_rnds)] remoteExec ["sidechat",_unit];
		sleep 3;
	};
	if (_battery getVariable "acpl_arty_lg") then {
		private ["_rnds"];
		
		_rnds = _battery getVariable "acpl_arty_LG_rounds";
		[_battery, "Iloœæ pocisków typu LASER GUIDED: " + str(_rnds)] remoteExec ["sidechat",_unit];
		sleep 3;
	};
	if (_battery getVariable "acpl_arty_mine") then {
		private ["_rnds"];
		
		_rnds = _battery getVariable "acpl_arty_mine_rounds";
		[_battery, "Iloœæ pocisków typu MINE: " + str(_rnds)] remoteExec ["sidechat",_unit];
		sleep 3;
	};
	if (_battery getVariable "acpl_arty_atmine") then {
		private ["_rnds"];
		
		_rnds = _battery getVariable "acpl_arty_atmine_rounds";
		[_battery, "Iloœæ pocisków typu AT MINE: " + str(_rnds)] remoteExec ["sidechat",_unit];
		sleep 3;
	};
	if (_battery getVariable "acpl_arty_cluster") then {
		private ["_rnds"];
		
		_rnds = _battery getVariable "acpl_arty_cluster_rounds";
		[_battery, "Iloœæ pocisków typu CLUSTER: " + str(_rnds)] remoteExec ["sidechat",_unit];
		sleep 3;
	};
	if (_battery getVariable "acpl_arty_guided") then {
		private ["_rnds"];
		
		_rnds = _battery getVariable "acpl_arty_guided_rounds";
		[_battery, "Iloœæ pocisków typu GUIDED: " + str(_rnds)] remoteExec ["sidechat",_unit];
		sleep 3;
	};
	
	[_battery, "Tutaj " + toUpper(_name) + ", to wszystko co posiadamy, " + toUpper(_name_unit) + " jak przyja³? Odbiór."] remoteExec ["sidechat",_unit];
	sleep 3;
	[_unit, "Tutaj " + toUpper(_name_unit) + ", przyj¹³em, bez odbioru."] remoteExec ["sidechat",_unit];
};
publicvariable "acpl_arty_sendammo";

acpl_arty_call_corrected = {
	params ["_unit"];
	private ["_cor", "_lastfire", "_battery", "_lf1", "_lf2", "_rnds", "_ammo", "_exit"];
	
	_battery = _unit getvariable "acpl_arty_chosen";
	_cor = _unit getVariable "acpl_arty_correction";
	_lastfire = [_unit] call acpl_arty_find_lastfire;
	_lf1 = _lastfire select 1;
	_lf2 = _lastfire select 2;
	_rnds = _unit getvariable "acpl_arty_rounds";
	_ammo = _unit getvariable "acpl_arty_ammo";
	
	_exit = false;
	
	if (_battery getVariable "acpl_arty_he") then {
		if (_rnds > (_battery getvariable "acpl_arty_he_rounds")) exitwith {
			["Bateria nie ma wystarczaj¹cej iloœci pocisków!"] remoteExec ["hint",_unit];
			_exit = true;
		};
		_battery setvariable ["acpl_arty_he_rounds",(_battery getvariable "acpl_arty_guided_rounds") - _rnds,true];
	};
	if (_battery getVariable "acpl_arty_smoke") then {
		if (_rnds > (_battery getvariable "acpl_arty_smoke_rounds")) exitwith {
			["Bateria nie ma wystarczaj¹cej iloœci pocisków!"] remoteExec ["hint",_unit];
			_exit = true;
		};
		_battery setvariable ["acpl_arty_smoke_rounds",(_battery getvariable "acpl_arty_guided_rounds") - _rnds,true];
	};
	if (_battery getVariable "acpl_arty_flare") then {
		if (_rnds > (_battery getvariable "acpl_arty_flare_rounds")) exitwith {
			["Bateria nie ma wystarczaj¹cej iloœci pocisków!"] remoteExec ["hint",_unit];
			_exit = true;
		};
		_battery setvariable ["acpl_arty_flare_rounds",(_battery getvariable "acpl_arty_guided_rounds") - _rnds,true];
	};
	if (_battery getVariable "acpl_arty_lg") then {
		if (_rnds > (_battery getvariable "acpl_arty_lg_rounds")) exitwith {
			["Bateria nie ma wystarczaj¹cej iloœci pocisków!"] remoteExec ["hint",_unit];
			_exit = true;
		};
		_battery setvariable ["acpl_arty_lg_rounds",(_battery getvariable "acpl_arty_guided_rounds") - _rnds,true];
	};
	if (_battery getVariable "acpl_arty_mine") then {
		if (_rnds > (_battery getvariable "acpl_arty_mine_rounds")) exitwith {
			["Bateria nie ma wystarczaj¹cej iloœci pocisków!"] remoteExec ["hint",_unit];
			_exit = true;
		};
		_battery setvariable ["acpl_arty_mine_rounds",(_battery getvariable "acpl_arty_guided_rounds") - _rnds,true];
	};
	if (_battery getVariable "acpl_arty_atmine") then {
		if (_rnds > (_battery getvariable "acpl_arty_atmine_rounds")) exitwith {
			["Bateria nie ma wystarczaj¹cej iloœci pocisków!"] remoteExec ["hint",_unit];
			_exit = true;
		};
		_battery setvariable ["acpl_arty_atmine_rounds",(_battery getvariable "acpl_arty_guided_rounds") - _rnds,true];
	};
	if (_battery getVariable "acpl_arty_cluster") then {
		if (_rnds > (_battery getvariable "acpl_arty_cluster_rounds")) exitwith {
			["Bateria nie ma wystarczaj¹cej iloœci pocisków!"] remoteExec ["hint",_unit];
			_exit = true;
		};
		_battery setvariable ["acpl_arty_cluster_rounds",(_battery getvariable "acpl_arty_guided_rounds") - _rnds,true];
	};
	if (_battery getVariable "acpl_arty_guided") then {
		if (_rnds > (_battery getvariable "acpl_arty_guided_rounds")) exitwith {
			["Bateria nie ma wystarczaj¹cej iloœci pocisków!"] remoteExec ["hint",_unit];
			_exit = true;
		};
		_battery setvariable ["acpl_arty_guided_rounds",(_battery getvariable "acpl_arty_guided_rounds") - _rnds,true];
	};
	
	if (_exit) exitwith {};
	
	[[_unit, _battery, (_lastfire select 1), _lf2, _lf1, [_rnds, _ammo], true, _cor],acpl_arty_openfire] remoteExec ["spawn",2];
	["Wezwano ostrza³ na ostatni¹ pozycje z podan¹ poprawk¹"] remoteExec ["hint",_unit];
};
publicvariable "acpl_arty_call_corrected";

acpl_arty_check_lastfire = {
	private ["_return", "_unit", "_battery", "_list"];
	
	_return = false;
	
	_unit = _this select 0;
	_battery = _unit getvariable "acpl_arty_chosen";
	_list = _unit getvariable "acpl_arty_lastfire";
	
	if (_battery == objnull) exitwith {false};
	{
		if (_x select 0 == _battery) then {_return = true;};
	} foreach _list;
	
	_return
};
publicvariable "acpl_arty_check_lastfire";

acpl_arty_find_lastfire = {
	private ["_return", "_unit", "_battery", "_list"];
	
	_return = [];
	
	_unit = _this select 0;
	_battery = _unit getvariable "acpl_arty_chosen";
	_list = _unit getvariable "acpl_arty_lastfire";
	
	if (_battery == objnull) exitwith {};
	{
		if (_x select 0 == _battery) then {_return = _x;};
	} foreach _list;
	
	_return
};
publicvariable "acpl_arty_find_lastfire";

acpl_arty_count_gunnermistake = {
	params ["_battery", "_pos"];
	private ["_maxdir", "_maxangle", "_skill", "_return", "_artypos", "_angle", "_c_dir", "_c_dis", "_distance", "_dir", "_vd", "_veh", "_dis"];
	
	_return = [0,0];
	
	_dis = _battery distance _pos;
	
	_maxdir = acpl_arty_maxmistake_dir;
	_maxangle = (acpl_arty_maxmistake_angle * (_dis / 1000));
	_skill = (gunner _battery) skill "aimingAccuracy";
	_artypos = getPos _battery;
	_vd = [(_pos select 0),(_pos select 1),0] vectorDiff _artypos;
	_angle = (_vd select 0) atan2 (_vd select 1);
	if (_angle < 0) then {_angle = 360 + _angle};
	
	_maxdir = _maxdir - (_maxdir * _skill);
	_maxangle = _maxangle - (_maxangle * _skill);
	
	_c_dir = random [-_maxdir,0,_maxdir];
	_c_dis = random [-_maxangle,0,_maxangle];
	_dir = _angle + _c_dir;
	_distance = (_battery distance _pos) + _c_dis;
	
	_veh = "Land_HelipadEmpty_F" createVehicle (getPos _battery);
	_veh setPosASL (getposASL _battery);
	_veh setdir 0;
	
	_return = _veh getRelPos [_distance, _dir];
	
	deletevehicle _veh;
	
	_return
};
publicvariable "acpl_arty_count_gunnermistake";

acpl_arty_openfire = {
	params ["_caller", "_unit", "_inarea", "_position", "_type", "_info", ["_mc", false], ["_correction", [0,0]]];
	private ["_lastfire", "_thisfire", "_rnds", "_ammo", "_modified", "_classname", "_cor_x", "_cor_y", "_markers"];
	
	_rnds = _info select 0;
	_ammo = _info select 1;
	
	_unit setVariable ["acpl_arty_battery_busy",true,true];
	_unit setvariable ["acpl_arty_wait",true,true];
	
	[_caller, _unit, _type, _ammo, _rnds, _position, _mc, _correction] spawn acpl_arty_sendinfo;
	
	if (_ammo == "he") then {_classname = _unit getvariable "acpl_arty_he_class";};
	if (_ammo == "smoke") then {_classname = _unit getvariable "acpl_arty_smoke_class";};
	if (_ammo == "lg") then {_classname = _unit getvariable "acpl_arty_lg_class";};
	if (_ammo == "flare") then {_classname = _unit getvariable "acpl_arty_flare_class";};
	if (_ammo == "cluster") then {_classname = _unit getvariable "acpl_arty_cluster_class";};
	if (_ammo == "mine") then {_classname = _unit getvariable "acpl_arty_mine_class";};
	if (_ammo == "atmine") then {_classname = _unit getvariable "acpl_arty_atmine_class";};
	if (_ammo == "guided") then {_classname = _unit getvariable "acpl_arty_guided_class";};
	
	waitUntil {!(_unit getvariable "acpl_arty_wait")};
	
	if (_mc) then {
		_cor_x = _correction select 0;
		_cor_y = _correction select 1;
		
		_markers = [_caller, _unit] call acpl_arty_check_lastmarkers;
		
		if (_type > 0) then {_inarea = true;} else {_inarea = false;};
		
		if (_inarea) then {
			private ["_pos"];
			_pos = _position select 0;
			
			_modified = [(_pos select 0) + _cor_x,(_pos select 1) + _cor_y,(_pos select 2)];
			
			{
				[_x, _pos] remoteExec ["setMarkerPosLocal",_caller, true];
			} foreach _markers;
		} else {
			_modified = [(_position select 0) + _cor_x,(_position select 1) + _cor_y,(_position select 2)];
			
			{
				[_x, _position] remoteExec ["setMarkerPosLocal", _caller, true];
			} foreach _markers;
		};
	} else {
		if (_inarea) then {
			private ["_pos"];
			_pos = _position select 0;
			
			_modified = [_unit, _pos] call acpl_arty_count_gunnermistake;
		} else {
			_modified = [_unit, _position] call acpl_arty_count_gunnermistake;
		};
	};
	
	if (_type == 0) then {
		_thisfire = [_unit, _type, _modified];
		
		for "_i" from 1 to (_rnds) do {
			[_unit,[_classname,1]] remoteExec ["addmagazine",_unit];
			_unit setvariable ["acpl_arty_fired",false,true];
			[_unit, _classname, _modified] spawn acpl_arty_fire_round;
			waitUntil {_unit getvariable "acpl_arty_fired"};
		};
		
	};
	if (_type == 1) then {
		private ["_center", "_change", "_pos1", "_distance", "_pos2", "_target"];
		
		_center = _position select 0;
		_change = [(_center select 0) - (_modified select 0), (_center select 1) - (_modified select 1)];
		_pos1 = _position select 1;
		_pos2 = _position select 2;
		
		_pos1 = [(_pos1 select 0) - (_change select 0),(_pos1 select 1) - (_change select 1),0];
		_pos2 = [(_pos2 select 0) - (_change select 0),(_pos2 select 1) - (_change select 1),0];
		
		_distance = [((_pos1 select 0) - (_pos2 select 0)),((_pos1 select 1) - (_pos2 select 1))];
		_distance = [((_distance select 0) / _rnds),((_distance select 1) / _rnds)];
		
		_thisfire = [_unit, _type, [_modified, _pos1, _pos2]];
		
		_target = _pos1;
		[_unit,[_classname,1]] remoteExec ["addmagazine",_unit];
		_unit setvariable ["acpl_arty_fired",false,true];
		[_unit, _classname, _pos1] spawn acpl_arty_fire_round;
		waitUntil {_unit getvariable "acpl_arty_fired"};
		
		for "_i" from 2 to (_rnds) do {
			[_unit,[_classname,1]] remoteExec ["addmagazine",_unit];
			_target = [(_target select 0) - (_distance select 0),(_target select 1) - (_distance select 1),0];
			_unit setvariable ["acpl_arty_fired",false,true];
			[_unit, _classname, _target] spawn acpl_arty_fire_round;
			waitUntil {_unit getvariable "acpl_arty_fired"};
		};
	};
	if (_type == 2) then {
		private ["_max_x", "_max_y", "_angle"];
		
		_max_x = _position select 1;
		_max_y = _position select 2;
		_angle = _position select 3;
		
		_thisfire = [_unit, _type, [_modified, _max_x, _max_y, _angle]];
		
		if (_angle < 0) then {_angle = 360 + _angle};
		
		for "_i" from 1 to (_rnds) do {
			private ["_target", "_veh", "_random_x", "_random_y", "_dir", "_distance", "_vd"];
			
			_veh = "Land_HelipadEmpty_F" createVehicle _modified;
			_veh setdir 0;
			
			_random_x = random [-_max_x,0,_max_x];
			_random_y = random [-_max_y,0,_max_y];
			
			_random_pos = [(_modified select 0) + _random_x,(_modified select 1) + _random_y,(_modified select 2)];
			
			_vd = _modified vectorDiff _random_pos;
			_dir = (_vd select 0) atan2 (_vd select 1);
			if (_dir < 0) then {_dir = 360 + _dir};
			_dir = _angle + _dir;
			if (_dir > 360) then {_dir = 360 - _dir};
			
			_distance = _modified distance _random_pos;
			
			_target = _veh getRelPos [_distance, _dir];
			
			deletevehicle _veh;
			
			[_unit,[_classname,1]] remoteExec ["addmagazine",_unit];
			_unit setvariable ["acpl_arty_fired",false,true];
			[_unit, _classname, _target] spawn acpl_arty_fire_round;
			waitUntil {_unit getvariable "acpl_arty_fired"};
		};
	};
	
	_lastfire = _caller getvariable "acpl_arty_lastfire";
	if ([_caller] call acpl_arty_check_lastfire) then {
		private ["_fire"];
		
		_fire = [_caller] call acpl_arty_find_lastfire;
		_lastfire = _lastfire - [_fire];
	};
	_caller setvariable ["acpl_arty_lastfire",_lastfire + [_thisfire],true];
	
	_unit setVariable ["acpl_arty_battery_busy",false,true];
};
publicvariable "acpl_arty_openfire";

acpl_arty_fire_round = {
	params ["_unit", "_classname", "_target"];
	private ["_skill", "_pos_x", "_pos_y", "_dispersion", "_mod", "_dis"];
	
	_skill = (gunner _unit) skill "aimingAccuracy";
	_mod = ((getpos _unit) distance _target) / 1000;
	_dis = acpl_arty_dispersion * _mod;
	_dispersion = _dis - (_dis * _skill);
	_pos_x = random [-_dispersion,0,_dispersion];
	_pos_y = random [-_dispersion,0,_dispersion];
	
	_target = [(_target select 0) + _pos_x,(_target select 1) + _pos_y, 0];
	_target = [(_target select 0) + _pos_x,(_target select 1) + _pos_y, (getTerrainHeightASL _target)];
	
	(group (gunner _unit)) setCombatMode "YELLOW";
	
	[_unit,[_target, _classname, 1]] remoteExec ["doArtilleryFire",_unit];
};
publicvariable "acpl_arty_openfire";

acpl_arty_fncs = true;
publicvariable "acpl_arty_fncs";

if (acpl_fnc_debug) then {["ACPL FNCS ARTILLERY LOADED"] remoteExec ["systemchat",0];};