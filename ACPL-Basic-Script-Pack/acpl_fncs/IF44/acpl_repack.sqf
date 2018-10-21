private ["_unit","_class1","_class2","_maxammo","_mags","_a","_a1","_check","_rep1","_rep2","_lm"];

_unit = _this select 0;
_class1 = _this select 1;
_class2 = _this select 2;
_maxammo = _this select 3;

if (!isserver) exitwith {};

_mags = magazinesAmmo _unit;
_unit setvariable ["acpl_repack_mags",[],true];
{
	private ["_x0","_x1"];
	_x0 = _x select 0;
	_x1 = _x select 1;
	if (_x0 == _class1) then {_unit setvariable ["acpl_repack_mags",(_unit getvariable "acpl_repack_mags") + [_x],true];};
} foreach _mags;
_a = (_unit getvariable "acpl_repack_mags") select 0;
_a1 = _a select 1;
_check = _a1 / _maxammo;
if (_check <= 1) then {
	_unit removemagazine _class1;
	_unit addmagazine [_class2,_a1];
} else {
	_unit removemagazine _class1;
	_rep1 = _a1 / _maxammo;
	_rep2 = [_rep1,0] call BIS_fnc_cutDecimals;
	_rep = if (_rep1 >= _rep2) then {_rep2} else {_rep2 - 1};
	_lm = _a1 - (_rep*_maxammo);
	for "_i" from 1 to _rep do {
		_unit addmagazine [_class2,_maxammo];
	};
	_unit addmagazine [_class2,_lm];
};