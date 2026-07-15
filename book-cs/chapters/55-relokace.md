# Kapitola 55: Relokace

Vybraný rezidentní obraz už leží ve své konečné oblasti paměti. Jeho bajty jsou
na správném místě a jeho barvy i chování klávesnice byly nakonfigurovány.
Program však stále nelze bezpečně spustit.

Důvod se skrývá uvnitř mnoha zcela obyčejně vypadajících instrukcí Z80.

PROMETHEUS byl sestaven tak, jako by jeho rezidentní payload začínal na adrese
nula. Skok poblíž jeho začátku proto obsahuje adresu například `$1F09`, nikoli
`$7CC9` nebo `$9F09`. Po zkopírování obrazu na skutečný cíl je nutné každou
takovou interní absolutní adresu opravit.

Touto opravou je relokace.

PROMETHEUS obsahuje pozoruhodně malý runtime relokátor. Rekonstrukce k němu
přidává build-time generátor, který jeho cíle objeví sestavením stejného payloadu
na několika umělých originech. Společně řeší dva různé problémy:

- generátor rozhoduje, **která slova je třeba upravit**;
- rezidentní instalátor provede **úpravu zvolenou uživatelem**.

## Skok, který stále věří, že program začíná na nule

První rezidentní bajty jsou:

```asm
relocatablePayloadStart:
ENTRY_POINT_WITH_MONITOR:
    jp startPrometheus
```

Při originu nula leží `startPrometheus` na offsetu payloadu `$1F09`. Instrukce
proto začíná takto:

```text
C3 09 1F
```

`C3` je opcode absolutního `JP`. Následující little-endian slovo je `$1F09`.

Předpokládejme, že uživatel nainstaluje celý systém na `$8000`. Požadovaný cíl
je:

```text
$8000 + $1F09 = $9F09
```

Zkopírovaná instrukce se musí změnit na:

```text
C3 09 9F
```

Mění se pouze dvoubajtový operand. Opcode zůstává stejný.

Obecně úplná instalace potřebuje:

```text
installedWord = linkedWord + residentBase
```

Runtime relokátor opakuje toto sčítání u každého slova v payloadu, které nese
adresu.

## Ne každé číslo měnící tok řízení je relokovatelné

Naivní program by mohl vyhledat každý opcode `JP`, `CALL` a `LD` a změnit
následující bajty. To by velmi rychle selhalo.

Zaprvé se absolutní adresy objevují i mimo instrukce:

- slova v tabulkách;
- adresy callbacků;
- ukazatele na obrazovku nebo buffery uložené jako data;
- počáteční operandy samomodifikujících instrukcí;
- ukazatele v deskriptorech čelního panelu;
- adresy rutin používané nepřímými dispatchery.

Zadruhé není každé slovo následující za opcodem připomínajícím adresu interním
ukazatelem. PROMETHEUS obsahuje také:

- adresy ROM Spectra;
- pevné hardwarové a obrazovkové adresy;
- číselné konstanty;
- masky;
- počty;
- data vypadající jako opcodes;
- rozdíly mezi labely.

Zatřetí relativní tok řízení tuto úpravu nepotřebuje. `JR` a `DJNZ` ukládají
signed vzdálenost od samotné instrukce. Když se celý program posune společně,
posunou se o stejnou hodnotu zdroj i cíl, takže vzdálenost zůstane nezměněna.

Například běžící program:

```asm
LOOP    DJNZ LOOP
```

zůstává `$10,$FE` bez ohledu na to, kam se tato dvoubajtová instrukce umístí.

Relokace proto potřebuje sémantické informace, které z prostého skenování bajtů
nejsou vidět.

## Historická odpověď: předem vypočítaný proud cílů

Původní hotový program nesl kompaktní seznam relokačních cílů. Seznam neukládal
1 293 absolutních offsetů. Ukládal vzdálenost od jednoho cíle k následujícímu.

Pro runtime to byla výborná reprezentace:

- instalátor udržuje jediný průběžný ukazatel v DE;
- většina mezer mezi cíli se vejde do jednoho bajtu;
- opakované tvary instrukcí vytvářejí opakované mezery, které lze komprimovat;
- dekodér je maličký;
- tabulka je dočasná a při spotřebovávání se smí sama měnit.

