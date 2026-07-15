# Dodatek A: Instrukce Z80 použité neobvyklými způsoby

Tento dodatek není obecným manuálem instrukcí Z80. Je průvodcem místy, kde
PROMETHEUS žádá obyčejnou instrukci, aby vykonala neobvyklou práci. Samotná
instrukce není záhadná. Neobvyklá je okolní dohoda o registrech, flags, obsahu
stacku, zapisovatelných operandech nebo bajtech, které jsou dočasně považovány
za kód.

Při čtení zdroje je užitečné pravidlo:

```text
Neptej se jen: „Co tato instrukce dělá?“
Ptej se také: „Co kolem ní PROMETHEUS uspořádal, aby tento účinek znamenal
něco většího?“
```

Následující oddíly shromažďují vzory, kvůli nimž zdroj nejčastěji vypadá
kouzelnější, než ve skutečnosti je.

## A.1 Alternativní banky registrů jsou druhý pracovní stůl

Z80 má druhou kopii `BC`, `DE` a `HL`, volenou instrukcí `EXX`, a druhý `AF`,
volený instrukcí `EX AF,AF'`. PROMETHEUS používá tyto banky ke třem zcela
odlišným účelům.

### A.1.1 Dočasné uchování bez paměti

Malá rutina může přejít do alternativní banky, zavolat kód, který volně používá
běžné registry, a potom se vrátit:

```asm
readKeyCode:
    exx
    call processKey
    exx
    call isLetter
    ret nz
    or 020h
    ret
```

Monitor uchovává užitečný stav v alternativní bance. `readKeyCode` proto přesune
klávesnicový mechanismus pryč od tohoto stavu, místo aby jednotlivě ukládal a
obnovoval tři páry registrů.

Je to rychlejší a menší než konvenční sekvence ukládání, vytváří to však místní
smlouvu: kód mezi oběma instrukcemi `EXX` nesmí sám předpokládat, že alternativní
banka obsahuje běžný stav monitoru.

### A.1.2 Přenášení dvou nezávislých kontextů stroje

Kazetové rutiny používají `EX AF,AF'`, protože ROM Spectra očekává požadovaný
flag bajt kazety a carry určující LOAD/VERIFY v alternativním akumulátoru a
flags. PROMETHEUS připraví běžný `AF`, vymění jej do `AF'` a potom vstoupí do
rutiny ROM.

Důležité je, že `AF'` zde není jen „uložený AF“. Je vstupním kanálem pro kód ROM.

### A.1.3 Uložení uživatelského procesoru, zatímco monitor pokračuje

Monitor vykonávání musí zachovat program, který zkoumá, a současně mít registry,
v nichž může pracovat. Jeho uložený obraz procesoru žije převážně v paměti,
ale výměny alternativních registrů jsou součástí přenosu mezi skutečným Z80 a
tímto obrazem. Na hranici není banka registrů pouhým scratch prostorem; patří
jedné ze dvou osobností:

```text
osobnost monitoru     osobnost uživatelského programu
```

Proto může být zdánlivě nevinné vložení `EXX` nebo `EX AF,AF'` velmi nebezpečné.
Instrukce nemusí vyměňovat dvě dočasné hodnoty, ale dva úplné kontexty.

### Kontrolní seznam pro čtení `EXX` a `EX AF,AF'`

Než budete sledovat další instrukci, určete:

1. která banka patřila volajícímu;
2. zda může během výměny bank nastat přerušení;
3. zda rutina ROM očekává hodnoty výslovně v `AF'`;
4. zda se kód vrátí přes stejné místo výměny;
5. zda je v některé bance živý stav uživatelského programu.

## A.2 Stack pointer je pohyblivý ukazatel na data

Většina začátečnických programů považuje `SP` za pevný ukazatel na stack volání.
PROMETHEUS s ním zachází jako s registrem, který může dočasně adresovat libovolný
pečlivě připravený proud slov.

### A.2.1 Opětovné přečtení spotřebované návratové adresy

Bootstrap odolný vůči relokaci zavolá bajt ROM obsahující prosté `RET`:

```asm
    call ROM_ImmediateRET
bootstrapRecoverLoadAddress:
    dec sp
    dec sp
    pop bc
```

`CALL` zapíše na stack adresu za voláním. ROM `RET` toto slovo spotřebuje. Dvě
instrukce `DEC SP` posunou stack pointer zpět přes stejné bajty a `POP BC` přečte
návratovou adresu jako data.

