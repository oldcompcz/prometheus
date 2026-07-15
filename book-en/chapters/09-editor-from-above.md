# Chapter 9: The Editor from Above

We are now ready to enter the first major subsystem in detail.

The source editor is a good place to begin because its purpose is visible. A user sees source lines, an active line, a separate edit row, a status message, and immediate movement in response to keys. Behind that simple surface, PROMETHEUS is coordinating several very different representations:

- compressed source records in memory;
- one expanded 32-character display line;
- one editable input buffer containing a cursor marker and tokens;
- selected-block boundaries stored as addresses;
- screen bitmap rows and attributes;
- a moving source/symbol boundary;
- self-modified pointers that remember the current editor state.

This chapter gives a top-down account of that coordination. We will not yet decode every key or every source-record byte. Those details belong to the next several chapters. Our goal is to understand the editor's **flow**: how it starts, what its main loop does, which operations cause a complete redraw, and which operations take faster paths.

## The editor is not a conventional full-screen text file

A conventional editor might keep one character array for the entire document and draw a cursor inside it.

PROMETHEUS instead separates three things:

```text
persistent source    compressed records
visible source       expanded lines drawn on screen
current edit line    temporary token/character buffer
```

The source listing is not directly editable in place. To change a line, PROMETHEUS expands one compressed record into the edit buffer. The user changes that temporary representation. Pressing ENTER parses it again and replaces or inserts a compressed record.

This round trip is central:

```text
compressed record
    → expanded edit text
    → user changes
    → parser
    → new compressed record
```

It allows the persistent source to remain compact while the user interacts with readable text.

## The visible layout has different jobs

The editor screen can be thought of as several horizontal zones.

### Source window

Twenty source records are expanded and displayed around the active access line. The active line is not necessarily the first or last visible record. PROMETHEUS tries to keep context above and below it.

### Access or edit row

The bottom editor row contains `inputBufferStart`, rendered with a movable cursor marker. This is where new source or a command is composed.

### Status row

The status line shows:

- a message such as the copyright text, an error, or “Wait please”;
- insert/overwrite mode;
- the current high end of source and symbols;
- `U-TOP`;
- numbers in the selected decimal or hexadecimal form.

### Selection indication

A source line inside the remembered block receives a special marker. The marker is drawn from character code `$03`, whose glyph on the original 48K ROM appears as a solid block because it points into a ROM region filled with `$FF` bytes. This is clever but hardware-dependent; another ROM may display a different shape.

These zones share low-level rendering code but have different state and colour rules.

## Two entry points reach the same editor

The complete installation has an entry at `ENTRY_POINT_WITH_MONITOR`. The assembler-only suffix begins at `ENTRY_POINT_WITHOUT_MONITOR`.

The assembler-only entry is very small:

```asm
ENTRY_POINT_WITHOUT_MONITOR:
    jp startPrometheus
```

The full monitor can also leave its interface and return to `startPrometheus`.

Thus the editor's cold resident entry is shared:

```text
full installation → monitor/editor choice → startPrometheus
assembler-only installation              → startPrometheus
return from monitor                       → startPrometheus
```

The installer patches a few addresses for assembler-only mode, but the editor itself does not need a second implementation.

## Cold start clears the machine-owned display

The editor begins:

```asm
startPrometheus:
    di
    ld e,SEPARATOR_CHARCODE
    call clearDisplay
```

Interrupts are disabled, and the complete screen is filled through the internal character renderer.

The separator character is `~`, not an ordinary blank. In the configured font and interface, this establishes the editor's initial visual background. `invokeRun` later uses `clearDisplayToSpaces` before handing control to assembled user code.

After the display is initialized, execution falls directly into `prometheusWarmStart`.

There is no `CALL`. The labels describe progressively warmer restart points in one continuous routine.

## Three warm-start levels

PROMETHEUS has several entry labels because different operations want to preserve different amounts of state.

### `prometheusWarmStart`

This is the fullest editor reset short of reinstalling the program.

It:

- restores the highlighted access-line attributes;
- chooses the default status message;
- clears shared work buffers;
- recreates the edit buffer's cursor marker and guard byte;
- resets the internal stack;
- redraws visible source;
- enters the key loop.

### `prometheusWarmStartWithMessage`

