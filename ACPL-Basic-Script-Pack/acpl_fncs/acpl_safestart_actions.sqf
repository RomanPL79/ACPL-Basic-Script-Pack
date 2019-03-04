private ["_unit","_timechange","_rozpocznij"];

_unit = _this select 0;
_timechange = _this select 1;

if (!isserver) exitwith {};

if (isNil "acpl_safestart_inited") then {acpl_safestart_inited = false};

waitUntil {acpl_safestart_inited};

//_nul = [this,true] execVM "acpl_fncs\acpl_safestart_actions.sqf";
//v1.0

_rozpocznij = ["acpl_safestart_rozpocznij", "Rozpocznij misje", "", {[[],acpl_safestart_startmission] remoteExec ["spawn",2];}, {acpl_safestart}] call ace_interact_menu_fnc_createAction;

[[_unit, 0, ["ACE_MainActions"], _rozpocznij],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
if (_timechange) then {
	private ["_czas_menu","_czas_1h","_czas_2h","_czas_4h","_czas_8h","_czas_12h"];
	
	_czas_menu = ["acpl_safestart_czas_menu", "Poczekaj...", "", {}, {acpl_safestart}] call ace_interact_menu_fnc_createAction;
	_czas_1h = ["acpl_safestart_czas_1h", "Godzinę", "", {[[1],acpl_safestart_wait] remoteExec ["call",2];}, {acpl_safestart}] call ace_interact_menu_fnc_createAction;
	_czas_2h = ["acpl_safestart_czas_2h", "2 Godziny", "", {[[2],acpl_safestart_wait] remoteExec ["call",2];}, {acpl_safestart}] call ace_interact_menu_fnc_createAction;
	_czas_4h = ["acpl_safestart_czas_4h", "4 Godziny", "", {[[4],acpl_safestart_wait] remoteExec ["call",2];}, {acpl_safestart}] call ace_interact_menu_fnc_createAction;
	_czas_8h = ["acpl_safestart_czas_8h", "8 Godzin", "", {[[8],acpl_safestart_wait] remoteExec ["call",2];}, {acpl_safestart}] call ace_interact_menu_fnc_createAction;
	_czas_12h = ["acpl_safestart_czas_12h", "12 Godzin", "", {[[12],acpl_safestart_wait] remoteExec ["call",2];}, {acpl_safestart}] call ace_interact_menu_fnc_createAction;
	
	[[_unit, 0, ["ACE_MainActions"], _czas_menu],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
	[[_unit, 0, ["ACE_MainActions", "acpl_safestart_czas_menu"], _czas_1h],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
	[[_unit, 0, ["ACE_MainActions", "acpl_safestart_czas_menu"], _czas_2h],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
	[[_unit, 0, ["ACE_MainActions", "acpl_safestart_czas_menu"], _czas_4h],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
	[[_unit, 0, ["ACE_MainActions", "acpl_safestart_czas_menu"], _czas_8h],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
	[[_unit, 0, ["ACE_MainActions", "acpl_safestart_czas_menu"], _czas_12h],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
};
