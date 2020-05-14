if (!isserver) exitwith {};

missionNamespace setVariable ["psz_intro",true,true];

enableRadio false;
titleCut ["","BLACK IN",8];
sleep 6;
[localize "STR_PSZ_Mission_authors_l1", localize "STR_PSZ_Mission_authors_l2", localize "STR_PSZ_Mission_authors_l3"] spawn BIS_fnc_infoText;
sleep 8;
[localize "STR_PSZ_Mission_missionpack_l1", localize "STR_PSZ_Mission_missionpack_l2", localize "STR_PSZ_Mission_missionpack_l3"] spawn BIS_fnc_infoText;
sleep 8;
[localize "STR_PSZ_Mission_created_l1", localize "STR_PSZ_Mission_created", localize "STR_PSZ_Mission_author"] spawn BIS_fnc_infoText;
sleep 8;
[localize "STR_PSZ_Mission_name", "", ""] spawn BIS_fnc_infoText;
if (isserver) then {
	CO_boi globalchat localize "STR_PSZ_Mission_chatter_pseudobriefing";
};
