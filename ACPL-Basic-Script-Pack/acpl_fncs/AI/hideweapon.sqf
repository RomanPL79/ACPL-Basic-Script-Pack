private ["_unit","_weapons","_primary","_secondary","_handgun","_handgun_addons","_enemy","_where"];

if (!isserver) exitwith {};

_unit = _this select 0;
_weapons = _this select 1;
_enemy = _this select 2;

_unit setvariable ["acpl_dostop_hiddenweapon",true,true];

_unit setCaptive true;

_primary = primaryWeapon _unit;
_secondary = secondaryWeapon _unit;
_handgun = handgunWeapon _unit;
_handgun_addons = handgunItems _unit;

_unit removeWeapon _primary;
_unit removeWeapon _secondary;
_unit removeWeapon _handgun;

if (_unit canAddItemToUniform _handgun) then {
	_unit addItemToUniform _handgun;
	_where = "uniform";
} else {
	if (_unit canAddItemToVest _handgun) then {
		_unit addItemToVest _handgun;
		_where = "vest";
	} else {
		if (_unit canAddItemToBackpack _handgun) then {
			_unit addItemToBackpack _handgun;
			_where = "backpack";
		} else {
			if (true) exitwith {};
		};
	};
};

while {(alive _unit) AND (_unit getvariable "acpl_dostop_hiddenweapon")} do {
	if ([_unit, acpl_dostop_weap_distance, _enemy, _unit] call acpl_enemyinrange) then {
		if ([_unit, _enemy] call acpl_dostop_weap_risk) then {
			_unit setvariable ["acpl_dostop_hiddenweapon",false,true];
			_unit setCaptive false;
			if (_where == "uniform") then {_unit removeItemFromUniform _handgun;};
			if (_where == "vest") then {_unit removeItemFromvest _handgun;};
			if (_where == "backpack") then {_unit removeItemFrombackpack _handgun;};
			_unit addweapon _handgun;
			{_unit addHandgunItem _x;} foreach _handgun_addons;
		};
	};
	sleep 5;
};