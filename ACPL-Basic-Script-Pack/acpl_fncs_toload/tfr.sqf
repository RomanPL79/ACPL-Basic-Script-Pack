if (!isserver) exitwith {};

acpl_tfr_check_swradio = {
	private ["_return","_unit"];
	
	_unit = _this select 0;
	_return = false;
	if (isNil {_unit} OR {isNull (_unit)}) exitWith{false};
	{
		if (_x call TFAR_fnc_isRadio) exitWith {_return = true};
		true;
	} count (assignedItems _unit);
	
	_return
};
publicvariable "acpl_tfr_check_swradio";

acpl_tfr_check_lrradio = {
	private ["_return","_unit"];
	
	_unit = _this select 0;
	_return = false;
	
	if (isNil {_unit} OR {isNull (_unit)}) exitWith{false};
	if (count (_unit call TFAR_fnc_lrRadiosList) > 0) then {_return = true;};
	
	_return
};
publicvariable "acpl_tfr_check_lrradio";

acpl_tfr_class_swradio = {
	private ["_return","_unit"];
	
	_unit = _this select 0;
	
	_return = nil;
	{	
		if (_x call TFAR_fnc_isRadio) exitWith {_return = _x};
		true;
	} count (assignedItems _unit);
	
	_return
};
publicvariable "acpl_tfr_class_swradio";

acpl_tfr_giveradio_sw = {
	private ["_owner","_caller","_radio_o","_radio_c","_settings_o","_settings_c"];
	
	_owner = _this select 0;
	_caller = _owner getVariable "acpl_radio_asked_sw_target";
	_radio_o = [_owner] call acpl_tfr_class_swradio;
	_radio_c = [_caller] call acpl_tfr_class_swradio;
	_settings_c = _radio_c call TFAR_fnc_getSwSettings;
	_settings_o = _radio_o call TFAR_fnc_getSwSettings;
	
	_owner setVariable ["acpl_radio_asked_sw_class",_radio_o,true];
	_caller setVariable ["acpl_radio_asked_sw_class",_radio_c,true];
	_owner setVariable ["acpl_radio_asked_sw",false,true];
	_owner setVariable ["acpl_radio_asked_sw_target",_caller,true];
	_caller setVariable ["acpl_radio_asked_sw_owner",_owner,true];
	_owner setVariable ["acpl_radio_borrowed_sw",true,true];
	_caller setVariable ["acpl_radio_borrowed_sw",true,true];
	_caller setVariable ["acpl_radio_settings_sw",_settings_c,true];
	_owner setVariable ["acpl_radio_settings_sw",_settings_o,true];
	
	if (!(isNil "_radio_c")) then {[_caller, _radio_c] remoteExec ["unlinkItem",_caller];};
	[_caller, _radio_o] remoteExec ["linkItem",_caller];
	[_radio_o, _settings_o] call TFAR_fnc_setSwSettings;
	[_owner, _radio_o] remoteExec ["unlinkItem",_owner];
	["Podałeś radio"] remoteExec ["hint",_caller];
	["Podano ci radio"] remoteExec ["hint",_owner];
	
	[_owner, _caller] spawn {
		private ["_owner","_caller"];
		
		_owner = _this select 0;
		_caller = _this select 1;
		
		while {_owner getVariable "acpl_radio_borrowed_sw"} do {
			if (_owner distance _caller > 2.5) then {
				[[_caller],acpl_tfr_giveback_sw] remoteExec ["call",2];
				["Odszedłeś zbyt daleko!"] remoteExec ["systemchat",_caller];
			};
			if (!(alive _owner)) then {
				[[_caller],acpl_tfr_giveback_sw] remoteExec ["call",2];
				["Właściciel został zabity!"] remoteExec ["systemchat",_caller];
			};
			if (!(alive _caller)) then {
				[[_caller],acpl_tfr_giveback_sw] remoteExec ["call",2];
				["Pożyczający został zabity!"] remoteExec ["systemchat",_caller];
			};
			sleep 1;
		};
	};
};
publicvariable "acpl_tfr_giveradio_sw";

