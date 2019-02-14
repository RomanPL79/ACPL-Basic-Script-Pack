if (isserver) then {
	[
		[
			0,
			[],
			true,
			true,
			[],
			true,
			false,
			"Sample text"
		],"acpl_fncs_init.sqf"] remoteExec ["execVM",2];
};

//Komendy do briefingu:
/* 
 - <br/> - przechodzi do nowej lini
 - <marker name='marker_name'>Tekst do kliknięcia</marker> - tworzy tekst po kliknięciu na który pokazuje miejsce na mapie oznaczone markerem, 
marker_name <- nazwa markeru który ma pokazać
/*
