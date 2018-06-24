Podstawowa paczka skryptów ACPL [BETA]

Paczka zawiera: (u¿ycie opisane ni¿ej)
* Wbudowany VCOMAI w wersji 3.02
* Wbudowany Taskmaster (skrypt do tworzenia briefingów i zarz¹dzania zadaniami)
* Skrypt dodaj¹cy automatycznie odpowiedni¹ iloœæ medykamentów grywalnym jednostk¹ [z mo¿liwoœci¹ konfiguracji]
* Skrypt zarz¹dzaj¹cy wrogiem ustawionym na sta³e w budynkach
* Skrypt pozwalaj¹cy wyœwietlaæ animacje w œrodowisku MP (WIP)
* Skrypt pozwalaj¹cy tworzyæ zombie-stalkerów
* Skrypt pozwalaj¹cy na przejmowanie w³adzy nad HC
* Skrypt pozwalaj¹cy na przejmowanie oraz u¿ycie artylerii
* Skrypt ustawiaj¹cy skill wszystkich jednostek na mapie [z mo¿liwoœci¹ konfiguracji]
* Skrypt pozwalaj¹cy na ustawienie gogli jednostk¹ graczy (zamiast tych ustawionych w profilu)
* Skrypt pozwalaj¹cy na prze³adowanie amunicji z nie pasuj¹cych do naszej broni magazynków do pasuj¹cych do naszej broni magazynków [IF44 only!]

CHANGELOG:
*BETA:
- Wydanie paczki, duh

Instalacja:
Zawartoœæ paczki wrzucamy do pliku misji, w pliku init.sqf ustawiamy wartoœci w ostatniej linijce dla:
[x1,[x2],x3,x4] execVM "acpl_fncs_init.sqf";
* x1 - wersja teatru, 0 dla modern, 1 dla WW2
* x2 - nazwy pojazdów medycznych, zapisane w [], np.: [pojazd1,pojazd2]
* x3 - czy w³aczyæ VCOMAI, true/false
* x4 - czy zablokowaæ mo¿liwoœæ chodzenia grywalnemu AI (odblokowaæ mo¿e dowódca dru¿yny w menu ACE'a), true/false

W init.sqf znajduje siê równie¿ brefing, instrukcja do jego skonfigurowania znajduje siê w shk_taskmaster.sqf

W pliku acpl_fncs_init.sqf mo¿emy dodatkowo skonfigurowaæ iloœæ medykamentów dla graczy oraz ustawienia VCOMAI

Ustawienia skilla jednostek znajdziemy acpl_fncs\acpl_msc\ustawienia.sqf, skill jest ustawiany dla ka¿dej ze stron oddzielnie! Jednostki spawnowane w trakcie rozgrywki równie¿ podlegaj¹ modyfikacji.

U¿ycie:
> DoStop.sqf [v1.5] - skrypt zarz¹dzaj¹cy przeciwnikiem ustawionym na sta³e w budynkach:
W init jednostki wklejamy: _nul = [this,pos,ducking] execVM "acpl_fncs\dostop.sqf"; gdzie:

* this - nazwa jednostki
* pos - pozycja w jakiej jednostka ma staæ - "up"/"middle"/"down"
* ducking - czy jednostka ma chowaæ siê przed ostrza³em/kiedy prze³adowywuje - true/false

Aby odblokowaæ jednostkê, aby np.: wysz³a z budynku nale¿y u¿yæ komendy: nazwa_jednostki setvariable ["acpl_dostop",false,true];
Aby zmieniæ pozycje jednostki nale¿y u¿yæ komendy: nazwa_jednostki setvariable ["acpl_dostop_pos",numer,true]; w miejscu numer wpisuj¹c numer pozycji - 2 = stoj¹ca, 1 = kucaj¹ca, 0 = le¿¹ca

> Animations [v1.0] - skrypt pozwalaj¹cy ustawiæ animacje jednostk¹, na razie statycznie (brak funkcji wyjœcia z animacji gdy pod ostrza³em, itd)
W init jednostki wpisujemy: _nul = ["ANIM",[this,"animacja"]] execVM "acpl_fncs\acpl_animations.sqf"; gdzie:

* this - nazwa jednostki
* "animacja" - classname animacji (nale¿y u¿yæ Animation Viewer'a w edytorze aby znaleŸæ klase)

Aby wy³aczyæ animacje nale¿y u¿yæ komendy: nazwa_jednostki setVariable ["acpl_animation_active",false,true];

> AddGoogles [v1.0] - skrypt pozwalaj¹cy dodaæ gogle graczowi (zwykle s¹ one nadpisywane tymi ustawionymi w profilu gracza)
W init jednostki wpisujemy: _nul = [this,"classname"] execVM "acpl_fncs\addgoggles.sqf"; gdzie:

* this - nazwa jednostki
* "classname" - classname gogli

> HC_TakeControl [v1.0] - skrypt pozwalaj¹cy na przejêcie kontroli nad High Command pod menu ACE'a
Ustawiamy i konfigurujemy modu³y HC w edytorze. Modu³y nie musz¹ byæ nazwane lecz musz¹ byæ zesob¹ synchronizowane. Nazwaæ nale¿y grupy które maj¹ byæ podleg³e HC
W init jednostki wpisujemy _nul = [_unit,[_grps]] execVM "acpl_fncs\HC_takecontrol.sqf"; gdzie:

* _unit - nazwa jednostki która ma pierwotnie posiadaæ dostêp do HC
* _grps - nazwy podleg³ych grup

> Take_Arty [v1.0] - skrypt dodaj¹cy do twojego oddzia³u artylerie (ustawion¹ wczeœniej na mapie)
W init wklejamy: _nul = [[_arty1,_arty2],_grp] execVM "acpl_fncs\take_arty.sqf"; gdzie:

* [_arty1,_arty2] - s¹ to nazwy baterii artyleryjskich
* _grp - nazwa grupy (musi byæ nazwana!) do której aryleria ma byæ pierwotnie przypisana

> Stalker_Zombie [v1.0] - skrypt zmieniaj¹cy jednostkê w przyg³upie zombie
W init jednostki wklejamy: _nul = [this] execVM "acpl_fncs\stalker_zombie.sqf"; gdzie:

* this - nazwa jednostki