# Kapitola 4: Registry jako dočasné postavy příběhu

Když se lidé poprvé učí assembler, bývají registry představovány jako seznam k zapamatování:

- `A` je akumulátor;
- `B`, `C`, `D`, `E`, `H` a `L` jsou univerzální registry;
- `BC`, `DE` a `HL` jsou dvojice registrů;
- `IX` a `IY` jsou indexové registry;
- `SP` je ukazatel zásobníku;
- `PC` je čítač programu.

Tento popis je správný, ale pro čtení velkého programu ještě nestačí. Říká, co registry *mohou dělat*, nikoli co *právě teď znamenají*.

V PROMETHEU je užitečnější představovat si registr jako herce, který mezi scénami mění kostým. V jedné rutině je `HL` adresou zdrojového textu. O několik volání později představuje pozici na obrazovce. Jinde tentýž pár obsahuje číslo, které se právě formátuje. Procesor si tyto významy nepamatuje. Existují pouze jako dohoda mezi rutinou a jejími volajícími.

Tato kapitola proto není katalogem registrů Z80. Je návodem, jak sledovat jejich proměnlivé role, aniž bychom se ztratili.

## Rutina vytváří dočasný slovník

Uvažujme tuto velmi malou pomocnou rutinu:

```asm
addAtoHL:
    add a,l
    ld l,a
    ret nc
    inc h
    ret
```

Jejím úkolem je přičíst osmibitovou neznaménkovou hodnotu v `A` k šestnáctibitové adrese v `HL`.

Z80 nemá instrukci ve smyslu „přičti `A` přímo k `HL`“. PROMETHEUS proto přičte `A` k dolnímu bajtu `L`. Pokud součet překročí hranici 256bajtové stránky, nastaví se carry a je třeba zvýšit `H`.

V pseudokódu:

```text
HL.low = HL.low + A
if při součtu vznikl přenos:
    HL.high = HL.high + 1
return HL
```

Uvnitř této malé rutiny platí dočasný slovník:

```text
A     = neznaménkový posun
HL    = základní adresa, potom výsledná adresa
carry = přenos z dolního bajtu
```

Tento slovník končí instrukcí `RET`. Následující rutina může každému registru přiřadit úplně jiný význam.

To je první návyk potřebný při čtení PROMETHEA:

> Neptejte se, co registr znamená obvykle. Ptejte se, co podle dohody znamená v právě čtené rutině.

## Dvojice registrů bývají důležitější než jednotlivé registry

Z80 je osmibitový procesor, ale adresy mají 16 bitů. PROMETHEUS proto neustále pracuje s dvojicemi:

```text
BC = B jako horní bajt, C jako dolní bajt
DE = D jako horní bajt, E jako dolní bajt
HL = H jako horní bajt, L jako dolní bajt
```

Pokud `HL` obsahuje `$8123`, potom:

```text
H = $81
L = $23
```

Toto párování není jen pohodlná konvence. Mnohé instrukce Z80 zacházejí s dvojicí jako s jediným šestnáctibitovým objektem:

```asm
ld hl,$8123
inc hl
add hl,de
push hl
pop hl
jp (hl)
```

PROMETHEUS toho využívá neustále. Dvojice může představovat:

- adresu ve zdrojové paměti;
- první nebo poslední adresu bloku;
- počet bajtů;
- vypočtenou hodnotu symbolu;
- pozici v bitmapě obrazovky;
- následující výstupní adresu assembleru.

Jednotlivé poloviny jsou stále přístupné. To umožňuje kompaktní triky jako `addAtoHL`, ale zároveň vytváří nebezpečí. Je-li `HL` ukazatelem a rutina si vypůjčí `H` jako nesouvisející čítač, ukazatel se poškodí, pokud předtím nebyl uložen.

## Běžná pochodová sestava: zdroj, cíl a počet

Rutiny pro přesouvání paměti často používají známé uspořádání:

```text
HL = zdroj
DE = cíl
BC = počet bajtů
```

Toto uspořádání odpovídá blokové instrukci `LDIR`, která opakovaně provádí přibližný ekvivalent:

```text
memory[DE] = memory[HL]
HL = HL + 1
DE = DE + 1
BC = BC - 1
```

Dokud `BC` nedosáhne nuly.

PROMETHEUS potřebuje také kopírování směrem zpět, pokud se zdroj a cíl překrývají nevhodným směrem. Vyšší účel zůstává stejný, i když se registry nejprve nastaví na konce rozsahů a poté se použije `LDDR`.

Až pozdější kapitoly začnou mluvit o vložení záznamu zdroje, přesunu tabulky symbolů nebo instalaci rezidentního obrazu, bude se tato trojice registrů vracet znovu a znovu.

Je užitečné číst ji téměř jako větu:

```text
zkopíruj BC bajtů z HL do DE
```

