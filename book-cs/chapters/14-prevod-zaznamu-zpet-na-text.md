# Kapitola 14: Převod záznamu zpět na text

PROMETHEUS nikdy nepovažuje pixely zdrojového okna za program. Skutečným programem je řetězec komprimovaných záznamů v paměti.

Kdykoli je třeba řádek zobrazit, editovat, vytisknout, prohledat jako text nebo převést do jiné podoby, PROMETHEUS z jednoho záznamu zrekonstruuje čitelný řádek.

Tento zpětný převod není pouhou dekompresí v obvyklém smyslu. Záznam neobsahuje všechny viditelné znaky. Expander musí spojit informace z několika míst:

```text
záznam zdroje
tabulka instrukcí
tabulka řetězců mnemonic
tabulka řetězců operandů
tabulka symbolů
pravidla šířky polí editoru
aktuální volba velikosti písmen zdroje
hranice vybraného bloku
```

Teprve společně vytvoří známý assemblerový řádek.

## Celá cesta ven

Hlavní rutinou je `expandSourceRecordToLineBuffer`.

Na nejvyšší úrovni:

```text
vyčisti 32bajtový lineBuffer

if záznam je komentář:
    zkopíruj text komentáře
else:
    zrekonstruuj volitelné pole labelu
    dekóduj metadata opcodu a prefixu
    zrekonstruuj pole mnemonic
    zrekonstruuj první operand
    if existuje druhý operand:
        připoj čárku
        zrekonstruuj druhý operand

vlož soukromé značky polí
zakonči řádek
```

Tím vznikne neutrální řádek editoru. Druhá fáze, `printExpandedSourceLineWithRoutine`, jej prochází a posílá znaky cíli zvolenému volajícím.

Samotné rozbalování proto neví, zda výsledek míří:

- na obrazovku Spectra;
- na tiskárnu;
- do porovnávací rutiny FIND;
- do builderu REPLACE;
- k jinému konzumentovi textu.

Všem slouží stejná sémantická rekonstrukce.

## Cíl se nejprve vyčistí

Výchozí vstup vybere `lineBuffer`:

```asm
expandSourceRecordToLineBuffer:
    ld hl,lineBuffer
expandSourceRecordToHL:
    push hl
    ld bc,02000h
    call atHLrepeatBTimesC
    pop hl
```

`BC=$2000` je kompaktní volací konvence pro:

```text
B = 32 bajtů
C = nulový výplňový bajt
```

Před zápisem kteréhokoli pole je tedy buffer čistým, 32bajtovým, nulou zakončeným pracovním prostorem.

Vedlejší vstup `expandSourceRecordToHL` dovoluje jinému volajícímu dodat jiný cíl a přitom znovu použít tentýž algoritmus.

## Komentáře jsou téměř doslovné

Záznam komentáře se rozpozná přesnou dvoubajtovou identitou:

```text
opcode       $01
information  $37
```

Expander potom kopíruje bajty od offsetu záznamu `+2`, dokud nenarazí na hodnotu v koncovém rozsahu `$C0`–`$FF`.

Před každým testem předem zapíše `$01` na aktuální výstupní pozici:

```asm
.expandCommentRecordLoop:
    ld a,(ix+002h)
    cp 0c0h
    ld (hl),001h
    ret nc
    inc ix
    ld (hl),a
    inc hl
    jr .expandCommentRecordLoop
```

Konečné `$01` se stane značkou kurzoru či pole editovaného řádku použitou při otevření řádku k editaci.

Tabulka mnemonic ani symbolů se nekonzultuje. Próza byla uložena doslova, takže ji lze doslova také vrátit.

## Strukturované řádky začínají devítiznakovým polem labelu

U obyčejného záznamu zdroje připraví expander pole `LABEL_LENGTH`, tedy devět znaků.

Je-li bit 3 informačního bajtu nulový, jednoduše toto pole vyplní mezerami.

Je-li bit nastaven, první dva proměnlivé bajty tvoří pořadové číslo symbolu. Expander zavolá `resolveRecordLabelAfterHeader`, která nakonec dorazí do `resolveSymbolReferenceToName`.

Tento resolver provede několik úrovní nepřímosti:

```text
pořadové číslo ze záznamu zdroje
    → dvoubajtový vektor v tabulce symbolů
    → offset položky hodnoty a názvu
    → zápis symbolu zakončený vysokým bitem
```

