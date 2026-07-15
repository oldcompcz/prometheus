# Chapter 23: The Symbol Table

A symbol table sounds like a dictionary:

```text
START  = 32768
LOOP   = 32771
SCREEN = 16384
```

That description is true, but incomplete. PROMETHEUS needs the same collection
of names to serve several different jobs.

The assembler wants to find a symbol quickly when the programmer writes its
name. Source records want a short, stable reference that does not change every
time the table moves. The `TABLE` command wants names displayed alphabetically.
Pass one wants to mark a symbol as defined. Separate work may require a saved
value to remain locked. `TABLE C` wants to remove unused names and compact the
remaining bytes.

A single simple list would make at least one of these jobs awkward. PROMETHEUS
therefore stores the table in **two simultaneous orders**:

- an ordinal vector array, whose positions give symbols stable numbers;
- an alphabetical value-and-name area, whose records are pleasant to display
  and search by spelling.

The vector array connects the two.

This design is one of the most elegant structures in the program. It is also a
good example of what programmers did when memory was scarce: instead of storing
several complete indexes, they stored a tiny layer of indirection.

## Where the table lives

The symbol table does not occupy a fixed address. It sits immediately above the
compressed source and moves whenever source records are inserted or deleted.

The broad arrangement is:

```text
low addresses

    compressed source records
    permanent empty-record padding

    symbol-table base  ← varcSymbolTablePt
        two-byte symbol count
        two-byte ordinal vectors
        sorted value/name records

    first unused byte  ← varcCodeEndPt

high addresses
```

This arrangement lets source and symbols share one growing packed region.

If a new source record is inserted below the table, the whole symbol table moves
up. If a source record is deleted, it moves down. No source record contains a
direct address into the table, so these movements do not invalidate symbol
references.

Instead, source expressions contain ordinals such as:

```text
symbol 1
symbol 2
symbol 37
```

The ordinal vector at the current table base tells PROMETHEUS where the actual
name and value live now.

## The exact layout

Let `P` be the current address stored in `varcSymbolTablePt+1`, and let `N` be
the number of symbols.

The table begins:

```text
P+0   count low byte
P+1   count high byte
```

Then come `N` two-byte vectors:

```text
P+2            vector for ordinal 1
P+4            vector for ordinal 2
P+6            vector for ordinal 3
...
P+2+2*(N-1)    vector for ordinal N
```

After the vectors come the physical symbol records, sorted alphabetically by
name:

```text
value low
value high
name character 1
name character 2
...
final name character with bit 7 set
```

There is no persistent name length byte.

A small table might look conceptually like this:

```text
P:
    03 00                   three symbols

    vector ordinal 1  ───────────────┐
    vector ordinal 2  ───────┐       │
    vector ordinal 3  ───┐   │       │
                          │   │       │
    $8000  "ALPHA"       ◄───┘       │
    $8010  "LOOP"        ◄───────────┘
    $4000  "SCREEN"      ◄──────────── other vector
```

The physical records are alphabetical:

```text
ALPHA
LOOP
SCREEN
```

The ordinal order depends on when the names were first encountered. It might be:

```text
ordinal 1 = LOOP
ordinal 2 = SCREEN
ordinal 3 = ALPHA
```

The vectors allow both orders to coexist.

## Why ordinals are one-based

The first symbol is ordinal 1, not ordinal 0.

That fits the table arithmetic conveniently. The count occupies the first two
bytes, and a doubled ordinal naturally reaches the corresponding vector from
the table base:

```text
vectorAddress = P + 2 * ordinal
```

For ordinal 1:

```text
P + 2
```

which is the first vector.

For ordinal 2:

```text
P + 4
```

which is the second.

The tagged ordinal stored in a source expression has bit 7 set in its high byte.
The resolver clears that tag before using the ordinal as a number.

## A vector is an offset plus two flags

Each vector is a little-endian 16-bit word, but not all sixteen bits belong to
the address offset.

```text
bits 0–13   offset into the alphabetical entry area
bit 14      DEFINED, or temporary TABLE C mark
bit 15      LOCKED
```

In the stored high byte this means:

```text
bit 6       DEFINED / temporary mark
bit 7       LOCKED
```

The remaining six high-byte bits join the low byte to form a fourteen-bit
offset.

This is why code repeatedly uses:

```asm
    and 03fh
```

before treating the vector as an address offset. `$3F` keeps the six low bits
and removes both flags.

A vector can therefore answer two questions at once:

```text
Where is the symbol's physical record?
What is the symbol's current state?
```

