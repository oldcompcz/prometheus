# Kapitola 60: Jak upravovat program, aniž se rozbije

Projekt vzkříšení už PROMETHEUS v jednom důležitém smyslu změnil: dnes dokážeme
pojmenovat jeho rutiny, znovu sestavit přesně jeho historické bajty, generovat
metadata adres a automaticky testovat relokované instalace.

To však neznamená, že jsou úpravy snadné.

PROMETHEUS je kompaktní právě proto, že mnoho hranic, které by moderní program
udržoval odděleně, je v něm záměrně spojeno:

- operandy kódu jsou proměnnými;
- pořadí tabulky může kódovat adresy;
- záznamy zdroje a symboly sdílejí pohyblivou oblast;
- jedna tabulka instrukcí slouží několika směrům;
- instalace pouze s assemblerem řeže jediný rezidentní zdrojový soubor;
- generovaná relokační metadata závisejí na emitovaných bajtech;
- zdroj uložený na kazetě obsahuje ordinaly a záznamy specifické pro svůj formát.

Bezpečná změna začíná rozhodnutím, **o jaký druh změny jde** a přes které smlouvy
programu zasahuje.

Tato kapitola je praktickou příručkou, nikoli slibem, že každá úprava bude
jednoduchá. Její hlavní pravidlo zní:

> Měň význam na nejvyšší úrovni, která tento význam už vlastní, a potom nech
> existující sdílené mechanismy, aby změnu přenesly směrem dolů.

## Nejprve změnu zařaďme

Ještě před úpravou jediného řádku zařaďme zamýšlenou práci do jedné ze čtyř
kategorií.

### 1. Vysvětlující změna

Příklady:

- vylepšení komentáře;
- přejmenování rekonstruovaného labelu;
- přidání orientačního nadpisu do zdroje;
- zpřesnění generovaného reportu.

Neměl by se změnit žádný příkaz emitující strojové bajty. Znovu sestavený binární
soubor i TAP musí zůstat historicky shodné bajt po bajtu.

Je to nejbezpečnější kategorie, ale i přejmenování labelu musí aktualizovat všechny
odkazy, anotace a linky v dokumentaci.

### 2. Strukturální změna zdroje se zamýšleně totožnými bajty

Příklady:

- nahrazení číselného expressionu ekvivalentním symbolickým expressionem;
- zavedení labelu na již existující adrese;
- rozdělení dlouhého bloku zdroje pomocí komentářů;
- použití tečkového prefixu pro skutečně lokální label větvení;
- regenerování tabulky, která musí znovu vytvořit své historické bajty.

Zdroj vypadá jinak, ale emitovaný proud příkazů má zůstat stejný. Akceptačním
testem je nadále historická binární identita.

### 3. Funkční změna bajtů v rámci existujících formátů

Příklady:

- oprava rutiny;
- přidání příkazu editoru využívajícího existující struktury příkazů a zdroje;
- změna chování zobrazení;
- přidání nového záznamu do tabulky instrukcí bez změny formátu záznamu;
- zvětšení rezidentního payloadu;
- přesun rutiny nebo tabulky.

Binární soubor a TAP se mohou záměrně změnit. Relokace, konfigurační metadata,
expressiony délek a instalační testy musí následovat nové rozložení.

### 4. Změna formátu nebo architektury

Příklady:

- změna kódování komprimovaných záznamů zdroje;
- rozšíření jednobajtové samorelativní tabulky;
- změna reprezentace ordinalů symbolů;
- rozšíření runtime formátu relokačního proudu;
- přesunutí hranice varianty pouze s assemblerem;
- změna nativního kazetového formátu zdroje;
- nahrazení rozložení uloženého obrazu procesoru.

To není pouhé „přidání trochy kódu“. Je nutné najít každého producenta,
konzumenta, uložený soubor, importer i test dané reprezentace. Zpětná kompatibilita
se stává explicitním návrhovým rozhodnutím.

Kategorie určuje, co všechno musí změna prokázat.

## Začínejme od zdrojového anchoru, nikoli od adresy bajtu

Rekonstruovaný zdroj poskytuje sémantické hranice, jako jsou:

```text
bootstrapEntry
installerEntryAt5000
relocatablePayloadStart
ENTRY_POINT_WITH_MONITOR
ENTRY_POINT_WITHOUT_MONITOR
sourceBufferStart
relocatablePayloadEnd
```

