# Kapitola 32: Celá cesta kazetou

Nyní jsme samostatně prozkoumali čtyři kazetové operace:

- SAVE zapisuje nativní zdroj a symboly PROMETHEA;
- VERIFY porovnává tento přesný zápis s pamětí;
- LOAD překládá nativní uložený projekt zpět do současného editoru;
- GENS překládá cizí text s čísly řádků na běžný vstup editoru.

Tato kapitola ustoupí od jednotlivých rutin a projde celé cesty systémem.
Nezavádí žádný velký nový mechanismus. Jejím účelem je znovu spojit jednotlivé
části dříve, než kniha opustí editor a assembler a vstoupí do monitoru strojového
kódu.

Společným tématem je, že PROMETHEUS zachází s kazetou jako s **transportem**,
nikoli jako s aktivní pamětí editoru. Data překračující hranici kazety se před
začleněním do současného projektu ověří, dočasně uloží nebo přeloží.

## Čtyři používané reprezentace

Podpoře kazety se lépe rozumí, když jednotlivé reprezentace výslovně pojmenujeme.

### 1. Aktivní stav editoru

Jde o současný projekt v paměti:

```text
komprimované záznamy zdroje
trvalé prázdné koncové záznamy
vektor pořadových čísel symbolů
abecedně seřazené záznamy symbolů
```

Jeho současný tvar popisují ukazatele jako `varcSymbolTablePt` a
`varcCodeEndPt`.

### 2. Nativní kazetový payload PROMETHEA

SAVE zapisuje:

```text
[bajty zdroje][dvoubajtový můstek][úplná tabulka symbolů]
```

Hlavička CODE Spectra nese:

```text
celkovou délku payloadu
délku zdroje v poli hlavičky použitém k jinému účelu
```

Tato soukromá hodnota délky zdroje dovoluje LOAD najít importovanou tabulku
symbolů uvnitř dočasně uloženého payloadu.

### 3. Dočasný payload v horní paměti

LOAD a GENS nejprve umístí úplná data CODE bezprostředně pod U-TOP:

```text
temporaryStart = U-TOP - totalLength
```

Aktivní projekt zůstává na místě a dočasná reprezentace se interpretuje řádek po
řádku.

### 4. Běžný vstup editoru

Oba importéry nakonec vytvářejí:

```text
textové bajty | marker kurzoru $01 | nulová výplň
```

v `inputBufferStart` a potom vstupují do `submitInputLineOrDispatchCommand`.

Tato poslední reprezentace tvoří úzký most do aktivního projektu.

## Nativní SAVE: od živých struktur ke kazetě

Předpokládejme, že v editoru běží tento program:

```asm
        ORG 32768
START   LD B,5
LOOP    DJNZ LOOP
        RET
        ENT START
```

Jeho aktivní podobou není tento text. Je to řetězec komprimovaných záznamů
odkazujících na pořadová čísla symbolů a tabulka symbolů obsahující jména jako
`START` a `LOOP`.

SAVE zvolí buď:

- smysluplný interval celého zdroje; nebo
- přesný uzavřený vybraný blok převedený na polootevřený rozsah bajtů.

Při ukládání celého zdroje se vynechá šest trvalých prázdných záznamů před
tabulkou symbolů. Jsou oporou editoru, nikoli obsahem projektu.

Příkaz vypočítá:

```text
S = uložené bajty zdroje
T = bajty úplné tabulky symbolů
P = S + 2 + T
```

a sestaví hlavičku CODE Spectra:

```text
filename = deset doplněných bajtů
CODE length = P
private source length = S
```

Fyzická datová cesta je zřetězená. ROM nejprve zapíše segment zdroje a potom
pokračuje přes dvoubajtový můstek a segment tabulky. PROMETHEUS nemusí celý
logický balík kopírovat do jednoho dočasného bufferu jen proto, aby byl fyzicky
souvislý.

Důležitý přechod je:

```text
adresy aktivního zdroje a tabulky
    ↓ přesně vybrané rozsahy
hlavička Spectra + zřetězené datové bloky
    ↓ kazetové pulzy
fyzický záznam na kazetě
```

SAVE si také zapamatuje přesné použité rozsahy, aby mohl bezprostřední VERIFY
porovnat stejné bajty.

## VERIFY: z kazety zpět do téže paměti

VERIFY nic nevytváří ani neslučuje. Požádá ROM, aby příchozí bajty porovnala se
zapamatovanými rozsahy zdroje a tabulky.

Cesta vypadá takto:

```text
prohledávej kazetové hlavičky
    ↓ přesné zapamatované jméno souboru
porovnej data zdroje se zapamatovaným rozsahem zdroje
    ↓ stav zřetězeného markeru
porovnej data můstku/tabulky se zapamatovaným pomocným rozsahem
```

Carry ve službě ROM `LD-BYTES` vybírá VERIFY místo LOAD.

Jestliže souhlasí každý bajt, předchozí záznam je důvěryhodný. Pokud se jediný
bajt liší nebo očekávaný blok nelze správně přečíst, příkaz ohlásí `Tape error`.

VERIFY je tedy testem jedné nedávné fyzické operace, nikoli obecným porovnáním
projektů. Závisí na samomodifikovaných rozsazích uložených předchozím SAVE a měl
by se provést dříve, než další editace tyto struktury přesune.

## Nativní LOAD: od soukromých záznamů přes veřejný text

LOAD začíná dočasným uložením kazetového payloadu pod U-TOP. Potom přečte délku
zdroje z hlavičky CODE a odvodí:

```text
stagedSourceStart = temporaryStart
stagedSourceEnd   = temporaryStart + sourceLength
stagedTableStart  = stagedSourceEnd + 2
```

Importované záznamy nelze přímo zkopírovat do aktivního zdroje. Jejich pořadové
číslo symbolu 4 například odkazuje na pořadové číslo 4 v **importované** tabulce,
nikoli nutně na pořadové číslo 4 v tabulce současné.

PROMETHEUS problém řeší dočasnou opravou resolveru jmen symbolů:

```text
normální režim:
    načti základ aktivní tabulky nepřímo z varcSymbolTablePt

režim importu:
    použij přímo základ dočasné importované tabulky
```

Pro každý dočasný záznam:

```text
1. najdi následující záznam
2. zapamatuj jej jako další kurzor importu
3. ověř, že současný záznam stále leží uvnitř dočasného zdroje
4. expanduj záznam pomocí importovaných jmen symbolů
5. obnov běžný resolver aktivní tabulky
6. zkopíruj kanonický text do inputBuffer
7. odešli jej běžným parserem a cestou INSERT
8. vrať se přes pokračování importu
```

Tím se:

```text
importovaná komprimovaná identita
```

změní na:

```text
jména symbolů
```

a potom zpět na:

```text
novou aktivní komprimovanou identitu
```

Stabilním mostem je jméno. Pořadová čísla se smějí změnit.

## GENS: od cizího textu stejným veřejným vstupem

GENS sdílí scan kazetových hlaviček a krok dočasného uložení, ale soukromá
metadata zdroje a symbolů ignoruje.

Pro každý řádek:

```text
přeskoč dva bajty čísla řádku
zkopíruj nejvýše 31 znaků
nahraď řídicí znaky mezerami
vynuluj bit 7
zastav na carriage return
připoj marker editoru $01
odešli běžnou cestou
```

Nativní LOAD potřebuje dočasnou importovanou tabulku symbolů, protože jeho
uložený zdroj už je komprimovaný. GENS ji nepotřebuje: jména jsou stále přítomna
jako text.

Obě cesty se spojí na stejném místě:

```text
inputBufferStart
    ↓
submitInputLineOrDispatchCommand
    ↓
běžný tokenizer, parser, správce symbolů a inserter
```

## Proč je LOAD sloučení, nikoli obnovení obrazu

Název příkazu `LOAD` může naznačovat nahrazení celého současného stavu uloženým
snapshotem. PROMETHEUS dělá něco pružnějšího.

