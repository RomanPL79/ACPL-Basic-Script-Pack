private ["_unit","_mag","_classname_gun","_classnames_mags"];

_unit = _this select 0;
_mag = _this select 1;
_classname_gun = _this select 2;
_classnames_mags = _this select 3;

//_nul = [this,"firstmagclass","gunclassname",["magazineclassname",howmany]] execVM "acpl_fncs\addgun.sqf";
//v1.0

_unit addmagazine _mag;
_unit addweapon _classname_gun;
{
	_unit addmagazines _x;
} foreach _classnames_mags;