Používejme je.

Historická adresa jako `$7A7C` může popisovat místo, na němž se určitá hranice
nacházela v jednom konkrétním rozložení načtení. Není však trvalým významem této
hranice.

Dávejme přednost:

```asm
ENTRY_POINT_WITHOUT_MONITOR-relocatablePayloadStart
```

před:

```asm
$1388
```

pokud expression znamená „délka prefixu monitoru“.

Číselný výsledek může být nyní stejný, symbolická forma však program popisuje i
poté, co se kód přesune.

Stejné pravidlo platí uvnitř rutin. Větvěme na sémantický label, nikoli na starou
adresu opsanou z disassembly výpisu.

## Zachovejme rozdíl mezi globálními a lokálními labely

Tečkou prefixované labely v tomto zdroji znamenají:

```text
blízký soukromý cíl toku řízení
není volán nepřímo
jeho adresa se nikde nepřebírá
není sdílenou hranicí dat ani patchů
```

Assembler používaný projektem jim neposkytuje lexikální scope. Jejich úplné názvy
proto musí zůstat globálně jedinečné.

Nedělejme label lokálním jen proto, že má jediný odkaz. Label s jediným odkazem
může být stále:

- volatelným vstupem;
- pokračováním patchovaným do instrukce `JP`;
- cílem tabulky, jehož adresa se přebírá;
- anchorem relokace nebo konfigurace;
- hranicí oblasti zdroje;
- externě významným vstupním bodem.

Naopak popisný globální název není potřeba pro malou blízkou smyčku, jejíž adresa
se nikdy nepoužívá jako data.

Prefix sděluje dalšímu čtenáři záměr rozhraní.

## Každý label `varc...` považujme současně za kód i data

Představme si, že zdroj obsahuje:

```asm
varcAssemblyOutputPointer:
    ld hl,00000h
```

Některá rutina může zapisovat na:

```asm
varcAssemblyOutputPointer+1
```

`+1` není náhodné. Vybírá dvoubajtový immediate operand následující za opcodem.

Nebezpečné změny zahrnují:

```asm
; replacing LD HL,nn with a different-width instruction
; inserting a prefix before the operand without updating patch sites
; changing the opcode while assuming only the value matters
; moving the label from the instruction start to the operand without auditing references
```

Bezpečná kontrola si klade tyto otázky:

1. Které bajty se čtou jako spustitelný kód?
2. Které bajty se zapisují jako trvalý stav?
3. Je hodnotou režimu celý opcode?
4. Relokuje se operand při instalaci?
5. Je jedním ze čtrnácti konfiguračních cílů?
6. Očekává některý report nebo test, že label označuje začátek instrukce, nebo
   operand?

Při přidání nového zapisovatelného stavu v kódu dejme operandu nebo opcodu
explicitní sémantický label a zdokumentujme jeho šířku.

## Data ve tvaru opcodů nezjednodušujme podle vzhledu

Některé tabulky záměrně obsahují bajty vypadající jako instrukce Z80. Nejjasnějším
příkladem je relokační výjimka:

```asm
relocationExceptionMonitorEntryDescriptorWord:
    defw ENTRY_POINT_WITH_MONITOR+2 ; @noreloc
```

Differential assembly vidí slovo závislé na originu, jeho konzument však jeho
bajty chápe jako pole deskriptoru, nikoli jako adresu.

Jiné kompaktní tabulky mohou obsahovat:

- opcodes používané jako voliče režimu;
- masky podobné prefixům;
- počty posunuté do rozsahů opcodů;
- jednobajtové delty rutin;
- řetězce, jejichž poslední bajt má nastaven bit 7.

Nikdy nenahrazujme podivnou posloupnost bajtů něčím „ekvivalentním“, dokud jsme
nevysledovali jejího konzumenta.

Správnou jednotkou porozumění bývá často tabulka společně s rutinou, která ji čte,
nikoli samotný řádek obsahující `DEFB` nebo `DEFW`.

## Zachovejme invarianty záznamů zdroje

Komprimovaný jazyk zdroje sdílejí editor, assembler, kazetový převod, obrácené
disassembly, hledání, náhrady i komprimace symbolů.