Bajty záznamu záměrně **neinterpretuje** jako adresu. Uložení zdroje i symbolů se může přesouvat; pořadové číslo zůstává stabilní.

Zápis se zkopíruje zarovnaný doleva a zbytek devítiznakového pole se doplní mezerami.

Pojmově:

```text
název symbolu "LOOP"
šířka pole 9
výsledek "LOOP     "
```

Přesahuje-li zápis dostupné pole, sdílená kopírovací rutina nahlásí chybu zdroje místo přepsání následujícího pole.

## Záznam neukládá zápis mnemonic

Po poli labelu zná expander jen:

- bajt opcodu z offsetu záznamu 0;
- nibble rodiny prefixu z offsetu záznamu 1.

Musí znovu najít záznam tabulky instrukcí, který je původně vytvořil.

`decodeInstructionTableRecord` prohledá seřazená metadata instrukcí a vrátí:

- index tabulky mnemonic v `A`;
- deskriptor prvního operandu v `D`;
- deskriptor druhého operandu v `E`.

Vyhledávání používá uspořádaný postup s půlením kroku, nikoli lineární průchod. Začne velkým posunem zarovnaným na záznam, porovná opcode a normalizovanou rodinu prefixu a opakovaně zmenšuje vyhledávací okno na polovinu.

V hrubém pseudokódu:

```text
key = (opcode, normalizedPrefixFamily)
position = střed seřazené tabulky instrukcí
stride = počáteční krok poloviny tabulky

repeat omezený počet pokusů:
    if table[position].key == key:
        rozbal mnemonic a operandy
        return úspěch

    if table[position].key < key:
        position += stride
    else:
        position -= stride

    stride = další menší krok zarovnaný na záznam

return chyba poškozeného záznamu
```

Je to obrácená podoba vyhledávání při zadávání zdroje z kapitoly 13. Tam parser znal mnemonic a třídy operandů a hledal záznam instrukce. Zde expander zná opcode a metadata prefixu a obnovuje deskriptory mnemonic a operandů.

## DD a FD se při hledání normalizují

Instrukce IX a IY sdílejí tabulkové záznamy. Říká-li informační bajt zdroje FD, decoder jej dočasně převede na společný klíč rodiny DD a zaznamená, kterou textovou variantu bude později třeba obnovit.

Po rozbalení deskriptorů operandů podle potřeby upraví deskriptory ve tvaru IX na jejich zápis IY.

Výsledkem je stejný normalizační vzor jako při kódování, jen v opačném směru:

```text
uložená rodina FD
    → hledej společná indexová metadata
    → vrať deskriptory operandů ve variantě IY
```

Tabulka zůstává kompaktní a rekonstruovaný text věrně zachová uživatelem zvolený registr.

## Poškozená metadata se projeví jako chyba zdroje

Pokud žádný záznam tabulky instrukcí neodpovídá uloženému opcodu a rodině prefixu, `expandSourceRecordToLineBuffer` nehádá. Nastaví stav chyby zdroje pro následující překreslení editoru a vrátí se.

Je to důležité, protože komprimovaný zdroj je strukturovanou databází. Zbloudilý bajt v ní může vytvořit kombinaci, která nikdy nevzešla z encoderu.

PROMETHEUS kontroluje integritu vlastního interního jazyka v okamžiku, kdy tento jazyk interpretuje.

## Soukromá značka odděluje pole zdroje

Po dekódování metadat instrukce zapíše expander před pole mnemonic `$01`:

```asm
.appendExpandedMnemonic:
    ld (hl),001h
```

Další `$01` zapíše později před operandy.

Tyto bajty se nezobrazují jako znaky. Scanneru editovatelného řádku a výstupu zdroje slouží jako neviditelné strukturální značky.

Rekonstruovaný buffer proto připomíná:

```text
text labelu a výplň
$01
text mnemonic a výplň
$01
text operandů
$00...
```

Editor může umístit pohyblivý kurzor na smysluplnou hranici pole, aniž by tyto hranice ukládal do trvalého zdroje.

## Text mnemonic pochází ze zabalené tabulky

Dekódovaný index mnemonic vybere zápis prostřednictvím `mnemonicsReferences` a `getStringFromTableDE`.

