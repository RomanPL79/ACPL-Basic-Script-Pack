private ["_type","_vcom","_static","_playable","_action","_ied_init","_safe_start","_text"];

//Podstawowe skrypty ACPL
//v1.1b

_type = _this select 0;
acpl_medical_mc = _this select 1;
_vcom = _this select 2;
_static = _this select 3;
acpl_medical_exep = _this select 4;
_ied_init = _this select 5;
_safe_start = _this select 6;
_text = _this select 7;

acpl_fnc_debug = true;
publicvariable "acpl_fnc_debug";

acpl_custommarkers = true;						//Czy nanosić markery dla dostawionych budynków?
publicvariable "acpl_custommarkers";

if (acpl_fnc_debug) then {["ACPL FNCS INITIATION"] remoteExec ["systemchat",0];};

[1600] remoteExec ["setViewDistance",0];

if (!isserver) exitwith {};

_playable = [] + playableUnits + switchableUnits + allPlayers;

[["","BLACK IN", 7]] remoteExec ["titleCut",0];

{[[_text, str(date select 2) + "." + str(date select 1) + "." + str(date select 0), str(name _x)],BIS_fnc_infoText] remoteExec ["spawn",_x,true];} foreach _playable;

if (_ied_init) then {
	acpl_ied_distance = 20; 					//Dystans po wejściu w który IED może zostać odpalony
	acpl_ied_worth_modifier = 0.5;				//Modyfikator opłacalności odpalenia IED (ilość osób * modyfikator * odwaga)
	acpl_ied_time = 30;							//Średni czas do odpalania ładunku
	acpl_ied_broken_chance = 10;				//Szansa w % na niewybuch (nie wybuchnie wcale), zależy od zapalnika (radiowe = szansa \ 2)
	acpl_ied_failed = 20;						//Szansa w % na nieudaną detonacje
	acpl_ied_jammer_effectivity = 95;			//Skuteczność jammera
	acpl_ied_jammer_distance = 300;				//Maksymalny zasięg działania
	acpl_ied_jammer_effective_distance = 200;	//Skuteczny zasięg (poniżej jego zawsze skuteczność zawsze równa acpl_ied_jammer_effectivity)
	acpl_ied_noiedsretreat = true;				//Czy jednostka ma zacząć uciekać po odpaleniu wszystkich ied? Tylko dla jednostek 'cywilnych'
	
	{publicvariable _x;} foreach ["acpl_ied_noiedsretreat","acpl_ied_distance","acpl_ied_worth_modifier","acpl_ied_time","acpl_ied_broken_chance","acpl_ied_failed","acpl_ied_jammer_effective_distance","acpl_ied_jammer_distance","acpl_ied_jammer_effectivity"];
} else {
	acpl_ied_noiedsretreat = false;
	publicvariable "acpl_ied_noiedsretreat";
};

acpl_dostop_weap_chance = 50;					//Szansa w % na wyciągnięcie broni przez przeciwnika z ukrytą bronią. Im więcej przeciwników jednostki w pobliżu tym szansa sie zmniejsza o x ludzi
acpl_dostop_weap_distance = 30;					//Odłegłość w której musi być przeciwnik aby jednostka z ukrytą bronią zaczeła się zastanawiać nad wyjęciem broni
acpl_dostop_retreat_chance = 20;				//Szansa w % na ucieczkę z zajmowaniej pozycji przez jednostke (dodatkowo wpływa na nią odwaga jednostki)
acpl_dostop_retreat_distance = 100;				//Odległość w jakiej musi być przeciwnik aby rozważyć ucieczkę

{publicvariable _x;} foreach ["acpl_dostop_weap_chance","acpl_dostop_weap_distance","acpl_dostop_retreat_chance","acpl_dostop_retreat_distance"];

acpl_tfr_debug = false;							//Debug systemu wykrywanie gdy mówisz
acpl_tfr_know = 1.5;							//Maksymalna wartość jaką może dodać do wiedzy AI po usłyszeniu rozmowy
acpl_tfr_time = 60;								//Po jakim czasie wróg 'zapomina' o głosach i może zostać nadpisany przez nowe głosy

{publicvariable _x;} foreach ["acpl_tfr_debug","acpl_tfr_know","acpl_tfr_time"];

//Ustawienia skilla AI

acpl_msc = true;								//Włącznik
acpl_msc_exception = [];						//Wykluczone ze zmiany skilla jednostki
acpl_msc_debug = false;							//Debug

//WEST
acpl_msc_west_random = 2;						//Im bliżej jedynki tym skill będzie losowany bliżej górnej granicy

acpl_msc_west_acc = [0.2, 0.4];					//Granice ustawienia celności
acpl_msc_west_shake = [0.1, 0.4];				//Stabilność ręki w czasie strzelania
acpl_msc_west_speed = [0.2, 0.5];				//Prędkość celowania
acpl_msc_west_spot = [0.2, 0.6];				//Dystans wykrywania
acpl_msc_west_time = [0.2, 0.4];				//Czas wykrywania
acpl_msc_west_general = [0.4, 0.7];				//Skill generalny - używanie osłon, flankowanie, generalny brain-factor
acpl_msc_west_courage = [0.2, 0.5];				//Odwaga - im więcej tej wartości tym trudniej przycisnąć wroga
acpl_msc_west_reload = [0.1, 0.3];				//Prędkość przeładowania

//EAST
acpl_msc_east_random = 6;						//Im bliżej jedynki tym skill będzie losowany bliżej górnej granicy

acpl_msc_east_acc = [0.1, 0.25];				//Granice ustawienia celności
acpl_msc_east_shake = [0.1, 0.25];				//Stabilność ręki w czasie strzelania
acpl_msc_east_speed = [0.2, 0.3];				//Prędkość celowania
acpl_msc_east_spot = [0.2, 0.6];				//Dystans wykrywania
acpl_msc_east_time = [0.1, 0.3];				//Czas wykrywania
acpl_msc_east_general = [0.2, 0.6];				//Skill generalny - używanie osłon, flankowanie, generalny brain-factor
acpl_msc_east_courage = [0.4, 0.7];				//Odwaga - im więcej tej wartości tym trudniej przycisnąć wroga
acpl_msc_east_reload = [0.1, 0.2];				//Prędkość przeładowania

//RESISTANCE
acpl_msc_resistance_random = 6;					//Im bliżej jedynki tym skill będzie losowany bliżej górnej granicy

acpl_msc_resistance_acc = [0.1, 0.25];			//Granice ustawienia celności
acpl_msc_resistance_shake = [0.1, 0.25];		//Stabilność ręki w czasie strzelania
acpl_msc_resistance_speed = [0.2, 0.3];			//Prędkość celowania
acpl_msc_resistance_spot = [0.2, 0.6];			//Dystans wykrywania
acpl_msc_resistance_time = [0.1, 0.3];			//Czas wykrywania
acpl_msc_resistance_general = [0.2, 0.6];		//Skill generalny - używanie osłon, flankowanie, generalny brain-factor
acpl_msc_resistance_courage = [0.4, 0.7];		//Odwaga - im więcej tej wartości tym trudniej przycisnąć wroga
acpl_msc_resistance_reload = [0.1, 0.2];		//Prędkość przeładowania

{publicvariable _x;} foreach ["acpl_msc_resistance_reload","acpl_msc_resistance_courage","acpl_msc_resistance_general","acpl_msc_resistance_time","acpl_msc_resistance_spot","acpl_msc_resistance_speed","acpl_msc_resistance_shake","acpl_msc_resistance_acc","acpl_msc_resistance_random","acpl_msc_east_reload","acpl_msc_east_courage","acpl_msc_east_general","acpl_msc_east_time","acpl_msc_east_spot","acpl_msc_east_speed","acpl_msc_east_shake","acpl_msc_east_acc","acpl_msc_east_random","acpl_msc_west_reload","acpl_msc_west_courage","acpl_msc_west_general","acpl_msc_west_time","acpl_msc_west_spot","acpl_msc_west_speed","acpl_msc_west_shake","acpl_msc_west_acc","acpl_msc_west_random","acpl_msc_debug","acpl_msc_exception","acpl_msc"];

acpl_betterAI_detection = 1;					//Wartość powyżej której jednostka 'widzi' przeciwnika
acpl_betterAI_detection_time = 4;				//Czas po którym jednostka wykrywa przeciwnika globalnie
acpl_betterAI_morale_enabled = true;			//Włacznik systemu morali (im mniejsze morale tym przeciwnik gorzej walczy)
acpl_betterAI_morale_changer = 0.4;				//Jak bardzo morale mogą wpłynąć na skill AI

acpl_betterAI_startmorale_blue = 100;			//Początkowe morale dla WEST
acpl_betterAI_startmorale_red = 100;			//Początkowe morale dla EAST
acpl_betterAI_startmorale_green = 100;			//Początkowe morale dla RESISTANCE

acpl_betterAI_morale_lostleader = 0.2;			//O ile spadają morale za utratę dowódcy (pierwotny dowódca to 1.5 tej wartości)
acpl_betterAI_lostunit_modifier = 0.2;			//O jaką wartość zmieniają się morale po utraconej jednostce (jest to % wyliczany z aktualnych morali)
acpl_betterAI_kill_modifier = 0.15;				//Jak bardzo podbija morale za zabicie przeciwnika
acpl_betterAI_groups_modifier = 15;				//Jak obecność grup sojuszniczych wpływa na morale
acpl_betterAI_countgroups_modifier = 7.5;		//Jak dzielona jest ilość grup wpływających na morale grupy
acpl_betterAI_groups_distance = 200;			//Odlegość w której obecność innej grupy poprawia morale

_null = [] execVM "acpl_betterAI\betterAI_init.sqf";

//Ustawienia medykamentów
acpl_medical = true;							//Czy automatyczne dodawanie medykamentów jest uruchomione?
acpl_medical_AI = true; 						//Zmiana ilości medykamentów dla jednotek AI

//Dla zwykłego żołdaka grywalnego
acpl_fieldDressing_sol = 3;
acpl_elasticBandage_sol = 2;
acpl_adenosine_sol = 0;
acpl_atropine_sol = 0;
acpl_epinephrine_sol = 0;
acpl_morphine_sol = 0;
acpl_packingBandage_sol = 2;
acpl_personalAidKit_sol = 0;
acpl_tourniquet_sol = 1;

//Dla medyka
acpl_fieldDressing_med = 10;
acpl_elasticBandage_med = 30;
acpl_adenosine_med = 0;
acpl_atropine_med = 0;
acpl_epinephrine_med = 20;
acpl_morphine_med = 20;
acpl_packingBandage_med = 20;
acpl_personalAidKit_med = 0;
acpl_plasmaIV_med = 2;
acpl_plasmaIV_250_med = 0;
acpl_plasmaIV_500_med = 4;
acpl_salineIV_med = 0;
acpl_salineIV_250_med = 0;
acpl_salineIV_500_med = 0;
acpl_tourniquet_med = 4;
acpl_surgicalKit_med = 0;
acpl_bloodIV_250_med = 0;

//Dla zwykłego żołdaka, AI
acpl_fieldDressing_AI = 2;
acpl_elasticBandage_AI = 0;
acpl_adenosine_AI = 0;
acpl_atropine_AI = 0;
acpl_epinephrine_AI = 0;
acpl_morphine_AI = 0;
acpl_packingBandage_AI = 0;
acpl_personalAidKit_AI = 0;
acpl_tourniquet_AI = 1;