Platný záznam musí zachovat:

- význam své dvoubajtové hlavičky;
- rozlišení pseudo-opcodu a strojové instrukce;
- volitelné kódování labelu;
- pole tříd operandů;
- hranice zakódovaných expressionů;
- tagy ordinalů symbolů;
- informace o zakončení a zpětném odkazu;
- všechna pravidla zvláštních záznamů pevné délky.

Při přidání nové formy zdroje najděme každý směr:

```text
text -> záznam             encoder
záznam -> text             expander
záznam -> délka/adresa     první průchod
záznam -> bajty/účinek     druhý průchod
záznam -> uložená kazeta   nativní SAVE
uložený záznam -> živý     převod LOAD
záznam -> odkazy           scanner/compactor symbolů
```

Chybí-li byť jediný směr, může vlastnost zdánlivě fungovat, dokud uživatel zdroj
nevytiskne, znovu nenačte, nezkomprimuje symboly nebo se nezačne pohybovat zpět.

Změna formátu ovlivňuje také dříve uložené kazety se zdrojem. Rozhodněme, zda
staré záznamy zůstávají čitelné, nebo zda je potřeba verzovaný converter.

## Zachovejme smlouvy pohyblivé oblasti zdroje a symbolů

`insertByteRangeAtHLFromDE` je ústřední rutina otevírající mezery. Předpokládá,
že kombinovaná dynamická oblast je sbalená, a potom opravuje:

- `varcCodeEndPt`;
- `varcSymbolTablePt`;
- hranice vybraného bloku na místě vložení nebo za ním;
- sémantické ukazatele zvolené volajícím podle zdokumentované hranice vložení.

Nepřesouvejme bajty v této oblasti příležitostným `LDIR` a neopravujme potom pouze
ukazatel, který byl viditelný v právě upravované rutině.

Před přidáním nového trvalého ukazatele do úložiště zdroje nebo symbolů rozhodněme,
jak se má chovat, když se před něj vloží nebo z něj odstraní bajty. Možná jej bude
nutné zapojit do společné opravné logiky.

Stejně tak zachovejme trvalé prázdné koncové záznamy. Jejich odstranění jako
„nepoužitého paddingu“ změní předpoklady navigace a zobrazení.

## Zachovejme stabilní ordinaly symbolů — nebo záměrně přepišme každý odkaz

Ordinal symbolu je uložen v komprimovaných expressionech po celém zdroji.
Vektorová tabulka jej převádí na současný abecedně uložený záznam.

Přesunou-li se záznamy symbolů, opraví se offsety vektorů a ordinaly mohou zůstat
stejné.

Odstraní-li se při `TABLE C` jedna položka vektoru, musí se každý větší ordinal
vložený ve zdroji zmenšit o jedna.

Nová operace s tabulkou symbolů proto musí odpovědět:

```text
Mění se pouze fyzické pozice záznamů?
Mění se offsety vektorů?
Mění se číslování ordinalů?
Které komprimované záznamy obsahují dotčené ordinaly?
```

Neseřazujme pole vektorů abecedně. Nenahrazujme ordinaly přímými ukazateli na
záznamy, pokud současně nepřepracováváme každou reprezentaci zdroje a všechny
kazetové pracovní postupy.

## Znalost instrukcí měňme pokud možno ve sdílené tabulce

Chybí-li některá forma instrukce Z80 nebo je-li chybná, upřednostňovaným místem
opravy je tabulka deskriptorů instrukcí, pokud ji existující pětibajtový formát
dokáže vyjádřit.

Změna tabulky může ovlivnit:

- rozpoznání při vstupu zdroje;
- emisi prefixu a opcodu;
- recept immediate hodnoty nebo displacementu;
- rozpoznání při disassembly;
- délku instrukce;
- základní časování i časování provedené cesty;
- klasifikaci krokování a toku řízení.

Je to výhoda: jediná oprava může napravit několik směrů. Je to také riziko:
zdánlivě čistě assemblerová změna může pozměnit disassembly nebo trasování.

Po změně záznamu testujme oba směry:

```text
forma zdroje -> přesně očekávané bajty
bajty        -> očekávaná forma zdroje
```

Potom otestujme metadata vykonávání, má-li instrukce zvláštní tok řízení, přístup
do paměti nebo časování.

