private ["_unit","_grps","_action"];

_unit = _this select 0;
_grps = _this select 1;

if (!isserver) exitwith {};

//_nul = [_unit,[_grps]] execVM "acpl_fncs\HC_takecontrol.sqf";
//v1.1

acpl_hc_unit = _unit;
acpl_hc_groups = _grps;
publicvariable "acpl_hc_unit";
publicvariable "acpl_hc_groups";

{[_unit,[_x]] remoteExec ["hcSetGroup",0];} foreach _grps;

_action = ["acpl_hc_action", "Take HC Command", "", {[acpl_hc_unit] remoteExec ["hcRemoveAllGroups",0];{[_player,[_x]] remoteExec ["hcSetGroup",0];} foreach acpl_hc_groups;acpl_hc_unit = _player;publicvariable "acpl_hc_unit";hint "Przejąłeś kontrole nad HC";}, {true}] call ace_interact_menu_fnc_createAction;
{[[(_x), 1, ["ACE_SelfActions"], _action],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];} foreach allunits;