Referenční vektor používá jednobajtové self-relative displacementy zavedené v kapitole 6. `getStringFromTableDE` vypočítá:

```text
tableBase + index + table[index]
```

a vrátí ukazatel na zápis zakončený vysokým bitem.

Mnemonic se zkopíruje do pětiznakového pole a doplní mezerami.

Definiční pseudo-záznamy potřebují malou úpravu indexu, aby se `$06` až `$09` namapovaly zpět na sdílené zápisy `DEFB`, `DEFM`, `DEFS` a `DEFW`.

Viditelné slovo opět není uloženo v záznamu zdroje. Rekonstruuje se z kompaktní sémantické identity.

## Pevné operandy jsou slovy tabulky

`expandOperandByDescriptor` dostane jeden deskriptor operandu v `A`.

Hodnoty menší než `$2C` odkazují na pevné zápisy operandů:

```text
A
BC
HL
NZ
(BC)
IX
...
```

Rutina vyřeší deskriptor přes `operandsReferences` a zkopíruje zabalený řetězec do výstupního řádku.

Jde o nejlevnější druh rekonstrukce operandu:

```text
deskriptor  →  známý zápis
```

Z proměnlivého payloadu výrazu se nemusí spotřebovat žádný bajt.

## Výrazové operandy spojují šablony a uložené bajty

Deskriptory `$2C` a vyšší říkají, že následuje proměnlivý výrazový materiál.

Deskriptor určuje vnější textovou šablonu:

```text
$2C    výraz
$2D    (výraz)
$2E    (ix+displacement)
$2F    (iy+displacement)
```

Expander zapíše znaky vyplývající z deskriptoru:

- úvodní závorku, kde je potřeba;
- `ix` nebo `iy` u indexových forem;
- plus před nezáporným indexovým displacementem;
- koncovou závorku.

Ze záznamu se čte pouze proměnlivá část.

Například záznam pro:

```asm
        LD A,(IX+TABLE-2)
```

nemusí ukládat znaky `(`, `i`, `x`, `+` ani `)`. Jsou důsledkem deskriptoru operandu. Ukládá pouze zakódovaný výraz pro `TABLE-2`.

To je sémantická komprese ve své nejčistší podobě.

## Proč může rozbalování doplnit znak plus

U indexového displacementu může výraz záznamu začínat `-`. Pokud ano, expander jej nechá beze změny:

```text
(ix-3)
```

Nezačíná-li minusem, viditelná syntaxe vyžaduje výslovné plus:

```text
(ix+3)
```

Plus se tedy generuje, nikoli ukládá.

Přímý výraz jako `LABEL+2` si své vnitřní plus zachová, protože tento operátor patří do samotného výrazu. Rozdíl je mezi:

```text
plusem vyplývajícím ze šablony indexové adresy
plusem napsaným jako operátor výrazu
```

## Doslovné bajty výrazu se kopírují přímo

Uvnitř `.expandEncodedExpressionLoop` jsou bajty menší než `$80` obyčejnými znaky výrazu.

Kopírují se, dokud se neobjeví jedna ze dvou strukturálních hranic:

- `$1F`, oddělující dva strojové operandy nesoucí výrazy;
- `$C0` nebo vyšší, ukončující proměnlivý záznam.

Mezi příklady kopírovaných bajtů patří:

```text
0 1 2 # % + - * / ? " '
```

Trvalý výraz byl záměrně ponechán dost blízko zdrojovému textu, aby rekonstrukce zůstala jednoduchá.

## Odkazy na symboly se znovu mění na názvy

Bajty `$80` až `$BF` uvádějí dvoubajtové pořadové číslo. Expander:

1. přečte označený horní a dolní bajt;
2. vyřeší pořadové číslo přes aktuální tabulku symbolů;
3. zkopíruje název zakončený vysokým bitem do výstupního řádku;
4. pokračuje ve scanování zakódovaného výrazu.

Dva trvalé bajty se tak mohou rozbalit do mnohem delšího zápisu:

```text
$80,$25  →  LOOP_COUNTER
```

Proto musí rozbalování konzultovat živé uložení symbolů. Záznam zdroje zná identitu; tabulka symbolů zná prezentaci a aktuální hodnotu.

## Dva operandy oddělují metadata, nikoli uložený text čárky

