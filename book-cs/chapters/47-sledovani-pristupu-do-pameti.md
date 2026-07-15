# Kapitola 47: Sledování přístupů do paměti

Monitor schopný krokovat strojový kód má jednu nepříjemnou odpovědnost.

Musí dovolit, aby uživatelova instrukce pracovala se skutečnou pamětí, protože
právě tím vzniká věrný výsledek. Neměl by však bezstarostně umožnit krokované
instrukci přepsat PROMETHEA, číst chráněnou tajnou oblast nebo předat řízení do
zakázaného prostoru.

PROMETHEUS neemuluje každé načtení, uložení, push, pop, volání, návrat a blokový
přesun. Místo toho předpovídá adresy paměti, kterých se instrukce právě chystá
dotknout. Jsou-li tyto adresy povoleny, skutečný Z80 provede operaci ve scratch
RAM se skutečnými registry uživatele.

Tato kapitola vysvětluje právě tuto predikční vrstvu.

## Důvěryhodné příkazy a krokované instrukce jsou něco jiného

Kapitola 38 představila pět druhů ochranných oken:

- zobrazovací oblasti DEFB;
- zobrazovací oblasti DEFW;
- oblasti chráněné proti READ;
- oblasti chráněné proti WRITE;
- oblasti chráněné proti RUN.

První dvě ovlivňují disassembly. Poslední tři jsou především pravidly pro engine
krokování instrukcí.

Na tomto rozdílu záleží. Důvěryhodné příkazy monitoru jako MOVE a FILL používají
jednodušší kontroly rezidentní paměti a konfigurovatelná okna READ a WRITE
nedodržují důsledně. Uživatelská instrukce prováděná trasovacím enginem prochází
podrobným deskriptorovým mechanismem popsaným zde.

Monitor považuje sám sebe za důvěryhodný. Pozorovaný program považuje za
potenciálně nebezpečný.

## Brána před vykonáním

Po dekódování, ale ještě před sestavením nebo spuštěním scratch instrukce volá
`stepInstructionAtHL`:

```asm
call validateInstructionBeforeExecution
```

Tato rutina vykonává dvě pojmově oddělené úlohy:

1. odmítne `HALT`, z něhož by nebylo možné pokračovat;
2. jsou-li zapnuty kontroly instrukcí, předpoví účinky READ a WRITE.

Ochrana RUN se kontroluje později, až po zachycení stavu. K tomuto překvapivému
rozdílu se ještě vrátíme.

## HALT při zakázaném přerušení

`HALT` čeká, dokud nenastane přerušení. Jestliže uložený uživatelský stav říká,
že jsou přerušení zakázána, mohl by `HALT` uvnitř scratch programu uvěznit
monitor navždy.

PROMETHEUS rozpozná přesný neprefikovaný `HALT` ještě před kontrolou přepínače
řízení:

```asm
validateInstructionBeforeExecution:
    ld a,b
    sub 076h
    or c
    jr nz,.enforceInstructionMemoryControls
    ld a,(varcInterruptEnableState+1)
    or a
    ret nz
    ld a,0cfh
    jp showMonitorOperationError
```

Test kombinuje:

```text
opcode B == $76
třída prefixu C == 0
```

Je-li uloženým stavem EI, instrukce je povolena. Je-li jím DI, monitor zobrazí
`Interrupt ERROR`.

Tato kontrola zůstává aktivní i tehdy, jsou-li běžné kontroly READ, WRITE a RUN
vypnuty. Není to pouhá volitelná ochrana; je to pojistka proti kroku, který by se
nemusel nikdy vrátit.

## Obrácená logika přepínače kontrol

Stavový příkaz přepíná samomodifikovanou okamžitou hodnotu:

```asm
varcInstructionControlsDisabled:
    ld a,000h
    or a
    ret nz
```

Význam je obrácený:

```text
0       kontroly zapnuty
nenula  kontroly vypnuty
```

Nula je výhodná, protože běžná chráněná cesta jednoduše pokračuje dál. Vypnutí
kontrol způsobí časný návrat ještě před jakýmkoli hledáním deskriptoru.

I při vypnutých kontrolách:

- dekodér stále odmítá neplatné opcodes;
- `HALT` při DI je stále odmítnut;
- přepis toku řízení stále vrací instrukci do monitoru;
- obyčejné krokování stále zachycuje registry a PC.

