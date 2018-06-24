Podstawowa paczka skryptów ACPL [BETA]

Paczka zawiera: (użycie opisane niżej)
* Wbudowany VCOMAI w wersji 3.02
* Wbudowany Taskmaster (skrypt do tworzenia briefingów i zarządzania zadaniami)
* Skrypt dodający automatycznie odpowiednią ilość medykamentów grywalnym jednostką [z możliwością konfiguracji]
* Skrypt zarządzający wrogiem ustawionym na stałe w budynkach
* Skrypt pozwalający wyświetlać animacje w środowisku MP (WIP)
* Skrypt pozwalający tworzyć zombie-stalkerów
* Skrypt pozwalający na przejmowanie władzy nad HC
* Skrypt pozwalający na przejmowanie oraz użycie artylerii
* Skrypt ustawiający skill wszystkich jednostek na mapie [z możliwością konfiguracji]
* Skrypt pozwalający na ustawienie gogli jednostką graczy (zamiast tych ustawionych w profilu)
* Skrypt pozwalający na przeładowanie amunicji z nie pasujących do naszej broni magazynków do pasujących do naszej broni magazynków [IF44 only!]

CHANGELOG:
*BETA:
- Wydanie paczki, duh

Instalacja:
Zawartość paczki wrzucamy do pliku misji, w pliku init.sqf ustawiamy wartości w ostatniej linijce dla:
[x1,[x2],x3,x4] execVM "acpl_fncs_init.sqf";
* x1 - wersja teatru, 0 dla modern, 1 dla WW2
* x2 - nazwy pojazdów medycznych, zapisane w [], np.: [pojazd1,pojazd2]
* x3 - czy właczyć VCOMAI, true/false
* x4 - czy zablokować możliwość chodzenia grywalnemu AI (odblokować może dowódca drużyny w menu ACE'a), true/false

W init.sqf znajduje się również brefing, instrukcja do jego skonfigurowania znajduje się w shk_taskmaster.sqf

W pliku acpl_fncs_init.sqf możemy dodatkowo skonfigurować ilość medykamentów dla graczy oraz ustawienia VCOMAI

Ustawienia skilla jednostek znajdziemy acpl_fncs\acpl_msc\ustawienia.sqf, skill jest ustawiany dla każdej ze stron oddzielnie! Jednostki spawnowane w trakcie rozgrywki również podlegają modyfikacji.

Użycie:
> DoStop.sqf [v1.5] - skrypt zarządzający przeciwnikiem ustawionym na stałe w budynkach:
W init jednostki wklejamy: _nul = [this,pos,ducking] execVM "acpl_fncs\dostop.sqf"; gdzie:

* this - nazwa jednostki
* pos - pozycja w jakiej jednostka ma stać - "up"/"middle"/"down"
* ducking - czy jednostka ma chować się przed ostrzałem/kiedy przeładowywuje - true/false

Aby odblokować jednostkę, aby np.: wyszła z budynku należy użyć komendy: nazwa_jednostki setvariable ["acpl_dostop",false,true];
Aby zmienić pozycje jednostki należy użyć komendy: nazwa_jednostki setvariable ["acpl_dostop_pos",numer,true]; w miejscu numer wpisując numer pozycji - 2 = stojąca, 1 = kucająca, 0 = leżąca

> Animations [v1.0] - skrypt pozwalający ustawić animacje jednostką, na razie statycznie (brak funkcji wyjścia z animacji gdy pod ostrzałem, itd)
W init jednostki wpisujemy: _nul = ["ANIM",[this,"animacja"]] execVM "acpl_fncs\acpl_animations.sqf"; gdzie:

* this - nazwa jednostki
* "animacja" - classname animacji (należy użyć Animation Viewer'a w edytorze aby znaleźć klase)

Aby wyłaczyć animacje należy użyć komendy: nazwa_jednostki setVariable ["acpl_animation_active",false,true];

> AddGoogles [v1.0] - skrypt pozwalający dodać gogle graczowi (zwykle są one nadpisywane tymi ustawionymi w profilu gracza)
W init jednostki wpisujemy: _nul = [this,"classname"] execVM "acpl_fncs\addgoggles.sqf"; gdzie:

* this - nazwa jednostki
* "classname" - classname gogli

> HC_TakeControl [v1.0] - skrypt pozwalający na przejęcie kontroli nad High Command pod menu ACE'a
Ustawiamy i konfigurujemy moduły HC w edytorze. Moduły nie muszą być nazwane lecz muszą być zesobą synchronizowane. Nazwać należy grupy które mają być podległe HC
W init jednostki wpisujemy _nul = [_unit,[_grps]] execVM "acpl_fncs\HC_takecontrol.sqf"; gdzie:

* _unit - nazwa jednostki która ma pierwotnie posiadać dostęp do HC
* _grps - nazwy podległych grup

> Take_Arty [v1.0] - skrypt dodający do twojego oddziału artylerie (ustawioną wcześniej na mapie)
W init wklejamy: _nul = [[_arty1,_arty2],_grp] execVM "acpl_fncs\take_arty.sqf"; gdzie:

* [_arty1,_arty2] - są to nazwy baterii artyleryjskich
* _grp - nazwa grupy (musi być nazwana!) do której aryleria ma być pierwotnie przypisana

> Stalker_Zombie [v1.0] - skrypt zmieniający jednostkę w przygłupie zombie
W init jednostki wklejamy: _nul = [this] execVM "acpl_fncs\stalker_zombie.sqf"; gdzie:

* this - nazwa jednostki