Nedokáže-li formát novou instrukci vyjádřit, rozšíření nebo nové vyložení záznamu
je architektonickou změnou. Je nutné prověřit všech 687 konzumentů i předpoklady
o umístění generované tabulky.

## Příkaz přidávejme přes existující vrstvy dispatch

Příkaz editoru obvykle prochází několika kompaktními strukturami:

1. zápisem klávesy nebo tokenu;
2. slovníkem labelů operací;
3. položkou token-to-handler v `commandHandlerTable`;
4. rutinou handleru;
5. chováním teplého startu nebo vlastního pokračování;
6. tokenem stavového či chybového hlášení, je-li potřeba.

Nepřidávejme souběžný textový parser příkazů jen proto, že se zdá snazší.
Duplikoval by normalizaci, expanzi tokenů i pravidla dispatch.

Ověřme, zda příkaz pracuje s:

- aktivním řádkem;
- inkluzivním vybraným blokem;
- celým zdrojem;
- vstupním řádkem následujícím za tokenem příkazu;
- trvalým stavem potřebným pro opakovaný příkaz, jako je FIND/NEXT.

Přesměruje-li handler dočasně `varcPostCommandContinuationJump`, musí normální
cíl obnovit na každé cestě dokončení i chyby.

## Funkce monitoru přidávejme přes neutrální reprezentace

Monitor už má sdílené formy pro běžné úlohy:

- současnou adresu v `varcMonitorCurrentAddress`;
- formátovaný výstup v `lineBuffer`;
- inkluzivní rozsahy First/Last nebo First/Length;
- záznamy deskriptorů čelního panelu;
- editovatelná ochranná okna;
- uložený stav uživatelova procesoru;
- dekódovanou strukturu instrukce.

Nový pohled by měl pokud možno vytvářet řádky v `lineBuffer` a vybírat cíl,
namísto psaní nesouvisejícího rendereru obrazovky.

Nová hodnota čelního panelu by měla pokud možno dostat deskriptor nebo třídu
rendereru, nikoli natvrdo zapsanou logiku překreslování rozptýlenou po smyčce
monitoru.

Nové bezpečnostní pravidlo trasování by se mělo připojit k validaci před
vykonáním, nikoli se pokoušet vracet nebezpečný zápis až potom.

Tak zůstane zachován model teplých vstupů monitoru na nejvyšší úrovni.

## Respektujme rozdíl mezi důvěryhodnými nástroji a trasovaným uživatelským kódem

Ne každý paměťový příkaz monitoru používá ochranná okna READ/WRITE.

Okna popisují, kam smí přistupovat neznámá uživatelská instrukce během trasování.
Důvěryhodné operace monitoru, jako jsou zobrazení, MOVE nebo FILL, mají vlastní
pravidla soustředěná tam, kde je potřeba, především na ochranu rezidentní dílny.

Nepředpokládejme, že přidání rozsahu do ochrany WRITE má automaticky zablokovat
každou editaci monitoru. Změnilo by to model vysvětlovaný uživatelským rozhraním.

Při úpravě příkazu určeme, do které třídy politiky patří:

```text
důvěryhodná operace monitoru
ochrana výstupu assembleru
predikce trasovaných READ/WRITE
ochrana cíle trasovaného RUN
rezidentní sebeochrana
```

Tyto třídy se překrývají, ale nejsou zaměnitelné.

## Přepis toku řízení oddělujme od aritmetického vykonání

Síla stepperu spočívá v tom, že instrukci vykonává skutečný Z80. Přepisuje pouze
hrany toku řízení, které by jinak unikly ze scratch trampoline.

Při přidání podpory nové formy toku řízení:

1. dekódujme logický sekvenční cíl a cíl provedené cesty;
2. rozhodněme, zda může fyzická instrukce ve scratch programu běžet beze změny;
3. vytvořme zachycovací výstupy pro každou možnou cestu;
4. zachovejme uživatelsky viditelný účinek forem CALL/RET/RST na stack;
5. vraťme logické PC nezávislé na scratch adresách;
6. vyberme správné časování podle skutečně zvolené cesty;
7. před potvrzením ověřme predikované cíle paměti a vykonání.