Taková věta se pamatuje mnohem snáze než tři navzájem nesouvisející názvy registrů.

## Registr může nést hodnotu i rozhodnutí

Rutina často vrací užitečnou adresu nebo bajt v registrech a druhou odpověď v příznacích.

Uvažujme toto porovnání hranice:

```asm
compareHLWithSourceBufferStart:
    push hl
    push de
    ld de,sourceBufferAccessLine
    and a
    sbc hl,de
    pop de
    pop hl
    ret
```

Volající předá kandidátní ukazatel v `HL`. Rutina odečte trvalý začátek zdrojového bufferu pouze proto, aby stanovila vzájemný vztah. Před návratem pak obnoví obě dvojice registrů.

Kandidátní ukazatel se tedy vrátí beze změny, zatímco carry sděluje výsledek:

```text
carry nastaveno = kandidát leží pod začátkem zdrojového bufferu
carry vynulováno = kandidát leží na začátku nebo nad ním
```

Instrukce `POP` nezmění příznaky vzniklé porovnáním, takže se obnovené `HL` a výsledek v carry mohou vrátit společně.

Tento styl je v PROMETHEU běžný:

```text
užitečná hodnota zůstane v registrech
odpověď o této hodnotě zůstane v příznacích
```

Mezi běžně vracená rozhodnutí patří:

- nalezeno nebo nenalezeno;
- uvnitř nebo vně rozsahu;
- platné nebo neplatné;
- rovno, menší nebo větší;
- carry nastaveno ve významu „ano“.

Při čtení pouze jedné strany volání to může působit tajemně. Volání rutiny je mnohem jasnější, když si poznamenáme obě části jeho výsledku.

## Carry je oblíbená jednobitová obálka PROMETHEA

Příznak carry původně vznikl jako aritmetický příznak, ale programy v assembleru jej běžně používají jako jednobitovou návratovou hodnotu.

Mechanismus kontroly rozsahů v monitoru například používá carry k oznámení, zda adresa leží uvnitř chráněné oblasti. Pojmově:

```text
carry vynulováno = adresa nebo rozsah jsou povoleny
carry nastaveno   = adresa nebo rozsah zasahují chráněný interval
```

Volající pak může reagovat přímo:

```asm
call checkAddressAgainstProtectionTable
jr c,.buildDefbDisassemblyRecord
```

Jakmile známe dohodu, čte se větev přirozeně:

```text
if adresa je chráněná:
    zobraz ji jako data místo dekódování instrukce
```

Carry je obzvlášť výhodné proto, že je již vytváří řada porovnávacích a sčítacích instrukcí. Dobrý programátor Z80 často uspořádá výpočet tak, aby se užitečné rozhodnutí objevilo v carry samo a nebylo třeba ukládat další bajt.

Kniha takovou konvenci vždy vysvětlí, když je důležitá. Carry nemá v celém PROMETHEU jeden globální význam. Znamená pouze to, co slibuje právě volaná rutina.

## Zachovat registr znamená zachovat slib

Představme si, že volající potřebuje `HL` i po návratu ze subrutiny, která jej však sama používá. Běžným řešením je zásobník:

```asm
push hl
call someRoutine
pop hl
```

Tento postup se často popisuje mechanicky jako „ulož a obnov `HL`“. Hlubší důvod je tento:

> Volající přisoudil registru `HL` význam, který musí přetrvat, a volaná rutina si chce fyzický registr dočasně vypůjčit.

Přesně to dělá reprezentativní úryvek z vykreslování vstupu:

```asm
displayInputTokenOrCharacter:
    cp $80
    jr c,displayUninvertedCharacter
    push hl
    push de
    ; locate and render the expanded token
    ...
    pop de
    pop hl
```

`HL` zde patří okolnímu průchodu vstupním bufferem a `DE` může patřit jiné širší operaci. Expanze tokenu potřebuje oba registry k vyhledávání v tabulkách a průchodu textem, takže si je za zády volajícího vypůjčí a vrátí je beze změny.

Instrukce `PUSH` zde nejsou ozdobou. Udržují širší příběh pohromadě.

## Zásobník není jen místo pro návratové adresy

Každá instrukce `CALL` automaticky uloží na zásobník návratovou adresu. `RET` ji z něj odebere. PROMETHEUS zásobník používá také pro:

- ukládání dvojic registrů;
- přenášení dočasných hodnot přes rutinu, která potřebuje příslušné registry;
- obracení pořadí dat;
- zapamatování několika vnořených adres;
- záměrné převzetí kontroly nad návratovou adresou.

Nápadný příklad poskytuje tisk inline řetězce:

```asm
installerPrintInlineString:
    ld (varcInstallerStringDestination+1-...),hl
    pop hl
    ...
    jp (hl)
```