Po rozbalení prvního operandu rutina zkontroluje druhý deskriptor vrácený z tabulky instrukcí.

Je-li nulový, řádek je hotov.

Je-li nenulový, expander zapíše viditelnou čárku a rozbalí druhý operand.

Interní bajt `$1F` zastaví první zakódovaný výraz na správném místě. Viditelná čárka pochází ze skutečnosti, že instrukce má dva operandy.

Toto uspořádání neukládá čárku, kterou už metadata sama určují.

## Definiční seznamy jsou řízenou výjimkou

Definiční záznamy mohou obsahovat libovolně dlouhý seznam výrazů:

```asm
        DEFB 1,2,3,4
```

Metadata instrukce nemohou vědět, kolik položek se vyskytuje. Jejich čárky jsou proto přítomny jako obyčejné bajty payloadu a při rozbalování výrazu se kopírují.

`DEFM` podobně obsahuje doslovné znaky řetězce, které musí být reprodukovány.

Jeden vnější formát záznamu může obsahovat několik malých vnitřních jazyků. Pseudo-opcode říká expanderu, jakou interpretaci použít.

## Neutrální řádek ještě není konečným zobrazením

Po rozbalení obsahuje `lineBuffer` čitelný nulou zakončený řádek se soukromými značkami polí `$01`.

`renderSourceRecord` doplní kontext zobrazení.

Nejprve zjistí, zda záznam leží uvnitř právě vybraného bloku. Pokud ano, zapíše bajt značky `$03` na `lineBufferMarkerPosition`.

Tato značka se má vykreslit plně vyplněným glyfem ROM a vytvořit viditelné označení výběru bloku. Samotný rekonstruovaný záznam zdroje se nemění.

Potom `renderSourceRecord` vybere jako výstupní callback `displayCharacterSafely` a vstoupí do `printExpandedSourceLineWithRoutine`.

## Jeden scanner zdroje slouží mnoha cílům

`printExpandedSourceLineWithRoutine` patchuje toto volání:

```asm
varcExpandedSourceCharacterRendererCall:
    call displayCharacterSafely
```

Volající může cíl nahradit jinou rutinou. Samotný scanner potom:

- přeskakuje značky polí `$01`;
- zastaví se na nule;
- sleduje, zda se nachází uvnitř dvojitých uvozovek;
- používá nastavený převod velikosti písmen zdroje pouze mimo uvozovky;
- posílá každý výsledný znak vybranému callbacku.

V pseudokódu:

```text
for each byte in lineBuffer:
    if byte == $01:
        continue
    if byte == $00:
        stop

    if byte == '"':
        přepni quotedState

    if mimo uvozovky and převod velikosti písmen je zapnutý:
        převeď písmeno

    outputCallback(byte)
```

Jde o miniaturní stream processor. Rozbalování stanoví význam; scanner aplikuje výstupní politiku.

## Převod velikosti písmen nesmí změnit data řetězce

PROMETHEUS může zobrazovat zdroj ve zvolené velikosti písmen. Nesmí však změnit:

```asm
        DEFM "Hello"
```

na jiný řetězec jen proto, že zobrazení zdroje je nastaveno na velká nebo malá písmena.

Scanner proto při každém `"` přepne bit stavu uvozovek. Písmena uvnitř citovaného textu převod velikosti obcházejí.

Volba velikosti písmen mění prezentaci, nikoli význam zdroje.

Toto rozlišení je zvlášť důležité, protože rozbalené řádky znovu používají PRINT, FIND i další nástroje. Předvolba zobrazení se nesmí stát mechanismem poškození dat.

## Výstupní callback je mocnější, než se zprvu zdá

Náhradou jediného operandu `CALL` může PROMETHEUS znovu použít stejný průchod řádkem k několika účelům.

Pojmově:

```text
jednou rozbal záznam
jednou projdi rekonstruovaný text

callback = renderer znaku na obrazovku
    → zobraz zdroj

callback = rutina znaku tiskárny
    → vytiskni zdroj

callback = porovnávací rutina
    → hledej ve zdrojovém textu

callback = builder náhrady
    → vytvoř transformovaný řádek
```

Callback dostává normalizovanou posloupnost, z níž zmizely soukromé značky polí a kde se podle potřeby už použila politika velikosti písmen zdroje.

