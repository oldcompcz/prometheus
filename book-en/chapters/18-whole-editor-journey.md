# Chapter 18: The Whole Editor Journey

We have examined the editor in layers:

- keyboard scanning;
- command tokens;
- the editable line;
- compressed source records;
- text-to-record parsing;
- record-to-text expansion;
- source navigation;
- memory insertion and deletion;
- block commands and continuing searches.

It is time to put those layers back together.

This chapter introduces no major new data structure. Instead, it follows one
small editing session from the user's fingers to the moving packed source area
and back to the screen. The goal is to replace a collection of routine names
with one continuous mental picture.

Our running program is:

```asm
        ORG 32768
START   LD B,5
LOOP    DJNZ LOOP
        RET
        ENT START
```

At this stage we care about how the editor stores and changes it. The assembler
meaning of `ORG`, `ENT`, labels and opcodes will be developed in Part III.

## Before the first key

After cold start, the dynamic source area already contains twenty valid empty
records:

```text
13 top-padding records
1 access-line record
6 bottom-padding records
```

The active pointer names `sourceBufferAccessLine`. Both selected-block pointers
also begin there. The symbol table follows the source and contains a zero entry
count.

The screen is not a memory dump of these records. `renderVisibleSourceRecords`
walks thirteen records backward from the active pointer, expands twenty records
one at a time into `lineBuffer`, and draws their textual forms.

Every visible source row is empty, but the editor is already using its final
navigation algorithm.

## Entering `ORG 32768`

The user types characters on the Spectrum keyboard.

For each keypress:

```text
ROM keyboard service identifies a key
PROMETHEUS normalizes shifts and CAPS LOCK
printable character is inserted before the $01 cursor marker
cursor marker moves right
edit row is redrawn
```

The temporary buffer eventually contains the visible text plus one movable
marker and a zero-filled tail.

When ENTER is pressed, `updateInputBuffer` reports a complete line. The main
loop hides the edit row and inspects the first significant byte.

It is ordinary source text, not a command token, so control goes to
`parseAndInsertSourceLine`.

## The parser creates meaning before storage

The encoder separates fields, normalizes spelling, looks up the pseudo-operation
and validates its operand.

It constructs a staged record with:

- opcode/pseudo-opcode identifier;
- information bits;
- encoded expression for `32768`;
- variable-record terminal marker;
- one leading copy-count byte outside the persistent record.

At this point the source has not changed. The parser has prepared a complete
candidate in temporary workspace.

This transactional ordering is important:

```text
validate first
move persistent memory only after success
```

A syntax error returns to the editor with the existing source intact.

## The first insertion

The editor asks for the record after the active empty line. That address becomes
the insertion point.

`insertByteRangeAtHLFromDE`:

1. checks U-TOP;
2. shifts the remaining empty source records and empty symbol table upward;
3. advances `varcSymbolTablePt` and `varcCodeEndPt`;
4. repairs selected-block pointers if they lie at or above the gap;
5. copies the staged `ORG` record into the gap.

The caller then makes the new record active.

The packed source now resembles:

```text
13 upper empty records
original access-line empty record
ORG record              ← active
remaining lower empties
symbol table
```

A warm start rebuilds the visible window. The newly expanded `ORG 32768` line
appears on the access row.

## Entering the remaining lines

Each following source line repeats the same broad journey:

```text
keys
→ input buffer
→ field parser
→ mnemonic/operand lookup
→ staged compressed record
→ gap insertion after active record
→ new record becomes active
→ screen reconstructed
```

For `START LD B,5`, the parser also encounters the label `START`. It obtains or
creates a compact symbol ordinal and stores that ordinal in the compressed
record instead of repeating the full spelling.

For `LOOP DJNZ LOOP`, the same name appears as both a definition and an operand
reference. The detailed symbol-table lifecycle belongs to Chapters 23 and 24,
but the editor-facing fact is already clear:

```text
visible name LOOP
    ↕
small ordinal inside source records
    ↕
persistent symbol-table entry containing the spelling
```

`RET` can use a short fixed record. `ENT START` uses a pseudo-operation record
with an encoded symbol reference.

Record lengths differ, but navigation does not care. It reads each record's own
header and terminal marker.

## What the source looks like physically

A simplified view might be:

```text
$....  empty padding record
$....  empty access record
$....  ORG record                 variable length
$....  START / LD B,5 record      variable length
$....  LOOP / DJNZ LOOP record    variable length
$....  RET record                 fixed or short structured form
$....  ENT START record           variable length
$....  empty tail records
$....  symbol-table count
$....  symbol vectors
$....  symbol names and values
$....  protected end tail
```