acpl_tfr_giveback_sw = {
	private ["_owner","_caller","_radio_o","_radio_c","_settings_c","_settings_o"];
	
	_caller = _this select 0;
	_owner = _caller getVariable "acpl_radio_asked_sw_owner";
	_radio_c = _caller getVariable "acpl_radio_asked_sw_class";
	_radio_o = _owner getVariable "acpl_radio_asked_sw_class";
	_settings_c = _caller getVariable "acpl_radio_settings_sw";
	_settings_o = _owner getVariable "acpl_radio_settings_sw";
	
	_owner setVariable ["acpl_radio_asked_sw_class",Nil,true];
	_caller setVariable ["acpl_radio_asked_sw_class",Nil,true];
	_owner setVariable ["acpl_radio_asked_sw_target",Nil,true];
	_caller setVariable ["acpl_radio_asked_sw_owner",Nil,true];
	_owner setVariable ["acpl_radio_borrowed_sw",false,true];
	_caller setVariable ["acpl_radio_borrowed_sw",false,true];
	_caller setVariable ["acpl_radio_settings_sw",nil,true];
	_owner setVariable ["acpl_radio_settings_sw",nil,true];
	
	[_owner, _radio_o] remoteExec ["linkItem",_owner];
	[_radio_o, _settings_o] call TFAR_fnc_setSwSettings;
	[_caller, _radio_o] remoteExec ["unlinkItem",_caller];
	if (!(isNil "_radio_c")) then {
		[_caller, _radio_c] remoteExec ["linkItem",_caller];
		[_radio_c, _settings_c] call TFAR_fnc_setSwSettings;
	};
	["Oddano ci radio"] remoteExec ["hint",_owner];
	["Oddałeś radio"] remoteExec ["hint",_caller];
};
publicvariable "acpl_tfr_giveback_sw";

acpl_tfr_class_lrradio = {
	private ["_radios", "_found", "_unit", "_return"];
	
	_unit = _this select 0;
	_return = nil;
	
	_radios = _unit call TFAR_fnc_lrRadiosList;
	if (count _radios > 0) then {
		if (count _radios == 1) then {
			_return = _radios select 0;
		} else {
			_return = _radios select 0;
		};
	} else {
		_return = nil;
	};
	
	_return
};
publicvariable "acpl_tfr_class_lrradio";

acpl_tfr_giveradio_lr = {
	private ["_owner","_caller","_radio_o","_settings"];
	
	_owner = _this select 0;
	_caller = _owner getVariable "acpl_radio_asked_lr_target";
	_radio_o = [backpack _owner, backpackItems _owner];
	_settings = _radio_o call TFAR_fnc_getSwSettings;
	
	_owner setVariable ["acpl_radio_asked_lr_class",_radio_o,true];
	_owner setVariable ["acpl_radio_asked_lr",false,true];
	_owner setVariable ["acpl_radio_asked_lr_target",_caller,true];
	_caller setVariable ["acpl_radio_asked_lr_owner",_owner,true];
	_owner setVariable ["acpl_radio_borrowed_lr",true,true];
	_caller setVariable ["acpl_radio_borrowed_lr",true,true];
	_owner setVariable ["acpl_radio_settings_lr",_settings,true];
	
	if (backpack _caller != "") then {
		_caller setVariable ["acpl_radio_asked_lr_class",backpack _caller,true];
		[[_caller],zade_boc_fnc_actionOnChest] remoteExec ["call",_caller];
	};
	[_caller, (_radio_o select 0)] remoteExec ["addbackpack",_caller];
	{[_caller, _x] remoteExec ["additemtobackpack",_caller];} foreach (_radio_o select 1);
	[([_caller] call acpl_tfr_class_lrradio) select 0, ([_caller] call acpl_tfr_class_lrradio) select 1, _settings] call TFAR_fnc_setLrSettings;
	[_owner] remoteExec ["removebackpack",0];
	["Podałeś radio"] remoteExec ["hint",_caller];
	["Podano ci radio"] remoteExec ["hint",_owner];
	
	[_owner, _caller] spawn {
		private ["_owner","_caller"];
		
		_owner = _this select 0;
		_caller = _this select 1;
		
		while {_owner getVariable "acpl_radio_borrowed_lr"} do {
			if (_owner distance _caller > 2.5) then {
				[[_caller],acpl_tfr_giveback_lr] remoteExec ["call",2];
				["Odszedłeś zbyt daleko!"] remoteExec ["systemchat",_caller];
			};
			if (!(alive _owner)) then {
				[[_caller],acpl_tfr_giveback_lr] remoteExec ["call",2];
				["Właściciel został zabity!"] remoteExec ["systemchat",_caller];
			};
			if (!(alive _caller)) then {
				[[_caller],acpl_tfr_giveback_lr] remoteExec ["call",2];
				["Pożyczający został zabity!"] remoteExec ["systemchat",_caller];
			};
			sleep 1;
		};
	};
};
publicvariable "acpl_tfr_giveradio_lr";