Obcházejí se pouze konfigurovatelné kontroly oken READ, WRITE a RUN.

## Předpovídání účinků místo emulace instrukcí

Uvažujme tyto instrukce:

```asm
LD A,(HL)
LD (IX+5),B
PUSH DE
POP BC
LD ($9000),HL
CALL $8120
```

Monitor nemusí znát načítanou nebo ukládanou hodnotu. O tu se postará skutečný
Z80.

Pro ochranu potřebuje pouze:

```text
druh přístupu: READ nebo WRITE
první adresa
šířka: jeden nebo dva bajty
```

Příklady:

```text
LD A,(HL)       READ  uložené HL, jeden bajt
LD (IX+5),B     WRITE uložené IX + signed 5, jeden bajt
PUSH DE         WRITE uložené SP - 2, dva bajty
POP BC          READ  uložené SP, dva bajty
LD ($9000),HL   WRITE $9000, dva bajty
CALL $8120      WRITE uložené SP - 2, dva bajty
```

K propojení tvarů opcode s těmito recepty na adresu stačí kompaktní tabulka.

## Tabulky deskriptorů READ a WRITE

`readAccessDescriptorTable` a `writeAccessDescriptorTable` používají stejný
formát řádku jako tabulka toku řízení:

```text
počet
opakované řádky:
    maska opcode
    očekávaný maskovaný opcode
    sbalený deskriptor
```

Řádek odpovídá, když:

```text
(B AND opcodeMask) == expectedOpcode
AND
třída prefixu řádku == dekódovaná třída prefixu z C
```

Sbalený deskriptor obsahuje:

```text
horní nibble  třída dekodéru/prefixu
bit 3         přístup zabírá dva bajty
bity 0..2     recept na efektivní adresu
```

Odpovídající rutina vrací nastavené carry, když danou instrukci nepopisuje žádný
řádek. Žádná shoda není chyba. Znamená pouze, že instrukce nemá chráněný přístup
do paměti daného druhu.

Instrukce může odpovídat jednomu řádku READ, jednomu řádku WRITE, oběma nebo
žádnému.

Například blokový přesun čte z jednoho rozsahu a zapisuje do jiného. Stackové
operace mohou číst nebo zapisovat dva bajty. Čistě registrové `ADD A,B`
neodpovídá žádnému paměťovému deskriptoru.

## Jedna odpovídací rutina slouží třem tabulkám

Zdroj nazývá rutinu `matchInstructionAccessDescriptor`, používá se však také pro
tok řízení. Její činnost je obecná:

```asm
matchInstructionAccessDescriptor:
    ld a,c
    and 0f0h
    ld c,a
    ld d,(hl)               ; row count
    inc hl
.scanNextInstructionAccessDescriptor:
    ld a,b
    and (hl)                ; opcode mask
    inc hl
    cp (hl)                 ; expected value
    inc hl
    jr z,.returnInstructionAccessDescriptor
    ...
```

Když opcode odpovídá, rutina porovná horní nibble deskriptoru s dekódovanou
třídou. Při úspěchu vrátí spodní nibble a pomocí zero flagu si zapamatuje, zda
byl přítomen bit 3.

Je to kompaktní, ale ne hned zřejmé:

```text
A po návratu = index receptu adresy 0..7
Z po návratu = jednobajtový přístup
NZ po návratu = dvoubajtový přístup
carry         = žádný řádek neodpovídal
```

Flags jsou součástí kontraktu rutiny. Volající jim musí rozumět stejně přesně
jako hodnotě vrácené v registru.

## Osm způsobů získání efektivní adresy

Spodní tři bity deskriptoru vybírají jednu z osmi malých přístupových rutin:

```text
0  uložené BC
1  uložené DE
2  uložené HL
3  uložené IX + signed displacement
4  uložené IY + signed displacement
5  uložené SP
6  uložené SP - 2
7  dekódované okamžité slovo NN
```

Výběrová tabulka je další sekvencí offsetů zapsaných jako opcodes:

```asm
effectiveAddressAccessorOffsets:
    nop
    inc b
    ex af,af'
    inc c
    ld de,0211dh
    daa
```

Při čtení jako data ukazují tyto bajty do souvislých přístupových rutin
začínajících na `loadEffectiveAddressFromBC`.

### Uložené páry registrů

První tři přístupové rutiny jednoduše načtou slovo z uloženého uživatelského
obrazu:

```asm
loadEffectiveAddressFromBC:
    ld hl,(savedRegisterBC)
    ret
    ld hl,(savedRegisterDE)
    ret
    ld hl,(savedRegisterD+1)    ; saved HL
    ret
```

Podivně vypadající `savedRegisterD+1` je adresa uloženého bajtu H, a tedy začátek
little-endian slova HL ve sbaleném obrazu procesoru.

### Indexované adresy

Při adresování přes IX nebo IY se dekódovaný displacement nachází v E. Musí být
považován za signed bajt:

```asm
bit 7,e
ld d,000h
jr z,.applySignedDisplacementToEffectiveAddress
dec d
.applySignedDisplacementToEffectiveAddress:
add hl,de
```

Tedy:

```text
E=$05 -> DE=$0005
E=$FB -> DE=$FFFB = -5
```

Adresou přístupu se stane uložené IX nebo IY plus tato signed hodnota.

### Stackové adresy

Jsou zapotřebí dva stackové recepty:

```text
SP      pro POP, RET a další čtení z vrcholu stacku
SP - 2  pro PUSH, CALL a další zápisy pod současný vrchol
```

Monitor předpovídá adresu ještě předtím, než skutečný Z80 změní SP.

### Okamžitá adresa

Instrukce obsahující `(NN)` používají surový operand uložený dekodérem:

```asm
varcDecodedInstructionOperandWord:
    ld hl,00000h
    ret
```

Dekodér přepíše okamžitou hodnotu v této malé přístupové rutině `LD HL,nn / RET`
ještě před začátkem kroku.

## Kontrola jednoho nebo dvou bajtů

Po výběru efektivní adresy ji `validateMatchedMemoryAccess` zkontroluje proti
zvolené tabulce READ nebo WRITE:

```asm
call checkAddressAgainstProtectionTable
jp c,showMonitorReadWriteError
```

Označuje-li deskriptor jednobajtový přístup, to stačí.

U přístupu ke slovu monitor adresu zvýší a provede kontrolu znovu:

```asm
inc de
call checkAddressAgainstProtectionTable
jp c,showMonitorReadWriteError
```

Oddělená kontrola obou bajtů správně ošetří každou hranici včetně
šestnáctibitového přetečení:

```text
první bajt  $FFFF
druhý bajt  $0000
```

Dvoubajtový přístup je odmítnut, leží-li v chráněném rozsahu kterýkoli z obou
bajtů.

Je to přesnější než kontrolovat pouze počáteční adresu.

## READ před WRITE

Obecná cesta nejprve prohledá tabulku READ a potom tabulku WRITE:

```asm
ld hl,readAccessDescriptorTable
push de
call matchInstructionAccessDescriptor
ld hl,setReadProtectedAreas
call validateMatchedMemoryAccess

ld hl,writeAccessDescriptorTable
pop de
call matchInstructionAccessDescriptor
ld hl,setWriteProtectedAreas
```

Surový dekódovaný operand v DE se přes první hledání zachovává, protože jej mohou
potřebovat oba výpočty adresy.

Selže-li kterákoli validace, vykonávání se ke scratch instrukci vůbec nedostane.
Současné PC, registry, paměť i nahromaděné časování zůstávají logicky
nepotvrzené. Společná chybová cesta monitoru obnoví uloženou hodnotu R, aby
odmítnutá instrukce nevypadala, že spotřebovala fetch cykly.

## LDIR a LDDR potřebují celé rozsahy

Obyčejný deskriptor popisuje jeden přístup do paměti. `LDIR` a `LDDR` operaci
opakují, dokud BC neklesne na nulu. Kontrola pouze prvních zdrojových a cílových
bajtů by přehlédla většinu účinku instrukce.

PROMETHEUS proto opakované ED opcodes rozpoznává zvlášť.

Pro dopředný `LDIR` s uloženými hodnotami:

```text
HL = první zdroj
DE = první cíl
BC = počet
```

sestaví inkluzivní rozsahy:

```text
zdroj  HL .. HL+BC-1
cíl    DE .. DE+BC-1
```

Pro zpětný `LDDR` ukazují uložené HL a DE na horní konce:

```text
zdroj  HL-BC+1 .. HL
cíl    DE-BC+1 .. DE
```

Zdroj při sestavování těchto rozsahů používá alternativní bank registrů, takže
hlavní banka zůstává k dispozici okolnímu trasovacímu enginu.