Je to jedno z nejelegantnějších použití samomodifikujícího kódu v programu. Patchované volání není nekontrolovaným trikem; je drobným konfigurovatelným rozhraním.

## Sledujme `LOOP DJNZ LOOP` zpět ven

Obraťme záznam vytvořený v kapitole 13.

Pojmově obsahuje:

```text
opcode $10
information: label přítomen + třída relativního výrazu
pořadové číslo labelu řádku 37
pořadové číslo výrazu operandu 37
koncová značka $C4
```

### 1. Vyčištění bufferu řádku

Třicet dva nulových bajtů poskytne čistý cíl.

### 2. Rozbalení labelu

Bit 3 informačního bajtu je nastaven. Pořadové číslo 37 se přes tabulku symbolů vyřeší na `LOOP`. Výsledek se doplní na devět znaků:

```text
LOOP
```

### 3. Dekódování metadat instrukce

Opcode `$10` a jeho rodina prefixu vyhledají záznam instrukce `DJNZ`. Decoder vrátí:

```text
index mnemonic: DJNZ
první operand: relativní výraz
druhý operand: žádný
```

### 4. Připojení značky pole a mnemonic

Tabulka mnemonic dodá `djnz`, doplněné na pět znaků.

Neutrální buffer nyní připomíná:

```text
LOOP     $01djnz $01
```

kde `$01` představuje neviditelnou značku pole.

### 5. Rozbalení operandu

Deskriptor relativního výrazu nevyžaduje závorky. Označené pořadové číslo 37 se znovu vyřeší na `LOOP` a zkopíruje.

### 6. Použití výstupní politiky

Scanner zobrazení přeskočí značky a podle instalační konfigurace může převést písmena zdroje na velká.

Uživatel uvidí:

```asm
LOOP     DJNZ LOOP
```

Zápis byl znovu vytvořen z identity a tabulek. Nebyl uchován jako jeden původní textový řetězec.

## Otevření rekonstruovaného řádku k editaci

Stejná cesta rozbalování se používá, když EDIT přenese aktivní záznam zdroje do spodního editačního řádku.

Značky `$01` jsou zde užitečné. Poskytují přirozené pozice polí a jedna z nich může sloužit jako pohyblivá značka kurzoru, které rozumí `updateInputBuffer`.

Cesta záznamu na text tedy řádek pouze netiskne. Konstruuje další editovatelnou reprezentaci.

Celý okruh je:

```text
trvalý sémantický záznam
    → neutrální editovatelný řádek
    → uživatel změní znaky
    → parser vytvoří nový sémantický záznam
```

Obrazovka je jen pohledem mezi těmito dvěma strukturovanými stavy.

## Které informace se záměrně nereprodukují přesně?

PROMETHEUS zachovává význam zdroje programu, ale neslibuje, že si zapamatuje každou kosmetickou volbu zadaného řádku.

Rekonstruuje:

- pevné šířky polí labelu a mnemonic;
- normalizované zápisy mnemonic a operandů;
- nakonfigurovanou velikost písmen zdroje;
- standardní interpunkci vyplývající z deskriptorů operandů.

Nemusí zachovat:

- libovolné mezery navíc;
- původní velikost písmen mimo uvozovky;
- redundantní unární plus zahozené encoderem výrazu;
- malá šestnáctková písmena, která byla kanonizována;
- ručně zvolené zarovnání přesahující pole editoru.

Nejde o náhodnou ztrátu. Komprimovaný formát zdroje ukládá kanonickou podobu vhodnou pro malý integrovaný assembler.

## Rozpoznání poškozeného záznamu zdroje

Rozbalování chrání několik kontrol:

- metadata opcodu a prefixu musí dekódovat na záznam tabulky;
- pořadová čísla symbolů se musí vyřešit přes aktuální strukturu tabulky;
- pevná slova se musí vejít do výstupního pole;
- scanning výrazu musí narazit na platné strukturální hranice;
- výstup musí zůstat uvnitř malého bufferu řádku.

PROMETHEUS nemůže nabídnout moderní ochranu paměti, ale opakovaně kontroluje invarianty svých kompaktních datových jazyků.

Chyba `Source` znamená, že interní reprezentace už těmto invariantům neodpovídá, nikoli jen to, že uživatel napsal chybný řádek. Syntaktické chyby při zadání měly být odmítnuty ještě před uložením záznamu.