acpl_tfr_giveback_lr = {
	private ["_owner","_caller","_radio_o","_radio_c","_backpack_c","_settings"];
	
	_caller = _this select 0;
	_owner = _caller getVariable "acpl_radio_asked_lr_owner";
	_radio_o = _owner getVariable "acpl_radio_asked_lr_class";
	_backpack_c = _caller getVariable "acpl_radio_asked_lr_class";
	_settings = _owner getVariable "acpl_radio_settings_lr";
	
	_owner setVariable ["acpl_radio_asked_lr_class",Nil,true];
	_caller setVariable ["acpl_radio_asked_lr_class",Nil,true];
	_owner setVariable ["acpl_radio_asked_lr_target",Nil,true];
	_caller setVariable ["acpl_radio_asked_lr_owner",Nil,true];
	_owner setVariable ["acpl_radio_borrowed_lr",false,true];
	_caller setVariable ["acpl_radio_borrowed_lr",false,true];
	_owner setVariable ["acpl_radio_settings_lr",nil,true];
	
	[_owner, (_radio_o select 0)] remoteExec ["addbackpack",_owner];
	{[_owner, _x] remoteExec ["additemtobackpack",_owner];} foreach (_radio_o select 1);
	[([_owner] call acpl_tfr_class_lrradio) select 0, ([_owner] call acpl_tfr_class_lrradio) select 1, _settings] call TFAR_fnc_setLrSettings;
	[_caller] remoteExec ["removebackpack",0];
	if (_backpack_c != "") then {
		[_caller] call zade_boc_fnc_actionOnBack;
	};
	["Oddano ci radio"] remoteExec ["hint",_owner];
	["Oddałeś radio"] remoteExec ["hint",_caller];
};
publicvariable "acpl_tfr_giveback_lr";

acpl_tfr_check_speakvolume = {
	private ["_unit","_volume","_volume_max"];
	
	_unit = _this select 0;
	_volume = TF_speak_volume_meters;
	_volume_max = TF_max_voice_volume;
	
	if (_unit getvariable "acpl_tfr_speakvolume" != _volume) then {_unit setVariable ["acpl_tfr_speakvolume",_volume,true];};
	if (_unit getvariable "acpl_tfr_speakvolume_max" != _volume_max) then {_unit setVariable ["acpl_tfr_speakvolume_max",_volume_max,true];};
};
publicvariable "acpl_tfr_check_speakvolume";

acpl_tfr_find_change = {
	private ["_unit","_var","_return"];
	
	_unit = _this select 0;
	_var = _this select 1;
	_return = [];
	
	if (count _var > 0) then {
		{
			if (_unit == _x select 0) then {_return = [_x]};
		} foreach _var;
	};
	
	_return
};
publicvariable "acpl_tfr_find_change";

acpl_tfr_check_change = {
	private ["_unit","_var","_return","_multipler","_knows"];
	
	_unit = _this select 0;
	_var = _this select 1;
	_multipler = _this select 2;
	_knows = _this select 3;
	_return = false;
	
	if (count _var > 0) then {
		{
			if ((_multipler > _x select 1) OR (_knows < _x select 2) OR (time >= (_x select 3) + acpl_tfr_time)) then {_return = true;};
		} foreach _var;
	};
	
	_return
};
publicvariable "acpl_tfr_check_change";

acpl_tfr_check_inlist = {
	private ["_unit","_var","_return"];
	
	_unit = _this select 0;
	_var = _this select 1;
	_return = false;
	
	if (count _var > 0) then {
		{
			if (_unit == _x select 0) then {_return = true};
		} foreach _var;
	};
	
	_return
};
publicvariable "acpl_tfr_check_inlist";

acpl_tfr_fncs = true;
publicvariable "acpl_tfr_fncs";

if (acpl_fnc_debug) then {["ACPL FNCS TFR LOADED"] remoteExec ["systemchat",0];};
