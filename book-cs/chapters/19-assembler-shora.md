# Kapitola 19: Assembler shora

Editor už máme za sebou.

To neznamená, že zmizel. Assembler závisí téměř na každé myšlence editoru, kterou jsme poznali:

- zdroj je stále řetězem komprimovaných záznamů;
- labely a jména ve výrazech jsou stále pořadovými čísly symbolů, nikoli opakovaným textem;
- aktivní řádek se stále používá, když je třeba ukázat chybu;
- hranice bloku mohou stále omezit prováděnou operaci;
- pohyblivý konec zdroje a symbolů stále určuje, kde začíná volná paměť.

Otázka se však změnila.

Editor se ptá:

> Jak může člověk zadávat, ukládat a měnit zdroj v assembleru?

Assembler se ptá:

> Jaké bajty tento zdroj znamená a kam se mají uložit?

Tato kapitola nabízí první pohled na odpověď shora. Několik obtížných mechanismů zatím záměrně necháme zavřených. Výrazy dostanou vlastní kapitolu. Symboly dvě. Emise instrukcí další. Prozatím chceme vidět podobu sestavení od chvíle, kdy uživatel zvolí `ASSEMBLY`, až do okamžiku, kdy editor oznámí dokončení práce.

## Viditelná operace je téměř podezřele jednoduchá

Handler příkazu je drobný:

```asm
invokeAssembly:
    call processCompilation
    ld a,MESSAGE_ASSEMBLY_COMPLETE
    jp prometheusWarmStartWithMessage
```

Neexistuje žádný zvláštní režim obrazovky, čítač postupu ani tištěný listing. Pokud se `processCompilation` vrátí běžným způsobem, PROMETHEUS zvolí stavový text `Assembly complete` a znovu vstoupí do editoru.

Dojde-li k chybě, k běžnému návratu vůbec nedojde. Společný mechanismus chyb použije ukazatel na záznam zdroje uložený controllerem sestavení, učiní tento záznam aktivním, zobrazí příslušné hlášení a vrátí uživatele na řádek, který potíže způsobil.

Z pohledu klávesnice proto sestavení vypadá jako jediná nedělitelná operace:

```text
zadej ASSEMBLY
    → krátká prodleva
    → buď chyba na jednom řádku zdroje,
      nebo „Assembly complete“
```

Uvnitř programu však PROMETHEUS projde zdroj dvakrát.

## Proč existují dva průchody

Uvažujme tento malý program:

```asm
        ORG 32768
START   LD B,5
LOOP    DJNZ LOOP
        RET
        ENT START
```

Instrukce `DJNZ LOOP` obsahuje relativní displacement. Aby jej assembler zakódoval, musí znát adresu `LOOP` i adresu bezprostředně za instrukcí `DJNZ`.

V tomto příkladu se label nachází před odkazem, takže by si jednoduchý jednosměrný assembler poradil. Skutečné programy však obsahují dopředné odkazy:

```asm
        JR Z,FINISHED
        ; many instructions
FINISHED RET
```

Když assembler dorazí k `JR Z,FINISHED`, adresa `FINISHED` ještě není známa. Nabízí se několik možných návrhů:

1. dopředné odkazy zakázat;
2. zapamatovat si každou nedokončenou opravu a později se k ní vrátit;
3. jedním průchodem zdroje zjistit adresy a druhým průchodem emitovat bajty.

PROMETHEUS volí třetí řešení.

Oba průchody mají odlišnou práci.

### První průchod: zjistit tvar programu

První průchod sleduje záznamy zdroje v pořadí a určuje:

- adresu příslušející každému labelu řádku;
- hodnotu symbolů `EQU`, které lze vyhodnotit;
- o kolik každá strojová instrukce posune logickou adresu;
- jak `ORG`, `PUT` a rezervované místo ovlivní čítače;
- zda nejsou definice duplicitní nebo jinak neplatné.

Konečné bajty opcodů ještě nemusí ukládat na jejich cílové místo.

### Druhý průchod: vytvořit výsledek

Druhý průchod opakuje tutéž cestu zdrojem. Tentokrát lze ve výrazech použít labely určené prvním průchodem. Assembler:

- zapisuje prefixy instrukcí a opcody;
- zapisuje bezprostřední bajty a slova;
- počítá displacementy relativních skoků;
- emituje data `DEFB`, `DEFM` a `DEFW`;
- provádí změny ukazatelů vyžádané `ORG`, `PUT` a `DEFS`;
- zaznamená adresu `ENT` používanou příkazem RUN.

V prostém pseudokódu:

```text
vymaž definice běžných symbolů

pass = 1
address = defaultStart
for each vybraný záznam zdroje:
    zjisti definice a délku záznamu

pass = 2
address = defaultStart
output = defaultStart
for each vybraný záznam zdroje:
    vyhodnoť konečné operandy a emituj bajty
```

Důležitá jsou slova **tatáž cesta zdrojem**. PROMETHEUS nemá dvě velké a z větší části duplicitní smyčky sestavení. Má jediný controller, jehož akce pro jeden záznam se mezi průchody vymění.

## Controller je malý stroj sám pro sebe

Hlavní rutinou je `processCompilation`.

Její zdroj začíná rozhodnutím, zda se má sestavit celý zdroj, nebo pouze vybraný blok:

```asm
processCompilation:
    call containsInputBufferCharacterB
    ld a,000h
    jr z,.storeCompilationScope
    inc a
.storeCompilationScope:
    ld (varcCompileWholeSource+1),a
```

Volitelný parametr příkazu `B` znamená sestavení pouze bloku. Uložený příznak má poněkud neintuitivní význam:

```text
0  sestav pouze vybraný blok
1  sestav celý zdroj
```

Toto obrácení není hlubokou vlastností jazyka. Pouze umožní, aby pozdější `OR A` a podmíněný skok levně zvolily běžnou cestu celého zdroje.

Před prvním průchodem assembler vymaže stav `DEFINED` běžných symbolů:

```asm
    ld c,0b6h
    call processSymbolTableItems
```

Hodnota `$B6` je sama zakódovanou instrukcí `RES 6,(HL)`, předanou společnému modifikátoru vektoru symbolů. Uzamčené symboly si zachovávají samostatný stav zámku a mohou dál představovat definice dodané již sestavenou spodní vrstvou. Tento kompaktní mechanismus symbolů prozkoumáme v kapitolách 23 a 24.

Prozatím je výsledkem:

```text
běžné definice z předchozího sestavení se zapomenou
uzamčené externí definice zůstanou dostupné
```

Je to důležité, protože nový první průchod nesmí omylem považovat label za již definovaný jen proto, že předchozí sestavení zanechalo hodnotu v jeho položce symbolu.

## Jedna smyčka, dvě osobnosti

Controller inicializuje samomodifikované `CALL` rutinou prvního průchodu:

```asm
    ld a,001h
    ld (varcAssemblyPassTransitionCounter+1),a
    ld hl,firstPassProcessSourceRecord
    ld (varcAssemblyPassHandlerCall+1),hl
```

Později ve zdroji najdeme samotné volání:

```asm
varcAssemblyPassHandlerCall:
    call firstPassProcessSourceRecord
```

Viditelný operand `firstPassProcessSourceRecord` je pouze počáteční hodnota. Po prvním průchodu program zapíše adresu `secondPassEmitSourceRecord` do dvou bajtů operandu za opcodem `CALL`.

Smyčka scanu se tedy chová takto:

```text
handler = firstPassProcessSourceRecord
projdi zdroj

handler = secondPassEmitSourceRecord
projdi zdroj znovu
```

Moderní jazyk by mohl ukazatel na funkci uložit do proměnné. PROMETHEUS jej ukládá přímo do instrukce, která funkci zavolá. S tímto stylem jsme se setkali v kapitole 5. Zde se z něj stává architektonický prostředek: jediná kompaktní smyčka provádí oba průchody.

## Kde ve výchozím stavu začíná generovaný kód

Na začátku každého průchodu controller načte aktuální konec zabalené oblasti zdroje a symbolů:

```asm
.initializeAssemblyPass:
    ld hl,(varcCodeEndPt+1)
    inc hl
    ld (varcAddressCounter+1),hl
    ld (varcAssemblyOutputPointer+1),hl
    ld hl,sourceBufferAccessLine
```

Jeden bajt za `varcCodeEndPt` se stane současně:

- počátečním **čítačem logické adresy**;
- počátečním **fyzickým ukazatelem výstupu**.

Tato výchozí volba je praktická. Pokud program neobsahuje `ORG` ani `PUT`, sestavený kód se uloží bezprostředně za aktuální zdroj a tabulku symbolů PROMETHEA.

Oba ukazatele začínají se stejnou hodnotou, ale pojmově se liší.

### Čítač logické adresy

`varcAddressCounter` odpovídá na otázky jako:

- Jakou hodnotu má dostat tento label?
- Co zde znamená atom výrazu `$`?
- Jak daleko leží cíl relativního skoku od následující instrukce?
- Jaká adresa následuje za touto instrukcí nebo rezervovanou oblastí?

Popisuje adresu, **o níž si generovaný program myslí, že ji obývá**.

### Fyzický ukazatel výstupu

`varcAssemblyOutputPointer` odpovídá:

- Na kterou adresu RAM Spectra se má skutečně zapsat další bajt?

Oba ukazatele se obvykle pohybují společně. `ORG` mění oba. `PUT` existuje právě proto, aby se fyzický cíl mohl lišit od logické adresy. `DEFS` může posunout adresní prostor, aniž by zapsal bajty.

Toto oddělení patří k nejdůležitějším myšlenkám assembleru. PROMETHEUS může popsat kód určený pro jednu adresu a současně řídit, kam se jeho bajty skutečně ukládají.

Užitečný mentální obraz je:

```text
čítač logické adresy   → adresa vytištěná na plánu
fyzický ukazatel výstupu → místo, kam stavitel pokládá cihlu
```

Plán a staveniště se většinou shodují. Assembler je přesto vede odděleně, protože některé direktivy zdroje vyžadují, aby tomu tak nebylo.

## Procházení záznamů bez ztráty následujícího

Controller začíná na `sourceBufferAccessLine` a opakovaně porovnává adresu aktuálního záznamu s dynamickým koncem zdroje:

```asm
.processNextAssemblyRecord:
    call comparePositionWithCodeEnd
    jr nc,varcAssemblyPassTransitionCounter
```

Před zpracováním aktuálního záznamu najde a uloží jeho následníka:

```asm
    ld (reportAssemblyErrorAtSourceRecord+1),hl
    push hl
    call getNextSourceRecord
    ld (varcNextAssemblyRecordPointer+1),hl
    pop ix
```

Aktuální záznam je vložen do `IX`, zatímco následník se zapíše do operandu této instrukce:

```asm
varcNextAssemblyRecordPointer:
    ld hl,00000h
```

Proč se následník počítá předem?

Handlery jednotlivých záznamů jsou rozsáhlé. Vyhodnocují výrazy, prohledávají symboly, zkoumají záznamy instrukcí a používají `HL` k mnoha dočasným účelům. Bylo by nepraktické požadovat, aby každý handler uchoval ukazatel záznamu a poté znovu hledal následující záznam proměnné délky.

Controller místo toho říká:

```text
před předáním záznamu složité rutině
si přesně zapamatuj, kde začíná následující záznam
```

Po návratu handleru obnoví následníka jediné opravené `LD HL,nn` a smyčka pokračuje.

Stejný vzor zajišťuje také spolehlivé hlášení chyb. Operand instrukce na `reportAssemblyErrorAtSourceRecord+1` si pamatuje přesný záznam, který se právě zpracovává. Ohlásí-li některá hlubší rutina chybu, PROMETHEUS může editor vrátit na tento řádek, přestože pracovní registry už dávno změnily význam.

## Celý zdroj, nebo vybraný blok

Po přípravě `IX` smyčka uplatní pravidlo rozsahu:

```asm
varcCompileWholeSource:
    ld a,000h
    or a
    jr nz,varcAssemblyPassHandlerCall
    call testSourceRecordOutsideSelectedBlock
    jr c,varcNextAssemblyRecordPointer
```