Neměňme stepper v částečný softwarový emulátor, pokud nejde o záměrný nový návrh.
Napůl emulovaná instrukční sada by vytvořila dva zdroje sémantiky Z80 a mnoho
příležitostí k rozdílům ve flags.

## Změny hranice monitoru a assembleru považujme za architektonické

Historická hranice leží přesně 5 000 bajtů od začátku payloadu. Řídí:

- začátek zdroje varianty pouze s assemblerem;
- délku kopírování varianty pouze s assemblerem;
- rozdělení relokačních proudů;
- korekci addendu;
- vynechaný rozsah monitoru;
- fallback patch příkazu MONITOR;
- instalační a vykonávací testy.

Přidávání bajtů uvnitř prefixu monitoru podporuje generovaný build mechanismus;
symbolická hranice se přesune společně s `ENTRY_POINT_WITHOUT_MONITOR`.

Sémantické přesunutí hranice — umístění sdílené rutiny na druhou stranu nebo
vytvoření závislosti suffixu na vynechaných datech monitoru — vyžaduje více
rozvahy. Obraz pouze s assemblerem musí stále obsahovat každou rutinu a každá
data dosažitelná ze svého vstupu.

Před přesunem sdíleného kódu do volitelného prefixu hledejme:

- přímá volání ze suffixu;
- callbacky, jejichž adresa se přebírá;
- delty tabulek;
- odkazy na data;
- konfigurační cíle;
- relokační slova;
- fallback chování monitoru.

Skutečnost, že se některé volání uskuteční pouze při použití MONITORu,
automaticky neznamená, že lze jeho cíl bezpečně vynechat, zůstává-li samotný
příkaz v suffixu.

## Generované tabulky nechme vlastnit generátory

Ze sémantických anchorů zdroje se generují dvě tabulky:

- delty konfiguračních patchů;
- proudy relokačních cílů.

Jejich emitované include soubory ručně neupravujme.

U konfiguračních polí přidejme nebo změňme uspořádanou anotaci přímo u skutečného
cíle ve zdroji:

```asm
configurationPatchTargetNNMeaning: equ $+1 ; @config-patch NN
```

Pořadí je zapisovacím protokolem instalátoru. Hodnoty pořadí musí být jedinečné a
souvislé.

Pro relokaci zapisujme běžné symbolické interní adresy jako úplná slova.
Multi-origin generátor je objeví.

`@noreloc` používejme pouze pro slovo závislé na originu, které sémanticky není
adresou, a výjimku vysvětleme vedle dat. `@reloc` používejme pouze tehdy, když
skutečný cíl nelze běžným způsobem objevit.

Nikdy nezavádějme izolované formy odpovídající:

```asm
defb LOW residentLabel
defb HIGH residentLabel
```

Historický runtime relocator je nedokáže opravit. Build záměrně odmítá
nepodporované jednotlivé bajty závislé na originu.

## Znejme historický limit relokačního proudu

Jedna mezera mezi cíli v kompaktním historickém formátu se musí vejít do svého
kódování. Současný generátor explicitně selže, vytvoří-li změněné rozložení mezeru
větší než podporovaný jednokrokový rozsah `$C7`.

Neumlčujme tuto chybu vložením falešného relokačního cíle. Správné možnosti jsou:

- přesunout příslušný kód nebo data tak, aby mezera byla zakódovatelná;
- přidat skutečné slovo nesoucí adresu, pokud je návrh přirozeně potřebuje;
- nebo záměrně rozšířit relokační formát a jeho runtime dekodér.

Třetí možnost mění historický emitovaný kód a musí být otestována v obou režimech
instalace.

Hlasité selhání buildu je bezpečnější než tabulka, která potichu relokuje nesprávné
slovo.

## Regenerujme délky a znovu sestavme TAP

Distribuovaný blok CODE obsahuje více než jen rezidentní payload:

```text
bootstrap + instalátor + generovaná metadata + logo + rezidentní payload
```

Funkční změna může ovlivnit:

- délku payloadu;
- hranici monitoru;
- délku varianty pouze s assemblerem;
- délku kopírování instalátoru;
- velikost relokačního proudu;
- celkovou velikost bloku CODE;
- délku hlavičky TAP;
- délku datového bloku TAP;
- kontrolní součty hlavičky a dat.

V assembleru používejme symbolické rozdíly sekcí a builder TAPu s proměnnou
délkou. Starou hodnotu 18 356 bajtů neopravujme ručně.

