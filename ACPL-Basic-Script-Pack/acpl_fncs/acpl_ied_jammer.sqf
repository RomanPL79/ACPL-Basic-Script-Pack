private ["_unit","_type","_activated","_acpl_ied_jammer_menu"];

_unit = _this select 0;
_type = _this select 1;
_activated = _this select 2;

if (!isserver) exitwith {};

//_nul = [this,["phone","clacker"],false] execVM "acpl_fncs\acpl_ied_jammer.sqf";
//1.0

if (isNil "acpl_fncs_initied") then {acpl_fncs_initied = false};

waitUntil {acpl_fncs_initied};

_acpl_ied_jammer_menu = ["acpl_ied_jammer_menu", "IED Jammer", "", {}, {true}] call ace_interact_menu_fnc_createAction;

[[_unit, 1, ["ACE_SelfActions"], _acpl_ied_jammer_menu],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];

_unit setvariable ["acpl_ied_jammer",[],true];
_unit setvariable ["acpl_ied_phone_jammer_active",false,true];
_unit setvariable ["acpl_ied_clacker_jammer_active",false,true];

if (("phone" in _type) OR ("PHONE" in _type) OR ("Phone" in _type)) then {
	private ["_acpl_ied_jammer_menu_phone","_acpl_ied_jammer_menu_phone_on","_acpl_ied_jammer_menu_phone_off"];
	
	_acpl_ied_jammer_menu_phone = ["acpl_ied_jammer_menu_phone", "GSM Signal Jammer", "", {}, {true}] call ace_interact_menu_fnc_createAction;
	_acpl_ied_jammer_menu_phone_on = ["aacpl_ied_jammer_menu_phone_on", "Turn On", "", {_target setvariable ["acpl_ied_phone_jammer_active",true,true];hint "You just activated GSM jammer";}, {!(_target getvariable "acpl_ied_phone_jammer_active")}] call ace_interact_menu_fnc_createAction;
	_acpl_ied_jammer_menu_phone_off = ["acpl_ied_jammer_menu_phone_off", "Turn Off", "", {_target setvariable ["acpl_ied_phone_jammer_active",false,true];hint "You just deactivated GSM jammer";}, {_target getvariable "acpl_ied_phone_jammer_active"}] call ace_interact_menu_fnc_createAction;
	
	_unit setvariable ["acpl_ied_jammer",(_unit getvariable "acpl_ied_jammer") + ["phone"],true];
	
	[[_unit, 1, ["ACE_SelfActions","acpl_ied_jammer_menu"], _acpl_ied_jammer_menu_phone],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
	[[_unit, 1, ["ACE_SelfActions","acpl_ied_jammer_menu","acpl_ied_jammer_menu_phone"], _acpl_ied_jammer_menu_phone_on],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
	[[_unit, 1, ["ACE_SelfActions","acpl_ied_jammer_menu","acpl_ied_jammer_menu_phone"], _acpl_ied_jammer_menu_phone_off],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
	
	if (_activated) then {
		_unit setvariable ["acpl_ied_phone_jammer_active",true,true];
	};
};

if (("clacker" in _type) OR ("CLACKER" in _type) OR ("Clacker" in _type)) then {
	private ["_acpl_ied_jammer_menu_clacker","_acpl_ied_jammer_menu_clacker_on","_acpl_ied_jammer_menu_clacker_off"];
	
	_acpl_ied_jammer_menu_clacker = ["acpl_ied_jammer_menu_clacker", "Radio Signal Jammer", "", {}, {true}] call ace_interact_menu_fnc_createAction;
	_acpl_ied_jammer_menu_clacker_on = ["acpl_ied_jammer_menu_clacker_on", "Turn On", "", {_target setvariable ["acpl_ied_clacker_jammer_active",true,true];hint "You just activated Radio jammer";}, {!(_target getvariable "acpl_ied_clacker_jammer_active")}] call ace_interact_menu_fnc_createAction;
	_acpl_ied_jammer_menu_clacker_off = ["acpl_ied_jammer_menu_clacker_off", "Turn Off", "", {_target setvariable ["acpl_ied_clacker_jammer_active",false,true];hint "You just deactivated Radio jammer";}, {_target getvariable "acpl_ied_clacker_jammer_active"}] call ace_interact_menu_fnc_createAction;
	
	_unit setvariable ["acpl_ied_jammer",(_unit getvariable "acpl_ied_jammer") + ["clacker"],true];
	
	[[_unit, 1, ["ACE_SelfActions","acpl_ied_jammer_menu"], _acpl_ied_jammer_menu_clacker],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
	[[_unit, 1, ["ACE_SelfActions","acpl_ied_jammer_menu","acpl_ied_jammer_menu_clacker"], _acpl_ied_jammer_menu_clacker_on],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
	[[_unit, 1, ["ACE_SelfActions","acpl_ied_jammer_menu","acpl_ied_jammer_menu_clacker"], _acpl_ied_jammer_menu_clacker_off],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
	
	if (_activated) then {
		_unit setvariable ["acpl_ied_clacker_jammer_active",true,true];
	};
};

acpl_ied_jammers = acpl_ied_jammers + [_unit];
publicvariable "acpl_ied_jammers";
