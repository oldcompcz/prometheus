# Kapitola 37: Hledání a změny bloků

Monitor paměti je nejužitečnější tehdy, když dokáže víc než jen hledět na jednu
adresu. Dříve nebo později začne uživatel klást větší otázky:

- Kde se vyskytuje tato posloupnost bajtů?
- Mohu celou tuto rutinu zkopírovat jinam?
- Mohu vymazat nebo inicializovat celou oblast?
- Co se stane, když se zdroj a cíl překrývají?
- Jak PROMETHEUS zabrání takovým příkazům zasáhnout vlastní rezidentní obraz?

PROMETHEUS na tyto otázky odpovídá třemi kompaktními nástroji:

1. pětibajtovým hledáním s maskou;
2. přesunem bloku bezpečným při překryvu;
3. vyplněním bloku zadanou hodnotou bajtu.

Jsou záměrně malé. Neexistuje tu obecný engine regulárních výrazů ani
propracovaný objekt mapy paměti. Hledaný vzor má přesně pět pozic. Blokové
příkazy pracují s inkluzivními šestnáctibitovými rozsahy. Expressiony se čtou
stejným vstupním mechanismem monitoru, který už slouží adresám a registrům.

Tato jednoduchost není slabinou. Na 48K Spectru znamená, že je každý příkaz
předvídatelný, rychlý a dost malý, aby mohl bydlet vedle editoru, assembleru a
traceru.

## Dva druhy hledání v jediné aplikaci

Editor má příkaz FIND popsaný v kapitole 17. Hledá v rozvinutém zdrojovém textu.
Příkaz G monitoru je jiný tvor. Hledá přímo v bajtech paměti.

Na rozdílu záleží:

```text
editor FIND:
    komprimovaný záznam zdroje
        -> rozvinutý zdrojový text
        -> porovnávání znaků

monitor G:
    adresa paměti
        -> pět syrových bajtů
        -> maskované porovnávání bajtů
```

Monitoru je jedno, zda je bajt opcode, znak textu, číslo, atribut obrazovky nebo
část tabulky. Vidí pouze hodnoty od `$00` do `$FF`.

## Vzor o pěti pozicích

Pracovní prostor `monitorFindByteMaskPairs` rezervuje deset bajtů:

```asm
monitorFindByteMaskPairs:
    defs 10
```

Těchto deset bajtů se interpretuje jako pět sousedních dvojic:

```text
(hodnota 1, maska 1)
(hodnota 2, maska 2)
(hodnota 3, maska 3)
(hodnota 4, maska 4)
(hodnota 5, maska 5)
```

Každou pozici vzoru tedy představují dva bajty místo jednoho. První říká, jaká
hodnota se požaduje. Druhý určuje, které bity této hodnoty jsou významné.

PROMETHEUS v současnosti vytváří jen dva druhy masek:

```text
běžný expression   maska = $FF   záleží na všech osmi bitech
dvojtečka `:`      maska = $00   nezáleží na žádném bitu
```

Dvojtečka je wildcard.

Předpokládejme, že uživatel zadá:

```text
$3E : $CD : $C9
```

Výsledný vzor vypadá pojmově takto:

```text
hodnota  maska
$3E      $FF
libovolná $00
$CD      $FF
libovolná $00
$C9      $FF
```

Odpovídá pěti bajtům, jejichž první, třetí a pátá pozice mají hodnoty `$3E`,
`$CD` a `$C9`, zatímco druhá a čtvrtá mohou obsahovat cokoli.

Formát tabulky je o něco obecnější než uživatelské rozhraní. Maska jako `$F0`
by mohla porovnávat pouze horní čtyři bity. Původní příkaz takovou masku nikdy
nevytváří, porovnávací vzorec by ji však podporoval.

## Porovnávací vzorec

Vnitřní test je nádherně malý:

```asm
    ld a,(de)
    inc de
    xor (hl)
    inc hl
    and (hl)
    inc hl
    jr nz,.advanceMonitorFindAfterMismatch
```

V tomto okamžiku:

- `(DE)` byl kandidátní bajt paměti;
- první `(HL)` byla požadovaná hodnota;
- druhé `(HL)` byla maska.

Matematický test zní:

```text
(memory XOR wanted) AND mask
```

Nulový výsledek znamená, že souhlasily všechny významné bity.

Proč XOR? XOR vytvoří nulu všude, kde jsou dva bity stejné, a jedničku tam, kde
se liší. AND potom vymaže rozdíly, které má maska ignorovat.

Pro přesný bajt:

```text
memory = $3E
wanted = $3E
mask   = $FF

($3E XOR $3E) AND $FF = $00
```

Pro neshodu:

```text
memory = $3F
wanted = $3E
mask   = $FF

($3F XOR $3E) AND $FF = $01
```

Pro wildcard:

```text
memory = cokoli
wanted = cokoli
mask   = $00

(libovolný rozdíl) AND $00 = $00
```

To je celý mechanismus wildcardu. Neexistuje větev říkající „pokud to byla
dvojtečka, bajt přeskoč“. Maska promění tutéž aritmetiku buď v přesné
porovnání, nebo v operaci bez účinku.

## Zadání vzoru

`monFindSequence` se zeptá na pět pozic. Místo uložení pěti promptů uchovává
PROMETHEUS jediný řetězec začínající zapisovatelnou číslicí:

```text
1. byte:
```

Bajt označený `monitorFindBytePromptDigit` se před první otázkou nastaví zpět na
znak `1` a po každé odpovědi se zvýší. Tentýž text se proto postupně stane:

```text
1. byte:
2. byte:
3. byte:
4. byte:
5. byte:
```

Je to drobný příklad obecného zvyku programu: pokud může jediný bajt proměnit
jeden kus dat v pět příbuzných zpráv, neukládej pět samostatných zpráv.

Každá odpověď prochází přes `promptForMonitorValue`. Pevnou pozici lze tedy
zapsat jako libovolný běžný expression PROMETHEA:

```text
42
#$2A                 není skutečná syntaxe; šestnáctkově se zadává $2A
LABEL
LABEL+1
'A'
```

Zvláštní výsledek dvojtečky se odlišuje od vyhodnoceného expressionu. Handler
potom uloží buď:

```text
(dolní bajt výsledku, $FF)
```

nebo:

```text
(libovolná hodnota, $00)
```

Použije se pouze dolní bajt expressionu. Zadání `$123E` tedy na této pozici hledá
`$3E`.

## G a N začínají za současnou adresou

Jakmile G shromáždí nový vzor, provádění propadne do `monNextSequence`. Příkaz N
vstupuje do `monNextSequence` přímo a znovu používá předchozí vzor.

První instrukce jsou:

```asm
monNextSequence:
    ld de,(varcMonitorCurrentAddress+1)
    inc de
```

Oba příkazy tedy začínají na **současné adrese plus jedna**.

Díky této volbě je opakované hledání přirozené:

```text
G   definuj vzor a najdi první pozdější shodu
N   najdi další pozdější shodu
N   najdi znovu následující shodu
```

Kdyby nové hledání začínalo na současné adrese, N by stále znovu nacházelo tutéž
shodu.

## Postup od kandidáta ke kandidátovi

Pro každou kandidátní adresu rutina:

1. uloží kandidáta na CPU stack;
2. nastaví HL zpět na první dvojici hodnoty a masky;
3. porovná pět vzestupných bajtů paměti;
4. při shodě všech pěti nastaví kandidáta jako adresu monitoru;
5. jinak kandidáta obnoví, zvýší a zkusí znovu.

V pseudokódu:

```text
candidate = currentAddress + 1

repeat:
    p = candidate

    for i = 0 to 4:
        if ((memory[p+i] XOR value[i]) AND mask[i]) != 0:
            candidate = candidate + 1
            if candidate == 0:
                return bez nalezené shody
            continue repeat

    currentAddress = candidate
    překresli monitor
    return
```

Skutečný adresní prostor Z80 se na `$FFFF` přetáčí. Pětibajtové porovnání
začínající poblíž horního konce proto může své poslední bajty přečíst z `$0000`,
stejně jako by to udělal sám procesor. Smyčka kandidátů končí, když se zvýšení
neúspěšného kandidáta přetočí na nulu. Hledání začínající na nule tak může před
vzdáním projít celý 64K kruh.

Zpráva „nenalezeno“ neexistuje. Neúspěch se prostě vrátí s nezměněnou původní
současnou adresou. Je to strohé, ale odpovídá kompaktnímu stylu interakce
monitoru.

## Proč se kandidát ukládá na stack

Během porovnávání postupuje DE pěti bajty kandidáta. Při neshodě potřebuje
PROMETHEUS původního kandidáta, nikoli částečně posunuté DE. Každý pokus proto
začíná:

```asm
    push de
```

Úplná shoda vyzvedne uloženou hodnotu do HL a udělá z ní novou současnou adresu.
Neshoda ji vyzvedne zpět do DE, jednou zvýší a zkusí znovu.

Stack zde slouží jako lokální proměnná o velikosti jednoho slova.

## Přesun bloku

Příkaz I přesouvá inkluzivní zdrojový blok na jinou adresu. Má dvě podoby:

```text
I              First, Last, To
SYMBOL SHIFT+I First, Length, To
```

