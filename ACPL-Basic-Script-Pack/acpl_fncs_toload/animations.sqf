if (!isserver) exitwith {};

acpl_play_anim = {
	private ["_params", "_anims", "_azimutFix", "_attachSnap", "_attachOffset", "_attachObj", "_attachSpecs", "_attachSpecsAuto", "_linked", "_canInterpolate"];
	params [
	"_unit",
	"_animset",
	["_forcedSnapPoint", objNull],
	["_interpolate", false],
	["_attach", true]
	];
	
	if (isNil "_unit") exitWith {
		if (acpl_fnc_debug) then {_unit GlobalChat "acpl_play_anim - No unit selected!";};
	};
	if (isNil "_animset") exitWith {
		if (acpl_fnc_debug) then {_unit GlobalChat "acpl_play_anim - No animset selected!";};
	};
	if (isNil "_forcedSnapPoint") then {
		if (acpl_fnc_debug) then {_unit GlobalChat "acpl_play_anim - ForcedSnapPoint is not existing!";};

		_forcedSnapPoint = objNull;
	};
	if ((_unit getVariable ["BIS_fnc_ambientAnim__animset",""]) != "") exitWith {
		if (acpl_fnc_debug) then {_unit GlobalChat "acpl_play_anim - is already playing! Can not call it second time!";};
	};
	
	{[_unit, _x] remoteExec ["disableAI",0];} forEach ["ANIM","AUTOTARGET","FSM","MOVE","TARGET"];
	[_unit] remoteExec ["detach",0];
	
	_params = _animset call BIS_fnc_ambientAnimGetParams;

	_anims		= _params select 0;
	_azimutFix 	= _params select 1;
	_attachSnap 	= _params select 2;
	_attachOffset 	= _params select 3;
	_canInterpolate = _params select 7;
	
	if (count _anims == 0) exitWith {
		if (acpl_fnc_debug) then {_unit GlobalChat "acpl_play_anim - Wrong animset!";};
	};
	
	_linked = _unit nearObjects ["man",5];
	_linked = _linked - [_unit];

	{
		_xSet = _x getVariable ["BIS_fnc_ambientAnim__animset",""];

		if (_xSet != _animset || _xSet == "") then
		{
			_linked set [_forEachIndex,objNull];
		}
		else
		{
			_xLinked = _x getVariable ["BIS_fnc_ambientAnim__linked",[]];

			if !(_unit in _xLinked) then
			{
				_xLinked = _xLinked + [_unit];
				_x setVariable ["BIS_fnc_ambientAnim__linked",_xLinked];
			};
		};
	} forEach _linked; _linked = _linked - [objNull];	
	
	_attachSpecsAuto = switch (_animset) do {
		case "SIT_AT_TABLE":
		{
			[
				["Land_CampingChair_V2_F",[0,0.08,-0.02],-180],
				["Land_ChairPlastic_F",[0,0.08,-0.02],90],
				["Land_ChairWood_F",[0,0.02,-0.02],-180]
			];
		};
		case "SIT";
		{
			[
				["Land_CampingChair_V2_F",[0,0.08,0.05],-180],
				["Land_ChairPlastic_F",[0,0.08,0.05],90],
				["Land_ChairWood_F",[0,0.02,0.05],-180]
			];
		};
		case "SIT1";
		{
			[
				["Land_CampingChair_V2_F",[0,0.08,0.05],-180],
				["Land_ChairPlastic_F",[0,0.08,0.05],90],
				["Land_ChairWood_F",[0,0.02,0.05],-180]
			];
		};
		case "SIT2";
		{
			[
				["Land_CampingChair_V2_F",[0,0.08,0.05],-180],
				["Land_ChairPlastic_F",[0,0.08,0.05],90],
				["Land_ChairWood_F",[0,0.02,0.05],-180]
			];
		};
		case "SIT3";
		{
			[
				["Land_CampingChair_V2_F",[0,0.08,0.05],-180],
				["Land_ChairPlastic_F",[0,0.08,0.05],90],
				["Land_ChairWood_F",[0,0.02,0.05],-180]
			];
		};
		case "SIT_U1";
		{
			[
				["Land_CampingChair_V2_F",[0,0.08,0.05],-180],
				["Land_ChairPlastic_F",[0,0.08,0.05],90],
				["Land_ChairWood_F",[0,0.02,0.05],-180]
			];
		};
		case "SIT_U2";
		{
			[
				["Land_CampingChair_V2_F",[0,0.08,0.05],-180],
				["Land_ChairPlastic_F",[0,0.08,0.05],90],
				["Land_ChairWood_F",[0,0.02,0.05],-180]
			];
		};
		case "SIT_U3":
		{
			[
				["Land_CampingChair_V2_F",[0,0.08,0.05],-180],
				["Land_ChairPlastic_F",[0,0.08,0.05],90],
				["Land_ChairWood_F",[0,0.02,0.05],-180]
			];
		};

		case "SIT_SAD1":
		{
			[
				["Box_NATO_Wps_F",[0,-0.27,0.03],0]
			];
		};
		case "SIT_SAD2":
		{
			[
				["Box_NATO_Wps_F",[0,-0.3,0.05],0]
			];
		};
		case "SIT_HIGH1":
		{
			[
				["Box_NATO_Wps_F",[0,-0.23,0.03],0]
			];
		};
		case "SIT_HIGH";
		case "SIT_HIGH2":
		{
			[
				["Box_NATO_Wps_F",[0,-0.12,-0.20],0]
			];
		};


		default
		{
			[];
		};
	};
	
	if !(isNull _forcedSnapPoint) then
	{
		_attachObj = _forcedSnapPoint;
		_attachSpecs = [typeOf _forcedSnapPoint,[0,0,_attachOffset],0];

		//get the attach specs
		{
			if ((_x select 0) == typeOf _forcedSnapPoint) exitWith
			{
				_attachSpecs = _x;
			};
		}
		forEach _attachSpecsAuto;
	}
	else
	{
		//default situation, snappoint not found = using unit position
		_attachSpecs = [typeOf _unit,[0,0,_attachOffset],0];
		_attachObj = _unit;

		//get the snappoint object
		private["_obj"];

		{
			_obj = nearestObject [_unit, _x select 0];

			if (([_obj,_unit] call BIS_fnc_distance2D) < _attachSnap) exitWith {
				_attachSpecs = _x;
				_attachObj = _obj;
			};
		} forEach _attachSpecsAuto;
	};
	
	_unit setVariable ["BIS_fnc_ambientAnim__linked",_linked];
	
	_unit setVariable ["acpl_anim",true,true];
	_unit setVariable ["BIS_fnc_ambientAnim__anims",_anims];
	_unit setVariable ["BIS_fnc_ambientAnim__animset",_animset];
	_unit setVariable ["BIS_fnc_ambientAnim__interpolate",_interpolate && _canInterpolate];
	
	_unit setVariable ["BIS_fnc_ambientAnim__time",0];
	
	[_attachObj, _unit] remoteExec ["disableCollisionWith",0];
	[_unit, _attachObj] remoteExec ["disableCollisionWith",0];
	
	[_unit,_attachObj,_attachSpecs,_azimutFix,_attach] spawn
	{
		private ["_unit", "_attachObj", "_attachSpecs", "_azimutFix", "_attach", "_group", "_logic", "_ehAnimDone", "_ehKilled"];
		
		_unit = _this select 0;
		_attachObj = _this select 1;
		_attachSpecs = _this select 2;
		_azimutFix = _this select 3;
		_attach = _this select 4;
		
		waitUntil {time > 0};
		
		if (isNil "_unit") exitWith {};
		if (isNull _unit) exitWith {};
		if !(alive _unit && canMove _unit) exitWith {};
		
		_attachPos = getPosASL _attachObj;
		
		_group = group _unit;
		_logic = _group createUnit ["Logic", [_attachPos select 0,_attachPos select 1,0], [], 0, "NONE"];
		
		if (isNull _logic) exitWith {
			_unit call acpl_func_playAnim;

			if (count units _group == 0) then
			{
				deleteGroup _group;
			};
		};
		
		_logic setPosASL _attachPos;
		_logic setDir ((getDir _attachObj) + _azimutFix);
		
		_unit setVariable ["BIS_fnc_ambientAnim__logic",_logic];
		_unit setVariable ["BIS_fnc_ambientAnim__helper",_attachObj];
		
		if (_attach) then
		{
			_unit attachTo [_logic,_attachSpecs select 1];
			_unit setVariable ["BIS_fnc_ambientAnim__attached",true];
		};
		
		_unit call acpl_func_playAnim;
		
		_ehAnimDone = _unit addEventHandler [
			"AnimDone",
			{
				private["_unit","_anim","_pool"];

				_unit = _this select 0;
				_anim = _this select 1;
				_pool = _unit getVariable ["BIS_fnc_ambientAnim__anims",[]];

				if (alive _unit) then
				{
					_unit call acpl_func_playAnim;
				}
				else
				{
					_unit call acpl_func_animterminate;
				};
			}
		];
		_unit setVariable ["BIS_EhAnimDone", _ehAnimDone];
	
		_ehKilled = _unit addEventHandler [
			"Killed",
			{
				(_this select 0) call acpl_func_animterminate;
			}
		];
		_unit setVariable ["BIS_EhKilled", _ehKilled];
	};
};
publicvariable "acpl_play_anim";