Režim celého zdroje pokračuje přímo k opravenému volání.

Režim bloku se zeptá, zda aktuální záznam leží mimo inkluzivní vybraný rozsah. Záznamy mimo blok se přeskočí. Záznamy uvnitř se zpracují v obou průchodech.

Sestavení bloku tedy není jiný assembler. Je to filtr obalující běžný handler záznamu:

```text
for each záznam zdroje:
    if wholeSource nebo recordInsideSelectedBlock:
        zpracuj záznam
```

Vybraný blok proto musí dávat smysl jako samostatný celek. Labely mimo něj se během prvního průchodu bloku znovu nedefinují, pokud nezůstaly uzamčené z dřívější vrstvy. Právě proto jsou uzamčené symboly důležité pro samostatně sestavované části.

## Čítač přechodu mezi průchody

Když scan zdroje dorazí na konec, řízení přijde sem:

```asm
varcAssemblyPassTransitionCounter:
    ld a,000h
    dec a
    ld (varcAssemblyPassTransitionCounter+1),a
    ld hl,secondPassEmitSourceRecord
    ld (varcAssemblyPassHandlerCall+1),hl
    jr z,.initializeAssemblyPass
    ret
```

Na začátku sestavení byl immediate operand opraven na `1`.

Po prvním scanu:

```text
1 - 1 = 0
```

Nula se uloží zpět. Handler se změní na rutinu druhého průchodu a `JR Z` spustí cestu od začátku.

Po druhém scanu:

```text
0 - 1 = 255
```

Výsledek není nulový, takže se rutina vrátí.

Čítač je tedy stavem i řízením:

```text
1    první průchod je ještě před námi
0    druhý průchod je ještě před námi
255  oba průchody jsou dokončeny
```

Uvnitř scanovací smyčky není potřeba samostatná větev typu „ve kterém průchodu právě jsem?“.

## Co vidí handler jednoho záznamu

V obou průchodech ukazuje `IX` na dvoubajtovou komprimovanou hlavičku zdroje.

Handler z ní může zjistit:

- zda je záznam prázdný, komentářový, pseudo-operací nebo strojovou instrukcí;
- zda obsahuje label řádku;
- která rodina prefixů patří instrukci;
- jaké tvary operandů následují;
- o kolik se má posunout logická adresa.

Právě proto proběhlo nákladné rozpoznání textu už při zadání řádku. Sestavení znovu neporovnává písmena `L`, `D`, `B` a `,` s tabulkami jazyka. Začíná sémantickým záznamem zdroje, který už obsahuje volbu položky tabulky instrukcí a kompaktní data výrazů.

Celá cesta vypadá takto:

```text
editovatelný text                  hotovo při zadání řádku
    ↓
komprimovaný sémantický záznam     trvalý zdroj
    ↓
handler prvního průchodu           adresy a definice
    ↓
handler druhého průchodu           konečné hodnoty a emitované bajty
```

Editor a assembler nejsou dva programy propojené textovým souborem. Editor ukládá podobu záměrně připravenou pro assembler.

## Strojové instrukce a pseudo-instrukce

Každý záznam patří do jedné ze dvou širokých rodin.

### Strojové instrukce

Příklady:

```asm
LD B,5
DJNZ LOOP
RET
```

Jejich komprimované hlavičky odkazují na jeden z 687 pětibajtových záznamů v `instructionsTable`. Tento záznam nese dostatek metadat, aby PROMETHEUS znal:

- základní opcode;
- rodinu prefixů;
- identitu mnemonic;
- třídy operandů;
- délku instrukce a informace o časování.

První průchod používá informace o délce. Druhý emituje prefixy, opcode a zakódované hodnoty operandů.

### Pseudo-instrukce

Příklady:

```asm
ORG 32768
ENT START
DEFB 1,2,3
DEFM "HELLO"
DEFS 20
DEFW TABLE
```

Neoznačují instrukce Z80, jsou však uloženy ve stejném řetězu zdroje s malými čísly pseudo-opcodů. Jejich chování v jednotlivých průchodech vybírají kompaktní větve místo tabulky strojových instrukcí.

