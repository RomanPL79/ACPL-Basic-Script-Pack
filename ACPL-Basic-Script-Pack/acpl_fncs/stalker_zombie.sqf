private ["_unit","_faces","_items"];

_unit = _this select 0;
_faces = ["RyanZombieFace1","RyanZombieFace2","RyanZombieFace3","RyanZombieFace4","RyanZombieFace6","RyanZombieFace5"];

//_nul = [this] execVM "acpl_fncs\stalker_zombie.sqf";
//v1.0

if (!isserver) exitwith {};

_unit disableAI "FSM";
_unit disableAI "SUPPRESSION";
_unit disableAI "COVER";
_unit disableAI "AUTOCOMBAT";
_unit forceWalk true;
_unit setSkill ["aimingAccuracy", 0.01];
_unit setSkill ["aimingShake", 0.01];
_unit setSkill ["aimingSpeed", 0.01];
_unit setSkill ["spotDistance", 0.01];
_unit setSkill ["spotTime", 0.01];
_unit setSkill ["general", 0.01];
_unit setSkill ["courage", 0.01];
_unit setSkill ["reloadSpeed", 0.01];
_unit setunitpos "up";
_unit setVariable ["VCOM_NOAI",true];
_unit setHitPointDamage ["hitBody", 0.01];
_unit setHitPointDamage ["hitHands", 0.01];
_unit setHitPointDamage ["hitLegs", 0.01];
_unit setHitPointDamage ["hitArms", 0.01];
_unit setHitPointDamage ["hitNeck", 0.01];
_unit setHitPointDamage ["hitChest", 0.01];
_face = _faces select floor(random(count _faces));
[_unit,_face] remoteExec ["setFace",0,true];
_unit setSpeaker "NoVoice";
sleep 10;
_unit setHit ["legs", 1];

_items = items _unit;
for "_i" from 1 to ({_x == "ACE_fieldDressing"} count _items) do {_unit removeitem "ACE_fieldDressing"};
for "_i" from 1 to ({_x == "ACE_elasticBandage"} count _items) do {_unit removeitem "ACE_elasticBandage"};
for "_i" from 1 to ({_x == "ACE_adenosine"} count _items) do {_unit removeitem "ACE_adenosine"};
for "_i" from 1 to ({_x == "ACE_atropine"} count _items) do {_unit removeitem "ACE_atropine"};
for "_i" from 1 to ({_x == "ACE_bloodIV"} count _items) do {_unit removeitem "ACE_bloodIV"};
for "_i" from 1 to ({_x == "ACE_bloodIV_250"} count _items) do {_unit removeitem "ACE_bloodIV_250"};
for "_i" from 1 to ({_x == "ACE_bloodIV_500"} count _items) do {_unit removeitem "ACE_bloodIV_500"};
for "_i" from 1 to ({_x == "ACE_bodyBag"} count _items) do {_unit removeitem "ACE_bodyBag"};
for "_i" from 1 to ({_x == "ACE_epinephrine"} count _items) do {_unit removeitem "ACE_epinephrine"};
for "_i" from 1 to ({_x == "ACE_morphine"} count _items) do {_unit removeitem "ACE_morphine"};
for "_i" from 1 to ({_x == "ACE_packingBandage"} count _items) do {_unit removeitem "ACE_packingBandage"};
for "_i" from 1 to ({_x == "ACE_personalAidKit"} count _items) do {_unit removeitem "ACE_personalAidKit"};
for "_i" from 1 to ({_x == "ACE_plasmaIV"} count _items) do {_unit removeitem "ACE_plasmaIV"};
for "_i" from 1 to ({_x == "ACE_plasmaIV_250"} count _items) do {_unit removeitem "ACE_plasmaIV_250"};
for "_i" from 1 to ({_x == "ACE_plasmaIV_500"} count _items) do {_unit removeitem "ACE_plasmaIV_500"};
for "_i" from 1 to ({_x == "ACE_salineIV"} count _items) do {_unit removeitem "ACE_salineIV"};
for "_i" from 1 to ({_x == "ACE_salineIV_250"} count _items) do {_unit removeitem "ACE_salineIV_250"};
for "_i" from 1 to ({_x == "ACE_salineIV_500"} count _items) do {_unit removeitem "ACE_salineIV_500"};
for "_i" from 1 to ({_x == "ACE_surgicalKit"} count _items) do {_unit removeitem "ACE_surgicalKit"};
for "_i" from 1 to ({_x == "ace_tourniquet"} count _items) do {_unit removeitem "ace_tourniquet"};