acpl_func_playAnim = {
	private["_unit","_anims","_anim","_available","_time","_linkedUnits","_linkedAnims","_xTime","_interpolate"];

	if (isNull _this) exitWith {};
	if !(alive _this && canMove _this) exitWith {};

	_unit = _this;
	_anims 	= _unit getVariable ["BIS_fnc_ambientAnim__anims",[]];

	if (count _anims == 0) exitWith
	{
		if (acpl_fnc_debug) then {_unit GlobalChat "acpl_play_anim - doesn't have defined ambient anims!";};
	};

	_linkedUnits = _unit getVariable ["BIS_fnc_ambientAnim__linked",[]];

	_linkedAnims = [];

	_time = time - 10;

	{
		_xTime = _x getVariable ["BIS_fnc_ambientAnim__time",_time];

		if (_xTime > _time) then
		{
			_linkedAnims = _linkedAnims + [animationState _x];
		};
	}
	forEach _linkedUnits;
	
	_available = _anims - _linkedAnims;

	if (count _available == 0) then
	{
		if (acpl_fnc_debug) then {_unit GlobalChat "acpl_play_anim - oesn't have an available/free animation to play!";};

		_available = _anims;
	};
	
	_anim = _available call BIS_fnc_selectRandom;

	_interpolate = _unit getVariable ["BIS_fnc_ambientAnim__interpolate",false];

	if (_interpolate) then
	{
		[_unit, _anim] remoteExec ["playMoveNow",0];
	}
	else
	{
		[_unit, _anim] remoteExec ["switchMove",0];
	};
	
	_unit setVariable ["acpl_anim",true,true];
};
publicvariable "acpl_func_playAnim";

