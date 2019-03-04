private ["_type","_vcom","_static","_playable","_action","_ied_init","_safe_start","_text","_version"];

//Podstawowe skrypty ACPL
//v1.1j

_type = _this select 0;
acpl_medical_mc = _this select 1;
_vcom = _this select 2;
_static = _this select 3;
acpl_medical_exep = _this select 4;
_ied_init = _this select 5;
_safe_start = _this select 6;
_text = _this select 7;

_version = "v1.1j";

acpl_fncs_initied = false;
acpl_mainloop_done = false;

acpl_fnc_debug = true;
publicvariable "acpl_fnc_debug";

acpl_custommarkers = true;						//Czy nanosić markery dla dostawionych budynków?
publicvariable "acpl_custommarkers";

if (acpl_fnc_debug) then {["ACPL FNCS INITIATION"] remoteExec ["systemchat",0];};

[1600] remoteExec ["setViewDistance",0];

if (!isserver) exitwith {};

[] execVM "briefing.sqf";
if (acpl_fnc_debug) then {["BRIEFING LOADED"] remoteExec ["systemchat",0];};

_nul = [_version] execVM "acpl_info_init.sqf";

_playable = [] + playableUnits + switchableUnits + allPlayers;

[["","BLACK IN", 7]] remoteExec ["titleCut",0];

if (isDedicated) then {
	{[[_text, str(date select 2) + "." + str(date select 1) + "." + str(date select 0), str(name _x)],BIS_fnc_infoText] remoteExec ["spawn",_x,true];} foreach _playable;
} else {
	[[_text, str(date select 2) + "." + str(date select 1) + "." + str(date select 0), str(name player)],BIS_fnc_infoText] remoteExec ["spawn",0,true];
};

acpl_fncs_initied = false;
publicvariable "acpl_fncs_initied";

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
acpl_dostop_retreat_chance = 30;				//Szansa w % na ucieczkę z zajmowaniej pozycji przez jednostke (dodatkowo wpływa na nią odwaga jednostki)
acpl_dostop_retreat_distance = 30;				//Odległość w jakiej musi być przeciwnik aby rozważyć ucieczkę
acpl_dostop_retreat_distance = 30;				//Odległość w jakiej musi być przeciwnik aby rozważyć ucieczkę
acpl_dostop_ammo_rearm = 0.5;					//Ile % amunicji musi zostać zużyte aby ją uzupełnić

{publicvariable _x;} foreach ["acpl_dostop_weap_chance","acpl_dostop_weap_distance","acpl_dostop_retreat_chance","acpl_dostop_retreat_distance"];

acpl_tfr_debug = false;							//Debug systemu wykrywanie gdy mówisz
acpl_tfr_know = 1.5;							//Maksymalna wartość jaką może dodać do wiedzy AI po usłyszeniu rozmowy
acpl_tfr_time = 60;								//Po jakim czasie wróg 'zapomina' o głosach i może zostać nadpisany przez nowe głosy

{publicvariable _x;} foreach ["acpl_tfr_debug","acpl_tfr_know","acpl_tfr_time"];

//Ustawienia skilla AI

acpl_msc = true;								//Włącznik
acpl_msc_exception = [];						//Wykluczone ze zmiany skilla jednostki
acpl_msc_debug = false;							//Debug

acpl_arty_maxmistake_dir = 0.5;					//Maksymalna pomyłka załogi artylerii, w kątach azymutu
acpl_arty_maxmistake_angle = 200;				//Maksymalna pomyłka załogi artylerii, w odległości (całe 200m będzie na odległości 1000m)
acpl_arty_dispersion = 50;						//Maksymalny rozrzut (wyliczany dla pojedyńczego pocisku, nie celu)

//WEST
acpl_msc_west_random = 2;						//Im bliżej jedynki tym skill będzie losowany bliżej górnej granicy

acpl_msc_west_acc = [0.1, 0.15];					//Granice ustawienia celności
acpl_msc_west_shake = [0.1, 0.15];				//Stabilność ręki w czasie strzelania
acpl_msc_west_speed = [0.1, 0.15];				//Prędkość celowania
acpl_msc_west_spot = [0.2, 0.3];				//Dystans wykrywania
acpl_msc_west_time = [0.2, 0.4];				//Czas wykrywania
acpl_msc_west_general = [0.4, 0.6];				//Skill generalny - używanie osłon, flankowanie, generalny brain-factor
acpl_msc_west_courage = [0.4, 0.6];				//Odwaga - im więcej tej wartości tym trudniej przycisnąć wroga
acpl_msc_west_reload = [0.1, 0.2];				//Prędkość przeładowania

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
acpl_msc_resistance_random = 2;					//Im bliżej jedynki tym skill będzie losowany bliżej górnej granicy