Například:

- `EQU` přiřazuje hodnotu během prvního průchodu;
- `ENT` zaznamenává cíl RUN během druhého průchodu;
- `ORG` mění logický i fyzický ukazatel;
- `DEFB` emituje zkontrolované bajty;
- `DEFS` posouvá ukazatele, aniž by zapisovalo blok bajtů.

Úplné podrobnosti patří do kapitoly 27. V této chvíli stačí vidět, že dvouprůchodový controller zachází s každým řádkem jako se záznamem a nechává zvolený handler rozhodnout, co daný typ záznamu znamená.

## Chyby se rozbalí zpět ke správnému řádku

Rutiny sestavení jsou hluboce vnořené. Chybný výraz může odhalit evaluator volaný emitterem operandu, který volá handler záznamu, jenž byl zavolán controllerem průchodu.

PROMETHEUS nepožaduje, aby každá úroveň vracela pečlivě vrstvený chybový objekt. Společná chybová cesta resetuje zásobník do známého stavu a použije samomodifikovanou adresu aktuálního záznamu připravenou controllerem.

Pojmově:

```text
před záznamem:
    errorRecord = currentRecord

během zpracování:
    if cokoli selže:
        zahoď vnořenou práci
        activeRecord = errorRecord
        zobraz chybové hlášení
        vrať se do editoru
```

Tento styl je rázný, ale pro malý interaktivní nástroj vhodný. Chybu sestavení nelze napravit uvnitř právě probíhajícího průchodu. Užitečným zotavením je vrátit programátora na chybný řádek zdroje a přitom zachovat program i editor.

## Jednořádkový assembler monitoru používá stejný engine

Monitor obsahuje editor pro sestavení jediné instrukce přímo na aktuální adrese monitoru. Neobsahuje druhý malý assembler.

Jeho cesta je v zásadě:

```asm
call firstPassProcessSourceRecord
call initializeMonitorLineAssembler
call secondPassEmitSourceRecord
```

Dočasný záznam zdroje se připraví běžným parserem. Monitor pak na tento jediný záznam použije stejné handlery prvního a druhého průchodu, přičemž logickou adresu a fyzický ukazatel výstupu inicializuje na zvolené místo v paměti.

Toto znovupoužití je cenné ze dvou důvodů:

1. monitor přijímá stejný jazyk instrukcí jako hlavní editor;
2. opravy vyhodnocování výrazů a emise bajtů platí pro obě cesty.

Velký controller celého zdroje není pro jeden řádek potřebný, sémantičtí pracovníci jsou však sdíleni.

## Úplná cesta sestavením

Náš příklad nyní můžeme sledovat se správnou úrovní podrobnosti.

### 1. Uživatel zadá `ASSEMBLY`

Dispatch příkazu zavolá `invokeAssembly`, která zavolá `processCompilation`.

### 2. Připraví se rozsah a symboly

PROMETHEUS rozhodne mezi režimem celého zdroje a bloku. Běžným symbolům se vymažou bity `DEFINED`; uzamčené definice přežijí.

### 3. Začne první průchod

Oba čítače začnou jeden bajt za aktuálním úložištěm zdroje a symbolů. Aktivní řetěz zdroje se scanuje od `sourceBufferAccessLine`.

Pro náš příklad:

```text
ORG 32768       nastav logickou i fyzickou pozici
START LD B,5    definuj START = 32768; posuň o 2
LOOP DJNZ LOOP  definuj LOOP = 32770; posuň o 2
RET             posuň o 1
ENT START       bez délky strojového kódu
```

Na konci prvního průchodu assembler zná potřebné adresy.

### 4. Controller změní osobnost

Opraveným handlerem se stane `secondPassEmitSourceRecord`, čítače se znovu inicializují a scan zdroje začne od začátku.

### 5. Druhý průchod emituje

Assembler vyhodnotí každý konečný operand a vytvoří bajty:

```text
32768: 06 05       LD B,5
32770: 10 FE       DJNZ LOOP
32772: C9          RET
```

`ENT START` uloží 32768 jako vstupní adresu používanou příkazem RUN.