Nesouvisející bloky TAP mají zůstat nedotčené, pokud se nemění samotná
distribuce.

## Disciplinovaný postup úpravy

Následující posloupnost je záměrně konzervativní.

### Krok 1: napišme záměr chování

Popišme změnu bez instrukcí Z80.

Například:

```text
Přidat příkaz, který po potvrzení vymaže pouze vybraný blok zdroje.
```

Uveďme viditelné vstupy, výstupy, zrušení a chování při chybě.

### Krok 2: najděme vlastníka reprezentace

Ptejme se, který existující subsystém už daný význam vlastní:

```text
dispatch příkazů editoru?
změna záznamů zdroje?
tabulka instrukcí?
deskriptor čelního panelu?
konfigurační cíl?
relokační generátor?
```

Nevytvářejme souběžný mechanismus.

### Krok 3: vypišme dotčené smlouvy

Pro příkladový příkaz:

- token příkazu a handler;
- inkluzivitu vybraného bloku;
- helper mazání;
- trvalý koncový padding;
- opravu aktivního řádku;
- stavové hlášení;
- pokračování teplého startu.

Pro novou instrukci by seznam vypadal úplně jinak.

### Krok 4: udělejme hranice symbolickými

Zaveďme sémantické labely pro každou novou oblast, operand, cíl patche nebo
callback. Nezapisujme současné adresy natvrdo do logiky.

### Krok 5: zachovejme nebo zdokumentujme změny reprezentace

Pokud se formát nemění, řekněme to. Pokud se mění, popišme jeho starou a novou
gramatiku a najděme každého producenta a konzumenta.

### Krok 6: regenerujme metadata

Spusťme generování konfigurace a relokace nad změněným zdrojem. Verzované
generované soubory se musí přesně shodovat s čerstvým výstupem.

### Krok 7: otestujme obě rezidentní rozložení

Změna není hotová jen proto, že se spustí plný build s monitorem.

Otestujme:

```text
úplný 16KB obraz
suffix pouze s assemblerem
několik cílových základen
překryvové kopírování vpřed i vzad
```

Leží-li změna v suffixu, musí ji vykonávat oba produkty.

### Krok 8: otestujme viditelnou vlastnost i její obrácené cesty

Příklady:

- vlastnost parseru: zadat, expandovat, uložit, načíst, zkomprimovat symboly;
- vlastnost instrukce: sestavit, disassemblovat, krokovat;
- kazetová vlastnost: uložit, ověřit, načíst, zrušit, zpracovat poškozený vstup;
- pohled monitoru: podle potřeby obrazovka, panel, tiskárna nebo cíl ve zdroji.

### Krok 9: zachovejme historii tam, kde má být zachována

U změn pouze v komentářích nebo bez dopadu na bajty vyžadujme přesnou identitu
binárního souboru i TAPu.

U záměrných funkčních změn zachovejme historický artefakt jako referenci a
zdokumentujme, proč se hashe liší.

### Krok 10: aktualizujme knihu a atlas zdroje

Úprava, kterou nelze jasně vysvětlit, může stále obsahovat nerozpoznanou
závislost. Dokumentace je součástí review návrhu.

## Praktický příklad: přesunutí běžné rutiny

Představme si, že rutina v suffixu assembleru a editoru naroste a je nutné ji
přesunout.

Bezpečný postup je:

1. zachovat její globální vstupní label;
2. přesunout s ní všechny skutečně soukromé tečkové cíle toku řízení;
3. vyhledat přímé odkazy `CALL` a `JP`;
4. vyhledat její adresu uloženou v tabulkách nebo samomodifikovaných callbackách;
5. regenerovat relokační metadata — absolutní odkazy se přesunou;
6. ověřit, že jednobajtové relativní delty tabulek stále dosáhnou;
7. ověřit, že instalace pouze s assemblerem rutinu stále obsahuje;
8. sestavit/disassemblovat nebo vyzkoušet její viditelnou funkci;
9. otestovat instalace na nehistorických základnách.

Strojový kód nemusí zůstat na staré adrese. Sémantický label a generovaný
relokační systém jsou navrženy tak, aby přesun umožnily.

## Praktický příklad: přidání pouze zobrazovaného stavového hlášení