## Zpět k celému stroji

Expander ukazuje, proč je komprimovaný zdroj PROMETHEA nejen malý, ale také užitečný.

Záznam ukládá dostatek sémantických informací pro dva opačné konzumenty:

```text
assembler:
    chce rodinu opcodu, třídu operandu a zakódované výrazy

editor:
    chce label, mnemonic a čitelný text operandů
```

Tabulky instrukcí a symbolů propojují oba pohledy.

Stejný zdrojový řádek proto může opakovaně procházet tímto cyklem:

```text
záznam
  → text na obrazovce
  → editovaný text
  → nový záznam
  → průchody sestavení
  → strojový kód
```

Žádná fáze nepotřebuje původní syrovou posloupnost stisknutých kláves.

## Co se změnilo v paměti?

Během neutrálního rozbalování:

- `lineBuffer` se vyčistí a naplní rekonstruovaným textem;
- značky `$01` označují hranice polí;
- `IX` postupuje proměnlivým materiálem záznamu;
- paměť tabulky symbolů se čte, ale nemění;
- `varcIndexRegisterVariantOffset` během dekódování zaznamenává volbu textu IX/IY.

Během kontextového renderování:

- `lineBufferMarkerPosition` může dostat `$03` pro výběr bloku;
- `varcExpandedSourceCharacterRendererCall` dostane zvolený callback;
- stav uvozovek se dočasně drží v `C`;
- obrazovka, tiskárna nebo jiný cíl přijímá znaky;
- trvalý komprimovaný zdroj zůstává beze změny.

Při nalezení poškozených metadat:

- `varcLastStatusBarMessage` se nastaví na hlášení chyby zdroje;
- editor později zobrazí diagnostiku.

## Důležité myšlenky pro další kapitoly

- rozbalování spojuje zdroj, tabulku instrukcí, mnemonic, operandů a symbolů;
- komentáře používají rychlou doslovnou cestu;
- labely se řeší z pořadových čísel a doplňují na devět sloupců;
- opcode spolu s rodinou prefixu obnoví deskriptory mnemonic a operandů;
- metadata IX/IY se pro hledání normalizují a pro text znovu obnoví;
- značky `$01` dělí rekonstruovaná pole, ale nezobrazují se;
- pevné operandy pocházejí ze zabalených tabulek řetězců;
- výrazové šablony generují závorky, názvy indexových registrů a část interpunkce;
- pořadová čísla symbolů se rozbalují na aktuální zápisy symbolů;
- `$1F` odděluje dva zakódované výrazové operandy;
- značení vybraného bloku patří k pohledu, nikoli k záznamu;
- jeden patchovaný výstupní callback umožňuje obrazovce, tiskárně, hledání i nahrazování sdílet tentýž scanner;
- uvnitř citovaného textu se potlačuje převod velikosti písmen;
- výsledkem je kanonický zdroj, nikoli přesné zopakování původních mezer a velikosti písmen.

## Vysvětlené orientační body ve zdroji

- `expandSourceRecordToLineBuffer`
- `expandSourceRecordToHL`
- `.expandCommentRecordLoop`
- `.expandStructuredSourceRecord`
- `resolveRecordLabelAfterHeader`
- `resolveSymbolReferenceToName`
- `decodeInstructionTableRecord`
- `varcIndexRegisterVariantOffset`
- `.appendExpandedMnemonic`
- `mnemonicsReferences`
- `operandsReferences`
- `getStringFromTableDE`
- `printFromDEtoHLpaddedLeft`
- `fillHLWithBSpaces`
- `expandOperandByDescriptor`
- `.expandExpressionOperand`
- `.expandEncodedExpressionLoop`
- `.expandEncodedSymbolReference`
- `.finishExpressionOperand`
- `copyResolvedSymbolNameToLine`
- `renderSourceRecord`
- `testSourceRecordOutsideSelectedBlock` na úrovni zobrazení
- `lineBuffer`
- `lineBufferMarkerPosition`
- `printExpandedSourceLineWithRoutine`
- `varcExpandedSourceCharacterRendererCall`
- `configurationPatchTarget02SourceCaseTransform`
- `displayCharacterSafely` na úrovni výstupu zdroje