//Dla medyka, AI
acpl_fieldDressing_med_AI = 20;
acpl_elasticBandage_med_AI = 0;
acpl_adenosine_med_AI = 0;
acpl_atropine_med_AI = 0;
acpl_epinephrine_med_AI = 20;
acpl_morphine_med_AI = 20;
acpl_packingBandage_med_AI = 10;
acpl_personalAidKit_med_AI = 0;
acpl_plasmaIV_med_AI = 0;
acpl_plasmaIV_250_med_AI = 5;
acpl_plasmaIV_500_med_AI = 0;
acpl_salineIV_med_AI = 0;
acpl_salineIV_250_med_AI = 0;
acpl_salineIV_500_med_AI = 0;
acpl_tourniquet_med_AI = 4;
acpl_surgicalKit_med_AI = 0;
acpl_bloodIV_250_med_AI = 0;

//Dla centrum medycznego
acpl_fieldDressing_veh = 50;
acpl_elasticBandage_veh = 20;
acpl_adenosine_veh = 0;
acpl_atropine_veh = 0;
acpl_bloodIV_veh = 2;
acpl_bodyBag_veh = 10;
acpl_epinephrine_veh = 30;
acpl_morphine_veh = 30;
acpl_packingBandage_veh = 30;
acpl_plasmaIV_veh = 8;
acpl_salineIV_veh = 4;
acpl_surgicalKit_veh = 9;
acpl_tourniquet_veh = 10;

if (_type == 1) then {
	acpl_WZ28_Enabled = false; //włącza możliwość przeładowania dla polskiej wersji BAR'a (na 7,92), tylko WW2
};

{publicvariable _x;} foreach ["acpl_fieldDressing_sol","acpl_elasticBandage_sol","acpl_adenosine_sol","acpl_atropine_sol","acpl_epinephrine_sol","acpl_morphine_sol","acpl_packingBandage_sol","acpl_personalAidKit_sol","acpl_tourniquet_sol"];
{publicvariable _x;} foreach ["acpl_fieldDressing_AI","acpl_elasticBandage_AI","acpl_adenosine_AI","acpl_atropine_AI","acpl_epinephrine_AI","acpl_morphine_AI","acpl_packingBandage_AI","acpl_personalAidKit_AI","acpl_tourniquet_AI"];
{publicvariable _x;} foreach ["acpl_bloodIV_250_med_AI","acpl_surgicalKit_med_AI","acpl_tourniquet_med_AI","acpl_salineIV_500_med_AI","acpl_salineIV_250_med_AI","acpl_salineIV_med_AI","acpl_plasmaIV_500_med_AI","acpl_plasmaIV_250_med_AI","acpl_plasmaIV_med_AI","acpl_fieldDressing_med_AI","acpl_elasticBandage_med_AI","acpl_adenosine_med_AI","acpl_atropine_med_AI","acpl_epinephrine_med_AI","acpl_morphine_med_AI","acpl_packingBandage_med_AI","acpl_personalAidKit_med_AI"];
{publicvariable _x;} foreach ["acpl_bloodIV_250_med","acpl_surgicalKit_med","acpl_tourniquet_med","acpl_salineIV_500_med","acpl_salineIV_250_med","acpl_salineIV_med","acpl_plasmaIV_500_med","acpl_plasmaIV_250_med","acpl_plasmaIV_med","acpl_fieldDressing_med","acpl_elasticBandage_med","acpl_adenosine_med","acpl_atropine_med","acpl_epinephrine_med","acpl_morphine_med","acpl_packingBandage_med","acpl_personalAidKit_med"];
{publicvariable _x;} foreach ["acpl_tourniquet_veh","acpl_surgicalKit_veh","acpl_salineIV_veh","acpl_plasmaIV_veh","acpl_packingBandage_veh","acpl_morphine_veh","acpl_epinephrine_veh","acpl_bodyBag_veh","acpl_bloodIV_veh","acpl_atropine_veh","acpl_adenosine_veh","acpl_elasticBandage_veh","acpl_fieldDressing_veh"];
{publicvariable str(_x);} foreach [acpl_medical,acpl_medical_AI,acpl_medical_mc,acpl_medical_exep];

if (_type == 0) then {
};

if (_type == 1) then {
	_nul = execVM "acpl_fncs\IF44\acpl_repack_init.sqf";
};

if (_vcom) then {
	[] execVM "Vcom\VcomInit.sqf";
	
	//USTAWIENIA VCOMAI ZNAJDUJĄ SIĘ W "Vcom\Functions\VCM_CBASettings.sqf"
};

{
	(group _x) setVariable ["VCM_DisableForm",true,true];
	(group _x) setVariable ["VCM_TOUGHSQUAD",true,true];
	(group _x) setVariable ["VCM_NORESCUE",true,true];
	(group _x) setVariable ["VCM_NOFLANK",true,true];
	(group _x) setVariable ["VCOM_NOAI",true];
	(group _x) setVariable ["Vcm_Disable",true];
} foreach _playable;

if (_static) then {
	private ["_action"];
	
	{[_x,"move"] remoteExec ["disableAI",0];} foreach _playable;
	
	_action = ["acpl_ai_action", "Odblokuj możliwość chodzenia AI w grupie", "acpl_icons\run.paa", {{[_x,"move"] remoteExec ["enableAI",0];} foreach (units (group _player));hint "Odblokowałeś AI w swojej grupie";}, {_player == leader (group _player)}] call ace_interact_menu_fnc_createAction;
	{[[(_x), 1, ["ACE_SelfActions"], _action],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];} foreach allunits;
};

if (acpl_custommarkers) then {
	acpl_add_buildingmarker = {
		private ["_object", "_pos", "_bound", "_rot", "_bmin", "_markerName", "_marker"];

		_object = _this select 0;

		_pos = getPosATL _object;
		_bound = boundingBoxReal _object;
		_rot = getDir _object;

		_bmin = _bound select 0;
			
		_markerName = format[ "bound_%1", (_object call BIS_fnc_objectVar)];

		_marker = createMarker [_markerName, _pos];
		_marker setMarkerShape "RECTANGLE";
		_marker setMarkerSize [_bmin select 0, _bmin select 1];
		_marker setMarkerDir _rot;
	};
	publicvariable "acpl_add_buildingmarker";
	
	_null = [] execVM "acpl_configs\buildings.sqf";
	
	[] spawn {
		waitUntil {acpl_config_buildings_inited};
		
		{
			if (!(typeof _x in acpl_config_notabuilding)) then {
				_nul = [_x] spawn acpl_add_buildingmarker;
			};
		} foreach allMissionObjects "building";
	};
};