Importované záznamy se vkládají za současný access line. Existující zdroj i
symboly zůstávají. Uživatel, který chce projekt nahradit, může nejprve vymazat
starý projekt příkazem CLEAR.

Tento návrh podporuje:

- načtení knihovny pod existující zdroj;
- vložení uloženého bloku do většího programu;
- spojení projektů s odlišným číslováním symbolů;
- import vybraného zdroje uloženého v jiném kontextu.

Cenou je postupnost a netransakčnost LOAD. Chyba po několika přijatých záznamech
ponechá vložený prefix.

Pojmově:

```text
LOAD = automatizovaná posloupnost platných vložení v editoru
```

nikoli:

```text
LOAD = přepsání paměti editoru uloženými bajty
```

## Setkání dvou rostoucích oblastí

Během obou importů paměť obsahuje starou i příchozí reprezentaci:

```text
rezidentní program
aktivní zdroj a symboly      → rostou vzhůru
volná paměť
dočasný kazetový payload     → kurzor postupuje vzhůru
U-TOP
```

U nativního LOAD se adresa dalšího dočasného záznamu po každém vloženém řádku
porovnává s rostoucím koncem aktivní oblasti:

```text
if liveEnd < nextStagedRecord:
    continue
else:
    Memory full
```

Porovnání je jemnější než jednorázová kontrola payloadu před načtením. Počáteční
payload se může vejít, jeho nové zakódování však může aktivní projekt zvětšit:

- importovaná jména mohou vytvořit nové záznamy tabulky;
- importovaný záznam může používat reprezentaci, jejíž aktivní zakódování má
  jinou délku;
- současné symboly musí existovat vedle importovaných jmen;
- vložení zdroje posouvá aktivní tabulku vzhůru.

Kontrola kapacity před načtením dokazuje pouze to, že lze data dočasně uložit.
Kontrola po každém řádku dokazuje, že obě reprezentace mohou během překladu dál
koexistovat.

GENS používá U-TOP jako konec proudu. Komentáře zdroje zdůrazňují okrajový případ
chybně ukončeného řádku, zatímco nativní LOAD zná přesné hranice záznamů ze svého
komprimovaného formátu.

## Jména překračují hranici bezpečněji než pořadová čísla

Předpokládejme, že uložený projekt obsahuje:

```text
ordinal 1 = LOOP
ordinal 2 = START
```

ale současný projekt už má:

```text
ordinal 1 = SCREEN
ordinal 2 = LOOP
ordinal 3 = BUFFER
```

Přímé kopírování záznamů by tiše změnilo význam. Odkaz zakódovaný jako pořadové
číslo 1 by se změnil na `SCREEN` místo `LOOP`.

LOAD místo toho expanduje importované pořadové číslo 1 přes dočasnou tabulku a
získá text `LOOP`. Aktivní parser potom najde existující aktivní pořadové číslo 2.

Překlad je:

```text
imported ordinal 1
    → imported name LOOP
    → live ordinal 2
```

Proto je zdánlivě plýtvavá cesta expandovat-a-znovu-analyzovat ve skutečnosti
bezpečná.

Vysvětluje to také, proč se úplná tabulka symbolů ukládá i při výběru pouhého
bloku zdroje. Blok může odkazovat na jména definovaná nebo uložená jinde. Importér
potřebuje tabulku, aby tato jména obnovil.

## Kazetové chyby vznikají v různých etapách

Je užitečné oddělit chyby podle toho, zda už byl změněn aktivní zdroj.

### Před začátkem vkládání

Příklady:

- nenalezen odpovídající blok CODE;
- chybný checksum kazetových dat;
- payload je příliš velký pro dočasné uložení;
- selhání načítání ROM.

V tomto okamžiku zůstává aktivní zdroj nedotčen. Příkaz se může vrátit s čistým
stavem projektu.

### Během postupného překladu

Příklady:

- neplatná syntaxe importovaného zdroje;
- kolize aktivní a dočasné oblasti paměti;
- přerušení klávesou SPACE;
- chybně vytvořený cizí řádek;
- importovaný text připomínající příkaz způsobí nezamýšlenou cestu.

Dříve přijaté řádky zůstávají vloženy.

Toto rozdělení je užitečným mentálním modelem:

```text
fáze fyzického získání:
    vzhledem k aktivnímu zdroji všechno, nebo nic

fáze sémantického importu:
    postupná a viditelná
```

## Klávesnice zůstává součástí kazetových operací

Podpora kazety není uzavřený proces běžící na pozadí. Uživatel se účastní v
několika okamžicích:

- výzvy ke spuštění kazety čekají na vědomý stisk klávesy;
- SPACE může přerušit kazetovou operaci nebo import;
- jiná klávesa během importu vyžádá překreslení okna zdroje;
- jméno souboru lze použít znovu nebo zadat za dvojtečkou;
- VERIFY běžně následuje po SAVE, dokud má zapamatovaný stav ještě smysl.

PROMETHEUS byl navržen pro člověka sedícího před kazetovým magnetofonem, nikoli
pro bezobslužné dávkové zpracování.

Fyzická posloupnost je důležitá:

```text
připrav magnetofon
stiskni klávesu
spusť nebo čti kazetu
sleduj zprávy Found
podle potřeby si vyžádej zobrazení průběhu
při chybě nebo přerušení skonči
```

## Úplná nativní cesta tam a zpět

Sledujme jeden projekt z editoru na kazetu a potom do jiného aktivního projektu.

### Krok 1: původní aktivní projekt

```text
záznamy zdroje používají původní pořadová čísla
tabulka symbolů obsahuje START a LOOP
```

### Krok 2: SAVE

```text
vyber rozsah zdroje
při celém zdroji vynech trvalý prázdný konec
zapiš hlavičku CODE
zapiš bajty zdroje
zapiš můstek a úplnou tabulku
zapamatuj přesné rozsahy pro VERIFY
```

### Krok 3: VERIFY

```text
najdi přesné jméno souboru
porovnej zdroj na kazetě se zapamatovaným zdrojem
porovnej můstek/tabulku na kazetě se zapamatovaným rozsahem tabulky
ohlas úspěch
```

### Krok 4: pozdější LOAD do jiného projektu

```text
dočasně ulož úplný payload CODE pod U-TOP
najdi dočasný zdroj a tabulku
for each importovaný záznam:
    importované pořadové číslo → importované jméno
    importovaný záznam → kanonický text
    kanonický text → aktivní parser
    aktivní parser → současné pořadové číslo a nový záznam
```

### Krok 5: výsledný aktivní projekt

```text
staré současné záznamy zůstávají
importované záznamy se objeví za access line
sdílená jména znovu použijí současná pořadová čísla
nová jména získají nová současná pořadová čísla
zdroj je celý v kanonickém formátu PROMETHEA
```

Fyzické bajty na kazetě byly při získávání přesně zachovány, aktivní výsledek
však může mít jiné bajty záznamů i jiná pořadová čísla symbolů. Zachován je
textový a symbolický význam programu.

## Úplná cesta cizího zdroje

Cesta GENS je kratší:

```text
cizí assembler uloží číslovaný text ukončený CR
    ↓ SAVE nebo export z tohoto assembleru
blok CODE Spectra na kazetě
    ↓ scan jména souboru a dočasné uložení příkazem GENS
cizí bajty pod U-TOP
    ↓ odstranění čísel řádků a normalizace bajtů
PROMETHEUS inputBuffer
    ↓ běžný parser
kanonický komprimovaný zdroj a aktivní symboly
```

Výsledný zdroj už není „ve formátu GENS“. Po přijetí je obyčejným zdrojem
PROMETHEA a lze jej editovat, sestavit, uložit a načíst nativními mechanismy.

## Podpora kazety jako sada adaptérů

Čtyři příkazy lze chápat jako adaptéry kolem dvou ústředních reprezentací:

```text
                    ┌─────────────────┐
                    │ aktivní projekt │
                    └─────────────────┘
                       ↑           ↓
            parser textu│           │výběr syrových rozsahů
                        │           │
        ┌───────────────┘           └───────────────┐
        │                                           │
kanonický text editoru                   nativní kazetový balík
        ↑                                           ↓
        │                                      fyzická kazeta
        │                                           ↑
cizí číslovaný text                              VERIFY
```

Parser editoru je sémantickým vstupem. Kazetové rutiny ROM jsou fyzickým vstupem
a výstupem. Importéry tyto dvě strany propojují.

## Proč neexistuje univerzální objekt souboru

Moderní program by mohl definovat jeden strukturovaný objekt projektu a
serializovat jej. PROMETHEUS místo toho pracuje s rozsahy adres, opravenými
operandy a několika kompaktními konvencemi.

Tato volba odráží procesor Z80 i paměťová omezení stroje:

- zdroj už existuje v užitečné sbalené podobě;
- tabulka symbolů už je souvislá;
- ROM očekává v registrech syrovou adresu a délku;
- vytvoření druhého úplného obrazu projektu by plýtvalo vzácnou RAM;
- postupný překlad dovoluje užitečný částečný úspěch.

Kód není organizován kolem „souborů“ jako abstraktních objektů. Je organizován
kolem transformací mezi oblastmi bajtů.

## Co se změnilo v paměti

V celém kazetovém systému mění různé operace různé věci.

### SAVE

- vytvoří sedmnáctibajtový pracovní prostor hlavičky;
- opraví zapamatované rozsahy pro VERIFY;
- nemění zdroj ani symboly.

### VERIFY

- čte hlavičky a porovnává kazetová data;
- záměrně nemění bajty projektu;
- závisí na stavu zapamatovaném příkazem SAVE.

### LOAD

- dočasně uloží nativní balík pod U-TOP;
- dočasně přesměruje řešení importovaných symbolů;
- vkládá nově zakódované záznamy do aktivního zdroje;
- může vytvářet nebo znovu používat aktivní symboly.

### GENS

- dočasně uloží plochý cizí proud pod U-TOP;
- postupuje řádky s dvoubajtovými čísly ukončenými CR;
- opakovaně vytváří `inputBufferStart`;
- vkládá běžné záznamy PROMETHEA.

## Důležité labely, které jsme potkali

- `invokeSave`
- `invokeVerify`
- `invokeLoad`
- `invokeGens`
- `scanTapeForNextCodeHeader`
- `callRomTapeLoadOrVerify`
- `prepareTapeSourceImport`
- `loadMatchingCodePayloadToTemporaryMemory`
- `patchSymbolReferenceResolverBase`
- `varcImportedDataCursor`
- `varcImportedSourceEnd`
- `varcImportedSymbolTableBase`
- `continueSourceImportAfterSubmittedLine`
- `continueGensImportAfterSubmittedLine`
- `pollImportKeyboardAndRefreshIfRequested`

## Myšlenky potřebné v pozdějších kapitolách

- Kazetové nástroje monitoru použijí stejné služby ROM, ale budou přenášet syrové
  bloky paměti místo strukturovaných projektů zdroje.
- Monitor znovu použije sdílené vstupní a zobrazovací mechanismy a změní okolní
  pokračování a chování při chybách.
- PROMETHEUS často zachovává význam překladem přes neutrální textovou
  reprezentaci místo kopírování soukromých interních identit.
- Paměťové oblasti se chápou jako pohyblivé hranice a jejich schopnost koexistovat
  se musí kontrolovat opakovaně, nikoli pouze jednou.

## Pokrytí zdroje

Tato kapitola znovu spojuje úplnou nativní cestu SAVE/VERIFY/LOAD a importér
GENS/MASM popsaný v kapitolách 29–31. Na úrovni knihy uzavírá část IV, aniž by
opakovala každou nízkoúrovňovou rutinu ROM nebo parseru.