## What the offset is relative to

The offset is not relative simply to `P`. Its anchor is the first possible name
byte after the count, vector array and first value word.

Conceptually:

```text
nameAnchor = P + 2 + 2*N + 2
```

The final `+2` skips the value word belonging to the first alphabetical record.

Then:

```text
nameAddress  = nameAnchor + (vector & $3FFF)
valueAddress = nameAddress - 2
```

The offset of the first name is therefore zero.

This choice saves every vector from having to include the two-byte value prefix
in its displacement. It also lets the resolver return a particularly useful
pair of addresses:

```text
DE   = first character of the name
DE-2 = low byte of the value
HL   = address of the vector high byte containing the flags
```

One resolution operation gives callers access to all three aspects of a symbol:
identity, value and state.

## Names are normalized

PROMETHEUS symbol names contain at most eight characters drawn from:

```text
letters
numbers
underscore
```

Letters are stored in uppercase. Thus:

```text
Loop
LOOP
loop
```

all refer to the same symbol.

`parseSymbolNameAndFindOrdinal` collects the temporary normalized spelling in
`numberStringBuffer+1` and stores its length in `numberStringBuffer`.

The relevant loop is:

```asm
parseSymbolNameAndFindOrdinal:
    ld de,numberStringBuffer+1
    ld b,000h
.collectNormalizedSymbolNameLoop:
    call atHLorNextIfOne
    call isNumber
    jr z,.storeNormalizedSymbolCharacter
    res 5,a
    cp "_"
    jr z,.storeNormalizedSymbolCharacter
    call isLetter
    jr nz,.finishNormalizedSymbolName
.storeNormalizedSymbolCharacter:
    ld (de),a
    inc de
    inc hl
    inc b
    ld a,b
    cp LABEL_LENGTH
    jr c,.collectNormalizedSymbolNameLoop
    jp syntaxError
```

`LABEL_LENGTH` is nine because reaching the ninth collected character triggers
the error. Eight characters are accepted.

When collection finishes, bit 7 is set on the temporary final character. This
makes the spelling compatible with the persistent high-bit-terminated format
used elsewhere in PROMETHEUS.

## Names have no stored length

A persistent name looks like:

```text
'L' 'O' 'O' ('P' | $80)
```

A reader masks bit 7 to obtain the visible final character and knows at the same
time that the name ends there.

This saves one length byte per symbol. It also means a scanner can skip a name
with a tiny loop:

```text
repeat:
    byte = *pointer++
until byte has bit 7 set
```

The count of symbols tells the program how many records exist. The high bit tells
it where each individual spelling ends.

## Looking up a name

Once the temporary spelling has been prepared, the routine searches the ordinal
vectors from the highest ordinal downward.

Why search vectors rather than the already alphabetical records? Because the
result required by source encoding is the ordinal. A direct alphabetical search
would find a record address and then require another search to discover which
vector points to it.

For each vector, the lookup performs this work:

```text
mask away DEFINED and LOCKED
add the offset to the current name anchor
compare temporary spelling with persistent high-bit-terminated name
if equal, return this ordinal
```

The real comparison loop is small because the temporary length is already
known:

```asm
.compareCandidateSymbolNameLoop:
    ld a,(de)
    cp (hl)
    jr nz,.candidateSymbolNameMismatch
    inc hl
    inc de
    djnz .compareCandidateSymbolNameLoop
```

The stored final character still has bit 7 set, and the temporary final
character was tagged the same way. Exact comparison therefore checks both the
characters and the length. `LOOP` cannot accidentally match `LOOP2`.

On success:

```text
carry clear
HL = one-based ordinal
```

On failure:

```text
carry set
temporary normalized spelling remains available for creation
```

This is a useful contract: the expensive normalization is not repeated when the
caller decides to create a new symbol.

## Resolving an ordinal

The opposite direction is handled by `resolveSymbolReferenceToName`.

Entry:

```text
DE = tagged two-byte ordinal from a source record
```

The routine:

1. clears the tag bit;
2. doubles the ordinal to locate its vector;
3. preserves the vector high-byte address;
4. masks DEFINED and LOCKED from the offset;
5. calculates the current name anchor from the current count;
6. adds the fourteen-bit offset.

Its contract is deliberately rich:

```text
HL = vector high-byte address
DE = symbol name address
DE-2 = symbol value address
```

Different callers use different parts.

The expression evaluator tests `(HL) & $C0` and then loads the value at `DE-2`.
The source expander copies the name beginning at `DE`. `TABLE L` and `TABLE U`
change flag bits in vector high bytes. Pass one writes a value and sets DEFINED.

