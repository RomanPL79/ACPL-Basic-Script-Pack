if (!isserver) exitwith {};

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

acpl_medical_fncs = true;
publicvariable "acpl_medical_fncs";

if (acpl_fnc_debug) then {["ACPL FNCS MEDICAL LOADED"] remoteExec ["systemchat",0];};