This entry begins with the message already chosen in `A`.

An error or completed operation can therefore display a specific status while still clearing transient editor buffers and rebuilding the screen.

### `prometheusWarmStartWithCurrentBuffers`

This preserves the current edit/work buffers. It resets the stack, redraws source, and resumes the input loop.

Navigation uses this warmer path. Moving up or down should not necessarily destroy the current input line.

The three labels form a useful hierarchy:

```text
warm start
    reset message, attributes, buffers, stack, listing

warm start with message
    keep chosen message; reset buffers, stack, listing

warm start with current buffers
    keep buffers; reset stack and listing
```

This is smaller than three separate routines because later entry points are simply labels farther down the same instruction sequence.

## Why every warm start resets the stack

At `prometheusWarmStartWithCurrentBuffers`:

```asm
ld sp,internalStackTop
call renderVisibleSourceRecords
```

Setting `SP` abandons whatever internal call chain led to the warm start.

Many handlers do not carefully unwind every temporary stack item on every abort path. Instead they jump to a known restart label. Reinitializing `SP` makes that safe.

This resembles restarting a small event loop after an exception:

```text
forget partial nested operation
restore known top-level stack
redraw consistent interface
accept next command
```

It is one reason warm-start labels are important control-flow destinations rather than ordinary subroutines.

A routine that jumps there must not expect to return.

## The active source line is an instruction operand

The source record around which the listing is drawn is remembered here:

```asm
varcSourceBufferActiveLine:
    ld hl,sourceBufferAccessLine
```

Changing the active line means rewriting the immediate word of this `LD HL,...` instruction:

```asm
ld (varcSourceBufferActiveLine+1),hl
```

The active line is therefore persistent editor state and executable code at the same time, as discussed in Chapter 5.

The initial value points to `sourceBufferAccessLine`, a permanent low-address anchor inside the source area.

Immediate navigation, block selection, delete, copy, source import, and command handlers all consult or change this pointer.

## Drawing the visible source window

`renderVisibleSourceRecords` begins with the active line, walks backward thirteen records, and then renders forward until the screen window is full.

The first steps are:

```asm
varcSourceBufferActiveLine:
    ld hl,sourceBufferAccessLine
    ld b,LINES_BEFORE_ACCESS_LINE
.findTopVisibleSourceRecordLoop:
    call getPreviousSourceRecord
    djnz .findTopVisibleSourceRecordLoop
```

The source format supports constant-time backward movement because a variable record ends with a marker containing its variable length. Chapter 15 will explain that format in detail.

Once the top visible record is found, the routine sets the first bitmap row and repeats:

```text
clear destination row
expand and render current record
advance to next record
advance one text row on screen
```

The loop stops after twenty records.

The active line remains the conceptual centre. The top pointer is only a temporary rendering cursor.

## Rendering does not alter compressed source

For each record, `renderSourceRecord` expands it into `lineBuffer`.

If the record belongs to the selected block, it places marker byte `$03` at `lineBufferMarkerPosition`.

Then `printExpandedSourceLineWithRoutine` scans the expanded line and sends visible characters to a callback.

The callback is normally `displayCharacterSafely`, but the same scanner can be redirected to:

- printer output;
- FIND processing;
- other line consumers.

The source record itself remains unchanged.

This gives a useful pipeline:

```text
compressed source record
    ↓
lineBuffer with internal separators
    ↓
shared scanner
    ↓
selected output callback
```

The editor display is only one destination.

## Field separators are not visible characters

Expanded source contains internal byte `$01` between formatted fields. The output scanner skips it:

```asm
ld a,(hl)
inc hl
dec a
jr z,.readNextExpandedSourceCharacter
inc a
ret z
```

The first `DEC A` maps `$01` to zero. If so, the scanner loops without output.

Restoring `A` with `INC A` then maps the real zero terminator back to zero, which ends the line.

This compact pair distinguishes:

```text
$01 → formatting separator, skip
$00 → line terminator, stop
other → visible character, continue
```

The separator allows expansion code to preserve field structure without displaying extra control symbols.

## Source case changes outside quotes only

PROMETHEUS can display source in configured upper or lower case, but text inside quotes must remain unchanged.

The shared scanner counts quote characters in `C` and tests its low bit:

```text
even number of quotes seen → outside a quoted literal
odd number of quotes seen  → inside a quoted literal
```

Outside quotes, letters pass through the configured case-transform instruction. Inside quotes, they go directly to output.

This is a small but important correctness detail. The source:

```asm
DEFM "Hello"
```

may be displayed with `DEFM` changed to the chosen source case, while `Hello` remains the literal the programmer entered.

## The main loop has a stable heartbeat

After rendering the source window, PROMETHEUS enters `.readInputLineLoop`:

```asm
.readInputLineLoop:
    call repaintEditLine
    call setBorderColor
    call processKey
    push af
    ld a,MESSAGE_COPYRIGHT
    call printStatusBar
    ...
    pop af
```

The rhythm is:

```text
1. repaint edit line
2. restore normal border
3. wait for one normalized key
4. refresh status line
5. dispatch the key
6. repeat or warm-start
```

The accepted key is preserved on the stack while the status bar is drawn.

`varcLastStatusBarMessage` remembers which message should be used. After normal input it is reset to the default copyright message, so an error or special status does not remain forever.

This main loop is the editor's top-level control centre.

## Some keys act immediately

The key does not always enter the edit buffer.

The main loop first checks several editor controls:

- clear the current edit line;
- expand the active source record for editing;
- toggle insert/overwrite mode;
- move one page;
- move one line;
- delete the active line;
- set a block boundary.

Only if none of these matches does the key go to `updateInputBuffer`.

This order matters. Arrow keys, EDIT, block marks, and page movement are editor actions, not text characters.

A command such as `ASSEMBLY` is different. It is entered into the edit line as a token and dispatched only after ENTER.

So there are two command layers:

```text
immediate control keys
    handled directly by main loop

written command line
    tokenized in input buffer, submitted with ENTER
```

## Editing the active record

The EDIT shortcut selects the current compressed record and expands it into `inputBufferStart`:

```asm
ld ix,(varcSourceBufferActiveLine+1)
ld hl,inputBufferStart
...
call expandSourceRecordToHL
ld a,001h
ld (varcInsertMode+1),a
```

The buffer is cleared first. Expansion creates readable source text and places the cursor marker in the editable representation.

The insert-mode flag is set to the value used for replacement. When the user later submits the line, the old compressed record is deleted and replaced by the newly encoded one.

This is why “edit existing line” and “enter new line” can share the same text parser. Their difference is the insertion mode and chosen destination.

## Insert and overwrite are editor policies

`varcInsertMode` stores the current submission policy in an instruction operand.

The status bar displays either:

```text
I   insert
O   overwrite
```

After a submission, `restoreInsertModeAndContinue` clears the flag back to its default.

The exact numeric convention is less important than the semantic distinction:

- insert keeps the existing active record and adds a new record after it;
- overwrite removes the appropriate old record as part of replacing an edited line.

Later chapters will trace the parser and insertion calls precisely.

## Page movement reuses line movement

For a page command, the editor sets `B` to twenty and repeatedly calls the one-record movement routine:

```asm
ld b,014h
.nextPageAdvanceLoop:
    call moveActiveLineToNextSourceRecord
    djnz .nextPageAdvanceLoop
```

This is a simple design. There is no separate “find record twenty lines later” algorithm.

Boundary handling remains centralized in `moveActiveLineToNextSourceRecord` and `moveActiveLineToPreviousSourceRecord`.

If movement reaches an invalid position, the movement helper redirects to a warm redraw without committing the bad pointer.

The page loop therefore composes a trusted smaller operation.

## Single-line movement has a fast visual path

A newly accepted down-arrow first advances the active record. Then it scrolls existing bitmap rows and draws only the new bottom source line.

The source routine roughly performs:

```text
move active pointer one record down
copy visible bitmap rows upward
clear new bottom row
walk six records below active line
render that record at bottom
sample physical down key
repeat while held
```

The up-arrow mirrors this operation.

Why walk six or thirteen records from the active line? Because the access line is placed asymmetrically inside the visible source window. The renderer and fast scroller must agree about which record belongs in the newly exposed edge row.

The exact constants are layout knowledge. Their purpose is to keep the active record in the same visual position while context moves around it.

## Fast scrolling bypasses the normal main-loop repeat