One routine makes the whole table coherent.

## DEFINED does not mean “the name exists”

A name may exist in the table without currently having a valid value.

This happens naturally with forward references:

```asm
        JR LOOP
        ...
LOOP    RET
```

When the first line is entered, `LOOP` can be created as a symbol so the source
record can store its ordinal. But no assembler pass has yet reached the label
and assigned its address.

The vector therefore begins with both state flags clear:

```text
exists: yes
defined: no
locked: no
```

During pass one, when the label definition is encountered, PROMETHEUS writes the
current logical address into the value word and sets bit 6.

The distinction is:

```text
symbol identity may be known before symbol value is known
```

That is the foundation of forward references.

## LOCKED values survive differently

Bit 7 means LOCKED.

A locked symbol's stored value is treated as known even when the ordinary
DEFINED bit is not set. Expression evaluators accept a symbol when:

```text
(flags & $C0) != 0
```

so either flag is sufficient.

This supports a form of separate work. A programmer can preserve selected symbol
values across clearing or recompiling source. The exact workflow is controlled
by the `TABLE L`, `TABLE U` and `TABLE C` commands discussed in Chapter 24.

It is important not to read LOCKED as “the bytes cannot move.” The physical
record may still move when source or other symbols change. LOCKED protects the
meaning and stored value, not the address of the table record.

## Value words have no flags

Each alphabetical record begins with a plain two-byte value:

```text
value low
value high
```

The flags are not stored beside it. They live in the ordinal vector.

This separation has a consequence when displaying the table. PROMETHEUS walks
alphabetical records because that is the desired display order, but for each
record it must find the vector that points to that name in order to discover the
flags.

Thus table display performs a small reverse lookup:

```text
for each alphabetical symbol record:
    find vector whose masked offset selects this record
    read LOCKED and DEFINED from that vector
    format name and value
```

This costs time but saves redundant flag bytes and preserves the two-order
design.

## The TABLE display

The ordinary `TABLE` command shows forty symbols per page in two columns of
twenty.

A displayed row contains conceptually:

```text
lock marker
symbol name
value or undefined marker
```

The conventions are:

```text
'*'       symbol is locked
' '       symbol is not locked
'.....'   neither DEFINED nor LOCKED gives a usable value
number    value is known
```

The table can use decimal or hexadecimal number formatting according to the
current output mode.

The physical records already appear alphabetically, so the display traversal is
straightforward at that level. The extra vector search is needed only for flags.

The screen driver clears the table rows, renders a left column, renders a right
column, then waits for a key:

```text
SPACE      leave table display
other key  advance to next page
```

`TABLE P` uses the same broad traversal while also routing each formatted entry
to the printer path.

## A small worked example

Suppose the programmer first types lines mentioning symbols in this order:

```text
LOOP
SCREEN
ALPHA
```

The ordinals become:

```text
1 = LOOP
2 = SCREEN
3 = ALPHA
```

Now suppose the values are:

```text
LOOP   = $8010
SCREEN = $4000
ALPHA  = $8000
```

The table can be pictured as:

```text
count = 3

ordinal vectors:
    [1] offset of LOOP   + flags
    [2] offset of SCREEN + flags
    [3] offset of ALPHA  + flags

alphabetical records:
    $8000, ALPHA
    $8010, LOOP
    $4000, SCREEN
```

A source record containing ordinal 1 always means `LOOP`, even though the
physical record for `LOOP` may shift when `ALPHA` is inserted before it.

When the new earlier name is inserted, the vector for `LOOP` is adjusted to its
new physical offset. The source ordinal remains 1.

This is precisely the problem indirection solves.

## Why not store direct pointers?

Imagine that every source reference stored the address of a symbol record.

Then inserting one source line would move the complete table and require finding
and rewriting every symbol reference in the source. Adding one alphabetically
earlier symbol would move later records and require another rewrite. Loading a
saved source package at a different address would invalidate all references.

Ordinals avoid those problems:

```text
source record stores stable identity
vector translates identity to current location
```

The vectors themselves do need repair when physical records move, but there is
only one vector per symbol. A symbol used fifty times still requires only one
updated offset.

This is the same broad idea used in many later systems:

- object handles;
- file-descriptor tables;
- relocation tables;
- indexes into string pools;
- virtual addresses translated to physical addresses.

PROMETHEUS uses it in a particularly compact form.

## Why not keep records in ordinal order?