Slabina se projeví teprve tehdy, když lidé začnou měnit zdroj. Vložení jediné
instrukce před některý cíl může zneplatnit každou pozdější předem vypočítanou
vzdálenost.

Vzkříšení proto zachovává původní formát proudu, ale jeho obsah generuje z
aktuálního zdroje.

## Objevování relokace změnou originu

Ústřední pozorování je jednoduché:

> Interní slovo závislé na originu se změní přesně o hodnotu, o kterou se změní
> origin payloadu.

Build sestaví rezidentní payload na šesti umělých originech:

```text
$0000
$0101
$1234
$4000
$7FFF
$C000
```

Pro každou dvoubajtovou pozici porovná emitované little-endian slovo.

Označme:

```text
W0 = slovo emitované při originu $0000
WB = slovo emitované při zkušebním originu B
```

Pozice je kandidátem relokace pouze tehdy, když každý zkušební build splňuje:

```text
WB = W0 + B  modulo 65536
```

Operand prvního entry pointu to ukazuje dokonale:

```text
origin $0000 -> $1F09
origin $0101 -> $200A
origin $1234 -> $313D
origin $4000 -> $5F09
origin $7FFF -> $9F08
origin $C000 -> $DF09
```

Rozdíly přesně odpovídají zvoleným originům, včetně běžného šestnáctibitového
přetečení.

Volání ROM se takto nechová. Konstantní adresa jako `$028E` zůstává `$028E` při
každém zkušebním originu. Rozdíl labelů jako:

```asm
ENTRY_POINT_WITHOUT_MONITOR-ENTRY_POINT_WITH_MONITOR
```

zůstává také konstantní, protože oba labely se posouvají společně.

Tato diferenciální metoda rozumí konečnému významu vytvořenému assemblerem, aniž
by bylo nutné psát druhý parser Z80.

## Proč je několik originů lepších než jeden

Dva buildy — nula a jeden nenulový origin — by už odhalily většinu míst. Další
zkoušky chrání před náhodnými shodami.

Dvojice nesouvisejících bajtů by se mezi dvěma buildy mohla náhodou lišit o
`$0101`, protože ji změnil jiný efekt rozložení. Je mnohem méně pravděpodobné,
že napodobí všech pět nenulových originů.

Zkoušky zahrnují také obtížné hodnoty:

- `$0101` mění dolní i horní bajt;
- `$1234` je dost nepravidelné, aby odhalilo chyby pořadí bajtů;
- `$7FFF` překračuje hranici znaménka;
- `$C000` prověřuje přetečení poblíž horního okraje adresního prostoru Z80.

Pro současný historický payload generátor hlásí:

```text
délka payloadu                         16 000 bajtů
hranice assembler-only                 $1388
bajty závislé na originu               2 588
kandidátní slova závislá na originu    1 294
explicitní výjimky @noreloc                1
vygenerovaná relokační slova            1 293
proud monitoru                            571
proud assembleru                          722
nepodporované jednobajtové závislosti        0
```

Oněch 2 588 měnících se bajtů jsou přesně dva bajty pro každé z 1 294
kandidátních slov.

## Jediná záměrná výjimka

Jedno slovo závislé na originu vůbec není ukazatelem:

```asm
relocationExceptionMonitorEntryDescriptorWord:
    defw ENTRY_POINT_WITH_MONITOR+2 ; @noreloc
```

Toto slovo leží ve sbaleném deskriptoru přístupu do paměti. Jeho dolní a horní
bajt se znovu používají jako pole tabulky připomínající opcodes. Expression se
pohybuje s originem, takže diferenciální detekce správně zaznamená, že na něm
závisí. Runtime k němu však nesmí přičíst instalační základ, jako by šlo o
adresu.

Explicitní anotace vyjadřuje sémantickou výjimku.

Je to bezpečnější než ukrýt výjimku pouze v kódu generátoru. Důvod zůstává vedle
neobvyklých dat, kde jej budoucí čtenář uvidí.