acpl_msc_resistance_acc = [0.1, 0.25];			//Granice ustawienia celności
acpl_msc_resistance_shake = [0.1, 0.25];		//Stabilność ręki w czasie strzelania
acpl_msc_resistance_speed = [0.1, 0.25];		//Prędkość celowania
acpl_msc_resistance_spot = [0.2, 0.3];			//Dystans wykrywania
acpl_msc_resistance_time = [0.2, 0.4];			//Czas wykrywania
acpl_msc_resistance_general = [0.4, 0.6];		//Skill generalny - używanie osłon, flankowanie, generalny brain-factor
acpl_msc_resistance_courage = [0.4, 0.6];		//Odwaga - im więcej tej wartości tym trudniej przycisnąć wroga
acpl_msc_resistance_reload = [0.1, 0.2];		//Prędkość przeładowania

{publicvariable _x;} foreach ["acpl_msc_resistance_reload","acpl_msc_resistance_courage","acpl_msc_resistance_general","acpl_msc_resistance_time","acpl_msc_resistance_spot","acpl_msc_resistance_speed","acpl_msc_resistance_shake","acpl_msc_resistance_acc","acpl_msc_resistance_random","acpl_msc_east_reload","acpl_msc_east_courage","acpl_msc_east_general","acpl_msc_east_time","acpl_msc_east_spot","acpl_msc_east_speed","acpl_msc_east_shake","acpl_msc_east_acc","acpl_msc_east_random","acpl_msc_west_reload","acpl_msc_west_courage","acpl_msc_west_general","acpl_msc_west_time","acpl_msc_west_spot","acpl_msc_west_speed","acpl_msc_west_shake","acpl_msc_west_acc","acpl_msc_west_random","acpl_msc_debug","acpl_msc_exception","acpl_msc"];

acpl_betterAI_detection = 1;					//Wartość powyżej której jednostka 'widzi' przeciwnika
acpl_betterAI_detection_time = 10;				//Czas po którym jednostka wykrywa przeciwnika globalnie
acpl_betterAI_morale_enabled = false;			//Włacznik systemu morali (im mniejsze morale tym przeciwnik gorzej walczy)
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

acpl_betterAI_arty_enabled = false;				//Czy AI może korzystać z artylerii
acpl_betterAI_arty_autofo = false;				//Czy automatycznie dodawać obserwatorów artyleryjskich?
acpl_betterAI_arty_autofo_itemradio = false;	//Czy dodawać FO wszystkim jednostką posiadającym jakiekolwiek radio?
acpl_betterAI_arty_autofo_lr = true;			//Czy dodawać FO jednostką które posiadają długie radio?
acpl_betterAI_arty_autofo_leader = true;		//Czy dodawac FO dowódcą drużyn?
acpl_betterAI_arty_worth = 1;					//Minimalna wartość celu dla wezwania ostrzału
acpl_betterAI_arty_dangerclose = 300;			//Jak daleko od celu muszą być siły sprzymierzone aby można było wezwać wsparcie arty

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
acpl_plasmaIV_500_sol = 0;
acpl_salineIV_500_sol = 0;

//Dla medyka
acpl_fieldDressing_med = 10;
acpl_elasticBandage_med = 30;
acpl_adenosine_med = 0;
acpl_atropine_med = 0;
acpl_epinephrine_med = 20;
acpl_morphine_med = 20;
acpl_packingBandage_med = 20;
acpl_personalAidKit_med = 0;
acpl_plasmaIV_med = 0;
acpl_plasmaIV_250_med = 0;
acpl_plasmaIV_500_med = 3;
acpl_salineIV_med = 0;
acpl_salineIV_250_med = 0;
acpl_salineIV_500_med = 3;
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
	
	acpl_ww2_change_m1garand = true;				//Czy zamieniać M1 garand z IF44 na M1 Garand z FoW?
	acpl_ww2_change_leeenfield = true;				//Czy wymienić lee enfieldy z FoW na lepsze?
	
	{publicvariable _x;} foreach ["acpl_ww2_change_m1garand", "acpl_ww2_change_leeenfield"];
} else {
	acpl_ww2_change_m1garand = false;
	acpl_ww2_change_leeenfield = false;
	
	{publicvariable _x;} foreach ["acpl_ww2_change_m1garand", "acpl_ww2_change_leeenfield"];
};

{publicvariable _x;} foreach ["acpl_salineIV_500_sol","acpl_plasmaIV_500_sol","acpl_fieldDressing_sol","acpl_elasticBandage_sol","acpl_adenosine_sol","acpl_atropine_sol","acpl_epinephrine_sol","acpl_morphine_sol","acpl_packingBandage_sol","acpl_personalAidKit_sol","acpl_tourniquet_sol"];
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
	(group _x) setVariable ["VCOM_NOAI",true,true];
	(group _x) setVariable ["Vcm_Disable",true,true];
} foreach _playable;

