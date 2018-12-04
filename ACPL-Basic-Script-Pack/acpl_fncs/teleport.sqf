params ["_entrance", "_pos1", "_exit", "_pos2"];
private ["_act1", "_act2"];

if (!isserver) exitwith {};

//_nul = [_entrance, _teleport_from_entrance_pos, _exit, _teleport_from_exit_pos] execVM "acpl_fncs\teleport.sqf";
//v1.0

_act1 = ["acpl_action1", "Wejdź", "acpl_icons\entrance.paa", {
	params ["_target", "_player", "_params"];
	_params params ["_pos"];
	
	[_player, _pos] remoteExec ["setpos",_player];
}, {true},{},[_pos1]] call ace_interact_menu_fnc_createAction;
_act2 = ["acpl_action2", "Wyjdź", "acpl_icons\exit.paa", {
	params ["_target", "_player", "_params"];
	_params params ["_pos"];
	
	[_player, _pos] remoteExec ["setpos",_player];
}, {true},{},[_pos2]] call ace_interact_menu_fnc_createAction;

[[_entrance, 0, ["ACE_MainActions"], _act1],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
[[_exit, 0, ["ACE_MainActions"], _act2],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];