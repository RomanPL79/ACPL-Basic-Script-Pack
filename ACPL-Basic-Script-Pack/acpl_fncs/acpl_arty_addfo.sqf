private ["_unit"];

if (!isserver) exitwith {};

//_nul = [this] execVM "acpl_fncs\acpl_arty_addfo.sqf";
//v1.0

if (isNil "acpl_fncs_initied") then {acpl_fncs_initied = false};

waitUntil {acpl_fncs_initied};

if (isNil "acpl_mainloop_done") then {acpl_mainloop_done = false};

waitUntil {acpl_mainloop_done};

_unit = _this select 0;

_unit setvariable ["acpl_arty_fo",true,true];