`processKey` already implements general key autorepeat. The arrow handlers add an even faster path for source scrolling.

After shifting and drawing one row, they read the relevant keyboard matrix row directly. As long as the physical arrow key remains held, they perform another source movement and bitmap shift without returning through full edit-line repaint and status processing.

This is an optimisation for the operation most visibly affected by delay.

Once the key is released, control returns to `.readInputLineLoop`, where the complete interface is refreshed.

## Deleting the active line

The immediate delete shortcut requests one compressed record:

```asm
ld bc,00001h
ld hl,(varcSourceBufferActiveLine+1)
call deleteSourceLinesAndRestoreTailPadding
```

After deletion, the editor tries to select the previous surviving record unless the deleted record was at the permanent source start.

Then it commits that survivor as the active line and redraws.

The low-level deletion routine from Chapter 7 moves bytes and repairs storage pointers. The editor-level code decides what the user should see afterward.

This division is worth remembering:

```text
storage routine → preserve memory structure
editor handler  → preserve understandable interaction
```

## Selecting a block remembers two source addresses

The block-boundary key shifts the previous upper boundary into the lower boundary, then stores the active line as the new upper boundary:

```asm
ld hl,(varcSelectedBlockEnd+1)
ld (varcSelectedBlockStart+1),hl
ld hl,(varcSourceBufferActiveLine+1)
ld (varcSelectedBlockEnd+1),hl
```

The user can therefore mark two positions in sequence.

`getSelectedBlock` later normalizes them so commands do not care which was chosen first.

The selected range is represented by record addresses, not line numbers. When insertion or deletion moves source bytes, the pointer-repair machinery from Chapter 7 keeps these boundaries connected to the intended records.

## Ordinary keys mutate the edit buffer

Keys not handled immediately enter `updateInputBuffer`.

Its return convention is deliberately based on the zero flag:

```text
Z set   → ENTER was pressed; submit the line
Z clear → buffer changed or key ignored; repaint and continue
```

The main loop does:

```asm
call updateInputBuffer
jr nz,.repeatInputLineLoopFar
```

If no complete line was submitted, it returns to repaint the edit row.

If ENTER produced zero, execution falls into `submitInputLineOrDispatchCommand`.

Chapter 11 will explain cursor movement, insertion, deletion, tabulation, and the byte-swap chain inside `updateInputBuffer`.

## Submission first hides the edit row

Before parsing, PROMETHEUS fills the edit-line attributes with a configured value that makes ink and paper the same colour:

```asm
ld hl,LEFT_BOTTOM_ATTRIBUTE_ADDRESS
ld bc,0203fh
call atHLrepeatBTimesC
```

The bitmap pixels remain, but the line disappears visually.

This avoids showing partially transformed input while the parser, command handler, or source insertion changes shared buffers.

It is an elegant use of the Spectrum's separate attribute memory: hide thirty-two cells with thirty-two byte writes.

## The first byte decides command or source

After skipping the cursor marker where necessary, PROMETHEUS examines the first meaningful input byte.

```text
byte below $80 → ordinary source text
byte at/above $80 → tokenized command
```

The branch is:

```asm
cp 080h
jr c,parseAndInsertSourceLine
```

This is why a command entered with SYMBOL SHIFT plus a letter can occupy one byte. The key translator may create a token in the `$C1-$DA` range rather than spelling the command.

The same input line can therefore carry two languages:

- editable assembly text;
- one-byte editor command tokens followed by arguments.

## Command tokens jump through a table

A command token is doubled to index a table of 16-bit handler addresses:

```asm
ld de,commandHandlerTable-(0xc1*2)
add hl,hl
add hl,de
ld a,(hl)
inc hl
ld h,(hl)
ld l,a
jp (hl)
```

Conceptually:

```text
index = token - $C1
handler = commandHandlerTable[index]
jump handler
```

The bias is folded into the table-base arithmetic, so no explicit subtraction is needed.

The handlers include:

- assembly;
- BASIC;
- copy;
- delete;
- find;
- import;
- load/save/verify;
- monitor;
- print;
- run;
- symbol table;
- `U-TOP`;
- clear and replace.

Several token slots deliberately share handlers because the historical command table contains aliases.

## A pushed warm-start address behaves like a common return target

Before dispatching a command, PROMETHEUS prepares:

```asm
ld hl,prometheusWarmStart
ld (varcPostCommandContinuationJump+1),hl
push hl
```

A simple command handler can therefore finish with `RET` and arrive at `prometheusWarmStart` even though the dispatcher used `JP (HL)` rather than `CALL`.

The stack has been prepared as if the command had been called from the warm-start address.

This is another use of the stack as control-flow data.

Some multi-stage commands temporarily patch `varcPostCommandContinuationJump` to a different continuation. Normal command dispatch restores the warm-start destination first, so old special state does not leak into the next command.

## Source submission takes the parser path

If the first byte is ordinary text, `parseAndInsertSourceLine` calls:

```asm
call encodeInputLineToSourceRecord
call getRecordAfterActiveLine
```

The parser creates a compressed record in temporary workspace. The destination is normally after the active record.

The insertion engine opens a gap and copies the record. In overwrite/edit mode, the old record is also removed.

After a successful submission:

- the status message returns to the default;
- insert mode is restored;
- the continuation jump returns to the normal warm start;
- visible source is rebuilt from compressed records.

Chapters 12–14 will explain exactly what the encoded record contains and how the round trip works.

## The status bar is part of the control loop

`printStatusBar` first displays a selected message. It then patches the shared print cursor to the mode position, prints `I` or `O`, and formats two addresses:

```text
current code/source-symbol end
current U-TOP
```

The number formatter obeys the decimal/hexadecimal display mode.

This means the user receives continuous feedback about memory pressure. As source and symbols grow, the displayed high-end address approaches `U-TOP`.

The editor is not hiding the machine's memory constraints. It makes them part of ordinary operation.

## Error paths return through the same visual centre

Parsing and commands report errors through `signalError` and related message routines. These paths ultimately re-enter the warm-start structure with an appropriate status message.

Because warm start:

- resets the internal stack;
- clears transient buffers at the appropriate level;
- redraws source;
- rebuilds the edit row;

error handling does not require every deep routine to reverse every partial display action.

This is the editor's recovery architecture:

```text
on ordinary completion → return or jump to warm start
on error               → choose message and jump to warm start
on navigation          → warmer redraw preserving buffers
```

The warm-start family is therefore as important as the main key loop itself.

## The editor as pseudocode

At the highest useful level, the editor behaves like this:

```text
startEditor:
    disable interrupts
    initialize display

warmStart:
    restore access-line attributes
    choose status message
    clear transient buffers
    create empty edit line with cursor

warmStartWithCurrentBuffers:
    reset private stack
    draw source window around active record

mainLoop:
    draw edit buffer
    restore border
    key = readNormalizedKey()
    draw status bar

    if key is immediate editor control:
        perform navigation/edit/block action
        go to an appropriate warm start

    submitted = mutateEditBuffer(key)

    if not submitted:
        go to mainLoop

    hide edit row

    if first input byte is a command token:
        dispatch command handler
    else:
        parse line into compressed record
        insert or replace source record

    go to warmStart
```

This pseudocode omits important details but captures the editor's shape.

## Following one new source line

Suppose the active source record is an empty line and the user enters:

```asm
LOOP    DJNZ LOOP
```

At this overview level, the journey is:

```text
1. processKey returns normalized characters and controls.
2. updateInputBuffer maintains the temporary line and cursor marker.
3. repaintEditLine expands tokens and draws the current edit row.
4. ENTER makes updateInputBuffer return zero.
5. submitInputLineOrDispatchCommand sees ordinary text below $80.
6. encodeInputLineToSourceRecord parses fields and creates a compact record.
7. insertByteRangeAtHLFromDE opens space after the active record.
8. the compressed bytes are copied into persistent source.
9. warm start clears temporary state and redraws the source window.
10. renderSourceRecord expands the new record back into readable text.
```

The line is displayed in nearly the same form the user entered, but the persistent bytes are no longer a simple text string.

## Following one command

Now suppose the input line begins with the token for `ASSEMBLY`.

```text
1. SYMBOL SHIFT command entry creates token $C1.
2. repaintEditLine expands the token to the visible word.
3. ENTER submits the line.
4. first byte is at least $80, so source parsing is skipped.
5. command token indexes commandHandlerTable.
6. control jumps to invokeAssembly.
7. the pushed warm-start address acts as the normal return target.
8. compilation reports a status and the editor redraws.
```