PROMETHEUS nyní zná fyzickou adresu uvnitř načteného obrazu, přestože obraz
nemusel být načten na svou nominální adresu sestavení.

Nejde o poškození stacku. Je to záměrné převinutí slova, o němž je známo, že po
posunutí `SP` instrukcí `RET` zůstává v RAM.

### A.2.2 `EX (SP),HL` jako obousměrné předání

Při vstupu do instalátoru je jedna užitečná adresa v `HL` a druhá na vrcholu
dočasného stacku. Instalátor je vymění:

```asm
    ex (sp),hl
```

Po výměně:

- `HL` obsahuje původní fyzickou bázi načtení potřebnou pro zobrazení;
- stack obsahuje fyzický ukazatel na payload, potřebný později, až ENTER potvrdí
  instalaci.

Instrukce provede výměnu mezi registrem a trvale odloženým argumentem. Není
potřeba žádná další dvoubajtová proměnná.

### A.2.3 Tabulka převlečená za stack

Tabulka konfiguračních patchů instalátoru je řadou signed šestnáctibitových
displacementů. Instalátor namíří `SP` na tuto tabulku a nechá pomocná volání
postupně provádět `POP` dalších displacementů.

Konceptuálně:

```text
SP -> delta 1, delta 2, delta 3, ...

repeat:
    POP next delta
    add delta to current patch pointer
    write selected setting
```

Je to kompaktní, protože `POP` je krátká a rychlá čtečka little-endian slov,
která současně automaticky posouvá ukazatel proudu. Cenou je, že běžné vnořování
podprogramů nemůže během průchodu používat stejný stack, pokud kód nepřipravil
oddělenou cestu pokračování.

### A.2.4 Reset opuštěného toku řízení

`startMonitor` a teplé vstupy editoru načtou do `SP` hodnotu `internalStackTop`.
Tím úmyslně zahodí staré stack frames. Chyba parseru, zrušená kazetová operace
nebo příkaz monitoru mohly uniknout přes patchované pokračování, místo aby se
vracely ze všech běžných volání. Reset `SP` dělá z teplého vstupu kontrolní bod
toku řízení.

Invariant nezní „každému CALL odpovídá RET“. Zní:

```text
Každý dlouhodobý režim se nakonec vrátí do vstupu, který nastaví známý stack.
```

### A.2.5 Běh se skutečným uživatelským stackem

Nativní CALL monitoru a breakpointové operace obnovují uložené uživatelské `SP`
před vykonáním uživatelského kódu. Je to nutné pro autentické chování `CALL`,
`RET`, `PUSH`, `POP` a přerušení. Znamená to také, že uložený stack musí ukazovat
do zapisovatelné platné RAM. Varování manuálu o stacku je tedy přesným
požadavkem stroje, nikoli obecnou opatrností.

## A.3 Syntetická volání vytvořená pomocí `PUSH` a `RET`

Z80 nemá instrukci `CALL (HL)`. PROMETHEUS často získá stejný účinek vložením
adresy na stack a vykonáním `RET`.

### A.3.1 Dispatch tabulky

Dispatcher kláves monitoru vypočte v `HL` adresu handleru z kompaktního seznamu
delt. Při shodě provede:

```asm
    push hl
    ld hl,(varcMonitorCurrentAddress+1)
    ret
```

`RET` načte vypočtený handler do `PC`. Handler uvidí současnou adresu monitoru v
`HL`, přesně jako kdyby existovala instrukce nepřímého volání.

Pod syntetickou adresou handleru leží další adresa, `startMonitor`, vložená před
zahájením dispatch. Když handler nakonec vykoná vlastní `RET`, vrátí se do smyčky
překreslení monitoru.

Stack tedy obsahuje záměrně sestavený dvouúrovňový řetězec volání:

```text
top -> selected handler
       startMonitor
```

### A.3.2 Handlery instalátoru, které všechny překreslují

Instalátor vloží `installerRedrawAndWait` na stack před kontrolou zvolené klávesy.
Většina handlerů kláves pouze změní jeden bajt a provede `RET`. Jejich návrat
překreslí obrazovku a obnoví vstup.

ENTER je jiný: odstraní nebo obejde tento syntetický návrat, protože instalátor
opouští natrvalo.

### A.3.3 Vstup do relokovaného rezidentu pomocí `RET`

Po zkopírování a relokaci zvoleného obrazu vytvoří instalátor nový rezidentní
stack, vloží zvolenou vstupní adresu a vykoná `RET`. Tím se vyhne absolutnímu
`JP`, jehož cíl by závisel na režimu a cíli instalace.

