# Kapitola 54: Metadata konfiguračních patchů

Náhled instalátoru ukládá zvolené možnosti uvnitř dočasného programu na
`$5000`. Rezidentní payload obsahuje vlastní kopie odpovídajících instrukcí a
barevných konstant. Než se payload přesune, musí instalátor přenést vybrané
hodnoty do těchto vzdálených míst.

Cílů je čtrnáct. Jsou rozesety v monitoru, assembleru, editoru, zobrazení
tabulky symbolů, kódu klávesnice a vykreslování znaků. Některé od sebe dělí
tisíce bajtů; následující cíl může ležet níže i výše než předchozí.

PROMETHEUS je navštěvuje pomocí proudu signed šestnáctibitových delt, který se
dočasně používá jako stack Z80.

Tento mechanismus se liší od relokační tabulky:

- konfigurační patchování zapisuje vybrané **hodnoty a opcodes**;
- relokace později přičítá základ k vybraným **adresním slovům**.

Kdybychom tyto dva mechanismy zaměnili, působil by instalátor mnohem záhadněji,
než ve skutečnosti je.

## Čtrnáct cílů

V pořadí, v němž do nich instalátor zapisuje, je rekonstruovaný zdroj pojmenovává
takto:

| Pořadí | Offset payloadu | Účel |
|---:|---:|---|
| 1 | `$29CE` | opcode transformace znaku na tučné písmo |
| 2 | `$2502` | dvoubajtová instrukce změny velikosti písmen ve zdroji |
| 3 | `$2950` | délka zvuku klávesy |
| 4 | `$0F0C` | normální atribut textu monitoru |
| 5 | `$16A4` | normální atribut tabulky symbolů |
| 6 | `$29BC` | obecný atribut rezidentního textu |
| 7 | `$0ECC` | atribut výplně editoru čelního panelu |
| 8 | `$0EDA` | porovnávací atribut editoru čelního panelu |
| 9 | `$2021` | atribut skrytého editačního řádku |
| 10 | `$2959` | barva borderu při zvuku klávesy |
| 11 | `$1A41` | běžná barva rezidentního borderu |
| 12 | `$1F13` | atribut přístupového řádku při warm startu |
| 13 | `$16A7` | atribut zvýraznění tabulky symbolů |
| 14 | `$0F04` | atribut přístupového řádku monitoru |

Pořadí není seřazeno podle adres. Je zvoleno tak, aby odpovídalo kompaktní
sekvenci zápisů: několik cílů dostává stejnou hodnotu A, takže instalátor může
zapsat, postoupit, znovu zapsat a nemusí nastavení znovu načítat.

## Proč se tabulka nyní generuje

V historickém zdroji bylo čtrnáct delt uloženo jako předem vypočítané bajty. Pro
hotový program s pevným rozložením to bylo rozumné, při rekonstrukci je to však
křehké. Přidání jediné instrukce před některý cíl posune jeho label a bez
varování zneplatní každý pozdější natvrdo zapsaný displacement.

Vzkříšený build označuje každý cíl seřazenou anotací, například:

```asm
configurationPatchTarget03KeypressBeepDuration: equ $+1 ; @config-patch 03
    ld e,01eh
```

Generátor spuštěný při buildu sestaví zdroj, vyřeší offsety labelů a zapíše:

```asm
installerConfigurationPatchDeltas:
include "configurationPatchTable.asm"
```

Vygenerovaný soubor obsahuje čtrnáct little-endian signed slov — celkem dvacet
osm bajtů.

Pro nezměněný program generátor přesně reprodukuje historické bajty. Pro upravený
program následuje labely.

Tento moderní generátor je nástrojem rekonstrukce. Rezidentní dekodér Z80 i
kompaktní formát tabulky zůstávají původním návrhem.

## Offsety místo nainstalovaných adres

Konfigurační cíle jsou vyjádřeny relativně k začátku fyzického payloadu s
originem nula. Nezávisí na požadovaném rezidentním základu.

Po stisku ENTER se HL naplní fyzickým ukazatelem payloadu:

```asm
    pop hl
    push hl
```

První delta posune tento ukazatel k cíli 1. Každá další delta postupuje od
předchozího cíle.

Stejná tabulka proto funguje bez ohledu na to, zda se blok CODE načetl na
`$5DC0`, `$8000` nebo jinou adresu. Všechny cíle se pohybují společně s fyzickým
zdrojem payloadu.

Nejde o relokaci, protože se nepřebázovává žádná adresa uložená *uvnitř*
payloadu. Instalátor pouze hledá bajty ve zdrojovém obrazu dříve, než jej
zkopíruje.