Druhá podoba se okamžitě převede na první:

```text
Last = First + Length - 1
```

Od této chvíle má příkaz tři adresy:

```text
sourceFirst
sourceLast
destinationFirst = To
```

Odvodí inkluzivní konec cíle:

```text
destinationLast = destinationFirst + sourceLast - sourceFirst
```

a počet bajtů:

```text
length = destinationLast - destinationFirst + 1
```

Na `+1` se snadno zapomíná. Pro inkluzivní blok `$8000..$8000` dá odečtení
nulu, blok však obsahuje jeden bajt.

## Odmítnutí nemožných rozsahů

Ještě před zkopírováním jediného bajtu se může pokazit několik věcí:

- First může ležet nad Last;
- Length může být nula;
- `First + Length - 1` se může přetočit přes šestnáct bitů;
- výpočet cíle se může přetočit;
- cíl se může překrývat s PROMETHEEM a jeho živým úložištěm zdroje nebo symbolů.

Příkaz všechny tyto případy svádí do kontroly rezidentního rozsahu. Chybný
rozsah skončí cestou monitoru `Read/Write ERROR` místo toho, aby spustil obrovské
přetočené kopírování.

Kontroluje se cíl, protože právě tuto oblast příkaz MOVE přepíše. Zdroj se
považuje za důvěryhodný vstup monitoru určený ke čtení.

## Překryv není chyba

Zdroj a cíl se mohou překrývat. Například:

```text
zdroj  $8000..$80FF
cíl    $8001..$8100
```

Naivní kopírování dopředu by přepsalo `$8001` dříve, než by přečetlo jeho původní
hodnotu. Poškození by se pak rozšířilo zbytkem bloku.

PROMETHEUS volá `moveMemoryBlockOverlapSafe`, stejný obecný mechanismus, který
editor používá při otevírání a zavírání mezer. Směr zvolí podle vzájemné polohy:

```text
if cíl začíná pod zdrojem:
    kopíruj dopředu pomocí LDIR
else:
    kopíruj dozadu pomocí LDDR
```

Kopírování dozadu v uvedeném příkladu začne posledním bajtem zdroje a zachová
každý dosud nepřečtený bajt dříve, než bude přepsán jeho cíl.

Příkaz se tedy chová jako moderní `memmove`, nikoli jako jednoduché `memcpy`.

## Skutečný tok MOVE

Práce s registry je natolik kompaktní, že v syrovém zdroji působí záhadně:

```asm
    push hl
    push de
    call promptForMonitorValue
    defb 0xd8
    pop de
    pop bc
    push de
    push hl
    or a
    sbc hl,de
    add hl,bc
```

Význam v próze je jednodušší:

```text
zapamatuj si zdrojové First a Last
zeptat se na cílové First (`To`)
spočítat cílové Last
zkontrolovat cíl
spočítat inkluzivní délku
provést přesun bezpečný při překryvu
```

Zdánlivá složitost pochází hlavně z nutnosti udržet tři šestnáctibitové adresy
naživu v procesoru s několika málo obecnými páry registrů.

## Vyplnění bloku

Příkaz P vyplní inkluzivní rozsah jedním bajtem. Opět má dvě podoby:

```text
P              First, Last, With
SYMBOL SHIFT+P First, Length, With
```

`With` se vyhodnotí jako šestnáctibitový expression, zapíše se však pouze jeho
dolní bajt.

PROMETHEUS nespouští ručně napsanou ukládací smyčku. Zapíše první bajt a potom
pomocí `LDIR` kopíruje tento bajt přes něj samotný do zbývajících buněk:

```asm
    ld (de),a
    ret z
    ld b,h
    ld c,l
    ex de,hl
    ld d,h
    ld e,l
    inc de
    ldir
```

Představme si vyplnění `$9000..$9004` hodnotou `$FF`:

```text
zapiš $FF na $9000
zkopíruj $9000 do $9001
zkopíruj $9001 do $9002
zkopíruj $9002 do $9003
zkopíruj $9003 do $9004
```

Jakmile existuje první cílový bajt, stane se bloková kopírovací instrukce Z80
kompaktním enginem pro replikaci bajtu.

## Nenápadné, ale důležité pravidlo ochrany

Monitor má konfigurovatelná ochranná okna READ a WRITE. Nabízí se předpoklad, že
je MOVE a FILL respektují.

Nerespektují.

Oba příkazy volají specializovanou kontrolu pouze rezidentní oblasti, která
nakonec vede do `checkRangeAgainstResidentRegionOnly`. Chrání:

```text
začátek relokovaného PROMETHEA
    až po
současný konec PROMETHEA + zdroje + tabulky symbolů
```

