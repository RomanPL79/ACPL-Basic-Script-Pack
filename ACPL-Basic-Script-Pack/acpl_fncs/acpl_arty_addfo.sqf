private ["_unit"];

if (!isserver) exitwith {};

//_nul = [this] execVM "acpl_fncs\acpl_arty_addfo.sqf";
//v1.0

waitUntil {acpl_fncs_initied};

waitUntil {acpl_mainloop_done};

_unit = _this select 0;

_unit setvariable ["acpl_arty_fo",true,true];