Generátor podporuje také `@reloc` pro neobvyklé slovo, které má být do tabulky
vynuceně přidáno, současný zdroj však žádné takové doplnění nepotřebuje.

## Zachycení adresních bajtů, které runtime nedokáže opravit

Historický relokátor upravuje pouze úplná little-endian slova. Zdrojová konstrukce
equivalentní například:

```asm
defb LOW someResidentLabel
```

by vytvořila jediný bajt závislý na originu. Nebyl by pokryt detekovaným
dvoubajtovým cílem a runtime tabulka jej neumí vyjádřit.

Generátor proto provádí druhé porovnání na úrovni jednotlivých bajtů. Každý
měnící se bajt musí patřit do jednoho přijatého relokačního slova. Jinak build
selže a oznámí:

- offset v payloadu;
- hodnotu emitovanou při každém zkušebním originu;
- řádek assemblerového listingu, který bajt vytvořil.

Tím se nenápadná budoucí runtime chyba změní v okamžitou chybu buildu.

## Rozdělení tabulky na hranici monitoru

Rezidentní payload má dvě možná fyzická rozložení:

```text
úplný obraz:
    zkopírují se offsety $0000-$3E7F

obraz pouze s assemblerem:
    původní offsety $1388-$3E7F se zkopírují na cílový offset $0000
```

Jeden relokační proud začíná u originu úplného obrazu. Druhý začíná na hranici
assembleru.

Vygenerovaný zdroj je pojmenovává:

```asm
vr_l05353h:       ; first, monitor-region stream
    ...

vr_l05547h:       ; second, assembler-region stream
    ...
```

Názvy jsou historické rekonstrukční labely, nikoli smysluplné původní názvy.
Důležitá je jejich role.

Rozdělení umožňuje:

- úplné instalaci použít proud 1 a potom proud 2;
- assembler-only instalaci přeskočit proud 1 a použít společný suffixový proud
  s jiným addendem.

První proud nyní obsahuje 571 slov. Druhý obsahuje 722.

## Převod cílů na delty

Uvnitř každého proudu jsou relokační offsety seřazeny. Generátor je převede na
mezery od předchozího cíle.

U prvního proudu je počáteční předchozí pozice nula. Jeho první bajt je:

```text
$01
```

To znamená:

```text
přejdi z offsetu payloadu $0000 na $0001
relokuj slovo na této adrese
```

Offset `$0001` je operand úvodního `JP startPrometheus`.

U druhého proudu je počáteční předchozí pozicí hranice assembleru `$1388`. Jeho
první cíl je `$1389`, opět operand bezprostředně za opcodem entry-point `JP`,
takže první mezera je rovněž jedna.

Normální jednotlivý cíl používá:

```text
$01-$C7  -> postup o tuto vzdálenost a relokace jednoho slova
```

Nulový bajt proud ukončuje.

Největší přímo vyjádřitelná jednotlivá mezera je tedy `$C7`, neboli 199 bajtů.
Generátor odmítne vytvořit neplatný proud, pokud budoucí rozložení vytvoří větší
mezeru. Rozšíření historického formátu má být vědomou změnou zdroje, nikoli
tichým poškozením.

## Komprese opakovaných mezer

Kód Z80 často obsahuje tabulky nebo opakované tvary instrukcí, jejichž adresní
operandy jsou od sebe stejně vzdáleny. PROMETHEUS takové běhy komprimuje.

Opakovaná forma je:

```text
prefix $C8-$FF
bajt počtu
```

Její vzdálenost je:

```text
distance = prefix - $C8
```

Například:

```text
$CF,$1D
```

znamená:

```text
$CF - $C8 = mezera 7 bajtů
$1D       = 29 opakování
```

Dekodér tedy relokuje dvacet devět slov, každé sedm bajtů za předchozím.

Současný generátor používá tuto dvoubajtovou reprezentaci, pokud se alespoň dvě
stejné mezery opakují a mezera je dost malá, aby se vešla do opakovacího prefixu.
Jinak emituje obyčejné jednobajtové mezery samostatně.

Celá vygenerovaná tabulka — včetně dvou ukončovacích/padding bajtů proudů — zabírá
mnohem méně místa než 1 293 šestnáctibitových absolutních offsetů.