Uživatelská okna READ ani WRITE **nezkoumá**.

Implementované chování proto zní:

```text
MOVE/FILL nemohou přepsat rezidentní dílnu
MOVE/FILL mohou přepsat uživatelskou oblast chráněnou proti WRITE
MOVE může číst z uživatelské oblasti chráněné proti READ
```

Dochovaná příručka údajně popisuje širší ochranu. Strojový kód je však
jednoznačný: uživatelské tabulky na této cestě volání neleží.

V historické rekonstrukci by se to nemělo potichu „opravit“. Je to součást
programu, který vysvětlujeme.

## Důvěryhodné příkazy monitoru a řízené uživatelské instrukce

Zdánlivá nedůslednost dává větší smysl, když rozlišíme dvě role:

```text
důvěryhodný operátor monitoru:
    výslovně žádá o prohlédnutí, přesun nebo vyplnění paměti

trasovaný uživatelský program:
    může omylem nebo úmyslně číst, zapisovat či vykonávat chráněnou paměť
```

Konfigurovatelná okna prosazuje hlavně engine řízení instrukcí a krokování. Jsou
to ploty kolem zkoumaného programu, nikoli univerzální systém správy paměti
obalující každou rutinu monitoru.

Číselné výpisy rovněž čtou paměť přímo. Jednořádkové sestavení používá kontrolu
rezidentního výstupu a zdroje z assembleru. MOVE a FILL používají užší kontrolu
rezidentní oblasti.

PROMETHEUS má několik bezpečnostních hranic a každá je připojena ke konkrétní
cestě. Porozumět tomu, která cesta je právě aktivní, je užitečnější než
předpokládat jediné globální pravidlo.

## Zpět k celé operaci

Uvažujme běžné zkoumání:

```text
1. Nastav současnou adresu na podezřelou rutinu.
2. Stiskni G a zadej: $21 : : $CD :
3. PROMETHEUS uloží pět dvojic hodnoty a masky.
4. Prohledává od current+1, dokud maskovaný vzor nesouhlasí.
5. Shoda se stane novou současnou adresou.
6. Stiskni I a zkopíruj okolní blok do pracovní RAM.
7. Stiskni P a vyplň dočasnou pracovní oblast nulami.
8. Na zkopírované bajty použij jednořádkový assembler nebo disassembler.
```

Příkazy působí na klávesnici samostatně. Uvnitř však sdílejí principy, které
jsme viděli v celém programu:

- běžné vyhodnocování expressionů;
- kompaktní pracovní prostory pevné velikosti;
- flags jako booleovské výsledky;
- aritmetiku inkluzivních šestnáctibitových rozsahů;
- blokové instrukce bezpečné při překryvu;
- dynamickou hranici rezidentní paměti.

Blokové nástroje monitoru nejsou samostatným miniaturním operačním systémem.
Jsou to pečlivé nové kombinace mechanismů, které už potřeboval editor a
assembler.

## Co se změnilo v paměti

Po úspěšném hledání G:

- `monitorFindByteMaskPairs` obsahuje nový vzor;
- `varcMonitorCurrentAddress+1` obsahuje adresu shody.

Po N:

- vzor se nezmění;
- posunout se může pouze současná adresa.

Po MOVE:

- cílový rozsah obsahuje přesnou kopii původních bajtů zdroje;
- překrývající se kopie zůstávají správné;
- zdrojové bajty jsou jinak nezměněné.

Po FILL:

- každý bajt inkluzivního cílového rozsahu obsahuje dolní bajt `With`.

## Důležité navštívené labely

- `monFindSequence`
- `monNextSequence`
- `monitorFindByteMaskPairs`
- `monitorFindBytePromptDigit`
- `monMoveBlockFirstLast`
- `monMoveBlockFirstLength`
- `monFillBlockFirstLast`
- `monFillBlockFirstLength`
- `promptForFirstAndLast`
- `promptForFirstAndLength`
- `checkBlockDestinationAgainstResidentRegion`
- `preserveBlockRangeAndCheckResidentWrite`
- `checkRangeAgainstResidentRegionOnly`
- `moveMemoryBlockOverlapSafe`

## Myšlenky potřebné v dalších kapitolách

- Rozsah lze představit inkluzivními slovy First a Last.
- Několik funkcí monitoru sdílí jediný kompaktní jazyk tabulek rozsahů.
- Rezidentní interval PROMETHEUS/zdroj se před bezpečnostní kontrolou vytváří
  dynamicky.
- Konfigurovatelná ochrana platí především pro chování trasovaných instrukcí,
  nikoli automaticky pro každý důvěryhodný příkaz monitoru.

---