### A.3.4 Proč se místo toho nepoužívá vždy `JP (HL)`

`JP (HL)` změní tok řízení, ale nevytvoří návratovou adresu. Také vyžaduje, aby
cíl zůstal v `HL`, který může být potřebný jako argument. Vzor `PUSH`/`RET` může:

- vytvořit nepřímé volání;
- předat `HL` cíli poté, co byl cíl vložen na stack;
- umístit pod něj vnější pokračování;
- sestavit cíl z libovolného páru registrů nebo výsledku tabulky.

## A.4 Návratové adresy používané jako ukazatele na inline data

Několik rutin PROMETHEA ukládá data bezprostředně za `CALL`:

```asm
    call installerPrintInlineString
    defb "Text", "!"+080h
    ; execution continues here
```

Volaná rutina sejme svou návratovou adresu ze stacku a zachází s ní jako s
ukazatelem na inline bajty. Po nalezení terminátoru s nastaveným high bit skočí
na bajt za daty.

Stejná technika se používá pro jednobajtové tokeny promptů monitoru:

```asm
    call promptForMonitorValue
    defb 0c4h
```

Zde návratová adresa ukazuje na jediný token. Rutina tento bajt spotřebuje,
vloží opravené pokračování na stack a otevře sdílený editor vstupu.

Tento vzor šetří:

- samostatné načtení ukazatele;
- zvlášť označený krátký řetězec nebo token;
- další tabulku oprav návratových adres.

Znamená to také, že disassembler, který slepě považuje bajty za každým `CALL` za
instrukce, zobrazí nesmysl. Čtenář zdroje musí vědět, které cíle volání
spotřebovávají inline data.

## A.5 Flags jako malé návratové hodnoty

PROMETHEUS často vrací rozhodnutí v jednom flagu místo v bajtu. Je to běžná
praxe Z80, ale několik idiomů lze snadno přečíst chybně.

### A.5.1 `CP A` jako „vrať equal“

Pomocná rutina může ověřit rozsah a skončit:

```asm
    cp a
    ret
```

`CP A` vždy nastaví Z a vynuluje carry, protože A se rovná samo sobě. Je to
kompaktní způsob, jak vrátit „ano“, aniž se změní A.

Klasifikační helpery `isNumber` a `isLetter` používají tuto konvenci: Z znamená,
že znak patří do třídy.

### A.5.2 `OR A` a `AND A` jako vynulování carry

`OR A` a `AND A` ponechají A číselně beze změny, ale vynulují carry a nastaví Z
podle A. Často připravují unsigned porovnání `SBC HL,DE`:

```asm
    or a
    sbc hl,de
```

Bez první instrukce by staré carry odečetlo jednu jednotku navíc.

Zdroj používá `OR A` i `AND A`; volba může odrážet okolní rozložení bajtů nebo
původní styl programování, nikoli odlišný algoritmus.

### A.5.3 `SCF` následované `CCF`

Carry někdy představuje obrácenou podmínku. Zdroj používá `CCF` po porovnání, aby
přizpůsobil konvenci jednoho helperu konvenci druhého, místo aby porovnání
opakoval.

### A.5.4 Podmíněné CALL jako politika zobrazení

Pomalé a rychlé trasování používají opačné podmínky volání překreslení panelu:

```asm
    call c,redrawFrontPanelAtCurrentAddress
```

nebo:

```asm
    call nc,redrawFrontPanelAtCurrentAddress
```

Předchozí test klávesy záměrně vrátil svůj stav v carry. Volání netestuje
aritmetické přetečení; implementuje „zobraz každý krok“ nebo „potlač zobrazení,
dokud je držena tato kombinace“.

### A.5.5 Zachování výsledku ROM přes dotaz klávesnice

Kazetové helpery potřebují carry vrácené ROM LD-BYTES, ale také musí testovat
SPACE. Používají:

```asm
    push af
    ; poll port $FE
    pop af
    ret
```

`PUSH AF` zde neukládá především A. Zachovává flag úspěchu, zatímco nesouvisející
hardwarový test zničí flags.

## A.6 Delay a testy wrapu zachovávající hodnotu

Charakteristická smyčka se objevuje v instalátoru, opakování kláves a beeperu:

```asm
    dec hl
    inc h
    dec h
    jr nz,loop
```

nebo:

```asm
    inc hl
    inc h
    dec h
    jr nz,loop
```

