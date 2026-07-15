# Kapitola 2: Cesta jednoho malého programu

Systému se porozumí snáze, když jím sledujeme jednu konkrétní věc. U PROMETHEA je nejužitečnější sledovat zdrojový program.

V celé knize budeme používat tento drobný příklad:

```asm
        ORG 32768
START   LD B,5
LOOP    DJNZ LOOP
        RET
        ENT START
```

Na přesném rozložení mezer na obrazovce zatím nezáleží. Program plní čtyři jednoduché úkoly:

1. řekne assembleru, aby kód umístil na adresu 32768, tedy `$8000`;
2. vloží do registru `B` hodnotu 5;
3. zmenšuje `B` a skáče zpět na `LOOP`, dokud nedosáhne nuly;
4. vrátí se volajícímu.

`ENT START` sděluje PROMETHEU, kterou adresu má zavolat příkaz RUN.

Smyčka je záměrně nezajímavá. Můžeme se tak soustředit na její cestu systémem, nikoli na účel samotného programu.

## Fáze 1: Klávesy neputují přímo do úložiště zdroje

Představme si, že uživatel píše první řádek. PROMETHEUS přečte fyzickou klávesu Spectra, vyhodnotí Caps Shift nebo Symbol Shift, uplatní režim Caps Lock, zpracuje opakování držené klávesy a vrátí jediný normalizovaný kód.

Vnější smyčka editoru opakovaně volá `processKey`:

```asm
.readInputLineLoop:
    call repaintEditLine
    call setBorderColor
    call processKey
    push af
    call printStatusBar
    pop af
```

Normalizovaný znak se vloží do editovatelného vstupního bufferu. V této chvíli je řádek stále blízký obyčejnému textu. Kurzor se v něm může pohybovat, znaky lze vkládat a mazat a jednotlivá pole lze znovu vykreslovat.

Teprve když uživatel řádek potvrdí, pokusí se mu PROMETHEUS porozumět.

U řádku `START LD B,5` musí parser zodpovědět několik otázek:

- Je `START` label?
- Je `LD` známá mnemonika?
- Je `B` operand označující registr?
- Je `5` číselný výraz?
- Odpovídá tato kombinace skutečnému tvaru instrukce Z80?

Pokud odpovědi zapadají do sebe, řádek se zakóduje jako kompaktní záznam zdroje a vloží do trvalé oblasti zdroje.

V pseudokódu:

```text
potvrď editovatelný řádek:
    rozděl řádek na pole labelu, operace a operandů
    rozpoznej operaci
    zpracuj každý operand nebo výraz
    vytvoř kompaktní záznam
    nahraď nebo vlož aktivní záznam zdroje
    znovu vykresli viditelné okno zdroje
```

Podrobnostem tohoto záznamu se bude věnovat několik pozdějších kapitol. Prozatím je důležitá jediná skutečnost: **trvale uložený zdroj už není jen posloupností znaků, které uživatel napsal**.

## Fáze 2: Zdroj začíná dvaceti prázdnými záznamy

Na konci rezidentního obrazu obsahuje PROMETHEUS počáteční oblast zdroje:

```asm
sourceBufferStart:
    defb 0x00, 0x30
    defb 0x00, 0x30
    ; ...twenty empty records in total...
```

Prázdný řádek představují dva bajty `$00,$30`. Takových záznamů je připraveno dvacet, aby mohl editor hned umístit aktivní přístupový řádek mezi platné záznamy nad ním i pod ním.

Jak uživatel zadává skutečné řádky, vkládají se do této oblasti nové záznamy a následující paměť se posouvá. Zdroj proto za běhu PROMETHEA roste, zmenšuje se a mění tvar.

Našich pět viditelných řádků se změní v pět strukturovaných záznamů. Nebudou všechny stejně dlouhé:

- `ORG 32768` potřebuje kód direktivy a zakódovaný výraz;
- `START LD B,5` obsahuje odkaz na label, popis instrukce a konstantu;
- `LOOP DJNZ LOOP` obsahuje definici symbolu i odkaz na něj;
- `RET` je krátký, protože nemá explicitní operand;
- `ENT START` uchovává vstupní výraz používaný příkazem RUN.

Samotné názvy symbolů se spravují odděleně. Záznam tak může odkazovat na kompaktní pořadové číslo symbolu, místo aby při každém použití opakoval celé jeho jméno.

## Fáze 3: Ze jmen se stávají symboly

V příkladu se objevují dva labely:

```text
START
LOOP
```

Během editace a sestavování přidělí PROMETHEUS každému jménu identitu v tabulce symbolů. Záznamy zdroje se pak mohou odkazovat právě na tuto identitu.