The visible word and the stored input byte are different representations, just as compressed source and visible source are different representations.

## Following one down-arrow

```text
1. processKey returns the immediate down control code.
2. main loop calls moveActiveLineToNextSourceRecord.
3. boundary helper refuses movement beyond source end.
4. visible bitmap rows shift upward.
5. one new bottom record is expanded and rendered.
6. direct keyboard port test asks whether down remains held.
7. repeat the fast path or return to normal main loop.
```

No source bytes move. Only the active pointer and screen image change.

This distinction matters:

```text
navigation changes view state
editing changes persistent source structure
```

## What the editor does not yet know

At this top level, the editor treats several complex subsystems as services:

- `processKey` supplies one normalized key;
- `updateInputBuffer` maintains the edit-line representation;
- `encodeInputLineToSourceRecord` parses and compresses source;
- `expandSourceRecordToLineBuffer` reconstructs readable source;
- `getNextSourceRecord` and `getPreviousSourceRecord` navigate variable records;
- command handlers implement assembly, tape, search, monitor, and other functions.

The next chapters will open these boxes one at a time.

This ordering is deliberate. We first need to know why a routine exists and where its result goes. Only then do its low-level tricks form a coherent story.

## Back to the whole machine

The editor is the hub connecting nearly every subsystem.

It creates the compressed source consumed by the assembler.

It displays symbol and memory boundaries.

It launches the monitor and accepts disassembled lines back into source.

It saves and loads source packages through tape.

It executes the program chosen by `ENT`.

It repairs its view after errors and long operations through a small family of warm starts.

From above, the editor is not a collection of unrelated key handlers. It is a repeated transformation cycle:

```text
persistent structures
    → visible representation
    → one user action
    → changed view or changed structure
    → visible representation again
```

The rest of Part II will descend into the mechanisms that make each arrow in that cycle work.

## What has changed in memory?

During ordinary navigation:

- `varcSourceBufferActiveLine` changes;
- bitmap rows may be copied and one edge row redrawn;
- persistent compressed source remains unchanged.

During edit-line typing:

- bytes in `inputBufferStart` move around the cursor marker;
- `varcInputBufferPosition` and display cursor state are refreshed;
- compressed source remains unchanged until ENTER.

During source submission:

- a temporary compressed record is created;
- source/symbol memory may shift;
- code-end and symbol-table pointers may change;
- the input buffer is reset by warm start.

During command dispatch:

- a warm-start return address is placed on the stack;
- the handler may patch continuation state;
- the command may affect source, symbols, display, tape, monitor, or assembled output.

## Important ideas for later chapters

- persistent source, visible source, and editable text are separate representations;
- warm-start labels are recovery and redraw levels, not merely startup code;
- the active source line is a self-modified immediate pointer;
- visible source is reconstructed, never edited directly in bitmap memory;
- immediate control keys and submitted command tokens follow different dispatch paths;
- fast scrolling changes view state without changing source;
- command handlers can `RET` into a prepared warm-start address even though dispatch used an indirect jump;
- the zero flag from `updateInputBuffer` means “submit now.”

## Source anchors explained at overview level

- `ENTRY_POINT_WITHOUT_MONITOR`
- `startPrometheus`
- `prometheusWarmStart`
- `prometheusWarmStartWithMessage`
- `prometheusWarmStartWithCurrentBuffers`
- `.readInputLineLoop`
- `varcLastStatusBarMessage`
- `varcSourceBufferActiveLine`
- `renderVisibleSourceRecords`
- `renderSourceRecord`
- `printExpandedSourceLineWithRoutine`
- `varcExpandedSourceCharacterRendererCall`
- `moveActiveLineToPreviousSourceRecord`
- `moveActiveLineToNextSourceRecord`
- `writeLineOfCodeAndTestKeyboard`
- `varcSelectedBlockStart`
- `varcSelectedBlockEnd`
- `updateInputBuffer` at interface level
- `submitInputLineOrDispatchCommand`
- `commandHandlerTable`
- `parseAndInsertSourceLine` at overview level
- `varcInsertMode`
- `varcPostCommandContinuationJump`
- `printStatusBar`