## Runtime dekodér mění vlastní tabulku

Dekodér začíná:

```asm
installerApplyRelocationTable:
    ld a,(hl)
    or a
    ret z
    ld (hl),001h
    cp 0c8h
    jr c,.installerApplyRelocationRun
    sub 0c8h
    inc hl
```

U krátké formy mezery se původní bajt přepíše jedničkou. HL na něj stále
ukazuje. Tento bajt se stane syntetickým počtem:

```text
proveď tuto mezeru jednou
```

U opakované formy se A změní z prefixu na vzdálenost a HL postoupí ke skutečnému
bajtu počtu.

V obou případech následující smyčka vidí:

```text
A    = mezera
(HL) = počet zbývajících opakování
```

Jde o destruktivní dekódování. To je přijatelné, protože tabulka patří do
dočasného instalátoru na `$5000`. Po instalaci už nikdy nebude potřeba.

Formálnější dekodér by uchovával samostatný registr počtu. PROMETHEUS šetří
bajty tím, že si vypůjčí samotnou tabulku.

## Posouvání ukazatele cíle

DE je průběžná adresa v nainstalovaném obrazu. Mezery v A se přičtou k jeho
dolnímu bajtu:

```asm
    add a,e
    ld e,a
    jr nc,.installerRelocateWord
    inc d
```

Jde o kompaktní šestnáctibitové přičtení unsigned osmibitové vzdálenosti:

```text
E = E + gap
if dolní bajt přetekl:
    D = D + 1
```

Formát proudu zaručuje kladnou mezeru nejvýše 199, takže není zapotřebí větší
aritmetika.

## Přebázování jednoho slova

Na zvoleném cíli musí kód přičíst BC k little-endian slovu a přitom zachovat oba
ukazatele:

```asm
.installerRelocateWord:
    pop af
    push hl
    ex de,hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    add hl,bc
    ex de,hl
    ld (hl),d
    dec hl
    ld (hl),e
    ex de,hl
    pop hl
```

Výměny registrů jsou hutné, logická operace je však obyčejná:

```text
streamPointer = HL
wordPointer   = DE

word = readWord(wordPointer)
word = word + relocationAddend
writeWord(wordPointer, word)

obnov streamPointer a průběžný wordPointer
```

Počet běhu se potom sníží přímo v tabulce:

```asm
    dec (hl)
    jr nz,.installerApplyRelocationRun
    inc hl
    jr installerApplyRelocationTable
```

Když dosáhne nuly, HL postoupí k další zakódované mezeře.

## Runtime dekodér v pseudokódu

Celou rutinu lze zapsat takto:

```text
function applyRelocationStream(stream, target, addend):
    while true:
        prefix = stream.byte

        if prefix == 0:
            return target

        if prefix < $C8:
            gap = prefix
            count = 1
            přepiš prefix hodnotou count
        else:
            gap = prefix - $C8
            stream++
            count je uložen ve stream.byte

        while stream.byte != 0:
            target += gap
            writeWord(target, readWord(target) + addend)
            stream.byte--

        stream++
```

Vrácený `target` je důležitý. Instalátor používá konečnou pozici jednoho proudu
jako počáteční referenci pro pozdější aritmetiku.

## Úplná instalace: přičtení zvoleného základu

Po zkopírování instalátor znovu získá zvolený cíl:

```asm
.installerRelocateCopiedImage:
    pop bc
    ld d,b
    ld e,c
    pop af
    push bc
    push af
```

Pro úplné rozložení:

```text
BC = zvolený rezidentní základ
DE = zvolený rezidentní základ
```

První proud začíná mezerami měřenými od offsetu payloadu nula, takže DE začíná
na základu payloadu:

```asm
    ld hl,vr_l05353h
    call installerApplyRelocationTable
```

Každé linkované slovo dostane:

```text
word += residentBase
```

První proud končí na offsetu payloadu `$11C0`. Druhý proud byl zakódován tak,
jako by jeho předchozí pozicí byla hranice assembleru `$1388`. Instalátor tuto
mezeru překlene symbolicky:

```asm
    ld hl,ENTRY_POINT_WITHOUT_MONITOR
          -ENTRY_POINT_WITH_MONITOR
          -RELOCATION_FIRST_STREAM_FINAL_TARGET_OFFSET
    add hl,de
    ex de,hl
```

Pro historické rozložení:

```text
$1388 - $11C0 = $01C8
```

DE se změní na:

```text
residentBase + $1388
```

Sdílený druhý proud nyní může pokračovat se stejným addendem BC.

## Assembler-only instalace: odečtení vynechaného prefixu

Assembler-only obraz kopíruje původní offset payloadu `$1388` na cílový offset
nula.

Linkované slovo obsahující původní offset `$2500` se má změnit na:

```text
destination + ($2500 - $1388)
```

Po úpravě výrazu:

```text
$2500 + (destination - $1388)
```

Správný relokační addend je tedy:

```text
BC = destination - $1388
```

Instalátor jej vytvoří takto:

```asm
.installerPrepareAssemblerOnlyRelocation:
    ld hl,ENTRY_POINT_WITH_MONITOR-ENTRY_POINT_WITHOUT_MONITOR
    add hl,bc
    ld b,h
    ld c,l
```

Rozdíl labelů je `-$1388`, reprezentovaný modulo 65536 jako `$EC78`.

DE zůstává fyzickým začátkem zkopírovaného suffixu. Protože mezery druhého proudu
jsou měřeny od původní hranice `$1388`, jeho první mezera jedna dopadne na
zkopírovaný cílový offset jedna — operand entry jumpu assembler-only varianty.

Stejný proud se 722 cíli nyní funguje pro obě rozložení:

```text
úplné:          počáteční ukazatel = base+$1388, addend = base
assembler-only: počáteční ukazatel = destination, addend = destination-$1388
```

To je jádro návrhu se dvěma rozloženími.

## Druhý kompatibilní patch assembler-only varianty

Kód assembleru stále obsahuje handler příkazu:

```asm
invokeMonitor:
    ...
assemblerOnlyMonitorFallbackOpcode:
    defb 0c3h
assemblerOnlyMonitorFallbackAddress:
    defw startMonitor
```

Při úplné instalaci se cíl `JP startMonitor` normálně relokuje.

Při assembler-only instalaci se `startMonitor` nezkopíroval. Příkaz nesmí skočit
do nepřítomné paměti. Po druhém relokačním proudu instalátor najde pojmenovaný
operand relativně ke konečnému cíli proudu a zapíše do něj entry adresu
assembler-only varianty:

```asm
    pop af
    pop bc
    jr c,.installerStartRelocatedProgram
    ld (hl),c
    inc hl
    ld (hl),b
```

BC bylo právě obnoveno z uloženého stacku a znovu obsahuje zvolený cíl. Příkaz
MONITOR proto v případě, že monitor neexistuje, skočí zpět na entry point
assembleru/editoru.

Jde o druhý záměrný patch suffixu. První, popsaný v kapitole 53, byl použit před
kopírováním na `emitByteAtAssemblyOutput+1`.

## Od posledního relokačního cíle k rezidentnímu stacku

Dekodér ponechá DE na posledním relokovaném slovu. V historickém rozložení s
originem nula je tímto konečným cílem `$2CDD`.

Instalátor potom přičte `$0104`:

```asm
.installerStartRelocatedProgram:
    ld hl,00104h
    add hl,de
    ld sp,hl
    push bc
    ret
```

Stack tedy není prostě `residentBase+$0104`. Aritmetika je:

```text
úplné rozložení:
    DE = residentBase + $2CDD
    SP = residentBase + $2DE1

assembler-only rozložení:
    DE = destination + ($2CDD-$1388)
    SP = destination + ($2DE1-$1388)
```

Oba výrazy označují stejný logický `internalStackTop` uvnitř příslušného
zkopírovaného rozložení.

BC bylo obnoveno na zvolenou entry adresu. `PUSH BC` následované `RET` proto
předá řízení na:

```text
úplná instalace:           destination + úplný entry offset 0
assembler-only instalace: destination + suffixový entry offset 0
```

