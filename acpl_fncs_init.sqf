private ["_type","_vcom","_mc","_static","_playable","_action"];

//Podstawowe skrypty ACPL
//v1.0

_type = _this select 0;
_mc = _this select 1;
_vcom = _this select 2;
_static = _this select 3;

if (!isserver) exitwith {};

_playable = playableUnits + switchableUnits + allPlayers;

//Ustawienia medykamentów
//Dla zwykłego żołdaka
acpl_fieldDressing_sol = 5;
acpl_elasticBandage_sol = 2;
acpl_adenosine_sol = 0;
acpl_atropine_sol = 0;
acpl_epinephrine_sol = 0;
acpl_morphine_sol = 1;
acpl_packingBandage_sol = 2;
acpl_personalAidKit_sol = 0;
acpl_tourniquet_sol = 1;

//Dla medyka
acpl_fieldDressing_med = 10;
acpl_elasticBandage_med = 30;
acpl_adenosine_med = 6;
acpl_atropine_med = 6;
acpl_epinephrine_med = 30;
acpl_morphine_med = 30;
acpl_packingBandage_med = 20;
acpl_personalAidKit_med = 0;
acpl_plasmaIV_med = 0;
acpl_plasmaIV_250_med = 3;
acpl_plasmaIV_500_med = 0;
acpl_salineIV_med = 0;
acpl_salineIV_250_med = 4;
acpl_salineIV_500_med = 0;
acpl_tourniquet_med = 6;
acpl_surgicalKit_med = 0;
acpl_bloodIV_250_med = 2;

//Dla centrum medycznego
acpl_fieldDressing_veh = 50;
acpl_elasticBandage_veh = 50;
acpl_adenosine_veh = 50;
acpl_atropine_veh = 50;
acpl_bloodIV_veh = 10;
acpl_bodyBag_veh = 10;
acpl_epinephrine_veh = 50;
acpl_morphine_veh = 50;
acpl_packingBandage_veh = 50;
acpl_plasmaIV_veh = 10;
acpl_salineIV_veh = 10;
acpl_surgicalKit_veh = 10;
acpl_tourniquet_veh = 50;

if (_type == 1) then {
	acpl_WZ28_Enabled = false; //włącza możliwość przeładowania dla polskiej wersji BAR'a (na 7,92), tylko WW2
};

{publicvariable _x;} foreach ["acpl_fieldDressing_sol","acpl_elasticBandage_sol","acpl_adenosine_sol","acpl_atropine_sol","acpl_epinephrine_sol","acpl_morphine_sol","acpl_packingBandage_sol","acpl_personalAidKit_sol","acpl_tourniquet_sol"];
{publicvariable _x;} foreach ["acpl_bloodIV_250_med","acpl_surgicalKit_med","acpl_tourniquet_med","acpl_salineIV_500_med","acpl_salineIV_250_med","acpl_salineIV_med","acpl_plasmaIV_500_med","acpl_plasmaIV_250_med","acpl_plasmaIV_med","acpl_fieldDressing_med","acpl_elasticBandage_med","acpl_adenosine_med","acpl_atropine_med","acpl_epinephrine_med","acpl_morphine_med","acpl_packingBandage_med","acpl_personalAidKit_med"];
{publicvariable _x;} foreach ["acpl_tourniquet_veh","acpl_surgicalKit_veh","acpl_salineIV_veh","acpl_plasmaIV_veh","acpl_packingBandage_veh","acpl_morphine_veh","acpl_epinephrine_veh","acpl_bodyBag_veh","acpl_bloodIV_veh","acpl_atropine_veh","acpl_adenosine_veh","acpl_elasticBandage_veh","acpl_fieldDressing_veh"];

if (_type == 0) then {
};

if (_type == 1) then {
	_nul = execVM "acpl_fncs\IF44\acpl_repack_init.sqf";
};

[] execVM "acpl_fncs\acpl_animations\acpl_animations_init.sqf";
[_mc] execVM "acpl_fncs\acpl_addmeds.sqf";

[] execVM "acpl_fncs\acpl_msc\main.sqf";
if (_vcom) then {
	[] execVM "Vcom\VcomInit.sqf";
	
	//USTAWIENIA VCOMAI
	
	Vcm_ActivateAI = true; //Set this to false to disable VcomAI. It can be set to true at any time to re-enable Vcom AI
	VcmAI_ActiveList = []; //Leave this alone.
	Vcm_ArtilleryArray = []; //Leave this alone
	VCM_ARTYENABLE = false; //Enable improved artillery handling.
	VCM_AIMagLimit = 5; //Number of mags remaining before AI looks for ammo.
	VCM_Debug = false; //Enable debug mode.
	VCM_MINECHANCE = 75; //Chance to lay a mine
	VCM_ARTYLST = []; //List of all AI inside of artillery pieces, leave this alone.
	VCM_ARTYDELAY = 300; //Delay between squads requesting artillery
	VCM_ARTYWT = -(VCM_ARTYDELAY);
	VCM_ARTYET = -(VCM_ARTYDELAY);
	VCM_ARTYRT = -(VCM_ARTYDELAY);
	VCM_ARTYSPREAD = 400; //Spread of artillery rounds;	
	VCM_SIDEENABLED = [west,east,resistance]; //Sides that will activate Vcom AI
	VCM_RAGDOLL = true; //Should AI ragdoll when hit
	VCM_RAGDOLLCHC = 20; //CHANCE AI RAGDOLL	
	VCM_HEARINGDISTANCE = 800; //Distance AI hear unsuppressed gunshots.
	VCM_WARNDIST = 1000; //How far AI can request help from other groups.
	VCM_WARNDELAY = 30; //How long the AI have to survive before they can call in for support. This activates once the AI enter combat.
	VCM_STATICARMT = 300; //How long AI stay on static weapons when initially arming them. This is just for AI WITHOUT static bags. They will stay for this duration when NO ENEMIES ARE SEEN, or their group gets FAR away.	
	VCM_StealVeh = false; //Will the AI steal vehicles.
	VCM_AIDISTANCEVEHPATH = 100; //Distance AI check from the squad leader to steal vehicles
	VCM_ADVANCEDMOVEMENT = true; //True means AI will actively generate waypoints if no other waypoints are generated for the AI group (2 or more). False disables this advanced movements.
	VCM_FRMCHANGE = true; //AI GROUPS WILL CHANGE FORMATIONS TO THEIR BEST GUESS.
	VCM_SKILLCHANGE = false; //AI Groups will have their skills changed by Vcom.
};

{
	(group _x) setVariable ["VCM_DisableForm",true,true];
	(group _x) setVariable ["VCM_TOUGHSQUAD",true,true];
	(group _x) setVariable ["VCM_NORESCUE",true,true];
	(group _x) setVariable ["VCM_NOFLANK",true,true];
} foreach _playable;

if (_static) then {
	{_x disableAI "move";} foreach _playable;
	
	_action = ["acpl_ai_action", "Odblokuj możliwość chodzenia AI w grupie", "", {{_x enableAI "MOVE";} foreach (units (group _player));hint "Odblokowałeś AI w swojej grupie";}, {_player == leader (group _player)}] call ace_interact_menu_fnc_createAction;
	{[[(_x), 1, ["ACE_SelfActions"], _action],ace_interact_menu_fnc_addActionToObject] remoteExec ["call"];} foreach allunits;
};