acpl_play_anim = {
	private ["_unit", "_animset", "_forcedSnapPoint", "_params", "_anims", "_azimutFix", "_attachSnap", "_attachOffset", "_attachObj", "_attachSpecs", "_attachSpecsAuto", "_attach", "_linked", "_interpolate", "_canInterpolate"];
	
	_unit = _this select 0;
	_animset = _this select 1;
	if (isNil {_this select 2}) then {_forcedSnapPoint = objNull;} else {_forcedSnapPoint = _this select 2;};
	if (isNil {_this select 3}) then {_interpolate = false;} else {_interpolate = _this select 3;};
	if (isNil {_this select 4}) then {_attach = true;} else {_attach = _this select 4;};
	
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
		case "SIT1";
		case "SIT2";
		case "SIT3";
		case "SIT_U1";
		case "SIT_U2";
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
		
		waitUntil{time > 0};
		
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

acpl_check_seebody = {
	private ["_unit", "_detection", "_return"];
	
	_unit = _this select 0;
	if (isNil {_this select 1}) then {_detection = 1;} else {_detection = _this select 1;};
	_return = false;
	
	{
		if (_unit knowsAbout _x > _detection) then {_return = true;};
	} foreach allDead;
	{
		if ((_unit getvariable "ace_isunconscious") AND (_unit knowsAbout _x > _detection)) then {_return = true;};
	} foreach allunits;
	
	_return
};
publicvariable "acpl_check_seebody";

acpl_check_knowsaboutenemy = {
	private ["_unit", "_enemy", "_return", "_detection"];
	
	_unit = _this select 0;
	if (isNil {_this select 1}) then {_enemy = [_unit] call acpl_check_enemy;} else {_enemy = _this select 1;};
	if (isNil {_this select 2}) then {_detection = 1;} else {_detection = _this select 2;};
	
	_return = false;
	
	{
		if (side _x in _enemy) then {
			if (_unit knowsAbout _x > _detection) then {_return = true;}; 
		};
	} foreach allunits;
	
	_return
};
publicvariable "acpl_check_knowsaboutenemy";

acpl_calculate_posfromdir = {
	private ["_center","_dir","_distance","_return"];
	
	_center = _this select 0;
	_dir = _this select 1;
	if (isNil {_this select 2}) then {_distance = 50;} else {_distance = _this select 2;};
	_return = [0,0];
	
	if ((_dir >= 337.5) AND (_dir < 22.5)) then {
		_return = [(_center select 0),(_center select 1) + _distance];
	};
	if ((_dir >= 25.5) AND (_dir < 67.5)) then {
		_return = [(_center select 0) + _distance, (_center select 1) + _distance];
	};
	if ((_dir >= 67.5) AND (_dir < 112.5)) then {
		_return = [(_center select 0) + _distance, (_center select 1)];
	};
	if ((_dir >= 112.5) AND (_dir < 157.5)) then {
		_return = [(_center select 0) + _distance, (_center select 1) - _distance];
	};
	if ((_dir >= 157.5) AND (_dir < 202.5)) then {
		_return = [(_center select 0), (_center select 1) - _distance];
	};
	if ((_dir >= 202.5) AND (_dir < 247.5)) then {
		_return = [(_center select 0) - _distance, (_center select 1) - _distance];
	};
	if ((_dir >= 247.5) AND (_dir < 292.5)) then {
		_return = [(_center select 0) - _distance, (_center select 1)];
	};
	if ((_dir >= 292.5) AND (_dir < 337.5)) then {
		_return = [(_center select 0) - _distance, (_center select 1) + _distance];
	};
	
	_return
};
publicvariable "acpl_calculate_posfromdir";

acpl_check_assigned_vehs = {
	private ["_group","_assignes","_vehicles","_return"];
	
	_group = _this select 0;
	
	//v1.0
	
	_assignes = [];
	_units = units _group;
	{_assignes = _assignes + [assignedVehicle _x];} foreach _units;
	_vehicles = [];
	{
		if (!(_x in _vehicles)) then {
			_vehicles = _vehicles + [_x];
		};
	} foreach _assignes;
	
	_return = _vehicles;
	
	_return
};
publicvariable "acpl_check_assigned_vehs";

acpl_check_eq = {
	private ["_unit","_return","_face","_h_items","_s_items","_p_items","_h_weap","_s_weap","_p_weap","_items","_goggles","_headgear","_b_items","_backpack","_v_items","_vest","_uniform","_u_items"];
	
	_unit = _this select 0;
	_return = [];
	
	_uniform = uniform _unit;
	_u_items = uniformItems _unit;
	_vest = vest _unit;
	_v_items = vestItems _unit;
	_backpack = backpack _unit;
	_b_items = backpackitems _unit;
	_headgear = headgear _unit;
	_goggles = goggles _unit;
	_items = assignedItems _unit;
	
	_p_weap = primaryweapon _unit;
	_s_weap = secondaryweapon _unit;
	_h_weap = handgunWeapon _unit;
	
	_p_items = primaryweaponitems _unit;
	_s_items = secondaryweaponitems _unit;
	_h_items = handgunitems _unit;
	
	_face = face _unit;
	
	_return = [_uniform, _u_items, _vest, _v_items, _backpack, _b_items, _headgear, _goggles, _items, _p_weap, _s_weap, _h_weap, _p_items, _s_items, _h_items, _face];
	
	_return
};
publicvariable "acpl_check_eq";

acpl_add_eq = {
	private ["_unit","_info","_face","_h_items","_s_items","_p_items","_h_weap","_s_weap","_p_weap","_items","_goggles","_headgear","_b_items","_backpack","_v_items","_vest","_uniform","_u_items"];
	
	_unit = _this select 0;
	_info = _this select 1;
	
	_uniform = _info select 0;
	_u_items = _info select 1;
	_vest = _info select 2;
	_v_items = _info select 3;
	_backpack = _info select 4;
	_b_items = _info select 5;
	_headgear = _info select 6;
	_goggles = _info select 7;
	_items = _info select 8;
	
	_p_weap = _info select 9;
	_s_weap = _info select 10;
	_h_weap = _info select 11;
	
	_p_items = _info select 12;
	_s_items = _info select 13;
	_h_items = _info select 14;
	
	_face = _info select 15;
	
	[_unit] call acpl_remove_eq;
	
	_unit forceadduniform _uniform;
	{_unit additemtouniform _x;} foreach _u_items;
	_unit addvest _vest;
	{_unit additemtovest _x;} foreach _v_items;
	_unit addbackpack _backpack;
	{_unit additemtobackpack _x;} foreach _b_items;
	_unit addheadgear _headgear;
	_unit addgoggles _goggles;
	_unit addweapon _p_weap;
	_unit addweapon _s_weap;
	_unit addweapon _h_weap;
	{_unit addprimaryweaponitem _x;} foreach _p_items;
	{_unit addsecondaryweaponitem _x;} foreach _s_items;
	{_unit addhandgunitem _x;} foreach _h_items;
	{_unit linkItem _x;} forEach _items;
	[_unit, _face] remoteExec ["setface",0,true];
};
publicvariable "acpl_add_eq";

acpl_remove_eq = {
	private ["_unit"];
	
	_unit = _this select 0;
	
	removeallweapons _unit;
	removeuniform _unit;
	removevest _unit;
	removebackpack _unit;
	removeheadgear _unit;
	removegoggles _unit;
	{_unit unlinkItem _x;} foreach assignedItems _unit;
};
publicvariable "acpl_remove_eq";

acpl_check_info = {
	private ["_list","_return"];
	
	_list = _this select 0;
	_vehicles = _this select 1;
	
	//v1.0
	
	_return = [];
	
	{
		private ["_role","_type","_pos","_dir","_unit","_num","_veh_id","_eq"];
		
		_type = typeof _x;
		_role = assignedVehicleRole _x;
		_pos = [(getpos _x) select 0,(getpos _x) select 1,(getpos _x) select 2];
		_dir = direction _x;
		
		_veh_id = -1;
		_eq = [_x] call acpl_check_eq;
		
		_unit = _x;
		_num = 0;
		
		{
			if (vehicle _unit == _x) then {
				_veh_id = _num;
			};
			
			_num = _num + 1;
		} foreach _vehicles;
		
		_return = _return + [[_type,_pos,_dir,_role,_veh_id,_eq]];
	} foreach _list;
	
	_return
};
publicvariable "acpl_check_info";

acpl_check_info_vehs = {
	private ["_list","_return"];
	
	_list = _this select 0;
	
	//v1.0
	
	_return = [];
	
	{
		private ["_type","_pos","_dir"];
		
		_type = typeof _x;
		if (_type != "") then {
			_pos = [(getpos _x) select 0,(getpos _x) select 1,(getpos _x) select 2];
			_dir = direction _x;
			_return = _return + [[_type,_pos,_dir]];
		};
	} foreach _list;
	
	_return
};
publicvariable "acpl_check_info_vehs";

acpl_get_waypoints = {
	private ["_group","_return","_wps","_wp"];
	
	//v1.0
	
	_group = _this select 0;
	
	_return = [];
	
	_wps = count (waypoints _group);
	_wp = 0;
	for "_i" from 1 to _wps do {
		private ["_type","_pos","_beh","_com","_cr","_from","_speed","_time","_done"];
		
		_type = waypointType [_group,_wp];
		_pos = waypointPosition [_group,_wp];
		_beh = waypointBehaviour [_group,_wp];
		_com = waypointCombatMode [_group,_wp];
		_cr = waypointCompletionRadius [_group,_wp];
		_from = waypointFormation [_group,_wp];
		_speed = waypointSpeed [_group,_wp];
		_time = waypointTimeout [_group,_wp];
		
		_done = [[_pos,_type,_beh,_com,_cr,_from,_speed,_time]];
		_return = _return + _done;
		
		_wp = _wp + 1;
	};
	
	_return
};
publicvariable "acpl_get_waypoints";

acpl_spawn_newgroup = {
	private ["_side","_inf","_veh","_type","_c_inf","_c_veh","_grp","_s_vehs","_return"];
	
	//v1.1
		
	_side = _this select 0;
	_inf = _this select 1;
	_veh = _this select 2;
	
	_c_inf = count _inf;
	_c_veh = count _veh;
	
	_s_vehs = [];
	
	_grp = createGroup _side;
	_return = _grp;
	
	if (_c_veh > 0) then {
		{
			private ["_v","_class","_spawn_point","_dir"];
			
			_class = _x select 0;
			_spawn_point = _x select 1;
			_dir = _x select 2;
			
			_v = createVehicle [_class, _spawn_point, [], 0];
			_v setdir _dir;
			
			_s_vehs = _s_vehs + [_v];
		} foreach _veh;
	};
	if (_c_inf > 0) then {
		{
			private ["_unit","_class","_spawn_point","_dir","_type","_veh_id","_veh","_eq"];
			
			_class = _x select 0;
			_spawn_point = _x select 1;
			_dir = _x select 2;
			_type = _x select 3;
			_veh_id = _x select 4;
			_eq = _x select 5;
			
			_unit = _grp createUnit [_class, _spawn_point, [], 0, "NONE"];
			_unit setdir _dir;
			[_unit, _eq] call acpl_add_eq;
			if (_veh_id >= 0) then {
				_veh = _s_vehs select _veh_id;
				
				if (count _type > 0) then {
					if (_type select 0 == "driver") then {
						_unit moveInDriver _veh;
					};
					if (_type select 0 == "cargo") then {
						_unit moveInCargo _veh;
					};
					if (_type select 0 == "turret") then {
						_unit moveInTurret [_veh,(_type select 1)];
					};
				};
			};
		} foreach _inf;
	};
	
	_return
};
publicvariable "acpl_spawn_newgroup";

acpl_spawn_addwaypoints = {
	private ["_grp","_waypoints"];

	_grp = _this select 0;
	_waypoints = _this select 1;
	
	//v1.1
	
	{
		private ["_pos","_complete","_type","_formation","_behaviour","_combatmode","_speed","_wp","_time"];
		
		_pos = _x select 0;
		_type = _x select 1;
		_behaviour = _x select 2;
		_combatmode = _x select 3;
		_complete = _x select 4;
		_formation = _x select 5;
		_speed = _x select 6;
		_time = _x select 7;
		
		_wp = _grp addWaypoint [_pos, 0];
		_wp setWaypointCompletionRadius _complete;
		_wp setWaypointType _type;
		_wp setWaypointFormation _formation;
		_wp setWaypointBehaviour _behaviour;
		_wp setWaypointCombatMode _combatmode;
		_wp setWaypointSpeed _speed;
		_wp setWaypointTimeout _time;
	} forEach _waypoints;
};
publicvariable "acpl_spawn_addwaypoints";

acpl_medic_remove = {
	_unit = _this select 0;
	
	private ["_items"];
	_items = items _unit;
	for "_i" from 1 to ({_x == "ACE_fieldDressing"} count _items) do {[_unit,"ACE_fieldDressing"] remoteExec ["removeitem",_unit];};
	for "_i" from 1 to ({_x == "ACE_elasticBandage"} count _items) do {[_unit,"ACE_elasticBandage"] remoteExec ["removeitem",_unit];};
	for "_i" from 1 to ({_x == "ACE_adenosine"} count _items) do {[_unit,"ACE_adenosine"] remoteExec ["removeitem",_unit];};
	for "_i" from 1 to ({_x == "ACE_atropine"} count _items) do {[_unit,"ACE_atropine"] remoteExec ["removeitem",_unit];};
	for "_i" from 1 to ({_x == "ACE_bloodIV"} count _items) do {[_unit,"ACE_bloodIV"] remoteExec ["removeitem",_unit];};
	for "_i" from 1 to ({_x == "ACE_bloodIV_250"} count _items) do {[_unit,"ACE_bloodIV_250"] remoteExec ["removeitem",_unit];};
	for "_i" from 1 to ({_x == "ACE_bloodIV_500"} count _items) do {[_unit,"ACE_bloodIV_500"] remoteExec ["removeitem",_unit];};
	for "_i" from 1 to ({_x == "ACE_bodyBag"} count _items) do {[_unit,"ACE_bodyBag"] remoteExec ["removeitem",_unit];};
	for "_i" from 1 to ({_x == "ACE_epinephrine"} count _items) do {[_unit,"ACE_epinephrine"] remoteExec ["removeitem",_unit];};
	for "_i" from 1 to ({_x == "ACE_morphine"} count _items) do {[_unit,"ACE_morphine"] remoteExec ["removeitem",_unit];};
	for "_i" from 1 to ({_x == "ACE_packingBandage"} count _items) do {[_unit,"ACE_packingBandage"] remoteExec ["removeitem",_unit];};
	for "_i" from 1 to ({_x == "ACE_personalAidKit"} count _items) do {[_unit,"ACE_personalAidKit"] remoteExec ["removeitem",_unit];};
	for "_i" from 1 to ({_x == "ACE_plasmaIV"} count _items) do {[_unit,"ACE_plasmaIV"] remoteExec ["removeitem",_unit];};
	for "_i" from 1 to ({_x == "ACE_plasmaIV_250"} count _items) do {[_unit,"ACE_plasmaIV_250"] remoteExec ["removeitem",_unit];};
	for "_i" from 1 to ({_x == "ACE_plasmaIV_500"} count _items) do {[_unit,"ACE_plasmaIV_500"] remoteExec ["removeitem",_unit];};
	for "_i" from 1 to ({_x == "ACE_salineIV"} count _items) do {[_unit,"ACE_salineIV"] remoteExec ["removeitem",_unit];};
	for "_i" from 1 to ({_x == "ACE_salineIV_250"} count _items) do {[_unit,"ACE_salineIV_250"] remoteExec ["removeitem",_unit];};
	for "_i" from 1 to ({_x == "ACE_salineIV_500"} count _items) do {[_unit,"ACE_salineIV_500"] remoteExec ["removeitem",_unit];};
	for "_i" from 1 to ({_x == "ACE_surgicalKit"} count _items) do {[_unit,"ACE_surgicalKit"] remoteExec ["removeitem",_unit];};
	for "_i" from 1 to ({_x == "ace_tourniquet"} count _items) do {[_unit,"ace_tourniquet"] remoteExec ["removeitem",_unit];};
};
publicvariable "acpl_medic_remove";

acpl_check_enemy = {
	private ["_unit","_side","_enemy","_blue","_green","_red"];
	
	_unit = _this select 0;
	_side = side _unit;
	
	_blue = _side getFriend west;
	_red = _side getFriend east;
	_green = _side getFriend resistance;
	
	_enemy = [];
	if (_blue < 0.6) then {_enemy = _enemy + [WEST];};
	if (_red < 0.6) then {_enemy = _enemy + [EAST];};
	if (_green < 0.6) then {_enemy = _enemy + [RESISTANCE];};
	
	_enemy
};
publicvariable "acpl_check_enemy";

acpl_check_enemy_side = {
	private ["_side","_enemy","_blue","_green","_red"];
	
	_side = _this select 0;
	
	_blue = _side getFriend west;
	_red = _side getFriend east;
	_green = _side getFriend resistance;
	
	_enemy = [];
	if (_blue < 0.6) then {_enemy = _enemy + [WEST];};
	if (_red < 0.6) then {_enemy = _enemy + [EAST];};
	if (_green < 0.6) then {_enemy = _enemy + [RESISTANCE];};
	
	_enemy
};
publicvariable "acpl_check_enemy_side";

acpl_enemyinrange = {
	private ["_center","_distance","_enemy","_return","_unit"];
	
	_center = _this select 0;
	_distance = _this select 1;
	_enemy = _this select 2;
	_unit = _this select 3;
	_return = false;
	
	{
		if (_x distance _center <= _distance) then {
			private ["_side"];
			
			_side = side _x;
			if ((_side in _enemy) AND (_unit knowsAbout _x > 1)) then {_return = true;};
		};
	} foreach allunits;
	
	_return
};
publicvariable "acpl_enemyinrange";

acpl_dostop_weap_risk = {
	private ["_unit","_enemy","_distance","_list","_chance","_random","_courage"];
	
	_unit = _this select 0;
	_enemy = _this select 1;
	_distance = acpl_dostop_weap_distance;
	_list = [];
	_return = false;
	_courage = _unit skill "courage";
	
	{
		if (_x distance _unit <= _distance) then {
			private ["_side"];
			
			_side = side _x;
			if ((_side in _enemy) AND (_unit knowsAbout _x > 1)) then {
				_list = _list + [_x];
			};
		};
	} foreach allunits;
	
	if (count _list > 0) then {_chance = acpl_dostop_weap_chance / (count _list) * _courage;} else {_chance = acpl_dostop_weap_chance * _courage;};
	_random = random 100;
	
	if (_chance >= _random) then {_return = true;};
	
	_return
};
publicvariable "acpl_dostop_weap_risk";

acpl_dostop_runaway_risk = {
	private ["_unit","_enemy","_distance","_someone","_chance","_random","_courage","_dis","_multiplier"];
	
	_unit = _this select 0;
	_enemy = _this select 1;
	_distance = acpl_dostop_retreat_distance;
	_someone = false;
	_return = false;
	_courage = _unit skill "courage";
	_dis = _distance;
	
	{
		if (_x distance _unit <= _distance) then {
			private ["_side"];
			
			_side = side _x;
			if ((_side in _enemy) AND (_unit knowsAbout _x > 1)) then {
				_someone = true;
				if (_dis > _x distance _unit) then {_dis = _x distance _unit};
			};
		};
	} foreach allunits;
	
	_multiplier = _distance / _dis;
	_chance = acpl_dostop_retreat_chance * _multiplier / _courage;
	_random = random 100;
	
	if ((_chance >= _random) AND _someone) then {_return = true;};
	
	_return
};
publicvariable "acpl_dostop_runaway_risk";

acpl_check_onground = {
	private ["_list","_return"];
	
	_list = _this select 0;
	_return = true;
	
	{
		if ((alive _x) AND !(isTouchingGround (vehicle _x))) then {_return = false;};
	} foreach _list;
	
	_return
};
publicvariable "acpl_check_onground";

if (_ied_init) then {
	acpl_ied_touchoff = {
		private ["_ied","_trigger","_random","_unit"];
		
		_ied = _this select 0;
		_unit = _this select 1;
		_trigger = _this select 2;
		
		_random = random 100;
		
		_unit setvariable ["acpl_ied_ready",false,true];
		[_unit] spawn acpl_ied_playanim;
		sleep 5;
		
		if ((acpl_ied_failed <= _random) AND !([_ied,_trigger] call acpl_ied_jammed)) then {
			if (_trigger in acpl_ied_trigger_phone) then {
				private ["_sleep"];
				
				_sleep = 12 + (random 3);
				sleep (_sleep - 1);
				[_ied,"acpl_ied_nokia_sound"] remoteExec ["say3D",0];
				sleep 1;
				[_ied, 0] call ace_explosives_fnc_scriptedExplosive;
			};
			if (_trigger in acpl_ied_trigger_clacker) then {
				private ["_sleep"];
				
				_sleep = 1 + (random 1);
				sleep (_sleep - 0.5);
				[_ied,"acpl_ied_trigger"] remoteExec ["say3D",0];
				sleep 0.5;
				[_ied, 0] call ace_explosives_fnc_scriptedExplosive;
			};
			_unit setvariable ["acpl_ied_active",(_unit getVariable "acpl_ied_active") - [_ied],true];
		} else {
			if (_trigger in acpl_ied_trigger_phone) then {
				private ["_sleep"];
				
				_sleep = 12 + (random 3);
				[_ied,"acpl_ied_nokia_sound_full"] remoteExec ["say3D",0];
				sleep _sleep;
			};
			if (_trigger in acpl_ied_trigger_clacker) then {
				private ["_sleep"];
				
				_sleep = 1 + (random 1);
				[_ied,"acpl_ied_trigger"] remoteExec ["say3D",0];
				sleep _sleep;
			};
		};
		
		sleep 2;
		_unit setvariable ["acpl_ied_ready",true,true];
	};
	publicvariable "acpl_touchoff";
	
	acpl_ied_worth = {
		private ["_center","_distance","_enemy","_return","_list","_unit","_courage","_knowsabout","_vehs","_knowsabout_veh"];
		
		_center = _this select 0;
		_distance = _this select 1;
		_enemy = _this select 2;
		_unit = _this select 3;
		_courage = _unit skill "courage";
		_list = [];
		_knowsabout = [];
		_vehs = [];
		_knowsabout_veh = [];
		
		{
			if (_x distance _center <= _distance) then {
				private ["_side"];
				
				_side = side _x;
				if (_side in _enemy) then {
					_list = _list + [_x];
					if (vehicle _x != _x) then {
						_vehs = _vehs + [vehicle _x];
					};
				};
			};
		} foreach allunits;
		{
			if (_unit knowsAbout _x > 1) then {
				_knowsabout = _knowsabout + [_x];
			};
		} foreach _list;
		{
			if (_unit knowsAbout _x > 1) then {
				_knowsabout_veh = _knowsabout_veh + [_x];
			};
		} foreach _vehs;
		
		_return = count _knowsabout * acpl_ied_worth_modifier * _courage + count _knowsabout_veh * 2 * acpl_ied_worth_modifier * _courage;
		
		_return
	};
	publicvariable "acpl_ied_worth";
	
	acpl_ied_abletotouchoff = {
		private ["_unit","_trigger","_return"];
		
		_unit = _this select 0;
		_trigger = _this select 1;
		_return = true;
		
		if (_unit getvariable "ace_captives_ishandcuffed") then {_return = false;};
		if (_unit getvariable "ace_isunconscious") then {_return = false;};
		if (!(_trigger in items _unit)) then {_return = false;};
		
		_return
	};
	publicvariable "acpl_ied_abletotouchoff";
	
	acpl_ied_broken_ied = {
		private ["_return","_random","_trigger"];
		
		_trigger = _this select 0;
		
		_return = true;
		_random = random 100;
		
		if (_trigger in acpl_ied_trigger_phone) then {
			if (acpl_ied_broken_chance >= _random) then {_return = false;};
		};
		if (_trigger in acpl_ied_trigger_clacker) then {
			if ((acpl_ied_broken_chance / 2) >= _random) then {_return = false;};
		};
		
		_return
	};
	publicvariable "acpl_ied_abletotouchoff";
	
	acpl_ied_jammed = {
		private ["_ied","_trigger","_return"];
		
		_ied = _this select 0;
		_trigger = _this select 1;
		_return = false;
		
		
		if (_trigger in acpl_ied_trigger_phone) then {
			{
				if ((_ied distance _x <= acpl_ied_jammer_distance) AND (_x getvariable "acpl_ied_phone_jammer_active")) then {
					if (_ied distance _x <= acpl_ied_jammer_effective_distance) then {
						private ["_random"];
						
						_random = random 100;
						if (_random <= acpl_ied_jammer_effectivity) then {_return = true;[_x] spawn acpl_ied_jammer_giveinfo;};
					} else {
						private ["_random","_effectivity"];
						
						_random = random 100;
						_effectivity = (_ied distance _x) / (acpl_ied_jammer_distance - acpl_ied_jammer_effective_distance) * acpl_ied_jammer_effectivity;
						if (_random <= _effectivity) then {_return = true;[_x] spawn acpl_ied_jammer_giveinfo;};
					};
				};
			} foreach acpl_ied_jammers;
		};
		if (_trigger in acpl_ied_trigger_clacker) then {
					{
				if ((_ied distance _x <= acpl_ied_jammer_distance) AND (_x getvariable "acpl_ied_clacker_jammer_active")) then {
					if (_ied distance _x <= acpl_ied_jammer_effective_distance) then {
						private ["_random"];
						
						_random = random 100;
						if (_random <= (acpl_ied_jammer_effectivity - acpl_ied_jammer_effectivity/4)) then {_return = true;[_x] spawn acpl_ied_jammer_giveinfo;};
					} else {
						private ["_random","_effectivity"];
						
						_random = random 100;
						_effectivity = (_ied distance _x) / (acpl_ied_jammer_distance - acpl_ied_jammer_effective_distance) * (acpl_ied_jammer_effectivity - acpl_ied_jammer_effectivity/4);
						if (_random <= _effectivity) then {_return = true;[_x] spawn acpl_ied_jammer_giveinfo;};
					};
				};
			} foreach acpl_ied_jammers;
		};
		
		_return
	};
	publicvariable "acpl_ied_jammed";
	
	acpl_ied_jammer_giveinfo = {
		private ["_unit"];
		
		_unit = _this select 0;
		
		{
			["Zablokowano sygnał!"] remoteExec ["systemchat",_x];
		} foreach crew _unit;
	};
	publicvariable "acpl_ied_jammed";
	
	acpl_ied_playanim = {
		private ["_unit"];
		
		_unit = _this select 0;
		
		if (_unit getvariable "acpl_ied_civ") then {
			[_unit,"Acts_Kore_IdleNoWeapon_in"] remoteExec ["switchMove",0];
			sleep 2;
			[_unit,"Acts_Kore_TalkingOverRadio_in"] remoteExec ["switchMove",0];
			sleep 2.5;
			[_unit,"Acts_Kore_TalkingOverRadio_out"] remoteExec ["switchMove",0];
			sleep 1.5;
			[_unit,"Acts_Kore_IdleNoWeapon_out"] remoteExec ["switchMove",0];
			sleep 2;
			[_unit,""] remoteExec ["switchMove",0];
		};
	};
	publicvariable "acpl_ied_playanim";
	
	acpl_ied_trigger_phone = ["ACE_Cellphone"];
	acpl_ied_trigger_clacker = ["ACE_M26_Clacker","ACE_Clacker"];
	publicvariable "acpl_ied_trigger_clacker";
	publicvariable "acpl_ied_trigger_phone";
	
	acpl_ied_jammers = [];
	publicvariable "acpl_ied_jammers";
	
	[[{
		params ["_unit", "_range", "_explosive", "_fuzeTime", "_triggerItem"];
		if (_triggerItem == "ace_cellphone") exitwith {if ([_explosive,"ACE_Cellphone"] call acpl_ied_jammed) then {systemChat "Your Cell Phone signal was blocked";false};};
		if (_triggerItem == "ACE_M26_Clacker") exitwith {if ([_explosive,"ACE_M26_Clacker"] call acpl_ied_jammed) then {systemChat "Your Cell Phone signal was blocked";false};};
		if (_triggerItem == "ACE_Clacker") exitwith {if ([_explosive,"ACE_Clacker"] call acpl_ied_jammed) then {systemChat "Your Cell Phone signal was blocked";false};};
		true;
	}],ace_explosives_fnc_addDetonateHandler] remoteExec ["call",0,true];
	
	acpl_ied_fncs_initied = true;
	publicvariable "acpl_ied_fncs_initied";
};

if (_safe_start) then {
	acpl_safestart = true;
	publicvariable "acpl_safestart";
	
	{
		[_x,"MOVE"] remoteExec ["disableAI",0];
		[_x,"TARGET"] remoteExec ["disableAI",0];
		[_x,"AUTOTARGET"] remoteExec ["disableAI",0];
	} foreach allunits;
	
	acpl_safestart_units = [];
	publicvariable "acpl_safestart_units";
	
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
	
	acpl_safestart_inited = true;
	publicvariable "acpl_safestart_inited";
};

acpl_tfr_check_swradio = {
	private ["_return","_unit"];
	
	_unit = _this select 0;
	_return = false;
	if (isNil {_unit} OR {isNull (_unit)}) exitWith{false};
	{
		if (_x call TFAR_fnc_isRadio) exitWith {_return = true};
		true;
	} count (assignedItems _unit);
	
	_return
};
publicvariable "acpl_tfr_check_swradio";

acpl_tfr_check_lrradio = {
	private ["_return","_unit"];
	
	_unit = _this select 0;
	_return = false;
	
	if (isNil {_unit} OR {isNull (_unit)}) exitWith{false};
	if (count (_unit call TFAR_fnc_lrRadiosList) > 0) then {_return = true;};
	
	_return
};
publicvariable "acpl_tfr_check_lrradio";

acpl_tfr_class_swradio = {
	private ["_return","_unit"];
	
	_unit = _this select 0;
	
	_return = nil;
	{	
		if (_x call TFAR_fnc_isRadio) exitWith {_return = _x};
		true;
	} count (assignedItems _unit);
	
	_return
};
publicvariable "acpl_tfr_class_swradio";

acpl_tfr_giveradio_sw = {
	private ["_owner","_caller","_radio_o","_radio_c","_settings_o","_settings_c"];
	
	_owner = _this select 0;
	_caller = _owner getVariable "acpl_radio_asked_sw_target";
	_radio_o = [_owner] call acpl_tfr_class_swradio;
	_radio_c = [_caller] call acpl_tfr_class_swradio;
	_settings_c = _radio_c call TFAR_fnc_getSwSettings;
	_settings_o = _radio_o call TFAR_fnc_getSwSettings;
	
	_owner setVariable ["acpl_radio_asked_sw_class",_radio_o,true];
	_caller setVariable ["acpl_radio_asked_sw_class",_radio_c,true];
	_owner setVariable ["acpl_radio_asked_sw",false,true];
	_owner setVariable ["acpl_radio_asked_sw_target",_caller,true];
	_caller setVariable ["acpl_radio_asked_sw_owner",_owner,true];
	_owner setVariable ["acpl_radio_borrowed_sw",true,true];
	_caller setVariable ["acpl_radio_borrowed_sw",true,true];
	_caller setVariable ["acpl_radio_settings_sw",_settings_c,true];
	_owner setVariable ["acpl_radio_settings_sw",_settings_o,true];
	
	if (!(isNil "_radio_c")) then {[_caller, _radio_c] remoteExec ["unlinkItem",_caller];};
	[_caller, _radio_o] remoteExec ["linkItem",_caller];
	[_radio_o, _settings_o] call TFAR_fnc_setSwSettings;
	[_owner, _radio_o] remoteExec ["unlinkItem",_owner];
	["Podałeś radio"] remoteExec ["hint",_caller];
	["Podano ci radio"] remoteExec ["hint",_owner];
	
	[_owner, _caller] spawn {
		private ["_owner","_caller"];
		
		_owner = _this select 0;
		_caller = _this select 1;
		
		while {_owner getVariable "acpl_radio_borrowed_sw"} do {
			if (_owner distance _caller > 2.5) then {
				[[_caller],acpl_tfr_giveback_sw] remoteExec ["call",2];
				["Odszedłeś zbyt daleko!"] remoteExec ["systemchat",_caller];
			};
			sleep 1;
		};
	};
};
publicvariable "acpl_tfr_giveradio_sw";

acpl_tfr_giveback_sw = {
	private ["_owner","_caller","_radio_o","_radio_c","_settings_c","_settings_o"];
	
	_caller = _this select 0;
	_owner = _caller getVariable "acpl_radio_asked_sw_owner";
	_radio_c = _caller getVariable "acpl_radio_asked_sw_class";
	_radio_o = _owner getVariable "acpl_radio_asked_sw_class";
	_settings_c = _caller getVariable "acpl_radio_settings_sw";
	_settings_o = _owner getVariable "acpl_radio_settings_sw";
	
	_owner setVariable ["acpl_radio_asked_sw_class",Nil,true];
	_caller setVariable ["acpl_radio_asked_sw_class",Nil,true];
	_owner setVariable ["acpl_radio_asked_sw_target",Nil,true];
	_caller setVariable ["acpl_radio_asked_sw_owner",Nil,true];
	_owner setVariable ["acpl_radio_borrowed_sw",false,true];
	_caller setVariable ["acpl_radio_borrowed_sw",false,true];
	_caller setVariable ["acpl_radio_settings_sw",nil,true];
	_owner setVariable ["acpl_radio_settings_sw",nil,true];
	
	[_owner, _radio_o] remoteExec ["linkItem",_owner];
	[_radio_o, _settings_o] call TFAR_fnc_setSwSettings;
	[_caller, _radio_o] remoteExec ["unlinkItem",_caller];
	if (!(isNil "_radio_c")) then {
		[_caller, _radio_c] remoteExec ["linkItem",_caller];
		[_radio_c, _settings_c] call TFAR_fnc_setSwSettings;
	};
	["Oddano ci radio"] remoteExec ["hint",_owner];
	["Oddałeś radio"] remoteExec ["hint",_caller];
};
publicvariable "acpl_tfr_giveback_sw";

acpl_tfr_class_lrradio = {
	private ["_radios", "_found", "_unit", "_return"];
	
	_unit = _this select 0;
	_return = nil;
	
	_radios = _unit call TFAR_fnc_lrRadiosList;
	if (count _radios > 0) then {
		if (count _radios == 1) then {
			_return = _radios select 0;
		} else {
			_return = _radios select 0;
		};
	} else {
		_return = nil;
	};
	
	_return
};
publicvariable "acpl_tfr_class_lrradio";

acpl_tfr_giveradio_lr = {
	private ["_owner","_caller","_radio_o","_settings"];
	
	_owner = _this select 0;
	_caller = _owner getVariable "acpl_radio_asked_lr_target";
	_radio_o = [backpack _owner, backpackItems _owner];
	_settings = _radio_o call TFAR_fnc_getSwSettings;
	
	_owner setVariable ["acpl_radio_asked_lr_class",_radio_o,true];
	_owner setVariable ["acpl_radio_asked_lr",false,true];
	_owner setVariable ["acpl_radio_asked_lr_target",_caller,true];
	_caller setVariable ["acpl_radio_asked_lr_owner",_owner,true];
	_owner setVariable ["acpl_radio_borrowed_lr",true,true];
	_caller setVariable ["acpl_radio_borrowed_lr",true,true];
	_owner setVariable ["acpl_radio_settings_lr",_settings,true];
	
	if (backpack _caller != "") then {
		_caller setVariable ["acpl_radio_asked_lr_class",backpack _caller,true];
		[[_caller],zade_boc_fnc_actionOnChest] remoteExec ["call",_caller];
	};
	[_caller, (_radio_o select 0)] remoteExec ["addbackpack",_caller];
	{[_caller, _x] remoteExec ["additemtobackpack",_caller];} foreach (_radio_o select 1);
	[([_caller] call acpl_tfr_class_lrradio) select 0, ([_caller] call acpl_tfr_class_lrradio) select 1, _settings] call TFAR_fnc_setLrSettings;
	[_owner] remoteExec ["removebackpack",0];
	["Podałeś radio"] remoteExec ["hint",_caller];
	["Podano ci radio"] remoteExec ["hint",_owner];
	
	[_owner, _caller] spawn {
		private ["_owner","_caller"];
		
		_owner = _this select 0;
		_caller = _this select 1;
		
		while {_owner getVariable "acpl_radio_borrowed_lr"} do {
			if (_owner distance _caller > 2.5) then {
				[[_caller],acpl_tfr_giveback_lr] remoteExec ["call",2];
				["Odszedłeś zbyt daleko!"] remoteExec ["systemchat",_caller];
			};
			sleep 1;
		};
	};
};
publicvariable "acpl_tfr_giveradio_lr";

acpl_tfr_giveback_lr = {
	private ["_owner","_caller","_radio_o","_radio_c","_backpack_c","_settings"];
	
	_caller = _this select 0;
	_owner = _caller getVariable "acpl_radio_asked_lr_owner";
	_radio_o = _owner getVariable "acpl_radio_asked_lr_class";
	_backpack_c = _caller getVariable "acpl_radio_asked_lr_class";
	_settings = _owner getVariable "acpl_radio_settings_lr";
	
	_owner setVariable ["acpl_radio_asked_lr_class",Nil,true];
	_caller setVariable ["acpl_radio_asked_lr_class",Nil,true];
	_owner setVariable ["acpl_radio_asked_lr_target",Nil,true];
	_caller setVariable ["acpl_radio_asked_lr_owner",Nil,true];
	_owner setVariable ["acpl_radio_borrowed_lr",false,true];
	_caller setVariable ["acpl_radio_borrowed_lr",false,true];
	_owner setVariable ["acpl_radio_settings_lr",nil,true];
	
	[_owner, (_radio_o select 0)] remoteExec ["addbackpack",_owner];
	{[_owner, _x] remoteExec ["additemtobackpack",_owner];} foreach (_radio_o select 1);
	[([_owner] call acpl_tfr_class_lrradio) select 0, ([_owner] call acpl_tfr_class_lrradio) select 1, _settings] call TFAR_fnc_setLrSettings;
	[_caller] remoteExec ["removebackpack",0];
	if (_backpack_c != "") then {
		[_caller] call zade_boc_fnc_actionOnBack;
	};
	["Oddano ci radio"] remoteExec ["hint",_owner];
	["Oddałeś radio"] remoteExec ["hint",_caller];
};
publicvariable "acpl_tfr_giveback_lr";

acpl_tfr_check_speakvolume = {
	private ["_unit","_volume","_volume_max"];
	
	_unit = _this select 0;
	_volume = TF_speak_volume_meters;
	_volume_max = TF_max_voice_volume;
	
	if (_unit getvariable "acpl_tfr_speakvolume" != _volume) then {_unit setVariable ["acpl_tfr_speakvolume",_volume,true];};
	if (_unit getvariable "acpl_tfr_speakvolume_max" != _volume_max) then {_unit setVariable ["acpl_tfr_speakvolume_max",_volume_max,true];};
};
publicvariable "acpl_tfr_check_speakvolume";

acpl_tfr_isspeaking = {
	private ["_unit","_volume"];

	_unit = _this select 0;
	_volume = _this select 1;

	{
		if (_x distance _unit <= _volume) then {
			private ["_distance","_multipler","_knows"];
			
			_distance = _x distance _unit;
			_multipler = acpl_tfr_know - (acpl_tfr_know * (_distance / _volume));
			_knows = _x knowsAbout _unit;
			
			if (acpl_tfr_debug) then {["Distance: " + str(_distance)] remoteExec ["systemchat",_unit];};
			if (acpl_tfr_debug) then {["Knows: " + str(_knows)] remoteExec ["systemchat",_unit];};
			if (acpl_tfr_debug) then {["Multiplier: " + str(_multipler)] remoteExec ["systemchat",_unit];};
			
			if ([_unit,_x getVariable "acpl_tfr_knows"] call acpl_tfr_check_inlist) then {
				if ([_unit,_x getVariable "acpl_tfr_knows",_multipler,_knows] call acpl_tfr_check_change) then {
					private ["_change"];
					
					_change = [_unit,_x getVariable "acpl_tfr_knows"] call acpl_tfr_find_change;
					if (acpl_tfr_debug) then {["Wróg cię usłyszał"] remoteExec ["systemchat",_unit];};
					if (acpl_tfr_debug) then {["Basic KnowsAbout: " + str(_knows)] remoteExec ["systemchat",_unit];};
					if (acpl_tfr_debug) then {["Multiplier: " + str(_multipler)] remoteExec ["systemchat",_unit];};
					if (_knows + _multipler > 4) then {
						[_x,[_unit, 4]] remoteExec ["reveal",0];
						if (acpl_tfr_debug) then {["Osiągnięto maksymalne wykrycie"] remoteExec ["systemchat",_unit];};
						_x setVariable ["acpl_tfr_knows",(_x getVariable "acpl_tfr_knows") - _change + [[_unit, _multipler, 4, time]],true];
					} else {
						[_x,[_unit, _knows + _multipler]] remoteExec ["reveal",0];
						if (acpl_tfr_debug) then {["Doliczono Multiplier"] remoteExec ["systemchat",_unit];};
						_x setVariable ["acpl_tfr_knows",(_x getVariable "acpl_tfr_knows") - _change + [[_unit, _multipler, 4, time]],true];
					};
				};
			} else {
				if (acpl_tfr_debug) then {["Wróg cię usłyszał"] remoteExec ["systemchat",_unit];};
				if (acpl_tfr_debug) then {["Basic KnowsAbout: " + str(_knows)] remoteExec ["systemchat",_unit];};
				if (acpl_tfr_debug) then {["Multiplier: " + str(_multipler)] remoteExec ["systemchat",_unit];};
				if (_knows + _multipler > 4) then {
					[_x,[_unit, 4]] remoteExec ["reveal",0];
					if (acpl_tfr_debug) then {["Osiągnięto maksymalne wykrycie"] remoteExec ["systemchat",_unit];};
					_x setVariable ["acpl_tfr_knows",(_x getVariable "acpl_tfr_knows") + [[_unit, _multipler, 4, time]],true];
				} else {
					[_x,[_unit, _knows + _multipler]] remoteExec ["reveal",0];
					if (acpl_tfr_debug) then {["Doliczono Multiplier"] remoteExec ["systemchat",_unit];};
					_x setVariable ["acpl_tfr_knows",(_x getVariable "acpl_tfr_knows") + [[_unit, _multipler, _knows + _multipler, time]],true];
				};
			};
		};
	} foreach allunits;
};
publicvariable "acpl_tfr_isspeaking";

acpl_tfr_speaking_loop = {
	while {true} do {
		{
			private ["_volume"];
			
			_volume = _x getVariable "acpl_tfr_speakvolume";
			if (_x getvariable "acpl_tfr_speaking") then {[[_x, _volume],acpl_tfr_isspeaking] remoteExec ["spawn",2];};
		} foreach allunits;
		sleep 0.25;
		if (acpl_tfr_debug) then {["Pętla zakończona"] remoteExec ["systemchat",0];};
	};
};
publicvariable "acpl_tfr_speaking_loop";

acpl_tfr_find_change = {
	private ["_unit","_var","_return"];
	
	_unit = _this select 0;
	_var = _this select 1;
	_return = [];
	
	if (count _var > 0) then {
		{
			if (_unit == _x select 0) then {_return = [_x]};
		} foreach _var;
	};
	
	_return
};
publicvariable "acpl_tfr_find_change";

acpl_tfr_check_change = {
	private ["_unit","_var","_return","_multipler","_knows"];
	
	_unit = _this select 0;
	_var = _this select 1;
	_multipler = _this select 2;
	_knows = _this select 3;
	_return = false;
	
	if (count _var > 0) then {
		{
			if ((_multipler > _x select 1) OR (_knows < _x select 2) OR (time >= (_x select 3) + acpl_tfr_time)) then {_return = true;};
		} foreach _var;
	};
	
	_return
};
publicvariable "acpl_tfr_check_change";

acpl_tfr_check_inlist = {
	private ["_unit","_var","_return"];
	
	_unit = _this select 0;
	_var = _this select 1;
	_return = false;
	
	if (count _var > 0) then {
		{
			if (_unit == _x select 0) then {_return = true};
		} foreach _var;
	};
	
	_return
};
publicvariable "acpl_tfr_check_inlist";

acpl_tfr_loop = {
	private ["_playable"];
	
	acpl_tfr_done = [];
	publicvariable "acpl_tfr_done";
	
	_playable = [] + playableUnits + switchableUnits + allPlayers;
	
	{
		_x setVariable ["acpl_tfr_speakvolume",0,true];
		_x setVariable ["acpl_tfr_speakvolume_max",60,true];
		[["acpl_tfr_speak", "OnSpeak", {
			private ["_unit","_volume","_speaking"];
			
			_unit = _this select 0;
			_volume = _this select 1;
			_speaking = _unit getvariable "acpl_tfr_speaking";
				
			if (_speaking) then {
				_unit setvariable ["acpl_tfr_speaking",false,true];
				if (acpl_tfr_debug) then {["Właśnie skończyłeś mówić"] remoteExec ["systemchat",_unit];};
			} else {
				_unit setvariable ["acpl_tfr_speaking",true,true];
				if (acpl_tfr_debug) then {["Właśnie mówisz"] remoteExec ["systemchat",_unit];};
			};
		}, _x], TFAR_fnc_addEventHandler] remoteExec ["call",_x];
		_x setVariable ["acpl_tfr_speaking",false,true];
	} foreach _playable;
	
	while {true} do {
		{
			[[_x], acpl_tfr_check_speakvolume] remoteExec ["call",_x];
		} foreach _playable;
		sleep 0.5;
		{
			if (!(_x in acpl_tfr_done)) then {
				_x setVariable ["acpl_tfr_knows",[],true];
				acpl_tfr_done = acpl_tfr_done + [_x];
				publicvariable "acpl_tfr_done";
			};
		} foreach allunits;
		sleep 0.5;
	};
};
publicvariable "acpl_tfr_loop";

acpl_loop = {
	private ["_radio","_radio_2","_radio_lower_sw","_radio_lower_lr","_radio_onhead_sw","_radio_onhead_lr","_playable","_radio_ask_sw","_radio_ask_lr","_radio_asked_sw","_radio_asked_lr","_radio_return_sw","_radio_return_lr"];
	
	acpl_radio_added = [];
	publicvariable "acpl_radio_added";

	acpl_msc_done = [];
	publicvariable "acpl_msc_done";

	acpl_medical_done = [];
	publicvariable "acpl_medical_done";
	
	acpl_variables_done = [];
	publicvariable "acpl_variables_done";
	
	_hidebody = ["acpl_hidebody", "Ukryj Ciało", "acpl_icons\hide.paa", {[_target] remoteExec ["hideBody",0,true];}, {!(alive _target)}] call ace_interact_menu_fnc_createAction;
	
	_radio = ["acpl_radio_menu", "Opcje Radia", "acpl_icons\radio.paa", {}, {(call TFAR_fnc_haveSWRadio) OR (call TFAR_fnc_haveLRRadio)}] call ace_interact_menu_fnc_createAction;
	_radio_lower_sw = ["acpl_radio_lowerheadset_sw", "Zdejmij słuchawki (SW)", "acpl_icons\radio.paa", {private ["_volume"];_volume = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getSwVolume;_player setvariable ["acpl_radio_volume_sw",_volume,true];_player setvariable ["acpl_radio_lower_sw",true,true];[(call TFAR_fnc_ActiveSWRadio), 1] call TFAR_fnc_setSwVolume;hint "Zdjąłeś słuchawki z radia krótkiego";}, {(call TFAR_fnc_haveSWRadio) AND !(_player getvariable "acpl_radio_lower_sw")}] call ace_interact_menu_fnc_createAction;
	_radio_onhead_sw = ["acpl_radio_headset_sw", "Załóż słuchawki (SW)", "acpl_icons\radio.paa", {_player setvariable ["acpl_radio_lower_sw",false,true];[(call TFAR_fnc_ActiveSWRadio), (_player getvariable "acpl_radio_volume_sw")] call TFAR_fnc_setSwVolume;hint "Założyłeś słuchawki z radia krótkiego";}, {(call TFAR_fnc_haveSWRadio) AND (_player getvariable "acpl_radio_lower_sw")}] call ace_interact_menu_fnc_createAction;
	_radio_lower_lr = ["acpl_radio_lowerheadset_lr", "Zdejmij słuchawki (LR)", "acpl_icons\radio.paa", {private ["_volume"];_volume = (call TFAR_fnc_ActiveLrRadio) call TFAR_fnc_getLrVolume;_player setvariable ["acpl_radio_volume_lr",_volume,true];_player setvariable ["acpl_radio_lower_lr",true,true];[(call TFAR_fnc_ActiveLrRadio), 1] call TFAR_fnc_setLrVolume;hint "Zdjąłeś słuchawki z radia długiego";}, {(call TFAR_fnc_haveLRRadio) AND !(_player getvariable "acpl_radio_lower_lr")}] call ace_interact_menu_fnc_createAction;
	_radio_onhead_lr = ["acpl_radio_headset_lr", "Załóż słuchawki (LR)", "acpl_icons\radio.paa", {_player setvariable ["acpl_radio_lower_lr",false,true];[(call TFAR_fnc_ActiveLRRadio), (_player getvariable "acpl_radio_volume_lr")] call TFAR_fnc_setLrVolume;hint "Założyłeś słuchawki z radia długiego";}, {(call TFAR_fnc_haveLRRadio) AND (_player getvariable "acpl_radio_lower_lr")}] call ace_interact_menu_fnc_createAction;
	_radio_ask_sw = ["acpl_radio_ask_sw", "Poproś o pożyczenie radia (SW)", "acpl_icons\radio.paa", {
		if (isPlayer _target) then {
			["Zostałeś poproszony o pożyczenie radia (SW)"] remoteExec ["hint",_target];
			_target setVariable ["acpl_radio_asked_sw_target",_player,true];
			_target setVariable ["acpl_radio_asked_sw",true,true];
		} else {
			_target setVariable ["acpl_radio_asked_sw_target",_player,true];
			[[_target],acpl_tfr_giveradio_sw] remoteExec ["call",2];
		};
	}, {([_target] call acpl_tfr_check_swradio) AND !(_player getvariable "acpl_radio_borrowed_sw") AND !(_target getvariable "acpl_radio_borrowed_sw")}] call ace_interact_menu_fnc_createAction;
	_radio_ask_lr = ["acpl_radio_ask_lr", "Poproś o pożyczenie radia (LR)", "acpl_icons\radio.paa", {
		if (isPlayer _target) then {
			["Zostałeś poproszony o pożyczenie radia (LR)"] remoteExec ["hint",_target];
			_target setVariable ["acpl_radio_asked_lr_target",_player,true];
			_target setVariable ["acpl_radio_asked_lr",true,true];
		} else {
			_target setVariable ["acpl_radio_asked_lr_target",_player,true];
			[[_target],acpl_tfr_giveradio_lr] remoteExec ["call",2];
		};
	}, {([_target] call acpl_tfr_check_lrradio) AND !(_player getvariable "acpl_radio_borrowed_lr") AND !(_target getvariable "acpl_radio_borrowed_lr")}] call ace_interact_menu_fnc_createAction;
	_radio_2 = ["acpl_radio_menu_2", "Radio", "acpl_icons\radio.paa", {}, {([_target] call acpl_tfr_check_swradio) OR ([_target] call acpl_tfr_check_lrradio)}] call ace_interact_menu_fnc_createAction;
	_radio_asked_sw = ["acpl_radio_asked_sw_act", "Podaj radio (SW)", "acpl_icons\radio.paa", {[[_player],acpl_tfr_giveradio_sw] remoteExec ["call",2];}, {(_player getvariable "acpl_radio_asked_sw") AND !(_player getvariable "acpl_radio_borrowed_sw")}] call ace_interact_menu_fnc_createAction;
	_radio_asked_lr = ["acpl_radio_asked_lr_act", "Podaj radio (LR)", "acpl_icons\radio.paa", {[[_player],acpl_tfr_giveradio_lr] remoteExec ["call",2];}, {(_player getvariable "acpl_radio_asked_lr") AND !(_player getvariable "acpl_radio_borrowed_lr")}] call ace_interact_menu_fnc_createAction;
	_radio_return_sw = ["acpl_radio_return_sw", "Oddaj radio (SW)", "acpl_icons\radio.paa", {[[_player],acpl_tfr_giveback_sw] remoteExec ["call",2];}, {(_player getvariable "acpl_radio_borrowed_sw")}] call ace_interact_menu_fnc_createAction;
	_radio_return_lr = ["acpl_radio_return_lr", "Oddaj radio (LR)", "acpl_icons\radio.paa", {[[_player],acpl_tfr_giveback_lr] remoteExec ["call",2];}, {(_player getvariable "acpl_radio_borrowed_lr")}] call ace_interact_menu_fnc_createAction;
	
	_playable = [] + playableUnits + switchableUnits + allPlayers;
	
	if (acpl_msc) then {
		acpl_msc_west_acc_mid = (((acpl_msc_west_acc select 0) + (acpl_msc_west_acc select 1))/acpl_msc_west_random);
		acpl_msc_west_shake_mid = (((acpl_msc_west_shake select 0) + (acpl_msc_west_shake select 1))/acpl_msc_west_random);
		acpl_msc_west_speed_mid = (((acpl_msc_west_speed select 0) + (acpl_msc_west_speed select 1))/acpl_msc_west_random);
		acpl_msc_west_spot_mid = (((acpl_msc_west_spot select 0) + (acpl_msc_west_spot select 1))/acpl_msc_west_random);
		acpl_msc_west_time_mid = (((acpl_msc_west_time select 0) + (acpl_msc_west_time select 1))/acpl_msc_west_random);
		acpl_msc_west_general_mid = (((acpl_msc_west_general select 0) + (acpl_msc_west_general select 1))/acpl_msc_west_random);
		acpl_msc_west_courage_mid = (((acpl_msc_west_courage select 0) + (acpl_msc_west_courage select 1))/acpl_msc_west_random);
		acpl_msc_west_reload_mid = (((acpl_msc_west_reload select 0) + (acpl_msc_west_reload select 1))/acpl_msc_west_random);
		
		{publicvariable str(_x);} foreach [acpl_msc_west_reload_mid,acpl_msc_west_courage_mid,acpl_msc_west_general_mid,acpl_msc_west_time_mid,acpl_msc_west_spot_mid,acpl_msc_west_speed_mid,acpl_msc_west_shake_mid,acpl_msc_west_acc_mid];
		
		acpl_msc_east_acc_mid = (((acpl_msc_east_acc select 0) + (acpl_msc_east_acc select 1))/acpl_msc_east_random);
		acpl_msc_east_shake_mid = (((acpl_msc_east_shake select 0) + (acpl_msc_east_shake select 1))/acpl_msc_east_random);
		acpl_msc_east_speed_mid = (((acpl_msc_east_speed select 0) + (acpl_msc_east_speed select 1))/acpl_msc_east_random);
		acpl_msc_east_spot_mid = (((acpl_msc_east_spot select 0) + (acpl_msc_east_spot select 1))/acpl_msc_east_random);
		acpl_msc_east_time_mid = (((acpl_msc_east_time select 0) + (acpl_msc_east_time select 1))/acpl_msc_east_random);
		acpl_msc_east_general_mid = (((acpl_msc_east_general select 0) + (acpl_msc_east_general select 1))/acpl_msc_east_random);
		acpl_msc_east_courage_mid = (((acpl_msc_east_courage select 0) + (acpl_msc_east_courage select 1))/acpl_msc_east_random);
		acpl_msc_east_reload_mid = (((acpl_msc_east_reload select 0) + (acpl_msc_east_reload select 1))/acpl_msc_east_random);
		
		{publicvariable str(_x);} foreach [acpl_msc_east_reload_mid,acpl_msc_east_courage_mid,acpl_msc_east_general_mid,acpl_msc_east_time_mid,acpl_msc_east_spot_mid,acpl_msc_east_speed_mid,acpl_msc_east_shake_mid,acpl_msc_east_acc_mid];
		
		acpl_msc_resistance_acc_mid = (((acpl_msc_resistance_acc select 0) + (acpl_msc_resistance_acc select 1))/acpl_msc_resistance_random);
		acpl_msc_resistance_shake_mid = (((acpl_msc_resistance_shake select 0) + (acpl_msc_resistance_shake select 1))/acpl_msc_resistance_random);
		acpl_msc_resistance_speed_mid = (((acpl_msc_resistance_speed select 0) + (acpl_msc_resistance_speed select 1))/acpl_msc_resistance_random);
		acpl_msc_resistance_spot_mid = (((acpl_msc_resistance_spot select 0) + (acpl_msc_resistance_spot select 1))/acpl_msc_resistance_random);
		acpl_msc_resistance_time_mid = (((acpl_msc_resistance_time select 0) + (acpl_msc_resistance_time select 1))/acpl_msc_resistance_random);
		acpl_msc_resistance_general_mid = (((acpl_msc_resistance_general select 0) + (acpl_msc_resistance_general select 1))/acpl_msc_resistance_random);
		acpl_msc_resistance_courage_mid = (((acpl_msc_resistance_courage select 0) + (acpl_msc_resistance_courage select 1))/acpl_msc_resistance_random);
		acpl_msc_resistance_reload_mid = (((acpl_msc_resistance_reload select 0) + (acpl_msc_resistance_reload select 1))/acpl_msc_resistance_random);
		
		{publicvariable str(_x);} foreach [acpl_msc_resistance_reload_mid,acpl_msc_resistance_courage_mid,acpl_msc_resistance_general_mid,acpl_msc_resistance_time_mid,acpl_msc_resistance_spot_mid,acpl_msc_resistance_speed_mid,acpl_msc_resistance_shake_mid,acpl_msc_resistance_acc_mid];
	};
	
	{
		[[(_x), 0, ["ACE_MainActions"], _hidebody],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
	} foreach allDead;
	
	while {true} do {
		
		{
			if (_x in acpl_variables_done) then {} else {
				_x setVariable ["acpl_anim",false,true];
				
				acpl_variables_done = acpl_variables_done + [_x];
				publicvariable "acpl_variables_done";
			};
			
			if (_x in acpl_radio_added) then {} else {
				[[(_x), 1, ["ACE_SelfActions"], _radio],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions","acpl_radio_menu"], _radio_lower_sw],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions","acpl_radio_menu"], _radio_onhead_sw],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions","acpl_radio_menu"], _radio_lower_lr],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions","acpl_radio_menu"], _radio_onhead_lr],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 0, ["ACE_MainActions"], _radio_2],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 0, ["ACE_MainActions","acpl_radio_menu_2"], _radio_ask_sw],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 0, ["ACE_MainActions","acpl_radio_menu_2"], _radio_ask_lr],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions","acpl_radio_menu"], _radio_asked_sw],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions","acpl_radio_menu"], _radio_asked_lr],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions","acpl_radio_menu"], _radio_return_sw],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				[[(_x), 1, ["ACE_SelfActions","acpl_radio_menu"], _radio_return_lr],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				_x setvariable ["acpl_radio_lower_sw",false,true];
				_x setvariable ["acpl_radio_volume_sw",100,true];
				_x setvariable ["acpl_radio_lower_lr",false,true];
				_x setvariable ["acpl_radio_volume_lr",100,true];
				_x setVariable ["acpl_radio_asked_sw",false,true];
				_x setVariable ["acpl_radio_asked_lr",false,true];
				_x setVariable ["acpl_radio_asked_sw_class",nil,true];
				_x setVariable ["acpl_radio_asked_lr_class",nil,true];
				_x setVariable ["acpl_radio_asked_sw_target",nil,true];
				_x setVariable ["acpl_radio_asked_lr_target",nil,true];
				_x setVariable ["acpl_radio_asked_sw_owner",nil,true];
				_x setVariable ["acpl_radio_asked_lr_owner",nil,true];
				_x setVariable ["acpl_radio_borrowed_sw",false,true];
				_x setVariable ["acpl_radio_borrowed_lr",false,true];
				_x setVariable ["acpl_radio_settings_sw",nil,true];
				_x setVariable ["acpl_radio_settings_lr",nil,true];
				
				[[(_x), 0, ["ACE_MainActions"], _hidebody],ace_interact_menu_fnc_addActionToObject] remoteExec ["call",0,true];
				
				acpl_radio_added = acpl_radio_added + [_x];
				publicvariable "acpl_radio_added";
			};
			if ((_x in acpl_msc_done) AND acpl_msc) then {} else {
				if (_x in acpl_msc_exception) then {
					acpl_msc_done = acpl_msc_done + [_x];
					publicvariable "acpl_msc_done";
				} else {
					if (side _x == WEST) then {
						[_x] spawn {
							private ["_acc", "_shake", "_speed", "_spot", "_time", "_general", "_courage", "_reload", "_x"];
							
							_x = _this select 0;
							
							_acc = random [(acpl_msc_west_acc select 0),acpl_msc_west_acc_mid,(acpl_msc_west_acc select 1)];
							_shake = random [(acpl_msc_west_shake select 0),acpl_msc_west_shake_mid,(acpl_msc_west_shake select 1)];
							_speed = random [(acpl_msc_west_speed select 0),acpl_msc_west_speed_mid,(acpl_msc_west_speed select 1)];
							_spot = random [(acpl_msc_west_spot select 0),acpl_msc_west_spot_mid,(acpl_msc_west_spot select 1)];
							_time = random [(acpl_msc_west_time select 0),acpl_msc_west_time_mid,(acpl_msc_west_time select 1)];
							_general = random [(acpl_msc_west_general select 0),acpl_msc_west_general_mid,(acpl_msc_west_general select 1)];
							_courage = random [(acpl_msc_west_courage select 0),acpl_msc_west_courage_mid,(acpl_msc_west_courage select 1)];
							_reload = random [(acpl_msc_west_reload select 0),acpl_msc_west_reload_mid,(acpl_msc_west_reload select 1)];
							
							sleep 5;
							
							_x setSkill ["aimingAccuracy", _acc];
							_x setVariable ["acpl_msc_AimAcc", _acc, true];
							_x setSkill ["aimingShake", _shake];
							_x setVariable ["acpl_msc_AimSha", _shake, true];
							_x setSkill ["aimingSpeed", _speed];
							_x setVariable ["acpl_msc_AimSpe", _speed, true];
							_x setSkill ["spotDistance", _spot];
							_x setVariable ["acpl_msc_SpoDis", _spot, true];
							_x setSkill ["spotTime", _time];
							_x setVariable ["acpl_msc_SpoTim", _time, true];
							_x setSkill ["general", _general];
							_x setVariable ["acpl_msc_Gen", _general, true];
							_x setSkill ["courage", _courage];
							_x setVariable ["acpl_msc_Cou", _courage, true];
							_x setSkill ["reloadSpeed", _reload];
							_x setVariable ["acpl_msc_Rel", _reload, true];
							
							acpl_msc_done = acpl_msc_done + [_x];
							publicvariable "acpl_msc_done";
							
							if (acpl_msc_debug) then {["Skill change: Done " + str(_x)] remoteExec ["systemchat",0];};
						};
					};
					if (side _x == EAST) then {
						[_x] spawn {
							private ["_acc", "_shake", "_speed", "_spot", "_time", "_general", "_courage", "_reload"];
							
							_x = _this select 0;
							
							_acc = random [(acpl_msc_east_acc select 0),acpl_msc_east_acc_mid,(acpl_msc_east_acc select 1)];
							_shake = random [(acpl_msc_east_shake select 0),acpl_msc_east_shake_mid,(acpl_msc_east_shake select 1)];
							_speed = random [(acpl_msc_east_speed select 0),acpl_msc_east_speed_mid,(acpl_msc_east_speed select 1)];
							_spot = random [(acpl_msc_east_spot select 0),acpl_msc_east_spot_mid,(acpl_msc_east_spot select 1)];
							_time = random [(acpl_msc_east_time select 0),acpl_msc_east_time_mid,(acpl_msc_east_time select 1)];
							_general = random [(acpl_msc_east_general select 0),acpl_msc_east_general_mid,(acpl_msc_east_general select 1)];
							_courage = random [(acpl_msc_east_courage select 0),acpl_msc_east_courage_mid,(acpl_msc_east_courage select 1)];
							_reload = random [(acpl_msc_east_reload select 0),acpl_msc_east_reload_mid,(acpl_msc_east_reload select 1)];
							
							sleep 5;
							
							_x setSkill ["aimingAccuracy", _acc];
							_x setVariable ["acpl_msc_AimAcc", _acc, true];
							_x setSkill ["aimingShake", _shake];
							_x setVariable ["acpl_msc_AimSha", _shake, true];
							_x setSkill ["aimingSpeed", _speed];
							_x setVariable ["acpl_msc_AimSpe", _speed, true];
							_x setSkill ["spotDistance", _spot];
							_x setVariable ["acpl_msc_SpoDis", _spot, true];
							_x setSkill ["spotTime", _time];
							_x setVariable ["acpl_msc_SpoTim", _time, true];
							_x setSkill ["general", _general];
							_x setVariable ["acpl_msc_Gen", _general, true];
							_x setSkill ["courage", _courage];
							_x setVariable ["acpl_msc_Cou", _courage, true];
							_x setSkill ["reloadSpeed", _reload];
							_x setVariable ["acpl_msc_Rel", _reload, true];
							
							acpl_msc_done = acpl_msc_done + [_x];
							publicvariable "acpl_msc_done";
							
							if (acpl_msc_debug) then {["Skill change: Done " + str(_x)] remoteExec ["systemchat",0];};
						};
					};
					if (side _x == resistance) then {
						[_x] spawn {
							private ["_acc", "_shake", "_speed", "_spot", "_time", "_general", "_courage", "_reload"];
							
							_x = _this select 0;
							
							_acc = random [(acpl_msc_resistance_acc select 0),acpl_msc_resistance_acc_mid,(acpl_msc_resistance_acc select 1)];
							_shake = random [(acpl_msc_resistance_shake select 0),acpl_msc_resistance_shake_mid,(acpl_msc_resistance_shake select 1)];
							_speed = random [(acpl_msc_resistance_speed select 0),acpl_msc_resistance_speed_mid,(acpl_msc_resistance_speed select 1)];
							_spot = random [(acpl_msc_resistance_spot select 0),acpl_msc_resistance_spot_mid,(acpl_msc_resistance_spot select 1)];
							_time = random [(acpl_msc_resistance_time select 0),acpl_msc_resistance_time_mid,(acpl_msc_resistance_time select 1)];
							_general = random [(acpl_msc_resistance_general select 0),acpl_msc_resistance_general_mid,(acpl_msc_resistance_general select 1)];
							_courage = random [(acpl_msc_resistance_courage select 0),acpl_msc_resistance_courage_mid,(acpl_msc_resistance_courage select 1)];
							_reload = random [(acpl_msc_resistance_reload select 0),acpl_msc_resistance_reload_mid,(acpl_msc_resistance_reload select 1)];
							
							sleep 5;
							
							_x setSkill ["aimingAccuracy", _acc];
							_x setVariable ["acpl_msc_AimAcc", _acc, true];
							_x setSkill ["aimingShake", _shake];
							_x setVariable ["acpl_msc_AimSha", _shake, true];
							_x setSkill ["aimingSpeed", _speed];
							_x setVariable ["acpl_msc_AimSpe", _speed, true];
							_x setSkill ["spotDistance", _spot];
							_x setVariable ["acpl_msc_SpoDis", _spot, true];
							_x setSkill ["spotTime", _time];
							_x setVariable ["acpl_msc_SpoTim", _time, true];
							_x setSkill ["general", _general];
							_x setVariable ["acpl_msc_Gen", _general, true];
							_x setSkill ["courage", _courage];
							_x setVariable ["acpl_msc_Cou", _courage, true];
							_x setSkill ["reloadSpeed", _reload];
							_x setVariable ["acpl_msc_Rel", _reload, true];
							
							acpl_msc_done = acpl_msc_done + [_x];
							publicvariable "acpl_msc_done";
							
							if (acpl_msc_debug) then {["Skill change: Done " + str(_x)] remoteExec ["systemchat",0];};
						};
					};
				};
			};
			if (acpl_medical AND !(_x in acpl_medical_done) AND !(_x in acpl_medical_mc) AND !(_x in acpl_medical_exep)) then {
				if (_x in _playable) then {
					private ["_medic"];
					
					[_x] call acpl_medic_remove;
		
					_medic = [_x] call ace_medical_fnc_isMedic;
					
					if (_medic) then {
						for "_i" from 1 to acpl_fieldDressing_med do {[_x,"ACE_fieldDressing"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_elasticBandage_med do {[_x,"ACE_elasticBandage"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_adenosine_med do {[_x,"ACE_adenosine"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_atropine_med do {[_x,"ACE_atropine"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_bloodIV_250_med do {[_x,"ACE_bloodIV_250"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_epinephrine_med do {[_x,"ACE_epinephrine"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_morphine_med do {[_x,"ACE_morphine"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_packingBandage_med do {[_x,"ACE_packingBandage"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_personalAidKit_med do {[_x,"ACE_personalAidKit"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_plasmaIV_med do {[_x,"ACE_plasmaIV"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_plasmaIV_250_med do {[_x,"ACE_plasmaIV_250"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_plasmaIV_500_med do {[_x,"ACE_plasmaIV_500"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_salineIV_med do {[_x,"ACE_salineIV"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_salineIV_250_med do {[_x,"ACE_salineIV_250"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_salineIV_500_med do {[_x,"ACE_salineIV_500"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_surgicalKit_med do {[_x,"ACE_surgicalKit"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_tourniquet_med do {[_x,"ACE_fieldDressing"] remoteExec ["additem",_x];};
					} else {
						for "_i" from 1 to acpl_fieldDressing_sol do {[_x,"ACE_fieldDressing"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_elasticBandage_sol do {[_x,"ACE_elasticBandage"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_adenosine_sol do {[_x,"ACE_adenosine"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_atropine_sol do {[_x,"ACE_atropine"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_epinephrine_sol do {[_x,"ACE_epinephrine"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_morphine_sol do {[_x,"ACE_morphine"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_packingBandage_sol do {[_x,"ACE_packingBandage"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_personalAidKit_sol do {[_x,"ACE_personalAidKit"] remoteExec ["additem",_x];};
						for "_i" from 1 to acpl_tourniquet_sol do {[_x,"ace_tourniquet"] remoteExec ["additem",_x];};
					};
					acpl_medical_done = acpl_medical_done + [_x];
					publicvariable "acpl_medical_done";
				} else {
					if (acpl_medical_AI) then {
						private ["_medic"];
						
						[_x] call acpl_medic_remove;
						
						_medic = [_x] call ace_medical_fnc_isMedic;
						
						if (_medic) then {
							for "_i" from 1 to acpl_fieldDressing_med_AI do {[_x,"ACE_fieldDressing"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_elasticBandage_med_AI do {[_x,"ACE_elasticBandage"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_adenosine_med_AI do {[_x,"ACE_adenosine"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_atropine_med_AI do {[_x,"ACE_atropine"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_bloodIV_250_med_AI do {[_x,"ACE_bloodIV_250"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_epinephrine_med_AI do {[_x,"ACE_epinephrine"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_morphine_med_AI do {[_x,"ACE_morphine"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_packingBandage_med_AI do {[_x,"ACE_packingBandage"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_personalAidKit_med_AI do {[_x,"ACE_personalAidKit"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_plasmaIV_med_AI do {[_x,"ACE_plasmaIV"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_plasmaIV_250_med_AI do {[_x,"ACE_plasmaIV_250"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_plasmaIV_500_med_AI do {[_x,"ACE_plasmaIV_500"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_salineIV_med_AI do {[_x,"ACE_salineIV"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_salineIV_250_med_AI do {[_x,"ACE_salineIV_250"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_salineIV_500_med_AI do {[_x,"ACE_salineIV_500"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_surgicalKit_med_AI do {[_x,"ACE_surgicalKit"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_tourniquet_med_AI do {[_x,"ace_tourniquet"] remoteExec ["additem",_x];};
						} else {
							for "_i" from 1 to acpl_fieldDressing_AI do {[_x,"ACE_fieldDressing"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_elasticBandage_AI do {[_x,"ACE_elasticBandage"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_adenosine_AI do {[_x,"ACE_adenosine"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_atropine_AI do {[_x,"ACE_atropine"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_epinephrine_AI do {[_x,"ACE_epinephrine"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_morphine_AI do {[_x,"ACE_morphine"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_packingBandage_AI do {[_x,"ACE_packingBandage"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_personalAidKit_AI do {[_x,"ACE_personalAidKit"] remoteExec ["additem",_x];};
							for "_i" from 1 to acpl_tourniquet_AI do {[_x,"ace_tourniquet"] remoteExec ["additem",_x];};
						};
						acpl_medical_done = acpl_medical_done + [_x];
						publicvariable "acpl_medical_done";
					};
				};
			};
		} foreach allunits;
		
		sleep 5;
	};
};
publicvariable "acpl_loop";

if (acpl_medical) then {
	{
		_x additemCargoGlobal ["ACE_fieldDressing",acpl_fieldDressing_veh];
		_x additemCargoGlobal ["ACE_elasticBandage",acpl_elasticBandage_veh];
		_x additemCargoGlobal ["ACE_adenosine",acpl_adenosine_veh];
		_x additemCargoGlobal ["ACE_atropine",acpl_atropine_veh];
		_x additemCargoGlobal ["ACE_bloodIV",acpl_bloodIV_veh];
		_x additemCargoGlobal ["ACE_bodyBag",acpl_bodyBag_veh];
		_x additemCargoGlobal ["ACE_epinephrine",acpl_epinephrine_veh];
		_x additemCargoGlobal ["ACE_morphine",acpl_morphine_veh];
		_x additemCargoGlobal ["ACE_packingBandage",acpl_packingBandage_veh];
		_x additemCargoGlobal ["ACE_plasmaIV",acpl_plasmaIV_veh];
		_x additemCargoGlobal ["ACE_salineIV",acpl_salineIV_veh];
		_x additemCargoGlobal ["ACE_surgicalKit",acpl_surgicalKit_veh];
		_x additemCargoGlobal ["ace_tourniquet",acpl_tourniquet_veh];
		
		_x setVariable ["ace_medical_isMedicalFacility",true,true];
		_x setVariable ["ace_medical_medicClass",2,true];
	} foreach acpl_medical_mc
};

[[], acpl_loop] remoteExec ["spawn",2];
[[], acpl_tfr_loop] remoteExec ["spawn",2];
[[], acpl_tfr_speaking_loop] remoteExec ["spawn",2];

acpl_fncs_initied = true;
publicvariable "acpl_fncs_initied";

if (acpl_fnc_debug) then {["ACPL FNCS INITED"] remoteExec ["systemchat",0];};