## Sekvence delt

Vygenerovaný report popisuje současnou cestu:

```text
začátek na offsetu payloadu $0000
+10702 -> $29CE
 -1228 -> $2502
 +1102 -> $2950
 -6724 -> $0F0C
 +1944 -> $16A4
 +4888 -> $29BC
 -6896 -> $0ECC
   +14 -> $0EDA
 +4423 -> $2021
 +2360 -> $2959
 -3864 -> $1A41
 +1234 -> $1F13
 -2156 -> $16A7
 -1955 -> $0F04
```

Záporná čísla jsou obyčejná slova v dvojkovém doplňku. Například:

```text
-1228 = $FB34
```

Tabulka ukládá `$34,$FB`, protože slova Z80 jsou little-endian.

Proud delt nemusí nutně zabírat méně datových bajtů než čtrnáct absolutních
šestnáctibitových offsetů. Jeho hlavní výhody jsou zde provozní:

- HL zůstává průběžným ukazatelem cíle;
- původní základ není nutné znovu načítat pro každý cíl;
- jeden malý helper může ze stacku spotřebovat následující cíl;
- posunuté zdrojové labely mohou mechanicky vygenerovat novou cestu;
- pořadí zápisů může sledovat opětovné použití hodnot namísto pořadí adres.

## Nahrazení stacku instalátoru tabulkou

Nejpřekvapivější řádek je:

```asm
    ld sp,installerConfigurationPatchDeltas-installerEntryAt5000+LOADER_ADDRESS
```

Před jeho provedením instalátor zapíše živý soukromý ukazatel stacku do operandu
instrukce:

```asm
    ld (varcInstallerSavedStackPointer+1-installerEntryAt5000+LOADER_ADDRESS),sp
```

Později SP obnoví vykonáním této patchované instrukce:

```asm
varcInstallerSavedStackPointer:
    ld sp,00000h
```

Mezi těmito okamžiky ukazuje SP do bajtů tabulky, které vypadají jako read-only
data, ale používají se jako sekvence slov.

Žádné běžné vnořené volání nesmí tabulku omylem spotřebovat. Helper je pečlivě
napsán tak, aby CALL a RET dokázaly koexistovat s následující deltou.

## Jak se spotřebuje jedna delta

Helper vypadá takto:

```asm
installerAdvancePatchPointer:
    pop bc
    pop de
    add hl,de
    push bc
    ret
```

Předpokládejme, že stack zpočátku obsahuje:

```text
následující delta
další delta
...
```

`CALL installerAdvancePatchPointer` nejprve uloží svou návratovou adresu nad
následující deltu:

```text
návratová adresa
následující delta
další delta
...
```

Uvnitř helperu:

```asm
pop bc
```

odebere a uchová návratovou adresu.

```asm
pop de
```

spotřebuje signed deltu.

```asm
add hl,de
```

posune průběžný ukazatel cíle.

```asm
push bc
ret
```

obnoví návratovou adresu a normálně se vrátí, přičemž SP zůstane na následující
deltě.

V pseudokódu:

```text
function advancePatchPointer():
    savedReturn = popWord()
    delta       = popWord()
    HL          = HL + delta
    pushWord(savedReturn)
    return
```

Tabulka je stack, návratová adresa CALL jej dočasně přeruší a helper toto
přerušení opatrně odstraní.

## Zápis a posun jsou sloučeny

Většina jednobajtových cílů používá:

```asm
installerStoreAAndAdvancePatchPointer:
    ld (hl),a
```

a potom přímo propadne do `installerAdvancePatchPointer`.

Proto:

```asm
call installerStoreAAndAdvancePatchPointer
```

znamená:

```text
zapiš A na současný cíl
spotřebuj následující deltu
posuň HL k následujícímu cíli
```

Poslední cíl se zapíše obyčejným:

```asm
    ld (hl),a
```

protože patnáctá delta neexistuje.

## Patch 1: tučné písmo jako opcode

První posun přemístí HL od začátku payloadu na offset `$29CE`. Instalátor načte
svůj právě zvolený opcode tučného písma:

```asm
    ld a,(varcInstallerBoldTransform)
    call installerStoreAAndAdvancePatchPointer
```

A je buď:

```text
$00 = NOP
$0F = RRCA
```

Tento opcode se zkopíruje do odpovídající instrukce rezidentního vykreslování
znaků. Rezidentní renderer potom vykoná zvolenou politiku, aniž by pro každý
řádek glyphu testoval booleovské nastavení.

Konfigurační patchování tedy dokáže kopírovat kód stejně jako běžná data.

## Patch 2: politika velikosti písmen jako dvoubajtová instrukce