Jde o menší změnu, přesto zasahuje kompaktní formáty.

Otázky zahrnují:

- Je hlášení zakončeno high bitem?
- Vybírá se tokenem nebo indexem s pevným pořadím?
- Očekává vykreslovací rutina inline text za instrukcí `CALL`?
- Vytvoří přidané bajty nezakódovatelnou deltu samorelativní tabulky?
- Leží hlášení v prefixu monitoru, nebo ve sdíleném suffixu?
- Posune jeho vložení konfigurační nebo relokační cíle?

Viditelnou změnou může být jediná věta, správná reprezentace však rozhoduje, zda
stojí nový renderer, jednu položku tabulky, nebo pouze jeden sbalený řetězec.

## Praktický příklad: přidání formy instrukce

Představme si opravu nebo přidání položky tabulky instrukcí.

Ověřme:

```text
textový vstup je zařazen do zamýšlených tříd operandů
hledání v tabulce instrukcí vybere nový záznam
druhý průchod emituje přesné pořadí prefixu/opcodu/operandů
disassembler rozpozná tyto bajty a rekonstruuje stejnou formu
délka vrácená navigaci zdroje a stepperu je správná
základní časování i časování provedené cesty jsou správná
deskriptory přístupu do paměti a toku řízení pokrývají zvláštní chování
```

U forem DD/FD-CB věnujme zvláštní pozornost fyzickému pořadí bajtů. Logický popis
v tabulce a pořadí emise nejsou vždy na první pohled zřejmé.

## Praktický příklad: změna formátu záznamů zdroje

Taková změna nikdy nemá začínat lokálním patchem.

Sepišme:

- nové bity hlavičky;
- nové pravidlo zakončení a zpětného odkazu;
- starou a novou maximální délku;
- kódování ordinalů symbolů;
- mapování pseudo-opcodů;
- způsob rozpoznání starých nativních souborů SAVE;
- způsob pohybu editoru zpět;
- způsob, jakým FIND/REPLACE a komprimace procházejí pole proměnné délky;
- způsob, jakým obrácené disassembly vytváří nový formát.

Potom implementujme convertery nebo záměrně prohlašme nekompatibilitu.

Formát záznamu je jazyk sdílený napříč časem i napříč rutinami.

## Praktický příklad: přidání LOW bajtu rezidentní adresy

Nedělejme toto:

```asm
    defb residentRoutine & $FF
```

Při originu nula může bajt vypadat správně. Po instalaci na `$8000` se low bajt
může, ale také nemusí změnit podle carry z přidaného základu, a runtime nemá
žádnou položku říkající, že má opravit jediný bajt.

Upřednostněme úplné relokovatelné slovo a potřebný bajt z něj odvoďme za běhu,
nebo změňme reprezentaci na samorelativní.

Selhání generátoru není nepříjemnost. Dokazuje, že historický instalátor novou
reprezentaci nedokáže podporovat.

## Release gate jako spustitelné vysvětlení

Testy rekonstrukce kódují velkou část architektury popsané v této knize.

Kontrolují, že:

- generování metadat je deterministické;
- anotace stále ukazují na platná místa;
- neexistují nepodporované bajty závislé na originu;
- relokace odpovídá nezávislým sestavením s nenulovým originem;
- úplný obraz i obraz pouze s assemblerem se instalují správně;
- obrazy se změněnou délkou vytvářejí platné bloky TAP;
- funguje překryvové kopírování vpřed i vzad;
- vykonávání dosáhne smyčky editoru na několika cílových adresách;
- záměrná vložení do monitoru a assembleru regenerují všechna metadata rozložení;
- historické hashe zůstávají přesné, pokud nebyla zamýšlena změna strojových bajtů.

Selhání testu často ukazuje smlouvu, kterou úprava překročila. Čtěme je jako
důkaz o architektuře, nikoli pouze jako překážku na cestě k zelenému buildu.

## Oddělujme původní runtime chování od nástrojů rekonstrukce

Samotný PROMETHEUS neví nic o:

- šesti umělých originech sestavení;
- generátorech tabulek v Pythonu;
- manifestech SHA-256;
- headless vykonávacích harnesses;
- nahrazování šablon TAP s proměnnou délkou.

To jsou moderní nástroje obklopující rekonstruovaný zdroj.