Volající umístí text bezprostředně za instrukci `CALL`. Za běžných okolností by návratová adresa ukazovala na následující instrukci. Zde ukazuje na první znak textu.

Rutina odebere návratovou adresu pomocí `POP HL`, považuje ji za ukazatel na řetězec, postupuje až za označený poslední znak a nakonec provede `JP (HL)`, aby pokračovala za inline daty.

V pseudokódu:

```text
stringPointer = popReturnAddress()
tiskni znaky od této adresy
stringPointer = bajt za posledním znakem
jump stringPointer
```

Zásobník dočasně změnil svou roli. Stále nesl adresu, ale ta byla nejprve interpretována jako data a teprve potom se znovu stala tokem řízení.

K této technice se vrátíme v kapitole 6, protože závisí také na kompaktním způsobu označení konce řetězce.

## `IX` a `IY` jsou užitečné, když mají pole pevné pozice

`HL` je výborný pro průchod posloupností. `IX` a `IY` se výborně hodí k odkazování na pole kolem stabilní základní adresy.

Disassembler používá `IX` při stavbě dočasného komprimovaného záznamu zdroje:

```asm
ld ix,encodedRecordInfoByte
ld (ix-1),c
ld (ix-2),b
```

Základní registr ukazuje na jedno známé pole. Okolní pole se adresují znaménkovými posuny:

```text
IX-2 = bajt opcode
IX-1 = informační bajt
IX+0 = první bajt výrazu
```

Připomíná to malou strukturu ve vyšším jazyce:

```text
record.opcode = B
record.info   = C
record.expression začíná zde
```

Indexované instrukce Z80 jsou delší a pomalejší než běžný přístup přes `(HL)`, proto je PROMETHEUS nepoužívá všude. Největší smysl mají tehdy, když rutina potřebuje několik pojmenovaných pozic kolem jednoho objektu a nechce neustále posouvat základní ukazatel.

## Alternativní sada registrů je druhý pracovní stůl

Z80 obsahuje stínové kopie několika registrů:

```text
AF  ↔ AF'
BC  ↔ BC'
DE  ↔ DE'
HL  ↔ HL'
```

`EX AF,AF'` prohodí akumulátor a příznaky. `EXX` prohodí `BC`, `DE` a `HL` s jejich alternativními verzemi.

Hodnoty se nekopírují. Pouze se vymění sada, která je právě viditelná.

Představme si pracovní stůl se dvěma zásuvkami. Místo přesouvání šesti předmětů po jednom `EXX` jednu zásuvku zavře a druhou otevře.

PROMETHEUS to využívá v situacích, kdy dvě činnosti potřebují vlastní dočasný svět registrů. Tisk inline řetězce si v jedné sadě ponechá ukazatel na zdrojový text, zatímco vykreslovač znaků používá druhou sadu pro adresy fontu a obrazovky:

```asm
ld a,(hl)
and $7F
exx
; calculate and draw glyph using the other HL/DE/BC
...
exx
ld a,(hl)
```

Monitor si chrání alternativní registry také při volání sdílené klávesnicové rutiny:

```asm
readKeyCode:
    exx
    call processKey
    exx
    call isLetter
    ...
```

Důležité není to, že alternativní sada představuje „rychlejší úložiště“. Umožňuje dvěma překrývajícím se příběhům zachovat si oddělené obsazení registrů.

Cena je mentální. Po `EXX` znamenají jména `HL`, `DE` a `BC` jiné fyzické hodnoty než o jedinou instrukci dříve. Dobré komentáře a jasné hranice rutin jsou proto nezbytné.

## Registry mohou nést metadata kódu, nikoli uživatelská data

Disassembler ukazuje další druh přiřazení rolí. Po dekódování instrukce používá:

```text
B  = kanonický opcode
C  = metadata prefixu a třídy operandu
DE = surové bajty operandu
HL = následující sekvenční adresa
```

Tyto hodnoty nepatří přímo živému stavu procesoru uživatelova programu. Jsou *popisem* instrukce.

Pozdější rutina vezme dolní tři bity `C`, vybere handler operandu a vytvoří text nebo dočasný záznam zdroje. Tytéž fyzické registry, které jinde představují bloky paměti, zde vyjadřují fakta o gramatice strojového kódu.

Proto jsou názvy v próze tak užitečné. Místo věty:

> Rutina maskuje C, načte C z `(HL)` a potom přičte BC k HL.

můžeme říci:

> Rutina použije třídu operandu k výběru položky samorelativního formátovače.

Skutečný kód zůstává k dispozici, ale dočasný slovník zviditelní jeho účel.

## Význam registru se může změnit uprostřed rutiny

Velké rutiny někdy znovu použijí registry poté, co skončila dřívější fáze. Šetří tím instrukce `PUSH`, paměťové proměnné i bajty kódu.

Parser může například začínat se stavem:

```text
HL = ukazatel vstupu
DE = ukazatel výstupního bufferu
C  = zbývající kapacita
```

Po zkopírování pole se může `HL` změnit na ukazatel do tabulky a `DE` může obsahovat číselnou hodnotu. Je to v pořádku, protože dřívější významy už nejsou potřeba.

Nejbezpečnější je číst takový kód po fázích:

```text
Fáze 1: projdi vstup
Fáze 2: klasifikuj token
Fáze 3: vytvoř zakódovanou podobu
```

Na každé hranici přepište ve svých poznámkách slovník registrů. Snaha udržet jeden význam po celou dlouhou rutinu vytváří zmatek, který v původním kódu ve skutečnosti neexistuje.

## Některé instrukce záměrně vyrábějí příznaky

Podivně může působit například:

```asm
cp a
```

Instrukce porovnává `A` se sebou samým. Hodnoty se nemohou lišit, takže se nastaví zero a vynuluje carry.

Proč se prostě nevrátit?

Protože volající očekává výsledek v příznacích. Rutina vyrábí slíbenou odpověď.

Mezi další běžné idiomy pro nastavení příznaků patří:

```asm
or a       ; test A, clear carry
and a      ; test A, clear carry
scf        ; set carry
inc a      ; alter zero without altering carry
```

Čteme-li je pouze jako aritmetiku, mohou vypadat zbytečně. Smysl dostávají jako příprava výstupní podmínky rutiny.

Pozdější kapitoly vždy uvedou přesnou dohodu a nebudou od čtenáře očekávat, že si okamžitě zapamatuje všechny vedlejší účinky instrukcí na příznaky.

## Praktická metoda sledování registrů

Když je rutina obtížná, vytvořte si ještě před čtením každé instrukce malou tabulku:

| Registr | Význam při vstupu | Význam při návratu |
|---|---|---|
| `HL` | adresa záznamu zdroje | následující záznam nebo zachovaný ukazatel |
| `DE` | cílový buffer | konec vytvořených dat |
| `BC` | počet bajtů | nula nebo zachovaná hodnota |
| `A` | volba nebo současný bajt | výsledkový kód |
| příznaky | neurčeno | carry znamená úspěch/neúspěch |

Potom rozdělte tělo na fáze a tabulku aktualizujte pokaždé, když se významy změní.

U volání si položte čtyři otázky:

1. Co musí být před voláním vloženo do registrů?
2. Které registry mají podle dohody přežít?
3. Kde se vrací hodnota?
4. Které příznaky nesou vrácené rozhodnutí?

Je to assemblerový ekvivalent čtení signatury funkce.

## Zpět k celému stroji

Několik dřívějších cest nyní můžeme znovu vyjádřit jazykem registrů.

Když editor prochází vstup:

```text
HL prochází znaky
DE zapisuje normalizované pole
C počítá zbývající místo v bufferu
A nese právě zpracovávaný znak
příznaky oznamují jeho třídu
```

Když assembler vytváří bajty:

```text
HL a IX ukazují do zdroje a struktur záznamů
DE nebo BC nesou dekódované hodnoty
varcAssemblyOutputPointer si pamatuje dlouhodobý cíl
A nese jednotlivé bajty do emitteru
```

Když monitor disassembluje:

```text
HL prochází strojový kód
B a C popisují dekódovanou instrukci
DE nese bajty operandu
IX staví dočasný záznam zdroje
```

Jména registrů zůstávají stejná. Příběhy se mění.

Právě tato pružnost je jedním z důvodů, proč PROMETHEUS vměstná tolik funkcí do tak malého prostoru. Program nerezervuje oddělenou sadu proměnných pro každý pojmový objekt. Několika rychlým registrům přidělí přesné dočasné role, intenzivně je využije a potom je znovu obsadí do další scény.

## Co se změnilo v paměti?

Tato kapitola se zabývala hlavně hodnotami v procesoru, nikoli dlouhodobou pamětí. Během příkladů:

- `PUSH` dočasně ukládal hodnoty registrů na aktivní zásobník;
- tisk inline řetězce odebral návratovou adresu a později pokračoval za řetězcem;
- vykreslovač vstupu zachoval ukazatele volajícího během expanze tokenu;
- `IX` adresoval pole v dočasném komprimovaném záznamu;
- prohazování alternativních registrů změnilo aktivní fyzickou sadu registrů, aniž se změnila RAM.

Zatím jsme nezavedli žádný nový trvalý datový formát. To se změní v následujících dvou kapitolách.

## Uvedené orientační labely zdroje

- `addAtoHL`
- `compareHLWithSourceBufferStart`
- `displayInputTokenOrCharacter`
- `installerPrintInlineString`
- `readKeyCode`
- `processKey`
- `encodedRecordInfoByte`
- `dispatchDisassemblyOperandHandler`
- `checkAddressAgainstProtectionTable`