There are no newline characters separating these records. Their own structure
provides forward and backward travel.

There is also no screen-format text stored beside them. Text is reconstructed
when needed.

## Moving up to edit `LD B,5`

The user presses the up-arrow key several times.

Each move:

```text
loads active record pointer
uses previous record's final byte as a back-link
checks earliest legal active position
stores candidate pointer
scrolls bitmap or repaints source window
```

When `START LD B,5` becomes active, pressing EDIT expands that compressed record
into canonical text.

The path is the inverse of source entry:

```text
record header
→ label ordinal resolved to START
→ instruction descriptor resolved to LD
→ operand descriptors expanded to B and 5
→ fields written to lineBuffer
→ text copied to editable input buffer
→ $01 cursor marker installed
```

The user sees source, not ordinals and table indexes.

## Changing 5 to 8 manually

Suppose the user moves the cursor left, deletes `5`, types `8`, and presses
ENTER while OVERWRITE mode is active.

The new text is parsed from the beginning. PROMETHEUS does not try to patch the
old numeric expression byte in place.

The commit sequence is:

```text
encode new LD B,8 record
insert it after old LD B,5 record
make new record active
step back to old record
delete old record
new record slides into old position
restore default INSERT mode
warm start
```

Even if the encoded length changes, the same process works.

The visible operation is “replace this line.” The memory operation is “insert a
new valid record, then remove the old one.”

## Finding `LOOP`

The user enters:

```text
FIND s:loop
```

The first byte is a command token, so submission follows `commandHandlerTable`
instead of the source parser.

FIND:

```text
stores lowercase pattern "loop"
sets whole-source scope
places scan cursor before first real record
advances one record at a time
expands each into lineBuffer
matches visible characters while skipping $01 separators
```

The first successful record might be the definition line:

```asm
LOOP    DJNZ LOOP
```

That compressed record becomes active. A warm start places it on the access row.

Notice how many representations cooperate:

- the command line is tokenized editor input;
- the search pattern is length-prefixed lowercase text;
- the source is compressed semantic records;
- each candidate is expanded into canonical line text;
- matching ignores formatting markers;
- success is returned through carry;
- the record pointer becomes editor state.

No representation is forced to do another representation's job.

## Replacing one value through the command path

Suppose the user first finds `5` on the `LD B,5` line and enters:

```text
REPLACE :8
```

REPLACE expands the active record, performs textual substitution while building
a normal input line, and sends that line through the same parser used for manual
editing.

The commit is therefore the same OVERWRITE journey described above. The only
new element is the post-command continuation, which resumes FIND after the
parser has returned.

Manual editing and command replacement converge before persistent source
changes:

```text
manual keys ───────────────┐
                           ├→ inputBuffer → parser → staged record → commit
REPLACE reconstruction ────┘
```

This convergence is one of the editor's strongest design decisions. It keeps
validation and source encoding in one place.

## Marking a block

To select the two middle lines, the user visits one endpoint and presses the
block-margin key, then visits the other endpoint and presses it again.

The special key operation shifts the old upper boundary into the lower slot and
stores the current active record as the new upper boundary.

After normalization, the block might be:

```text
low  = LOOP / DJNZ LOOP
high = RET
```

The records themselves are unchanged. During repaint,
`testSourceRecordOutsideSelectedBlock` identifies records inside the inclusive
address range and places a temporary marker in `lineBuffer` before rendering.

Selection exists in editor state and on screen, not in persistent source bytes.

## Copying the block

The user moves the active line to `ENT START` and invokes COPY.

COPY:

```text
normalizes block endpoints
advances once past RET
computes selected byte count
verifies insertion point is not strictly inside selection
opens a gap before ENT START
corrects source pointer if gap movement relocated original block
copies exact compressed bytes into gap
```

The result is physically:

```asm
        ORG 32768
START   LD B,8
LOOP    DJNZ LOOP
        RET
LOOP    DJNZ LOOP      ; copied bytes, same symbol ordinals
        RET
        ENT START
```

The editor does not object that `LOOP` is now defined twice. COPY is a structural
editor operation. Duplicate-label diagnosis belongs to the assembler.

This boundary between responsibilities is healthy:

```text
editor asks: are these valid source records and is memory structurally sound?
assembler asks: does the complete program have valid definitions and meanings?
```

