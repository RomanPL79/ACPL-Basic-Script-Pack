params ["_version"];
private ["_info", "_radio", "_ied", "_jammer", "_unlockAI", "_hc", "_arty", "_safestart"];

_info = ("W uruchomionym scenariuszu uruchomiona jest Podstawowa Paczka Skryptów ACPL w wersji " + _version + "
<br/>
<br/>
Paczka ta w obecnej wersji poszerza możliwości graczy oraz AI o:<br/>
* Możliwość przejmowania dowództwa nad High Command (jeżeli jest obecne)<br/>
* Dodatkowe funkcje radia - teraz można je łatwo pożyczać oraz wyciszać<br/>
* Od teraz pobliski wróg usłyszy wasze rozmowy<br/>
* Zaawansowane możliwości wzywania wsparcia artyleryjskiego<br/>
* Możliwość zakłócania ładunków wybuchowych (jeżeli w misji obecny jest jammer)<br/>
* Symulacje obserwatorów IED<br/>
* Ulepszone procesy myśleniowe AI");

_radio = "Od teraz macie możliwość szybkiego i prostego wyciszenia swojego radia w menu interkacji osobistych ACE'a.<br/>
<br/>
Możecie również pożyczać od innych graczy oraz AI radio krótkie lub długie. Aby to zrobić należy wybrać na osobie od której chcemy pożyczyć radio odpowiednią opcje za pomocą menu interakcji ACE'a.<br/>
Jeżeli osobą pożyczającą jest gracz musi on zaakceptować twoją prośbę w menu interkacji osobistych ACE'a.<br/>
Aby zwrócić radio należy użyć odpowiedniej opcji w menu interkacji osobistych ACE'a.<br/>
Po pożyczeniu radia należy nie oddalać się od właściciela - jeżeli odejdziesz na więcej niż 5m automatycznie oddasz radio!<br/>
<br/>
Dodatkowo przeciwnik może usłyszeć wasze rozmowy jeżeli znajduje się wystarczająco blisko was.";

_ied = "Paczka posiada system symulacji obserwatora IED. Sprawia on, że w wypadku napotkania IED może posiadać ona obserwatora który znajduje się gdzieś w okolicy z zapalnikiem.<br/>
Obserwator ocenia czy warto wysadzić ładunek oraz detonuje go jeżeli uzna to za dobry pomysł.<br/>
Obserwatora należy schwytać lub zlikwidować jeżeli chcecie pozbyć się zapalnika. Najłatwiej rozpoznać obserwatora poprzez przeszukanie go - powinien mieć przy sobie detonator.<br/>
Obserwator może mieć przy sobie schowaną broń co nie oznacza, że za każdym razem jej użyje - im więcej ludzi będzie go obserwować tym mniejsza szansa, że zrobi coś głupiego.<br/>
Istnieje szansa, że obserwator stchórzy po zauważeniu żołnierzy i zacznie uciekać, schowa się lub pozbędzie się dowodów.";

_jammer = "W niektórych wozach może być zainstalowany system zakłócania sygnałów radiowych lub/i komórkowych.<br/>
Aby go użyć należy siedząc w pojeździe wybrać odpowiednią opcje w menu interkacji osobistych ACE'a.<br/>
Jammer zakłóca zapalniki graczy oraz AI.";

_hc = "Jeżeli w misji został użyty system High Command istnieje opcja przejęcia nad nim kontroli (np: w przypadku śmierci poprzedniego dowódcy).<br/>
Aby tego dokonać należy wybrać odpowiednią opcje w menu interkacji osobistych ACE'a.";

_arty = "W paczce znajduje się zaawansowany system wzywania artylerii.<br/>
Aby z niego skorzystać należy użyć odpowiedniej opcji w menu interkacji osobistych ACE'a.<br/>
Menu te jest dostępne jedynie dla graczy wyznaczonych jako FO.<br/>
Na samym początku należy wybrać baterię której ogień chcesz naprowadzać.<br/>
Następnie należy wybrać rodzaj używanej amunicji (restartuje się po każdej zmianie baterii).<br/>
Kolejnym krokiem będzie ustalenie dokładnej liczby pocisków oraz rodzaju ostrzału.<br/>
Po ustawieniu wszystkiego użyj opcji 'wezwij' i zaznacz koordynaty na mapie.<br/>
<br/>
Jeżeli wybrałeś baterię z której już strzelałeś możesz wprowadzić poprawkę aby się wstrzelać.<br/>
Aby wezwać ostrzał z naniesioną poprawką uzyj opcji 'wezwij z poprawką'.<br/>
<br/>
Możesz również sprawdzić ilość pozostałej amunicji za pomocą opcji 'sprawdź stan amunicji'.";

_unlockAI = "Istnieje możliwość, że możliwość chodzenia AI znajdującego się w twojej grupie jest zablokowana na starcie misji.<br/>
Aby ją odblokować należy użyć odpowiednią opcje w menu interkacji osobistych ACE'a.<br/>
Opcja ta widoczna jest tylko dla dowódcy grupy.";

_safestart = "W niektórych sceniariuszach istnieje możliwość przygotowania się do wykonywanej misji.<br/>
System umożliwiający to nazywa się SafeStart i sprawia, że misja nie rozpocznie się dopóki nie będziecie tego chcieli.<br/>
Aby rozpocząć misje należy użyć w menu interkacji ACE'a znajdującego się na jednej z jednostek lub przedmiotów w okolicy (mission maker powinien określić go w fazie briefingu).<br/>
Czasami na tym samym obiekcie będzie opcja zmiany godziny.";

waitUntil {acpl_fncs_initied};

{	
	[_x,["acpl_fncs_info","Paczka Skryptów ACPL"]] remoteExec ["createDiarySubject",_x,true];
	
	
	[_x,["acpl_fncs_info",["TFR Radio", _radio]]] remoteExec ["createDiaryRecord",_x,true];
	[_x,["acpl_fncs_info",["System IED", _ied]]] remoteExec ["createDiaryRecord",_x,true];
	[_x,["acpl_fncs_info",["System Jammer", _jammer]]] remoteExec ["createDiaryRecord",_x,true];
	[_x,["acpl_fncs_info",["System Artylerii", _arty]]] remoteExec ["createDiaryRecord",_x,true];
	[_x,["acpl_fncs_info",["System SafeStart", _safestart]]] remoteExec ["createDiaryRecord",_x,true];
	[_x,["acpl_fncs_info",["Odblokowania AI", _unlockAI]]] remoteExec ["createDiaryRecord",_x,true];
	[_x,["acpl_fncs_info",["High Command", _hc]]] remoteExec ["createDiaryRecord",_x,true];
	
	[_x,["acpl_fncs_info",["Podstawowe Informacje", _info]]] remoteExec ["createDiaryRecord",_x,true];
} foreach allunits;