private ["_unit", "_animset", "_forcedSnapPoint", "_interpolate", "_attach"];

/*
	Pierwotny Autor: Jiri Wainar
	Poprawiono przez: Roman79

	Opis:
	W³¹cza wybran¹ animacje dla podanej jednostki.

	Parametry:
	0: OBJECT - jednostka na której wyœwietli siê animacja
	1: STRING - id listy animacji spoœród których wylosuje animacje.
	   > "STAND"		- standing still, slightly turning to the sides, with rifle weapon
	   > "STAND_IA"		- standing still, slightly turning to the sides, with rifle weapon
	   > "STAND_U1-3"	- standing still, slightly turning to the sides, no weapon
	   > "WATCH1-2"		- standing and turning around, with rifle weapon
	   > "GUARD"		- standing still, like on guard with hands behing the body
	   > "LISTEN_BRIEFING"  - standing still, hands behind back, recieving briefing / commands, no rifle.
	   > "LEAN_ON_TABLE"	- standing while leaning on the table
	   > "LEAN"		- standing while leaning (on wall)
	   > "BRIEFING"		- standing, playing ambient briefing loop with occasional random moves
	   > "BRIEFING_POINT_LEFT"	- contains 1 extra pointing animation, pointing left & high
	   > "BRIEFING_POINT_RIGHT"	- contains 1 extra pointing animation, pointing right & high
	   > "BRIEFING_POINT_TABLE"	- contains 1 extra pointing animation, pointing front & low, like at table
	   > "SIT1-3"		- sitting on chair or bench, with rifle weapon
	   > "SIT_U1-3"		- sitting on chair or bench, without weapon
	   > "SIT_AT_TABLE"	- sitting @ table, hands on table
	   > "SIT_HIGH1-2" 	- sitting on taller objects like a table or wall, legs not touching the ground. Needs a rifle!
	   > "SIT_LOW"		- sitting on the ground, with weapon.
	   > "SIT_LOW_U"	- sitting on the ground, without weapon.
	   > "SIT_SAD1-2"	- sitting on a chair, looking very sad.
	   > "KNEEL"		- kneeling, with weapon.
	   > "PRONE_INJURED_U1-2" - laying wounded, back on the ground, wothout weapon
	   > "PRONE_INJURED"	- laying wounded & still, back on the ground, with or without weapon
	   > "KNEEL_TREAT"	- kneeling while treating the wounded
	   > "REPAIR_VEH_PRONE"	- repairing vehicle while laying on the ground (under the vehicle)
	   > "REPAIR_VEH_KNEEL"	- repairing vehicle while kneeling (like changing a wheel)
	   > "REPAIR_VEH_STAND"	- repairing/cleaning a vehicle while standing

	2: OBJECT - Obiekt do którego zostanie przeczepiona jednostka

	3: True/false 	- function will try to interpolate into the ambient animation, if the interpolateTo link exists

	Przyk³ad:
	[this,"SIT_HIGH2"] call BIS_fnc_ambientAnim;
*/

if (!isserver) exitwith {};

waitUntil {acpl_fncs_initied};

_unit = _this select 0;
_animset = _this select 1;
if (isNil {_this select 2}) then {_forcedSnapPoint = objNull;} else {_forcedSnapPoint = _this select 2;};
if (isNil {_this select 3}) then {_interpolate = false;} else {_interpolate = _this select 3;};
if (isNil {_this select 4}) then {_attach = true;} else {_attach = _this select 4;};

[_unit, _animset, _forcedSnapPoint, _interpolate, _attach] call acpl_play_anim;