Symbol může zpočátku existovat bez konečné hodnoty. `LOOP` se může objevit ve výrazu dříve, než mu první průchod assembleru přiřadí adresu. Tabulka symbolů proto musí uchovávat více než jen jméno a číslo. Sleduje také stavy jako definovaný, nedefinovaný, uzamčený nebo dočasný.

U našeho příkladu první průchod nakonec zjistí:

```text
START = $8000
LOOP  = $8002
```

Proč právě `$8002`? Instrukce `LD B,5` zabírá dva bajty na adresách `$8000` a `$8001`. Další instrukce tedy začíná na `$8002`.

## Fáze 4: První průchod assembleru program změří

Příkaz ASSEMBLY dorazí do `invokeAssembly`:

```asm
invokeAssembly:
    call processCompilation
    ld a,MESSAGE_ASSEMBLY_COMPLETE
    jp prometheusWarmStartWithMessage
```

Skutečná práce probíhá v `processCompilation`. Jeho ústředním trikem je samomodifikované volání. Při prvním průchodu ukazuje na `firstPassProcessSourceRecord`. Před druhým průchodem se přepíše tak, aby volalo `secondPassEmitSourceRecord`.

Okolní řídicí logika vypadá přibližně takto:

```text
připrav symboly pro nové sestavení
vyber handler záznamu pro první průchod

repeat dvakrát:
    obnov logickou adresu a ukazatel výstupu
    projdi záznamy zdroje v pořadí
    call právě vybraný handler pro každý záznam
    nahraď handler prvního průchodu handlerem druhého průchodu
```

Skutečný zdroj obsahuje:

```asm
    ld hl,firstPassProcessSourceRecord
    ld (varcAssemblyPassHandlerCall+1),hl
```

a později:

```asm
    ld hl,secondPassEmitSourceRecord
    ld (varcAssemblyPassHandlerCall+1),hl
```

Bajty operandu instrukce `CALL` zde slouží jako zapisovatelný ukazatel na funkci.

Během prvního průchodu se logické počítadlo adres našeho příkladu mění takto:

| Řádek zdroje | Adresa před řádkem | Účinek |
|---|---:|---|
| `ORG 32768` | dynamická výchozí hodnota | nastav logickou i fyzickou výstupní adresu na `$8000` |
| `START LD B,5` | `$8000` | definuj `START=$8000`; přidej 2 |
| `LOOP DJNZ LOOP` | `$8002` | definuj `LOOP=$8002`; přidej 2 |
| `RET` | `$8004` | přidej 1 |
| `ENT START` | `$8005` | zaznamenej vstupní výraz; nevytvářej žádné bajty instrukce |

Na konci prvního průchodu jsou známy hodnoty všech labelů, které tento program potřebuje.

## Fáze 5: Druhý průchod vytvoří bajty

Druhý průchod prochází tytéž kompaktní záznamy zdroje. Tentokrát vyhodnocuje konečné výrazy a porovnává každou strojovou instrukci s tabulkou instrukcí.

Výsledkem je:

```text
Adresa    Bajty    Zdroj
$8000     06 05    LD B,5
$8002     10 FE    DJNZ LOOP
$8004     C9       RET
```

Zajímavý je bajt `$FE`, tedy posun instrukce `DJNZ`.

Relativní skok neukládá celou cílovou adresu `$8002`. Ukládá znaménkovou vzdálenost od adresy *za* instrukcí skoku. Po načtení instrukce `DJNZ` a jejího posunu by procesor pokračoval na `$8004`.

PROMETHEUS tedy vypočítá:

```text
cíl - následující instrukce
= $8002 - $8004
= -2
= $FE jako osmibitová znaménková hodnota
```

To je jeden z důvodů, proč assembler potřebuje handlery operandů specifické pro jednotlivé druhy instrukcí. Slovní adresa, okamžitá bajtová hodnota, indexový posun i relativní větev mohou všechny začínat jako výrazy, ale každý z nich se kóduje jinak.

Ukazatel výstupu se posouvá s každým zapsaným bajtem. PROMETHEUS zároveň kontroluje, zda vytvářený program nenarazí do chráněné rezidentní oblasti se zdrojem a symboly a zda nepřekročí nastavenou horní hranici paměti.

## Fáze 6: RUN použije vstup zvolený direktivou ENT

Direktiva `ENT START` nevytváří žádnou instrukci Z80. Ve druhém průchodu vyhodnotí výraz `START` a opraví cíl volání používaného příkazem RUN.

Příslušná část zdroje má podobu:

```asm
varcRunEntryCallTarget:
    call 00000h
```

Po sestavení obsahuje operand adresu `$8000`. RUN vymaže obrazovku editoru a vykoná opravené volání.

Pojmově:

```text
RUN:
    sestav zdroj
    vyžaduj právě jednu direktivu ENT
    vymaž obrazovku
    call adresu vybranou direktivou ENT
    po návratu programu čekej na klávesu
    vrať se do editoru
```

Náš ukázkový program se vrátí normálně. Změní registr `B`, ale nepřevezme Spectrum natrvalo pod svou kontrolu.

## Fáze 7: Monitor dokáže bajty znovu přečíst

Představme si nyní, že vstoupíme do monitoru a pro disassemblování vybereme adresu `$8000`.

Disassembler začíná v `disassembleNextLineToBuffer`. U běžné nechráněné adresy zavolá dekodér instrukcí:

```asm
    call decodeInstructionAtHL
```

Pokud nalezne odpovídající tvar instrukce, vrátí dekodér kanonický popis operace a operandů. PROMETHEUS poté vytvoří dočasný kompaktní záznam zdroje a předá jej obvyklému expanderu zdroje.

Výsledkem je text odpovídající:

```asm
        LD B,5
        DJNZ $8002
        RET
```

Je-li povoleno vyhledávání symbolů a lze podle hodnoty najít `LOOP`, může se větev zobrazit se jménem symbolu místo číselné adresy.

Jde o mimořádně elegantní propojení:

```text
strojové bajty
    ↓
dekodér instrukce
    ↓
dočasný komprimovaný záznam zdroje
    ↓
běžný expander řádku zdroje
    ↓
text monitoru nebo zdroj vložený do editoru
```

Disassembler nepotřebuje druhý úplný formátovač syntaxe assembleru.

## Fáze 8: Monitor může opatrně vykonat jedinou instrukci

Běžný RUN předá programu řízení a čeká, až se vrátí. Monitor dokáže provést něco jemnějšího: vykonat jedinou instrukci a přitom zachovat uložený obraz stavu uživatelova procesoru.

U `LD B,5` není zapotřebí mnoho zvláštního zacházení. U `DJNZ LOOP` musí monitor rozhodnout, zda se větev provede, zachovat ostatní registry a po instrukci znovu získat řízení.

Pozdější kapitoly ukážou, jak PROMETHEUS sestaví malou pomocnou sekvenci, obnoví uživatelovy registry, vybranou instrukci vykoná nebo přetvoří, zachytí výsledek a znovu vykreslí čelní panel.

Prozatím můžeme cestu prodloužit:

```text
řádek zdroje
    → kompaktní záznam
    → hodnoty symbolů
    → strojové bajty
    → dekódovaná instrukce
    → řízené vykonání
    → aktualizované zobrazení registrů
```

## Celá cesta v jediném pohledu

```text
1. Fyzické klávesy
        ↓ processKey
2. Editovatelný vstupní buffer
        ↓ parser a encoder
3. Komprimované záznamy zdroje
        ↓ první průchod
4. Adresy a hodnoty symbolů
        ↓ druhý průchod
5. Bajty strojového kódu
        ↓ RUN nebo monitor
6. Běžící program / zkoumaná paměť
        ↓ disassembler
7. Dočasný záznam zdroje
        ↓ expander zdroje
8. Čitelný text assembleru
```

Právě proto nelze PROMETHEUS chápat jako tři nesouvisející programy. Editor, assembler a monitor neustále převádějí mezi několika reprezentacemi téhož programu.

## Co se změnilo v paměti?

Po zadání a sestavení příkladu:

- pět smysluplných záznamů zdroje nahradilo část počátečních prázdných záznamů;
- dynamická oblast zdroje se zvětšila;
- tabulka symbolů obsahuje nejméně `START` a `LOOP` s konečnými hodnotami;
- značka konce chráněného kódu se posunula tak, aby zahrnula zvětšený zdroj a symboly;
- od adresy `$8000` byly vytvořeny bajty `$06,$05,$10,$FE,$C9`;
- po zpracování `ENT START` obsahuje operand volání RUN adresu `$8000`;
- monitor může vytvořený program zkoumat, aniž by změnil uložený zdroj.

## Uvedené orientační labely zdroje

- `processKey`
- `sourceBufferStart`
- `processCompilation`
- `firstPassProcessSourceRecord`
- `secondPassEmitSourceRecord`
- `varcAssemblyPassHandlerCall`
- `invokeAssembly`
- `varcRunEntryCallTarget`
- `disassembleNextLineToBuffer`
- `decodeInstructionAtHL`