### 6. Úspěch vrátí řízení editoru

Čítač průchodů controlleru podteče, `processCompilation` se vrátí a stavový řádek oznámí `Assembly complete`.

Nic na této cestě nevyžadovalo znovu parsovat viditelný text zdroje. Nic nevyžadovalo vytvoření samostatného mezisouboru. Vstupním jazykem assembleru byl sám řetěz komprimovaného zdroje.

## Proč je tento návrh účinný

Návrh má několik výrazných předností.

### Zdroj se pochopí pouze jednou

Rozpoznání mnemonic a operandů proběhne při přijetí řádku. Opakovaná sestavení znovu používají sémantické záznamy.

### Controller průchodů je malý

Jediná průchozí smyčka obslouží oba průchody prostřednictvím opravovaného handleru.

### Role paměti jsou výslovné

Logická adresa a fyzický cíl se mohou běžně shodovat, ale rozejdou se, když to vyžadují direktivy zdroje.

### Chyby zůstávají interaktivní

Aktuální záznam se zapamatuje před začátkem hlubokého zpracování, takže se editor může vrátit přesně na chybný řádek.

### Hlavní editor a monitor sdílejí pracovní rutiny

Jednořádkové sestavení znovu používá běžný parser a handlery průchodů místo udržování druhé implementace jazyka.

Cenou je, že důležitý stav žije v operandech instrukcí a kompaktních polích záznamů. Čtenář se musí naučit, kde jsou tyto skryté proměnné uloženy. To je nám však už důvěrně známé.

## V prostém pseudokódu

Zde je controller bez detailů Z80:

```text
function assemble(scope):
    wholeSource = scope není BLOCK
    clearDefinedFlagOnUnlockedSymbols()

    handler = firstPass
    transitions = 1

    repeat:
        logicalAddress = codeEnd + 1
        outputPointer = codeEnd + 1
        record = firstEditableSourceRecord

        while record leží před sourceEnd:
            errorRecord = record
            nextRecord = successor(record)

            if wholeSource nebo record leží uvnitř selectedBlock:
                handler(record)

            record = nextRecord

        transitions = transitions - 1
        handler = secondPass

    until transitions není nula
```

Neobvyklá závěrečná podmínka napodobuje původní přechod `1 → 0 → 255`.

## Co se změnilo v paměti

Po úspěšném sestavení celého zdroje:

- definice symbolů obsahují hodnoty z prvního průchodu;
- `varcRunEntryCallTarget` obsahuje adresu `ENT`;
- vygenerované bajty leží na zvolených fyzických adresách výstupu;
- logický i fyzický čítač obsahují své konečné pozice;
- komprimovaný zdroj sám zůstává nezměněn;
- aktivní řádek editoru zůstává k dispozici pro běžnou práci.

Po chybě:

- aktivní řádek se přesune na záznam, jehož adresa byla uložena před zpracováním;
- chybové hlášení určí kategorii;
- částečně emitovaný výstup může v paměti zůstat, protože sestavení není transakční operací nad oblastí generovaného kódu;
- záznamy zdroje zůstanou neporušené.

## Důležité labely, se kterými jsme se setkali

- `invokeAssembly`
- `processCompilation`
- `varcCompileWholeSource`
- `varcAssemblyPassHandlerCall`
- `varcNextAssemblyRecordPointer`
- `varcAssemblyPassTransitionCounter`
- `varcAddressCounter`
- `varcAssemblyOutputPointer`
- `firstPassProcessSourceRecord`
- `secondPassEmitSourceRecord`
- `reportAssemblyErrorAtSourceRecord`
- `testSourceRecordOutsideSelectedBlock`

## Co přijde dál

Tato kapitola zacházela se záznamem zdroje, jako by mu editor už přiřadil správnou identitu mnemonic a operandů.

Příští kapitola otevře právě tento dřívější krok rozpoznání. Uvidíme, jak PROMETHEUS nachází slova jako `LD`, `DJNZ`, `NZ` a `HL`, aniž by ukládal velký běžný slovník, a jak se jeden rozpoznaný řádek porovnává s 687 kompaktními popisy instrukcí.
