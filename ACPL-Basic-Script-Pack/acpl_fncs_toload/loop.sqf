if (!isserver) exitwith {};

acpl_loop = {
	private ["_playable", "_static", "_acpl_menu", "_hidebody"];
	
	waitUntil {acpl_fncs_initied};
	
	_static = _this select 0;
	
	acpl_mainloop_done = false;
	publicvariable "acpl_mainloop_done";
	
	acpl_radio_added = [];
	publicvariable "acpl_radio_added";

	acpl_msc_done = [];
	publicvariable "acpl_msc_done";

	acpl_medical_done = [];
	publicvariable "acpl_medical_done";
	
	acpl_variables_done = [];
	publicvariable "acpl_variables_done";
	
	acpl_arty_done = [];
	publicvariable "acpl_arty_done";
	
	acpl_static_done = [];
	publicvariable "acpl_static_done";
	
	acpl_arty_bateries = [];
	publicvariable "acpl_arty_bateries";
	
	_hidebody = ["acpl_hidebody", "Ukryj Ciało", "acpl_icons\hide.paa", {[_target] remoteExec ["hideBody",0,true];}, {!(alive _target)}] call ace_interact_menu_fnc_createAction;
	
	_acpl_menu = ["acpl_menu", "ACPL", "", {}, {true}] call ace_interact_menu_fnc_createAction;
	
	private ["_arty_call", "_arty_call_correction", "_arty_rounds_7", "_arty_rounds_6", "_arty_rounds_5", "_arty_rounds_4", "_arty_rounds_3", "_arty_rounds_2", "_arty_rounds_1", "_arty_typeoffire_point", "_arty_typeoffire_line", "_arty_typeoffire_circle", "_arty_ammo_guided", "_arty_ammo_flare", "_arty_ammo_lg", "_arty", "_arty_battery", "_arty_ammo", "_arty_typeoffire", "_arty_rounds", "_arty_correction", "_arty_call", "_arty_ammo_he", "_arty_ammo_smoke", "_arty_ammo_cluster", "_arty_ammo_mine", "_arty_ammo_mineat"];
	
	_arty = ["acpl_arty_menu", "Opcje Artylerii", "acpl_icons\arty.paa", {}, {_player getvariable "acpl_arty_fo"}] call ace_interact_menu_fnc_createAction;
	_arty_battery = ["acpl_arty_battery", "Bateria", "acpl_icons\arty.paa", {}, {_player getvariable "acpl_arty_fo"}] call ace_interact_menu_fnc_createAction;
	_arty_ammo = ["acpl_arty_menu_ammo", "Typ amunicji", "acpl_icons\arty.paa", {}, {_player getvariable "acpl_arty_fo"}] call ace_interact_menu_fnc_createAction;
	
	_arty_ammo_he = ["acpl_arty_ammo_he", "HE", "acpl_icons\arty.paa", {["Wybrano HE"] remoteExec ["hint",_player];_player setVariable ["acpl_arty_ammo","he",true];}, {(_player getvariable "acpl_arty_fo") AND ((_player getvariable "acpl_arty_chosen") getvariable "acpl_arty_he") AND ((_player getvariable "acpl_arty_chosen") != _player)}] call ace_interact_menu_fnc_createAction;
	_arty_ammo_smoke = ["acpl_arty_ammo_smoke", "SMOKE", "acpl_icons\arty.paa", {["Wybrano SMOKE"] remoteExec ["hint",_player];_player setVariable ["acpl_arty_ammo","smoke",true];}, {(_player getvariable "acpl_arty_fo") AND ((_player getvariable "acpl_arty_chosen") getvariable "acpl_arty_smoke") AND ((_player getvariable "acpl_arty_chosen") != _player)}] call ace_interact_menu_fnc_createAction;
	_arty_ammo_cluster = ["acpl_arty_ammo_cluster", "CLUSTER", "acpl_icons\arty.paa", {["Wybrano CLUSTER"] remoteExec ["hint",_player];_player setVariable ["acpl_arty_ammo","cluster",true];}, {(_player getvariable "acpl_arty_fo") AND ((_player getvariable "acpl_arty_chosen") getvariable "acpl_arty_cluster") AND ((_player getvariable "acpl_arty_chosen") != _player)}] call ace_interact_menu_fnc_createAction;
	_arty_ammo_mine = ["acpl_arty_ammo_mine", "MINE CLUSTER", "acpl_icons\arty.paa", {["Wybrano MINE CLUSTER"] remoteExec ["hint",_player];_player setVariable ["acpl_arty_ammo","mine",true];}, {(_player getvariable "acpl_arty_fo") AND ((_player getvariable "acpl_arty_chosen") getvariable "acpl_arty_mine") AND ((_player getvariable "acpl_arty_chosen") != _player)}] call ace_interact_menu_fnc_createAction;
	_arty_ammo_mineat = ["acpl_arty_ammo_mineat", "AT MINE CLUSTER", "acpl_icons\arty.paa", {["Wybrano AT MINE CLUSTER"] remoteExec ["hint",_player];_player setVariable ["acpl_arty_ammo","atmine",true];}, {(_player getvariable "acpl_arty_fo") AND ((_player getvariable "acpl_arty_chosen") getvariable "acpl_arty_atmine") AND ((_player getvariable "acpl_arty_chosen") != _player)}] call ace_interact_menu_fnc_createAction;
	_arty_ammo_flare = ["acpl_arty_ammo_flare", "FLARE", "acpl_icons\arty.paa", {["Wybrano FLARE"] remoteExec ["hint",_player];_player setVariable ["acpl_arty_ammo","flare",true];}, {(_player getvariable "acpl_arty_fo") AND ((_player getvariable "acpl_arty_chosen") getvariable "acpl_arty_flare") AND ((_player getvariable "acpl_arty_chosen") != _player)}] call ace_interact_menu_fnc_createAction;
	_arty_ammo_lg = ["acpl_arty_ammo_lg", "LASER GUIDED", "acpl_icons\arty.paa", {["Wybrano LASER GUIDED"] remoteExec ["hint",_player];_player setVariable ["acpl_arty_ammo","lg",true];}, {(_player getvariable "acpl_arty_fo") AND ((_player getvariable "acpl_arty_chosen") getvariable "acpl_arty_lg") AND ((_player getvariable "acpl_arty_chosen") != _player)}] call ace_interact_menu_fnc_createAction;
	_arty_ammo_guided = ["acpl_arty_ammo_guided", "GUIDED", "acpl_icons\arty.paa", {["Wybrano GUIDED"] remoteExec ["hint",_player];_player setVariable ["acpl_arty_ammo","guided",true];}, {(_player getvariable "acpl_arty_fo") AND ((_player getvariable "acpl_arty_chosen") getvariable "acpl_arty_guided") AND ((_player getvariable "acpl_arty_chosen") != _player)}] call ace_interact_menu_fnc_createAction;
	
	_arty_typeoffire = ["acpl_arty_typeoffire", "Rodzaj ostrzału", "acpl_icons\arty.paa", {}, {(_player getvariable "acpl_arty_fo") AND !(_player getvariable "acpl_arty_iscalling")}] call ace_interact_menu_fnc_createAction;
	
	_arty_typeoffire_point = ["acpl_arty_typeoffire_point", "Punktowy", "acpl_icons\arty.paa", {hint "Wybrano Punktowy";_player setVariable ["acpl_arty_typeoffire",0,true];}, {(_player getvariable "acpl_arty_fo") AND !(_player getvariable "acpl_arty_iscalling")}] call ace_interact_menu_fnc_createAction;
	_arty_typeoffire_line = ["acpl_arty_typeoffire_line", "Liniowy", "acpl_icons\arty.paa", {hint "Wybrano Liniowy";_player setVariable ["acpl_arty_typeoffire",1,true];}, {(_player getvariable "acpl_arty_fo") AND !(_player getvariable "acpl_arty_iscalling")}] call ace_interact_menu_fnc_createAction;
	_arty_typeoffire_circle = ["acpl_arty_typeoffire_circle", "Obszarowy", "acpl_icons\arty.paa", {hint "Wybrano Obszarowy";_player setVariable ["acpl_arty_typeoffire",2,true];}, {(_player getvariable "acpl_arty_fo") AND !(_player getvariable "acpl_arty_iscalling")}] call ace_interact_menu_fnc_createAction;
	
	_arty_rounds = ["acpl_arty_rounds", "Ilość pocisków", "acpl_icons\arty.paa", {}, {_player getvariable "acpl_arty_fo"}] call ace_interact_menu_fnc_createAction;
	
	_arty_rounds_1 = ["acpl_arty_rounds_1", "Ustaw na 1", "acpl_icons\arty.paa", {hint "Wybrano 1 pocisk";_player setvariable ["acpl_arty_rounds",1,true];}, {_player getvariable "acpl_arty_fo"}] call ace_interact_menu_fnc_createAction;
	_arty_rounds_2 = ["acpl_arty_rounds_+1", "+1", "acpl_icons\arty.paa", {
		private ["_rounds"];
		_rounds = (_player getvariable "acpl_arty_rounds") + 1;
		hint ("Liczba pocisków: " + str(_rounds));
		_player setvariable ["acpl_arty_rounds",_rounds,true];
	}, {_player getvariable "acpl_arty_fo"}] call ace_interact_menu_fnc_createAction;
	_arty_rounds_3 = ["acpl_arty_rounds_+5", "+5", "acpl_icons\arty.paa", {
		private ["_rounds"];
		_rounds = (_player getvariable "acpl_arty_rounds") + 5;
		hint ("Liczba pocisków: " + str(_rounds));
		_player setvariable ["acpl_arty_rounds",_rounds,true];
	}, {_player getvariable "acpl_arty_fo"}] call ace_interact_menu_fnc_createAction;
	_arty_rounds_4 = ["acpl_arty_rounds_+10", "+10", "acpl_icons\arty.paa", {
		private ["_rounds"];
		_rounds = (_player getvariable "acpl_arty_rounds") + 10;
		hint ("Liczba pocisków: " + str(_rounds));
		_player setvariable ["acpl_arty_rounds",_rounds,true];
	}, {_player getvariable "acpl_arty_fo"}] call ace_interact_menu_fnc_createAction;
	_arty_rounds_5 = ["acpl_arty_rounds_-1", "-1", "acpl_icons\arty.paa", {
		private ["_rounds"];
		_rounds = (_player getvariable "acpl_arty_rounds") - 1;
		if (_rounds < 1) then {_rounds = 1;};
		hint ("Liczba pocisków: " + str(_rounds));
		_player setvariable ["acpl_arty_rounds",_rounds,true];
	}, {_player getvariable "acpl_arty_fo"}] call ace_interact_menu_fnc_createAction;
	_arty_rounds_6 = ["acpl_arty_rounds_-5", "-5", "acpl_icons\arty.paa", {
		private ["_rounds"];
		_rounds = (_player getvariable "acpl_arty_rounds") - 5;
		if (_rounds < 1) then {_rounds = 1;};
		hint ("Liczba pocisków: " + str(_rounds));
		_player setvariable ["acpl_arty_rounds",_rounds,true];
	}, {_player getvariable "acpl_arty_fo"}] call ace_interact_menu_fnc_createAction;
	_arty_rounds_7 = ["acpl_arty_rounds_-10", "-10", "acpl_icons\arty.paa", {
		private ["_rounds"];
		_rounds = (_player getvariable "acpl_arty_rounds") - 10;
		if (_rounds < 1) then {_rounds = 1;};
		hint ("Liczba pocisków: " + str(_rounds));
		_player setvariable ["acpl_arty_rounds",_rounds,true];
	}, {_player getvariable "acpl_arty_fo"}] call ace_interact_menu_fnc_createAction;
	
	private ["_arty_correction_0_0", "_arty_correction", "_arty_correction_w100", "_arty_correction_w50", "_arty_correction_w10", "_arty_correction_w5", "_arty_correction_w1", "_arty_correction_s1", "_arty_correction_s5", "_arty_correction_s10", "_arty_correction_s50", "_arty_correction_s100", "_arty_correction_e50", "_arty_correction_e5", "_arty_correction_e100", "_arty_correction_e10", "_arty_correction_e1", "_arty_correction_n1", "_arty_correction_n5", "_arty_correction_n10", "_arty_correction_n50", "_arty_correction_n100", "_arty_correction_n", "_arty_correction_e", "_arty_correction_s", "_arty_correction_w"];
	
	_arty_correction = ["acpl_arty_correction", "Ustaw poprawkę", "acpl_icons\arty.paa", {}, {(_player getvariable "acpl_arty_fo") AND !(_player getvariable "acpl_arty_iscalling") AND ([_player] call acpl_arty_check_lastfire)}] call ace_interact_menu_fnc_createAction;
	
	_arty_correction_0_0 = ["acpl_arty_correction_0_0", "Wyzeruj poprawkę", "acpl_icons\arty.paa", {
		hint "Aktualna poprawka: 0E, 0N";
		_player setVariable ["acpl_arty_correction",[0,0],true];
	}, {(_player getvariable "acpl_arty_fo") AND (count (_player getVariable "acpl_arty_lastfire") > 0) AND !(_player getvariable "acpl_arty_iscalling") AND ([_player] call acpl_arty_check_lastfire)}] call ace_interact_menu_fnc_createAction;
	
	_arty_correction_n = ["acpl_arty_correction_n", "Północ", "acpl_icons\arty.paa", {}, {(_player getvariable "acpl_arty_fo") AND (count (_player getVariable "acpl_arty_lastfire") > 0) AND !(_player getvariable "acpl_arty_iscalling") AND ([_player] call acpl_arty_check_lastfire)}] call ace_interact_menu_fnc_createAction;
	_arty_correction_n1 = ["acpl_arty_correction_n1", "+1m", "acpl_icons\arty.paa", {
		private ["_cor", "_cor_x", "_cor_y", "_info_x", "_info_y"];
		_cor = [_player,0,1] call acpl_arty_make_correction;
		_cor_x = _cor select 0;
		if (_cor_x >= 0) then {_info_x = str(_cor_x) + "E";} else {_info_x = str(-_cor_x) + "W";};
		_cor_y = _cor select 1;
		if (_cor_y >= 0) then {_info_y = str(_cor_y) + "N";} else {_info_y = str(-_cor_y) + "S";};
		hint ("Aktualna poprawka: " + _info_x + " " + _info_y);
		_player setVariable ["acpl_arty_correction",_cor,true];
	}, {(_player getvariable "acpl_arty_fo") AND (count (_player getVariable "acpl_arty_lastfire") > 0) AND !(_player getvariable "acpl_arty_iscalling") AND ([_player] call acpl_arty_check_lastfire)}] call ace_interact_menu_fnc_createAction;
	_arty_correction_n5 = ["acpl_arty_correction_n5", "+5m", "acpl_icons\arty.paa", {
		private ["_cor", "_cor_x", "_cor_y", "_info_x", "_info_y"];
		_cor = [_player,0,5] call acpl_arty_make_correction;
		_cor_x = _cor select 0;
		if (_cor_x >= 0) then {_info_x = str(_cor_x) + "E";} else {_info_x = str(-_cor_x) + "W";};
		_cor_y = _cor select 1;
		if (_cor_y >= 0) then {_info_y = str(_cor_y) + "N";} else {_info_y = str(-_cor_y) + "S";};
		hint ("Aktualna poprawka: " + _info_x + " " + _info_y);
		_player setVariable ["acpl_arty_correction",_cor,true];
	}, {(_player getvariable "acpl_arty_fo") AND (count (_player getVariable "acpl_arty_lastfire") > 0) AND !(_player getvariable "acpl_arty_iscalling") AND ([_player] call acpl_arty_check_lastfire)}] call ace_interact_menu_fnc_createAction;
	_arty_correction_n10 = ["acpl_arty_correction_n10", "+10m", "acpl_icons\arty.paa", {
		private ["_cor", "_cor_x", "_cor_y", "_info_x", "_info_y"];
		_cor = [_player,0,10] call acpl_arty_make_correction;
		_cor_x = _cor select 0;
		if (_cor_x >= 0) then {_info_x = str(_cor_x) + "E";} else {_info_x = str(-_cor_x) + "W";};
		_cor_y = _cor select 1;
		if (_cor_y >= 0) then {_info_y = str(_cor_y) + "N";} else {_info_y = str(-_cor_y) + "S";};
		hint ("Aktualna poprawka: " + _info_x + " " + _info_y);
		_player setVariable ["acpl_arty_correction",_cor,true];
	}, {(_player getvariable "acpl_arty_fo") AND (count (_player getVariable "acpl_arty_lastfire") > 0) AND !(_player getvariable "acpl_arty_iscalling") AND ([_player] call acpl_arty_check_lastfire)}] call ace_interact_menu_fnc_createAction;
	_arty_correction_n50 = ["acpl_arty_correction_n50", "+50m", "acpl_icons\arty.paa", {
		private ["_cor", "_cor_x", "_cor_y", "_info_x", "_info_y"];
		_cor = [_player,0,50] call acpl_arty_make_correction;
		_cor_x = _cor select 0;
		if (_cor_x >= 0) then {_info_x = str(_cor_x) + "E";} else {_info_x = str(-_cor_x) + "W";};
		_cor_y = _cor select 1;
		if (_cor_y >= 0) then {_info_y = str(_cor_y) + "N";} else {_info_y = str(-_cor_y) + "S";};
		hint ("Aktualna poprawka: " + _info_x + " " + _info_y);
		_player setVariable ["acpl_arty_correction",_cor,true];
	}, {(_player getvariable "acpl_arty_fo") AND (count (_player getVariable "acpl_arty_lastfire") > 0) AND !(_player getvariable "acpl_arty_iscalling") AND ([_player] call acpl_arty_check_lastfire)}] call ace_interact_menu_fnc_createAction;
	_arty_correction_n100 = ["acpl_arty_correction_n100", "+100m", "acpl_icons\arty.paa", {
		private ["_cor", "_cor_x", "_cor_y", "_info_x", "_info_y"];
		_cor = [_player,0,100] call acpl_arty_make_correction;
		_cor_x = _cor select 0;
		if (_cor_x >= 0) then {_info_x = str(_cor_x) + "E";} else {_info_x = str(-_cor_x) + "W";};
		_cor_y = _cor select 1;
		if (_cor_y >= 0) then {_info_y = str(_cor_y) + "N";} else {_info_y = str(-_cor_y) + "S";};
		hint ("Aktualna poprawka: " + _info_x + " " + _info_y);
		_player setVariable ["acpl_arty_correction",_cor,true];
	}, {(_player getvariable "acpl_arty_fo") AND (count (_player getVariable "acpl_arty_lastfire") > 0) AND !(_player getvariable "acpl_arty_iscalling") AND ([_player] call acpl_arty_check_lastfire)}] call ace_interact_menu_fnc_createAction;
	
	_arty_correction_e = ["acpl_arty_correction_e", "Wschód", "acpl_icons\arty.paa", {}, {(_player getvariable "acpl_arty_fo") AND (count (_player getVariable "acpl_arty_lastfire") > 0) AND !(_player getvariable "acpl_arty_iscalling") AND ([_player] call acpl_arty_check_lastfire)}] call ace_interact_menu_fnc_createAction;
	_arty_correction_e1 = ["acpl_arty_correction_e1", "+1m", "acpl_icons\arty.paa", {
		private ["_cor", "_cor_x", "_cor_y", "_info_x", "_info_y"];
		_cor = [_player,1,0] call acpl_arty_make_correction;
		_cor_x = _cor select 0;
		if (_cor_x >= 0) then {_info_x = str(_cor_x) + "E";} else {_info_x = str(-_cor_x) + "W";};
		_cor_y = _cor select 1;
		if (_cor_y >= 0) then {_info_y = str(_cor_y) + "N";} else {_info_y = str(-_cor_y) + "S";};
		hint ("Aktualna poprawka: " + _info_x + " " + _info_y);
		_player setVariable ["acpl_arty_correction",_cor,true];
	}, {(_player getvariable "acpl_arty_fo") AND (count (_player getVariable "acpl_arty_lastfire") > 0) AND !(_player getvariable "acpl_arty_iscalling") AND ([_player] call acpl_arty_check_lastfire)}] call ace_interact_menu_fnc_createAction;
	_arty_correction_e5 = ["acpl_arty_correction_e5", "+5m", "acpl_icons\arty.paa", {
		private ["_cor", "_cor_x", "_cor_y", "_info_x", "_info_y"];
		_cor = [_player,5,0] call acpl_arty_make_correction;
		_cor_x = _cor select 0;
		if (_cor_x >= 0) then {_info_x = str(_cor_x) + "E";} else {_info_x = str(-_cor_x) + "W";};
		_cor_y = _cor select 1;
		if (_cor_y >= 0) then {_info_y = str(_cor_y) + "N";} else {_info_y = str(-_cor_y) + "S";};
		hint ("Aktualna poprawka: " + _info_x + " " + _info_y);
		_player setVariable ["acpl_arty_correction",_cor,true];
	}, {(_player getvariable "acpl_arty_fo") AND (count (_player getVariable "acpl_arty_lastfire") > 0) AND !(_player getvariable "acpl_arty_iscalling") AND ([_player] call acpl_arty_check_lastfire)}] call ace_interact_menu_fnc_createAction;
	_arty_correction_e10 = ["acpl_arty_correction_e10", "+10m", "acpl_icons\arty.paa", {
		private ["_cor", "_cor_x", "_cor_y", "_info_x", "_info_y"];
		_cor = [_player,10,0] call acpl_arty_make_correction;
		_cor_x = _cor select 0;
		if (_cor_x >= 0) then {_info_x = str(_cor_x) + "E";} else {_info_x = str(-_cor_x) + "W";};
		_cor_y = _cor select 1;
		if (_cor_y >= 0) then {_info_y = str(_cor_y) + "N";} else {_info_y = str(-_cor_y) + "S";};
		hint ("Aktualna poprawka: " + _info_x + " " + _info_y);
		_player setVariable ["acpl_arty_correction",_cor,true];
	}, {(_player getvariable "acpl_arty_fo") AND (count (_player getVariable "acpl_arty_lastfire") > 0) AND !(_player getvariable "acpl_arty_iscalling") AND ([_player] call acpl_arty_check_lastfire)}] call ace_interact_menu_fnc_createAction;
	_arty_correction_e50 = ["acpl_arty_correction_e50", "+50m", "acpl_icons\arty.paa", {
		private ["_cor", "_cor_x", "_cor_y", "_info_x", "_info_y"];
		_cor = [_player,50,0] call acpl_arty_make_correction;
		_cor_x = _cor select 0;
		if (_cor_x >= 0) then {_info_x = str(_cor_x) + "E";} else {_info_x = str(-_cor_x) + "W";};
		_cor_y = _cor select 1;
		if (_cor_y >= 0) then {_info_y = str(_cor_y) + "N";} else {_info_y = str(-_cor_y) + "S";};
		hint ("Aktualna poprawka: " + _info_x + " " + _info_y);
		_player setVariable ["acpl_arty_correction",_cor,true];
	}, {(_player getvariable "acpl_arty_fo") AND (count (_player getVariable "acpl_arty_lastfire") > 0) AND !(_player getvariable "acpl_arty_iscalling") AND ([_player] call acpl_arty_check_lastfire)}] call ace_interact_menu_fnc_createAction;
	_arty_correction_e100 = ["acpl_arty_correction_e100", "+100m", "acpl_icons\arty.paa", {
		private ["_cor", "_cor_x", "_cor_y", "_info_x", "_info_y"];
		_cor = [_player,100,0] call acpl_arty_make_correction;
		_cor_x = _cor select 0;
		if (_cor_x >= 0) then {_info_x = str(_cor_x) + "E";} else {_info_x = str(-_cor_x) + "W";};
		_cor_y = _cor select 1;
		if (_cor_y >= 0) then {_info_y = str(_cor_y) + "N";} else {_info_y = str(-_cor_y) + "S";};
		hint ("Aktualna poprawka: " + _info_x + " " + _info_y);
		_player setVariable ["acpl_arty_correction",_cor,true];
	}, {(_player getvariable "acpl_arty_fo") AND (count (_player getVariable "acpl_arty_lastfire") > 0) AND !(_player getvariable "acpl_arty_iscalling") AND ([_player] call acpl_arty_check_lastfire)}] call ace_interact_menu_fnc_createAction;
	
	_arty_correction_s = ["acpl_arty_correction_s", "Południe", "acpl_icons\arty.paa", {}, {(_player getvariable "acpl_arty_fo") AND (count (_player getVariable "acpl_arty_lastfire") > 0) AND !(_player getvariable "acpl_arty_iscalling") AND ([_player] call acpl_arty_check_lastfire)}] call ace_interact_menu_fnc_createAction;
	_arty_correction_s1 = ["acpl_arty_correction_s1", "+1m", "acpl_icons\arty.paa", {
		private ["_cor", "_cor_x", "_cor_y", "_info_x", "_info_y"];
		_cor = [_player,0,-1] call acpl_arty_make_correction;
		_cor_x = _cor select 0;
		if (_cor_x >= 0) then {_info_x = str(_cor_x) + "E";} else {_info_x = str(-_cor_x) + "W";};
		_cor_y = _cor select 1;
		if (_cor_y >= 0) then {_info_y = str(_cor_y) + "N";} else {_info_y = str(-_cor_y) + "S";};
		hint ("Aktualna poprawka: " + _info_x + " " + _info_y);
		_player setVariable ["acpl_arty_correction",_cor,true];
	}, {(_player getvariable "acpl_arty_fo") AND (count (_player getVariable "acpl_arty_lastfire") > 0) AND !(_player getvariable "acpl_arty_iscalling") AND ([_player] call acpl_arty_check_lastfire)}] call ace_interact_menu_fnc_createAction;
	_arty_correction_s5 = ["acpl_arty_correction_s5", "+5m", "acpl_icons\arty.paa", {
		private ["_cor", "_cor_x", "_cor_y", "_info_x", "_info_y"];
		_cor = [_player,0,-5] call acpl_arty_make_correction;
		_cor_x = _cor select 0;
		if (_cor_x >= 0) then {_info_x = str(_cor_x) + "E";} else {_info_x = str(-_cor_x) + "W";};
		_cor_y = _cor select 1;
		if (_cor_y >= 0) then {_info_y = str(_cor_y) + "N";} else {_info_y = str(-_cor_y) + "S";};
		hint ("Aktualna poprawka: " + _info_x + " " + _info_y);
		_player setVariable ["acpl_arty_correction",_cor,true];
	}, {(_player getvariable "acpl_arty_fo") AND (count (_player getVariable "acpl_arty_lastfire") > 0) AND !(_player getvariable "acpl_arty_iscalling") AND ([_player] call acpl_arty_check_lastfire)}] call ace_interact_menu_fnc_createAction;
	_arty_correction_s10 = ["acpl_arty_correction_s10", "+10m", "acpl_icons\arty.paa", {
		private ["_cor", "_cor_x", "_cor_y", "_info_x", "_info_y"];
		_cor = [_player,0,-10] call acpl_arty_make_correction;
		_cor_x = _cor select 0;
		if (_cor_x >= 0) then {_info_x = str(_cor_x) + "E";} else {_info_x = str(-_cor_x) + "W";};
		_cor_y = _cor select 1;
		if (_cor_y >= 0) then {_info_y = str(_cor_y) + "N";} else {_info_y = str(-_cor_y) + "S";};
		hint ("Aktualna poprawka: " + _info_x + " " + _info_y);
		_player setVariable ["acpl_arty_correction",_cor,true];
	}, {(_player getvariable "acpl_arty_fo") AND (count (_player getVariable "acpl_arty_lastfire") > 0) AND !(_player getvariable "acpl_arty_iscalling") AND ([_player] call acpl_arty_check_lastfire)}] call ace_interact_menu_fnc_createAction;
	_arty_correction_s50 = ["acpl_arty_correction_s50", "+50m", "acpl_icons\arty.paa", {
		private ["_cor", "_cor_x", "_cor_y", "_info_x", "_info_y"];
		_cor = [_player,0,-50] call acpl_arty_make_correction;
		_cor_x = _cor select 0;
		if (_cor_x >= 0) then {_info_x = str(_cor_x) + "E";} else {_info_x = str(-_cor_x) + "W";};
		_cor_y = _cor select 1;
		if (_cor_y >= 0) then {_info_y = str(_cor_y) + "N";} else {_info_y = str(-_cor_y) + "S";};
		hint ("Aktualna poprawka: " + _info_x + " " + _info_y);
		_player setVariable ["acpl_arty_correction",_cor,true];
	}, {(_player getvariable "acpl_arty_fo") AND (count (_player getVariable "acpl_arty_lastfire") > 0) AND !(_player getvariable "acpl_arty_iscalling") AND ([_player] call acpl_arty_check_lastfire)}] call ace_interact_menu_fnc_createAction;
	_arty_correction_s100 = ["acpl_arty_correction_s100", "+100m", "acpl_icons\arty.paa", {
		private ["_cor", "_cor_x", "_cor_y", "_info_x", "_info_y"];
		_cor = [_player,0,-100] call acpl_arty_make_correction;
		_cor_x = _cor select 0;
		if (_cor_x >= 0) then {_info_x = str(_cor_x) + "E";} else {_info_x = str(-_cor_x) + "W";};
		_cor_y = _cor select 1;
		if (_cor_y >= 0) then {_info_y = str(_cor_y) + "N";} else {_info_y = str(-_cor_y) + "S";};
		hint ("Aktualna poprawka: " + _info_x + " " + _info_y);
		_player setVariable ["acpl_arty_correction",_cor,true];
	}, {(_player getvariable "acpl_arty_fo") AND (count (_player getVariable "acpl_arty_lastfire") > 0) AND !(_player getvariable "acpl_arty_iscalling") AND ([_player] call acpl_arty_check_lastfire)}] call ace_interact_menu_fnc_createAction;
	
	_arty_correction_w = ["acpl_arty_correction_w", "Zachód", "acpl_icons\arty.paa", {}, {(_player getvariable "acpl_arty_fo") AND (count (_player getVariable "acpl_arty_lastfire") > 0) AND !(_player getvariable "acpl_arty_iscalling") AND ([_player] call acpl_arty_check_lastfire)}] call ace_interact_menu_fnc_createAction;
	_arty_correction_w1 = ["acpl_arty_correction_w1", "+1m", "acpl_icons\arty.paa", {
		private ["_cor", "_cor_x", "_cor_y", "_info_x", "_info_y"];
		_cor = [_player,-1,0] call acpl_arty_make_correction;
		_cor_x = _cor select 0;
		if (_cor_x >= 0) then {_info_x = str(_cor_x) + "E";} else {_info_x = str(-_cor_x) + "W";};
		_cor_y = _cor select 1;
		if (_cor_y >= 0) then {_info_y = str(_cor_y) + "N";} else {_info_y = str(-_cor_y) + "S";};
		hint ("Aktualna poprawka: " + _info_x + " " + _info_y);
		_player setVariable ["acpl_arty_correction",_cor,true];
	}, {(_player getvariable "acpl_arty_fo") AND (count (_player getVariable "acpl_arty_lastfire") > 0) AND !(_player getvariable "acpl_arty_iscalling") AND ([_player] call acpl_arty_check_lastfire)}] call ace_interact_menu_fnc_createAction;
	_arty_correction_w5 = ["acpl_arty_correction_w5", "+5m", "acpl_icons\arty.paa", {
		private ["_cor", "_cor_x", "_cor_y", "_info_x", "_info_y"];
		_cor = [_player,-5,0] call acpl_arty_make_correction;
		_cor_x = _cor select 0;
		if (_cor_x >= 0) then {_info_x = str(_cor_x) + "E";} else {_info_x = str(-_cor_x) + "W";};
		_cor_y = _cor select 1;
		if (_cor_y >= 0) then {_info_y = str(_cor_y) + "N";} else {_info_y = str(-_cor_y) + "S";};
		hint ("Aktualna poprawka: " + _info_x + " " + _info_y);
		_player setVariable ["acpl_arty_correction",_cor,true];
	}, {(_player getvariable "acpl_arty_fo") AND (count (_player getVariable "acpl_arty_lastfire") > 0) AND !(_player getvariable "acpl_arty_iscalling") AND ([_player] call acpl_arty_check_lastfire)}] call ace_interact_menu_fnc_createAction;
	_arty_correction_w10 = ["acpl_arty_correction_w10", "+10m", "acpl_icons\arty.paa", {
		private ["_cor", "_cor_x", "_cor_y", "_info_x", "_info_y"];
		_cor = [_player,-10,0] call acpl_arty_make_correction;
		_cor_x = _cor select 0;
		if (_cor_x >= 0) then {_info_x = str(_cor_x) + "E";} else {_info_x = str(-_cor_x) + "W";};
		_cor_y = _cor select 1;
		if (_cor_y >= 0) then {_info_y = str(_cor_y) + "N";} else {_info_y = str(-_cor_y) + "S";};
		hint ("Aktualna poprawka: " + _info_x + " " + _info_y);
		_player setVariable ["acpl_arty_correction",_cor,true];
	}, {(_player getvariable "acpl_arty_fo") AND (count (_player getVariable "acpl_arty_lastfire") > 0) AND !(_player getvariable "acpl_arty_iscalling") AND ([_player] call acpl_arty_check_lastfire)}] call ace_interact_menu_fnc_createAction;
	_arty_correction_w50 = ["acpl_arty_correction_w50", "+50m", "acpl_icons\arty.paa", {
		private ["_cor", "_cor_x", "_cor_y", "_info_x", "_info_y"];
		_cor = [_player,-50,0] call acpl_arty_make_correction;
		_cor_x = _cor select 0;
		if (_cor_x >= 0) then {_info_x = str(_cor_x) + "E";} else {_info_x = str(-_cor_x) + "W";};
		_cor_y = _cor select 1;
		if (_cor_y >= 0) then {_info_y = str(_cor_y) + "N";} else {_info_y = str(-_cor_y) + "S";};
		hint ("Aktualna poprawka: " + _info_x + " " + _info_y);
		_player setVariable ["acpl_arty_correction",_cor,true];
	}, {(_player getvariable "acpl_arty_fo") AND (count (_player getVariable "acpl_arty_lastfire") > 0) AND !(_player getvariable "acpl_arty_iscalling") AND ([_player] call acpl_arty_check_lastfire)}] call ace_interact_menu_fnc_createAction;
	_arty_correction_w100 = ["acpl_arty_correction_w100", "+100m", "acpl_icons\arty.paa", {
		private ["_cor", "_cor_x", "_cor_y", "_info_x", "_info_y"];
		_cor = [_player,-100,0] call acpl_arty_make_correction;
		_cor_x = _cor select 0;
		if (_cor_x >= 0) then {_info_x = str(_cor_x) + "E";} else {_info_x = str(-_cor_x) + "W";};
		_cor_y = _cor select 1;
		if (_cor_y >= 0) then {_info_y = str(_cor_y) + "N";} else {_info_y = str(-_cor_y) + "S";};
		hint ("Aktualna poprawka: " + _info_x + " " + _info_y);
		_player setVariable ["acpl_arty_correction",_cor,true];
	}, {(_player getvariable "acpl_arty_fo") AND (count (_player getVariable "acpl_arty_lastfire") > 0) AND !(_player getvariable "acpl_arty_iscalling") AND ([_player] call acpl_arty_check_lastfire)}] call ace_interact_menu_fnc_createAction;
	
	_arty_checkammo = ["acpl_arty_checkammo", "Sprawdź stan amunicji", "acpl_icons\arty.paa", {[[_player],acpl_arty_sendammo] remoteExec ["spawn",2];}, {(_player getvariable "acpl_arty_fo") AND (_player getvariable "acpl_arty_chosen" != _player) AND !(_player getvariable "acpl_arty_iscalling") AND !((_player getvariable "acpl_arty_chosen") getvariable "acpl_arty_battery_busy")}] call ace_interact_menu_fnc_createAction;
	_arty_call = ["acpl_arty_call", "Wezwij", "acpl_icons\arty.paa", {
		[[_player], acpl_arty_takecoordinates] remoteExec ["spawn",2];
	}, {(_player getvariable "acpl_arty_fo") AND (_player getvariable "acpl_arty_chosen" != _player) AND !(_player getvariable "acpl_arty_iscalling") AND !((_player getvariable "acpl_arty_chosen") getvariable "acpl_arty_battery_busy")}] call ace_interact_menu_fnc_createAction;
	_arty_call_correction = ["acpl_arty_call_correction", "Wezwij z poprawką", "acpl_icons\arty.paa", {[[_player], acpl_arty_call_corrected] remoteExec ["spawn",2];}, {(_player getvariable "acpl_arty_fo") AND (_player getvariable "acpl_arty_chosen" != _player) AND ([_player] call acpl_arty_check_lastfire) AND (!(_player getvariable "acpl_arty_iscalling")) AND (!((_player getvariable "acpl_arty_chosen") getvariable "acpl_arty_battery_busy")) AND ((_player getvariable "acpl_arty_ammo") != "")}] call ace_interact_menu_fnc_createAction;
	_arty_call_cancel = ["acpl_arty_call_cancel", "Anuluj", "acpl_icons\arty.paa", {_player setVariable ["acpl_arty_cancel",true,true];}, {(_player getvariable "acpl_arty_fo") AND (_player getvariable "acpl_arty_iscalling")}] call ace_interact_menu_fnc_createAction;
	
	private ["_radio","_radio_2","_radio_lower_sw","_radio_lower_lr","_radio_onhead_sw","_radio_onhead_lr","_radio_ask_sw","_radio_ask_lr","_radio_asked_sw","_radio_asked_lr","_radio_return_sw","_radio_return_lr"];
	
	_radio = ["acpl_radio_menu", "Opcje Radia", "acpl_icons\radio.paa", {}, {(call TFAR_fnc_haveSWRadio) OR (call TFAR_fnc_haveLRRadio)}] call ace_interact_menu_fnc_createAction;
	_radio_lower_sw = ["acpl_radio_lowerheadset_sw", "Zdejmij słuchawki (SW)", "acpl_icons\radio.paa", {private ["_volume"];_volume = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getSwVolume;_player setvariable ["acpl_radio_volume_sw",_volume,true];_player setvariable ["acpl_radio_lower_sw",true,true];[(call TFAR_fnc_ActiveSWRadio), 1] call TFAR_fnc_setSwVolume;hint "Zdjąłeś słuchawki z radia krótkiego";}, {(call TFAR_fnc_haveSWRadio) AND !(_player getvariable "acpl_radio_lower_sw")}] call ace_interact_menu_fnc_createAction;
	_radio_onhead_sw = ["acpl_radio_headset_sw", "Załóż słuchawki (SW)", "acpl_icons\radio.paa", {_player setvariable ["acpl_radio_lower_sw",false,true];[(call TFAR_fnc_ActiveSWRadio), (_player getvariable "acpl_radio_volume_sw")] call TFAR_fnc_setSwVolume;hint "Założyłeś słuchawki z radia krótkiego";}, {(call TFAR_fnc_haveSWRadio) AND (_player getvariable "acpl_radio_lower_sw")}] call ace_interact_menu_fnc_createAction;
	_radio_lower_lr = ["acpl_radio_lowerheadset_lr", "Zdejmij słuchawki (LR)", "acpl_icons\radio.paa", {private ["_volume"];_volume = (call TFAR_fnc_ActiveLrRadio) call TFAR_fnc_getLrVolume;_player setvariable ["acpl_radio_volume_lr",_volume,true];_player setvariable ["acpl_radio_lower_lr",true,true];[(call TFAR_fnc_ActiveLrRadio), 1] call TFAR_fnc_setLrVolume;hint "Zdjąłeś słuchawki z radia długiego";}, {(call TFAR_fnc_haveLRRadio) AND !(_player getvariable "acpl_radio_lower_lr")}] call ace_interact_menu_fnc_createAction;
	_radio_onhead_lr = ["acpl_radio_headset_lr", "Załóż słuchawki (LR)", "acpl_icons\radio.paa", {_player setvariable ["acpl_radio_lower_lr",false,true];[(call TFAR_fnc_ActiveLRRadio), (_player getvariable "acpl_radio_volume_lr")] call TFAR_fnc_setLrVolume;hint "Założyłeś słuchawki z radia długiego";}, {(call TFAR_fnc_haveLRRadio) AND (_player getvariable "acpl_radio_lower_lr")}] call ace_interact_menu_fnc_createAction;
	_radio_ask_sw = ["acpl_radio_ask_sw", "Poproś o pożyczenie radia (SW)", "acpl_icons\radio.paa", {
		if (isPlayer _target) then {
			["Zostałeś poproszony o pożyczenie radia (SW)"] remoteExec ["hint",_target];
			_target setVariable ["acpl_radio_asked_sw_target",_player,true];
			_target setVariable ["acpl_radio_asked_sw",true,true];
		} else {
			_target setVariable ["acpl_radio_asked_sw_target",_player,true];
			[[_target],acpl_tfr_giveradio_sw] remoteExec ["call",2];
		};
	}, {([_target] call acpl_tfr_check_swradio) AND !(_player getvariable "acpl_radio_borrowed_sw") AND !(_target getvariable "acpl_radio_borrowed_sw")}] call ace_interact_menu_fnc_createAction;
	_radio_ask_lr = ["acpl_radio_ask_lr", "Poproś o pożyczenie radia (LR)", "acpl_icons\radio.paa", {
		if (isPlayer _target) then {
			["Zostałeś poproszony o pożyczenie radia (LR)"] remoteExec ["hint",_target];
			_target setVariable ["acpl_radio_asked_lr_target",_player,true];
			_target setVariable ["acpl_radio_asked_lr",true,true];
		} else {
			_target setVariable ["acpl_radio_asked_lr_target",_player,true];
			[[_target],acpl_tfr_giveradio_lr] remoteExec ["call",2];
		};
	}, {([_target] call acpl_tfr_check_lrradio) AND !(_player getvariable "acpl_radio_borrowed_lr") AND !(_target getvariable "acpl_radio_borrowed_lr")}] call ace_interact_menu_fnc_createAction;
	_radio_2 = ["acpl_radio_menu_2", "Radio", "acpl_icons\radio.paa", {}, {([_target] call acpl_tfr_check_swradio) OR ([_target] call acpl_tfr_check_lrradio)}] call ace_interact_menu_fnc_createAction;
	_radio_asked_sw = ["acpl_radio_asked_sw_act", "Podaj radio (SW)", "acpl_icons\radio.paa", {[[_player],acpl_tfr_giveradio_sw] remoteExec ["call",2];}, {(_player getvariable "acpl_radio_asked_sw") AND !(_player getvariable "acpl_radio_borrowed_sw")}] call ace_interact_menu_fnc_createAction;
	_radio_asked_lr = ["acpl_radio_asked_lr_act", "Podaj radio (LR)", "acpl_icons\radio.paa", {[[_player],acpl_tfr_giveradio_lr] remoteExec ["call",2];}, {(_player getvariable "acpl_radio_asked_lr") AND !(_player getvariable "acpl_radio_borrowed_lr")}] call ace_interact_menu_fnc_createAction;
	_radio_return_sw = ["acpl_radio_return_sw", "Oddaj radio (SW)", "acpl_icons\radio.paa", {[[_player],acpl_tfr_giveback_sw] remoteExec ["call",2];}, {(_player getvariable "acpl_radio_borrowed_sw")}] call ace_interact_menu_fnc_createAction;
	_radio_return_lr = ["acpl_radio_return_lr", "Oddaj radio (LR)", "acpl_icons\radio.paa", {[[_player],acpl_tfr_giveback_lr] remoteExec ["call",2];}, {(_player getvariable "acpl_radio_borrowed_lr")}] call ace_interact_menu_fnc_createAction;
	
	_playable = [] + playableUnits + switchableUnits + allPlayers;
	
	if (acpl_msc) then {
		acpl_msc_west_acc_mid = (((acpl_msc_west_acc select 0) + (acpl_msc_west_acc select 1))/acpl_msc_west_random);
		acpl_msc_west_shake_mid = (((acpl_msc_west_shake select 0) + (acpl_msc_west_shake select 1))/acpl_msc_west_random);
		acpl_msc_west_speed_mid = (((acpl_msc_west_speed select 0) + (acpl_msc_west_speed select 1))/acpl_msc_west_random);
		acpl_msc_west_spot_mid = (((acpl_msc_west_spot select 0) + (acpl_msc_west_spot select 1))/acpl_msc_west_random);
		acpl_msc_west_time_mid = (((acpl_msc_west_time select 0) + (acpl_msc_west_time select 1))/acpl_msc_west_random);
		acpl_msc_west_general_mid = (((acpl_msc_west_general select 0) + (acpl_msc_west_general select 1))/acpl_msc_west_random);
		acpl_msc_west_courage_mid = (((acpl_msc_west_courage select 0) + (acpl_msc_west_courage select 1))/acpl_msc_west_random);
		acpl_msc_west_reload_mid = (((acpl_msc_west_reload select 0) + (acpl_msc_west_reload select 1))/acpl_msc_west_random);
		
		{publicvariable str(_x);} foreach [acpl_msc_west_reload_mid,acpl_msc_west_courage_mid,acpl_msc_west_general_mid,acpl_msc_west_time_mid,acpl_msc_west_spot_mid,acpl_msc_west_speed_mid,acpl_msc_west_shake_mid,acpl_msc_west_acc_mid];
		
		acpl_msc_east_acc_mid = (((acpl_msc_east_acc select 0) + (acpl_msc_east_acc select 1))/acpl_msc_east_random);
		acpl_msc_east_shake_mid = (((acpl_msc_east_shake select 0) + (acpl_msc_east_shake select 1))/acpl_msc_east_random);
		acpl_msc_east_speed_mid = (((acpl_msc_east_speed select 0) + (acpl_msc_east_speed select 1))/acpl_msc_east_random);
		acpl_msc_east_spot_mid = (((acpl_msc_east_spot select 0) + (acpl_msc_east_spot select 1))/acpl_msc_east_random);
		acpl_msc_east_time_mid = (((acpl_msc_east_time select 0) + (acpl_msc_east_time select 1))/acpl_msc_east_random);
		acpl_msc_east_general_mid = (((acpl_msc_east_general select 0) + (acpl_msc_east_general select 1))/acpl_msc_east_random);
		acpl_msc_east_courage_mid = (((acpl_msc_east_courage select 0) + (acpl_msc_east_courage select 1))/acpl_msc_east_random);
		acpl_msc_east_reload_mid = (((acpl_msc_east_reload select 0) + (acpl_msc_east_reload select 1))/acpl_msc_east_random);
		
		{publicvariable str(_x);} foreach [acpl_msc_east_reload_mid,acpl_msc_east_courage_mid,acpl_msc_east_general_mid,acpl_msc_east_time_mid,acpl_msc_east_spot_mid,acpl_msc_east_speed_mid,acpl_msc_east_shake_mid,acpl_msc_east_acc_mid];
		
		acpl_msc_resistance_acc_mid = (((acpl_msc_resistance_acc select 0) + (acpl_msc_resistance_acc select 1))/acpl_msc_resistance_random);
		acpl_msc_resistance_shake_mid = (((acpl_msc_resistance_shake select 0) + (acpl_msc_resistance_shake select 1))/acpl_msc_resistance_random);
		acpl_msc_resistance_speed_mid = (((acpl_msc_resistance_speed select 0) + (acpl_msc_resistance_speed select 1))/acpl_msc_resistance_random);
		acpl_msc_resistance_spot_mid = (((acpl_msc_resistance_spot select 0) + (acpl_msc_resistance_spot select 1))/acpl_msc_resistance_random);
		acpl_msc_resistance_time_mid = (((acpl_msc_resistance_time select 0) + (acpl_msc_resistance_time select 1))/acpl_msc_resistance_random);
		acpl_msc_resistance_general_mid = (((acpl_msc_resistance_general select 0) + (acpl_msc_resistance_general select 1))/acpl_msc_resistance_random);
		acpl_msc_resistance_courage_mid = (((acpl_msc_resistance_courage select 0) + (acpl_msc_resistance_courage select 1))/acpl_msc_resistance_random);
		acpl_msc_resistance_reload_mid = (((acpl_msc_resistance_reload select 0) + (acpl_msc_resistance_reload select 1))/acpl_msc_resistance_random);
		
		{publicvariable str(_x);} foreach [acpl_msc_resistance_reload_mid,acpl_msc_resistance_courage_mid,acpl_msc_resistance_general_mid,acpl_msc_resistance_time_mid,acpl_msc_resistance_spot_mid,acpl_msc_resistance_speed_mid,acpl_msc_resistance_shake_mid,acpl_msc_resistance_acc_mid];
	};
	
	{
		[[(_x), 0, ["ACE_MainActions"], _hidebody],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
	} foreach allDead;
	
	while {true} do {
		
		{
			if (_x in acpl_variables_done) then {} else {
				_x setVariable ["acpl_anim",false,true];
				
				_x setVariable ["acpl_arty_fo",false,true];
				_x setVariable ["acpl_arty_pos",[0,0],true];
				_x setVariable ["acpl_arty_iscalling",false,true];
				_x setVariable ["acpl_arty_chosen",_x,true];
				_x setVariable ["acpl_arty_ammo","",true];
				_x setVariable ["acpl_arty_typeoffire",0,true];
				_x setVariable ["acpl_arty_rounds",1,true];
				_x setVariable ["acpl_arty_correction",[0,0],true];
				_x setVariable ["acpl_arty_lastfire",[],true];
				_x setVariable ["acpl_arty_batteries_added",[],true];
				_x setVariable ["acpl_arty_cursor_pos",[0,0],true];
				_x setVariable ["acpl_arty_cancel",false,true];
				_x setVariable ["acpl_arty_battery_busy",false,true];
				
				_x setVariable ["acpl_arty_markers",[],true];
				
				_x setVariable ["acpl_arty_he",false,true];
				_x setVariable ["acpl_arty_lg",false,true];
				_x setVariable ["acpl_arty_smoke",false,true];
				_x setVariable ["acpl_arty_mine",false,true];
				_x setVariable ["acpl_arty_atmine",false,true];
				_x setVariable ["acpl_arty_guided",false,true];
				_x setVariable ["acpl_arty_flare",false,true];
				_x setVariable ["acpl_arty_cluster",false,true];
				
				if (acpl_ww2_change_m1garand) then {
					if ("LIB_M1_Garand" in (weapons _x)) then {
						[_x,"LIB_M1_Garand"] remoteExec ["removeweapon",_x];
						[_x,"fow_w_m1_garand"] remoteExec ["addweapon",_x];
					};
				};
				
				if (acpl_ww2_change_leeenfield) then {
					if ("fow_w_leeenfield_no4mk1" in (weapons _x)) then {
						private ["_count"];
						
						[_x,"fow_w_leeenfield_no4mk1"] remoteExec ["removeweapon",_x];
						[_x,"bnae_mk1_virtual"] remoteExec ["addweapon",_x];
						_count = {_x == "fow_10Rnd_303"} count (magazines _x);
						[_x,"fow_10Rnd_303"] remoteExec ["removemagazines",_x];
						[_x,["10Rnd_303_Magazine",_count]] remoteExec ["addmagazines",_x];
					};
					if ("fow_w_leeenfield_no4mk1_redwood" in (weapons _x)) then {
						private ["_count"];
						
						[_x,"fow_w_leeenfield_no4mk1_redwood"] remoteExec ["removeweapon",_x];
						[_x,"bnae_mk1_virtual"] remoteExec ["addweapon",_x];
						_count = {_x == "fow_10Rnd_303"} count (magazines _x);
						[_x,"fow_10Rnd_303"] remoteExec ["removemagazines",_x];
						[_x,["10Rnd_303_Magazine",_count]] remoteExec ["addmagazines",_x];
					};
				};
				
				acpl_variables_done = acpl_variables_done + [_x];
				publicvariable "acpl_variables_done";
			};
			
			if ((count (_x getvariable "acpl_arty_batteries_added")) != (count acpl_arty_bateries)) then {
				[_x] spawn acpl_arty_addbateries;
			};
			
			if (_x in acpl_arty_done) then {} else {
				[[(_x), 1, ["ACE_SelfActions"], _arty],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu"], _arty_battery],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[_x] spawn acpl_arty_addbateries;
				
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu"], _arty_ammo],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_menu_ammo"], _arty_ammo_he],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_menu_ammo"], _arty_ammo_smoke],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_menu_ammo"], _arty_ammo_flare],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_menu_ammo"], _arty_ammo_cluster],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_menu_ammo"], _arty_ammo_mine],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_menu_ammo"], _arty_ammo_mineat],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_menu_ammo"], _arty_ammo_lg],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_menu_ammo"], _arty_ammo_guided],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu"], _arty_rounds],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_rounds"], _arty_rounds_1],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_rounds"], _arty_rounds_2],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_rounds"], _arty_rounds_3],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_rounds"], _arty_rounds_4],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_rounds"], _arty_rounds_5],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_rounds"], _arty_rounds_6],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_rounds"], _arty_rounds_7],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu"], _arty_typeoffire],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_typeoffire"], _arty_typeoffire_point],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_typeoffire"], _arty_typeoffire_line],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_typeoffire"], _arty_typeoffire_circle],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu"], _arty_correction],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_correction"], _arty_correction_0_0],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_correction"], _arty_correction_n],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_correction", "acpl_arty_correction_n"], _arty_correction_n1],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_correction", "acpl_arty_correction_n"], _arty_correction_n5],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_correction", "acpl_arty_correction_n"], _arty_correction_n10],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_correction", "acpl_arty_correction_n"], _arty_correction_n50],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_correction", "acpl_arty_correction_n"], _arty_correction_n100],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_correction"], _arty_correction_s],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_correction", "acpl_arty_correction_s"], _arty_correction_s1],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_correction", "acpl_arty_correction_s"], _arty_correction_s5],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_correction", "acpl_arty_correction_s"], _arty_correction_s10],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_correction", "acpl_arty_correction_s"], _arty_correction_s50],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_correction", "acpl_arty_correction_s"], _arty_correction_s100],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_correction"], _arty_correction_e],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_correction", "acpl_arty_correction_e"], _arty_correction_e1],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_correction", "acpl_arty_correction_e"], _arty_correction_e5],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_correction", "acpl_arty_correction_e"], _arty_correction_e10],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_correction", "acpl_arty_correction_e"], _arty_correction_e50],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_correction", "acpl_arty_correction_e"], _arty_correction_e100],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_correction"], _arty_correction_w],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_correction", "acpl_arty_correction_w"], _arty_correction_w1],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_correction", "acpl_arty_correction_w"], _arty_correction_w5],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_correction", "acpl_arty_correction_w"], _arty_correction_w10],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_correction", "acpl_arty_correction_w"], _arty_correction_w50],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu", "acpl_arty_correction", "acpl_arty_correction_w"], _arty_correction_w100],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu"], _arty_checkammo],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu"], _arty_call],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu"], _arty_call_correction],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_arty_menu"], _arty_call_cancel],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				
				acpl_arty_done = acpl_arty_done + [_x];
				publicvariable "acpl_arty_done";
			};
			
			if (_x in acpl_radio_added) then {} else {
				[[(_x), 1, ["ACE_SelfActions"], _acpl_menu],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				
				[[(_x), 1, ["ACE_SelfActions", "acpl_menu"], _radio],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_menu","acpl_radio_menu"], _radio_lower_sw],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_menu","acpl_radio_menu"], _radio_onhead_sw],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_menu","acpl_radio_menu"], _radio_lower_lr],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_menu","acpl_radio_menu"], _radio_onhead_lr],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 0, ["ACE_MainActions"], _radio_2],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 0, ["ACE_MainActions","acpl_radio_menu_2"], _radio_ask_sw],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 0, ["ACE_MainActions","acpl_radio_menu_2"], _radio_ask_lr],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_menu","acpl_radio_menu"], _radio_asked_sw],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_menu","acpl_radio_menu"], _radio_asked_lr],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_menu","acpl_radio_menu"], _radio_return_sw],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions", "acpl_menu","acpl_radio_menu"], _radio_return_lr],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				_x setvariable ["acpl_radio_lower_sw",false,true];
				_x setvariable ["acpl_radio_volume_sw",100,true];
				_x setvariable ["acpl_radio_lower_lr",false,true];
				_x setvariable ["acpl_radio_volume_lr",100,true];
				_x setVariable ["acpl_radio_asked_sw",false,true];
				_x setVariable ["acpl_radio_asked_lr",false,true];
				_x setVariable ["acpl_radio_asked_sw_class",nil,true];
				_x setVariable ["acpl_radio_asked_lr_class",nil,true];
				_x setVariable ["acpl_radio_asked_sw_target",nil,true];
				_x setVariable ["acpl_radio_asked_lr_target",nil,true];
				_x setVariable ["acpl_radio_asked_sw_owner",nil,true];
				_x setVariable ["acpl_radio_asked_lr_owner",nil,true];
				_x setVariable ["acpl_radio_borrowed_sw",false,true];
				_x setVariable ["acpl_radio_borrowed_lr",false,true];
				_x setVariable ["acpl_radio_settings_sw",nil,true];
				_x setVariable ["acpl_radio_settings_lr",nil,true];
				
				[[(_x), 0, ["ACE_MainActions"], _hidebody],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				
				acpl_radio_added = acpl_radio_added + [_x];
				publicvariable "acpl_radio_added";
			};
			if ((_x in acpl_msc_done) AND acpl_msc) then {} else {
				if (_x in acpl_msc_exception) then {
					acpl_msc_done = acpl_msc_done + [_x];
					publicvariable "acpl_msc_done";
				} else {
					if (side _x == WEST) then {
						[_x] spawn {
							private ["_acc", "_shake", "_speed", "_spot", "_time", "_general", "_courage", "_reload", "_x"];
							
							_x = _this select 0;
							
							_acc = random [(acpl_msc_west_acc select 0),acpl_msc_west_acc_mid,(acpl_msc_west_acc select 1)];
							_shake = random [(acpl_msc_west_shake select 0),acpl_msc_west_shake_mid,(acpl_msc_west_shake select 1)];
							_speed = random [(acpl_msc_west_speed select 0),acpl_msc_west_speed_mid,(acpl_msc_west_speed select 1)];
							_spot = random [(acpl_msc_west_spot select 0),acpl_msc_west_spot_mid,(acpl_msc_west_spot select 1)];
							_time = random [(acpl_msc_west_time select 0),acpl_msc_west_time_mid,(acpl_msc_west_time select 1)];
							_general = random [(acpl_msc_west_general select 0),acpl_msc_west_general_mid,(acpl_msc_west_general select 1)];
							_courage = random [(acpl_msc_west_courage select 0),acpl_msc_west_courage_mid,(acpl_msc_west_courage select 1)];
							_reload = random [(acpl_msc_west_reload select 0),acpl_msc_west_reload_mid,(acpl_msc_west_reload select 1)];
							
							sleep 5;
							
							_x setSkill ["aimingAccuracy", _acc];
							_x setVariable ["acpl_msc_AimAcc", _acc, true];
							_x setSkill ["aimingShake", _shake];
							_x setVariable ["acpl_msc_AimSha", _shake, true];
							_x setSkill ["aimingSpeed", _speed];
							_x setVariable ["acpl_msc_AimSpe", _speed, true];
							_x setSkill ["spotDistance", _spot];
							_x setVariable ["acpl_msc_SpoDis", _spot, true];
							_x setSkill ["spotTime", _time];
							_x setVariable ["acpl_msc_SpoTim", _time, true];
							_x setSkill ["general", _general];
							_x setVariable ["acpl_msc_Gen", _general, true];
							_x setSkill ["courage", _courage];
							_x setVariable ["acpl_msc_Cou", _courage, true];
							_x setSkill ["reloadSpeed", _reload];
							_x setVariable ["acpl_msc_Rel", _reload, true];
							
							acpl_msc_done = acpl_msc_done + [_x];
							publicvariable "acpl_msc_done";
							
							if (acpl_msc_debug) then {["Skill change: Done " + str(_x)] remoteExec ["systemchat",0];};
						};
					};
					if (side _x == EAST) then {
						[_x] spawn {
							private ["_acc", "_shake", "_speed", "_spot", "_time", "_general", "_courage", "_reload"];
							
							_x = _this select 0;
							
							_acc = random [(acpl_msc_east_acc select 0),acpl_msc_east_acc_mid,(acpl_msc_east_acc select 1)];
							_shake = random [(acpl_msc_east_shake select 0),acpl_msc_east_shake_mid,(acpl_msc_east_shake select 1)];
							_speed = random [(acpl_msc_east_speed select 0),acpl_msc_east_speed_mid,(acpl_msc_east_speed select 1)];
							_spot = random [(acpl_msc_east_spot select 0),acpl_msc_east_spot_mid,(acpl_msc_east_spot select 1)];
							_time = random [(acpl_msc_east_time select 0),acpl_msc_east_time_mid,(acpl_msc_east_time select 1)];
							_general = random [(acpl_msc_east_general select 0),acpl_msc_east_general_mid,(acpl_msc_east_general select 1)];
							_courage = random [(acpl_msc_east_courage select 0),acpl_msc_east_courage_mid,(acpl_msc_east_courage select 1)];
							_reload = random [(acpl_msc_east_reload select 0),acpl_msc_east_reload_mid,(acpl_msc_east_reload select 1)];
							
							sleep 5;
							
							_x setSkill ["aimingAccuracy", _acc];
							_x setVariable ["acpl_msc_AimAcc", _acc, true];
							_x setSkill ["aimingShake", _shake];
							_x setVariable ["acpl_msc_AimSha", _shake, true];
							_x setSkill ["aimingSpeed", _speed];
							_x setVariable ["acpl_msc_AimSpe", _speed, true];
							_x setSkill ["spotDistance", _spot];
							_x setVariable ["acpl_msc_SpoDis", _spot, true];
							_x setSkill ["spotTime", _time];
							_x setVariable ["acpl_msc_SpoTim", _time, true];
							_x setSkill ["general", _general];
							_x setVariable ["acpl_msc_Gen", _general, true];
							_x setSkill ["courage", _courage];
							_x setVariable ["acpl_msc_Cou", _courage, true];
							_x setSkill ["reloadSpeed", _reload];
							_x setVariable ["acpl_msc_Rel", _reload, true];
							
							acpl_msc_done = acpl_msc_done + [_x];
							publicvariable "acpl_msc_done";
							
							if (acpl_msc_debug) then {["Skill change: Done " + str(_x)] remoteExec ["systemchat",0];};
						};
					};
					if (side _x == resistance) then {
						[_x] spawn {
							private ["_acc", "_shake", "_speed", "_spot", "_time", "_general", "_courage", "_reload"];
							
							_x = _this select 0;
							
							_acc = random [(acpl_msc_resistance_acc select 0),acpl_msc_resistance_acc_mid,(acpl_msc_resistance_acc select 1)];
							_shake = random [(acpl_msc_resistance_shake select 0),acpl_msc_resistance_shake_mid,(acpl_msc_resistance_shake select 1)];
							_speed = random [(acpl_msc_resistance_speed select 0),acpl_msc_resistance_speed_mid,(acpl_msc_resistance_speed select 1)];
							_spot = random [(acpl_msc_resistance_spot select 0),acpl_msc_resistance_spot_mid,(acpl_msc_resistance_spot select 1)];
							_time = random [(acpl_msc_resistance_time select 0),acpl_msc_resistance_time_mid,(acpl_msc_resistance_time select 1)];
							_general = random [(acpl_msc_resistance_general select 0),acpl_msc_resistance_general_mid,(acpl_msc_resistance_general select 1)];
							_courage = random [(acpl_msc_resistance_courage select 0),acpl_msc_resistance_courage_mid,(acpl_msc_resistance_courage select 1)];
							_reload = random [(acpl_msc_resistance_reload select 0),acpl_msc_resistance_reload_mid,(acpl_msc_resistance_reload select 1)];
							
							sleep 5;
							
							_x setSkill ["aimingAccuracy", _acc];
							_x setVariable ["acpl_msc_AimAcc", _acc, true];
							_x setSkill ["aimingShake", _shake];
							_x setVariable ["acpl_msc_AimSha", _shake, true];
							_x setSkill ["aimingSpeed", _speed];
							_x setVariable ["acpl_msc_AimSpe", _speed, true];
							_x setSkill ["spotDistance", _spot];
							_x setVariable ["acpl_msc_SpoDis", _spot, true];
							_x setSkill ["spotTime", _time];
							_x setVariable ["acpl_msc_SpoTim", _time, true];
							_x setSkill ["general", _general];
							_x setVariable ["acpl_msc_Gen", _general, true];
							_x setSkill ["courage", _courage];
							_x setVariable ["acpl_msc_Cou", _courage, true];
							_x setSkill ["reloadSpeed", _reload];
							_x setVariable ["acpl_msc_Rel", _reload, true];
							
							acpl_msc_done = acpl_msc_done + [_x];
							publicvariable "acpl_msc_done";
							
							if (acpl_msc_debug) then {["Skill change: Done " + str(_x)] remoteExec ["systemchat",0];};
						};
					};
				};
			};
			if (acpl_medical AND !(_x in acpl_medical_done) AND !(_x in acpl_medical_mc) AND !(_x in acpl_medical_exep)) then {
				if (_x in _playable) then {
					private ["_medic"];
					
					[_x] call acpl_medic_remove;
		
					_medic = [_x] call ace_medical_fnc_isMedic;
					
					if (_medic) then {
						for "_i" from 1 to acpl_fieldDressing_med do {[_x,"ACE_fieldDressing"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_elasticBandage_med do {[_x,"ACE_elasticBandage"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_adenosine_med do {[_x,"ACE_adenosine"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_atropine_med do {[_x,"ACE_atropine"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_bloodIV_250_med do {[_x,"ACE_bloodIV_250"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_epinephrine_med do {[_x,"ACE_epinephrine"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_morphine_med do {[_x,"ACE_morphine"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_packingBandage_med do {[_x,"ACE_packingBandage"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_personalAidKit_med do {[_x,"ACE_personalAidKit"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_plasmaIV_med do {[_x,"ACE_plasmaIV"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_plasmaIV_250_med do {[_x,"ACE_plasmaIV_250"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_plasmaIV_500_med do {[_x,"ACE_plasmaIV_500"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_salineIV_med do {[_x,"ACE_salineIV"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_salineIV_250_med do {[_x,"ACE_salineIV_250"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_salineIV_500_med do {[_x,"ACE_salineIV_500"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_surgicalKit_med do {[_x,"ACE_surgicalKit"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_tourniquet_med do {[_x,"ACE_fieldDressing"] remoteExec ["additem",_x];};
					} else {
						for "_i" from 1 to acpl_fieldDressing_sol do {[_x,"ACE_fieldDressing"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_elasticBandage_sol do {[_x,"ACE_elasticBandage"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_adenosine_sol do {[_x,"ACE_adenosine"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_atropine_sol do {[_x,"ACE_atropine"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_epinephrine_sol do {[_x,"ACE_epinephrine"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_morphine_sol do {[_x,"ACE_morphine"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_packingBandage_sol do {[_x,"ACE_packingBandage"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_personalAidKit_sol do {[_x,"ACE_personalAidKit"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_tourniquet_sol do {[_x,"ace_tourniquet"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_plasmaIV_500_sol do {[_x,"ACE_plasmaIV_500"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_salineIV_500_sol do {[_x,"ACE_salineIV_500"] remoteExec ["additem",_x];};
					};
					acpl_medical_done = acpl_medical_done + [_x];
					publicvariable "acpl_medical_done";
				} else {
					if (acpl_medical_AI) then {
						private ["_medic"];
						
						[_x] call acpl_medic_remove;
						
						_medic = [_x] call ace_medical_fnc_isMedic;
						
						if (_medic) then {
							for "_i" from 1 to acpl_fieldDressing_med_AI do {[_x,"ACE_fieldDressing"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_elasticBandage_med_AI do {[_x,"ACE_elasticBandage"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_adenosine_med_AI do {[_x,"ACE_adenosine"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_atropine_med_AI do {[_x,"ACE_atropine"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_bloodIV_250_med_AI do {[_x,"ACE_bloodIV_250"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_epinephrine_med_AI do {[_x,"ACE_epinephrine"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_morphine_med_AI do {[_x,"ACE_morphine"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_packingBandage_med_AI do {[_x,"ACE_packingBandage"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_personalAidKit_med_AI do {[_x,"ACE_personalAidKit"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_plasmaIV_med_AI do {[_x,"ACE_plasmaIV"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_plasmaIV_250_med_AI do {[_x,"ACE_plasmaIV_250"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_plasmaIV_500_med_AI do {[_x,"ACE_plasmaIV_500"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_salineIV_med_AI do {[_x,"ACE_salineIV"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_salineIV_250_med_AI do {[_x,"ACE_salineIV_250"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_salineIV_500_med_AI do {[_x,"ACE_salineIV_500"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_surgicalKit_med_AI do {[_x,"ACE_surgicalKit"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_tourniquet_med_AI do {[_x,"ace_tourniquet"] remoteExec ["additem",_x];};
						} else {
							for "_i" from 1 to acpl_fieldDressing_AI do {[_x,"ACE_fieldDressing"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_elasticBandage_AI do {[_x,"ACE_elasticBandage"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_adenosine_AI do {[_x,"ACE_adenosine"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_atropine_AI do {[_x,"ACE_atropine"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_epinephrine_AI do {[_x,"ACE_epinephrine"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_morphine_AI do {[_x,"ACE_morphine"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_packingBandage_AI do {[_x,"ACE_packingBandage"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_personalAidKit_AI do {[_x,"ACE_personalAidKit"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_tourniquet_AI do {[_x,"ace_tourniquet"] remoteExec ["additem",_x];};
						};
						acpl_medical_done = acpl_medical_done + [_x];
						publicvariable "acpl_medical_done";
					};
				};
			};
			if (!(_x in acpl_static_done) AND _static) then {
				private ["_action"];
				
				{[_x,"move"] remoteExec ["disableAI",0];} foreach _playable;
				
				_action = ["acpl_ai_action", "Odblokuj AI", "acpl_icons\run.paa", {{[_x,"move"] remoteExec ["enableAI",0];} foreach (units (group _player));hint "Odblokowałeś AI w swojej grupie";}, {_player == leader (group _player)}] call ace_interact_menu_fnc_createAction;
				[[(_x), 1, ["ACE_SelfActions", "acpl_menu"], _action],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				
				acpl_static_done = acpl_static_done + [_x];
				publicvariable "acpl_static_done";
			};
		} foreach allunits;
		
		sleep 5;
		if (!(acpl_mainloop_done)) then {
			acpl_mainloop_done = true;
			publicvariable "acpl_mainloop_done";
		};
	};
};
publicvariable "acpl_loop";

acpl_loop_fncs = true;
publicvariable "acpl_loop_fncs";

if (acpl_fnc_debug) then {["ACPL FNCS LOOP LOADED"] remoteExec ["systemchat",0];};
