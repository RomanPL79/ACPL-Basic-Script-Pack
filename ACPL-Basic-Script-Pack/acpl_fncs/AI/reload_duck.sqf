private ["_unit","_post_num"];

_unit = _this select 0;

if (!isserver) exitwith {};

while {(alive _unit) AND (_unit getvariable "acpl_dostop")} do {
	_post_num = _unit getvariable "acpl_dostop_pos";
	if (needReload _unit == 1) then {
		if (_post_num == 2) then {
			_unit setunitpos "middle";
			_eh = _unit addEventHandler ["Reloaded", {(_this select 0) setunitpos "up";(_this select 0) removeEventHandler ["Reloaded", 0];}];
		};
		if (_post_num == 1) then {
			_unit setunitpos "down";
			_eh = _unit addEventHandler ["Reloaded", {(_this select 0) setunitpos "middle";(_this select 0) removeEventHandler ["Reloaded", 0];}];
		};
	};
	if (getSuppression _unit > _unit skill "courage") then {
		if (_post_num == 2) then {
			_unit setunitpos "middle";
			waitUntil {getSuppression _unit <= _unit skill "courage"};
			_unit setunitpos "up";
		};
		if (_post_num == 1) then {
			_unit setunitpos "down";
			waitUntil {getSuppression _unit <= _unit skill "courage"};
			_unit setunitpos "middle";
		};
	};
	sleep 1;
};