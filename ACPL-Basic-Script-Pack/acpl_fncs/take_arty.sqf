private ["_arty","_group","_action"];

_arty = _this select 0;
_group = _this select 1;

if (!isserver) exitwith {};

//_nul = [[_arty1,_arty2],_grp] execVM "acpl_fncs\take_arty.sqf";
//v1.1

acpl_arty_units = [];
{acpl_arty_units = acpl_arty_units + (crew _x);} foreach _arty;
publicvariable "acpl_arty_units";

acpl_arty_units joinSilent _group;

_action = ["acpl_arty_action", "Take Command over Artillery", "", {acpl_arty_units joinSilent (group _player);hint "Przej¹³eœ kontrole nad artyleri¹";}, {_player == leader (group _player)}] call ace_interact_menu_fnc_createAction;
{[[(_x), 1, ["ACE_SelfActions"], _action],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];} foreach allunits;