Každý entry point začíná vlastním relokovaným `JP startPrometheus`.

## Jak generátor vytváří tabulku

Moderní build proces lze pojmově zapsat takto:

```text
sestav payload na šesti originech
porovnej každý emitovaný bajt a slovo
odmítni nepodporované jednobajtové závislosti
použij explicitní anotace @noreloc/@reloc
odmítni překrývající se relokační slova
rozděl cíle u ENTRY_POINT_WITHOUT_MONITOR
seřaď každou skupinu
převeď cíle na mezery
komprimuj opakované mezery
emituj relocationTable.asm
emituj čitelný report relokace
```

Vygenerovaný soubor také publikuje:

```asm
RELOCATION_FIRST_STREAM_FINAL_TARGET_OFFSET
RELOCATION_SECOND_STREAM_FINAL_TARGET_OFFSET
```

Instalátor používá tyto symbolické hodnoty při překlenovací aritmetice a při
aritmetice konečného patche. Když se kód posune, generátor aktualizuje proud i
reference instalátoru na jeho konečné pozice.

U nezměněného zdroje vygenerované bajty přesně reprodukují historickou tabulku.

## Co relokace neslibuje

Relokace zajistí, že interní absolutní adresy následují přesunutý rezidentní
obraz. Neřeší automaticky každou možnou úpravu.

Budoucí změna může stále selhat, pokud:

- vytvoří osamocený LOW/HIGH bajt labelu;
- vytvoří mezi relokačními cíli mezeru větší než `$C7`;
- změní výjimku `@noreloc` ve skutečný ukazatel;
- uloží adresu runtime zakódováním, které generátor nezná;
- dovolí zvětšenému rezidentnímu obrazu kolidovat se zdrojem, obrazovkou, ROM
  nebo U-TOP.

Současný build kontroluje první tři podmínky explicitně. Politika rozložení
paměti zůstává samostatnou návrhovou odpovědností.

## Co se změnilo v paměti

Během relokace:

- se při úplné instalaci upraví 571 slov v prefixu monitoru;
- v obou rozloženích se upraví 722 slov v suffixu assembleru/editoru;
- dočasné bajty počtu v relokační tabulce se přepisují a dekrementují;
- assembler-only režim přepíše operand fallbacku MONITOR;
- DE postoupí k poslednímu relokovanému cíli;
- SP se přesune z dočasného workspace instalátoru na `internalStackTop`;
- řízení přejde přes relokovaný entry-point jump.

## Důležité navštívené labely

- `relocatablePayloadStart`
- `ENTRY_POINT_WITH_MONITOR`
- `ENTRY_POINT_WITHOUT_MONITOR`
- `vr_l05353h`
- `vr_l05547h`
- `RELOCATION_FIRST_STREAM_FINAL_TARGET_OFFSET`
- `RELOCATION_SECOND_STREAM_FINAL_TARGET_OFFSET`
- `.installerRelocateCopiedImage`
- `.installerPrepareAssemblerOnlyRelocation`
- `.installerApplySecondRelocationTable`
- `installerApplyRelocationTable`
- `relocationExceptionMonitorEntryDescriptorWord`
- `assemblerOnlyMonitorFallbackAddress`
- `.installerStartRelocatedProgram`
- `internalStackTop`

## Zpět k celému stroji

Rezidentní obraz je nyní vnitřně konzistentní. Jeho absolutní skoky, volání,
ukazatele, položky dispatchů, samomodifikované operandy i adresy tabulek odkazují
do zvolené instalační oblasti.

PROMETHEUS prošel třemi souřadnicovými systémy:

```text
linkované offsety s originem nula
fyzické adresy načtení z kazety
konečné rezidentní adresy
```

Vygenerovaná tabulka propojuje první a třetí. Bootstrap a kopírovací logika
propojují druhý a třetí.

Mimo rezidentní zdroj zbývá kazetový kontejner, který celý instalační obraz
přenese do Spectra. Příští kapitola se podívá na tuto vnější vrstvu: BASICový
loader, hlavičkové a datové bloky Spectra a XOR kontrolní součty, díky nimž je
soubor `.tap` platným obrazem kazety.