## Deleting the copied block

After marking the duplicate two-line range, the user invokes DELETE. The original
selection remained on the original records after COPY; selection follows moved
bytes, but COPY does not automatically select the new duplicate.

DELETE counts the two records, compacts all later source and symbol bytes
downward, clears the freed tail, and restores any required empty records.

It then chooses the nearest surviving line, collapses both block pointers onto
it, and makes it active.

The source returns to:

```asm
        ORG 32768
START   LD B,8
LOOP    DJNZ LOOP
        RET
        ENT START
```

The screen is reconstructed from the repaired record chain. There is no stale
selection marker because block state was explicitly reset.

## Printing the program

PRINT does not walk screen rows. It walks compressed records from the source
start.

For each record:

```text
expand to lineBuffer
open/use channel 3
emit visible canonical text
emit carriage return
continue
```

A block-only option asks the same scanner to filter candidates through the
selected-block helper.

The source on paper or external output is therefore regenerated from semantic
records, just like the source on screen.

## The screen is always a projection

Throughout the session, screen text has repeatedly disappeared and been rebuilt.
That is not a loss of data because the screen is not the primary source model.

The direction of authority is:

```text
persistent compressed records
        ↓ expansion
lineBuffer
        ↓ rendering
Spectrum bitmap and attributes
```

The edit line is a temporary exception. While the user types, `inputBufferStart`
is the active human-readable workspace. It becomes authoritative only after the
parser has validated and committed a new record.

This model prevents a common class of editor bugs: there is no need to keep a
screen line, an editable line, and a stored text line synchronized as three
long-lived copies.

## The symbol table moves even when symbols do not change

Adding, copying or deleting source shifts the symbol table because it is packed
after source records.

This can happen even when the logical set of symbols is unchanged. COPY, for
example, duplicates source records that use existing ordinals. The table's
bytes move upward, but its entry count and names may remain identical.

That is why `varcSymbolTablePt` is part of every structural insertion/deletion.
The editor must follow the physical table even when symbol semantics have not
changed.

Part III will show that the table itself contains two related layouts—ordinal
vectors and alphabetically arranged entries. For now, the key point is that the
whole structure moves as one suffix.

## Error paths preserve the old source

Several operations can fail before commit:

- a source line has invalid syntax;
- a number is too large;
- a mnemonic/operand combination is unknown;
- a replacement would exceed 31 visible characters;
- an insertion would cross U-TOP;
- COPY's destination lies inside the selected range.

The code is arranged so these failures occur before—or at a controlled boundary
inside—the persistent mutation.

The parser completes its staged record before insertion. U-TOP is checked before
shifting bytes. COPY validates its destination before opening a gap. REPLACE
builds a bounded input line before submitting it.

When an error path returns to the editor, the source-chain invariants remain
valid.

## A compact pseudocode model of the editor

We can now describe the editor without Z80 register detail:

```text
initialize:
    active = permanent access record
    selection = active..active

main loop:
    render twenty source records around active
    render status and edit line
    key = read normalized key

    if key navigates:
        candidate = adjacentRecord(active)
        if candidate preserves display padding:
            active = candidate
        continue

    if key edits temporary line:
        mutate inputBuffer and cursor marker
        continue

    if key submits ordinary source:
        staged = parseAndEncode(inputBuffer)
        insert staged after active
        active = staged record
        if overwrite:
            delete previous record
        continue

    if key submits command:
        dispatch command token
        command may scan, expand, insert, delete, print or change state
        continue
```

This model omits many useful details, but it captures the editor's heartbeat.

## The top-down, bottom-up, top-down spiral

At the beginning of Part II, the editor looked like a simple loop:

```text
draw
read key
perform action
repeat
```

We then descended into:

- ROM keyboard reports;
- command tokens;
- an in-band cursor marker;
- compact record headers;
- instruction and operand descriptors;
- symbol ordinals;
- back-link markers;
- overlap-safe memory movement;
- self-modified pointers;
- callback-driven scans.

Now we can return to the simple loop without treating it as magic.

“Perform action” might mean moving one record pointer. It might mean expanding a
record, rebuilding an editable line, parsing it, moving the whole symbol table,
and deleting an old record. It might mean changing one callback address and
letting a generic scanner print the complete source.

The visible editor remains coherent because all those mechanisms agree about a
few invariants.

## The editor's central invariants

At every ordinary warm start:

```text
1. activeLine points to the first byte of a valid source record
2. selectedBlockStart and selectedBlockEnd point to valid record starts
3. source records are packed with no gaps
4. every variable record has a valid terminal/back-link marker
5. symbolTablePt points immediately after the source region
6. codeEnd bounds the live combined source/symbol area
7. thirteen valid padding records exist above the earliest active line
8. six valid records remain below the latest active line
9. inputBuffer contains one movable cursor marker when being edited
10. lineBuffer is temporary and may be rebuilt at any time
```

Individual routines are short because they can trust these conditions.

`getPreviousSourceRecord` does not search for corruption. The insertion routine
does not ask whether `HL` is a record boundary. The renderer does not test for a
missing thirteenth predecessor. The design relies on every writer preserving the
shared format.

## What the editor does not yet explain

The editor can store:

```asm
LOOP    DJNZ LOOP
```

but we have not yet fully answered:

- how `LOOP` receives a numeric value;
- how a forward reference remains unresolved in pass one;
- how `DJNZ` is found in the instruction table;
- how the relative displacement is calculated;
- how errors are attached to source records;
- where final machine-code bytes are written.

Those questions belong to Part III.

The transition is natural. The editor has already converted human source into a
compact semantic form. The assembler can operate on that form without parsing
the screen text again.

## One final journey: key to persistent record and back

Let us condense everything into one cycle.

The user types:

```asm
LOOP    DJNZ LOOP
```

### Downward journey

```text
physical keys
→ ROM key code
→ normalized printable characters
→ inputBuffer with cursor marker
→ field parser
→ mnemonic and operand descriptors
→ symbol ordinal for LOOP
→ staged compressed record
→ U-TOP capacity check
→ packed suffix shifted upward
→ record copied into source
→ active pointer updated
```

### Upward journey

Later the editor needs to display the same line:

```text
active compressed record
→ header and payload decoding
→ symbol ordinal resolved to LOOP
→ mnemonic descriptor resolved to DJNZ
→ operand expression expanded
→ canonical lineBuffer
→ selection marker added if needed
→ glyph renderer writes Spectrum bitmap
```

The text seen by the user is reconstructed from meaning that was compressed at
entry time.

That is the central achievement of the PROMETHEUS editor. It is not merely a
text box attached to an assembler. It is a compact structured-source database,
a renderer, a parser, and a moving-memory manager designed as one system.

## What has changed during the complete session?

By the end of the example:

- five meaningful compressed source records exist between permanent padding;
- `START` and `LOOP` have symbol ordinals and table entries;
- the active pointer has moved through several records;
- selected-block pointers have been set, followed moved bytes, and later
  collapsed after deletion;
- the source region has grown and shrunk several times;
- the symbol table has moved physically with it;
- `lineBuffer` has been rebuilt repeatedly;
- `inputBuffer` has served manual editing and REPLACE;
- printed source has been regenerated through the same expansion path;
- the final screen is only the latest projection of the persistent records.

## Important ideas carried into Part III

- source entry performs semantic compression before persistent commit;
- the assembler receives already classified records, not raw screen text;
- symbol names in records are represented by ordinals;
- source records can be traversed independently of their textual length;
- pseudo-operations and machine instructions share one record stream;
- source memory and the symbol table form one moving packed region;
- callbacks and self-modified operands provide compact reusable workflows;
- errors should be detected before structural mutation whenever possible;
- editor validity is expressed as shared invariants rather than defensive checks
  in every routine;
- the next stage is to turn semantic source records into addresses and bytes.

## Source anchors revisited

- `startPrometheus`
- `prometheusWarmStart`
- `processKey`
- `updateInputBuffer`
- `submitInputLineOrDispatchCommand`
- `commandHandlerTable`
- `encodeInputLineToSourceRecord`
- `encodedRecordStorageLength`
- `parseAndInsertSourceLine`
- `varcInsertMode`
- `insertByteRangeAtHLFromDE`
- `deleteSourceLinesAtHL`
- `deleteSourceLinesAndRestoreTailPadding`
- `varcSourceBufferActiveLine`
- `getNextSourceRecord`
- `getPreviousSourceRecord`
- `expandSourceRecordToLineBuffer`
- `lineBuffer`
- `inputBufferStart`
- `varcSelectedBlockStart`
- `varcSelectedBlockEnd`
- `invokeFind`
- `invokeReplace`
- `invokeCopy`
- `invokeDelete`
- `invokePrint`
- `varcSymbolTablePt`
- `varcCodeEndPt`
