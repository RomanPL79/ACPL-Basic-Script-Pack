private ["_unit", "_ammo", "_name", "_mags"];

if (!isserver) exitwith {};

//_nul = [this,[["he","",1],["smoke","",1]],"Name"] execVM "acpl_fncs\acpl_arty_addbattery.sqf";
//v1.0

waitUntil {acpl_fncs_initied};

waitUntil {acpl_mainloop_done};

_unit = _this select 0;
_ammo = _this select 1;
if (isNil {_this select 2}) then {_name = groupId (group (gunner _unit));} else {_name = _this select 2;};

(group (gunner _unit)) setVariable ["Vcm_Disable",true,true];
(group (gunner _unit)) setVariable ["VCOM_NOAI",true,true];

_side = side (gunner _unit);

(group (gunner _unit)) setCombatMode "BLUE";

_action = ["acpl_arty_battery_action", _name, "acpl_icons\arty.paa", {
	params ["_target", "_player", "_params"];
	_player setvariable ["acpl_arty_chosen",(_params select 0),true];
	hint ("Wybrano baterie: " + (_params select 2));
	_player setvariable ["acpl_arty_ammo","",true];
}, {(_player getvariable "acpl_arty_fo") AND (side _player == ((_this select 2) select 1))},{},[_unit, _side, _name]] call ace_interact_menu_fnc_createAction;

acpl_arty_bateries = acpl_arty_bateries + [[_unit, _action]];
publicvariable "acpl_arty_bateries";

_mags = magazines _unit;
{_unit removeMagazine _x;} foreach _mags;

[_unit,[(gunner (_unit)), (currentMuzzle (gunner _unit)), 0.01]] remoteExec ["setWeaponReloadingTime",0];
_unit setWeaponReloadingTime [(gunner (_unit)), (currentMuzzle (gunner _unit)), 0.01];

_unit setVariable ["acpl_arty_battery_busy",false,true];
_unit setVariable ["acpl_arty_battery_name",_name,true];
_unit setVariable ["acpl_arty_markers",[],true];
_unit setvariable ["acpl_arty_fired",false,true];

if (_name != groupId (group (gunner _unit))) then {[(group (gunner _unit)),[_name]] remoteExec ["setGroupIdGlobal",0];};

_unit setVariable ["acpl_arty_he",false,true];
_unit setVariable ["acpl_arty_he_class","",true];
_unit setVariable ["acpl_arty_he_rounds",0,true];

_unit setVariable ["acpl_arty_lg",false,true];
_unit setVariable ["acpl_arty_lg_class","",true];
_unit setVariable ["acpl_arty_lg_rounds",0,true];

_unit setVariable ["acpl_arty_smoke",false,true];
_unit setVariable ["acpl_arty_smoke_class","",true];
_unit setVariable ["acpl_arty_smoke_rounds",0,true];

_unit setVariable ["acpl_arty_mine",false,true];
_unit setVariable ["acpl_arty_mine_class","",true];
_unit setVariable ["acpl_arty_mine_rounds",0,true];

_unit setVariable ["acpl_arty_atmine",false,true];
_unit setVariable ["acpl_arty_atmine_class","",true];
_unit setVariable ["acpl_arty_atmine_rounds",0,true];

_unit setVariable ["acpl_arty_guided",false,true];
_unit setVariable ["acpl_arty_guided_class","",true];
_unit setVariable ["acpl_arty_guided_rounds",0,true];

_unit setVariable ["acpl_arty_flare",false,true];
_unit setVariable ["acpl_arty_flare_class","",true];
_unit setVariable ["acpl_arty_flare_rounds",0,true];

_unit setVariable ["acpl_arty_cluster",false,true];
_unit setVariable ["acpl_arty_cluster_class","",true];
_unit setVariable ["acpl_arty_cluster_rounds",0,true];

{
	private ["_v0"];
	
	_v0 = _x select 0;
	_v0 = toLower(_v0);
	if (_v0 == "he") then {
		_unit setVariable ["acpl_arty_he",true,true];
		_unit setVariable ["acpl_arty_he_class",(_x select 1),true];
		_unit setVariable ["acpl_arty_he_rounds",(_x select 2),true];
		for "_i" from 1 to (_x select 2) do {[_unit,[(_x select 1),1]] remoteExec ["addmagazine",_unit];};
	};
	if (_v0 == "lg") then {
		_unit setVariable ["acpl_arty_lg",true,true];
		_unit setVariable ["acpl_arty_lg_class",(_x select 1),true];
		_unit setVariable ["acpl_arty_lg_rounds",(_x select 2),true];
		for "_i" from 1 to (_x select 2) do {[_unit,[(_x select 1),1]] remoteExec ["addmagazine",_unit];};
	};
	if (_v0 == "smoke") then {
		_unit setVariable ["acpl_arty_smoke",true,true];
		_unit setVariable ["acpl_arty_smoke_class",(_x select 1),true];
		_unit setVariable ["acpl_arty_smoke_rounds",(_x select 2),true];
		for "_i" from 1 to (_x select 2) do {[_unit,[(_x select 1),1]] remoteExec ["addmagazine",_unit];};
	};
	if (_v0 == "mine") then {
		_unit setVariable ["acpl_arty_mine",true,true];
		_unit setVariable ["acpl_arty_mine_class",(_x select 1),true];
		_unit setVariable ["acpl_arty_mine_rounds",(_x select 2),true];
		for "_i" from 1 to (_x select 2) do {[_unit,[(_x select 1),1]] remoteExec ["addmagazine",_unit];};
	};
	if (_v0 == "atmine") then {
		_unit setVariable ["acpl_arty_atmine",true,true];
		_unit setVariable ["acpl_arty_atmine_class",(_x select 1),true];
		_unit setVariable ["acpl_arty_atmine_rounds",(_x select 2),true];
		for "_i" from 1 to (_x select 2) do {[_unit,[(_x select 1),1]] remoteExec ["addmagazine",_unit];};
	};
	if (_v0 == "guided") then {
		_unit setVariable ["acpl_arty_guided",true,true];
		_unit setVariable ["acpl_arty_guided_class",(_x select 1),true];
		_unit setVariable ["acpl_arty_guided_rounds",(_x select 2),true];
		for "_i" from 1 to (_x select 2) do {[_unit,[(_x select 1),1]] remoteExec ["addmagazine",_unit];};
	};
	if (_v0 == "flare") then {
		_unit setVariable ["acpl_arty_flare",true,true];
		_unit setVariable ["acpl_arty_flare_class",(_x select 1),true];
		_unit setVariable ["acpl_arty_flare_rounds",(_x select 2),true];
		for "_i" from 1 to (_x select 2) do {[_unit,[(_x select 1),1]] remoteExec ["addmagazine",_unit];};
	};
	if (_v0 == "cluster") then {
		_unit setVariable ["acpl_arty_cluster",true,true];
		_unit setVariable ["acpl_arty_cluster_class",(_x select 1),true];
		_unit setVariable ["acpl_arty_cluster_rounds",(_x select 2),true];
		for "_i" from 1 to (_x select 2) do {[_unit,[(_x select 1),1]] remoteExec ["addmagazine",_unit];};
	};
} foreach _ammo;

_unit addEventHandler ["Fired", {
	params ["_unit"];
	
	_unit setvariable ["acpl_arty_fired",true,true];
	(group (gunner _unit)) setCombatMode "BLUE";
}];