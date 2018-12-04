if (!isserver) exitwith {};

acpl_safestart_startmission = {
	{
		if (_x getvariable "acpl_safestart_veh") then {
			if (_x getvariable "acpl_safestart_role" == "driver") then {
					[_x,(_x getvariable "acpl_safestart_vehicle") select 0] remoteExec ["moveInDriver",0];
				};
				if (_x getvariable "acpl_safestart_role" == "cargo") then {
					[_x,(_x getvariable "acpl_safestart_vehicle") select 0] remoteExec ["moveInCargo",0];
				};
				if (_x getvariable "acpl_safestart_role" == "turret") then {
					[_x,[(_x getvariable "acpl_safestart_vehicle") select 0,(_x getvariable "acpl_safestart_vehicle") select 1]] remoteExec ["moveInTurret",0];
				};
		} else {
			[_x,_x getvariable "acpl_safestart_pos"] remoteExec ["setPosATL",0];
			[_x,_x getvariable "acpl_safestart_dir"] remoteExec ["setDir",0];
		};
	} foreach acpl_safestart_units;
	sleep 5;
	{
		[_x,true] remoteExec ["allowdamage",0];
	} foreach acpl_safestart_units;
	{
		[_x,"MOVE"] remoteExec ["enableAI",0];
		[_x,"TARGET"] remoteExec ["enableAI",0];
		[_x,"AUTOTARGET"] remoteExec ["enableAI",0];
	} foreach allunits;
	acpl_safestart = false;
	publicvariable "acpl_safestart";
};
publicvariable "acpl_safestart_startmission";

acpl_safestart_wait = {
	private ["_wait"];
		
	_wait = _this select 0;
		
	[_wait] remoteExec ["skipTime",0];
};
publicvariable "acpl_safestart_wait";

acpl_safestart_fncs = true;
publicvariable "acpl_safestart_fncs";

if (acpl_fnc_debug) then {["ACPL FNCS SAFESTART LOADED"] remoteExec ["systemchat",0];};