`INC H` následované `DEC H` obnoví H na původní hodnotu, ale závěrečné `DEC H`
nastaví Z podle této hodnoty. Dvojice je tedy kompaktním způsobem, jak testovat,
zda je H nula, aniž se změní šestnáctibitová hodnota čítače ponechaná v HL.

Neměla by být „zjednodušena“ na `LD A,H / OR A` bez kontroly velikosti, flags,
časování a historické identity. Ve zvukovém nebo klávesnicovém delay je časování
součástí chování.

## A.7 Blokové instrukce používané jako algoritmy

### A.7.1 `LDIR` jako copy, clear a fill

Stejná instrukce vykonává několik úloh podle prvního bajtu a vzájemné polohy HL
a DE.

Pro vymazání rozsahu:

```asm
    ld hl,start
    ld de,start+1
    ld (hl),0
    ld bc,length-1
    ldir
```

Nula zapsaná do prvního bajtu se opakovaně kopíruje dopředu.

Pro vyplnění libovolným bajtem se první cílový bajt zapíše explicitně a potom se
stejným způsobem replikuje.

Pro kopírování HL a DE jednoduše označují oddělené zdrojové a cílové rozsahy.

### A.7.2 `LDDR` jako zpětná polovina `memmove`

Když cíl začíná uvnitř zdrojového rozsahu na vyšší adrese, dopředné kopírování
by přepsalo bajty dříve, než jsou přečteny. PROMETHEUS posune oba ukazatele na
inkluzivní poslední bajt a použije `LDDR`.

Instalátor volí `LDIR` nebo `LDDR`, protože konečný rezidentní cíl se může
překrývat s dosud načteným instalačním obrazem.

### A.7.3 Opakované instrukce a monitor vykonávání

`LDIR` a `LDDR` jsou při kontrolovaném vykonávání zvláštní. Jejich paměťové
účinky pokrývají rozsahy, nikoli jeden zdrojový a jeden cílový bajt. PROMETHEUS
vypočte úplné rozsahy z uložených `HL`, `DE`, `BC` a směru, zkontroluje ochranu,
vypočte `21 * BC - 5` T-stavů a potom nechá skutečný procesor vykonat opakovanou
instrukci ve scratch trampoline.

## A.8 Nepřímé skoky a rekonstrukce nepřímého toku řízení

### A.8.1 Skutečné nepřímé skoky Z80

Z80 poskytuje:

```asm
jp (hl)
jp (ix)
jp (iy)
```

Monitor vykonávání PROMETHEA nemůže takovou instrukci zkopírovat do scratch RAM
a očekávat, že scratch adresa se stane dalším program counterem. Instrukci
rozpozná a logický cíl vezme z uloženého uživatelského registru. Zkopírované
bajty skoku se neutralizují a hodnota zvoleného registru se předá cestě zachycení
stavu.

### A.8.2 Indexované vektory handlerů

Mnoho tabulek PROMETHEA ukládá jednobajtové displacementy od položky, která je
obsahuje. Dispatcher načte displacement, přičte jej k vlastní adrese položky a
skočí nebo se vrátí přes výsledek.

Vektor je proto relokovatelný, aniž se jej instalátor dotkne:

```text
target = address_of_this_vector_byte + signed_or_unsigned_delta
```

Přesný bias se mezi tabulkami liší, proto vždy přečtěte konzumenta, než budete
bajt interpretovat jako offset.

### A.8.3 Patchované operandy `JP` a `CALL`

Label jako `varcPostCommandContinuationJump` často označuje instrukci, jejíž dva
operandové bajty se mění za běhu. Vykonávání zůstává obyčejným absolutním skokem;
jen jeho cíl se stal stavem.

Důležité rozlišení je:

```text
indirect jump through register      target supplied at execution time
self-modified absolute jump         target stored earlier in instruction bytes
```

## A.9 Refresh registr není obyčejný čítač

Registr `R` Z80 se zvyšuje při fetch každého opcode instrukce. Bit 7 má zvláštní
chování a není prostě součástí dolního sedmibitového refresh čítače. PROMETHEUS
uloží uživatelův `R`, vykoná instrukce monitoru a trampoline a později uloženou
hodnotu opraví, aby zobrazený či obnovený stav více odpovídal vykonání bez
nadbytečných fetchů monitoru.