If records were kept in ordinal order, source resolution would be easy, but
alphabetical table display and name comparison would be less convenient.

If ordinals were simply alphabetical positions, adding `ALPHA` before `LOOP`
would change every later ordinal and force the whole compressed source to be
rewritten.

The chosen design separates:

```text
stable order of identity      = ordinal vectors
changeable order of spelling  = alphabetical records
```

A new vector is appended, preserving existing identities. Its physical record
is inserted alphabetically, preserving readable order.

Chapter 24 will show the careful offset repairs needed to make that possible.

## The table base itself moves

There are two levels of movement to keep separate.

### Whole-table movement

Editing compressed source changes the address stored in `varcSymbolTablePt+1`.
The complete table moves together. Relative vector offsets remain valid because
both the vectors and records moved by the same amount.

### Internal record movement

Creating or deleting a symbol changes positions *inside* the table. Some vector
offsets must then be adjusted because the vectors and name records do not all
move equally.

This distinction explains why source insertion can use general pointer repair,
while symbol insertion requires specialized vector repair.

## The end pointer

`varcCodeEndPt+1` points at the first unused byte above the combined source and
symbol storage.

It is used for:

- checking whether new data fit below U-TOP;
- calculating move lengths when gaps are opened or closed;
- finding the end of table data;
- clearing bytes released by deletion;
- preventing packed regions from colliding with user memory.

Despite the name `CodeEnd`, this boundary belongs to the resident editor's
source-and-symbol storage, not merely to emitted machine code. The reconstructed
label reflects the original program's reused concepts and historical layout.

## In plain pseudocode

Resolving an ordinal:

```text
function resolveSymbol(ordinal):
    ordinal = clearSourceTag(ordinal)

    vectorAddress = symbolTableBase + 2 * ordinal
    vector = readWord(vectorAddress)

    flags = highByte(vector) & $C0
    offset = vector & $3FFF

    count = readWord(symbolTableBase)
    nameAnchor = symbolTableBase + 2 + 2*count + 2
    nameAddress = nameAnchor + offset

    return {
        flagsAddress: vectorAddress + 1,
        flags: flags,
        nameAddress: nameAddress,
        valueAddress: nameAddress - 2
    }
```

Looking up a name:

```text
function findSymbolOrdinal(sourceText):
    temporaryName = normalizeUppercase(sourceText, maximumLength=8)
    markLastCharacterWithBit7(temporaryName)

    for ordinal from symbolCount down to 1:
        symbol = resolveSymbol(ordinal)
        if bytesEqual(temporaryName, symbol.name):
            return ordinal

    return notFound
```

Displaying the table:

```text
for each physical symbol record in alphabetical order:
    vector = findVectorThatPointsTo(record.name)

    print '*' if vector is LOCKED else ' '
    print symbol name

    if vector is DEFINED or LOCKED:
        print record.value
    else:
        print '.....'
```

## What has changed in memory

Merely looking up or resolving a symbol does not change persistent bytes.

Creating source references may already have created undefined symbols, so at the
point described in this chapter the table contains:

- a two-byte symbol count;
- one two-byte vector per ordinal;
- one alphabetically sorted value/name record per symbol;
- zero value placeholders for names not yet defined;
- DEFINED and LOCKED state in vector high bytes;
- no direct source pointers to names.

During table display, temporary screen buffers and self-modified display
positions change, but the table itself remains intact.

## Important labels encountered

- `varcSymbolTablePt`
- `varcCodeEndPt`
- `parseSymbolNameAndFindOrdinal`
- `resolveSymbolReferenceToName`
- `varcSymbolEntryAreaBase`
- `numberStringBuffer`
- `displaySymbolTableColumn`
- `varcEndOfSymbolTable`
- `invokeTable`
- `varcSymbolVectorFlagInstruction`

## Back to the bigger picture

The expression pipeline from Chapter 22 can now be expanded:

```text
symbol spelling in source
    ↓
normalized uppercase name
    ↓
stable one-based ordinal
    ↓
tagged ordinal stored in compressed record
    ↓
vector lookup during assembly
    ↓
DEFINED/LOCKED test
    ↓
value loaded from alphabetical record
```

The table structure explains how forward references survive and why source can
move freely. It does not yet explain how a new alphabetically sorted record is
inserted without changing old ordinals, or how unused symbols can be removed
when removing one vector *does* shift later ordinals.

Those are the harder maintenance operations. Chapter 24 follows a symbol from
creation through locking, marking, deletion and complete source-reference
repair.