Cíl 2 obdrží úplnou instrukci uloženou ve `varcInstallerCaseTransform`:

```asm
    ld de,(varcInstallerCaseTransform-installerEntryAt5000+LOADER_ADDRESS)
    ld (hl),e
    inc hl
    ld (hl),d
    dec hl
    call installerAdvancePatchPointer
```

Možnosti jsou:

```asm
and 0ffh
or 020h
and 0dfh
```

Každá má dva bajty. Před přičtením další delty se HL vrátí na první bajt,
protože vygenerované delty se měří od označeného cílového labelu, nikoli od bajtu
za vícebajtovým patchem.

Na tomto detailu záleží. Bez `DEC HL` by byl každý pozdější cíl o jeden bajt
výše.

## Patch 3: délka kliknutí klávesnice

Třetí cíl obdrží immediate bajt z:

```asm
varcKeyboardEchoDelay:
    ld e,00ah
```

Náhled instalátoru a rezidentní smyčka klávesnice proto používají stejnou
zvolenou šestibitovou délku.

## Patche 4–6: opakované použití jednoho normálního atributu

A se jednou načte z normálního atributu textu instalátoru:

```asm
    ld a,(varcInstallerTextAttribute+1)
```

Potom jej tři po sobě jdoucí volání zápisu a posunu odešlou do:

1. normálního textu monitoru;
2. normálního textu tabulky symbolů;
3. obecného rezidentního textu.

Pořadí delt bylo zvoleno tak, aby A mohlo zůstat beze změny.

Proto sekvence cílů skáče z `$0F0C` na `$16A4` a potom na `$29BC`, místo aby
sledovala pořadí ve zdroji. Podobu metadat určila úspornost vykonávání.

## Patche 7–8: blízká varianta atributu

Po třetím patchi normálního atributu kód provede:

```asm
    xor 001h
```

a výsledek zapíše do dvou míst editoru čelního panelu.

Změní se pouze bit 0. Přesný vizuální význam vyplývá z rezidentních rutin, které
tyto bajty používají, důležitý princip je však zřejmý: instalátor odvodí blízce
příbuznou variantu, místo aby ukládal a editoval další nezávislou volbu.

Oba cíle jsou od sebe vzdáleny jen čtrnáct bajtů. Odpovídající vygenerovaná delta
je `+14`, nejmenší posun v celé tabulce.

## Patch 9: neviditelný text editačního řádku

Současný atribut se převede pomocí:

```asm
    call attributeCopyPaperColourToInk
```

INK se stane rovným PAPER. Výsledný bajt se zapíše do cíle atributu skrytého
editačního řádku.

Textové pixely se tak zneviditelní, aniž by se ztratilo zvolené pozadí a jas.

## Patche 10–11: barvy borderu

Po patchi 9 kód ponechá pouze tři spodní barevné bity:

```asm
    and 007h
```

Hodnota se zapíše dvakrát:

- jako barva borderu při zvuku klávesy;
- jako běžná barva rezidentního borderu.

Barva PAPER zvolená pro běžný text tak zároveň určuje barvu borderu ULA a bity
borderu používané při vytváření zvuku klávesnice.

Jediná uživatelská volba se soudržně promítne do buněk obrazovky, borderu i
kliknutí.

## Patche 12–14: atributy zvýraznění

Nakonec se A znovu načte z:

```asm
varcInstallerHighlightAttribute:
```

a zapíše se do:

- atributu přístupového řádku při warm startu;
- atributu zvýraznění tabulky symbolů;
- atributu přístupového řádku monitoru.

Instalátor opět načte hodnotu jen jednou a pomocí vygenerované cesty ji rozvede
do tří subsystémů.

## Úplná runtime sekvence

Celou patchovací operaci lze shrnout takto:

```text
HL = physicalPayloadStart
ulož skutečný SP instalátoru
SP = adresa vygenerovaného proudu delt

postup k cíli 1
zapiš zvolený opcode tučného písma
postup k cíli 2
zapiš zvolenou dvoubajtovou instrukci velikosti písmen
postup k cíli 3
zapiš délku kliknutí

postup přes cíle 4..6 a zapisuj normální atribut
mírně změň atribut
postup přes cíle 7..8 a zapisuj variantu čelního panelu
odvoď atribut paper-equals-ink
zapiš cíl 9
vyber tříbitovou barvu
zapiš cíle 10..11
načti zvolený atribut zvýraznění
zapiš cíle 12..14

obnov skutečný SP instalátoru
```

Tabulka delt dodává místa; přímočarý kód instalátoru dodává význam a hodnoty.

## Validace při buildu