`adjustSavedRefreshRegisterLow7` mění bity 0–6 a zachovává bit 7. Úklid
breakpointu používá opravu odpovídající snížení dolních sedmi bitů o jedna; jiné
cesty trasování používají opravy odpovídající jejich nadbytečným fetchům.

Tento mechanismus je nutně choulostivý:

- prefixy se počítají jako opcode fetch;
- zkopírované scratch instrukce přidávají fetch, který na původní adrese nebyl;
- vstup do monitoru a cesty zachycení přidávají další;
- bit 7 musí přežít opravu dolních sedmi bitů.

Náhrada, která by jednoduše zvýšila nebo snížila celý bajt, by byla na hranici
`$7F/$80` chybná.

## A.10 Operandy kódu používané jako proměnné

PROMETHEUS často ukládá trvalý stav uvnitř instrukce, kterou algoritmus stejně
potřebuje:

```asm
varcMonitorCurrentAddress:
    ld de,00000h
```

Zápis do `varcMonitorCurrentAddress+1` změní immediate word. Pozdější vykonání
instrukce načte zapamatovanou hodnotu.

Běžné tvary jsou:

| Tvar instrukce | Bajty používané jako stav |
|---|---|
| `LD A,n` | jeden bajt režimu, čítač nebo Boolean |
| `LD HL,nn` / `LD DE,nn` | ukazatel nebo šestnáctibitová hodnota |
| `CALL nn` | cíl callbacku |
| `JP nn` | cíl pokračování |
| `CP n` | zapamatovaná porovnávací hodnota |
| `LD SP,nn` | uložený stack pro opakování nebo obnovu |
| jednobajtový opcode | režim, jehož hodnota se vykonává |

Prefix `varc...` v rekonstruovaném zdroji varuje, že bajty jsou současně
instrukcí i úložištěm.

### A.10.1 Stav, jehož hodnotou je opcode

Některá nastavení jsou reprezentována opcode, protože vykonat nastavení je
levnější než je testovat. Příklady:

- `NOP`, `RET Z` nebo `RET` pro politiku přímého CALL;
- `NOP` nebo `RRCA` pro normální/tučné glyphs instalátoru;
- tvary `AND n` nebo `OR n` pro změnu velikosti písmen;
- změna `JP nn` na `LD HL,nn`, která přesměruje dokončení vstupu monitoru do
  cesty jednořádkového assembleru.

V posledním příkladu se mění pouze první opcode bajt. Následující dva bajty
zůstávají užitečným slovem. Pod `$C3` jsou cílem skoku; pod `$21` jsou immediate
hodnotou načtenou do HL. Vykonávání potom propadne do další cesty. Jde o opětovné
použití tvaru kódu, nikoli jen o patchovanou větev.

### A.10.2 Pravidla pro změnu pole `varc`

Při úpravách takového kódu ověřte vše následující:

1. label označuje začátek instrukce nebo přesný zamýšlený operandový bajt;
2. zápis má správnou šířku;
3. žádné přerušení ani alternativní vstup nemůže instrukci vykonat napůl
   patchovanou;
4. relokační metadata stále rozpoznávají slova závislá na originu;
5. assembler-only instalace stále opravuje odkazy do vynechaného prefixu;
6. každý deskriptor překrývající stejné bajty zůstává platný.

## A.11 Dočasné vykonávací trampolines

Monitor nemůže při pozorování bezpečně vykonat každou zkoumanou instrukci na
její původní adrese. Sestaví krátký program ve scratch paměti. Zjednodušená
trampoline vypadá takto:

```text
restore interrupt state
restore user registers
execute copied or substituted instruction
capture the resulting user state
return to monitor stack
```

### A.11.1 Proč samotná zkopírovaná instrukce nestačí

Instrukce toku řízení odkazují na své původní umístění nebo manipulují se
stackem. Relativní skoky zkopírované jinam by počítaly ze scratch adresy. CALL
by vložil scratch návratovou adresu. RET by trampoline opustil. Nepřímé skoky by
nikdy nedosáhly zachycovacího ocasu.

PROMETHEUS proto instrukci klasifikuje a může ji nahradit, obklopit nebo
neutralizovat:

- obyčejná sekvenční instrukce: zkopírovat a propadnout do zachycení;
- podmíněná relativní větev: připravit oddělené taken a untaken zachycení;
- `CALL`: předpovědět cíl a návratové chování, nebo jej vykonat nativně podle
  zvolené politiky direct-call;