Nejprve se proti ochraně WRITE zkontroluje cíl a potom proti ochraně READ zdroj:

```asm
ld hl,setWriteProtectedAreas
call checkRangeAgainstProtectionTable
jp c,showMonitorReadWriteError

ld hl,setReadProtectedAreas
call checkRangeAgainstProtectionTable
jp c,showMonitorReadWriteError
```

Teprve když jsou přijaty oba úplné rozsahy, proběhne opakovaná instrukce
nativně.

Je to dobrý příklad toho, že PROMETHEUS mění *predikci*, nikoli vykonání.
Skutečný Z80 stále provede skutečné `LDIR` nebo `LDDR` a vytvoří skutečné konečné
registry a flags.

## Současně se předpovídá časování bloku

Cesta opakovaného přesunu také nahrazuje obyčejné tabulkové časování výrazem:

```text
21 * BC - 5
```

Zdroj jej vypočítá pomocí existující násobicí pomocné rutiny:

```asm
ld h,b
ld l,c
ld de,00015h
call multiplyHLByDE

dec hl
dec hl
dec hl
dec hl
dec hl
ld (varcDecodedInstructionTStates+1),hl
```

Pro BC=1:

```text
21*1-5 = 16 T states
```

Pro BC=10:

```text
210-5 = 205 T states
```

Stejné zvláštní rozpoznání tedy dodá úplnou stopu v paměti i úplné časování
opakované instrukce.

Aritmetika je šestnáctibitová. Uložené BC rovné nule následuje přirozené chování
historického kódu při přetečení místo toho, aby dostalo moderní zvláštní případ.

## Ochrana RUN se kontroluje až po vykonání

Účinky READ a WRITE se kontrolují před spuštěním scratch programu. RUN je jiný.

Po zachycení se výsledné logické PC vloží do DE a zkontroluje proti
`setExecutionProtectedAreas`:

```asm
ld hl,setExecutionProtectedAreas
ld a,(varcInstructionControlsDisabled+1)
or a
call z,checkAddressAgainstProtectionTable
ld a,0ceh
jp c,showMonitorOperationError
```

Teprve po úspěchu této kontroly PROMETHEUS:

- provede callback simulované opravy stacku pro CALL/RET;
- potvrdí novou současnou adresu;
- přičte zvolený počet T-stavů.

Toto pořadí vytváří důležitou historickou nesrovnalost.

Jestliže krok vytvoří chráněné PC:

- zobrazené PC se nepotvrdí;
- zvolené T-stavy se nepřičtou;
- instrukce však už proběhla;
- její zápisy do paměti už mohou existovat;
- zachycené registry a SP už mohou odrážet výsledek.

Dochovaný manuál to zjednodušuje na představu, že chráněnému vykonání je
zabráněno. Původní program ve skutečnosti zjistí chráněný cíl až dodatečně.

Vzkříšená verze toto chování zachovává, místo aby kontrolu potichu přesunula.

## Co chybová cesta obnoví — a co obnovit nemůže

Společná cesta chyby operace sestaví krátký řádek, například:

```text
Read/Write ERROR
Run ERROR
Interrupt ERROR
```

Obnoví uloženou hodnotu R zachycenou před validací:

```asm
varcRestoreRBeforeOperationError:
    ld a,000h
    ld (savedRegisterR),a
```

Překreslí panel, pípne, počká na potvrzení, počká na uvolnění klávesy a znovu
vstoupí do `startMonitor`.

Při chybě READ nebo WRITE před vykonáním neběžela žádná uživatelova instrukce,
takže je toto zotavení čisté.

Při chybě RUN po vykonání nemůže vrátit libovolné vedlejší účinky registrů ani
paměti. Obecný transakční log neexistuje. Toto omezení plyne z hybridního
návrhu: skutečný procesor provádí operaci přímo.

## Propracovaný příklad: `LD (IX-2),HL`

Předpokládejme:

```text
uložené IX = $9002
displacement = $FE = -2
okno chráněné proti WRITE = $9000..$9000
```

Deskriptor říká:

```text
WRITE
efektivní adresa = IX + signed displacement
šířka = dva bajty
```

Přístupová rutina vypočítá:

```text
$9002 + (-2) = $9000
```

Validator zkontroluje:

```text
první bajt  $9000 -> chráněn
druhý bajt se už nekontroluje
```

Krok je odmítnut s `Read/Write ERROR`. Skutečný `LD` se nikdy nevykoná.