Runtime stále spotřebovává:

- kompaktní historický proud konfiguračních delt;
- kompaktní historický relokační proud;
- běžné kazetové bloky Spectra;
- své původní formáty zdroje, symbolů a monitoru.

Udržujme tento rozdíl viditelný v komentářích i dokumentaci. Build-time vylepšení
nemá být popisováno tak, jako by je program z osmdesátých let prováděl na
Spectru.

Současně nezachovávejme ruční křehkost jen proto, že je historická. Generování
stejných runtime bajtů ze sémantických labelů činí úpravy bezpečnějšími, aniž by
měnilo chování původního stroje.

## Checklist před commitnutím změny emitující strojové bajty

```text
[ ] Vlastní změnu některá existující reprezentace nebo subsystém?
[ ] Jsou nové labely globální či lokální ze správného důvodu?
[ ] Byli vysledováni všichni konzumenti stavů varc a stavů ve tvaru opcodů?
[ ] Jsou zachovány invarianty záznamů zdroje a ordinalů symbolů?
[ ] Jsou samorelativní delty a rozsahy kompaktních tabulek stále platné?
[ ] Obsahuje instalace pouze s assemblerem stále všechny závislosti suffixu?
[ ] Jsou interní adresy úplnými relokovatelnými slovy?
[ ] Jsou konfigurační anotace uspořádané a jedinečné?
[ ] Byly generované soubory metadat čerstvě znovu vytvořeny?
[ ] Byla úplná i assembler-only rozložení otestována na několika základnách?
[ ] Bylo při změně rozložení vyzkoušeno překryvové kopírování vpřed i vzad?
[ ] Byl TAP znovu sestaven se současnými délkami a kontrolními součty?
[ ] Mají historické hashe binárního souboru a TAPu zůstat shodné?
[ ] Bylo nové chování vysvětleno ve zdroji a dokumentaci knihy?
```

## Co se v paměti změní při úpravě zdroje

Odpověď závisí na kategorii:

- změna komentáře nebo labelu nemá změnit žádný emitovaný bajt;
- přesunutá rutina posune pozdější offsety payloadu a relokační cíle;
- nové konfigurační pole změní generovaný průchod deltami;
- větší monitor posune hranici varianty pouze s assemblerem;
- větší suffix změní délky payloadu a TAPu;
- nový formát záznamu zdroje změní každou živou i uloženou reprezentaci;
- nová položka tabulky může změnit samorelativní vzdálenosti a indexy dekodéru.

Postup úpravy musí tyto vlny záměrně následovat, nikoli se snažit udržet staré
adresy na místě.

## Důležité anchory zdroje a buildu

- `bootstrapEntry`
- `installerEntryAt5000`
- `relocatablePayloadStart`
- `ENTRY_POINT_WITH_MONITOR`
- `ENTRY_POINT_WITHOUT_MONITOR`
- `relocatablePayloadEnd`
- `configurationPatchTarget...`
- `installerConfigurationPatchDeltas`
- labely relokačních proudů
- zapisovatelné operandy a opcodes `varc...`
- `sourceBufferStart`
- `varcSymbolTablePt`
- `varcCodeEndPt`
- `instructionTable.asm`
- `emitByteAtAssemblyOutput`
- generátory metadat a vykonávací harness instalace

## Zpět k celému stroji

Vzkříšení odstranilo jedno staré omezení: PROMETHEUS už nemusí zůstat zmrazen na
adresách dochovaného binárního souboru jen proto, že jeho relokační a konfigurační
tabulky byly kdysi předem vypočítané.

Neodstranilo však nutnost rozumět kompaktním smlouvám programu. Přesun je
bezpečný, protože labely a generátory nyní popisují význam citlivý na adresy.
Funkční změna je bezpečná pouze tehdy, věnujeme-li stejnou péči záznamům zdroje,
ordinalům, tabulkám, stavovým operandům, rozložením stacků a sdíleným pipeline.

Poslední hlavní kapitola se od pravidel obrátí ke geografii. Projde soubor
`prometheus.asm` ve fyzickém pořadí, ukáže, kde každý subsystém leží a které
kapitoly jej vysvětlují. Tento atlas dovolí čtenáři vrátit se z knihy ke zdroji,
aniž ztratí celkový obraz.