acpl_func_animterminate = {
	private["_unit","_ehAnimDone","_ehKilled","_fnc_log_disable","_detachCode"];

	_fnc_log_disable = false;

	if (typeName _this == typeName []) exitWith
	{
		{
			_x call acpl_func_animterminate;
		}
		forEach _this;
	};

	if (typeName _this != typeName objNull) exitWith {};

	if (isNull _this) exitWith {};

	_unit = _this;
	
	{[_unit, _x] remoteExec ["enableAI",0];} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];

	_ehAnimDone 	= _unit getVariable ["BIS_EhAnimDone",-1];
	_ehKilled 	= _unit getVariable ["BIS_EhKilled",-1];

	if (_ehAnimDone != -1) then
	{
		_unit removeEventHandler ["AnimDone",_ehAnimDone];
		_unit setVariable ["BIS_EhAnimDone",-1];
	};
	if (_ehKilled != -1) then
	{
		_unit removeEventHandler ["Killed",_ehKilled];
		_unit setVariable ["BIS_EhKilled",-1];
	};

	_detachCode =
	{
		private["_logic"];
		
		if (isNull _this) exitWith {};

		_logic = _this getVariable ["BIS_fnc_ambientAnim__logic",objNull];

		//delete the game logic
		if !(isNull _logic) then
		{
			deleteVehicle _logic;
		};

		_this setVariable ["BIS_fnc_ambientAnim__attached",nil];
		_this setVariable ["BIS_fnc_ambientAnim__animset",nil];
		_this setVariable ["BIS_fnc_ambientAnim__anims",nil];
		_this setVariable ["BIS_fnc_ambientAnim__interpolate",nil];
		_this setVariable ["BIS_fnc_ambientAnim__time",nil];
		_this setVariable ["BIS_fnc_ambientAnim__logic",nil];
		_this setVariable ["BIS_fnc_ambientAnim__helper",nil];
		_this setVariable ["BIS_fnc_ambientAnim__linked",nil];
		
		detach _this;
		
		if (alive _this) then {
			[_unit, ""] remoteExec ["switchMove",0];
			_unit setVariable ["acpl_anim",false,true];
		};
	};

	if (time > 0) then
	{
		_unit call _detachCode;
	}
	else
	{
		[_unit,_detachCode] spawn
		{
			sleep 0.3; (_this select 0) call (_this select 1);
		};
	};
};
publicvariable "acpl_func_animterminate";

acpl_load_animations = true;
publicvariable "acpl_load_animations";

if (acpl_fnc_debug) then {["ACPL FNCS ANIMATIONS LOADED"] remoteExec ["systemchat",0];};