Kdyby byl chráněn pouze `$9001`, první kontrola by prošla a druhá selhala;
instrukce by přesto byla odmítnuta dříve, než by se zapsal kterýkoli bajt.

## Propracovaný příklad: `RET`

Při uloženém SP rovném `$A000` má RET dva druhy předpovídaného účinku:

```text
READ  $A000 a $A001       získání návratového cíle
RUN   výsledný cíl        kontrola po zachycení
```

Deskriptor READ chrání oba stackové bajty ještě před vykonáním. Handler toku
řízení je zároveň přečte, aby stanovil logické PC provedené cesty. RET je
přepsán tak, aby fyzicky neunikl ze scratch RAM.

Po zachycení se logický cíl zkontroluje proti oknům RUN. Teprve potom se uložené
SP posune o dva a potvrdí se nové PC.

Ukazuje to spolupráci několika oddělených subsystémů:

- paměťový deskriptor předpoví čtení stacku;
- handler toku řízení předpoví cíl;
- zachycení získá skutečný výsledek podmínky;
- tabulka RUN posoudí výsledné logické PC;
- callback provede logický pop ze stacku.

## Zpět k celému stroji

Ochranný engine lze nyní shrnout takto:

```text
dekóduj opcode a prefix

if HALT a uložené DI:
    Interrupt ERROR

if kontroly zapnuty:
    if LDIR/LDDR:
        sestav úplný zdrojový a cílový rozsah
        zkontroluj rozsah WRITE
        zkontroluj rozsah READ
    else:
        najdi deskriptor READ
        vypočítej efektivní adresu
        zkontroluj jeden nebo dva bajty

        najdi deskriptor WRITE
        vypočítej efektivní adresu
        zkontroluj jeden nebo dva bajty

vykonej skutečnou instrukci ve scratch
zachyť výsledek

if kontroly zapnuty:
    zkontroluj výsledné PC proti tabulce RUN

potvrď opravu stacku, PC a časování
```

PROMETHEUS předpovídá pouze to, co potřebuje pro prosazení pravidel. Neduplikuje
datové chování procesoru.

Příští kapitola vysvětlí, jak se sčítá zvolené časování, jak uložený stav
přerušení vstupuje do trampoline a zase ji opouští a jak se z jednotlivého kroku
stává pomalé nebo rychlé automatické trasování.

## Co se změnilo v paměti

Validace přístupů do paměti za normálních okolností nemění žádnou uživatelovu
paměť. Čte:

- uložené registry;
- stav dekódovaného operandu;
- tabulky deskriptorů READ a WRITE;
- tabulky ochranných oken.

Pro `LDIR`/`LDDR` přepíše dekódovanou hodnotu T-stavů úplným časováním opakované
instrukce.

Selže-li validace před vykonáním, scratch instrukce se nespustí. Selže-li
validace RUN po zachycení, mohly už nastat vedlejší účinky na straně uživatele,
přestože PC a časování nejsou potvrzeny.

## Důležité labely, s nimiž jsme se setkali

- `validateInstructionBeforeExecution`
- `varcInstructionControlsDisabled`
- `readAccessDescriptorTable`
- `writeAccessDescriptorTable`
- `matchInstructionAccessDescriptor`
- `validateMatchedMemoryAccess`
- `effectiveAddressAccessorOffsets`
- `loadEffectiveAddressFromBC`
- `varcDecodedInstructionOperandWord`
- `setReadProtectedAreas`
- `setWriteProtectedAreas`
- `setExecutionProtectedAreas`
- `showMonitorReadWriteError`
- `showMonitorOperationError`
- `varcRestoreRBeforeOperationError`

## Myšlenky potřebné v dalších kapitolách

- Pravidla trasovaných přístupů do paměti vycházejí z předpovídaných adres,
  nikoli z emulace instrukcí.
- Řádky deskriptorů spojují masku opcode, třídu prefixu, šířku a recept na
  adresu.
- Dvoubajtové přístupy se kontrolují bajt po bajtu, včetně přetečení přes
  `$FFFF`.
- `LDIR`/`LDDR` vyžadují předpověď celých inkluzivních rozsahů.
- `HALT` při DI je odmítnut i při vypnutých kontrolách.
- READ a WRITE se kontrolují před vykonáním; RUN až po něm.
- Chyba RUN po vykonání nemůže vrátit libovolné vedlejší účinky uživatelova
  programu.