Rekonstruovaný generátor nedělá pouze výpočet bajtů. Ověřuje, že:

- všech čtrnáct pořadových čísel existuje právě jednou;
- jejich labely se vyřeší uvnitř relokovatelného payloadu;
- vygenerovaná sekvence cílů se zpětně dekóduje na stejné labely;
- přiložený vygenerovaný výstup není zastaralý;
- nezměněný zdroj přesně reprodukuje historických dvacet osm bajtů.

Testy změn rozložení vkládají a odebírají bajty v obou hlavních oblastech
payloadu a potvrzují, že se konfigurační tabulka mění spolu s labely.

Taková moderní bezpečnostní síť je pro literární rekonstrukci zvlášť vhodná.
Zachovává kompaktní původní runtime techniku, ale odstraňuje starý požadavek, aby
každý dřívější bajt zůstal na své historické adrese.

## Proč nepatchovat až po kopírování?

Bylo by možné obraz nejprve relokovat a zkopírovat, potom najít čtrnáct
rezidentních adres a zapsat do nich nastavení. Každý cíl by však musel být
vyjádřen v konečných nainstalovaných souřadnicích nebo upraven podle úplného či
assembler-only rozložení.

Patchování fyzického zdroje s originem nula jako první je jednodušší:

```text
jeden zdrojový ukazatel
jedna relativní cesta mezi cíli
jedna sada nastavení
potom běžné blokové kopírování
```

V režimu pouze s assemblerem se cíle monitoru patchují, přestože se tyto bajty
nebudou kopírovat. Stojí to několik neškodných zápisů, ale není nutná druhá
podmíněná konfigurační sekvence.

Cíle v příponě, na nichž záleží, dostanou zvolené hodnoty a odcestují spolu s
11 000bajtovou kopií.

## Porovnání konfigurace a relokace

Nyní můžeme oba systémy metadat přesně porovnat.

### Konfigurační tabulka

```text
14 cílů
signed šestnáctibitové delty
použita před kopírováním
ukazuje do fyzického zdrojového payloadu
zapisuje zvolené bajty/opcodes
obsahuje pouze místa nastavitelná instalátorem
```

### Relokační tabulka

```text
1 293 cílů v historickém obrazu
komprimována převážně jako jednobajtové mezery a opakované běhy
použita po kopírování
ukazuje do nainstalovaného cílového obrazu
přičítá k adresním slovům šestnáctibitový základ závislý na instalaci
obsahuje každé relokovatelné interní absolutní slovo
```

Konfigurace odpovídá na otázku:

> Jaké chování a vzhled uživatel zvolil?

Relokace odpovídá:

> Kde nyní tento zkopírovaný program žije?

## Co se změnilo v paměti

Fáze patchování změní čtrnáct označených cílů payloadu:

- jeden opcode tučného písma;
- jednu dvoubajtovou instrukci změny velikosti písmen;
- jeden bajt délky kliknutí;
- několik normálních, odvozených, borderových a zvýrazňovacích atributů.

Dočasně také změní:

- operand `varcInstallerSavedStackPointer`;
- SP, který prochází `installerConfigurationPatchDeltas`;
- HL, který se po fyzickém payloadu pohybuje vpřed i vzad.

Po skončení fáze je soukromý stack instalátoru obnoven a vygenerovaná tabulka
zůstává beze změny.

## Důležité labely, s nimiž jsme se setkali

- `installerConfigurationPatchDeltas`
- `installerAdvancePatchPointer`
- `installerStoreAAndAdvancePatchPointer`
- `varcInstallerSavedStackPointer`
- `varcInstallerBoldTransform`
- `varcInstallerCaseTransform`
- `varcKeyboardEchoDelay`
- `varcInstallerTextAttribute`
- `varcInstallerHighlightAttribute`
- `attributeCopyPaperColourToInk`
- `configurationPatchTarget01CharacterBoldTransform`
- `configurationPatchTarget14MonitorAccessLineAttribute`

## Zpět k celému stroji

Fyzický payload nyní obsahuje uživatelem zvolenou osobnost. Má vybranou tloušťku
písma, způsob práce s velikostí písmen, délku kliknutí a barevné schéma ještě
předtím, než se přesune jediný rezidentní bajt.

Instalátor může zkopírovat kterékoli rozložení s jistotou, že zachované části
nesou správná nastavení.

Kopie však stále obsahuje interní adresy s originem nula. Následující kapitola
vysvětlí větší generovaný systém metadat, který najde 1 293 takových slov a
přebázuje je, aniž by za ukazatele omylem považoval konstanty, volání ROM,
relativní větvení nebo data připomínající opcodes.
