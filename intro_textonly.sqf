if (!isserver) exitwith {};

/*
	Miejsce na komendy odpalane przez serwer
*/

missionNamespace setVariable ["psz_intro",true,true];

private _intro = {
	if (isserver) then {
		waitUntil {psz_serverloaded};
	} else {
		waitUntil {player getVariable ["psz_missionloaded", false]};
		enableRadio false;
	};
	if (isNil "psz_safestart") then {psz_safestart = false;};
	if (psz_safestart) then {
		titleCut ["","BLACK IN",1];
		waitUntil {!psz_safestart};
		titleCut ["","BLACK",0.2];
	};
	//playMusic "AmbientTrack01a_F";
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
		/*
		Miejsce na komendy wykonywane przez serwer po zakończeniu intra
		*/
	};
};

[[],_intro] remoteExec ["spawn",0];