if (acpl_custommarkers) then {
	private ["_acpl_config_buildings"];
	
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
		
	acpl_add_treemarker = {
		private ["_object", "_pos", "_bound", "_rot", "_bmin", "_markerName", "_marker"];

		_object = _this select 0;

		_pos = getPosATL _object;
		_rot = getDir _object;
				
		_markerName = format[ "bound_%1", (_object call BIS_fnc_objectVar)];

		_marker = createMarker [_markerName, _pos];
		_marker setMarkerShape "ICON";
		_marker setMarkerSize [1, 1];
		_marker setMarkerDir _rot;
		_marker setMarkerType "loc_tree";
	};
	publicvariable "acpl_add_treemarker";
		
	acpl_add_bushmarker = {
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
		_marker setMarkerColor "Colorgreen";
	};
	publicvariable "acpl_add_bushmarker";
	
	acpl_config_buildings_inited = false;
	publicvariable "acpl_config_buildings_inited";
	_acpl_config_buildings = compile preprocessFileLineNumbers "acpl_configs\buildings.sqf";
	[] call _acpl_config_buildings;
	
	[] spawn {
		waitUntil {acpl_config_buildings_inited};
		
		{
			if (!(typeof _x in acpl_config_notabuilding)) then {
				_nul = [_x] spawn acpl_add_buildingmarker;
			};
		} foreach allMissionObjects "building";
		{
			if ((typeof _x in acpl_config_bush)) then {
				_nul = [_x] spawn acpl_add_bushmarker;
			};
			if ((typeof _x in acpl_config_tree)) then {
				_nul = [_x] spawn acpl_add_treemarker;
			};
		} foreach allMissionObjects "all";
		{
			if ((typeof _x in acpl_config_bush)) then {
				_nul = [_x] spawn acpl_add_bushmarker;
			};
			if ((typeof _x in acpl_config_tree)) then {
				_nul = [_x] spawn acpl_add_treemarker;
			};
		} foreach allSimpleObjects [];
		
		if (acpl_fnc_debug) then {["ACPL FNCS CUSTOM MARKERS ADDED"] remoteExec ["systemchat",0];};
	};
};

if (_safe_start) then {
	private ["_acpl_safestart_functions"];
	
	acpl_safestart = true;
	publicvariable "acpl_safestart";
	
	if (acpl_fnc_debug) then {["ACPL FNCS: SAFESTART IS ENABLED"] remoteExec ["systemchat",0];};
	
	{
		[_x,"MOVE"] remoteExec ["disableAI",0];
		[_x,"TARGET"] remoteExec ["disableAI",0];
		[_x,"AUTOTARGET"] remoteExec ["disableAI",0];
	} foreach allunits;
	
	acpl_safestart_units = [];
	publicvariable "acpl_safestart_units";
	
	_acpl_safestart_functions = compile preprocessFileLineNumbers "acpl_fncs_toload\safestart.sqf";
	[] call _acpl_safestart_functions;
	
	acpl_safestart_inited = true;
	publicvariable "acpl_safestart_inited";
};

private ["_acpl_animations_functions", "_acpl_checking_functions", "_acpl_spawning_functions", "_acpl_medical_functions"];

_acpl_animations_functions = compile preprocessFileLineNumbers "acpl_fncs_toload\animations.sqf";
[] call _acpl_animations_functions;

_acpl_checking_functions = compile preprocessFileLineNumbers "acpl_fncs_toload\AI_checking_funcs.sqf";
[] call _acpl_checking_functions;

_acpl_spawning_functions = compile preprocessFileLineNumbers "acpl_fncs_toload\spawning.sqf";
[] call _acpl_spawning_functions;

_acpl_medical_functions = compile preprocessFileLineNumbers "acpl_fncs_toload\medical.sqf";
[] call _acpl_medical_functions;

if (_ied_init) then {
	private ["_acpl_ied_functions"];

	_acpl_ied_functions = compile preprocessFileLineNumbers "acpl_fncs_toload\ied.sqf";
	_null = [] call _acpl_ied_functions;
	
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

private ["_acpl_tfr_functions", "_acpl_arty_functions", "_acpl_loop_functions"];

_acpl_tfr_functions = compile preprocessFileLineNumbers "acpl_fncs_toload\tfr.sqf";
[] call _acpl_tfr_functions;
	
_acpl_arty_functions = compile preprocessFileLineNumbers "acpl_fncs_toload\arty.sqf";
[] call _acpl_arty_functions;

acpl_arty_marker_id = 0;
publicvariable "acpl_arty_marker_id";

_acpl_loop_functions = compile preprocessFileLineNumbers "acpl_fncs_toload\loop.sqf";
[] call _acpl_loop_functions;

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

[[_static], acpl_loop] remoteExec ["spawn",2];

acpl_fncs_initied = true;
publicvariable "acpl_fncs_initied";

if (acpl_fnc_debug) then {["ACPL FNCS INITED"] remoteExec ["systemchat",0];};