- `RET`: přečíst cíl z uloženého stacku a posunout uložený SP;
- `RST`: syntetizovat jeho vektor a stackový účinek;
- `JP (HL/IX/IY)`: použít uložený registr jako další PC;
- `RETN/RETI`: částečně rekonstruované, s detaily návratu z přerušení výslovně
  ponechanými nejistými.

### A.11.2 Scratch bajty mohou být instrukcemi jen krátce

Scratch oblast je zapisovatelná pracovní paměť. Pro jeden krok může obsahovat
prefixy, zkopírovaný opcode, displacement, callbackové skoky a fragmenty
zachycení stavu a při dalším kroku být přepsána. Statický disassembly této
oblasti není trvalým popisem programu.

## A.12 Kód a data se záměrně překrývají

Některé tabulky jsou uspořádány tak, že bajt může být současně poslední položkou
tabulky a prvním bajtem užitečné instrukce dosažené po úspěšném vyhledání.
Jedním příkladem je tabulka podmínek editoru flags. Jinde jsou bajty vypadající
jako `RST $38` maskami deskriptorů s hodnotou `$FF`, nikoli voláními rutiny
přerušení.

Bezpečné pravidlo zní:

```text
Bajt je kódem pouze na prokázané cestě vykonávání.
Jeho vzhled jako mnemonic není důkazem.
```

Je to zvlášť důležité kolem:

- tabulek capabilities čelního panelu;
- deskriptorů toku řízení a přístupů do paměti;
- slovníků operací;
- selektorů flags monitoru;
- slov výjimek z relokace;
- kompaktních workspace příkazů.

## A.13 Instrukce, jejichž vedlejší účinky jsou záměrně vypůjčeny

PROMETHEUS často volí instrukci kvůli sekundárnímu účinku.

| Instrukce | Vypůjčený účinek |
|---|---|
| `CALL` | ponechá na stacku fyzickou adresu sebe sama nebo ukazatel na inline data |
| `RET` | nepřímý skok přes sestavené slovo na stacku |
| `POP` | čte a posouvá kompaktní proud slov |
| `EX (SP),HL` | vymění živý argument s odloženým |
| dvojice `INC/DEC H` | nastaví Z a současně obnoví H |
| `RRA` | přesune jeden klávesnicový bit do carry |
| `RRCA` | přesune attribute bits do pozic portu ULA nebo transformuje řádek glyphu |
| `LDIR` | kopírování, mazání nebo vyplnění podle počátečního uspořádání bajtů |
| `DJNZ` | časování delay i počítání smyčky |
| `CP A` | bezpodmínečný výsledek Z=1, C=0 |
| `OR A` | vynuluje carry před šestnáctibitovým odčítáním |
| `RST $10` | kompaktní výstup znaku ROM po nastavení kanálu |
| bajty `RST $38` | v některých tabulkách pouze bajt `$FF`, nikoli vykonání |

## A.14 Metoda čtení každé podezřelé sekvence

Když krátká sekvence vypadá jako trik, postupujte v tomto pořadí:

1. **Najděte vstupní smlouvu.** Které registry, flags, stacková slova a
   zapisovatelné operandy jsou už připraveny?
2. **Označte hranice kódu a dat.** Spotřebovává rutina bajty za voláním? Má
   tabulka tvar opcodes?
3. **Sledujte SP explicitně.** Zapište každé vložené slovo a každé syntetické
   pokračování.
4. **Pojmenujte flag.** Nahraďte „carry“ jeho místním významem: úspěch kazety,
   BREAK nestisknutý, platný rozsah, potlačené zobrazení a podobně.
5. **Zkontrolujte alternativní banky.** Rozhodněte, která osobnost vlastní každou
   banku.
6. **Hledejte zápisy do operandů.** Konstanta ve výpisu může být runtime stav.
7. **Sledujte oba výstupy.** Chybějící `RET` může být záměrný fall-through do
   teplého vstupu.
8. **Rozlišujte emulaci od nativního vykonání.** Monitor někdy kontroluje a
   simuluje, jindy nechá procesor běžet přímo.
9. **Nahlédněte do dodatku G.** Několik cest, zejména RETN/RETI, je
   zdokumentováno jako nejistých, nikoli tiše sjednoceno.

PROMETHEUS se čte mnohem snadněji, jakmile tyto techniky přestanou působit jako
izolovaná chytrost. Tvoří konzistentní styl: využívat vedlejší účinky instrukcí,
znovu používat bajty, držet stav blízko kódu, který jej spotřebovává, a na
bezpečných hranicích resetovat celé kontexty řízení.
