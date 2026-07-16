; PROMETHEUS floppy-version logical resident payload
; Derived mechanically from the semantic v042 reconstruction.
;
; This file assembles the complete logical payload at $7C38.  For the
; assembler-only variant the final image retains only offsets $1388..$3E79;
; assembling the omitted monitor prefix is still necessary so every suffix label
; has the same effective origin as the historical installer.
;
DISK_DRIVER_BASE:   equ 07918h
DISK_PAYLOAD_ORIGIN: equ 07c38h

INSTALLATION_ADDRESS:          equ 0x5dc0
VRAM_ADDRESS:                  equ 0x4000
ATTRIBUTES_ADDRESS:            equ 0x5800
LOADER_ADDRESS:                equ 0x5000

; ROM routines

ROM_PrintACharacter:           equ 0x10
ROM_MaskableInterrupt:         equ 0x38
ROM_Key_Tables:                equ 0x0205
ROM_KeyboardScanning:          equ 0x028e
ROM_KeyboardTest:              equ 0x031e
ROM_BreakKey:                  equ 0x1f54
ROM_LoadBytes_562:             equ 0x0562
ROM_SaveControl_4c6:           equ 0x04c6
ROM_SA_SET:                    equ 0x051a
ROM_LD_MARKER:                 equ 0x05c8
ROM_ChannelOpen:               equ 0x1601
ROM_PixelAddress_22b0:         equ 0x22b0
ROM_NEWCommandRoutine:         equ 0x11b7
ROM_ImmediateRET:              equ 0x0052
ROM_StatementReturn:           equ 0x1b76

; system variables

SYSVAR_ERR_SP:                 equ 05c3dh   ; Address of item on machine stack to use as error return

; constants

INSTRUCTIONS_TABLE_SIZE:       equ 687
TEXT_COLOR:                    equ 0x38     ; white paper, black color
HIGHLIGHT_COLOR:               equ 0x30     ; yellow paper, black color
FRONT_PANEL_EDITOR_COLOR:      equ 0x39     ; as text color with bit 0 inverted
LABEL_LENGTH:                  equ 9
MAX_FILE_NAME_LENGTH:          equ 10
SEPARATOR_CHARCODE:            equ "~"
SECOND_LINE_ADDRESS:           equ 0x4020
BOTTOM_LINE_VRAM_ADDRESS:      equ 0x50e0
LEFT_BOTTOM_ATTRIBUTE_ADDRESS: equ 0x5ae0
ACCESS_LINE_ATTRIBUTE_ADDRESS: equ 0x59e0
THIRD_LINE_ATTRIBUTE_ADDRESS:  equ 0x5840
STATUS_BAR_MODE_POSITION:      equ 0x13
LINES_BEFORE_ACCESS_LINE:      equ 13
CALLS_STACK_SIZE:              equ 10
CHARACTERS_PER_LINE:           equ 32
SYMBOL_TABLE_LINES_COUNT:      equ 20

; messages

MESSAGE_BAD_MNEMONIC:          equ 1
MESSAGE_BAD_OPERAND:           equ 2
MESSAGE_BIG_NUMBER:            equ 3
MESSAGE_SYNTAX_HORROR:         equ 4
MESSAGE_BAD_STRING:            equ 5
MESSAGE_BAD_INSTRUCTION:       equ 6
MESSAGE_MEMORY_FULL:           equ 7
MESSAGE_BAD_PUT_ORG:           equ 8
MESSAGE_UNKNOWN:               equ 9
MESSAGE_WAIT_PLEASE:           equ 10
MESSAGE_ASSEMBLY_COMPLETE:     equ 11
MESSAGE_START_TAPE:            equ 12
MESSAGE_TAPE_ERROR:            equ 13
MESSAGE_ANY_KEY:               equ 14
MESSAGE_COPYRIGHT:             equ 15
MESSAGE_SOURCE_ERROR:          equ 16
MESSAGE_FOUND:                 equ 17
MESSAGE_ALREADY_DEFINED:       equ 18
MESSAGE_ENT:                   equ 19


    org 07c38h

relocatablePayloadStart:
; =====================================================================
; END OF ITERATION 1 ANNOTATION BOUNDARY
; =====================================================================
; The installer/bootstrap above is now semantically named and documented.
; The relocated monitor/assembler body begins here.  Later resurrection passes
; should proceed subsystem by subsystem and retain the same byte-identity test.
;
ENTRY_POINT_WITH_MONITOR:
    jp startPrometheus

; The monitor front panel items definition

; =============================================================================
; MONITOR FRONT-PANEL ITEM DESCRIPTORS
; =============================================================================
; The panel is a table of 34 fixed seven-byte descriptors.  The panel editor
; stores a byte offset into this table, so adjacent items differ by seven and the
; last valid offset is $E7.  The layout reconstructed from the renderer/editor is:
;
;   +0,+1  Spectrum bitmap address of the item's first character cell
;   +2     heading glyph/token or selector for a special item renderer
;   +3     value-format and source-mode flags
;   +4     size/capability flags
;   +5,+6  address of the displayed value, address variable, or unused zero
;
; Descriptor byte +3:
;
;   bit 7  decimal output enabled
;   bit 6  hexadecimal output enabled
;   bit 5  binary output enabled
;   bit 4  character output enabled
;   bit 3  read two-byte values instead of one-byte values
;   bit 2  put successive values on separate rows instead of beside each other
;   bits 1..0 source/rendering class:
;       0  flags item with condition-name rendering
;       1  indirect memory item: dereference +5,+6 to obtain its start address
;       2  direct scalar item: +5,+6 points at the displayed register/value bytes
;       3  special area item: edit line, list window, disassembly window, or EI/DI
;
; Descriptor byte +4:
;
;   bit 7  variable-size item; A..Z may select the full range 0..25
;          (when clear, item size is reduced to 0/1, i.e. hidden/visible)
;   bit 6  the one-byte/two-byte toggle is applicable
;   bit 5  the horizontal/vertical toggle is applicable
;   bits 4..0 item size: visible flag, row count, or number of memory values
;
; The six format commands are implemented by frontPanelFormatToggleKeyTable.
; The editor only changes these descriptor bytes; normal panel repainting uses
; the same generic renderer immediately, so every change is visible on re-entry.
frontPanelItemDescriptors:
frontPanelEditLineItem:
    ; edit line
    defb 0e0h                               ; panel cell (0,23): the edit line bitmap-address low byte
    defb 050h                               ; the edit line bitmap-address high byte
    defb 0c5h                               ; panel selector for the edit line
    defb 003h                               ; classify the edit line as a special-area renderer
    defb 001h                               ; initialize the edit line as a fixed size 1 item
    defw 0
; The monitor list-window descriptor is the second seven-byte front-panel item.
;
; The first word is its Spectrum bitmap origin.  Byte +4 combines item flags
; with the visible height in its low five bits.  The default value $8B therefore
; describes an eleven-row list window.  Display routines always mask with $1F,
; so user panel editing may move or resize the window without changing the list
; machinery.
frontPanelListWindowItem:
    ; list window
    defb 000h                               ; panel cell (0,0): the list window bitmap-address low byte
    defb 040h                               ; the list window bitmap-address high byte
    defb 0a0h                               ; panel selector for the list window
    defb 003h                               ; classify the list window as a special-area renderer
frontPanelListWindowSizeFlags:
    defb 08bh                               ; initialize the list window as a variable size 11 item
    defw 0
frontPanelDisassemblyWindowItem:
    ; disassembler list window
    defb 0a0h                               ; panel cell (0,13): the disassembly window bitmap-address low byte
    defb 048h                               ; the disassembly window bitmap-address high byte
    defb 0c4h                               ; panel selector for the disassembly window
    defb 003h                               ; classify the disassembly window as a special-area renderer
    defb 082h                               ; initialize the disassembly window as a variable size 2 item
    defw 0
    ; interrupt state
    defb 012h                               ; panel cell (18,16): the interrupt state bitmap-address low byte
    defb 050h                               ; the interrupt state bitmap-address high byte
    defb 0a3h                               ; panel selector for the interrupt state
    defb 003h                               ; classify the interrupt state as a special-area renderer
    defb 001h                               ; initialize the interrupt state as a fixed size 1 item
    defw 0
frontPanelRegistersItems:
    ; register A
    defb 000h                               ; panel cell (0,16): the register A bitmap-address low byte
    defb 050h                               ; the register A bitmap-address high byte
    defb 0c1h                               ; panel selector for the register A
    defb 0b2h
    defb 001h                               ; initialize the register A as a fixed size 1 item
    defw savedRegisterA
    ; register B
    defb 020h                               ; panel cell (0,17): the register B bitmap-address low byte
    defb 050h                               ; the register B bitmap-address high byte
    defb 0c2h                               ; panel selector for the register B
    defb 092h
    defb 001h                               ; initialize the register B as a fixed size 1 item
    defw savedRegisterB
    ; register C
    defb 040h                               ; panel cell (0,18): the register C bitmap-address low byte
    defb 050h                               ; the register C bitmap-address high byte
    defb 0c3h                               ; panel selector for the register C
    defb 092h
    defb 001h                               ; initialize the register C as a fixed size 1 item
    defw savedRegisterBC
    ; register D
    defb 060h                               ; panel cell (0,19): the register D bitmap-address low byte
    defb 050h                               ; the register D bitmap-address high byte
    defb 0c4h                               ; panel selector for the register D
    defb 092h
    defb 001h                               ; initialize the register D as a fixed size 1 item
    defw savedRegisterD
    ; register E
    defb 080h                               ; panel cell (0,20): the register E bitmap-address low byte
    defb 050h                               ; the register E bitmap-address high byte
    defb 0c5h                               ; panel selector for the register E
    defb 092h
    defb 001h                               ; initialize the register E as a fixed size 1 item
    defw savedRegisterDE
    ; register H
    defb 0a0h                               ; panel cell (0,21): the register H bitmap-address low byte
    defb 050h                               ; the register H bitmap-address high byte
    defb 0c8h                               ; panel selector for the register H
    defb 092h
    defb 001h                               ; initialize the register H as a fixed size 1 item
    defw savedRegisterH
    ; register L
    defb 0c0h                               ; panel cell (0,22): the register L bitmap-address low byte
    defb 050h                               ; the register L bitmap-address high byte
    defb 0cch                               ; panel selector for the register L
    defb 092h
    defb 001h                               ; initialize the register L as a fixed size 1 item
    defw savedRegisterHL
    ; register I
    defb 080h                               ; panel cell (0,12): the register I bitmap-address low byte
    defb 048h                               ; the register I bitmap-address high byte
    defb 0c9h                               ; panel selector for the register I
    defb 082h
    defb 000h                               ; initialize the register I as a fixed hidden item
    defw savedRegisterI
    ; register R
    defb 0c8h                               ; panel cell (8,22): the register R bitmap-address low byte
    defb 050h                               ; the register R bitmap-address high byte
    defb 0d2h                               ; panel selector for the register R
    defb 082h
    defb 001h                               ; initialize the register R as a fixed size 1 item
    defw savedRegisterR
    ; register HX
    defb 000h                               ; panel cell (0,8): the register HX bitmap-address low byte
    defb 048h                               ; the register HX bitmap-address high byte
    defb 019h                               ; panel selector for the register HX
    defb 082h
    defb 000h                               ; initialize the register HX as a fixed hidden item
    defw savedRegisterIXHigh
    ; register LX
    defb 020h                               ; panel cell (0,9): the register LX bitmap-address low byte
    defb 048h                               ; the register LX bitmap-address high byte
    defb 01dh                               ; panel selector for the register LX
    defb 082h
    defb 000h                               ; initialize the register LX as a fixed hidden item
    defw savedRegisterIX
    ; register HY
    defb 040h                               ; panel cell (0,10): the register HY bitmap-address low byte
    defb 048h                               ; the register HY bitmap-address high byte
    defb 01ah                               ; panel selector for the register HY
    defb 082h
    defb 000h                               ; initialize the register HY as a fixed hidden item
    defw savedRegisterIYHigh
    ; register LY
    defb 060h                               ; panel cell (0,11): the register LY bitmap-address low byte
    defb 048h                               ; the register LY bitmap-address high byte
    defb 01eh                               ; panel selector for the register LY
    defb 082h
    defb 000h                               ; initialize the register LY as a fixed hidden item
    defw savedRegisterIY
    ; flags
    defb 0ceh                               ; panel cell (14,22): the flags bitmap-address low byte
    defb 050h                               ; the flags bitmap-address high byte
    defb 0c6h                               ; panel selector for the flags
    defb 000h
    defb 001h                               ; initialize the flags as a fixed size 1 item
    defw savedRegisterAF
    ; register AF
    defb 0e0h                               ; panel cell (0,7): the register AF bitmap-address low byte
    defb 040h                               ; the register AF bitmap-address high byte
    defb 015h                               ; panel selector for the register AF
    defb 08ah
    defb 000h                               ; initialize the register AF as a fixed hidden item
    defw savedRegisterAF
    ; register BC
    defb 049h                               ; panel cell (9,18): the register BC bitmap-address low byte
    defb 050h                               ; the register BC bitmap-address high byte
    defb 016h                               ; panel selector for the register BC
    defb 08ah
    defb 001h                               ; initialize the register BC as a fixed size 1 item
    defw savedRegisterBC
    ; register DE
    defb 069h                               ; panel cell (9,19): the register DE bitmap-address low byte
    defb 050h                               ; the register DE bitmap-address high byte
    defb 017h                               ; panel selector for the register DE
    defb 08ah
    defb 001h                               ; initialize the register DE as a fixed size 1 item
    defw savedRegisterDE
    ; register HL
    defb 089h                               ; panel cell (9,20): the register HL bitmap-address low byte
    defb 050h                               ; the register HL bitmap-address high byte
    defb 018h                               ; panel selector for the register HL
    defb 08ah
    defb 001h                               ; initialize the register HL as a fixed size 1 item
    defw savedRegisterHL
    ; register SP
    defb 052h                               ; panel cell (18,18): the register SP bitmap-address low byte
    defb 050h                               ; the register SP bitmap-address high byte
    defb 023h                               ; panel selector for the register SP
    defb 08ah
    defb 001h                               ; initialize the register SP as a fixed size 1 item
    defw savedRegisterSP
    ; register IX
    defb 072h                               ; panel cell (18,19): the register IX bitmap-address low byte
    defb 050h                               ; the register IX bitmap-address high byte
    defb 01bh                               ; panel selector for the register IX
    defb 08ah
    defb 001h                               ; initialize the register IX as a fixed size 1 item
    defw savedRegisterIX
    ; register IY
    defb 092h                               ; panel cell (18,20): the register IY bitmap-address low byte
    defb 050h                               ; the register IY bitmap-address high byte
    defb 01ch                               ; panel selector for the register IY
    defb 08ah
    defb 001h                               ; initialize the register IY as a fixed size 1 item
    defw savedRegisterIY
    ; cycles counter
    defb 0d9h                               ; panel cell (25,22): the cycle counter bitmap-address low byte
    defb 050h                               ; the cycle counter bitmap-address high byte
    defb 0d4h                               ; panel selector for the cycle counter
    defb 08ah
    defb 001h                               ; initialize the cycle counter as a fixed size 1 item
    defw accumulatedTStates
    ; address X
    defb 0a0h                               ; panel cell (0,13): the address X bitmap-address low byte
    defb 048h                               ; the address X bitmap-address high byte
    defb 0d8h                               ; panel selector for the address X
    defb 081h
    defb 0e0h                               ; front-panel descriptor: address X, variable width and orientation
    defw monitorAddressX
    ; address Y
    defb 0b1h                               ; panel cell (17,13): the address Y bitmap-address low byte
    defb 048h                               ; the address Y bitmap-address high byte
    defb 0d9h                               ; panel selector for the address Y
    defb 081h
    defb 0e0h                               ; front-panel descriptor: address Y, variable width and orientation
    defw monitorAddressY
    ; address (BC)
    defb 008h                               ; panel cell (8,8): the memory at BC bitmap-address low byte
    defb 048h                               ; the memory at BC bitmap-address high byte
    defb 026h                               ; panel selector for the memory at BC
    defb 081h
    defb 0e0h                               ; front-panel descriptor: memory at BC, variable width and orientation
    defw savedRegisterBC
    ; address (DE)
    defb 028h                               ; panel cell (8,9): the memory at DE bitmap-address low byte
    defb 048h                               ; the memory at DE bitmap-address high byte
    defb 027h                               ; panel selector for the memory at DE
    defb 081h
    defb 0e0h                               ; front-panel descriptor: memory at DE, variable width and orientation
    defw savedRegisterDE
    ; address (HL)
    defb 048h                               ; panel cell (8,10): the memory at HL bitmap-address low byte
    defb 048h                               ; the memory at HL bitmap-address high byte
    defb 028h                               ; panel selector for the memory at HL
    defb 081h
    defb 0e0h                               ; front-panel descriptor: memory at HL, variable width and orientation
    defw savedRegisterHL
    ; address (SP)
    defb 016h                               ; panel cell (22,16): the memory at SP bitmap-address low byte
    defb 050h                               ; the memory at SP bitmap-address high byte
    defb 02bh                               ; panel selector for the memory at SP
    defb 08dh
    defb 0e5h                               ; front-panel descriptor: memory at SP, size five with variable width/orientation
    defw savedRegisterSP
    ; address (IX)
    defb 068h                               ; panel cell (8,11): the memory at IX bitmap-address low byte
    defb 048h                               ; the memory at IX bitmap-address high byte
    defb 029h                               ; panel selector for the memory at IX
    defb 081h
    defb 0e0h                               ; front-panel descriptor: memory at IX, variable width and orientation
    defw savedRegisterIX
    ; address (IY)
    defb 088h                               ; panel cell (8,12): the memory at IY bitmap-address low byte
    defb 048h                               ; the memory at IY bitmap-address high byte
    defb 02ah                               ; panel selector for the memory at IY
    defb 081h
    defb 0e0h                               ; front-panel descriptor: memory at IY, variable width and orientation
    defw savedRegisterIY

    defb monitorTextDefb-monitorTables
; =============================================================================
; MONITOR DISASSEMBLY DATA-AREA TABLES
; =============================================================================
; The DEFB and DEFW tables reuse the same biased-count/range representation as
; the monitor protection windows:
;
;   +0      stored count = 2 + number of user ranges
;   +1..4   hidden dynamic range occupied by PROMETHEUS and its source/table
;   +5..    up to five user-defined inclusive First..Last ranges
;
; During disassembly the current instruction address is tested against DEFB
; first and DEFW second.  The hidden range is therefore always rendered as DEFB,
; even though it is physically present in both tables.  Only the starting address
; is tested: a DEFW beginning at the last byte of a range still consumes the next
; memory byte outside that range.  The code imposes no alignment requirement.
defbDisassemblyAreaTable:
    defb 002h                               ; initialize the DEFB stored count at bias two: hidden range present, no user ranges
    defw 0x5dc0, 0x9c38                     ; seed the hidden DEFB resident/source range; checks replace it with current dynamic bounds
customDefbDisassemblyAreas:
    defw 0x0000, 0x0000                     ; reserve user DEFB inclusive range slot 1 as First,Last
    defw 0x0000, 0x0000                     ; reserve user DEFB inclusive range slot 2 as First,Last
    defw 0x0000, 0x0000                     ; reserve user DEFB inclusive range slot 3 as First,Last
    defw 0x0000, 0x0000                     ; reserve user DEFB inclusive range slot 4 as First,Last
    defw 0x0000, 0x0000                     ; reserve user DEFB inclusive range slot 5 as First,Last

    defb monitorTextDefw-monitorTables
defwDisassemblyAreaTable:
    defb 002h                               ; initialize the DEFW stored count at bias two: hidden range present, no user ranges
    defw 0x5dc0, 0x9c38                     ; seed the hidden DEFW resident/source range; checks replace it with current dynamic bounds
customDefwDisassemblyAreas:
    defw 0x0000, 0x0000                     ; reserve user DEFW inclusive range slot 1 as First,Last
    defw 0x0000, 0x0000                     ; reserve user DEFW inclusive range slot 2 as First,Last
    defw 0x0000, 0x0000                     ; reserve user DEFW inclusive range slot 3 as First,Last
    defw 0x0000, 0x0000                     ; reserve user DEFW inclusive range slot 4 as First,Last
    defw 0x0000, 0x0000                     ; reserve user DEFW inclusive range slot 5 as First,Last

; =============================================================================
; MONITOR ADDRESS-NAVIGATION STACK
; =============================================================================
; This is the ten-level stack used by cursor-right/cursor-left navigation.  It is
; unrelated to the user's saved Z80 SP and unrelated to CALL/RET tracing.
;
;   +0      number of stored return addresses, 0..10
;   +1..+20 ten little-endian addresses
;
; Cursor right prompts for a new current address, pushes the previous address,
; and refuses the operation when the stack is full.  Cursor left pops one address
; and does nothing when empty.  The implementation calculates an address slot as
; `base + 2*count`, with the count byte itself deliberately occupying offset zero.
monitorNavigationAddressStack:
    defb 0                                  ; initialize the monitor navigation depth to zero
    defw 0x0000, 0x0000                     ; reserve the first two reachable navigation return-address words
    defs CALLS_STACK_SIZE*2                 ; reserve eight further reachable words plus two preserved spare tail words

    defb monitorTextNoRead-monitorTables
; =============================================================================
; MONITOR RANGE TABLES: READ, WRITE, AND RUN PROTECTION
; =============================================================================
; Each table is preceded by the monitor text token used as its panel heading and
; has the same physical layout:
;
;   +0      stored count = 2 + number of user ranges
;   +1..4   hidden four-byte slot, replaced during a check by the synthesized
;           inclusive range [resident PROMETHEUS start, current source/table end]
;   +5..    five user slots, each `defw First,Last` with both endpoints included
;
; The count starts at 2 even when no user window exists.  The common checker uses
; count-1 ranges: one synthesized resident/source range plus every user range.
; The panel editor subtracts the same two-base offset, so it displays only slots
; 0..4 belonging to the user.  The hidden slot is deliberately not shown or
; directly editable.
;
; READ and WRITE ranges are consulted while the monitor simulates/steps memory
; accesses.  RUN ranges are consulted before executing at a protected address.
; The standalone block MOVE/FILL commands use a narrower resident-only check;
; that implementation discrepancy is documented at those handlers below.
setReadProtectedAreas:
    defb 002h                               ; initialize the READ stored count at bias two: hidden range present, no user ranges
    defw 0x0000, 0x0000                     ; reserve the hidden READ range rewritten to the current resident/source bounds
customReadProtectedAreas:
    defw 0x0000, 0x0000                     ; reserve user READ-protection inclusive range slot 1
    defw 0x0000, 0x0000                     ; reserve user READ-protection inclusive range slot 2
    defw 0x0000, 0x0000                     ; reserve user READ-protection inclusive range slot 3
    defw 0x0000, 0x0000                     ; reserve user READ-protection inclusive range slot 4
    defw 0x0000, 0x0000                     ; reserve user READ-protection inclusive range slot 5

    defb monitorTextNoWrite-monitorTables
setWriteProtectedAreas:
    defb 002h                               ; initialize the WRITE stored count at bias two: hidden range present, no user ranges
writeProtectionDynamicRangeSlot:
    defw 0x0000, 0x0000                     ; reserve the hidden WRITE range rewritten before each protection check
customWriteProtectedAreas:
    defw 0x0000, 0x0000                     ; reserve user WRITE-protection inclusive range slot 1
    defw 0x0000, 0x0000                     ; reserve user WRITE-protection inclusive range slot 2
    defw 0x0000, 0x0000                     ; reserve user WRITE-protection inclusive range slot 3
    defw 0x0000, 0x0000                     ; reserve user WRITE-protection inclusive range slot 4
    defw 0x0000, 0x0000                     ; reserve user WRITE-protection inclusive range slot 5

    defb monitorTextNoRun-monitorTables
setExecutionProtectedAreas:
    defb 002h                               ; initialize the RUN stored count at bias two: hidden range present, no user ranges
    defw 0x0000, 0x0000                     ; reserve the hidden RUN range rewritten to the current resident/source bounds
customExecutionProtectedAreas:
    defw 0x0000, 0x0000                     ; reserve user RUN-protection inclusive range slot 1
    defw 0x0000, 0x0000                     ; reserve user RUN-protection inclusive range slot 2
    defw 0x0000, 0x0000                     ; reserve user RUN-protection inclusive range slot 3
    defw 0x0000, 0x0000                     ; reserve user RUN-protection inclusive range slot 4
    defw 0x0000, 0x0000                     ; reserve user RUN-protection inclusive range slot 5

    defb monitorTextCall-monitorTables
; =============================================================================
; DIRECT CALL/RST TARGET LIST
; =============================================================================
; Used only when the trace mode indicator is Call DEF.  The representation is:
;
;   +0      stored count = 1 + number of visible targets
;   +1..    eleven two-byte storage slots
;
; At most ten targets are visible.  The eleventh word is spare tail storage used
; by the compact fixed-length deletion move.  A stored count of one therefore
; means an empty list; the tracing scanner executes DJNZ before each POP and so
; consumes exactly count-1 target words.
;
; Targets are exact 16-bit addresses.  A traced CALL or RST is executed natively
; only when its destination equals one of these words.  The list is not sorted and
; duplicate values are accepted.
directCallAddressList:
    defb 001h                               ; initialize the direct-target biased count to one, representing an empty visible list
    defw 0x0000                             ; reserve visible direct CALL/RST target slot 1
directCallAddressStorage:
    defw 0x0000, 0x0000, 0x0000, 0x0000, 0x0000 ; reserve visible direct CALL/RST target slots 2 through 6
    defw 0x0000, 0x0000, 0x0000, 0x0000, 0x0000 ; reserve visible target slots 7 through 10 plus the spare deletion-tail word

; Append the prepared 32-byte lineBuffer to the list window and implement the
; monitor's unusual long-list continuation rule.
;
; After rendering, an immediate all-keyboard scan is made through port $FE:
;
;   any key still held
;       return immediately to the caller, allowing the next line to stream
;
;   no key held
;       call readKeyCode and wait for the next deliberate key press
;
;   next key is not EDIT
;       return to the caller and continue listing
;
;   next key is EDIT (CAPS SHIFT+1, normalized code $04)
;       do not return: execution falls directly into startMonitor below
;
; This precisely implements the manual's statement that output continues while
; a key is held and that EDIT terminates it.  The missing RET after the EDIT test
; is intentional control-flow fall-through, not a disassembly omission.
outputMonitorListLineAndPollContinuation:
    call appendLineBufferToMonitorListWindow
    xor a
    in a,(0feh)                             ; sample the Spectrum keyboard matrix directly through the ULA port
    cpl                                     ; convert active-low matrix bits into active-high pressed-key bits
    and 01fh
    ret nz                                  ; stream the next row immediately while any key remains physically held
    call readKeyCode                        ; with no held key, wait for one normalized deliberate continuation key
    cp 004h                                 ; test whether the newly pressed key is EDIT, normalized as $04
    ret nz


; =============================================================================
; MONITOR WARM ENTRY AND TOP-LEVEL KEY DISPATCH
; =============================================================================
; This entry is used by the assembler's MONITOR command, by Q/error returns from
; monitor operations, and by several long-running monitor displays when EDIT is
; pressed.  It deliberately reinitializes the private stack and monitor input
; workspace on every pass; command-specific handlers therefore keep persistent
; state in self-modified operands or monitor data fields rather than on the
; previous invocation's stack.
;
; The four-token status line assembled in inputBufferStart is:
;
;   UNIVERSUM Control  ON/OFF  Call  NON/DEF/ALL
;
; $C6 and $CC are fixed monitor-text tokens.  The instruction-control flag
; selects $C7/$C8 (ON/OFF).  directCallModeGateOpcode stores one of three executable opcodes
; ($00 NOP, $C8 RET Z, $C9 RET); the arithmetic below maps them to $C9/$CA/$CB
; (NON/DEF/ALL) without a lookup table.
;
; Before accepting a key, the routine restores three shared assembler/editor
; hooks to their ordinary safe defaults:
;
;   errorAction                       -> printStatusBar
;   abortCommandAndReturnToEditor     -> clearStringBuffers
;   varcPostCommandContinuationJump   -> prometheusWarmStart
;
; Individual monitor prompts temporarily replace errorAction again so syntax
; errors can be displayed on the panel edit line and the same prompt retried.
;
; startMonitor is pushed as a synthetic outer return address.  The table
; dispatcher later pushes a selected handler and executes RET; when a normal
; handler eventually RETs, it returns here and redraws the complete front panel.
;
; Emulator "flow from" comments record paths observed in tests.  They are useful
; evidence that an entry was exercised, but are not a complete caller list.
startMonitor:
    di                                      ; keep monitor stack, panel, and execution-state setup non-interruptible
    call setBorderColor                     ; restore the configured resident border before drawing the monitor panel
    ld sp,internalStackTop
    call monitorInputBuffersInitialization
    ld hl,inputBufferStart
    ld (hl),0c6h
    inc hl
    ld a,(varcInstructionControlsDisabled+1) ; load the inverse instruction-control Boolean from its self-modified operand
    add a,0c7h                              ; map 0/1 to the adjacent ON/OFF monitor text tokens $C7/$C8
    ld (hl),a
    inc hl
    ld (hl),0cch
    inc hl
    ld a,(directCallModeGateOpcode)         ; load the executable NOP/RET-Z/RET opcode that also encodes direct-CALL policy
    or a
    jr z,.selectMonitorCallModeTextToken     ; skip opcode normalization when NON already maps directly to token $C9
    sub 0c7h                                ; normalize RET-Z/RET opcodes $C8/$C9 to policy indices 1/2
.selectMonitorCallModeTextToken:
    add a,0c9h                              ; map the policy index to monitor text tokens $C9/$CA/$CB
    ld (hl),a
    call renderMonitorInputLine
    ld a,080h
    ld (inputBufferStart),a
    ld hl,l96a4-1                           ; select the monitor token-expansion table base one byte before its indexed entries
    ld (varcTokenExpansionTableBase+1),hl   ; redirect compact token expansion from assembler commands to monitor vocabulary
    ld hl,printStatusBar
    ld (errorAction+1),hl                   ; restore the shared error hook after any specialized monitor prompt
    ld hl,clearStringBuffers
    ld (abortCommandAndReturnToEditor+1),hl ; restore the shared abort hook after tape/list operations may have patched it
    ld hl,prometheusWarmStart
    ld (varcPostCommandContinuationJump+1),hl ; restore the shared submission continuation before monitor key dispatch
    ld hl,startMonitor
    push hl
    call redrawFrontPanelAtCurrentAddress
    call readKeyCode
    call getMonitorEditLineBitmapRowStart
    call clearBitmapTextRow                 ; erase the prior prompt before executing the selected command
    ld hl,(varcMonitorCurrentAddress+1)     ; current monitor address as the default handler argument
    ld e,020h

    ; Q - return to Prometheus
    cp 071h
    jp z,startPrometheus                    ; reinitialize the editor display and warm state when Q is pressed

    ; SS+W - front panel editor
    cp 014h
    jp z,invokeFrontPanelEditor

    ; SS+3 - hex/dec
    cp 023h                                 ; test SYMBOL SHIFT+3 for decimal/hexadecimal display-mode toggle
    jp z,invokeToggleNumberBase             ; toggle the shared numeric radix immediately when requested

    ; SS+Z - stepping
    cp 03ah
    jp z,stepInstructionAtHL                ; execute one step at the current monitor address

    ; SS+N - set register value
    cp 02ch
    jp z,setRegisterValue

    ; CS+0 - restore monitor display
    cp 003h
    jp z,clearDisplay                       ; clear the bitmap while retaining monitor mode and synthetic return state

    ld c,a                                  ; retain the unmatched normalized key for compact table comparison
    ld b,028h
    ld hl,monitorKeyboardActions
    ld de,monitorKeyboardActionsTable
.scanMonitorKeyBindings:
    ld a,(de)
    inc de                                  ; advance from the delta to its associated normalized key code
    call addAtoHL
    ld a,(de)                               ; read the normalized key assigned to the computed handler
    cp c
    inc de
    jr z,.invokeMatchedMonitorKeyBinding     ; dispatch through the computed handler address on a key match
    djnz .scanMonitorKeyBindings             ; continue through the remaining compact monitor bindings
    ld a,c
    jp testKeysForAreas
.invokeMatchedMonitorKeyBinding:
    push hl                                 ; push the computed handler address as an indirect RET target
    ld hl,(varcMonitorCurrentAddress+1)     ; supply the current monitor address in HL to every table-dispatched handler
    ret


; Handler block addressed by monitorKeyboardActionsTable.
;
; The table stores each handler as an unsigned delta from the preceding handler,
; beginning at this base.  .scanMonitorKeyBindings cumulatively adds the deltas to
; HL.  On a key match it pushes that computed handler, reloads HL with the current
; monitor address, and RETs into the handler.  Consequently every table handler
; receives HL=current address and normally leaves by RET to the startMonitor
; address already placed beneath it.
;
; The first five handlers intentionally share fall-through code:
;
;   M          prompt for a new address, then apply net displacement 0
;   cursor up  apply -1 byte
;   ENTER      apply +1 byte
;   cursor left/right use the ten-entry call-depth stack
;   cursor down advances by the decoded length of one Z80 instruction
monitorKeyboardActions:
monSetCurrentAddress:
    call promptForMonitorValue
    defb 0xc4                               ; embed the monitor Memory prompt token consumed by promptForMonitorValue
    inc hl

monOneByteBack:
    dec hl
    dec hl

monOneByteForward:
    inc hl
setMonitorCurrentAddressAndRet:
    ld (varcMonitorCurrentAddress+1),hl     ; commit HL as the self-modified current address used by panel and handlers
    ret

monLevelUp:
    ld hl,monitorNavigationAddressStack
    ld a,(hl)
    or a
    ret z                                   ; leave the current address unchanged when already at navigation level zero
    dec (hl)
    add a,a                                 ; convert the former one-based depth to the word-end offset of its saved address
    call addAtoHL                           ; advance from the depth byte to the high byte of the selected saved address
    ld a,(hl)
    dec hl
    ld l,(hl)
    ld h,a
    jr setMonitorCurrentAddressAndRet

monLevelDown:
    ld hl,monitorNavigationAddressStack
    ld a,(hl)
    cp CALLS_STACK_SIZE
    ret nc                                  ; ignore level-down when no additional parent slot is available
    push hl
    call promptForMonitorValue
    defb 0xc4                               ; embed the monitor Memory prompt token consumed by promptForMonitorValue
    ex (sp), hl                             ; exchange the prompted child with the saved table base, leaving child on the CPU stack
    inc (hl)
    ld a,(hl)
    add a,a                                 ; convert that depth to the high-byte offset of the new two-byte slot
    call addAtoHL                           ; advance from the depth byte to the selected slot's high-byte position
varcMonitorCurrentAddress:
    ld de,00000h
    ld (hl),d
    dec hl
    ld (hl),e
    pop hl
    jr setMonitorCurrentAddressAndRet

monOneInstructionForward:
    call decodeInstructionAtHL
    jr setMonitorCurrentAddressAndRet

; =============================================================================
; MONITOR V / SYMBOL SHIFT+4: INTERACTIVE DISASSEMBLY LISTING
; =============================================================================
; V prompts for First; SYMBOL SHIFT+4 uses the current monitor address supplied
; in HL.  A blank separator row is appended once, then each call to
; disassembleNextLineToBuffer prepares one exact 32-column line and returns HL at
; the next sequential machine-code address.
;
; Output has no Last endpoint.  It follows the standard list continuation rule:
; holding any key streams rows, release pauses, a non-EDIT key resumes, and EDIT
; returns to the monitor.  Unconditional JR/JP/RET instructions request one
; additional blank line before decoding the next address; that blank call leaves
; HL unchanged and is therefore formatting, not a skipped byte.
monListDisassemblyFromGivenAddress:
    call promptForMonitorValue
    defb 0xc2                               ; embed the monitor First prompt token consumed by promptForMonitorValue

monListDisassembly:
    call beginMonitorListOutputWithBlankLine ; initialize list output and insert one blank separator row before disassembly
    call disassembleNextLineToBuffer        ; decode the item at HL into lineBuffer and advance HL to its successor
    call outputMonitorListLineAndPollContinuation
    jr $-6                                  ; repeat the decode/output pair indefinitely from the returned next address

monClearListWindow:
    ld ix,frontPanelListWindowItem
    ld a,(ix+004h)
    and 01fh
    jp clearOrRenderFrontPanelSpecialArea


; Forty monitor key bindings, encoded as pairs:
;
;   byte 0  positive delta from the previous handler address
;   byte 1  normalized key code returned by readKeyCode
;
; The handlers are laid out in ascending address order, so an 8-bit cumulative
; delta is sufficient.  B=$28 in startMonitor is the exact entry count.  Q,
; panel edit, number-base toggle, single-step, register assignment, and full
; display restore are tested before this table because their targets live outside
; this contiguous handler block.
monitorKeyboardActionsTable:

    defb monSetCurrentAddress - monitorKeyboardActions
    defb 0x6d

    defb monOneByteBack - monSetCurrentAddress
    defb 0x0a

    defb monOneByteForward - monOneByteBack
    defb 0x0d

    defb monLevelUp - monOneByteForward
    defb 0x08

    defb monLevelDown - monLevelUp
    defb 0x0b

    defb monOneInstructionForward - monLevelDown
    defb 0x09

    defb monListDisassemblyFromGivenAddress - monOneInstructionForward
    defb 0x76

    defb monListDisassembly - monListDisassemblyFromGivenAddress
    defb 0x24                               ; SS + 4  - list disassembly

    defb monClearListWindow - monListDisassembly
    defb 0x05

    defb monMemoryEditingOneShot - monClearListWindow
    defb 0x20                               ; space   - memory editing (one-shot)

    defb monMemoryEditing - monMemoryEditingOneShot
    defb 0x65                               ; e       - memory editing

    defb monToggleInstructionControls - monMemoryEditing
    defb 0x60                               ; SS + x  - instruction controls mode

    defb monCycleDirectCallMode - monToggleInstructionControls
    defb 0x78                               ; x       - execution mode

    defb monToggleNumericDisassemblyAddresses - monCycleDirectCallMode
    defb 0x63

    defb monCycleDisassemblyAddressMode - monToggleNumericDisassemblyAddresses
    defb 0x3f                               ; SS + c  - addresses printing mode

    defb monSlowTracing - monCycleDisassemblyAddressMode
    defb 0x74

    defb monFastTracingToAddress - monSlowTracing
    defb 0x3e                               ; SS + t  - fast tracing

    defb monToggleInterruptEnableState - monFastTracingToAddress
    defb 0x2e                               ; SS + m  - interrupt mode

    defb monSaveBlockFirstLast - monToggleInterruptEnableState
    defb 0x73                               ; s       - save block (first/last)

    defb monSaveBlockFirstLength - monSaveBlockFirstLast
    defb 0x7c                               ; SS + s  - save block (first/length)

    defb monLoadBlockFirstLast - monSaveBlockFirstLength
    defb 0x6a                               ; j       - load block from a tape (first/last)

    defb monLoadBlockFirstLength - monLoadBlockFirstLast
    defb 0x2d                               ; SS + j  - load block from a tape (first/length)

    defb monReadTapeHeaderOrLeader - monLoadBlockFirstLength
    defb 0x79                               ; y       - load header from tape

    defb monSwapPrimaryAndAlternateRegisters - monReadTapeHeaderOrLeader
    defb 0x2a                               ; SS + b  - registers swap

    defb monDisassemblyOnPrinter - monSwapPrimaryAndAlternateRegisters
    defb 0x64

    defb monDisassembleIntoSource - monDisassemblyOnPrinter
    defb 0x5c                               ; SS + d  - reverse disassembly into source

    defb monSetBreakpointRunStartOrExecute - monDisassembleIntoSource
    defb 0x77                               ; w       - set start for breakpoint

    defb monRunToTemporaryBreakpoint - monSetBreakpointRunStartOrExecute
    defb 0x5d                               ; SS + u  - breakpoint

    defb monCallSubroutineWithSavedState - monRunToTemporaryBreakpoint
    defb 0x5e                               ; SS + h  - call

    defb monMoveBlockFirstLast - monCallSubroutineWithSavedState
    defb 0x69                               ; i       - move block (first/last)

    defb monMoveBlockFirstLength - monMoveBlockFirstLast
    defb 0x7f                               ; SS + i  - move block (first/length)

    defb monFillBlockFirstLast - monMoveBlockFirstLength
    defb 0x70                               ; p       - fill block (first/last)

    defb monFillBlockFirstLength - monFillBlockFirstLast
    defb 0x22                               ; SS + p  - fill block (first/length)

    defb monListMemoryFromAGivenAddress - monFillBlockFirstLength
    defb 0x3d                               ; SS + l  - list memory from a given address

    defb monListMemoryFromTheCurrentAddress - monListMemoryFromAGivenAddress
    defb 0x6c                               ; l       - list memory from the current address

    defb monCharactersFromAGivenAddress - monListMemoryFromTheCurrentAddress
    defb 0x3b                               ; SS + O  - characters from a given address

    defb monCharactersFromTheCurrentAddress - monCharactersFromAGivenAddress
    defb 0x6f

    defb monEditDirectCallAddressList - monCharactersFromTheCurrentAddress
    defb 0x36

    defb monFindSequence - monEditDirectCallAddressList
    defb 0x67

    defb monNextSequence - monFindSequence
    defb 0x6e


monMemoryEditingOneShot:
    ld (initializeMonitorLineAssembler+1),hl ; seed monitor-line assembly with the current address as logical and physical origin
; Shared one-line monitor assembler input path.
;
; monMemoryEditingOneShot first patches initializeMonitorLineAssembler with the
; current monitor address.  This entry selects the alternate completion mode by
; writing opcode $21 (LD HL,nn) over monitorInputCompletionDispatch's normal $C3
; (JP nn).  The two following address bytes are unchanged; execution therefore
; falls through to assembleMonitorInputLine instead of jumping to the expression
; evaluator.
;
; The entered line is tokenized by the ordinary PROMETHEUS editor, assembled by
; the ordinary first- and second-pass routines, and emitted under the same
; protected-memory checks as a source compilation.  The resulting logical
; address is copied back into initializeMonitorLineAssembler so E can assemble a
; sequence of lines while SPACE performs exactly one line.
editOneMonitorAssemblyLine:
    ld a,021h
    ld de,00001h                            ; prepare an initial buffer containing cursor marker $01 followed by an empty terminator
    ld hl,(varcSourceBufferActiveLine+1)    ; load the active source-record pointer used to attribute any assembly diagnostic
    ld (reportAssemblyErrorAtSourceRecord+1),hl ; bind monitor-line errors to the selected source record
    jr .initializeMonitorInputRequest
; Prompt for one monitor value; the prompt token is inline after CALL.
;
; Calling convention:
;
;     call promptForMonitorValue
;
;
; The routine pops the CALL return address, consumes that one byte into E, and
; pushes the address following it.  D=$01 supplies the edit-buffer cursor marker.
; Because `LD (inputBufferStart),DE` stores E first, the initial bytes are
; [token,$01]: fixed prompt text followed by the movable cursor.  The normal completion
; opcode is $C3, making monitorInputCompletionDispatch jump to the shared textual
; expression evaluator.
;
; Result:
;   - ordinary numeric, symbol, or expression input returns its 16-bit value in HL
;   - an input beginning with ':' returns immediately with A=':' and Z set; tape
;     commands use the remaining characters as a filename instead of evaluating
;   - EDIT abandons the request and returns to startMonitor
;
; The evaluator is the same left-to-right assembler evaluator documented in v004,
; so monitor prompts accept decimal, #hex, %binary, quoted values, $, symbols, and
; the + - * / ? operators.
promptForMonitorValue:
    pop hl                                  ; remove the CALL continuation so the following inline prompt token can be consumed
    ld e,(hl)
    inc hl
    push hl                                 ; restore the corrected continuation for return after value entry
    ld d,001h
    ld a,0c3h                               ; select the normal $C3 JP opcode for expression-evaluator completion
; Common monitor input setup for value prompts and line assembly.
;
; A is written into the first byte of monitorInputCompletionDispatch ($C3 for
; expression evaluation, $21 for the one-line assembler path).  DE provides the
; initial two bytes of inputBufferStart.  The current SP is embedded into
; monitorInputRestart, giving the monitor error handler a stable retry point even
; though the shared assembler parser may unwind through its own error stack.
;
; errorAction is redirected to retryMonitorInputAfterError.  That handler prints
; the selected error on the panel's edit line, pauses briefly, restores this saved
; SP, clears the temporary strings, and reopens the same prompt.
.initializeMonitorInputRequest:
    ld (monitorInputCompletionDispatch),a
    call monitorInputBuffersInitialization
    ld (inputBufferStart),de
    ld (monitorInputRestart+1),sp           ; capture the command stack pointer in the self-modified retry entry
monitorInputRestart:
    ld sp,00000h                            ; restore the exact prompt stack after first entry or parser-error unwinding
    call clearStringBuffers                 ; discard transient parser strings before accepting or retrying monitor input
    ld hl,retryMonitorInputAfterError
    ld (errorAction+1),hl                   ; redirect errorAction so syntax errors reopen this same request safely
    call monitorInputLoop
    ld hl,inputBufferStart+1
    call atHLorNextIfOne
    cp 03ah                                 ; recognize ':' as the filename form used by monitor tape commands
    ret z                                   ; return the colon form without invoking the numeric expression evaluator
; Self-modified completion instruction.
;
; Default bytes are `JP evaluateInputExpression`.  Memory-edit setup changes only
; the opcode byte from $C3 to $21, turning the same three bytes into an inert
; `LD HL,evaluateInputExpression`; execution then continues at
; assembleMonitorInputLine.  This is intentional executable data, not a damaged
; jump target.
monitorInputCompletionDispatch:
    jp evaluateInputExpression
    ld hl,inputBufferStart
; Assemble the monitor edit line through the normal source-line pipeline.
;
; The line is encoded into encodedRecordHeader but is never inserted into the
; user's compressed source.  initializeMonitorLineAssembler supplies both the
; logical address counter and physical output pointer, after which the ordinary
; first pass defines any label/EQU state and the second pass emits bytes.  The
; updated logical address is saved for the next E-mode line.  A=0 reports success
; to the monitor input loop.
assembleMonitorInputLine:
    call atHLorNextIfOne                    ; skip the movable cursor marker before tokenizing the entered assembly line
    ld c,009h                               ; reserve the ordinary nine-column PROMETHEUS label field during encoding
    call encodeInputLineToSourceRecord
    call initializeMonitorLineAssembler     ; initialize first-pass counters and output state at the monitor assembly origin
    call firstPassProcessSourceRecord
    call initializeMonitorLineAssembler     ; reset assembler state to the same origin before physical emission
    call secondPassEmitSourceRecord
    ld hl,(varcAddressCounter+1)            ; read the logical address immediately following the emitted instruction or directive
    ld (initializeMonitorLineAssembler+1),hl ; retain that successor as the origin for the next continuous E-mode line
    xor a
    ret


; Return the bitmap address of the first column of the panel edit line.
;
; frontPanelEditLineItem begins with a two-byte Spectrum bitmap address.  The
; lower five bits of L encode the horizontal character position; clearing them
; preserves the interleaved bitmap row while moving to column zero.  AF is
; preserved because monitor error display passes its message number in A.
getMonitorEditLineBitmapRowStart:
    ld hl,(frontPanelEditLineItem)
    push af
    ld a,l
    ; top 3 bits
    and 0e0h
    ld l,a
    pop af
    ret


; Print a parser/assembler error on the monitor edit line and hold it briefly.
;
; A is the standard PROMETHEUS message number.  The shared status-message routine
; is given the monitor edit-line bitmap address, then a deterministic busy delay
; keeps the message visible before the prompt is rebuilt.  This delay is UI
; pacing only; no persistent monitor state is changed.
displayMonitorInputErrorAndDelay:
    call getMonitorEditLineBitmapRowStart
    call displayIndexedMessageAtBitmapRow   ; render the standard message selected by A on that row
    ld h,001h
.monitorInputErrorDelayLoop:
    inc hl
    ex (sp),hl                              ; consume timing with a reversible stack exchange
    ex (sp),hl                              ; restore the original stack word while adding the matching delay
    inc h
    dec h
    jr nz,.monitorInputErrorDelayLoop        ; repeat until the 16-bit delay counter wraps to zero
    ret
; Monitor-specific error continuation installed in errorAction.
;
; Shared parser errors arrive here with A=message number.  After displaying the
; message, control jumps back to monitorInputRestart, whose SP immediate was
; captured at the start of the request.  The same prompt or assembly line can
; therefore be corrected without corrupting nested command-handler returns.
retryMonitorInputAfterError:
    call displayMonitorInputErrorAndDelay
    jr monitorInputRestart

monMemoryEditing:
    call monMemoryEditingOneShot            ; initialize continuous E-mode assembly by performing the ordinary one-line setup
.editMonitorAssemblyLinesLoop:
    ld hl,(initializeMonitorLineAssembler+1) ; load the logical origin retained after the preceding assembled line
    call redrawFrontPanelFromDisassemblyAddress
    call editOneMonitorAssemblyLine
    jr .editMonitorAssemblyLinesLoop

; Toggle the stepping engine's READ/WRITE/RUN checks.
;
; The self-modified immediate is interpreted inversely to the status wording:
;
;   0       controls ON: validate memory accesses and resulting execution address
;   nonzero controls OFF: skip all configurable protection-table checks
;
; The HALT-with-interrupts-disabled test is deliberately outside this switch and
; remains active even when controls are OFF.  Standalone monitor commands such as
; L, O, MOVE, and FILL have their own previously documented protection behavior.
monToggleInstructionControls:
    ld hl,varcInstructionControlsDisabled+1 ; select the self-modified controls byte that represents the inverse ON/OFF state
.invertLogicAtHLAndRet_:
    jp invertLogicAtHLAndRet                ; reuse the shared zero/nonzero toggler and return directly to the monitor dispatcher

; Cycle how traced CALL and RST instructions are handled.
;
; The mode is encoded as an executable opcode in directCallModeGateOpcode:
;
;   $00 NOP    NON: simulate every CALL/RST through the trace trampoline
;   $C8 RET Z  DEF: execute directly only targets present in the direct-call list
;   $C9 RET    ALL: execute every CALL/RST directly
;
; Cycling uses $00 -> $C8 -> $C9 -> $00.  Direct execution is faster, but the
; called routine is not traced, protection checks are not applied inside it, and
; its body contributes no T states to accumulatedTStates.  This exactly explains
; the manual's warning that direct CALL/RST modes invalidate timing measurements.
monCycleDirectCallMode:
    ld hl,directCallModeGateOpcode
    ld a,(hl)
    or a
    jr nz,.advanceDirectCallModeOpcode       ; advance an existing DEF or ALL opcode through the compact mode sequence
    ; c8(-1), ret z
    ld a,0c7h
.advanceDirectCallModeOpcode:
    ; increase to c9 (ret)
    inc a
    ; should rotate? is c9+1?
    cp 0cah                                 ; detect the byte immediately beyond RET, which marks wrap back to NON
    jr nz,.storeDirectCallModeOpcode         ; retain RET-Z or RET while the mode sequence has not wrapped
    ; set to NOP
    xor a                                   ; encode NON as NOP after cycling beyond ALL
.storeDirectCallModeOpcode:
    ; set execution mode
    ld (hl),a
    ret

; Toggle only the numeric address prefix printed before a disassembled line.
;
; Labels found at an instruction address are independent of this flag and remain
; visible when numeric addresses are disabled.  Reverse insertion forces this
; flag to zero so a decimal/hexadecimal address is not mistaken for source text.
monToggleNumericDisassemblyAddresses:
    ld hl,varcShowNumericDisassemblyAddresses+1 ; address the self-modified Boolean controlling numeric disassembly prefixes
    jr .invertLogicAtHLAndRet_               ; toggle zero/nonzero state through the shared logic inverter and return

; Cycle the disassembler's numeric/symbolic operand mode.
;
; The stored values are deliberately encoded in the order 0 -> 2 -> 1 -> 0:
;
;   1  print numeric values only
;   2  replace exact symbol values with the symbol name
;   0  exact symbols plus `symbol+1` when target-1 matches a symbol
;
; Stored value zero is therefore the manual's mode 3 and is the installation
; default.  Instruction-address labels use exact matches in modes 2 and 3;
; `+1` substitution applies only to two-byte operand values.
monCycleDisassemblyAddressMode:
    ld hl,varcDisassemblyAddressMode+1      ; address the compact numeric/exact-symbol/symbol-plus-one disassembly mode
    ld a,(hl)                               ; read the current encoded mode value 0, 1, or 2
    or a
    jr nz,.storeNextDisassemblyAddressMode
    ld a,003h                               ; translate zero to three so the common decrement yields mode two
.storeNextDisassemblyAddressMode:
    dec a
    ld (hl),a
    out (0feh),a                            ; mirror the compact mode byte to the ULA as the original command-feedback side effect
    ret


; =============================================================================
; MONITOR T: SLOW AUTOMATIC TRACE
; =============================================================================
; Execute one instruction at the current monitor address, then normally repaint
; the front panel.  testCapsShiftEnter returns carry clear while CAPS SHIFT+ENTER
; is held, so `CALL C` suppresses repainting during that chord.  BREAK
; (CAPS SHIFT+SPACE) terminates tracing; otherwise the loop repeats.
;
; The final key-release wait is shared with ranged disassembly so the terminating
; chord is not immediately reinterpreted as a monitor command.
monSlowTracing:
    call stepAtCurrentMonitorAddress
    call c,redrawFrontPanelAtCurrentAddress ; redraw after the step unless CAPS SHIFT+ENTER requested display suppression
    call ROM_BreakKey                       ; sample BREAK after the instruction and any permitted front-panel refresh
    jr c,monSlowTracing
; Wait until the Spectrum keyboard matrix reports no pressed key, then return.
;
; Ranged printer/source disassembly jumps here after CAPS SHIFT+ENTER so the
; abort chord cannot be consumed again by the monitor command loop.  Tracing
; paths share the same release wait.
waitForAllKeysReleased:
    xor a
    in a,(0feh)                             ; sample the Spectrum keyboard matrix through the ULA port
    cpl                                     ; convert active-low key bits into active-high pressed-state bits
    and 01fh
    jr nz,waitForAllKeysReleased            ; remain here until every key used to terminate the prior operation is released
    ret

; =============================================================================
; MONITOR SYMBOL SHIFT+T: FAST TRACE TO AN EXCLUSIVE STOP CONDITION
; =============================================================================
; Prompt for Last and repeatedly execute instructions.  Unlike slow tracing,
; panel refresh occurs only while CAPS SHIFT+ENTER is held (`CALL NC`).  The loop
; terminates when the newly committed current address equals Last or when BREAK
; is pressed.  Last is compared after executing each instruction, so an initial
; current address already equal to Last does not prevent one step.
monFastTracingToAddress:
    call promptForMonitorValue
    defb 0xc3                               ; embed the prompt text token for Last immediately after the call
    ld (varcFastTraceStopAddress+1),hl      ; set the exclusive fast-trace stop address
.fastTraceNextInstruction:
    call stepAtCurrentMonitorAddress
    call nc,redrawFrontPanelAtCurrentAddress ; redraw only while CAPS SHIFT+ENTER explicitly requests visibility in fast mode
    ld hl,(varcMonitorCurrentAddress+1)     ; load the newly committed PC rather than the address that preceded the step
varcFastTraceStopAddress:
    ld de,00000h                            ; supply the self-modified exclusive stop address for this trace run
    or a
    sbc hl,de
    ret z                                   ; finish immediately when the just-executed instruction reaches Last
    call ROM_BreakKey                       ; allow BREAK to terminate a fast trace before the next instruction
    jr nc,waitForAllKeysReleased            ; consume the terminating chord only when BREAK was detected
    jr .fastTraceNextInstruction

; Toggle the saved user's interrupt-enable state.
;
; Zero means DI and one means EI.  beginExecutionTrampoline converts this byte
; into opcode $F3 or $FB as the first instruction of the scratch program.  The
; panel's EI/DI item also reads this same self-modified immediate.
monToggleInterruptEnableState:
    ld hl,varcInterruptEnableState+1        ; select the saved EI/DI byte used by both the panel and execution trampoline
    jr .invertLogicAtHLAndRet_               ; toggle the saved interrupt state through the common boolean inverter

; =============================================================================
; MONITOR TAPE BLOCK SAVE
; =============================================================================
; S and SYMBOL SHIFT+S save an arbitrary inclusive memory block.  Both variants
; end with DE=First and HL=Last; the Length form calculates Last=First+Length-1.
;
; The final `Leader` prompt has two genuinely different modes:
;
;   numeric expression
;       The low byte of the result becomes the tape block flag/leader.  The ROM
;       SAVE routine is entered immediately, without a header and without the
;       extra "start tape" key wait.  The high byte is ignored.
;
;   :filename
;       A 17-byte Spectrum CODE header is built in commandArgumentBuffer.  Its
;       type is 3, filename is truncated/padded to ten characters, data length is
;       Last-First+1, and parameter 1 is First.  The common header writer waits
;       for a key, writes a flag-$00 header, then the block is written with the
;       standard data flag $FF.
;
; SAVE does not call the monitor protection-range checker and does not reject a
; reversed or wrapped range.  Its 16-bit subtraction simply supplies the length
; passed to the ROM, preserving the original behavior.
monSaveBlockFirstLast:
    call promptForFirstAndLast
    jr .saveMonitorBlockAfterRangePrompt

monSaveBlockFirstLength:
    call promptForFirstAndLength
; Preserve First/Last while reading the SAVE leader or `:filename` selector.
;
; Stack after the two pushes, from top downward:
;     First, Last, caller return state
;
; promptForMonitorValue returns ordinary expressions in HL.  For colon input it
; returns A=':' and HL pointing at the colon in inputBufferStart.  XOR $3A is a
; compact discriminator: nonzero selects raw leader mode; zero builds a CODE
; header and skips the colon before copying the name.
.saveMonitorBlockAfterRangePrompt:
    push hl
    push de
    call promptForMonitorValue
    defb 0xd9                               ; embed the prompt token for Leader immediately after the prompt call
    xor 03ah
    jr nz,.writeMonitorBlockWithSelectedLeader ; bypass header construction when a raw numeric leader was supplied
    ld ix,commandArgumentBuffer
    ld (ix+000h),003h                       ; mark the monitor-generated header as Spectrum block type 3 (CODE)
    ld de,monitorTapeHeaderFileName
    inc hl
    call copyFileNameFromHLToDE
    pop de
    pop hl
    push hl
    push de
    or a
    sbc hl,de                               ; compute Last-First in preparation for an inclusive byte count
    inc hl
    ld (monitorTapeHeaderParameter1),de
    ld (monitorTapeHeaderDataLength),hl
    call waitForKeyAndWriteTapeHeader
    ld l,0ffh                               ; select the standard $FF data-block flag for the following payload
; Write the selected memory block through Spectrum ROM SA-BYTES.
;
; Header mode sets L=$FF before entering prepareMonitorTapeBlockParameters, so A
; becomes the standard data-block flag.  Raw mode retains the low byte of the
; evaluated Leader in L.  The helper converts the saved inclusive range to the
; ROM register contract and this tail-jump deliberately never returns through a
; PROMETHEUS tape-status wrapper; ROM SAVE owns completion/error behavior.
.writeMonitorBlockWithSelectedLeader:
    call prepareMonitorTapeBlockParameters  ; convert the preserved First/Last range and selected leader to IX/DE/A
    jp ROM_SaveControl_4c6
; Convert the saved inclusive range and Leader into the ROM tape contract.
;
; Entry stack (created by the monitor SAVE/LOAD handlers):
;     return address, First, Last
; Entry:
;     L = requested tape flag/leader byte
;
; Exit:
;     A  = low byte of Leader
;     IX = First
;     DE = Last-First+1
;     original helper return address restored on the stack
;
; The routine pops and re-pushes its return address because First and Last are
; deliberately stored below it.  Only L is copied to A, so values outside
; 0..255 are silently reduced modulo 256.
prepareMonitorTapeBlockParameters:
    ld a,l
    pop bc                                  ; remove and retain this helper's return address
    pop de                                  ; recover First from beneath the return address
    pop hl
    push bc                                 ; restore the helper return address above the reconstructed caller stack
    or a
    sbc hl,de                               ; form Last-First
    inc hl
    ex de,hl
    push hl
    pop ix
    ret

; =============================================================================
; MONITOR TAPE BLOCK LOAD
; =============================================================================
; J and SYMBOL SHIFT+J load one arbitrary tape block into a caller-specified
; inclusive destination.  The Length form again calculates Last=First+Length-1.
;
; Before asking for Leader, preserveBlockRangeAndCheckResidentWrite rejects a
; reversed/wrapped range or any destination intersecting the resident
; PROMETHEUS/source/symbol region.  As with MOVE/FILL, the five configurable
; WRITE windows are not consulted by this original path.
;
; Unlike monitor SAVE, J has no `:filename` branch.  Leader is always reduced to
; its low byte and passed directly as the expected tape flag.  The first block
; read must have that flag, exact requested length, and valid parity; PROMETHEUS
; does not scan headers or names here.  Any ROM failure is reported with the same
; monitor `Read/Write ERROR` line used for protected destinations.
monLoadBlockFirstLast:
    call promptForFirstAndLast
    jr .loadMonitorBlockAfterRangePrompt

monLoadBlockFirstLength:
    call promptForFirstAndLength
; Validate and preserve the destination, then ask for its expected Leader byte.
;
; The range helper leaves First and Last beneath this handler's return address.
; promptForMonitorValue accepts the normal expression language.  Although colon
; input is syntactically accepted by the shared prompt, there is no filename
; handling here: prepareMonitorTapeBlockParameters would merely use the low byte
; of the returned buffer pointer as the expected leader.  The documented and
; meaningful J interface is therefore numeric Leader input.
.loadMonitorBlockAfterRangePrompt:
    call preserveBlockRangeAndCheckResidentWrite ; reject reversed, wrapped or resident-overlapping destinations before tape access
    call promptForMonitorValue
    defb 0xd9                               ; embed the prompt token for Leader after the prompt call
; Load/verify one raw tape block into the preserved destination.
;
; prepareMonitorTapeBlockParameters produces IX=First, DE=length, A=Leader.
; Carry is set before callRomTapeLoadOrVerify, selecting LOAD rather than VERIFY.
; Carry set on return means success.  Carry clear covers flag/length mismatch,
; parity/tape failure, or ROM abort and is converted to `Read/Write ERROR`.
;
; monReadTapeHeaderOrLeader re-enters here after a successful header display with
; L=$FF, using the header's parameter 1 and length as the destination range for
; the following standard data block.
.readMonitorBlockWithSelectedLeader:
    call prepareMonitorTapeBlockParameters  ; convert the protected destination range to IX/DE/A
    scf                                     ; select ROM LOAD rather than VERIFY
    call callRomTapeLoadOrVerify
    ret c                                   ; return directly when the ROM reports a valid loaded block
    jp showMonitorReadWriteError

; =============================================================================
; MONITOR Y: READ A HEADER OR DISPLAY A RAW LEADER BYTE
; =============================================================================
; Y reads 18 bytes into inputBufferStart: the tape flag plus the 17-byte Spectrum
; header payload.  It calls ROM LD-BYTES directly rather than the common wrapper
; so the flag byte is retained in the buffer.  Expected flag $00 and LOAD mode
; are placed in AF' before the ROM call.
;
; If a valid header is read, the list line shows:
;     block type, ten-character name, parameter 1, data length, parameter 2
; using the monitor's current decimal/hex number mode.  Control then waits for a
; key.  J loads the immediately following data block with flag $FF, destination
; from parameter 1 and length from the header.  Any other key returns to the
; monitor without reading the data.
;
; If the encountered block is not a valid $00 header, carry is clear but its
; first flag/leader byte remains at inputBufferStart.  Y displays that single
; byte instead, fulfilling the manual's "header or leader" behavior.  There is
; no subsequent raw-block load because a leader alone supplies neither address
; nor length.
monReadTapeHeaderOrLeader:
    call beginMonitorListOutputWithBlankLine
    ld ix,inputBufferStart
    ld de,00012h
    xor a
    scf
    ; Move expected header flag $00 and LOAD carry into AF' for the ROM's private tape-state convention.
    ex af,af'
    ld a,00fh
    out (0feh),a                            ; drive the selected border/tape state to port $FE
    call ROM_LoadBytes_562
    ld ix,lineBuffer+3
    jr c,.displayLoadedTapeHeader            ; format the full header when ROM reports a valid $00 header block
    ld hl,(inputBufferStart)
    ld h,000h
    call printCompactNumberToIX             ; format the raw leader in the monitor's active number base
    jp appendLineBufferToMonitorListWindow
; Format the successfully loaded 17-byte header into lineBuffer.
;
; Buffer layout after the special 18-byte read:
;     +0       tape flag ($00 for a header)
;     +1       header type
;     +2..+11  filename
;     +12..13  data length
;     +14..15  parameter 1
;     +16..17  parameter 2
;
; The type is displayed as one decimal digit by adding ASCII '0'.  Filename bytes
; below space become '?'; bytes $20 and above are copied unchanged.  The three
; words are printed in order parameter1, length, parameter2.  Parameter1 and
; length are also pushed for the optional J action after the line is rendered.
.displayLoadedTapeHeader:
    ld hl,inputBufferStart+1                ; start at the retained header type byte after the physical flag
    ld a,(hl)
    add a,030h                              ; convert the small type number to its displayed digit
    ld (ix-003h),a
    ld b,00ah
; Copy one of the ten header filename bytes to the monitor list line.
;
; Values below ASCII space are replaced by '?'.  Unlike the assembler-side CODE
; header scanner, this display path performs no upper-bound test, so bytes with
; bit 7 set are passed to the line renderer unchanged.
.copyLoadedHeaderNameCharacter:
    inc hl
    ld a,(hl)
    cp 020h                                 ; classify control bytes below printable space
    jr nc,.storeLoadedHeaderNameCharacter    ; retain every byte at or above space on this monitor-only display path
    ld a,03fh
.storeLoadedHeaderNameCharacter:
    ld (ix+000h),a
    inc ix
    djnz .copyLoadedHeaderNameCharacter
    inc ix
    ld hl,(loadedTapeHeaderParameter1)
    push hl
    call skipOneColumnAndPrintFixedWidthNumberToIX
    ld hl,(loadedTapeHeaderDataLength)
    push hl
    call skipOneColumnAndPrintFixedWidthNumberToIX ; print the data length after one separating column
    ld hl,(loadedTapeHeaderParameter2)
    call skipOneColumnAndPrintFixedWidthNumberToIX ; print parameter 2 after one separating column
    call appendLineBufferToMonitorListWindow ; commit the completed header description to the monitor list
    call readKeyCode
    pop hl
    pop de
    cp 06ah
    ret nz
    add hl,de                               ; form First+Length
    dec hl                                  ; convert the exclusive end to the inclusive Last address
    call preserveBlockRangeAndCheckResidentWrite ; protect the destination before accepting the following CODE data block
    ld l,0ffh                               ; select the standard $FF data-block flag
    jr .readMonitorBlockWithSelectedLeader

; Exchange the saved primary and alternate BC/DE/HL/AF register banks.
;
; The saved images are two contiguous eight-byte blocks, so the command performs
; a byte-for-byte swap without executing EXX or EX AF,AF' on the monitor's own
; working state.  IX, IY, SP, I, R, and interrupt state are unaffected.
monSwapPrimaryAndAlternateRegisters:
    ld b,008h
    ld hl,savedRegisterBC
    ld de,savedAlternateRegisterSet
.swapNextPrimaryAlternateRegisterByte:
    ld c,(hl)
    ld a,(de)
    ld (hl),a
    ld a,c
    ld (de),a
    inc hl
    inc de
    djnz .swapNextPrimaryAlternateRegisterByte
    ret

; =============================================================================
; MONITOR D: RANGED DISASSEMBLY TO CHANNEL 3
; =============================================================================
; Select the Spectrum channel-3 output routine as the per-line sink, then enter
; the common First/Last disassembly driver.  Every generated line is also shown
; in the monitor list window before being sent to the printer.
;
; Last is exclusive: an instruction whose first byte is exactly at Last is not
; emitted.  An instruction beginning below Last is emitted in full even when its
; operand bytes extend beyond Last.  CAPS SHIFT+ENTER is tested after every line
; and terminates the operation after all keys have been released.
monDisassemblyOnPrinter:
    ld hl,outputLineBufferToChannel3
; Configure and execute the common ranged disassembly driver.
;
; Entry:
;   HL = address of the selected per-line sink
;
; The sink address is written into varcRangedDisassemblyOutputCall.  The normal
; source-insertion completion JP is temporarily redirected to a one-byte RET so
; parseAndInsertSourceLine can return to this loop rather than re-entering the
; editor.  The prompt returns DE=First and HL=Last; EX DE,HL leaves HL=current
; address and DE=exclusive Last.
;
; For every line the driver:
;   1. disassembles into lineBuffer;
;   2. appends the line to the monitor list window;
;   3. calls the selected printer/source sink;
;   4. tests CAPS SHIFT+ENTER;
;   5. repeats while nextAddress < Last.
;
; The current and endpoint addresses are kept on the private stack so the source
; insertion error handler can restore a known state after the normal assembler
; error machinery has abandoned its nested calls.
.configureRangedDisassembly:
    ld (varcRangedDisassemblyOutputCall+1),hl ; patch the per-line sink selected by the command
    ld hl,finishRangedDisassembly
    ld (varcPostCommandContinuationJump+1),hl ; return successful source insertion to the range driver
    call promptForFirstAndLast
    push hl                                 ; preserve Last while installing the reverse-insertion error recovery action
    ld hl,recoverRangedDisassemblyInsertionError
    ld (errorAction+1),hl                   ; redirect assembler errors from the source sink into the monitor correction path
    pop hl
    ex de,hl                                ; place Last in DE while HL becomes the current First address
.processNextRangedDisassemblyLine:
    push de                                 ; preserve the exclusive loop limit while one address is decoded and emitted
    call disassembleNextLineToBuffer        ; decode the item at HL and construct the common 32-column lineBuffer row
    call appendLineBufferToMonitorListWindow
    push hl                                 ; preserve the returned next address across printer or source output
    ld (recoverRangedDisassemblyInsertionError+1),sp ; capture the parser-stack recovery point immediately before invoking the selected sink
; Self-modified per-line output call used by ranged disassembly.
;
; D selects outputLineBufferToChannel3.  SYMBOL SHIFT+D selects
; copyDisassemblyLineToInputBuffer.  The instruction itself remains a normal
; three-byte CALL; only its two-byte operand is changed.
varcRangedDisassemblyOutputCall:
    call 00052h                             ; invoke the self-modified printer or source-insertion sink for this generated row
    di                                      ; restore the monitor's interrupt-disabled convention after ROM or editor-side output
.resumeRangedDisassemblyAfterOutput:
    pop hl
    pop de
    call testCapsShiftEnter
    jp nc,waitForAllKeysReleased
    push hl                                 ; preserve the next address while comparing it with the range limit
    or a
    sbc hl,de
    pop hl
    jr c,.processNextRangedDisassemblyLine   ; emit another row while the next start address is still below Last
finishRangedDisassembly:
    ret
; Recover from a source-line error during reverse disassembly.
;
; Before invoking the source sink, the driver stores SP in this LD SP immediate.
; If tokenization, symbol creation, insertion, or capacity checking raises an
; assembler error, errorAction calls this entry.  Restoring SP discards the
; abandoned parser stack, monitorInputLoop lets the user edit the offending
; generated line, and parseAndInsertDisassemblyLine retries it.  Successful
; correction resumes the original address-range loop.
;
; There is no rollback: lines inserted before the error remain in the source.
; For Memory full, the practical exit described by the manual is EDIT.
recoverRangedDisassemblyInsertionError:
    ld sp,00000h                            ; restore the exact monitor stack captured before the failing source sink call
    call monitorInputLoop
    call parseAndInsertDisassemblyLine
    jr .resumeRangedDisassemblyAfterOutput

; =============================================================================
; MONITOR SYMBOL SHIFT+D: REVERSE DISASSEMBLY INTO PROMETHEUS SOURCE
; =============================================================================
; Select the source-insertion sink and disable numeric address prefixes.  Exact
; symbol labels may still occupy the source label field according to the current
; disassembly address mode.  The zero written to the display flag is not restored
; by this command, so subsequent interactive disassembly also starts with numeric
; addresses hidden until C toggles them again.
;
; Each generated line is copied to inputBuffer and submitted through the ordinary
; editor tokenizer and compressed-record insertion path.  It is inserted after
; the current access line exactly like LOAD.  Consequently all normal syntax,
; symbol-table, memory-capacity, and partial-completion behavior is shared.
;
; Blank separator lines requested after unconditional transfers are inserted as
; real empty source records when another address remains before Last.
monDisassembleIntoSource:
    ld hl,finishRangedDisassembly
    ld (varcPostCommandContinuationJump+1),hl ; return each generated source line to the range driver
    xor a
    ld (varcShowNumericDisassemblyAddresses+1),a ; hide numeric address prefixes while generating editable PROMETHEUS source
    ld hl,copyDisassemblyLineToInputBuffer
    jr .configureRangedDisassembly
; Copy the complete 32-column disassembly row into the normal editor input buffer.
;
; This is the ranged driver's source sink.  The copy is intentionally fixed at
; 32 bytes, preserving field markers and trailing spaces exactly as generated by
; the source-record expander.
copyDisassemblyLineToInputBuffer:
    ld hl,lineBuffer
    ld de,inputBufferStart
    ld bc,00020h
    ldir                                    ; preserve field markers and trailing spaces while transferring the generated line
; Submit a generated or interactively corrected disassembly line to the editor.
;
; Temporary parser buffers are reset, an initial field marker is skipped when
; present, and the line enters parseAndInsertSourceLine with the standard
; nine-column label field.  The caller has patched varcPostCommandContinuationJump
; to RET, so successful insertion returns to the ranged monitor loop.
parseAndInsertDisassemblyLine:
    call clearStringBuffers                 ; reset parser scratch strings before submitting a generated or corrected line
    ld hl,inputBufferStart
    call atHLorNextIfOne
    ld d,000h
    ld c,009h                               ; reserve the standard nine-column label field before opcode parsing
    jp parseAndInsertSourceLine

; =============================================================================
; W / SYMBOL SHIFT+U: TEMPORARY THREE-BYTE BREAKPOINT
; =============================================================================
; The two keys deliberately share one handler.  A still contains the normalized
; key code selected by the monitor dispatcher:
;
;   W ($77)
;       store HL, the current monitor address, in the immediate operand of
;       varcBreakpointRunStartAddress; no memory is modified
;
;   SYMBOL SHIFT+U
;       use HL as the breakpoint patch address and run natively from the address
;       previously stored by W
;
; The run command saves exactly three bytes at the breakpoint address, replaces
; them with `JP breakpointHitCaptureEntry`, restores the complete user register
; image, applies the saved EI/DI state, and executes a native JP to the W address.
; When the program reaches the patch it jumps into the state serializer.  On
; return to this routine the original three bytes are copied back verbatim.
;
; Important original semantics:
;
; - only one breakpoint exists; savedBreakpointOriginalBytes is a single slot;
; - the patch is always three bytes and is not aligned to instruction boundaries;
; - patch installation uses the assembler's protected byte emitter, preventing
;   ROM, PROMETHEUS/source-table, and above-U-TOP destinations;
; - custom READ/WRITE/RUN windows are not consulted during this native run;
; - if execution never reaches the patch, control never returns here and the
;   original bytes cannot be restored automatically;
; - the monitor current address remains the patch address, matching the manual's
;   description of the address shown after a breakpoint hit.
monSetBreakpointRunStartOrExecute:
    cp 077h
    jr nz,monRunToTemporaryBreakpoint
    ld (varcBreakpointRunStartAddress+1),hl ; patch the later native-JP operand with the current monitor address
    ret

monRunToTemporaryBreakpoint:
    push hl
    ld (varcAssemblyOutputPointer+1),hl     ; redirect the protected byte emitter to the breakpoint patch site
    ld de,savedBreakpointOriginalBytes
    push de
    call copyThreeBytesFromHLToDE
    ld hl,startMonitor
    ld (errorAction+1),hl                   ; install the monitor restart as the assembler emitter's temporary error action
    ld a,0c3h
    call emitByteAtAssemblyOutput
    ld bc,breakpointHitCaptureEntry
    call emitWordBCAtAssemblyOutput
    ld c,0c3h
varcBreakpointRunStartAddress:
    ld de,breakpointHitCaptureEntry
    call executeNativeCallOrJumpThroughTrampoline ; restore user state and leave the trampoline through a native jump to that origin
    pop hl
    pop de
; Copy exactly three bytes from HL to DE.
;
; The breakpoint command uses this once to preserve bytes from the patch site and
; once, with source/destination popped in reverse order, to restore them.  The
; restoration is a raw LDIR and intentionally bypasses the generated-code output
; checks that guarded installation of the patch.
copyThreeBytesFromHLToDE:
    ld bc,0003                              ; fix the breakpoint preservation/restoration width at exactly three bytes
    ldir                                    ; copy the displaced or restored instruction bytes verbatim
    ld a,0ffh
; Adjust the saved R register while preserving its high bit.
;
; A is an implementation-specific fetch correction.  The arithmetic changes only
; R bits 0..6 and retains bit 7 exactly.  The breakpoint return path supplies
; $FF, which decrements the low seven-bit count by one; tracing state restoration
; and capture use other constants to compensate for monitor/trampoline fetches.
adjustSavedRefreshRegisterLow7:
    ld hl,savedRegisterR
    add a,(hl)
    xor (hl)
    and 07fh
    xor (hl)                                ; recombine the corrected low seven bits with the original high bit
    ld (hl),a
    ret
; Single three-byte buffer holding the bytes displaced by the active breakpoint.
;
; There is no address or active flag beside this buffer: the patch address remains
; on the monitor stack throughout the native run, and restoration is reached only
; when breakpointHitCaptureEntry returns through that saved continuation.
savedBreakpointOriginalBytes:
    nop                                     ; reserve displaced breakpoint byte 0 in executable-compatible storage
    nop                                     ; reserve displaced breakpoint byte 1
    nop                                     ; reserve displaced breakpoint byte 2

; SYMBOL SHIFT+H: call one subroutine using the saved user processor state.
;
; The prompted target is encoded as a real CALL in the scratch trampoline.  The
; saved EI/DI state and all registers, including the user SP, are restored before
; execution; the normal sequential capture stub records the state after RET.
; Consequently the user's SP must point to writable RAM, exactly as warned by the
; manual.  This operation is native and does not apply traced access windows.
monCallSubroutineWithSavedState:
    call promptForMonitorValue              ; prompt for the native subroutine target to execute with the saved user state
    defb 0xcc                               ; embed the monitor's Call prompt token after the generic value reader
    ex de,hl
    ld c, 0xcd
; Build and execute a minimal native CALL or JP trampoline.
;
; Entry:
;   C = opcode ($CD CALL for SYMBOL SHIFT+H, $C3 JP for breakpoint run)
;   DE = target address
;
; beginExecutionTrampoline emits the saved DI/EI opcode, this routine appends the
; three-byte transfer instruction and both standard capture jumps, and then
; restores the complete user state.  CALL returns into the sequential capture
; jump.  The breakpoint JP normally leaves the trampoline permanently and reaches
; breakpointHitCaptureEntry only when the patched program address is executed.
executeNativeCallOrJumpThroughTrampoline:
    call beginExecutionTrampoline
    ld (hl),c
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    call appendSequentialAndTakenCaptureJumps
    jp restoreUserStateAndExecuteTrampoline

; Copy an inclusive memory block, accepting First/Last or First/Length.
;
; After the destination `To` value is read, the code computes:
;
;   destinationLast = To + sourceLast - sourceFirst
;   length          = destinationLast - To + 1
;
; A 16-bit wrap or reversed/zero-length range is rejected by the resident-range
; checker as READ/WRITE ERROR.  The final copy uses moveMemoryBlockOverlapSafe,
; so overlapping source and destination blocks are handled like `memmove`.
;
; Only the resident PROMETHEUS/source interval is protected here.  User READ and
; WRITE windows are not consulted by the original implementation.
monMoveBlockFirstLast:
    call promptForFirstAndLast
    jr .moveBlockAfterRangePrompt

monMoveBlockFirstLength:
    call promptForFirstAndLength            ; read MOVE's source First and derive inclusive Last from Length
.moveBlockAfterRangePrompt:
    push hl                                 ; preserve source Last while the destination prompt reuses HL
    push de
    call promptForMonitorValue
    defb 0xd8                               ; embed the monitor-text token for the To prompt
    pop de
    pop bc
    push de
    push hl                                 ; retain destination First while calculating destination Last
    or a
    sbc hl,de                               ; form destination First minus source First
    add hl,bc
    pop bc
    call checkBlockDestinationAgainstResidentRegion
    ex de,hl
    sbc hl,bc
    inc hl                                  ; convert the endpoint difference to the inclusive byte count
    ld d,b
    ld e,c
    ld b,h
    ld c,l
    pop hl
    jp moveMemoryBlockOverlapSafe

; Fill an inclusive memory block, accepting First/Last or First/Length.
;
; The target range first passes the same resident-only write check used by MOVE.
; `With` is evaluated as a 16-bit expression but only L, its low byte, is stored.
; The first byte is written explicitly; for longer ranges LDIR replicates that
; byte forward through the remaining inclusive length.
;
; As with MOVE, custom WRITE windows are not checked despite the manual's stated
; behavior.  This is a confirmed property of the original instruction path.
monFillBlockFirstLast:
    call promptForFirstAndLast
    jr .fillBlockAfterRangePrompt

monFillBlockFirstLength:
    call promptForFirstAndLength            ; read FILL's target First and derive inclusive Last from Length
.fillBlockAfterRangePrompt:
    call preserveBlockRangeAndCheckResidentWrite
    call promptForMonitorValue
    defb 0xd7                               ; embed the monitor-text token for the With prompt
    ld a,l
    pop de
    pop hl
    or a
    sbc hl,de                               ; calculate Last-First, the number of bytes after the first cell
    ld (de),a
    ret z
    ld b,h
    ld c,l
    ex de,hl
    ld d,h
    ld e,l
    inc de
    ldir                                    ; replicate the first fill byte through the remaining range
    ret

; =============================================================================
; MONITOR L / SYMBOL SHIFT+L: NUMERIC MEMORY LISTING
; =============================================================================
; SYMBOL SHIFT+L first asks for `First`; L uses the current monitor address
; supplied in HL by the command dispatcher.  Both paths then emit an unlimited
; sequence of exact 32-column rows:
;
;   decimal mode:  AAAAA__DDD_DDD_DDD_DDD_DDD_CCCCC
;   hex mode:      #AAAA__#DD_#DD_#DD_#DD_#DD_CCCCC
;
; where AAAAA/#AAAA is the row's first address, each DDD/#DD is one memory byte,
; underscores represent spaces, and CCCCC is the character view of those same
; five bytes.  Decimal bytes are always three digits; hexadecimal bytes are `#`
; plus two digits.  The row address is fixed-width in the selected base.
;
; The standalone $DD byte immediately before `LD HL,lineBuffer` is an intentional
; instruction prefix: together the bytes execute as `LD IX,lineBuffer`.  This
; code/data overlap lets the following formatting helpers use IX without adding
; another instruction and must not be normalized or removed.
;
; After five values and five character cells, the row is appended and HL has
; advanced by five.  The loop wraps naturally from $FFFF to $0000.  It directly
; reads RAM and does not consult the configurable READ-protection windows.
monListMemoryFromAGivenAddress:
    call promptForMonitorValue
    defb 0xc2                               ; embed the inline monitor-text token consumed by the value prompt

monListMemoryFromTheCurrentAddress:
    call beginMonitorListOutputWithBlankLine
    defb 0xdd                               ; prefix the following LD so it executes as LD IX,lineBuffer for row formatting
    ld hl,lineBuffer
    push hl                                 ; preserve the row's first memory address while its numeric address is formatted
    call printNumberToIX                    ; write the row address in the currently selected decimal or hexadecimal form
    pop hl
    inc ix                                  ; advance past the first separator column after the formatted address
    inc ix
    push hl
    ld bc,00500h                            ; set B to five byte fields while keeping C zero for fixed-width number formatting
; Format one of the five numeric byte fields.
;
; The source byte is zero-extended into HL.  In hexadecimal mode a literal `#`
; is emitted followed by exactly two hexadecimal digits.  Decimal mode emits
; exactly three decimal digits.  IX is then advanced over the one-column field
; separator, while the original memory pointer is restored and incremented.
.formatNextNumericDumpByte:
    push hl                                 ; preserve the current memory pointer while the byte is formatted through HL
    ld l,(hl)
    ld h,000h                               ; zero-extend the memory byte to a 16-bit unsigned value
    ld a,(varcHexMode+1)                    ; read the persistent decimal-versus-hexadecimal monitor mode
    push bc                                 ; preserve the remaining byte count and formatter mode across numeric conversion
    or a
    jr z,.formatNumericDumpByteDecimal       ; use the three-digit decimal formatter when hexadecimal mode is disabled
    ld (ix+000h),023h
    inc ix
    call printTwoDigitHexByteToIX
    jr .finishNumericDumpByteField
.formatNumericDumpByteDecimal:
    call printThreeDigitDecimalByteToIX
.finishNumericDumpByteField:
    pop bc                                  ; restore the remaining field count and fixed-width formatting state
    inc ix
    pop hl                                  ; restore the memory pointer hidden while HL held the numeric byte value
    inc hl
    djnz .formatNextNumericDumpByte          ; format all five numeric byte fields in the row
    pop hl                                  ; rewind HL to the row origin saved before numeric formatting
    ld b,005h
; Append the five character cells corresponding to the numeric fields.
;
; HL has been restored to the row's first memory address.  The shared character
; normalizer preserves bit 7 as inverse-video state, substitutes a dot for low
; seven-bit codes below space, and advances both HL and IX once per byte.
.appendNumericDumpCharacter:
    call appendMemoryByteAsDisplayCharacter
    djnz .appendNumericDumpCharacter
    call outputMonitorListLineAndPollContinuation
    jr $-60

; =============================================================================
; MONITOR O / SYMBOL SHIFT+O: CHARACTER MEMORY LISTING
; =============================================================================
; SYMBOL SHIFT+O asks for `First`; O begins at the current monitor address.  Each
; exact 32-column row contains:
;
;     AAAAA__CCCCCCCCCCCCCCCCCCCCCCCCC
; or  #AAAA__CCCCCCCCCCCCCCCCCCCCCCCCC
;
; That is one fixed-width address, two spaces, and 25 memory characters.  As in
; the numeric listing, the standalone $DD byte prefixes `LD HL,lineBuffer` and
; changes it into `LD IX,lineBuffer` without changing the following source text.
;
; The character conversion follows the manual exactly:
;
;   low seven-bit value $00-$1F  -> '.'
;   low seven-bit value $20-$7F  -> corresponding glyph
;   original bit 7 set           -> same result in inverse video
;
; Thus control bytes $80-$9F become inverse dots.  Each completed line advances
; the source pointer by 25 bytes, wraps naturally at $FFFF, and bypasses the
; configurable READ-protection windows.
monCharactersFromAGivenAddress:
    call promptForMonitorValue
    defb 0xc2                               ; embed the inline monitor-text token consumed by the character-list prompt

monCharactersFromTheCurrentAddress:
    call beginMonitorListOutputWithBlankLine
    defb 0xdd                               ; prefix the following LD so it executes as LD IX,lineBuffer for row formatting
    ld hl,lineBuffer
    push hl                                 ; preserve the row's first memory address while its address field is formatted
    call printFixedWidthNumberToIX
    pop hl
    inc ix
    inc ix
    ld b,019h
.appendCharacterDumpByte:
    call appendMemoryByteAsDisplayCharacter
    djnz .appendCharacterDumpByte
    call outputMonitorListLineAndPollContinuation
    jr $-23
; Convert the byte at HL to one monitor character cell and advance HL/IX.
;
; The low seven bits determine printability.  Values below ASCII space are
; replaced by '.', but the original high bit is retained.  Values at or above
; space are passed through unchanged.  displayNormalCharacter interprets bit 7
; as inverse video, so both printable and substituted characters preserve the
; memory byte's high-bit state.
;
; Exit:
;   HL = next memory byte
;   IX = next destination column in lineBuffer
appendMemoryByteAsDisplayCharacter:
    ld a,(hl)
    and 07fh
    cp 020h                                 ; classify codes below ASCII space as control characters
    ld a,(hl)
    inc hl
    jr nc,.storeDisplayCharacterAndAdvance   ; preserve printable bytes unchanged when the low seven bits are at least space
    and 080h
    or 02eh
.storeDisplayCharacterAndAdvance:
    ld (ix+000h),a
    inc ix
    ret

; =============================================================================
; KEY 6: EDIT DIRECT CALL/RST TARGET ADDRESSES
; =============================================================================
; The common table renderer is switched to single-word mode and repeatedly shows
; every currently defined target.  Returned actions are:
;
;   I       append a prompted `Call` address when fewer than ten exist
;   0..9    delete the corresponding visible target
;   other   return to the monitor through the shared renderer
;
; Insertion uses the stored biased count directly to choose the next free word,
; then increments it.  Values are not range-restricted, sorted, or deduplicated.
; The display formatter may show a matching symbol beside each numeric value.
monEditDirectCallAddressList:
    ld hl,directCallAddressList
.editDirectCallAddressListLoop:
    push hl
    call displayAndEditDirectCallAddressList
    pop hl
    jr nz,.deleteDirectCallAddressSelectedByKey
    ld a,(hl)
    cp 00bh
    ret nc                                  ; return without insertion when all ten visible target slots are already occupied
    push hl
    dec a
    add a,a                                 ; display the target list and append a new address when requested
    call addAtoHL
    inc hl
    push hl
    call promptForMonitorValue
    defb 0xcc
    ex de, hl
    pop hl
    ld (hl),e
    inc hl
    ld (hl),d
    pop hl
    inc (hl)
    jr .editDirectCallAddressListLoop

; =============================================================================
; MONITOR MASKED FIVE-BYTE MEMORY FINDER (G / N)
; =============================================================================
; G prompts for exactly five byte positions.  Each prompt accepts either an
; ordinary expression or `:`.  The ten-byte monitorFindByteMaskPairs workspace
; stores five `(value, mask)` pairs:
;
;   expression  -> value = low byte of result, mask = $FF
;   colon       -> value is irrelevant,          mask = $00
;
; During comparison the test is `(memory XOR value) AND mask`; a zero mask
; therefore makes that byte position a wildcard.  The visible prompt text is a
; single packed string, `1. byte:`.  monitorFindBytePromptDigit is incremented
; after every response, so the same text becomes 2., 3., 4. and 5. without five
; separate strings.  A new G command restores the digit to `1` first.
;
; Both G and N start at current monitor address + 1.  Each candidate compares
; five bytes in ascending memory order.  On mismatch the original candidate is
; popped, incremented and retried.  Search ends when that 16-bit candidate wraps
; from $FFFF to $0000; no message is printed and the current address remains
; unchanged.  A match installs the candidate as the current monitor address and
; returns through the ordinary panel-redraw path.
monFindSequence:
    ld a,031h                               ; initialize the five-byte masked memory-search pattern
    ld (monitorFindBytePromptDigit),a       ; patch the digit in the five-byte FIND prompt
    ld b,005h                               ; initialize the five-byte masked memory-search pattern
    ld hl,monitorFindByteMaskPairs
.promptNextMonitorFindByte:
    push bc
    push hl
    call promptForMonitorValue
    defb 0xda
    xor 0x3a
    ld c,000h
    jr z,.storeMonitorFindByteAndMask
    dec c
.storeMonitorFindByteAndMask:
    ld b,l                                  ; store one normalized value/mask pair and advancing to the next prompt
    ld hl,monitorFindBytePromptDigit        ; point at the FIND prompt digit/count byte
    inc (hl)                                ; increment the FIND component count before the next prompt
    pop hl
    ld (hl),b                               ; store (hl) from b so later code can store one normalized value/mask pair and advancing to the next prompt
    inc hl
    ld (hl),c                               ; store (hl) from c so later code can store one normalized value/mask pair and advancing to the next prompt
    inc hl
    pop bc
    djnz .promptNextMonitorFindByte

monNextSequence:
    ld de,(varcMonitorCurrentAddress+1)
    inc de
.scanNextMonitorFindCandidate:
    push de
    ld hl,monitorFindByteMaskPairs
    ld b,005h
.compareMonitorFindCandidateByte:
    ld a,(de)
    inc de
    xor (hl)
    inc hl
    and (hl)                                ; apply the current value/mask pair
    inc hl
    jr nz,.advanceMonitorFindAfterMismatch
    djnz .compareMonitorFindCandidateByte
    pop hl
    jp setMonitorCurrentAddressAndRet

; Delete one direct-call target selected by key 0..9.
;
; The key is converted to a one-based count comparison and then to a zero-based
; word offset.  A compact fixed-tail LDIR shifts all later words left and decrements
; the biased count.  The physical table includes an extra spare word, so bytes
; copied into the unused tail are irrelevant after the count changes.
.deleteDirectCallAddressSelectedByKey:
    sub 02fh                                ; remove the selected direct-call word and compact the fixed table
    cp (hl)
    jr nc,.editDirectCallAddressListLoop     ; ignore a deletion key outside the currently populated target count
    dec a
    add a,a                                 ; remove the selected direct-call word and compact the fixed table
    ld b,a
    ld a,015h
    sub b                                   ; remove the selected direct-call word and compact the fixed table
    ld c,a
    ld a,b
    ld b,000h
    push hl
    call addAtoHL
    inc hl
    ld d,h
    ld e,l
    inc hl
    inc hl
    ldir                                    ; copy the prepared byte span while preserving overlap/table-compaction semantics
    pop hl
    dec (hl)
    jr .editDirectCallAddressListLoop


; Dispatch keys 1..5 to the five monitor range-table editors.
;
;   1  DEFB display area
;   2  DEFW display area
;   3  READ-protected area
;   4  WRITE-protected area
;   5  RUN-protected area
;
; I appends a user range when fewer than five are present.  First and Last are
; entered through the ordinary expression parser; Last is inclusive.  A reversed
; range is left in the unused next slot but the count is not advanced, so the
; display immediately asks again and the next valid input overwrites it.
;
; Keys 0..4 remove a visible user range.  Later four-byte pairs are compacted
; downward and the stored count is decremented.  Because the count includes the
; two hidden/base units, key 0 corresponds to physical offset +5 from the table
; count byte, not to the hidden dynamic slot.
testKeysForAreas:
    ; test keys 1-5
    cp 031h                                 ; compare A with 031h to decide whether to map numeric keys 1..5 to the corresponding monitor range table
    ret c
    cp 036h                                 ; compare A with 036h to decide whether to map numeric keys 1..5 to the corresponding monitor range table
    ret nc
    sub 031h                                ; map numeric keys 1..5 to the corresponding monitor range table
    ; compute address offset
    add a,a                                 ; map numeric keys 1..5 to the corresponding monitor range table
    ld hl,monitorRangeTablePointers         ; map numeric keys 1..5 to the corresponding monitor range table
    call addAtoHL
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl                                ; arrange registers to map numeric keys 1..5 to the corresponding monitor range table
.editSelectedMonitorRangeTable:
    push hl
    call displayAndEditFiveRangeTable
    pop hl
    jr nz,.deleteSelectedMonitorRange
    ld a,(hl)
    cp 007h
    ret nc                                  ; return without insertion when all five visible user-range slots are occupied
    push hl
    dec a
    add a,a                                 ; display, insert, or reject an inclusive user range
    add a,a                                 ; display, insert, or reject an inclusive user range
    call addAtoHL
    inc hl
    push hl
    call promptForFirstAndLast
    push hl
    or a
    sbc hl,de
    pop bc
    pop hl
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    ld (hl),c
    inc hl
    ld (hl),b
    pop hl
    jr c,.editSelectedMonitorRangeTable      ; redisplay without incrementing the count when First is greater than Last
    inc (hl)
    jr .editSelectedMonitorRangeTable
.advanceMonitorFindAfterMismatch:
    pop de
    inc de
    ld a,d                                  ; advance the masked search to the next candidate without wrapping
    or e                                    ; detect masked-search address wrap
    ret z
    jr .scanNextMonitorFindCandidate
monitorRangeTablePointers:
    defw defbDisassemblyAreaTable
    defw defwDisassemblyAreaTable
    defw setReadProtectedAreas              ; map key 3 to the READ-protection table
    defw setWriteProtectedAreas             ; map key 4 to the WRITE-protection table
    defw setExecutionProtectedAreas         ; map key 5 to the RUN-protection table
monitorFindByteMaskPairs:
    defs 10                                 ; reserve five consecutive (value,mask) pairs for masked memory search
.deleteSelectedMonitorRange:
    sub 02eh                                ; remove one four-byte range pair and compact the table
    cp (hl)
    jr nc,.editSelectedMonitorRangeTable     ; ignore a deletion key outside the currently populated visible range count
    dec a
    add a,a                                 ; remove one four-byte range pair and compact the table
    add a,a                                 ; remove one four-byte range pair and compact the table
    ld b,a
    ld a,015h                               ; remove one four-byte range pair and compact the table
    sub b                                   ; remove one four-byte range pair and compact the table
    ld c,a
    ld a,b
    ld b,000h                               ; remove one four-byte range pair and compact the table
    push hl
    call addAtoHL
    inc hl
    ld d,h
    ld e,l
    inc hl
    inc hl
    inc hl
    inc hl
    ldir                                    ; copy the prepared byte span while preserving overlap/table-compaction semantics
    pop hl
    dec (hl)
    jr .editSelectedMonitorRangeTable
retryRegisterAssignmentAfterError:
    call displayMonitorInputErrorAndDelay
    jr restartRegisterAssignmentInput

; =============================================================================
; SYMBOL SHIFT+N: EDIT SAVED REGISTER/PANEL VALUES
; =============================================================================
; The edit line begins with tokenized `ld `.  The user enters a register name,
; comma or space, and an expression.  Rather than maintaining a second register
; name table, this routine scans the first 24 seven-byte front-panel descriptors:
;
;   A B C D E H L I R HX LX HY LY F AF BC DE HL SP IX IY T X Y
;
; Descriptor byte +2 is already the panel heading selector.  A value with bit 7
; set represents a one-letter name directly; other values index the normal
; operand-name table and are compared as multi-character names.  Comparison is
; case-insensitive.  After a name match, a following byte below `A` is accepted
; as the separator; otherwise the scan continues and eventually reports Bad
; operand.
;
; Normal assignments evaluate the remaining text with the ordinary left-to-
; right expression evaluator.  Descriptor bytes +5/+6 supply the destination.
; One-byte items store E only.  Two-byte items, register pairs, T, X and Y store
; D then E in little-endian memory order.  This directly modifies the saved user
; state or panel-address variables used by subsequent monitor operations.
;
; F has a special shorthand.  `ld f,s`, `ld f,z`, `ld f,p`, and `ld f,c` search
; flagToggleSelectorMaskPairs and XOR the selected mask ($80,$40,$04,$01) into
; the saved F byte.  The table deliberately overlaps executable bytes: its last
; mask is immediately followed by the opcode of `LD DE,savedRegisterAF`, then a
; tiny XOR/store tail.  This compact code/data overlap must not be normalized.
;
; Parser errors jump to retryRegisterAssignmentAfterError, display the message,
; restore the command's saved monitor stack, and allow the same assignment line
; to be corrected safely.
setRegisterValue:
    call monitorInputBuffersInitialization  ; reset the shared monitor input buffer before constructing the register LD request
    ld hl,001c5h                            ; prepare token $C5 followed by cursor marker $01 as the initial tokenized 'LD ' line
    ld (inputBufferStart),hl
    ld hl,retryRegisterAssignmentAfterError
    ld (errorAction+1),hl                   ; redirect shared parser diagnostics into the recoverable register editor
    ld (restartRegisterAssignmentInput+1),sp ; capture the command stack pointer for safe assignment retry after parser errors
restartRegisterAssignmentInput:
    ld sp,00000h                            ; restore the exact register-command stack on first entry and every retry
    call clearStringBuffers                 ; clear temporary expression strings before editing or re-evaluating the assignment
    call monitorInputLoop
    ld b,018h                               ; scan exactly the first twenty-four editable front-panel descriptors
    ld ix,frontPanelRegistersItems
.scanEditableRegisterDescriptors:
    ld hl,inputBufferStart+1
    call atHLorNextIfOne
    ld a,(ix+002h)                          ; read the descriptor heading selector that also encodes the editable name
    bit 7,a
    jr nz,.compareFinalRegisterNameCharacter ; compare a direct one-character name without resolving the operand-name table
    ld de,operandsReferences                ; select the packed operand-name reference table for a multi-character heading
    call getStringFromTableDE
    ld a,(de)
    xor (hl)                                ; XOR expected and entered characters before case folding
    and 05fh
    jr nz,.advanceEditableRegisterDescriptor ; advance to the next descriptor when the first character does not match
    inc de
    inc hl
    call atHLorNextIfOne
    ld a,(de)
.compareFinalRegisterNameCharacter:
    xor (hl)
    and 05fh
    jr nz,.advanceEditableRegisterDescriptor ; reject this descriptor when the complete register name does not match
    inc hl
    call atHLorNextIfOne
    cp 041h
    jr c,.parseRegisterValueAfterName        ; accept the matched descriptor and continue to its value expression
.advanceEditableRegisterDescriptor:
    ld de,00007h
    add ix,de
    djnz .scanEditableRegisterDescriptors
    jp badOperandError
.parseFlagToggleSelector:
    call atHLorNextIfOne                    ; skip a cursor marker before reading an optional F-flag selector
    or 020h
    push hl
    ld hl,flagToggleSelectorMaskPairs
    ld b,004h                               ; limit shorthand matching to S, Z, P/V, and C
.scanFlagToggleSelectorPairs:
    cp (hl)
    inc hl                                  ; advance HL from the selector byte to its XOR mask
    jr z,$+16                               ; on a match, jump into the overlapped LD DE,savedRegisterAF toggle tail
    inc hl                                  ; skip the mask and advancing to the next selector byte after a mismatch
    djnz .scanFlagToggleSelectorPairs        ; scan the remaining selector/mask pairs
    pop hl
    jr .evaluateAndStoreRegisterValue
flagToggleSelectorMaskPairs:
    ld (hl),e                               ; encode ASCII 's' as table data while the same byte remains opcode LD (HL),E
    add a,b                                 ; encode the sign-flag XOR mask $80 as table data and opcode ADD A,B
    ld a,d                                  ; encode ASCII 'z' as table data while the same byte remains opcode LD A,D
    ld b,b                                  ; encode the zero-flag XOR mask $40 as table data and opcode LD B,B
    ld (hl),b                               ; encode ASCII 'p' as table data while the same byte remains opcode LD (HL),B
    inc b                                   ; encode the parity/overflow XOR mask $04 as table data and opcode INC B
    ld h,e                                  ; encode ASCII 'c' as table data while the same byte remains opcode LD H,E
    defb 0x01, 0x11                         ; emit carry-mask $01 followed immediately by opcode $11 for LD DE,nn
    defw savedRegisterAF
    defb 0x1a, 0xae                         ; emit opcodes LD A,(DE) and XOR (HL) to toggle the selected saved-F mask
    ld (de),a                               ; store the toggled flags byte back through DE into savedRegisterAF
    pop hl                                  ; discard the preserved input pointer after a successful shorthand toggle
    ret
.parseRegisterValueAfterName:
    inc hl
    ld a,(ix+002h)
    cp 0c6h
    jr z,.parseFlagToggleSelector            ; try s/z/p/c shorthand before ordinary expression assignment to F
.evaluateAndStoreRegisterValue:
    push ix                                 ; preserve the matched descriptor while the expression evaluator uses IX
    call evaluateExpressionAtHL
    pop ix
    ex de,hl
    ld l,(ix+005h)
    ld h,(ix+006h)
    ld a,(ix+002h)
    cp 0d8h                                 ; treat T, X, and Y selector values at or above $D8 as sixteen-bit destinations
    jr nc,.storeRegisterValueHighByte
    bit 3,(ix+003h)                         ; otherwise test descriptor format bit 3 for an ordinary two-byte register pair
    jr z,.storeRegisterValueLowByte
.storeRegisterValueHighByte:
    inc hl
    ld (hl),d
    dec hl
.storeRegisterValueLowByte:
    ld (hl),e
    ret


writeMonitorTextToDE:
    ; C  - index of the text reference
    ; DE - address where the text should be written
    ld b,000h                               ; resolve one packed monitor-text reference into a destination buffer
    push hl
    ld hl,monitorTables                     ; resolve one packed monitor-text reference into a destination buffer
    ; get reference address
    add hl,bc                               ; resolve one packed monitor-text reference into a destination buffer
    ld c,(hl)
    ; get text address
    add hl,bc                               ; resolve one packed monitor-text reference into a destination buffer
.copyMonitorTextCharacterLoop:
    ; get character
    ld a,(hl)
    ; is line ending?
    cp 080h
    ; write the character to (DE)
    res 7,a
    ld (de),a
    ; next character
    inc de
    inc hl
    jr c,.copyMonitorTextCharacterLoop
    ; we are at the end of string, insert zero
    xor a
    ld (de),a
    inc de
    pop hl
    ret


; Display one five-slot inclusive range table and return the requested action.
;
; Entry:
;   HL -> table count byte (`2 + visible user range count`)
;
; This range-table wrapper patches the shared display engine to use carry-set
; behavior, print the word "windows:", accept keys 0..4, and render two endpoints
; for each visible entry.  It skips the hidden four-byte dynamic slot and prints
; exactly count-2 user ranges.
;
; Return:
;   Z set     user pressed I and requests insertion
;   Z clear   A contains a candidate numeric deletion key
;   invalid keys jump directly back to startMonitor
;
; The same compact engine is reused elsewhere for the ten direct-CALL addresses,
; but that mode patches the three SCF opcodes to OR A and displays one word per
; entry instead of an inclusive pair.
displayAndEditFiveRangeTable:
    ld a,037h                               ; select SCF patch bytes so range mode prints headings, skips the hidden slot, and emits Last
    ld c,035h                               ; accept deletion keys 0..4 in five-range mode
    jr .configureAndDisplayMonitorAddressTable

; Configure the generic monitor table viewer for direct-call addresses.
;
; Three self-modified SCF instructions become OR A.  This suppresses the word
; `windows:`, avoids skipping a hidden resident range, and prints one word rather
; than a First/Last pair.  Numeric deletion keys 0..9 are accepted.  The same core
; remains in carry-set mode for the five range/protection-table editors.
displayAndEditDirectCallAddressList:
    ld a,0b7h                               ; select OR A patch bytes so direct-call mode suppresses range-only behavior
    ld c,039h
.configureAndDisplayMonitorAddressTable:
    ; modify code
    ld (varcRangeTableDisplayCarrySetup),a  ; patch varcRangeTableDisplayCarrySetup to patch and initialize the shared address-table viewer
    ld (varcRangeTableSkipHiddenEntryTest),a ; patch varcRangeTableSkipHiddenEntryTest to patch and initialize the shared address-table viewer
    ld (varcAddressTableSecondWordCarrySetup),a ; patch varcAddressTableSecondWordCarrySetup to patch and initialize the shared address-table viewer
    ld a,c
    ld (keyCodeLimit+1),a                   ; set the highest accepted range-table key
    call beginMonitorListOutputWithBlankLine
    ; get corresponding item text and write it to the line buffer
    dec hl
    ld c,(hl)
    inc hl
    ld de,lineBuffer
    call writeMonitorTextToDE
varcRangeTableDisplayCarrySetup:
    ; operation
    scf                                     ; carry requests the heading and first visible entry
    ld c,monitorTextWindows-monitorTables
    call c,writeMonitorTextToDE
    call appendLineBufferToMonitorListWindow
    ld a,02fh
    ld (lineBuffer),a
    ld a,(hl)
varcRangeTableSkipHiddenEntryTest:
    scf                                     ; carry skips the hidden range in range mode
    jr nc,.advanceToFirstDisplayedRange      ; bypass hidden-slot skipping when direct-call mode patched SCF to OR A
    dec a
    inc hl
    inc hl
    inc hl
    inc hl
.advanceToFirstDisplayedRange:
    inc hl
.displayNextRangeEntry:
    ld ix,lineBuffer+2                      ; format one numbered address or inclusive range row
    dec a                                   ; decrement A toward the limit used to format one numbered address or inclusive range row
    jr z,.readRangeTableEditorKey
    push af
    inc (ix-002h)                           ; increment the displayed range number
    ld (ix-001h),03ah                       ; store (ix-001h) from 03ah so later code can format one numbered address or inclusive range row
    call appendRangeEndpointToDisplayLine
varcAddressTableSecondWordCarrySetup:
    scf                                     ; carry appends the second endpoint in range mode
    call c,appendRangeEndpointToDisplayLine
    call appendLineBufferToMonitorListWindow
    pop af
    jr .displayNextRangeEntry
.readRangeTableEditorKey:
    call readKeyCode
    ; key for inserting
    cp "i"
    ret z
    ; key 0
    cp 030h
    jr c,.exitRangeTableEditorToMonitor      ; leave the table editor for keys below 0
keyCodeLimit:
    ; key 5
    cp 035h
    ret c                                   ; return the accepted numeric deletion key when it is below the mode limit
.exitRangeTableEditorToMonitor:
    jp startMonitor
appendRangeEndpointToDisplayLine:
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    push hl
    ex de,hl                                ; arrange registers to format one endpoint and append a matching symbol name when available
    push hl
    call printFixedWidthNumberToIX
    pop de
    call findSymbolOrdinalByValue
    push ix
    ld b,00ah                               ; format one endpoint and append a matching symbol name when available
.clearRangeDisplayPadding:
    ld (ix+000h),020h
    inc ix
    djnz .clearRangeDisplayPadding
    pop hl
    jr c,.finishRangeEndpointDisplay         ; finish with a blank name field when no symbol has this endpoint value
    push hl
    call resolveSymbolReferenceToName
    pop hl
    inc hl
    ld b,LABEL_LENGTH
    call printFromDEtoHLpaddedLeft
.finishRangeEndpointDisplay:
    pop hl
    ret


; Initialize ordinary assembly state for one monitor-entered source record.
;
; The immediate HL is patched with the desired monitor address.  Both the logical
; address counter and physical emission pointer receive that value, and IX points
; to the temporary encoded record.  No source record is inserted and no global
; compilation controller is started.
initializeMonitorLineAssembler:
    ld hl,00000h                            ; patched origin for monitor-entered assembly
    ld (varcAddressCounter+1),hl            ; patch varcAddressCounter+1 to bind monitor-entered assembly to the requested address and temporary record
    ld (varcAssemblyOutputPointer+1),hl     ; set physical output to the requested assembly origin
    ld ix,encodedRecordHeader               ; temporary encoded-record destination for monitor assembly
    ret


; Initialize the shared monitor/editor input-buffer guard and cursor.
;
; The byte immediately before inputBufferStart is restored to $80, the first input
; byte to the movable $01 cursor marker, and the following 32 bytes to zero.  Both
; monitor warm entry and every prompt call this routine so stale text or token
; expansion state cannot leak between commands.
monitorInputBuffersInitialization:
    ld hl,inputBufferGuardByte
    ld (hl),080h                            ; store (hl) from 080h so later code can reset the guarded monitor edit buffer and movable cursor marker
    ; clear input buffer
    inc hl
    ld (hl),001h                            ; store (hl) from 001h so later code can reset the guarded monitor edit buffer and movable cursor marker
    inc hl
    ld bc,02000h
    jp atHLrepeatBTimesC
; Select monitor token texts and repaint the panel edit line.
;
; varcTokenExpansionTableBase is the token-expansion table pointer used by the generic line
; renderer.  It is switched to monitorTables, the edit item's bitmap row start is
; calculated, and the common editor renderer expands $C1-$DA monitor prompt/status
; tokens into text.  The assembler later restores its own token table.
renderMonitorInputLine:
    ld hl,monitorTables
    ld (varcTokenExpansionTableBase+1),hl   ; patch varcTokenExpansionTableBase+1 to select monitor token expansion and repaint the panel edit row
    call getMonitorEditLineBitmapRowStart
    jp renderInputLineAtBitmapAddress


; Interactive input loop for monitor prompts and monitor assembly lines.
;
; Each iteration repaints the line, obtains a normalized key through processKey,
; rejects monitor token codes >=$80 as direct keyboard input, and handles EDIT as
; an unconditional return to startMonitor.  DELETE is ignored when the character
; immediately before the cursor is a high-bit token byte, preventing prompt text
; from being erased.  updateInputBuffer performs ordinary cursor movement,
; insertion, deletion, and ENTER detection.  On completed input, the line row is
; cleared and control returns to .initializeMonitorInputRequest.
monitorInputLoop:
    call renderMonitorInputLine
    call processKey
    cp 080h
    jr nc,monitorInputLoop                  ; ignore monitor token codes and other values at or above $80
    ; edit (CS+1)
    cp 004h
    jp z,startMonitor
    cp 003h
    jr nz,.processMonitorInputKey
    ld hl,(varcInputBufferPosition+1)
    dec hl
    bit 7,(hl)
    jr nz,monitorInputLoop
.processMonitorInputKey:
    call updateInputBuffer
    jr nz,monitorInputLoop
    call getMonitorEditLineBitmapRowStart
    jp clearBitmapTextRow
; Read `First` and `Length`, returning DE=First and HL=inclusive Last.
;
; The second prompt token is encoded as the byte $C1 that would otherwise be the
; opcode of `POP BC`; promptForMonitorValue consumes it and resumes at the next
; byte.  This compact inline-data trick is intentional.  The calculation is:
;
;     Last = First + Length - 1
;
; Several block commands then share the same implementation as their First/Last
; variants.
promptForFirstAndLength:
    call promptForMonitorValue
    defb 0xc2                               ; embed the First prompt token consumed by promptForMonitorValue
    push hl                                 ; preserve First while reading Length
    call promptForMonitorValue
    pop bc
    pop de                                  ; recover the caller return address into DE after the inline-token mechanism
    add hl,de
    dec hl                                  ; convert the exclusive sum to inclusive Last
    ret
; Read `First` and `Last`, returning DE=First and HL=Last.
;
; As above, the second inline token is the first byte ($C3) of the apparent JP
; instruction.  promptForMonitorValue consumes it as monitorTextLast and resumes
; at the embedded POP DE / RET bytes ($D1,$C9).  The odd-looking `JP $C9D1` is
; therefore compact data plus executable continuation, not an actual branch.
promptForFirstAndLast:
    call promptForMonitorValue
    defb 0xc2                               ; embed the First prompt token
    push hl
    call promptForMonitorValue              ; read inclusive Last; the following bytes encode prompt token plus POP DE/RET
    jp 0c9d1h
; Preserve an inclusive block range and reject writes into PROMETHEUS itself.
;
; Entry from FILL/LOAD-style block handlers:
;   DE = First, HL = inclusive Last
;
; The return address is temporarily removed so First and Last can be placed below
; it on the caller's stack.  BC receives First for the range checker.  Execution
; falls into checkBlockDestinationAgainstResidentRegion, which validates only the
; synthesized resident/source interval and reports `Read/Write ERROR` on overlap.
preserveBlockRangeAndCheckResidentWrite:
    pop af                                  ; remove the caller return address temporarily
    push hl                                 ; place inclusive Last beneath the saved return address
    push de
    push af                                 ; restore the return address above the preserved range
    ld b,d
    ld c,e
; Validate BC..DE as an inclusive write destination against the resident region.
;
; This helper is also entered by MOVE after it has calculated the destination's
; inclusive final address.  The register exchange leaves BC=destination First and
; DE=destination Last for checkRangeAgainstResidentRegionOnly.
;
; Important implementation detail: this path does NOT pass setWriteProtectedAreas
; and therefore does not inspect any of the five user WRITE windows.  MOVE also
; does not inspect user READ windows for its source.  The manual says a protected
; area should cause READ/WRITE ERROR, but the original machine code enforces only
; PROMETHEUS/source protection for these two block commands.  The resurrection
; preserves and documents that behavior rather than silently changing it.
checkBlockDestinationAgainstResidentRegion:
    ex de,hl
    call checkRangeAgainstResidentRegionOnly
    ld hl,acknowledgeMonitorOperationError
    ld (abortCommandAndReturnToEditor+1),hl ; patch the shared abort continuation to keep errors inside the monitor
    ret nc                                  ; return with the preserved range when no protected overlap was found
; Show the two-token monitor error line `Read/Write ERROR`.
;
; Other protection failures enter showMonitorOperationError with A already set to
; a different monitor token, notably $CE for `Run`.  The common path rebuilds the
; monitor input line as [operation-token,$D0], repaints it, beeps, waits for a key
; and key release, and returns through a fresh startMonitor entry.
showMonitorReadWriteError:
    ld a,0cdh                               ; select the packed Read/Write operation token
showMonitorOperationError:
    call monitorInputBuffersInitialization  ; reset the monitor line before constructing the error message
    ld hl,inputBufferStart
    ld (hl),a
    inc hl
    ld (hl),0d0h                            ; append the packed ERROR token
    call renderMonitorInputLine
varcRestoreRBeforeOperationError:
    ld a,000h
    ld (savedRegisterR),a
acknowledgeMonitorOperationError:
    call redrawFrontPanelAtCurrentAddress
    call beep
    call processKey
    call waitForAllKeysReleased
    jp startMonitor


stepAtCurrentMonitorAddress:
    ld hl,(varcMonitorCurrentAddress+1)     ; load the committed monitor PC and fall into the common one-instruction engine
; =============================================================================
; SINGLE-STEP / TRACE CONTROLLER
; =============================================================================
; Entry:
;   HL = machine-code address to execute as the saved user's PC
;
; The controller decodes one instruction, records both the sequential address and
; raw operand, validates pre-execution hazards, builds a scratch trampoline, and
; rewrites control-flow instructions so both sequential and taken paths return to
; PROMETHEUS.  It then restores the complete saved Z80 state, executes the scratch
; program, captures the resulting state, checks the resulting PC against RUN
; protection, applies any simulated stack callback, commits PC and T states, and
; returns through testCapsShiftEnter.
;
; decodeInstructionAtHL returns Z reset for a valid table entry.  An unknown
; encoding abandons the step and returns to the monitor rather than executing an
; arbitrary byte.  Emulator `flow from` comments around this code are observed
; test paths only and do not enumerate every possible instruction category.
;
; Important original behavior: RUN protection is checked after the instruction
; has executed and the register image has been captured.  A Run ERROR prevents PC
; and T-state commitment, but memory, stack, and saved-register side effects may
; already exist.  This is weaker than the manual's statement that the instruction
; is not executed; the resurrection documents but does not alter it.
stepInstructionAtHL:
    push hl                                 ; preserve the original instruction address for trampoline copying after decode
    call decodeInstructionAtHL              ; decode opcode, prefixes, operand, sequential PC, and base timing without executing it
    ; Move the decoder validity flags to alternate AF so the main accumulator remains available for trace setup.
    ex af,af'
    jp nz,startMonitor                      ; abandon stepping when no valid instruction-table entry describes the encoding
    ld (varcSequentialNextAddress+1),hl     ; patch the normal-path PC used by capture and simulated CALL return repair
    ld (varcTakenFlowNextAddress+1),hl      ; initialize the taken-path PC to sequential flow before any control-flow rewrite
    ld (varcDecodedInstructionOperandWord+1),de ; retain the raw decoded operand for effective-address and control-flow helpers
    push bc                                 ; preserve decoder opcode/prefix metadata across pre-execution validation
    ld a,(savedRegisterR)
    ld (varcRestoreRBeforeOperationError+1),a ; restore this exact R value if the instruction is rejected
    call validateInstructionBeforeExecution
    pop bc
    pop de
    push bc                                 ; retain decoder metadata while instruction bytes are copied into scratch RAM
    call buildInstructionExecutionTrampoline
    pop bc
    ld hl,controlFlowDescriptorTable
    call matchInstructionAccessDescriptor   ; classify the decoded instruction and return its simulation-handler index
    jr c,.executePreparedInstructionTrampoline ; execute the unmodified scratch instruction when no control-flow descriptor matched
    ld hl,tracedControlFlowHandlerOffsets   ; select the byte-offset table that maps descriptor indexes to simulation handlers
    call addAtoHL                           ; address the handler offset selected by the descriptor result
    ld a,(hl)                               ; selected offset from the data-as-opcodes table
    ld hl,simulateRelativeControlFlow
    call addAtoHL                           ; derive the exact simulation routine address from the compact offset
    ld bc,noPostFlowStackAdjustment
    ld a,(varcDecodedInstructionTStates+1)  ; start the handler with the decoded instruction's base T-state count
    call dispatchDisassemblyOperandHandler
    ld (varcTakenFlowNextAddress+1),hl      ; patch the taken capture stub with the handler-computed logical destination
    ld (varcPostTakenControlFlowCallback+1),bc ; patch the post-capture callback selected for CALL or RET stack semantics
    ld (varcTakenFlowTStates+1),a           ; patch the taken-path timing selected or adjusted by the flow handler
; Execute the prepared scratch program and commit a successful step.
;
; restoreUserStateAndExecuteTrampoline returns through one of two capture exits.
; The alternate register bank carries the resulting PC in HL; it is moved to DE
; for the RUN-table check.  When controls are enabled, the resulting address is
; checked against the dynamic resident/source range and all custom RUN windows.
;
; A nonzero path flag invokes the self-modified callback used by simulated CALL or
; RET stack adjustment.  Only after that check succeeds are current PC and the
; selected T-state count committed.  DE contains the path-specific timing value.
.executePreparedInstructionTrampoline:
    call restoreUserStateAndExecuteTrampoline
    ; Recover the path flag and capture flags in alternate AF while the resulting PC is extracted from alternate HL.
    ex af,af'
    push af                                 ; preserve the sequential/taken path flag across execution-address protection checking
    exx
    push hl                                 ; preserve that resulting PC while returning to the monitor's working register bank
    exx
    pop de
    ld hl,setExecutionProtectedAreas
    ld a,(varcInstructionControlsDisabled+1) ; read the inverse controls switch governing all configurable instruction checks
    or a
    call z,checkAddressAgainstProtectionTable ; check the resulting PC only while instruction controls are enabled
    ld a,0ceh                               ; prepare the Run ERROR text index without disturbing the carry result
    jp c,showMonitorOperationError          ; abort commitment when the resulting PC falls in a protected execution area
    pop af
    or a
varcPostTakenControlFlowCallback:
    call nz,noPostFlowStackAdjustment       ; apply the handler-selected logical stack repair only after taken control flow
    exx
    ld (varcMonitorCurrentAddress+1),hl     ; commit the captured PC as the monitor's new current address
    ld hl,(accumulatedTStates)
    add hl,de
    ld (accumulatedTStates),hl
; Test the monitor's ranged-output abort chord: CAPS SHIFT+ENTER.
;
; ROM BREAK-KEY normally begins by loading the SPACE keyboard row.  Entering at
; ROM address $1F56 skips that load; A=$BF selects the ENTER row instead, while
; the remaining ROM code still tests CAPS SHIFT.  Carry clear means both keys are
; pressed; carry set means continue.
testCapsShiftEnter:
    ld a,0bfh
    jp 01f56h
; Restore the complete saved processor image and enter the scratch trampoline.
;
; savedRegisterR and savedRegisterI are popped together as HL (L=R, H=I), followed
; by alternate BC'/DE'/HL'/AF', IY, IX, primary BC/DE/HL/AF, and finally the saved
; user SP.  The scratch program begins at encodedRecordStorageLength and starts
; with the saved DI/EI state before the copied or rewritten instruction.
;
; The R correction helper compensates for instruction fetches performed by the
; monitor/trampoline while preserving R bit 7.  This routine cannot use the normal
; monitor stack after loading the user's SP; all exits must enter a capture stub.
restoreUserStateAndExecuteTrampoline:
    ld a,0e9h
    call adjustSavedRefreshRegisterLow7     ; adjust the saved R low seven bits while preserving architectural bit 7
    ld (varcRestoreMonitorStackAfterExecution+1),sp ; save monitor SP before switching to user state
    ld sp,savedRegisterR
    pop hl
    ld a,l
    ld r,a
    ld a,h
    ld i,a
    pop bc                                  ; restore alternate BC' from the first saved register-pair word
    pop de
    pop hl
    pop af                                  ; restore alternate AF' into the monitor-visible bank temporarily
    exx                                     ; make the alternate BC'/DE'/HL' bank architectural
    ; Swap the restored alternate AF' into its architectural bank before loading the primary register image.
    ex af,af'
    pop iy
    pop ix
    pop bc
    pop de
    pop hl
    pop af
    ld sp,(savedRegisterSP)
    jp encodedRecordStorageLength
; Capture state after the taken control-flow exit.
;
; This entry sets path flag A=1 and supplies self-modified taken-path T states and
; target PC.  captureUserStateAfterSequentialFlow uses A=0, the decoder's base
; timing, and the sequential PC.  Both converge on .saveRemainingUserState after
; first preserving primary AF/HL/DE and collecting I, R, and the user SP.
captureUserStateAfterTakenFlow:
    ld (savedRegisterSP),sp
    ld sp,encodedRecordStorageLength
    push af
    ld a,i
    push af
    ld a,r
    di                                      ; prevent monitor interrupts before switching back toward serialized state
    push af
    pop af                                  ; recover R capture into AF while retaining stack layout side effects
    pop af
    pop af
    ld sp,savedRegisterSP
    push af
    push hl
    push de
    ld a,001h                               ; mark this exit as taken control flow for callback and timing selection
varcTakenFlowTStates:
    ld de,00000h                            ; supply the handler-patched taken-path T-state count
varcTakenFlowNextAddress:
    ld hl,00000h                            ; supply the handler-patched logical destination PC
    jr .saveRemainingUserState
; Entry reached by the temporary `JP` installed at the breakpoint address.
;
; The NOP is intentional.  It provides the same fall-through layout as the normal
; sequential capture entry immediately below.  State capture restores the monitor
; stack saved by executeNativeCallOrJumpThroughTrampoline, returning to the
; breakpoint cleanup code that reinstalls the displaced bytes.
breakpointHitCaptureEntry:
    nop
; Capture state after ordinary or not-taken sequential execution.
;
; The scratch trampoline jumps here after the copied instruction.  The repeated
; PUSH/POP sequence around LD A,I and LD A,R retains both values and their P/V
; flags; .saveRemainingUserState later derives the saved EI/DI state from those
; flags.  DI is issued before switching back to the monitor stack.
captureUserStateAfterSequentialFlow:
    ld (savedRegisterSP),sp
    ld sp,encodedRecordStorageLength
    push af
    ld a,i
    push af
    ld a,r
    di                                      ; disable interrupts before restoring monitor-owned stack and registers
    push af
    pop af
    pop af
    pop af
    ld sp,savedRegisterSP
    push af
    push hl
    push de
    ld a,000h
; Self-modified two-byte T-state count for the most recently decoded instruction.
;
; The disassembler writes the instruction-table timing field here with a zero
; high byte.  Stepping/tracing code later reads and adjusts this value; the plain
; listing itself does not display it.
varcDecodedInstructionTStates:
    ld de,00004h                            ; supply the decoder-patched base timing for the sequential path
varcSequentialNextAddress:
    ld hl,00000h                            ; supply the decoder-patched sequential next PC
    nop                                     ; retain the breakpoint-compatible one-byte fall-through layout before common capture
; Finish serializing the user's processor state into the monitor image.
;
; The routine saves primary BC, IX, IY, then swaps banks to save alternate
; AF'/HL'/DE'/BC'.  I and R are packed as H/L at the beginning of the image.
; Finally the original monitor SP, captured before restoration, is reloaded.
;
; The P/V bits produced by LD A,I and LD A,R are ORed and reduced to bit 0.  That
; value becomes varcInterruptEnableState.  This approximates the user's interrupt
; enable state without exposing the monitor's own temporary DI.
.saveRemainingUserState:
    push bc
    push ix
    push iy
    exx                                     ; switch to the alternate BC'/DE'/HL' bank for contiguous storage
    ; Switch to the user's alternate register bank so its AF'/HL'/DE'/BC' values can be serialized contiguously.
    ex af,af'
    push af
    push hl
    push de
    push bc
    ld a,i
    ld h,a
    ld a,r
    ld l,a
    push hl
varcRestoreMonitorStackAfterExecution:
    ld sp,00000h
    ld a,0dbh
    call adjustSavedRefreshRegisterLow7     ; normalize the saved R counter while preserving bit 7
    ld hl,interruptStateCaptureScratch
    ld a,(hl)
    dec hl
    dec hl
    or (hl)
    and 004h
    rrca
    rrca                                    ; finish converting the P/V mask to boolean 0 or 1
    ld (varcInterruptEnableState+1),a       ; patch the saved interrupt state used by the panel and next trampoline
    ret
; Post-capture callback for a simulated CALL.
;
; The real scratch CALL has pushed an address inside the trampoline on the user's
; stack.  Replace that word with the original instruction's sequential address so
; later traced or native RET execution observes the program's logical return PC.
replaceScratchCallReturnAddress:
    ld hl,(savedRegisterSP)
    ld de,(varcSequentialNextAddress+1)
    ld (hl),e
    inc hl
    ld (hl),d
    ret
; Post-capture callback for simulated RET/RETN/RETI.
;
; Advance the saved user SP by one word after the return target was read without
; executing a real RET against user memory.  Static analysis shows the ordinary
; RET path selects this callback.  The RETN/RETI rewrite reaches the same target
; preparation but callback invocation is not clearly established for every path;
; that edge case remains documented as an implementation uncertainty rather than
; being silently regularized.
advanceSavedStackAfterReturn:
    ld hl,(savedRegisterSP)
    inc hl
    inc hl
    ld (savedRegisterSP),hl
noPostFlowStackAdjustment:
    ret
; Offset table for control-flow simulation handlers.
;
; matchInstructionAccessDescriptor returns a zero-based descriptor index.  The
; byte selected here is added to simulateRelativeControlFlow, producing handlers
; for relative branches, absolute CALL/JP, RET, RST, JP (HL/IX/IY), and RETN/RETI.
; These bytes disassemble as ordinary opcodes but are data offsets, not executed
; instructions.
tracedControlFlowHandlerOffsets:
    nop                                     ; handler offset 0: relative-branch simulation entry
    inc d                                   ; handler offset 1: absolute CALL/JP simulation entry
    ld c,d                                  ; handler offset 2: RET simulation entry
    ld h,a                                  ; handler offset 3: RST-to-CALL expansion entry
    ld a,h                                  ; handler offset 4: JP (HL) target capture entry
    add a,c                                 ; handler offset 5: JP (IX) target capture entry
    add a,(hl)                              ; handler offset 6: JP (IY) target capture entry
    sub l                                   ; handler offset 7: RETN/RETI-style stacked-target entry
; Rewrite JR/JR cc/DJNZ for dual sequential/taken capture.
;
; The copied displacement becomes +3, making a taken branch skip the first JP and
; land on the taken-capture JP appended to the trampoline.  The real destination
; is calculated from the decoded sequential address plus the original signed
; displacement and saved separately.  Five T states are added for the taken path.
simulateRelativeControlFlow:
    ld hl,encodedRecordInfoByte
    ld e,(hl)
    ld (hl),003h
    ld hl,(varcSequentialNextAddress+1)     ; start target calculation from the original instruction's sequential PC
    ld d,000h
    bit 7,e                                 ; test the sign bit of the original eight-bit displacement
    jr z,.finishRelativeControlFlowTarget    ; skip sign extension for forward relative flow
    dec d
.finishRelativeControlFlowTarget:
    add hl,de                               ; derive the real branch target from sequential PC plus signed displacement
    add a,005h
    ret


; Prepare absolute CALL/JP simulation and optional direct execution.
;
; The real operand target is preserved as the taken PC, while the copied operand
; is redirected to the taken-capture jump.  CALL uses a real CALL in scratch RAM;
; after capture, replaceScratchCallReturnAddress replaces its scratch return word
; on the user's stack with the original sequential PC.
;
; directCallModeGateOpcode can return before rewriting.  In DEF mode the target is
; searched in the direct-call list; in ALL mode every target executes natively.
; Direct execution returns naturally to the sequential capture stub.
.simulateAbsoluteCallOrJump:
    cp 00ah
    jr z,.redirectAbsoluteFlowToTakenCapture
    exx
    ld de,(encodedRecordInfoByte)
    ld (restoreStackAfterDirectCallScan+1),sp ; save monitor SP before reusing SP as the target-list cursor
    ld hl,directCallAddressList
    ld b,(hl)
    inc hl
    ld sp,hl
; Scan count-1 direct-call target words using SP as a compact iterator.
;
; The real monitor SP is first saved in restoreStackAfterDirectCallScan.  Each POP
; obtains one candidate word and compares it with DE, the traced CALL/RST target.
; A match reaches directCallModeGateOpcode with Z set.  Exhaustion reaches it with
; Z clear.  The opcode stored there implements NON/DEF/ALL without another branch
; table.  The monitor SP is restored before either path continues.
.scanDirectCallAddressList:
    djnz .compareDirectCallAddress
    jr restoreStackAfterDirectCallScan
.compareDirectCallAddress:
    pop hl                                  ; pop the next direct-call candidate through the temporary stack iterator
    or a
    sbc hl,de
    jr nz,.scanDirectCallAddressList
restoreStackAfterDirectCallScan:
    ld sp,00000h
    exx                                     ; return to the trace engine's original register bank
directCallModeGateOpcode:
    ; execution mode
    ; 00 (nop)   - NON
    ; c8 (ret z) - DEF
    ; c9 (ret)   - ALL
    nop                                     ; execute the current NON/DEF/ALL gate opcode using the scan's Z result
    add a,008h                              ; select taken CALL timing relative to the decoder's base value
    ld hl,varcDecodedInstructionTStates+1   ; address the low byte of the decoded T-state count
    inc (hl)
    ld bc,replaceScratchCallReturnAddress
.redirectAbsoluteFlowToTakenCapture:
    ld hl,(encodedRecordInfoByte)
    ld de,encodedRecordPayloadWorkspace
    ld (encodedRecordInfoByte),de
    ret
    ld hl,(savedRegisterSP)
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld hl,encodedRecordHeader
    ld a,(hl)
    add a,002h                              ; convert RET encoding toward the corresponding JP form used by the trampoline
    cp 0cbh
    jr nz,.appendReturnCaptureJumps          ; keep the conditional conversion when it already maps correctly
    sub 008h                                ; normalize unconditional RET to the unconditional JP encoding
.appendReturnCaptureJumps:
    ld (hl),a
    call writeDEWordAtHLAndAdvance
    ld a,00ah
    ld bc,advanceSavedStackAfterReturn
    jr .appendCaptureJumpsThenProcessAbsoluteFlow
    ld hl,encodedRecordHeader
    ld a,(hl)
    and 038h                                ; isolate the vector address bits from the RST opcode
    ld (hl),0cdh
    inc hl
    ld (hl),a
    inc hl
    ld (hl),000h                            ; zero-extend the RST vector to a full address
    inc hl
    ld a,003h
.appendCaptureJumpsThenProcessAbsoluteFlow:
    call appendSequentialAndTakenCaptureJumps
    jr .simulateAbsoluteCallOrJump
    ld hl,(savedRegisterD+1)                ; load saved HL as the logical destination of JP (HL)
    jr .setSequentialCaptureAddressFromHL
    ld hl,(savedRegisterIYHigh+1)           ; load saved IX as the logical destination of JP (IX)
    jr .clearSecondCopiedFlowOpcodeByte
    ld hl,(savedRegisterIY)
.clearSecondCopiedFlowOpcodeByte:
    xor a
    ld (encodedRecordInfoByte),a
.setSequentialCaptureAddressFromHL:
    xor a
    ld (encodedRecordHeader),a
    ld (varcSequentialNextAddress+1),hl     ; patch sequential capture with the indirect register target
    ret
    ld bc,advanceSavedStackAfterReturn
    ld hl,(savedRegisterSP)
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    jr .clearSecondCopiedFlowOpcodeByte
; Copy the decoded instruction into scratch RAM and append capture exits.
;
; beginExecutionTrampoline emits DI or EI first.  BC is the instruction byte
; length and DE the original address; LDIR copies exactly those bytes.  Two JP
; stubs are then appended: sequential capture first, taken capture second.
; Control-flow handlers may replace copied opcodes/operands and patch either JP.
buildInstructionExecutionTrampoline:
    ld hl,(varcSequentialNextAddress+1)     ; load the decoder's sequential PC to derive the exact instruction byte length
    and a
    sbc hl,de                               ; compute instruction length as sequential address minus original address
    ld b,h
    ld c,l
    call beginExecutionTrampoline
    ex de,hl
    ldir                                    ; copy exactly the decoded instruction bytes into executable scratch RAM
    ex de,hl                                ; restore HL as the cursor immediately after the copied instruction
appendSequentialAndTakenCaptureJumps:
    ld de,captureUserStateAfterSequentialFlow
    call writeJumpAtHL
    ld de,captureUserStateAfterTakenFlow
writeJumpAtHL:
    ld (hl),0c3h
writeDEWordAtHLAndAdvance:
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    ret
beginExecutionTrampoline:
    ld hl,encodedRecordStorageLength        ; start the scratch program at the reusable encoded-record workspace
    ld a,(varcInterruptEnableState+1)       ; load saved interrupt state as boolean DI=0 or EI=1
    add a,a
    add a,a
    add a,a
    add a,0f3h                              ; map the delta onto $F3 DI or $FB EI
    ld (hl),a
    inc hl
    ret
; Reject HALT under saved DI, then validate memory effects when enabled.
;
; `(B,C)` carries decoded opcode/prefix metadata.  HALT is recognized before the
; controls-disabled test and produces `Interrupt ERROR` whenever the saved state
; is DI, even with instruction controls OFF.  Other accesses are delegated to
; .enforceInstructionMemoryControls.
validateInstructionBeforeExecution:
    ld a,b                                  ; start exact HALT recognition from the decoded opcode byte
    sub 076h
    or c
    jr nz,.enforceInstructionMemoryControls  ; delegate every non-HALT instruction to normal memory-access validation
    ld a,(varcInterruptEnableState+1)       ; load the saved EI/DI state for the HALT deadlock check
    or a
    ret nz                                  ; allow HALT only when an interrupt can eventually release the processor
    ld a,0cfh                               ; select the Interrupt ERROR text index for HALT under DI
    jp showMonitorOperationError
; Enforce READ/WRITE windows for the instruction about to execute.
;
; Zero in varcInstructionControlsDisabled means checks are active.  ED block
; transfers receive a special full-range treatment; other instructions are
; matched against compact read/write descriptor tables.  All checks occur before
; the copied instruction runs.
;
; LDIR/LDDR calculate inclusive source and destination ranges from saved HL, DE,
; BC and direction, check WRITE then READ, and replace the table timing with
; `21*BC-5`.  This models the complete repeated instruction rather than one Z80
; iteration.  If BC is zero, 16-bit arithmetic naturally follows the original
; implementation's wrap behavior.
.enforceInstructionMemoryControls:
; Protection-table enforcement inside the instruction stepping engine.
;
; When instruction controls are enabled, decoded instruction metadata determines
; whether an effective memory range is read, written, or executed.  The engine
; calls checkRangeAgainstProtectionTable with setWriteProtectedAreas and
; setReadProtectedAreas, and checkAddressAgainstProtectionTable with
; setExecutionProtectedAreas.  A collision is converted to `Read/Write ERROR` or
; `Run ERROR` before the emulated instruction is allowed to continue.
;
; This is the path that actually honors the five configurable READ/WRITE/RUN
; windows.  It is separate from the simpler MOVE/FILL block-operation path.
varcInstructionControlsDisabled:
    ; on/off all controls of instructions
    ld a,000h
    or a
    ret nz                                  ; skip all descriptor-table protection checks when controls are OFF
    ld a,c
    and 040h
    jr z,.validateGenericInstructionMemoryAccess
    ld a,b                                  ; retain the decoded ED opcode for LDIR versus LDDR classification
    exx                                     ; borrow the alternate bank while constructing source and destination ranges
    cp 0b0h
    ld bc,(savedRegisterBC)
    ld de,(savedRegisterDE)
    ld hl,(savedRegisterD+1)                ; load the user's source start address from saved HL
    jr nz,.prepareBackwardBlockTransferRanges ; construct descending ranges unless the opcode is forward LDIR
    push hl
    add hl,bc
    dec hl                                  ; convert the exclusive source end to an inclusive last address
    push hl
    ex de,hl                                ; switch HL to the destination start while retaining source data on the stack
    push hl
    add hl,bc
    dec hl                                  ; convert the destination end to an inclusive last address
    jr .validateBlockTransferRangesAndTiming
.prepareBackwardBlockTransferRanges:
    cp 0b8h
    jr nz,.restoreMainBankAfterBlockTransferCheck ; restore the main bank when this ED block-class opcode needs no special range model
    push hl
    and a
    sbc hl,bc
    inc hl                                  ; convert to the inclusive lower endpoint source-count+1
    ex (sp),hl
    push hl
    ex de,hl
    push hl
    and a
    sbc hl,bc                               ; derive the lower destination endpoint
    inc hl                                  ; convert it to the inclusive count-byte range
    ex (sp),hl
.validateBlockTransferRangesAndTiming:
    push hl                                 ; retain the destination endpoint while timing is calculated
    ld h,b
    ld l,c
    ld de,00015h
    call multiplyHLByDE                     ; calculate 21 times BC for complete repeated-instruction timing
    dec hl
    dec hl
    dec hl
    dec hl
    dec hl
    ld (varcDecodedInstructionTStates+1),hl ; patch the decoded timing used when this instruction is committed
    ld hl,setWriteProtectedAreas
    pop de
    pop bc
    call checkRangeAgainstProtectionTable
    jp c,showMonitorReadWriteError          ; reject the instruction before execution on any destination collision
    ld hl,setReadProtectedAreas
    pop de
    pop bc
    call checkRangeAgainstProtectionTable
    jp c,showMonitorReadWriteError          ; reject the instruction before execution on any source collision
    exx                                     ; restore the monitor's main register bank after successful validation
    ret
.restoreMainBankAfterBlockTransferCheck:
    exx                                     ; restore the main register bank for an unhandled block-class opcode
.validateGenericInstructionMemoryAccess:
    ld hl,readAccessDescriptorTable
    push de                                 ; preserve the raw operand/displacement across the READ table lookup
    call matchInstructionAccessDescriptor
    ld hl,setReadProtectedAreas
    call validateMatchedMemoryAccess
    ld hl,writeAccessDescriptorTable
    pop de
    call matchInstructionAccessDescriptor
    ld hl,setWriteProtectedAreas            ; fall through with the WRITE-protection table selected
; Resolve and validate one descriptor-selected memory access.
;
; The selected accessor returns the first effective address in HL; it is checked
; against the supplied READ or WRITE protection table.  For a two-byte access the
; incremented second address is checked separately, preserving wraparound at
; $FFFF.  A collision immediately enters the common Read/Write ERROR path.
validateMatchedMemoryAccess:
    ret c                                   ; return immediately when no descriptor matched this READ or WRITE class
    push hl
    push af
    ld hl,effectiveAddressAccessorOffsets   ; select the table of offsets to effective-address loader routines
    call addAtoHL                           ; index the accessor-offset table with the descriptor's low three bits
    ld a,(hl)
    ld hl,loadEffectiveAddressFromBC
    call addAtoHL                           ; derive the exact effective-address loader entry
    call dispatchDisassemblyOperandHandler
    pop af
    ex (sp),hl                              ; exchange resolved address and protection-table pointer on the stack
    pop de
    push af                                 ; retain the width flag across the first address check
    push hl
    call checkAddressAgainstProtectionTable ; validate the first effective address against the selected READ or WRITE windows
    pop hl
    jp c,showMonitorReadWriteError          ; raise Read/Write ERROR immediately on the first-byte collision
    pop af
    ret z                                   ; finish after one address when the descriptor marks a byte access
    inc de
    call checkAddressAgainstProtectionTable
    jp c,showMonitorReadWriteError          ; raise Read/Write ERROR on a second-byte collision
    ret


; Match decoded opcode/prefix metadata against a compact descriptor table.
;
; Table format:
;
;   count
;   repeated count times: opcodeMask, expectedOpcode, descriptor
;
; A row matches when `(B & opcodeMask) == expectedOpcode` and the descriptor's
; high nibble equals the decoded prefix-class high nibble in C.  On success the
; low nibble is returned: bits 0..2 select an effective-address accessor and bit
; 3 means the access spans two bytes.  Carry set means no descriptor matched.
matchInstructionAccessDescriptor:
    ld a,c                                  ; extract the decoded prefix-class field used by every descriptor row
    and 0f0h
    ld c,a                                  ; keep the normalized prefix class in C during table traversal
    ld d,(hl)
    inc hl
.scanNextInstructionAccessDescriptor:
    ld a,b                                  ; reload the decoded opcode for this descriptor candidate
    and (hl)                                ; apply the candidate's opcode mask
    inc hl                                  ; advance from mask to expected masked opcode
    cp (hl)                                 ; compare the masked opcode with the candidate's expected value
    inc hl
    jr z,.returnInstructionAccessDescriptor  ; inspect prefix and result fields only when the opcode pattern matched
.skipInstructionAccessDescriptor:
    inc hl                                  ; skip the packed descriptor byte of a rejected row
    dec d
    jr nz,.scanNextInstructionAccessDescriptor
    scf                                     ; signal no descriptor match to the caller
    ret
.returnInstructionAccessDescriptor:
    ld a,(hl)
    and 0f0h
    cp c                                    ; require the descriptor prefix class to match the decoded instruction
    jr nz,.skipInstructionAccessDescriptor   ; resume scanning when opcode matched but prefix class did not
    ld a,(hl)                               ; reload the packed descriptor after prefix validation
    and 00fh                                ; isolate width bit and three-bit accessor/handler index
    bit 3,a
    res 3,a
    ret
    ld hl,effectiveAddressAccessorOffsets   ; select the effective-address offset table for the vestigial inline dispatch path
    call addAtoHL                           ; index that table with the matched selector
    ld a,(hl)
    ld hl,loadEffectiveAddressFromBC
    call addAtoHL                           ; derive the selected loader entry
    call dispatchDisassemblyOperandHandler  ; dispatch to the selected effective-address loader
; Effective-address accessor offset table.
;
; Descriptor indices select BC, DE, HL, IX+d, IY+d, SP, SP-2, or immediate NN.
; The bytes are offsets into the contiguous accessor routine sequence and are
; intentionally represented by opcodes in the disassembly.
effectiveAddressAccessorOffsets:
    nop                                     ; accessor offset 0 selects the saved-BC loader
    inc b                                   ; accessor offset 1 selects the saved-DE loader
    ; This byte is data, not an EX instruction: accessor-table entry 2 selects the saved-HL loader offset.
    ex af,af'
    inc c                                   ; accessor offset 3 selects the saved-IX-plus-displacement loader
    ld de,0211dh                            ; packed offsets 4, 5 and 6 select saved-IY+d, saved-SP and saved-SP-minus-two loaders
    daa                                     ; accessor offset 7 selects the decoded-immediate-address loader
loadEffectiveAddressFromBC:
    ld hl,(savedRegisterBC)
    ret
    ld hl,(savedRegisterDE)
    ret
    ld hl,(savedRegisterD+1)                ; load effective address from the saved user HL pair
    ret
    ld hl,(savedRegisterIYHigh+1)           ; load saved IX as the base for an IX+d effective address
    jr .addSignedDecodedDisplacementToEffectiveAddress
    ld hl,(savedRegisterIY)
.addSignedDecodedDisplacementToEffectiveAddress:
    bit 7,e                                 ; test the sign of the decoded eight-bit displacement in E
    ld d,000h
    jr z,.applySignedDisplacementToEffectiveAddress ; skip sign extension for offsets below $80
    dec d
.applySignedDisplacementToEffectiveAddress:
    add hl,de                               ; derive the indexed effective address from saved base plus signed displacement
    ret
    ld hl,(savedRegisterSP)
    ret
    ld hl,(savedRegisterSP)
    dec hl
    dec hl
    ret
; Self-modified raw operand word returned as HL to tracing helpers.
;
; decodeInstructionAtHL stores DE here before simulation.  The disassembler's
; textual path uses its own DE copy, while stepping code can call this tiny
; `LD HL,nn / RET` accessor.
varcDecodedInstructionOperandWord:
    ld hl,00000h                            ; return the self-modified decoded immediate/displacement word through HL
    ret
; Treat the current address as one little-endian DEFW item.
;
; The word is read without checking whether its second byte remains inside the
; configured DEFW range.  BC is loaded with the DEFW pseudo-opcode and record
; metadata, and HL is advanced by two before entering the shared record builder.
.buildDefwDisassemblyRecord:
    ld e,(hl)
    inc hl                                  ; advance to the word's high byte without enforcing range-end alignment
    ld d,(hl)
    ld bc,00937h
    jr .advancePastDisassembledData
; Treat the current address as one DEFB item.
;
; This path is used for explicit DEFB areas, the hidden PROMETHEUS/source range,
; and unknown instruction encodings.  One byte is zero-extended in DE and HL is
; advanced exactly once.
.buildDefbDisassemblyRecord:
        ld hl,(varcDisassemblyInstructionAddress+1) ; reload the original item address because protection-table checking used HL
    ld d,000h                               ; zero-extend the single data byte into DE
    ld e,(hl)
    ld bc,00637h
.advancePastDisassembledData:
    inc hl
    jr .buildTemporaryDisassemblyRecord
; =============================================================================
; DISASSEMBLE ONE MACHINE INSTRUCTION OR DATA ITEM INTO lineBuffer
; =============================================================================
; Entry:
;   HL = address to decode
;
; Return:
;   lineBuffer = one 32-column PROMETHEUS-style source line, or a blank separator
;   HL         = next sequential address (unchanged for a separator-only call)
;
; The immediate byte in the opening `LD A,n` is self-modified by the instruction
; decoder.  A nonzero value means the previous line was an unconditional JR, JP,
; JP (HL/IX/IY), or RET.  In that case this call emits one blank separator row,
; clears the flag, and returns without consuming memory.
;
; Otherwise the current address is remembered and checked against the DEFB and
; DEFW display-area tables.  A data-area hit constructs a pseudo-instruction;
; normal memory is decoded through decodeInstructionAtHL.  An opcode/prefix
; combination absent from instructionsTable falls back to DEFB for the first byte
; only, guaranteeing forward progress through arbitrary data.
;
; The textual line is not handwritten.  A compact temporary source record is
; built and passed to expandSourceRecordToLineBuffer, so mnemonic spelling,
; operand syntax, case conversion, symbol names, field widths, and editor markers
; are identical to ordinary PROMETHEUS source expansion.
disassembleNextLineToBuffer:
    ld a,000h                               ; load the self-modified pending-separator flag left by the previous decoded transfer
    or a                                    ; test whether this call should decode memory or emit a blank separator only
    jr z,.decodeDisassemblyAtCurrentAddress  ; decode the item at HL when no separator is pending
; Fill the complete 32-character lineBuffer with spaces.
;
; A is also loaded into B, so the loop count and fill byte are both $20.  The
; separate clearDisassemblyReentryFlag tail belongs to the disassembler state
; machine; ordinary list initialization enters only at this label and returns
; after clearing its self-modified flag.
clearMonitorLineBuffer:
    ld a," "
    ld b,a
    ld de,lineBuffer
.clearMonitorLineBufferLoop:
    ld (de),a
    inc de
    djnz .clearMonitorLineBufferLoop
; Clear the pending blank-line flag embedded at disassembleNextLineToBuffer+1.
;
; This tail is reached after filling lineBuffer with spaces.  It returns with HL
; unchanged so the next call decodes the address that follows the transfer.
clearPendingDisassemblySeparatorAndReturn:
    xor a
    ld (disassembleNextLineToBuffer+1),a    ; clear the self-modified separator flag in the decoder entry instruction
    ret
.decodeDisassemblyAtCurrentAddress:
    ld (varcDisassemblyInstructionAddress+1),hl ; remember the item's original address for relative targets, labels, and fallback data
    ex de,hl
    ld hl,defbDisassemblyAreaTable
    call checkAddressAgainstProtectionTable
    jr c,.buildDefbDisassemblyRecord         ; force a one-byte DEFB pseudo-record when the address lies in a DEFB interval
    ld hl,defwDisassemblyAreaTable
    call checkAddressAgainstProtectionTable
    ex de,hl
    jr c,.buildDefwDisassemblyRecord         ; force a two-byte DEFW pseudo-record when the address lies in a DEFW interval
    call decodeInstructionAtHL              ; decode one Z80 instruction and recover canonical opcode, metadata, operands, and next address
    ; restore the decoder's success flags from alternate AF without disturbing returned registers
    ex af,af'
    jr nz,.buildDefbDisassemblyRecord        ; fall back to a one-byte DEFB record when no instruction-table entry matched
; Build a shifted temporary compressed record for the source expander.
;
; decodeInstructionAtHL returns B=canonical opcode and C=prefix/operand metadata.
; The disassembler deliberately bases this temporary record one byte earlier than
; the normal insertion workspace:
;
;   encodedRecordStorageLength  used as temporary record byte 0 (opcode)
;   encodedRecordHeader         used as temporary record byte 1 (information)
;   encodedRecordInfoByte       first operand-expression byte
;
; Thus `(IX-2)=B` and `(IX-1)=C` are correct here even though those labels have
; different roles during ordinary source construction.  This record is expanded
; only; it is never inserted directly.
;
; The low three information bits select one of eight compact operand handlers.
; They append signed displacements, relative targets, RST vectors, numeric words,
; symbol ordinals, and expression terminators in the exact representation expected
; by the normal source-record expander.
.buildTemporaryDisassemblyRecord:
    push hl                                 ; preserve the next sequential address across temporary record construction and expansion
    ld ix,encodedRecordInfoByte
    ld (ix-001h),c
    ld (ix-002h),b
    ld a,c
    and 007h
    ld c,a                                  ; use the class as the low byte of the offset-table index
    ld b,000h                               ; zero-extend the operand-class index
    ld hl,disassemblyOperandHandlerOffsets
    add hl,bc                               ; select the offset byte for operand class zero through seven
    ld c,(hl)                               ; selected self-relative handler offset into C
    ld hl,formatIndexedDisplacementOperand  ; use the first operand handler as the offset-table base address
    add hl,bc                               ; add the selected byte offset to obtain the concrete operand handler
dispatchDisassemblyOperandHandler:
    jp (hl)
; Eight one-byte offsets from formatIndexedDisplacementOperand.
;
; The bytes are executable opcodes only by accident of disassembly; they are a
; jump-offset table indexed by operand class 0..7:
;
;   0 no operand                 4 signed IX/IY displacement
;   1 one-byte immediate         5 displacement plus immediate
;   2 two-byte value/address     6 RST vector encoded in opcode
;   3 relative branch target     7 invalid/not-instruction fallback
disassemblyOperandHandlerOffsets:
    ld e,c                                  ; encode the self-relative handler offset for operand class 0, which has no operand bytes
    ld d,e                                  ; encode the self-relative handler offset for operand class 1, a one-byte immediate
    daa                                     ; encode the self-relative handler offset for operand class 2, a two-byte value or address
    add hl,de                               ; encode the self-relative handler offset for operand class 3, a signed relative target
    nop                                     ; encode the zero offset for operand class 4, an IX/IY displacement
    dec b                                   ; encode the self-relative handler offset for class 5, displacement plus immediate byte
    ld c,h                                  ; encode the self-relative handler offset for class 6, an RST vector in the opcode
    daa                                     ; encode the invalid-class fallback offset that ultimately emits DEFB
; Convert an 8-bit signed displacement in E to printable sign plus magnitude.
;
; Negative values append '-' and replace E with its absolute magnitude.  Positive
; values append no explicit plus sign here; indexed syntax later supplies the
; literal '+' between IX/IY and a positive displacement.
normalizeSignedDisplacementMagnitude:
    bit 7,e
    ret z
    ld (ix+000h),02dh                       ; append a minus sign before the absolute value of a negative displacement
    inc ix
    xor a                                   ; prepare zero minus E to form the unsigned magnitude
    sub e                                   ; negate the two's-complement displacement byte
    ld e,a
    ret
formatIndexedDisplacementOperand:
    call normalizeSignedDisplacementMagnitude
    jr .zeroExtendDisassemblyOperandByte
    call normalizeSignedDisplacementMagnitude
    ld h,000h                               ; zero-extend the displacement magnitude for compact number formatting
    ld l,e
    push de                                 ; preserve the following immediate byte pair while the displacement is printed
    call printCompactNumberToIX
    pop de
    ld e,d
    ld (ix+000h),01fh                       ; append the compact expression separator used between indexed displacement and immediate
    inc ix
    jr .zeroExtendDisassemblyOperandByte     ; zero-extend and print the immediate byte
    ld d,000h                               ; assume a nonnegative relative displacement before sign extension
    bit 7,e                                 ; test the sign bit of the JR/DJNZ displacement
    jr z,varcDisassemblyInstructionAddress  ; use a zero high byte for a nonnegative relative displacement
    dec d                                   ; sign-extend a negative displacement with $FF in D
; Self-modified instruction address used while constructing relative targets.
;
; The operand-class-3 handler sign-extends the displacement in E and computes
; `instructionAddress + 2 + displacement`, matching JR and DJNZ encoding.  Other
; code reads the same immediate when it needs the original address for data or
; symbolic-prefix rendering.
varcDisassemblyInstructionAddress:
    ld hl,00001h
    inc hl
    inc hl
    add hl,de                               ; add the sign-extended displacement to obtain the absolute branch target
    ex de,hl
; Self-modified disassembly address/symbol mode; see monCycleDisassemblyAddressMode.
;
; For two-byte operands, mode 1 prints a number, mode 2 tries an exact symbol,
; and encoded mode 0 tries exact then target-1 and emits `symbol+1`.  Symbol
; references are stored as tagged ordinals in the temporary record, not copied as
; text, so the ordinary expander resolves their spelling and case.
varcDisassemblyAddressMode:
    ld c,000h
    dec c                                   ; map mode 1 to zero for the direct numeric branch
    jr z,.appendNumericDisassemblyOperand    ; append a number immediately when symbolic substitution is disabled
    call findSymbolOrdinalByValue
    jr c,.tryDisassemblyLabelPlusOne         ; try the optional symbol-plus-one rule when no exact symbol exists
    call appendTaggedSymbolOrdinalToDisassemblyRecord
    jr .expandTemporaryDisassemblyRecord
.tryDisassemblyLabelPlusOne:
    dec c
    jr z,.appendNumericDisassemblyOperand    ; fall back to a numeric operand when exact-only mode already failed
    dec de                                  ; search for a symbol whose value is one less than the decoded target
    call findSymbolOrdinalByValue
    inc de                                  ; restore the original decoded target after the adjusted lookup
    jr c,.appendNumericDisassemblyOperand    ; use a numeric operand when target-minus-one also has no symbol
    dec de
    call appendTaggedSymbolOrdinalToDisassemblyRecord
    ld de,02b31h
    call appendTwoBytesToDisassemblyExpression
    jr .expandTemporaryDisassemblyRecord
    ld hl,(varcDisassemblyInstructionAddress+1) ; reload the original opcode address for RST vector extraction
    ld a,(hl)
    and 038h
    ld e,a
.zeroExtendDisassemblyOperandByte:
    ld d,000h                               ; zero-extend a one-byte immediate, displacement magnitude, or RST vector
.appendNumericDisassemblyOperand:
    ex de,hl                                ; move the numeric operand into HL for the shared formatter
    call printCompactNumberToIX
; Terminate and expand the shifted temporary record into lineBuffer.
;
; `$C0` is the variable-record terminal marker.  IX is moved back to
; encodedRecordStorageLength, which is the temporary opcode byte in this special
; layout, and the standard source-record expander clears and reconstructs the
; complete editor line.
;
; After expansion, an exact symbol at the instruction address is printed in the
; nine-column label field in symbolic modes.  Otherwise the numeric address is
; printed only when varcShowNumericDisassemblyAddresses is enabled.  Labels are
; therefore not suppressed by the C command.
.expandTemporaryDisassemblyRecord:
    ld (ix+000h),0c0h                       ; terminate the variable temporary record with the standard $C0 marker
    ld ix,encodedRecordStorageLength
    call expandSourceRecordToLineBuffer
    ld ix,lineBuffer
    ld de,(varcDisassemblyInstructionAddress+1) ; recover the item's original address for label and numeric-prefix rendering
    ld a,(varcDisassemblyAddressMode+1)     ; read the persistent disassembly symbol-substitution mode
    dec a
    jr z,.renderNumericDisassemblyAddressIfEnabled
    call findSymbolOrdinalByValue
    jr c,.renderNumericDisassemblyAddressIfEnabled ; use the numeric address policy when no exact address label exists
    call resolveSymbolReferenceToName
    ld b,009h
    push ix                                 ; preserve the lineBuffer destination pointer across the text helper's HL convention
    pop hl
    call printFromDEtoHLpaddedLeft          ; right-align or pad the symbol name into the source label field
    jr .returnDisassembledLine
.renderNumericDisassemblyAddressIfEnabled:
varcShowNumericDisassemblyAddresses:
    ld a,001h
    dec a                                   ; convert enabled value one to zero for the branch test
    jr nz,.returnDisassembledLine            ; leave the address field blank when numeric prefixes are disabled
    ex de,hl                                ; move the item address from DE into the numeric formatter's HL input
    call printFixedWidthNumberToIX
    ld (ix+000h),020h                       ; restore the separator space following the generated address field
.returnDisassembledLine:
    pop hl
    ret
; Shared monitor number-formatting entries.
;
; `skipOneColumnAndPrintFixedWidthNumberToIX` first advances IX by one column.
; `printFixedWidthNumberToIX` selects C=0, forcing every digit position to be
; emitted.  `printCompactNumberToIX` selects C=1, suppressing leading zeroes until
; the first nonzero digit.  All three then use the common decimal/hex formatter
; controlled by varcHexMode.
skipOneColumnAndPrintFixedWidthNumberToIX:
    inc ix
printFixedWidthNumberToIX:
    ld c,000h
    jr .printNumberToIXWithLeadingMode
printCompactNumberToIX:
    ld c,001h
.printNumberToIXWithLeadingMode:
    jp printNumberToIX
; Append a two-byte symbol ordinal to the temporary expression.
;
; Bit 7 is set in the high byte to distinguish the ordinal from literal ASCII.
; The following shared entry appends any two literal bytes and advances IX twice;
; it is also used for the `+1` suffix.
appendTaggedSymbolOrdinalToDisassemblyRecord:
    set 7,d                                 ; tag the high ordinal byte so the source expander recognizes a symbol reference
appendTwoBytesToDisassemblyExpression:
    ld (ix+000h),d
    inc ix
    ld (ix+000h),e
    inc ix
    ret
; Search the symbol table for the first ordinal whose stored value equals DE.
;
; The scan follows ordinal-order vectors, masks their DEFINED/LOCKED flag bits,
; and compares the two-byte value in each movable symbol record.  It does not test
; the state flags themselves; any stored value can match.  On success carry is
; clear and DE is the one-based symbol ordinal.  On exhaustion carry is set.
;
; Duplicate values resolve to the first ordinal.  Mode-3 `symbol+1` is implemented
; by calling this routine again with target-1 after an exact search fails.
findSymbolOrdinalByValue:
    push bc                                 ; preserve the caller's BC while the search uses both primary and alternate register sets
    exx                                     ; switch to the alternate register set used for symbol-table traversal state
    ld de,00000h
    ld hl,(varcSymbolTablePt+1)             ; load the movable symbol-table base pointer
    ld c,(hl)
    inc hl
    ld b,(hl)
    inc hl
    push hl                                 ; preserve the vector base while deriving the value-record area base
    add hl,bc
    add hl,bc
    ld (varcSymbolValueAreaBase+1),hl       ; patch the movable base used to address symbol value records
    exx                                     ; return to the caller-facing register set
    pop hl
    exx                                     ; resume traversal in the alternate register set
.scanNextSymbolForValue:
    ld a,b
    or c
    scf                                     ; preselect carry set as the not-found result
    jr z,.finishSymbolValueSearch            ; finish with not-found carry when the complete ordinal range is exhausted
    exx
    inc hl
    ld a,(hl)
    ld c,a                                  ; retain the unmasked vector high byte for offset reconstruction
    and 0c0h
    ld a,c
    jr nz,.loadSymbolValueFromVector         ; load and compare the referenced symbol value when flag bits are nonzero
    inc a                                   ; convert an all-zero vector byte into the sentinel step used by the original scan
    jr .advanceSymbolValueSearch
.loadSymbolValueFromVector:
    push hl                                 ; preserve the current vector pointer while its record offset is resolved
    dec hl                                  ; move back to the vector offset low byte
    ld l,(hl)
    and 03fh                                ; remove DEFINED/LOCKED bits from the vector offset high byte
    ld h,a                                  ; complete the 14-bit movable symbol-record offset
varcSymbolValueAreaBase:
    ld bc,09c38h
    add hl,bc
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    xor a
    sbc hl,de
    pop hl
.advanceSymbolValueSearch:
    inc hl
    exx
    dec bc
    inc de
    jr nz,.scanNextSymbolForValue
    exx                                     ; switch back so the common exit can restore caller registers
.finishSymbolValueSearch:
    exx                                     ; leave alternate traversal state and restore the caller-facing registers
    pop bc
    ret
; Decode one Z80 instruction at HL using the shared five-byte instruction table.
;
; Prefix recognition produces the same information bits used by compressed
; source records:
;
;   bit 7 CB      bit 6 ED      bit 5 DD      bit 4 FD
;   bits 0..2 operand class
;
; DD CB d op and FD CB d op are handled in their physical byte order: E receives
; displacement d, B receives the final opcode, and the returned next address is
; one byte after that opcode.  RST opcodes are canonicalized to $C7 for table
; lookup; their vector is later recovered from bits 3..5 of the original byte.
;
; Return on a valid table match:
;   HL = next sequential address
;   B  = canonical opcode
;   C  = prefix bits OR operand class
;   DE = raw operand word, immediate, or displacement as applicable
;   AF' Z set
;
; An invalid prefix/opcode combination returns AF' nonzero; the caller renders
; the original first byte as DEFB.  The table's low five timing bits are copied
; into varcDecodedInstructionTStates for the tracing engine.
;
; The opening transfer classifier requests a blank separator only after
; unconditional JR $18, JP $C3, JP (HL/IX/IY) $E9, and RET $C9.  Conditional
; branches, CALL, RST, and conditional returns do not set it.
decodeInstructionAtHL:
    ld a,(hl)
    and 0c7h                                ; canonicalize every RST opcode to $C7 while leaving other opcodes distinct
    cp 0c7h                                 ; test whether the masked opcode belongs to the RST family
    ld b,a
    ld c,000h                               ; start with no DD/FD/ED/CB prefix bits in the information byte
    jr z,.advanceToInstructionOperandBytes   ; treat RST as an unprefixed opcode and proceed directly to operand positioning
    ld a,(hl)
    ld c,040h                               ; preselect the ED-family information bit
    cp 0edh
    jr z,.advancePastInstructionPrefix       ; consume ED and load the following opcode when present
    ld c,000h
    cp 0ddh                                 ; test for a DD index prefix
    jr nz,.testIyInstructionPrefix
    set 5,c
    jr .decodeIndexedInstructionPrefix
.testIyInstructionPrefix:
    cp 0fdh                                 ; test for an FD index prefix
    jr nz,.testCbInstructionPrefix
    set 4,c
.decodeIndexedInstructionPrefix:
    inc hl
    ld a,(hl)
    cp 0cbh                                 ; test for the four-byte DD/FD CB displacement form
    jr nz,.loadDecodedInstructionOpcode      ; use the current byte as the opcode for an ordinary indexed instruction
    set 7,c
    inc hl
    ld e,(hl)
    inc hl
    ld b,(hl)
    push hl
    jr .classifyUnconditionalTransferForSeparator
.testCbInstructionPrefix:
    cp 0cbh
    jr nz,.loadDecodedInstructionOpcode      ; use the byte itself as an ordinary unprefixed opcode when it is not CB
    set 7,c
.advancePastInstructionPrefix:
    inc hl
.loadDecodedInstructionOpcode:
    ld b,(hl)
.advanceToInstructionOperandBytes:
    inc hl
    push hl
    ld e,(hl)
    inc hl
    ld d,(hl)
; Decide whether the next disassembly call should emit a blank separator.
;
; Prefix-family metadata excludes CB/ED families immediately.  Unprefixed and
; DD/FD instructions are then checked for the small set of unconditional flow
; opcodes documented above.  The result is written into the opening immediate of
; disassembleNextLineToBuffer.
.classifyUnconditionalTransferForSeparator:
    push de                                 ; preserve the raw operand word while opcode and prefix metadata are classified
    ld a,c
    cp 03fh
    jr nc,.selectNoDisassemblySeparator      ; select no separator for metadata values at or above the CB/ED threshold
    cp 010h                                 ; distinguish unprefixed opcodes from DD/FD indexed forms
    ld a,b
    jr nc,.testIndirectJumpForSeparator      ; for DD/FD forms, test only the indirect JP opcode
    cp 018h
    jr z,.selectDisassemblySeparator         ; request a separator after unconditional JR
    cp 0c9h
    jr z,.selectDisassemblySeparator         ; request a separator after RET
    cp 0c3h
    jr z,.selectDisassemblySeparator         ; request a separator after absolute JP
.testIndirectJumpForSeparator:
    cp 0e9h                                 ; test unprefixed or indexed metadata for JP (HL), JP (IX), or JP (IY)
.selectNoDisassemblySeparator:
    ld a,000h
    jr nz,.lookupDecodedInstructionMetadata  ; skip separator selection when the tested opcode is not an unconditional transfer
.selectDisassemblySeparator:
    ld a,001h                               ; select one so the next disassembly call emits a blank row without consuming memory
.lookupDecodedInstructionMetadata:
   ld (disassembleNextLineToBuffer+1),a     ; patch the decoder entry's immediate separator flag for the following call
    push bc                                 ; preserve canonical opcode and prefix metadata across instruction-table lookup
    call decodeInstructionTableRecord
    ; restore the table lookup's success flags from alternate AF
    ex af,af'
    pop bc
    ld a,(hl)
    and 01fh
    ld (varcDecodedInstructionTStates+1),a  ; patch the tracing engine's base T-state accessor
    xor a                                   ; select zero as the high byte of the decoded T-state count
    ld (varcDecodedInstructionTStates+2),a  ; clear the tracing accessor's high byte
    dec hl
    dec hl
    dec hl
    ld a,(hl)
    and 007h
    or c                                    ; merge operand class with DD/FD/ED/CB prefix bits
    ld c,a
    pop de
    and 007h                                ; retain the operand class as the instruction-length adjustment index
    ld hl,operandClassLengthAdjustments
    call addAtoHL
    ld a,(hl)
    pop hl
addAtoHL:
    add a,l                                 ; add the low-byte offset A to pointer low byte L
    ld l,a                                  ; commit the wrapped or unwrapped low-byte result
    ret nc                                  ; return when the addition did not cross a 256-byte page
    inc h
    ret


; Test one inclusive range against the synthesized resident/source interval only.
;
; Entry:
;   BC = query First, DE = query Last
;
; The routine temporarily uses the WRITE table's hidden four-byte slot as a Z80
; stack.  It discards the placeholder words and pushes:
;
;   First = operand of `LD DE,ENTRY_POINT_WITH_MONITOR`
;           at emitByteAtAssemblyOutput+1 (relocated resident-image start)
;   Last  = varcCodeEndPt (current end of resident image + source + symbol table)
;
; A hard-coded count of 2 makes the common loop test exactly this one range.  It
; returns carry set for overlap or for a reversed query range.  No custom WRITE
; entries are reached from this specialized wrapper.
checkRangeAgainstResidentRegionOnly:
    ld (restoreProtectionCheckStackAndReturn+1),sp ; save the caller SP into the common self-restoring exit instruction
    ld a,002h                               ; use biased count two so exactly one synthesized interval is tested
    ld sp,writeProtectionDynamicRangeSlot
    jr .installDynamicProtectionRange
; Test inclusive BC..DE against a full monitor protection table.
;
; Entry:
;   HL -> table count byte
;   BC = query First
;   DE = query Last
;
; The table's hidden placeholder pair is replaced in place with the current
; resident/source interval.  The loop then checks count-1 inclusive ranges: that
; synthesized range followed by each custom user range.  Endpoint equality is an
; overlap.  Carry is returned for overlap or malformed First>Last; carry clear
; means the complete query range is outside every protected interval.
;
; SP is deliberately redirected into the table so POP can consume four-byte
; pairs cheaply.  The caller's real SP is embedded into the final instruction and
; restored on every exit.  This is intentional self-modifying stack use.
checkRangeAgainstProtectionTable:
   ld (restoreProtectionCheckStackAndReturn+1),sp ; save the real caller SP in the range checker's patched exit
    ld a,(hl)                               ; load the table's biased range count
    inc hl
    ld sp,hl
.installDynamicProtectionRange:
    pop hl
    pop hl
    ld hl,(varcCodeEndPt+1)                 ; current inclusive end of resident code, source, and symbols
    push hl
    ld hl,(emitByteAtAssemblyOutput+1)      ; load the relocated resident-image start from the protected emitter
    push hl
.testNextProtectedRange:
    and a                                   ; clear carry before decrementing the biased remaining-range count
    dec a                                   ; consume one bias/range unit
    jr z,restoreProtectionCheckStackAndReturn ; finish when all synthesized and user ranges have been examined
    ; save the remaining range count in alternate AF while primary AF classifies overlap
    ex af,af'
    xor a
    ld h,d
    ld l,e
    sbc hl,bc
    ccf                                     ; invert carry into the relation convention used by the accumulator
    adc a,000h
    pop hl
    sbc hl,de
    jr z,.compareProtectedRangeEnd           ; treat endpoint equality as overlap and continue with protected Last
    ccf                                     ; invert carry to the same relation convention
    adc a,000h
.compareProtectedRangeEnd:
    pop hl
    and a
    sbc hl,bc
    adc a,000h
    cp 002h
    scf                                     ; preselect carry-set as the overlap or malformed-range result
    jr nz,restoreProtectionCheckStackAndReturn ; return immediately unless this protected interval is disjoint
    ; restore the remaining-range count after a disjoint interval
    ex af,af'
    jr .testNextProtectedRange
restoreProtectionCheckStackAndReturn:
    ld sp,00000h                            ; restore the original caller stack pointer from the patched immediate word
    ret
; Test a single address in DE against a full monitor protection table.
;
; The table preparation is identical to checkRangeAgainstProtectionTable: discard
; the hidden placeholder, synthesize the current resident/source interval, then
; scan every custom range.  Carry is returned when First <= DE <= Last.
;
; The stepping engine uses this form for RUN protection and for effective memory
; addresses where only one byte needs checking.  The saved caller SP is restored
; from the self-modified LD SP instruction before returning.
checkAddressAgainstProtectionTable:
    ld (restoreAddressCheckStackAndReturn+1),sp ; save the caller SP into the single-address checker's patched exit
    ld a,(hl)                               ; load the table's biased range count
    inc hl
    ld sp,hl
    pop hl
    pop hl
    ld hl,(varcCodeEndPt+1)                 ; current resident/source Last
    push hl
    ld hl,(emitByteAtAssemblyOutput+1)      ; current resident-image First
    push hl
.testNextProtectedAddressRange:
    dec a                                   ; consume one bias/range unit
    jr z,restoreAddressCheckStackAndReturn  ; finish carry clear when no interval contains the address
    pop hl
    or a
    sbc hl,de
    pop hl
    jr z,.compareAddressWithRangeEnd
    jr nc,.testNextProtectedAddressRange     ; skip this interval when candidate First is above the address
.compareAddressWithRangeEnd:
    and a
    sbc hl,de
    ccf                                     ; invert carry so containment returns carry set
    jr nc,.testNextProtectedAddressRange
restoreAddressCheckStackAndReturn:
    ld sp,08b91h                            ; restore the caller stack pointer from the patched immediate word
    ret
; Start a monitor list operation by clearing lineBuffer and appending one blank
; separator row to the configured list window.
;
; The caller's HL value, normally the memory/disassembly address, is preserved by
; appendLineBufferToMonitorListWindow.  Subsequent rows bypass this initializer
; and call the append routine directly, so only one blank separator is inserted
; at the start of an operation.
beginMonitorListOutputWithBlankLine:
    call clearMonitorLineBuffer
; Scroll the configured list window upward by one text row and render lineBuffer
; into its new bottom row.
;
; The bitmap origin comes from frontPanelListWindowItem and is aligned to a
; 32-byte character-row boundary.  The low five bits of
; frontPanelListWindowSizeFlags supply the visible row count.  For height N,
; rows 1..N-1 are copied to rows 0..N-2 using eight 32-byte bitmap planes per
; text row.  The resulting bottom-row address becomes varcPrintingPosition and
; all 32 line-buffer characters are rendered there.
;
; A configured height of zero returns directly to startMonitor.  HL is preserved
; across the entire operation so listing loops keep their memory pointer.
appendLineBufferToMonitorListWindow:
    push hl                                 ; preserve the listing loop's memory/disassembly address across all bitmap work
    ld hl,(frontPanelListWindowItem)
    ld a,l                                  ; copy the horizontal address byte for 32-column alignment
    and 0e0h
    ld l,a                                  ; commit the aligned row origin
    ld a,(frontPanelListWindowSizeFlags)
    and 01fh                                ; isolate the low-five-bit visible row count
    jp z,startMonitor                       ; leave list output immediately when the configured height is zero
.scrollNextMonitorListWindowRow:
    dec a
    jr z,.selectMonitorListWindowBottomRow   ; finish copying when HL already denotes the bottom destination
    ld d,h
    ld e,l
    ; Preserve the remaining list-window row count in alternate AF while the bitmap-address helpers use primary AF.
    ex af,af'
    call advanceBitmapAddressOneTextRow
    call copyEightBitmapRows
    ; Recover the list-window row count after copying one complete text row upward.
    ex af,af'
    jr .scrollNextMonitorListWindowRow
.selectMonitorListWindowBottomRow:
    ld (varcPrintingPosition+1),hl          ; publish the exposed bottom row as the shared text output cursor
    pop hl                                  ; restore the caller's listing address before rendering lineBuffer
; Render exactly 32 characters from lineBuffer at varcPrintingPosition.
;
; The source begins at lineBuffer-1 because advanceInputPointerAndRead increments
; before reading.  Bytes below ASCII space are defensively converted to spaces.
; Bytes with bit 7 set are intentionally retained: the character renderer uses
; that bit to invert ink and paper.
renderLineBufferAtMonitorListCursor:
    push hl                                 ; preserve the caller's address while HL becomes a line-buffer scanner
    ld b,020h
    ld hl,lineBufferReadGuard
.renderNextMonitorListBufferCharacter:
    call advanceInputPointerAndRead
    cp 020h
    jr nc,.renderSanitizedMonitorListCharacter
    ld a,020h                               ; substitute a space for control bytes below ASCII $20
.renderSanitizedMonitorListCharacter:
    call displayNormalCharacter
    djnz .renderNextMonitorListBufferCharacter
    pop hl
    ret


; =============================================================================
; SYMBOL SHIFT+W: CONFIGURABLE FRONT-PANEL EDITOR
; =============================================================================
; First paint all 768 attribute cells with FRONT_PANEL_EDITOR_COLOR, redraw all
; 34 panel items, and then clear bitmap cells whose attributes were not touched by
; the renderer.  Rendered cells receive normal text attributes, while unused
; cells retain the editor colour and are erased.  This produces an immediate
; visual map of the currently occupied panel layout without maintaining a second
; occupancy bitmap.
;
; varcActiveFrontPanelItemOffset is a descriptor-table byte offset.  The selected
; item is redrawn in access-line colour, a key is accepted, and control returns
; through a synthetic invokeFrontPanelEditor address so every edit causes a full
; repaint.  EDIT returns directly to the monitor.
;
; Manual/editor keys implemented below:
;   4 / 3     next / previous seven-byte descriptor (with cyclic wrap)
;   5..8      left, down, up, right movement in Spectrum bitmap coordinates
;   A..Z      size 0..25 for variable items, or hidden/visible for scalar items
;   SS+D/H/B/C toggle decimal/hex/binary/character output
;   SS+T      toggle one-byte/two-byte values where descriptor +4 permits it
;   SS+S      toggle horizontal/vertical values where descriptor +4 permits it
invokeFrontPanelEditor:
    ld hl,ATTRIBUTES_ADDRESS
    ld bc,00003h
    push hl                                 ; preserve HL while constructing the front-panel occupancy map and entering descriptor editing
    push bc                                 ; preserve BC while constructing the front-panel occupancy map and entering descriptor editing
.fillNextFrontPanelEditorAttribute:
    ; color for the front panel editor (text color with inverted bit 0)
configurationPatchTarget07FrontPanelEditorFillAttribute: equ $+1 ; @config-patch 07
    ld (hl),FRONT_PANEL_EDITOR_COLOR
    inc hl
    djnz .fillNextFrontPanelEditorAttribute
    dec c
    jr nz,.fillNextFrontPanelEditorAttribute
    call redrawEntireFrontPanel
    pop bc
    pop hl
.scanNextFrontPanelEditorAttribute:
    ld a,(hl)
    ; front panel editor color
configurationPatchTarget08FrontPanelEditorCompareAttribute: equ $+1 ; @config-patch 08
    cp FRONT_PANEL_EDITOR_COLOR
    jr nz,.advanceFrontPanelEditorAttributeScan
    push hl                                 ; preserve HL while finding attribute cells not overwritten by rendered panel items
    ld a,h
    sub 00ah
.convertEditorAttributeHighByteToBitmapBand:
    ld h,a
    and 007h                                ; retain only 007h bits that control how routines map an unused attribute address back to its bitmap cell
    jr z,.clearUnusedFrontPanelCellBitmap
    ld a,h
    sub 007h                                ; map an unused attribute address back to its bitmap cell
    jr .convertEditorAttributeHighByteToBitmapBand
.clearUnusedFrontPanelCellBitmap:
    ld e,008h
.clearNextUnusedFrontPanelCellScanline:
    ld (hl),a
    inc h
    dec e
    jr nz,.clearNextUnusedFrontPanelCellScanline
    pop hl
.advanceFrontPanelEditorAttributeScan:
    inc hl
    djnz .scanNextFrontPanelEditorAttribute
    dec c
    jr nz,.scanNextFrontPanelEditorAttribute
varcActiveFrontPanelItemOffset:
    ld bc,00000h
    ld ix,frontPanelItemDescriptors
    add ix,bc                               ; select, highlight and edit the currently active seven-byte panel descriptor
    push bc
    ; access line color
configurationPatchTarget14MonitorAccessLineAttribute: equ $+1 ; @config-patch 14
    ld a,030h                         ; floppy full build highlights the access line in yellow
    ld (varcTextColor+1),a                  ; patch varc text color+1 to select, highlight and edit the currently active seven-byte panel descriptor
    call renderFrontPanelItem
    ; text color
configurationPatchTarget04MonitorNormalTextAttribute: equ $+1 ; @config-patch 04
    ld a,038h
    ld (varcTextColor+1),a                  ; patch varc text color+1 to select, highlight and edit the currently active seven-byte panel descriptor
    call readKeyCode
    pop bc
    ; edit (CS+1)
    cp 004h
    ret z
    ld hl,invokeFrontPanelEditor
    push hl
    ld b,007h
    ; key 4 - next item (descriptor offset +7)
    cp 034h
    jr z,.selectAdjacentFrontPanelItem
    ld b,0f9h
    ; key 3 - previous item (descriptor offset -7)
    cp 033h
    jr nz,.handleFrontPanelItemPropertyKey
.selectAdjacentFrontPanelItem:
    ld a,c
    add a,b                                 ; advance or retreat one descriptor with cyclic table wrapping
    cp 0f9h
    jr nz,.wrapFrontPanelItemOffsetAtTableEnds
    ld a,0e7h
.wrapFrontPanelItemOffsetAtTableEnds:
    ; the last item?
    cp 0eeh
    jr c,.storeActiveFrontPanelItemOffset
    ; the last item -> rotate
    xor a
.storeActiveFrontPanelItemOffset:
    ld (varcActiveFrontPanelItemOffset+1),a ; remember the selected descriptor offset for repaint
    ret
.handleFrontPanelItemPropertyKey:
    ld h,(ix+001h)
    ld l,(ix+000h)
    ld b,001h
    ; key 8 - right
    cp 038h
    jr z,.moveFrontPanelItemRightOneColumn
    ; key 6 - down
    cp 036h
    jr z,.moveFrontPanelItemByTextRows
    ; key 7 - up
    cp 037h
    jr nz,.testMoveFrontPanelItemLeft
.prepareMoveFrontPanelItemUp:
    ld b,017h
.moveFrontPanelItemByTextRows:
    call advanceBitmapAddressOneTextRow
    djnz .moveFrontPanelItemByTextRows
    jr .storeMovedFrontPanelItemBitmapAddress
.testMoveFrontPanelItemLeft:
    ; key 5 - left
    cp 035h
    jr nz,.testFrontPanelItemSizeKey
    ld b,01fh
.moveFrontPanelItemLeftAcrossScreen:
    call advanceBitmapAddressOneColumnWrappingScreen
    djnz .moveFrontPanelItemLeftAcrossScreen
    jr .prepareMoveFrontPanelItemUp
.moveFrontPanelItemRightOneColumn:
    call advanceBitmapAddressOneColumnWrappingScreen
.storeMovedFrontPanelItemBitmapAddress:
    ld (ix+001h),h
    ld (ix+000h),l
    ret
.testFrontPanelItemSizeKey:
    ; A-Z keys for the item size setting?
    cp "a"
    jr c,.testFrontPanelFormatToggleKey
    cp "z"+1
    jr nc,.testFrontPanelFormatToggleKey
    ; get item size
    sub "a"                                 ; translate A-Z into the descriptor's low-five-bit size field
    ld b,a
    ; 4th item byte, lowest 5 bits
    ld a,(ix+004h)
    ld c,a
    and 01fh                                ; extract the descriptor's five-bit size field
    xor b
    xor c
    bit 7,c                                 ; option bit selects how to translate A-Z into the descriptor's low-five-bit size field
    jr nz,.storeFrontPanelItemSize
    and 0e1h                                ; preserve descriptor capability bits while changing size
.storeFrontPanelItemSize:
    ld (ix+004h),a
    ret
.testFrontPanelFormatToggleKey:
    ld d,(ix+003h)
    ld e,(ix+004h)
    ld hl,frontPanelFormatToggleKeyTable
    ld b,006h
.scanFrontPanelFormatToggleKeyTable:
    cp (hl)
    inc hl
    jr z,.applyFrontPanelFormatToggle
    inc hl
    inc hl
    djnz .scanFrontPanelFormatToggleKeyTable
    ret
.applyFrontPanelFormatToggle:
    ld a,(hl)
    and e                                   ; apply only display formats supported by the descriptor
    ret z
    inc hl
    ld a,(hl)
    xor d
    ld (ix+003h),a
    ret
; Six triples used by the panel editor's format commands.
;
;   byte 0  normalized key code
;   byte 1  required capability mask in descriptor byte +4
;   byte 2  bit to XOR in descriptor byte +3
;
; Decimal, hexadecimal, binary, and character output use applicability mask $FF
; and toggle bits 7..4.  Type (T) requires +4 bit 6 and toggles +3 bit 3.  Direction
; (S) requires +4 bit 5 and toggles +3 bit 2.  These bytes are data even though
; the original linear disassembly renders them as plausible Z80 instructions.
frontPanelFormatToggleKeyTable:
    ld e,h                                  ; encode decimal-format key $5C as table data
    rst ROM_MaskableInterrupt               ; encode capability mask $FF for the decimal toggle
    add a,b                                 ; encode descriptor toggle bit $80 for decimal output
    ld e,(hl)                               ; encode hexadecimal-format key $5E as table data
    rst ROM_MaskableInterrupt               ; encode capability mask $FF for the hexadecimal toggle
    ld b,b                                  ; encode descriptor toggle bit $40 for hexadecimal output
    ld hl,(020ffh)                          ; encode binary key $2A, capability $FF and toggle bit $20 in one three-byte data word
    ccf                                     ; encode character-format key $3F as table data
    rst ROM_MaskableInterrupt               ; encode capability mask $FF for the character toggle
    djnz .resetFrontPanelValueSpacingState   ; encode toggle bit $10 plus the following type-key byte $10 as packed data
    ld b,b                                  ; encode type capability mask $40 as table data
    ; This byte is table data, not an executed EX: it is the type-toggle capability byte $08.
    ex af,af'
    ld a,h                                  ; encode type toggle bit $08 followed by direction key $7C
    jr nz,$+6                               ; encode direction capability $20 and toggle bit $04 as the final table bytes
; Redraw the normal monitor panel beginning with the disassembly window.
;
; The edit line is already produced by renderMonitorInputLine and the general list
; window is intentionally left intact.  Starting at descriptor 2 and rendering
; 32 descriptors therefore refreshes the disassembly window, EI/DI state,
; registers, flags, T counter, and all configurable memory-pointer items.
redrawFrontPanelAtCurrentAddress:
    ld hl,(varcMonitorCurrentAddress+1)
redrawFrontPanelFromDisassemblyAddress:
    ld ix,frontPanelDisassemblyWindowItem
    ld b,020h
    jr .renderFrontPanelDescriptorRange


; Render all 34 front-panel descriptors in table order.
;
; This entry is used by the panel editor after it marks the full attribute screen.
; The ordinary monitor redraw starts two descriptors later so it does not destroy
; the edit line or general-purpose scrolling list window.
redrawEntireFrontPanel:
    ld ix,frontPanelItemDescriptors
    ld b,022h
.renderFrontPanelDescriptorRange:
    ld (varcFrontPanelDisassemblyAddress+1),hl ; patch varc front panel disassembly address+1 to initialize and traverse a contiguous descriptor range
.renderNextFrontPanelDescriptor:
    push bc                                 ; preserve BC while rendering one seven-byte descriptor and advancing to the next
    call renderFrontPanelItemIfEnabled
    ld bc,00007h
    add ix,bc                               ; render one seven-byte descriptor and advancing to the next
    pop bc
    djnz .renderNextFrontPanelDescriptor
    ret
.renderParenthesizedAddressItemHeading:
    ld a,028h
    call displayNormalCharacter
    pop hl
    push hl
    call renderFrontPanelDecimalWord
    ld a,029h
.renderSingleGlyphItemHeading:
    call displayUninvertedCharacter
    jr .renderFrontPanelItemColonAndValues


; Render one descriptor only when its low five size bits are nonzero.
;
; IX points to the seven-byte descriptor.  A zero size hides scalar items and
; creates zero-height/zero-count window or memory items.  The caller advances IX
; by seven regardless, preserving the fixed descriptor ordering.
renderFrontPanelItemIfEnabled:
    ; get item size
    ld a,(ix+004h)
    and 01fh
    ; empty, do nothing
    ret z
    ; not empty
; Render an enabled ordinary or special front-panel item.
;
; Source mode 1 dereferences the word at descriptor +5,+6, allowing X, Y, and
; register-indirect memory items to follow a changing address.  Source mode 2
; uses +5,+6 directly for scalar register values.  Source modes 0 and 3 are
; diverted to flags or special-area rendering later.
;
; Heading selector values >=$D8 produce a parenthesized numeric address, values
; $80..$D7 are expanded through the operand-name table, and lower values are
; compact single-glyph headings.  A colon follows before enabled value formats.
renderFrontPanelItem:
    xor a
.resetFrontPanelValueSpacingState:
    ld (dispatchFrontPanelValueRendererWithSeparator+1),a ; reset value-rendering cursor, source and separator state
    call setPrintingPositionForItemData
    ld l,(ix+005h)
    ld h,(ix+006h)
    ld a,(ix+003h)
    and 003h
    dec a
    jr nz,.frontPanelItemDataPointerResolved
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
.frontPanelItemDataPointerResolved:
    push hl                                 ; preserve HL while classifying and render the descriptor heading
    ld a,(ix+002h)
    cp 0d8h
    ; >=
    jr nc,.renderParenthesizedAddressItemHeading
    cp 080h
    jr nc,.renderSingleGlyphItemHeading
    call renderFrontPanelOperandName
.renderFrontPanelItemColonAndValues:
    ld a,":"
    call displayNormalCharacter
    pop de
    ; get item size
    ld a,(ix+004h)
    and 01fh
    ld hl,(varcPrintingPosition+1)
; Render one value in every enabled representation.
;
; A is the remaining value count, DE points to the next one- or two-byte value,
; and HL holds the current bitmap cursor.  Four format positions are inspected in
; order.  The compact offset table selects byte/word variants for decimal,
; hexadecimal, binary, and character output.  A self-modified one-byte state in
; dispatchFrontPanelValueRendererWithSeparator inserts spaces between formats.
;
; For vertical items bit 2 advances the bitmap cursor by one text row after each
; value; horizontal items continue from the current character position.
.renderNextFrontPanelItemValue:
    ld bc,frontPanelValueRendererOffsetTablePrefix+2
    or a
    ret z
    push af
    push hl
    ld a,(de)
    ld l,a
    inc de
    ld a,(de)
    ld h,a
    ; one/two bytes?
    ld a,(ix+003h)
    bit 3,a                                 ; option bit selects how to load one byte/word value and dispatch all enabled representations
    jr z,.saveNextFrontPanelItemValuePointer
    inc de
.saveNextFrontPanelItemValuePointer:
    push de                                 ; preserve DE while preserving the next source value while formats are rendered
    ld e,a
    and 003h                                ; retain only 003h bits that control how routines preserve the next source value while formats are rendered
    jp z,.renderFrontPanelFlagsItem
    cp 003h
    jr nc,.renderFrontPanelSpecialItem
    ld d,004h
.scanEnabledFrontPanelValueFormats:
    ; one/two bytes?
    bit 3,(ix+003h)                         ; option bit selects how to walk decimal, hexadecimal, binary and character format slots
    push bc                                 ; preserve BC while walking decimal, hexadecimal, binary and character format slots
    jr z,.dispatchFrontPanelValueFormatRenderer
    inc bc                                  ; next element for walking decimal, hexadecimal, binary and character format slots
.dispatchFrontPanelValueFormatRenderer:
    push ix                                 ; preserve IX while forming and invoking the compact byte/word renderer offset
    ld ix,frontPanelValueRendererCodeBase
    ld a,(bc)
    ld b,000h
    ld c,a
    add ix,bc                               ; form and invoking the compact byte/word renderer offset
    rl e
    push de                                 ; preserve DE while forming and invoking the compact byte/word renderer offset
    push hl                                 ; preserve HL while forming and invoking the compact byte/word renderer offset
    call c,dispatchFrontPanelValueRendererWithSeparator
    pop hl
    pop de
    pop ix
    pop bc
    inc bc                                  ; next element for forming and invoking the compact byte/word renderer offset
    inc bc                                  ; next element for forming and invoking the compact byte/word renderer offset
    dec d
    jr nz,.scanEnabledFrontPanelValueFormats
    pop de
    pop hl
    ; single/multi line
    bit 2,(ix+003h)                         ; option bit selects how to form and invoking the compact byte/word renderer offset
    jr z,.finishFrontPanelItemValue
    call advanceBitmapAddressOneTextRow
    ld (varcPrintingPosition+1),hl          ; patch varc printing position+1 to form and invoking the compact byte/word renderer offset
    xor a
    ld (dispatchFrontPanelValueRendererWithSeparator+1),a ; reset separator state before invoking a value renderer
.finishFrontPanelItemValue:
    pop af
    dec a
    jr .renderNextFrontPanelItemValue
.renderFrontPanelSpecialItem:
    pop de
    pop hl
    pop af
; Handle source-mode-3 items and other renderer-specific classes.
;
; The size is converted to `size * 32` cells.  Ordinary special areas are filled
; with their descriptor glyph, which is how the editor/list regions reserve and
; colour their screen footprint.  Selector $C4 instead invokes repeated
; disassembly beginning at varcFrontPanelDisassemblyAddress.  Selector $A3 emits
; the current EI/DI mnemonic from varcInterruptEnableState.
clearOrRenderFrontPanelSpecialArea:
    call setPrintingPositionForItemData
    rlca
    rlca
    rlca
    ld l,a
    ld h,000h
    add hl,hl                               ; fill reserved panel areas or invoke special EI/disassembly renderers
    add hl,hl                               ; fill reserved panel areas or invoke special EI/disassembly renderers
.clearNextFrontPanelSpecialAreaCell:
    ld a,(ix+002h)
    cp 0c4h
    jr z,.renderFrontPanelDisassemblyWindow
    cp 0a3h
    jr z,varcInterruptEnableState
    call displayUninvertedCharacter
    dec hl
    ld a,h
    or l
    jr nz,.clearNextFrontPanelSpecialAreaCell
    ret
varcInterruptEnableState:
    ld a,000h
    add a,003h                              ; render the saved EI/DI mnemonic through the operand-name table
    ld de,mnemonicsReferences
    jp resolveAndRenderFrontPanelOperandName
; Render descriptor-size disassembly rows into the panel window.
;
; The generic one-line disassembler first builds lineBuffer; the same 32-column
; renderer used by monitor listings then writes it at the current panel cursor.
; HL is advanced by the decoder and retained for the next row.  The start address
; is patched by redrawFrontPanelAtCurrentAddress or its explicit-HL entry.
.renderFrontPanelDisassemblyWindow:
    ; item size
    ld a,(ix+004h)
    and 01fh
    ld b,a
    call clearPendingDisassemblySeparatorAndReturn
varcFrontPanelDisassemblyAddress:
    ld hl,00000h
    push ix                                 ; preserve IX while supplying the self-modified first disassembly address
.renderNextFrontPanelDisassemblyRow:
    push bc                                 ; preserve BC while decode and display one panel disassembly row
    call disassembleNextLineToBuffer
    call renderLineBufferAtMonitorListCursor
    pop bc
    djnz .renderNextFrontPanelDisassemblyRow
    pop ix
    ret


setPrintingPositionForItemData:
    ld l,(ix+000h)
    ld h,(ix+001h)
    ld (varcPrintingPosition+1),hl          ; patch varc printing position+1 to install the descriptor's bitmap origin as the text cursor
    ret


frontPanelFlagBitHeadingText:
    ld (hl),e                               ; encode the next packed flag-heading character
    ld a,d                                  ; encode another packed heading byte; this region is data, not executable flow
    dec l                                   ; encode the next compact flag-heading byte
    ld l,b                                  ; encode another character of the binary flag heading
    dec l                                   ; encode the final high-bit-terminated heading byte
    ld (hl),b
    ld l,(hl)
    ex (sp),hl
; Render F either as named conditions or as a binary bit display.
;
; When the descriptor's binary bit is clear, four triples in
; frontPanelConditionNameSelectionTable choose one name from each pair according
; to S, Z, P/V, and C.  The resulting default panel text is the familiar
; `NZ NC PO P`-style condition summary.
;
; When binary mode is enabled, the compact high-bit-terminated heading
; `SZ-H-PNC` is printed on one row and the eight flag bits on the next.  This is
; the manual's special interpretation of SYMBOL SHIFT+B for register F.
.renderFrontPanelFlagsItem:
    pop af
    pop af
    ld a,l
    ; Preserve the saved F byte in alternate AF while the symbolic-condition rendering path uses primary A.
    ex af,af'
    ld c,l
    ld b,004h
    bit 5,e                                 ; option bit selects how to render saved F as condition names or an eight-bit binary row
    call setPrintingPositionForItemData
    push hl                                 ; preserve HL while rendering saved F as condition names or an eight-bit binary row
    ld hl,frontPanelConditionNameSelectionTable
    jr z,.selectNextFrontPanelConditionName
    ld de,frontPanelFlagBitHeadingText
    call renderFrontPanelHighBitTerminatedText
    pop hl
    call advanceBitmapAddressOneTextRow
    ld (varcPrintingPosition+1),hl          ; patch varc printing position+1 to render saved F as condition names or an eight-bit binary row
    ; Recover the saved F byte for the binary flag-row renderer.
    ex af,af'
    call renderFrontPanelBinaryByteFromA
    pop hl
    ret
.separateFrontPanelConditionNames:
    call displaySpace
.selectNextFrontPanelConditionName:
    ld a,(hl)
    inc hl                                  ; next element for choosing the set or clear token for one flag mask
    and c                                   ; retain only C bits that control how routines choose the set or clear token for one flag mask
    jr nz,.selectSetFrontPanelConditionName
    inc hl                                  ; next element for choosing the set or clear token for one flag mask
    ld a,(hl)
    jr .renderSelectedFrontPanelConditionName
.selectSetFrontPanelConditionName:
    ld a,(hl)
    inc hl
.renderSelectedFrontPanelConditionName:
    inc hl
    push af                                 ; preserve AF while rendering one condition token while preserving table traversal
    rlca
    call c,displaySpace
    pop af
    and 07fh
    call renderFrontPanelOperandName
    djnz .separateFrontPanelConditionNames
    pop de
    pop hl
    ret
; Four three-byte flag-condition entries:
;
;   flag mask, text token when set, text token when clear
;
; They cover S, Z, P/V, and C.  The following bytes overlap a second data table:
; frontPanelValueRendererOffsetTablePrefix+2 is the eight-entry byte/word format
; renderer-offset table.  None of these bytes are executable despite their
; instruction-like disassembly.
; Four packed `(flag mask, set token, clear token)` triples are rendered as
; the default F-register condition summary.  Token bit 7 requests a leading
; separator space; the low seven bits index operandsReferences.  In order the
; entries select Z/NZ, C/NC, PE/PO and M/P, yielding the default `NZ NC PO P` for
; a cleared F register.
;
; .frontPanelCarryClearConditionToken names the NC token byte inside the second
; triple.  The bytes around it disassemble as `JR NZ,...`, but this entire region
; is data and that apparent control-flow edge is not executable.
frontPanelConditionNameSelectionTable:
    ld b,b                                  ; encode flag mask $40 and the first condition token bytes as packed data
    sub h                                   ; encode the remaining Z/NZ token byte
    jr nz,.frontPanelCarryClearConditionToken ; encode bytes $20,$15 for the C/NC entry; the apparent branch is not executed
    adc a,e                                 ; encode the final C/NC token byte and first P/V entry byte
.frontPanelCarryClearConditionToken:
    rra                                     ; encode packed P/V and carry-clear token data
    inc b                                   ; encode the next condition-name table byte
    ld hl,08022h                            ; encode the remaining P/V and sign-condition token bytes
frontPanelValueRendererOffsetTablePrefix:
    ld de,00012h                            ; encode decimal-byte and decimal-word renderer offsets $11,$00,$12
    ; This byte is renderer-offset table data, not an executed EX instruction; opcode $08 selects the hexadecimal-word renderer.
    ex af,af'
    djnz $+32                               ; encode binary renderer offsets $10,$1E as two data bytes
    inc (hl)                                ; encode character-byte renderer offset $34
    jr nc,.emitFrontPanelBinaryDigit         ; encode character-word renderer offsets $30,$0E as data
    ld b,e
; Common tail for the compact value-renderer jump table.
;
; The self-modified immediate is zero for the first representation of a value and
; one thereafter.  Later formats therefore receive one separating space.  IX has
; already been formed as frontPanelValueRendererCodeBase plus a table offset, so
; JP (IX) dispatches without a conventional address table.
dispatchFrontPanelValueRendererWithSeparator:
    ld a,000h
    or a                                    ; decide whether to insert inter-format spacing and jump through the compact renderer table
    call nz,displaySpace
    ld a,001h
    ld (dispatchFrontPanelValueRendererWithSeparator+1),a ; mark subsequent value formats for a leading separator
    jp (ix)

; Base of the eight compact value renderers.
;
; Offsets select decimal byte/word, hexadecimal byte/word, binary byte/word, and
; character byte/word variants.  The routines share fall-through tails and are
; intentionally packed so the offset table can contain one byte per variant.
frontPanelValueRendererCodeBase:
    call prepareFrontPanelByteValue
    call printThreeDigitDecimalByteToIX
    jr .renderFrontPanelNumberStringBuffer

    call prepareFrontPanelNumberBuffer
    call printDecNumberToIX
    jr .renderFrontPanelNumberStringBuffer

    call prepareFrontPanelByteValue
    ld (ix+000h),023h
    inc ix                                  ; next element for providing packed decimal, hexadecimal, binary and character renderers
    call printTwoDigitHexByteToIX
    jr .renderFrontPanelNumberStringBuffer

    call prepareFrontPanelNumberBuffer
    call printHexNumberToIX
.renderFrontPanelNumberStringBuffer:
    ld hl,numberStringBuffer
.renderNextFrontPanelNumberCharacter:
    ld a,(hl)
    or a                                    ; decide whether to emit one formatted number character
    ret z
    call displayNormalCharacter
    inc hl
    jr .renderNextFrontPanelNumberCharacter
    ld a,h
    call renderFrontPanelBinaryByteFromA
    ld a,l
renderFrontPanelBinaryByteFromA:
    ld c,a
    ld b,008h
.renderNextFrontPanelBinaryDigit:
    xor a
.emitFrontPanelBinaryDigit:
    rl c
    adc a,030h                              ; emit one binary digit and continue the fixed-width loop
    call displayNormalCharacter
    djnz .renderNextFrontPanelBinaryDigit
    ret
    ld a,h
    call renderFrontPanelCharacterFromA
    xor a
    ld h,l
    ld (dispatchFrontPanelValueRendererWithSeparator+1),a
    ld a,h
renderFrontPanelCharacterFromA:
    ld h,a
    and 07fh
    cp 020h
    ld a,h
    jr nc,.renderFrontPanelCharacterByte
    and 080h
    or 02eh
.renderFrontPanelCharacterByte:
    jp displayNormalCharacter


renderFrontPanelDecimalWord:
    push ix                                 ; preserve IX while formatting and render a 16-bit decimal item heading
    call printNumberToStringBuffer
    pop ix
    jr .renderFrontPanelNumberStringBuffer


prepareFrontPanelByteValue:
    ld h,000h
prepareFrontPanelNumberBuffer:
    ld ix,numberStringBuffer
    ld c,000h
    ret


renderFrontPanelOperandName:
    ld de,operandsReferences
resolveAndRenderFrontPanelOperandName:
    call getStringFromTableDE
; Render a compact string whose final character has bit 7 set.
;
; Alphabetic characters are forced to upper case for panel headings.  The high
; bit is removed before display and tested from the original byte after output.
; This is shared by operand names and the symbolic flags heading.
renderFrontPanelHighBitTerminatedText:
    ld a,(de)
    res 7,a                                 ; clear option bit 7 before emitting high-bit-terminated text
    call isLetter
    jr nz,.renderNextFrontPanelTextCharacter
    sub 020h
.renderNextFrontPanelTextCharacter:
    call displayUninvertedCharacter
    ld a,(de)
    inc de
    rla
    jr nc,renderFrontPanelHighBitTerminatedText
    ret


; Advance a Spectrum bitmap cursor by one character column.
;
; Incrementing L normally moves right.  At column wrap, the high byte advances by
; eight to the next character row band, with $58 wrapping back to $40.  The panel
; editor combines 31 such advances plus 23 text-row advances to implement a
; one-column move left while preserving screen wrap semantics.
advanceBitmapAddressOneColumnWrappingScreen:
    inc l                                   ; next element for advancing one text column with whole-screen wrap
    ret nz
.advanceBitmapAddressToNextScreenRowBand:
    ld a,h
    add a,008h                              ; cross into the next Spectrum character-row band
    cp 058h
    ld h,a
    ret nz
    ld h,040h
    ret


; Advance a Spectrum bitmap address by one eight-pixel text row.
;
; Adding $20 advances one 32-byte scanline group.  When L wraps, H is adjusted by
; eight to cross the Spectrum's interleaved character-row layout; reaching $58
; wraps the bitmap high byte back to $40.  The helper is shared by list scrolling
; and front-panel rendering.
advanceBitmapAddressOneTextRow:
    ld a,l
    add a,020h                              ; advance one eight-pixel text row in interleaved bitmap memory
    ld l,a
    ret nc
    jr .advanceBitmapAddressToNextScreenRowBand

; BLOCK 'data_78cf' (start 0x78cf end 0x7ab3)
; =============================================================================
; SAVED USER PROCESSOR IMAGE
; =============================================================================
; This contiguous block is deliberately stack-shaped so restore and capture can
; use POP/PUSH sequences with minimal code:
;
;   byte  R
;   byte  I
;   words BC', DE', HL', AF'
;   word  IY
;   word  IX
;   word  BC
;   word  DE
;   word  HL
;   word  AF
;   word  SP
;   word  accumulated T states
;   word  monitor address X
;   word  monitor address Y
;
; Z80 words preserve the stack byte order: low register/flags byte first, high
; register/accumulator byte second.  Front-panel items reference individual high
; bytes such as savedRegisterA, savedRegisterB, and savedRegisterD directly.
savedRegisterR:
    defb 000h                               ; saved user R byte; low seven bits are corrected around monitor fetches
savedRegisterI:
    defb 000h                               ; saved user interrupt-vector register I
savedAlternateRegisterSet:
    defs 8
savedRegisterIY:
    defb 03ah                               ; saved IY low byte
savedRegisterIYHigh:
    defb 05ch                               ; saved IY high byte
savedRegisterIX:
    defb 000h                               ; saved IX low byte
savedRegisterIXHigh:
    defb 000h                               ; saved IX high byte
savedRegisterBC:
    defb 0ffh                               ; saved BC low byte C
savedRegisterB:
    defb 0afh                               ; saved BC high byte B
savedRegisterDE:
    defb 001h                               ; saved DE low byte E
savedRegisterD:
    defb 001h                               ; saved DE high byte D
savedRegisterHL:
    defb 000h                               ; saved HL low byte L
savedRegisterH:
    defb 000h                               ; saved HL high byte H
savedRegisterAF:
    defb 000h                               ; saved AF low byte F
savedRegisterA:
    defb 000h                               ; saved AF high byte A
savedRegisterSP:
    defw 0                                  ; saved user stack pointer used for native and simulated execution
accumulatedTStates:
    defw 0                                  ; cumulative traced T-state count committed after successful steps
monitorAddressX:
    defw 0                                  ; saved monitor X address value in the processor-image tail
monitorAddressY:
    defw 0                                  ; saved monitor Y address value in the processor-image tail
; Compact READ-access descriptor table used only by traced execution.
;
; This is not a protection-window table.  It classifies Z80 instructions that
; read memory and describes how to derive their effective address.  The separate
; writeAccessDescriptorTable performs the analogous classification for writes.
readAccessDescriptorTable:
    defb 01bh                               ; declare the number of compact READ opcode descriptors that follow
    defb 0ffh                               ; descriptor 1: mask decoded opcode bits for a READ access pattern
    defb 0e3h                               ; descriptor 1: expected masked opcode for that READ pattern
    defb 00dh                               ; descriptor 1: decoder class $00, two-byte access via saved SP
    defb 0ffh                               ; descriptor 2: mask decoded opcode bits for a READ access pattern
    defb 0e3h                               ; descriptor 2: expected masked opcode for that READ pattern
    defb 01dh                               ; descriptor 2: decoder class $10, two-byte access via saved SP
    defb 0ffh                               ; descriptor 3: mask decoded opcode bits for a READ access pattern
    defb 0e3h                               ; descriptor 3: expected masked opcode for that READ pattern
    defb 02dh                               ; descriptor 3: decoder class $20, two-byte access via saved SP
    defb 0ffh                               ; descriptor 4: mask decoded opcode bits for a READ access pattern
    defb 0c9h                               ; descriptor 4: expected masked opcode for that READ pattern
    defb 00dh                               ; descriptor 4: decoder class $00, two-byte access via saved SP
    defb 0cfh                               ; descriptor 5: mask decoded opcode bits for a READ access pattern
    defb 0c1h                               ; descriptor 5: expected masked opcode for that READ pattern
    defb 00dh                               ; descriptor 5: decoder class $00, two-byte access via saved SP
    defb 0c7h                               ; descriptor 6: mask decoded opcode bits for a READ access pattern
    defb 0c0h                               ; descriptor 6: expected masked opcode for that READ pattern
    defb 00dh                               ; descriptor 6: decoder class $00, two-byte access via saved SP
    defb 0f7h                               ; descriptor 7: mask decoded opcode bits for a READ access pattern
    defb 0a0h                               ; descriptor 7: expected masked opcode for that READ pattern
    defb 042h                               ; descriptor 7: decoder class $40, one-byte access via saved HL
    defb 0c7h                               ; descriptor 8: mask decoded opcode bits for a READ access pattern

monitorTables:
    ; Base for self-relative references into the monitor text table.
    defb 086h                               ; descriptor 8: expected masked opcode for that READ pattern
    defb 014h                               ; descriptor 8: decoder class $10, one-byte access via saved IY plus displacement
    defb 0c7h                               ; descriptor 9: mask decoded opcode bits for a READ access pattern
    defb 086h                               ; descriptor 9: expected masked opcode for that READ pattern
    defb 023h                               ; descriptor 9: decoder class $20, one-byte access via saved IX plus displacement
    defb 0c7h                               ; descriptor 10: mask decoded opcode bits for a READ access pattern
    defb 086h                               ; descriptor 10: expected masked opcode for that READ pattern
    defb 002h                               ; descriptor 10: decoder class $00, one-byte access via saved HL
    defb 0cfh                               ; descriptor 11: mask decoded opcode bits for a READ access pattern
    defb 04bh                               ; descriptor 11: expected masked opcode for that READ pattern
    defb 04fh                               ; descriptor 11: decoder class $40, two-byte access via decoded immediate address
    defb 0c7h                               ; descriptor 12: mask decoded opcode bits for a READ access pattern
    defb 046h                               ; descriptor 12: expected masked opcode for that READ pattern
    defb 014h                               ; descriptor 12: decoder class $10, one-byte access via saved IY plus displacement
    defb 0c7h                               ; descriptor 13: mask decoded opcode bits for a READ access pattern
    defb 046h                               ; descriptor 13: expected masked opcode for that READ pattern
    defb 023h                               ; descriptor 13: decoder class $20, one-byte access via saved IX plus displacement
    defb 0c7h                               ; descriptor 14: mask decoded opcode bits for a READ access pattern
    defb 046h                               ; descriptor 14: expected masked opcode for that READ pattern
    defb 002h                               ; descriptor 14: decoder class $00, one-byte access via saved HL
    defb 0f7h                               ; descriptor 15: mask decoded opcode bits for a READ access pattern
    defb 045h                               ; descriptor 15: expected masked opcode for that READ pattern
    defb 045h                               ; descriptor 15: decoder class $40, one-byte access via saved SP
    defb 0ffh                               ; descriptor 16: mask decoded opcode bits for a READ access pattern
    defb 03ah                               ; descriptor 16: expected masked opcode for that READ pattern
    defb 007h                               ; descriptor 16: decoder class $00, one-byte access via decoded immediate address
    defb 0feh                               ; descriptor 17: mask decoded opcode bits for a READ access pattern
    defb 034h                               ; descriptor 17: expected masked opcode for that READ pattern
    defb 014h                               ; descriptor 17: decoder class $10, one-byte access via saved IY plus displacement
    defb 0feh                               ; descriptor 18: mask decoded opcode bits for a READ access pattern
    defb 034h                               ; descriptor 18: expected masked opcode for that READ pattern
    defb 023h                               ; descriptor 18: decoder class $20, one-byte access via saved IX plus displacement
    defb 0feh                               ; descriptor 19: mask decoded opcode bits for a READ access pattern
    defb 034h                               ; descriptor 19: expected masked opcode for that READ pattern
    defb 002h                               ; descriptor 19: decoder class $00, one-byte access via saved HL
    defb 0ffh                               ; descriptor 20: mask decoded opcode bits for a READ access pattern
    defb 02ah                               ; descriptor 20: expected masked opcode for that READ pattern
    defb 00fh                               ; descriptor 20: decoder class $00, two-byte access via decoded immediate address
    defb 0ffh                               ; descriptor 21: mask decoded opcode bits for a READ access pattern
    defb 02ah                               ; descriptor 21: expected masked opcode for that READ pattern
    defb 01fh                               ; descriptor 21: decoder class $10, two-byte access via decoded immediate address
    defb 0ffh                               ; descriptor 22: mask decoded opcode bits for a READ access pattern
    defb 02ah                               ; descriptor 22: expected masked opcode for that READ pattern
    defb 02fh                               ; descriptor 22: decoder class $20, two-byte access via decoded immediate address
    defb 0ffh                               ; descriptor 23: mask decoded opcode bits for a READ access pattern
    defb 01ah                               ; descriptor 23: expected masked opcode for that READ pattern
    defb 001h                               ; descriptor 23: decoder class $00, one-byte access via saved DE
    defb 0ffh                               ; descriptor 24: mask decoded opcode bits for a READ access pattern
    defb 00ah                               ; descriptor 24: expected masked opcode for that READ pattern
    defb 000h                               ; descriptor 24: decoder class $00, one-byte access via saved BC
    defb 087h                               ; descriptor 25: mask decoded opcode bits for a READ access pattern
    defb 006h                               ; descriptor 25: expected masked opcode for that READ pattern
    defb 094h                               ; descriptor 25: decoder class $90, one-byte access via saved IY plus displacement
    defb 087h                               ; descriptor 26: mask decoded opcode bits for a READ access pattern
    defb 006h                               ; descriptor 26: expected masked opcode for that READ pattern
    defb 0a3h                               ; descriptor 26: decoder class $A0, one-byte access via saved IX plus displacement
    defb 087h                               ; descriptor 27: mask decoded opcode bits for a READ access pattern
    defb 006h                               ; descriptor 27: expected masked opcode for that READ pattern
    defb 082h                               ; descriptor 27: decoder class $80, one-byte access via saved HL
writeAccessDescriptorTable:
    defb 01eh                               ; declare the number of compact WRITE opcode descriptors that follow
    defb 0ffh                               ; descriptor 1: mask decoded opcode bits for a WRITE access pattern
    defb 0e3h                               ; descriptor 1: expected masked opcode for that WRITE pattern
    defb 00dh                               ; descriptor 1: decoder class $00, two-byte access via saved SP
    defb 0ffh                               ; descriptor 2: mask decoded opcode bits for a WRITE access pattern
    defb 0e3h                               ; descriptor 2: expected masked opcode for that WRITE pattern
    defb 01dh                               ; descriptor 2: decoder class $10, two-byte access via saved SP
    defb 0ffh                               ; descriptor 3: mask decoded opcode bits for a WRITE access pattern
    defb 0e3h                               ; descriptor 3: expected masked opcode for that WRITE pattern
    defb 02dh                               ; descriptor 3: decoder class $20, two-byte access via saved SP
    defb 0ffh                               ; descriptor 4: mask decoded opcode bits for a WRITE access pattern
    defb 0cdh                               ; descriptor 4: expected masked opcode for that WRITE pattern
    defb 00eh                               ; descriptor 4: decoder class $00, two-byte access via saved SP minus two
    defb 0c7h                               ; descriptor 5: mask decoded opcode bits for a WRITE access pattern
    defb 0c7h                               ; descriptor 5: expected masked opcode for that WRITE pattern
    defb 00eh                               ; descriptor 5: decoder class $00, two-byte access via saved SP minus two
    defb 0cfh                               ; descriptor 6: mask decoded opcode bits for a WRITE access pattern
    defb 0c5h                               ; descriptor 6: expected masked opcode for that WRITE pattern
    defb 00eh                               ; descriptor 6: decoder class $00, two-byte access via saved SP minus two
    defb 0c7h                               ; descriptor 7: mask decoded opcode bits for a WRITE access pattern
    defb 0c4h                               ; descriptor 7: expected masked opcode for that WRITE pattern
    defb 00eh                               ; descriptor 7: decoder class $00, two-byte access via saved SP minus two
    defb 0f7h                               ; descriptor 8: mask decoded opcode bits for a WRITE access pattern
    defb 0a0h                               ; descriptor 8: expected masked opcode for that WRITE pattern
    defb 041h                               ; descriptor 8: decoder class $40, one-byte access via saved DE
    defb 087h                               ; descriptor 9: mask decoded opcode bits for a WRITE access pattern
    defb 086h                               ; descriptor 9: expected masked opcode for that WRITE pattern
    defb 094h                               ; descriptor 9: decoder class $90, one-byte access via saved IY plus displacement
    defb 087h                               ; descriptor 10: mask decoded opcode bits for a WRITE access pattern
    defb 086h                               ; descriptor 10: expected masked opcode for that WRITE pattern
    defb 0a3h                               ; descriptor 10: decoder class $A0, one-byte access via saved IX plus displacement
    defb 087h                               ; descriptor 11: mask decoded opcode bits for a WRITE access pattern
    defb 086h                               ; descriptor 11: expected masked opcode for that WRITE pattern
    defb 082h                               ; descriptor 11: decoder class $80, one-byte access via saved HL
    defb 0f8h                               ; descriptor 12: mask decoded opcode bits for a WRITE access pattern
    defb 070h                               ; descriptor 12: expected masked opcode for that WRITE pattern
    defb 014h                               ; descriptor 12: decoder class $10, one-byte access via saved IY plus displacement
    defb 0f8h                               ; descriptor 13: mask decoded opcode bits for a WRITE access pattern
    defb 070h                               ; descriptor 13: expected masked opcode for that WRITE pattern
    defb 023h                               ; descriptor 13: decoder class $20, one-byte access via saved IX plus displacement
    defb 0f8h                               ; descriptor 14: mask decoded opcode bits for a WRITE access pattern
    defb 070h                               ; descriptor 14: expected masked opcode for that WRITE pattern
    defb 002h                               ; descriptor 14: decoder class $00, one-byte access via saved HL
    defb 0cfh                               ; descriptor 15: mask decoded opcode bits for a WRITE access pattern
    defb 043h                               ; descriptor 15: expected masked opcode for that WRITE pattern
    defb 04fh                               ; descriptor 15: decoder class $40, two-byte access via decoded immediate address
    defb 0ffh                               ; descriptor 16: mask decoded opcode bits for a WRITE access pattern
    defb 036h                               ; descriptor 16: expected masked opcode for that WRITE pattern
    defb 014h                               ; descriptor 16: decoder class $10, one-byte access via saved IY plus displacement
    defb 0ffh                               ; descriptor 17: mask decoded opcode bits for a WRITE access pattern
    defb 036h                               ; descriptor 17: expected masked opcode for that WRITE pattern
    defb 023h                               ; descriptor 17: decoder class $20, one-byte access via saved IX plus displacement
    defb 0ffh                               ; descriptor 18: mask decoded opcode bits for a WRITE access pattern
    defb 036h                               ; descriptor 18: expected masked opcode for that WRITE pattern
    defb 002h                               ; descriptor 18: decoder class $00, one-byte access via saved HL
    defb 0feh                               ; descriptor 19: mask decoded opcode bits for a WRITE access pattern
    defb 034h                               ; descriptor 19: expected masked opcode for that WRITE pattern
    defb 014h                               ; descriptor 19: decoder class $10, one-byte access via saved IY plus displacement
    defb 0feh                               ; descriptor 20: mask decoded opcode bits for a WRITE access pattern
    defb 034h                               ; descriptor 20: expected masked opcode for that WRITE pattern
    defb 023h                               ; descriptor 20: decoder class $20, one-byte access via saved IX plus displacement
    defb 0feh                               ; descriptor 21: mask decoded opcode bits for a WRITE access pattern
    defb 034h                               ; descriptor 21: expected masked opcode for that WRITE pattern
    defb 002h                               ; descriptor 21: decoder class $00, one-byte access via saved HL
    defb 0ffh                               ; descriptor 22: mask decoded opcode bits for a WRITE access pattern
    defb 032h                               ; descriptor 22: expected masked opcode for that WRITE pattern
    defb 007h                               ; descriptor 22: decoder class $00, one-byte access via decoded immediate address
    defb 0ffh                               ; descriptor 23: mask decoded opcode bits for a WRITE access pattern
    defb 022h                               ; descriptor 23: expected masked opcode for that WRITE pattern
    defb 00fh                               ; descriptor 23: decoder class $00, two-byte access via decoded immediate address
    defb 0ffh                               ; descriptor 24: mask decoded opcode bits for a WRITE access pattern
    defb 022h                               ; descriptor 24: expected masked opcode for that WRITE pattern
    defb 01fh                               ; descriptor 24: decoder class $10, two-byte access via decoded immediate address
    defb 0ffh                               ; descriptor 25: mask decoded opcode bits for a WRITE access pattern
    defb 022h                               ; descriptor 25: expected masked opcode for that WRITE pattern
    defb 02fh                               ; descriptor 25: decoder class $20, two-byte access via decoded immediate address
    defb 0ffh                               ; descriptor 26: mask decoded opcode bits for a WRITE access pattern
    defb 012h                               ; descriptor 26: expected masked opcode for that WRITE pattern
    defb 001h                               ; descriptor 26: decoder class $00, one-byte access via saved DE
    defb 0c7h                               ; descriptor 27: mask decoded opcode bits for a WRITE access pattern
    defb 006h                               ; descriptor 27: expected masked opcode for that WRITE pattern
    defb 094h                               ; descriptor 27: decoder class $90, one-byte access via saved IY plus displacement
    defb 0c7h                               ; descriptor 28: mask decoded opcode bits for a WRITE access pattern
    defb 006h                               ; descriptor 28: expected masked opcode for that WRITE pattern
    defb 0a3h                               ; descriptor 28: decoder class $A0, one-byte access via saved IX plus displacement
    defb 0c7h                               ; descriptor 29: mask decoded opcode bits for a WRITE access pattern
    defb 006h                               ; descriptor 29: expected masked opcode for that WRITE pattern
    defb 082h                               ; descriptor 29: decoder class $80, one-byte access via saved HL
    defb 0ffh                               ; descriptor 30: mask decoded opcode bits for the final WRITE access pattern
relocationExceptionMonitorEntryDescriptorWord:
    defw ENTRY_POINT_WITH_MONITOR+2         ; @noreloc: opcode-shaped descriptor data, not an address pointer
; Compact control-flow classification table for the stepping engine.
;
; Fourteen masked opcode/prefix descriptors identify JP (HL/IX/IY), CALL, JP,
; RET, RST, conditional forms, JR, DJNZ, and RETN/RETI.  The descriptor index is
; converted through tracedControlFlowHandlerOffsets into a simulation routine.
; Unmatched instructions execute unchanged and return through sequential capture.
controlFlowDescriptorTable:
    defb 00eh                               ; declare the fourteen compact control-flow descriptor rows
    defb 0ffh                               ; JP (IY): opcode mask
    defb 0e9h                               ; JP (IY): expected masked opcode
    defb 016h                               ; JP (IY): decoder class $10, simulation handler index 6
    defb 0ffh                               ; JP (IX): opcode mask
    defb 0e9h                               ; JP (IX): expected masked opcode
    defb 025h                               ; JP (IX): decoder class $20, simulation handler index 5
    defb 0ffh                               ; JP (HL): opcode mask
    defb 0e9h                               ; JP (HL): expected masked opcode
    defb 004h                               ; JP (HL): decoder class $00, simulation handler index 4
    defb 0ffh                               ; unconditional CALL: opcode mask
    defb 0cdh                               ; unconditional CALL: expected masked opcode
    defb 001h                               ; unconditional CALL: decoder class $00, simulation handler index 1
    defb 0ffh                               ; unconditional RET: opcode mask
    defb 0c9h                               ; unconditional RET: expected masked opcode
    defb 002h                               ; unconditional RET: decoder class $00, simulation handler index 2
    defb 0c7h                               ; RST vector: opcode mask
    defb 0c7h                               ; RST vector: expected masked opcode
    defb 003h                               ; RST vector: decoder class $00, simulation handler index 3
    defb 0c7h                               ; conditional CALL: opcode mask
    defb 0c4h                               ; conditional CALL: expected masked opcode
    defb 001h                               ; conditional CALL: decoder class $00, simulation handler index 1
    defb 0ffh                               ; unconditional JP: opcode mask
    defb 0c3h                               ; unconditional JP: expected masked opcode
    defb 001h                               ; unconditional JP: decoder class $00, simulation handler index 1
    defb 0c7h                               ; conditional JP: opcode mask
    defb 0c2h                               ; conditional JP: expected masked opcode
    defb 001h                               ; conditional JP: decoder class $00, simulation handler index 1
    defb 0c7h                               ; conditional RET: opcode mask
    defb 0c0h                               ; conditional RET: expected masked opcode
    defb 002h                               ; conditional RET: decoder class $00, simulation handler index 2
    defb 0f7h                               ; extended return form: opcode mask
    defb 045h                               ; extended return form: expected masked opcode
    defb 047h                               ; extended return form: decoder class $40, simulation handler index 7
    defb 0e7h                               ; conditional JR family: opcode mask
    defb 020h                               ; conditional JR family: expected masked opcode
    defb 000h                               ; conditional JR family: decoder class $00, simulation handler index 0
    defb 0ffh                               ; unconditional JR: opcode mask
    defb 018h                               ; unconditional JR: expected masked opcode
    defb 000h                               ; unconditional JR: decoder class $00, simulation handler index 0
    defb 0ffh                               ; DJNZ: opcode mask
    defb 010h                               ; DJNZ: expected masked opcode
    defb 000h                               ; DJNZ: decoder class $00, simulation handler index 0

monitorTextReferences:
monitorTextLength:      defb monitorTextsTable02-monitorTextLength
monitorTextFirst:       defb monitorTextsTable03-monitorTextFirst
monitorTextLast:        defb monitorTextsTable04-monitorTextLast
monitorTextMemory:      defb monitorTextsTable05-monitorTextMemory
monitorTextLd:          defb monitorTextsTable06-monitorTextLd
monitorTextUniversum:   defb monitorTextsTable07-monitorTextUniversum
monitorTextOn:          defb monitorTextsTable08-monitorTextOn
monitorTextOff:         defb monitorTextsTable09-monitorTextOff
monitorTextNon:         defb monitorTextsTable10-monitorTextNon
monitorTextDef:         defb monitorTextsTable11-monitorTextDef
monitorTextAll:         defb monitorTextsTable12-monitorTextAll
monitorTextCall:        defb monitorTextsTable13-monitorTextCall
monitorTextReadWrite:   defb monitorTextsTable14-monitorTextReadWrite
monitorTextRun:         defb monitorTextsTable15-monitorTextRun
monitorTextInterrupt:   defb monitorTextsTable16-monitorTextInterrupt
monitorTextError:       defb monitorTextsTable17-monitorTextError
monitorTextNoRun:       defb monitorTextsTable18-monitorTextNoRun
monitorTextNoWrite:     defb monitorTextsTable19-monitorTextNoWrite
monitorTextNoRead:      defb monitorTextsTable20-monitorTextNoRead
monitorTextDefb:        defb monitorTextsTable21-monitorTextDefb
monitorTextDefw:        defb monitorTextsTable22-monitorTextDefw
monitorTextWindows:     defb monitorTextsTable23-monitorTextWindows
monitorTextWith:        defb monitorTextsTable24-monitorTextWith
monitorTextTo:          defb monitorTextsTable25-monitorTextTo
monitorTextLeader:      defb monitorTextsTable26-monitorTextLeader
monitorTextFirstByte:   defb monitorTextsTable27-monitorTextFirstByte

monitorTextsTable:
monitorTextsTable02:    defb "Lengt",0xe8
monitorTextsTable03:    defb "Firs",0xf4
monitorTextsTable04:    defb "Las",0xf4
monitorTextsTable05:    defb "Memor",0xf9
monitorTextsTable06:    defb "l",0xe4
monitorTextsTable07:    defb " UNIVERSUM Contro",0xec
monitorTextsTable08:    defb "ON",0xa0
monitorTextsTable09:    defb "OF",0xc6
monitorTextsTable10:    defb "NO",0xce
monitorTextsTable11:    defb "DE",0xc6
monitorTextsTable12:    defb "AL",0xcc
monitorTextsTable13:    defb "Cal",0xec
monitorTextsTable14:    defb "Read/Writ",0xe5
monitorTextsTable15:    defb "Ru",0xee
monitorTextsTable16:    defb "Interrup",0xf4
monitorTextsTable17:    defb "ERRO",0xd2
monitorTextsTable18:    defb "No ru",0xee
monitorTextsTable19:    defb "No writ",0xe5
monitorTextsTable20:    defb "No rea",0xe4
monitorTextsTable21:    defb "Def",0xe2
monitorTextsTable22:    defb "Def",0xf7
monitorTextsTable23:    defb "windows",0xba
monitorTextsTable24:    defb "Wit",0xe8
monitorTextsTable25:    defb "T",0xef
monitorTextsTable26:    defb "Leade",0xf2
; First character of the shared `n. byte:` prompt used by monitor G.
;
; monFindSequence writes `1` here and increments it after each of the five
; prompts.  The following label denotes the complete packed monitor text; this
; byte-level alias exists because only the ordinal digit is self-modified.
monitorFindBytePromptDigit:
monitorTextsTable27:    defb "1. byte",0xba
    defs 13

; =====================================================================
; Assembler-only entry.  The preceding monitor prefix is exactly 5,000 bytes,
; matching the installer's $1388 source skip when Monitor:No is selected.
ENTRY_POINT_WITHOUT_MONITOR:

    jp  startPrometheus

; =====================================================================
; TOKENIZED COMMAND DISPATCH TABLE
; =====================================================================
;
; When the edit line begins with an assembler command keyword, the tokenizer
; stores a one-byte command token in the range $C1-$DA.  These values map in
; alphabetical order to A-Z.  submitInputLineOrDispatchCommand doubles the
; token, adds commandHandlerTable-($C1*2), fetches a little-endian handler
; address, and jumps to it.
;
; This is not the raw keyboard table.  Immediate editor actions such as cursor
; movement, EDIT, block-boundary marking, and page movement are handled earlier
; in the main editor loop.  The table is reached only after an input line has
; been tokenized as a command.
;
; Confirmed command map from the manual and handler behaviour:
;
;   A ASSEMBLY     B BASIC       C COPY        D DELETE
;   E end of text  F FIND        G GENS        H decimal/hex toggle
;   G/I/J token slots share the GENS importer; L LOAD; M MONITOR
;   N/O enter the Spectrum ROM NEW path; P PRINT; Q QUIT; R RUN
;   S SAVE         T TABLE       U U-TOP       V VERIFY
;   W INSERT/OVERWRITE toggle; X/Y CLEAR; Z REPLACE
;
; Only GENS is documented.  The I/J table entries are retained as explicit token
; aliases, but static table identity is not treated as proof that every alias is
; reachable through normal command entry.  The duplicated N/O and X/Y entries are
; likewise preserved exactly rather than normalized away.
; =====================================================================
commandHandlerTable:
    defw invokeAssembly                     ; $C1 / A / ASSEMBLY
    defw invokeBasic                        ; $C2 / B / BASIC
    defw invokeCopy                         ; $C3 / C / COPY
    defw invokeDelete                       ; $C4 / D / DELETE
    defw invokeGoToSourceEnd                ; $C5 / E / end of source
    defw invokeFind                         ; $C6 / F / FIND
    defw invokeGens                         ; $C7 / G / GENS
    defw invokeToggleNumberBase             ; $C8 / H / decimal-hex
    defw invokeGensTokenAliasI              ; $C9 / I / import path
    defw invokeGensTokenAliasJ              ; $CA / J / import path
    defw invokeGoToSourceStart              ; $CB / K / source start
    defw invokeLoad                         ; $CC / L / LOAD
    defw invokeMonitor                      ; $CD / M / MONITOR
    defw ROM_NEWCommandRoutine              ; $CE / N / NEW path
    defw ROM_NEWCommandRoutine              ; $CF / O / NEW alias
    defw invokePrint                        ; $D0 / P / PRINT
    defw invokeQuit                         ; $D1 / Q / QUIT
    defw invokeRun                          ; $D2 / R / RUN
    defw invokeSave                         ; $D3 / S / SAVE
    defw invokeTable                        ; $D4 / T / TABLE
    defw invokeUTop                         ; $D5 / U / U-TOP
    defw invokeVerify                       ; $D6 / V / VERIFY
    defw invokeToggleInsertOverwrite        ; $D7 / W / mode toggle
    defw invokeClear                        ; $D8 / X / CLEAR
    defw invokeClear                        ; $D9 / Y / CLEAR alias
    defw invokeReplace                      ; $DA / Z / REPLACE


; ---------------------------------------------------------------------
; Immediate command E/K navigation
; ---------------------------------------------------------------------
;
; SYMBOL SHIFT+K on an empty edit line selects sourceBufferAccessLine, the
; permanent low-address sentinel/first displayable source position.  The main
; loop redraws the listing around this pointer after the handler returns.
invokeGoToSourceStart:
    ; go to the start of the source
    ld hl,sourceBufferAccessLine
; Store the active source-record pointer in the immediate operand of
; varcSourceBufferActiveLine.  PROMETHEUS uses self-modifying operands as its
; resident editor state, avoiding a separate variable block.
.setActiveSourceLine:
    ld (varcSourceBufferActiveLine+1),hl    ; persist the new active record in the editor's self-modified state
    ret


; SYMBOL SHIFT+E selects the last real source record.  getSourceEndPosition
; returns the end sentinel immediately before the symbol-table area; stepping
; once backward converts that sentinel into the start address of the last line.
invokeGoToSourceEnd:
    ; go to the end of the source
    call getSourceEndPosition               ; derive the end sentinel from the current source/symbol layout
    call getPreviousSourceRecord            ; step back from the sentinel to the last real source record
    jr .setActiveSourceLine

; Return the source end sentinel in HL.
;
; The symbol table grows immediately above the compressed source text.  The
; current symbol-table pointer therefore also anchors the source end.  The
; constant displacement accounts for the fixed twelve-byte editor/display
; tail area maintained between the visible source window and the table.
getSourceEndPosition:
    ld hl,(varcSymbolTablePt+1)             ; use the moving symbol-table base as the upper source anchor
    ; compute ending position of the active line
    ld de,sourceBufferAccessLine-symbolTableDefaultPt+2
    add hl,de
    ret

; ---------------------------------------------------------------------
; U-TOP expression command
; ---------------------------------------------------------------------
;
; Evaluate the expression following the command token and store the resulting
; 16-bit value in the immediate operand used as the user memory ceiling.  The
; evaluator works left-to-right, accepts current address '$', numeric literals,
; and already-defined symbols, matching the manual.  U-TOP -1 naturally yields
; $FFFF through 16-bit arithmetic.
invokeUTop:
    ; sets U-TOP, the last address where  a the source code can be stored
    call evaluateInputExpression
    ld (varcUTop+1),hl                      ; install the result as the user-memory ceiling
    ret


; Evaluate an expression beginning immediately after the command token.
;
; Entry: none; source is inputBufferStart+1.
; Exit:  HL = 16-bit result.  Syntax/undefined-symbol failures use signalError.
evaluateInputExpression:
    ld hl,inputBufferStart+1
; Shared expression-evaluator entry used by U-TOP and by instruction/source
; parsing.  HL points at the encoded/textual expression.  The deeper operator
; implementation is deliberately left for the expression-parser pass.
; -----------------------------------------------------------------------------
; Evaluate a textual expression copied from an editor/monitor command
; -----------------------------------------------------------------------------
; PROMETHEUS deliberately evaluates strictly from left to right; multiplication
; and division have no precedence over addition or subtraction.  The accepted
; atoms are decimal, hexadecimal (#), binary (%), one/two-character quoted
; constants, the current address counter '$', and an already-known symbol.
;
; The accumulator is kept on the Z80 stack.  A contains the binary operator
; which must combine that accumulator with the next atom.  A second
; self-modified immediate byte, varcTextAtomUnarySign, records a leading '-' on
; the atom.  The shared arithmetic primitives use 16-bit wraparound exactly as
; the manual describes.  Division by zero naturally returns $FFFF.
;
; Exit:
;   HL = 16-bit expression result
;   carry set only when the copied expression terminator has been reached
; Errors:
;   malformed syntax and undefined symbols leave through signalError.
evaluateExpressionAtHL:
    ld de,commandArgumentBuffer
    push de
    ld c,01eh                               ; limit the copied expression to the 30-byte command workspace
    call readSecondOperandToEnd             ; copy and normalize the remaining command argument
    pop de                                  ; recover the normalized expression cursor
    ld hl,00000h
    ld a,"+"
    ld ix,lineBuffer
.evaluateTextExpressionLoop:
    push hl                                 ; save the accumulated value while decoding the next atom
    push af
    call testClosingBracketOrComma          ; fetch the next significant expression character
    jp c,syntaxError                        ; reject an empty or prematurely terminated atom
    cp "+"
    jr z,.consumeOptionalUnaryPlus
    ld (varcTextAtomUnarySign+1),a          ; remember the possible unary sign in the inline operand
    cp "-"
    jr nz,.evaluateTextExpressionAtom        ; parse the current character directly when it is not minus
.consumeOptionalUnaryPlus:
    call testClosingBracketOrComma
.evaluateTextExpressionAtom:
    cp "$"
    ld hl,(varcAddressCounter+1)            ; prepare the current assembly address as a candidate value
    jr z,.finishTextExpressionAtom
    call isLetter
    jr nz,.evaluateTextLiteralAtom
    ; isLetter
    dec de
    push de                                 ; preserve the command-text position across symbol lookup
    push ix
    ex de,hl
    call parseSymbolNameAndFindOrdinal
    ld a,MESSAGE_UNKNOWN
    jp c,signalError                        ; abort when the symbol has no ordinal
    pop ix
    ex de,hl
    call resolveSymbolReferenceToName       ; resolve the ordinal to its value/name record
    ld a,(hl)
    and 0c0h
    ld a,MESSAGE_UNKNOWN
    jp z,signalError
    dec de
    ex de,hl
    ld d,(hl)
    dec hl
    ld e,(hl)
    pop bc
    ld hl,(numberStringBuffer)              ; load the normalized symbol-name length
    ld h,000h                               ; zero-extend that length
    add hl,bc
    ex de,hl
.finishTextExpressionAtom:
    call testClosingBracketOrComma
    jr .combineTextExpressionValue
.evaluateTextLiteralAtom:
    call encodeQuotedOrNumericAtom
.combineTextExpressionValue:
    push af
    push de
    ex de,hl
varcTextAtomUnarySign:
    ld a,032h                               ; load the self-modified unary-sign character
    call negateDEIfOperatorIsMinus          ; negate the atom only when the saved sign was '-'
    pop hl
    pop bc
    pop af
    ex (sp),hl
    push bc
    call applyExpressionOperatorToHLAndDE
    pop af
    pop de
    ret c                                   ; return when the atom parser marked end of expression
    jr .evaluateTextExpressionLoop
; Delete BC compressed source records beginning at HL, then restore the editor's
; fixed low-address/tail padding invariant.  deleteSourceLinesAtHL compacts the
; source and symbol-table region; the loop below inserts two-byte empty records
; as needed so sourceBufferAccessLine remains a valid display anchor even after
; deleting the whole program.
deleteSourceLinesAndRestoreTailPadding:
    push hl
    call deleteSourceLinesAtHL
; Test whether the source end has retreated too close to the permanent access
; line.  If so, insert one two-byte empty record and repeat.
.ensureSourceTailPaddingLoop:
    ld hl,sourceBufferAccessLine
    call comparePositionWithCodeEnd
    jr c,.sourceTailPaddingRestored          ; finish once the source end lies above the access line
    ld d,h
    ld e,l
    ld c,002h                               ; insert one two-byte empty compressed record
    call insertByteRangeAtHLFromDE
    jr .ensureSourceTailPaddingLoop
.sourceTailPaddingRestored:
    pop hl
    ret


; =====================================================================
; REPLACE COMMAND
; =====================================================================
;
; Manual forms:
;   REPLACE :new-text   store a new replacement string, replace on this line
;   REPLACE             reuse the previous replacement string
;
; The last FIND pattern remains in searchTextLength/searchTextCharacters.
; A colon causes the new replacement argument to be normalized to lowercase
; and stored in the separate replacement buffer.  The active compressed line
; is expanded to lineBuffer, transformed into inputBufferStart, submitted back
; through the normal line parser in OVERWRITE mode, and then FIND resumes at
; the following occurrence.
;
; Separator byte $01 in the expanded line is formatting metadata and is not
; counted as part of the visible search text.  The replacement builder has a
; strict 31-character capacity, the same limit documented for the edit line.
; =====================================================================
invokeReplace:
    ld b,03ah
    call containsInputBufferCharacterInB    ; leave Z set only when a new argument is present
    ld de,replacementTextStorageBaseMinusOne+2
    call z,storeLowercaseCommandArgument
    ld ix,(varcSourceBufferActiveLine+1)    ; select the active compressed record for expansion
    ld (varcFindScanPosition+1),ix          ; make subsequent FIND continue from this record
    call expandSourceRecordToLineBuffer
    ld hl,lineBuffer
    ld de,inputBufferStart
    ld a,001h                               ; seed the buffer with its movable cursor marker
    ld (de),a
    inc de
    ld c,01fh                               ; enforce the editor's 31-character visible-line limit
; At each visible source position, test whether the saved FIND pattern matches.
; Registers on entry:
;   HL = current position in expanded lineBuffer
;   DE = next output position in inputBufferStart
;   C  = remaining output capacity
.replaceScanLoop:
    push hl
    push de
    ex de,hl
    call matchSearchTextAtDE
    pop de
    jr nc,.replaceCopyUnmatchedCharacter     ; copy one original character when the pattern does not match
    ld hl,replacementTextStorageBaseMinusOne+1
    ld b,(hl)
; A match was found.  Copy the saved replacement characters to the output
; buffer.  appendReplacementCharacterOrAbort enforces the 31-byte limit.
.replaceCopyReplacementLoop:
    inc hl
    ld a,(hl)
    call appendReplacementCharacterOrAbort
    djnz .replaceCopyReplacementLoop
    pop hl
    ld a,(searchTextLength)
    ld b,a
; Advance the expanded source pointer by the number of visible characters in
; the FIND pattern.  atHLorNextIfOne skips internal $01 field separators, so a
; match spanning formatted fields is advanced consistently with the matcher.
.replaceSkipMatchedTextLoop:
    call atHLorNextIfOne                    ; skip formatting separators while consuming matched text
    inc hl
    djnz .replaceSkipMatchedTextLoop
    jr .replaceScanLoop
; No match at this position.  Copy one visible source character.  A zero byte
; is the expanded-line terminator and transfers control to finalization.
.replaceCopyUnmatchedCharacter:
    pop hl
    call atHLorNextIfOne
    inc hl
    or a
    jr z,.replaceFinalizeInputLine           ; finalize when the expanded source is exhausted
    call appendReplacementCharacterOrAbort
    jr .replaceScanLoop
; Terminate the reconstructed edit line, force OVERWRITE for this one submit,
; clear the unused input-buffer tail, and arrange for replacement processing to
; continue through replaceCommitContinuation after the normal parser commits
; the modified compressed record.
.replaceFinalizeInputLine:
    inc a                                   ; convert the zero terminator to the editor cursor marker value
    ld (de),a
    ld (varcInsertMode+1),a                 ; force this submission to replace the active record
    dec a
    inc c
.replaceClearRemainingInputBuffer:
    ld (de),a
    dec c
    jr nz,.replaceClearRemainingInputBuffer  ; clear the complete unused tail
    ld hl,replaceCommitContinuation
    ld (varcPostCommandContinuationJump+1),hl ; patch command completion to resume the FIND/REPLACE workflow
    jp submitInputLineOrDispatchCommand
; Post-submit continuation for REPLACE.  Restore the normal warm-start return
; hook, search for the next occurrence, then finish through the common command
; completion path.  This implements the manual's interactive FIND/REPLACE
; workflow without a separate replacement editor.
replaceCommitContinuation:
    ld hl,prometheusWarmStart
    ld (varcPostCommandContinuationJump+1),hl ; remove the temporary replacement continuation patch
    call findNextOccurrence                 ; locate the next occurrence after the committed line
    jp restoreInsertModeAndContinue


; =====================================================================
; FIND COMMAND
; =====================================================================
;
; Manual forms and their code paths:
;   FIND s[:text]  scan from source start
;   FIND b[:text]  scan from selected-block start and restrict to the block
;   FIND [:text]   continue from the active line using the previous scope
;   FIND           continue with the saved text and scope
;
; Search is case-insensitive.  New text after ':' is converted to lowercase and
; stored as a length-prefixed pattern.  The scan pointer and scope flag live in
; immediate operands so repeated bare FIND commands continue where the prior
; search stopped.  Failure leaves the active line unchanged, as documented.
; =====================================================================
invokeFind:
    ld hl,(varcSourceBufferActiveLine+1)    ; start a continuation search from the active source record
    ld (varcFindScanPosition+1),hl          ; remember that record as the last examined position
    ld b,053h
    call containsInputBufferCharacterInB
    jr nz,.checkFindBlockScopePrefix         ; try the block prefix when 's' was not present
    xor a
.initializeFindScopeAndRestartAtSourceBeginning:
    ld de,sourceBufferPreviousLine          ; restart immediately before the first real source record
    ld (varcFindScanPosition+1),de          ; reset the persistent scan cursor to the source beginning
    ld (varcFindRestrictToBlock+1),a        ; store the selected whole-source or block scope
    call readInputCharacterSkippingCursorAndAdvance
    jr .checkFindTextDelimiter
.checkFindBlockScopePrefix:
    ; character "B"
    ld b,042h
    call compareWithCharacterInB
    jr nz,.checkFindTextDelimiter            ; retain the previous scope when no prefix was supplied
    ld a,001h
    jr .initializeFindScopeAndRestartAtSourceBeginning
.checkFindTextDelimiter:
    ; character ":"
    ld b,03ah
    call compareWithCharacterInB
    ld de,searchTextCharacters
    call z,storeLowercaseCommandArgument    ; store a new lowercase pattern only when ':' was present
; Scan compressed records until the current line callback reports carry set.
;
; The routine first displays "Wait please".  Each compressed line is expanded
; to lineBuffer before matching or printing.  varcLineScanCallback makes this
; loop reusable: FIND installs findTextInLineBuffer; PRINT installs
; printLineBufferToChannel3.
findNextOccurrence:
    call printStatusBarWithWaitPlease       ; show progress before scanning potentially long source text
    ld hl,findTextInLineBuffer
; Store the per-line callback into the self-modifying CALL and enter the shared
; record scan.  HL is the callback address.
.configureLineScanAndStart:
    ld (varcLineScanCallback+1),hl          ; patch the generic line scanner with the requested callback
; Self-modifying scan cursor.  The immediate operand is the last record examined;
; getNextSourceRecord advances before processing, so sourceBufferPreviousLine starts
; a scan at the first source record.
varcFindScanPosition:
    ld hl,sourceBufferAccessLine
    call getNextSourceRecord
    ld (varcFindScanPosition+1),hl          ; persist the newly examined record
    call comparePositionWithCodeEnd
    ret nc                                  ; return without moving the active line when no match remains
    push hl
    pop ix
; Self-modifying scope flag: zero scans all source records; nonzero filters each
; candidate through the selected-block test before expanding it.
varcFindRestrictToBlock:
    ld a,000h
    or a
    jr z,.findDecodeAndMatchCurrentLine
    call testSourceRecordOutsideSelectedBlock
    jr c,.findAdvanceLoop                    ; skip expansion when the record is out of scope
.findDecodeAndMatchCurrentLine:
    call expandSourceRecordToLineBuffer
; Self-modifying CALL target used by the generic source-line scan.  Callback
; convention: carry set means stop successfully at the current record; carry
; clear means continue.
varcLineScanCallback:
    call findTextInLineBuffer
    ld hl,(varcFindScanPosition+1)          ; recover the record corresponding to the callback result
    jr c,.setActiveSourceLineAndReturn       ; select this record when the callback reports success
.findAdvanceLoop:
    jr varcFindScanPosition
; Copy a zero-terminated command argument from HL into the buffer at DE.
; Characters are normalized with OR $20, and the byte immediately preceding DE
; receives the resulting length.  This compact contract is used for both FIND
; and REPLACE saved strings.
storeLowercaseCommandArgument:
    ld b,000h                               ; start a new saved argument with length zero
    push de
.storeLowercaseArgumentLoop:
    call atHLorNextIfOne
    inc hl
    or a
    jr z,.finishLowercaseArgumentStorage     ; finish once the complete argument has been copied
    or 020h                                 ; normalize alphabetic text to lowercase
    ld (de),a
    inc de
    inc b
    jr .storeLowercaseArgumentLoop
.finishLowercaseArgumentStorage:
    pop hl
    dec hl
    ld (hl),b
    ret


; =====================================================================
; PRINT COMMAND
; =====================================================================
;
; PRINT scans from the beginning of the source.  Parameter 'b' sets the same
; selected-block filter used by FIND; without it the whole source is printed.
; Each expanded line is emitted character-by-character through Spectrum channel
; #3 and terminated by carriage return 13.  The SPACE test in the callback
; aborts through the common error/command return path, matching the manual.
; =====================================================================
invokePrint:
    call containsInputBufferCharacterB      ; detect whether PRINT was restricted to the selected block
    ld a,000h                               ; default to unrestricted source output
    jr nz,.printInitializeScan               ; keep that default when no 'b' parameter was found
    inc a
.printInitializeScan:
    ld (varcFindRestrictToBlock+1),a        ; store the shared scan-scope flag
    ld hl,sourceBufferPreviousLine          ; restart immediately before the first source record
    ld (varcFindScanPosition+1),hl          ; initialize the generic scan cursor
    ld hl,printLineBufferToChannel3
    jr .configureLineScanAndStart

; Per-line callback for the generic source scan.  First test SPACE/BREAK, then
; fall through to outputLineBufferToChannel3.  It returns carry clear so the
; scan continues until source end.
printLineBufferToChannel3:
    call abortCurrentOperationIfSpacePressed
; Open ROM channel #3, route the expanded line through the generic line-buffer
; renderer, emit ENTER, and return A=0/carry clear.
outputLineBufferToChannel3:
    ld a,003h
    call ROM_ChannelOpen
    ei                                      ; permit ROM output with maskable interrupts enabled
    ld hl,00010h
    call printExpandedSourceLineWithRoutine
    ld a,00dh
    rst ROM_PrintACharacter                 ; finish the printed source line with ENTER
    xor a
    ret


; =====================================================================
; DELETE SELECTED BLOCK
; =====================================================================
;
; getSelectedBlock normalizes the two remembered boundary pointers.  The first
; loop counts inclusive source records from the lower boundary through the upper
; boundary.  The common deletion routine compacts the byte range, updates every
; moving source/symbol pointer, and restores required empty tail records.  The
; surviving line nearest the removed block becomes both block boundaries and
; the active line.
; =====================================================================
invokeDelete:
    call getSelectedBlock                   ; normalize the remembered block boundaries
    ld bc,00001h                            ; count the first record of the inclusive block
.countSelectedBlockLinesLoop:
    push hl
    and a
    sbc hl,de
    pop hl
    jr nc,.deleteSelectedBlockNow            ; stop counting once the upper boundary is reached
    inc bc
    call getNextSourceRecord
    jr .countSelectedBlockLinesLoop
.deleteSelectedBlockNow:
    call getSelectedBlock
    call deleteSourceLinesAndRestoreTailPadding
    call comparePositionWithCodeEnd
    call z,getPreviousSourceRecord
    ld (varcSelectedBlockStart+1),hl        ; collapse the first block boundary onto the survivor
    ld (varcSelectedBlockEnd+1),hl          ; collapse the second boundary onto the same survivor
.setActiveSourceLineAndReturn:
    ld (varcSourceBufferActiveLine+1),hl    ; make the surviving record active
    ret
; Search one expanded line for the saved FIND pattern.
;
; DE walks every possible visible-character start.  Carry is returned on a
; complete case-insensitive match.  Zero from matchSearchTextAtDE means the line
; terminator was reached; nonzero mismatch advances to the next position.
findTextInLineBuffer:
    ld de,lineBuffer
.findTryNextLineBufferPosition:
    push de
    call matchSearchTextAtDE
    pop de
    ret c                                   ; return immediately after a complete match
    inc de
    jr nz,.findTryNextLineBufferPosition
    ret


; Compare the length-prefixed saved pattern with expanded text at DE.
;
; Internal byte $01 is skipped because it separates formatted source fields.
; Byte $00 ends the expanded line.  XOR followed by AND $DF performs ASCII
; case-insensitive comparison.  Returns carry set only after all B pattern
; characters match; otherwise returns carry clear with Z distinguishing end of
; line from an ordinary mismatch.
matchSearchTextAtDE:
    ld hl,searchTextLength
    ld b,(hl)
.matchNextSearchCharacter:
    inc hl
.matchReadNextSourceCharacter:
    ld a,(de)
    inc de
    dec a                                   ; map the internal field separator $01 to zero for testing
    jr z,.matchReadNextSourceCharacter       ; skip separators without consuming a pattern character
    inc a
    ret z                                   ; stop with carry clear at the expanded-line terminator
    xor (hl)
    and 0dfh
    ret nz                                  ; return carry clear on the first real mismatch
    djnz .matchNextSearchCharacter
    scf                                     ; mark a complete pattern match with carry
    ret
; Persistent FIND pattern: one-byte visible-character count followed by the
; lowercase characters.  The bytes after the active length are irrelevant and
; retain whatever original image data occupied this compact workspace.
searchTextLength:
    nop
searchTextCharacters:
    add a,d
    ld l,c
    jp nz,00009h
    ex de,hl
    ; Saved FIND character slot 7 is inert workspace data; its byte value happens to decode as EX AF,AF'.
    ex af,af'
    add a,d
    ld l,c
    jp nz,00318h
    nop
    ld a,b
    ld l,a
    ld (hl),e
    ld h,l
    ld h,(hl)
    ld (hl),e
    jr nc,$-59
    push de
    ; Saved FIND character slot 23 is inert workspace data; its byte value happens to decode as EX AF,AF'.
    ex af,af'
    add a,d
    ld l,d
; Persistent REPLACE workspace deliberately embedded in otherwise inactive bytes.
; The label points one byte before the logical fields because the original code
; addresses the saved replacement length as +1 and its character bytes as +2.
; Keeping those offsets explicit preserves the original assembler statements.
replacementTextStorageBaseMinusOne:
    jp nz,00000h                            ; encode the inert prefix byte, zero replacement length, and character slot 1
    nop
    ld (bc),a
    add a,b
    ret c
    jp nz,000c5h
    push bc
    nop
    ex de,hl
    nop
    ld hl,(0cd02h)
    ld hl,0c373h
    xor (hl)
    ld l,c
    ld (060a8h),a
    ld a,010h

; -----------------------------------------------------------------------------
; Render one twenty-row column of the alphabetically sorted symbol table
; -----------------------------------------------------------------------------
; The table has two orderings at once:
;   * source records refer to symbols by stable ordinal through the vector area;
;   * value/name records are physically stored in alphabetical order.
;
; HL walks the value/name records.  For each record, the routine searches the
; vector area for the vector whose offset selects that physical record; this is
; necessary to recover the vector's DEFINED/LOCKED flag bits.  A leading '*'
; marks LOCKED, an undefined value is displayed as five dots, and a defined or
; locked value is printed in the editor's current decimal/hexadecimal mode.
;
; A is the Spectrum pixel-row selector for the first output line.  The caller
; invokes this routine twice, with column positions $00 and $88, to display the
; forty symbols documented by the manual.
displaySymbolTableColumn:
    ; a = 0x00  - left column
    ;     0x88  - right column
    ld (varcSymbolTableColumnPosition+1),a  ; patch the horizontal pixel origin used for every row in this column
    ld a,010h                               ; start the column at the first symbol-table text row
.displayNextSymbolTableRow:
    push af                                 ; save this row coordinate while the symbol record is assembled
    ; Preserve the current row coordinate in the alternate accumulator while testing the remaining symbol count.
    ex af,af'
    ld a,b
    or c
    jp z,returnFromCompiledProgram          ; leave the display/print driver when no symbol remains
    ; Restore the row coordinate after confirming that at least one symbol remains.
    ex af,af'
    push bc                                 ; preserve the remaining-symbol count across row rendering
    push hl                                 ; preserve the current alphabetical entry pointer across formatting
varcSymbolTableColumnPosition:
    ; in pixels
    ; 0x00  - left column, 0x88  - right column
    ld c,000h
    call ROM_PixelAddress_22b0              ; convert the current row and column coordinates to a bitmap address
    ld (varcPrintingPosition+1),hl          ; redirect character output to the calculated row start
    pop hl
    push hl                                 ; retain it again while the corresponding ordinal vector is found
varcEndOfSymbolTable:
    ld de,00000h
    and a
    sbc hl,de
    ex de,hl
    ld hl,(varcSymbolTablePt+1)             ; restart at the current symbol-table count and vector array
    ; BC = number of ordinal vectors still available for this search
    ld c,(hl)
    inc hl
    ld b,(hl)
.findVectorForDisplayedSymbol:
    inc hl                                  ; advance from the count field to this vector’s low offset byte
    ld a,(hl)
    inc hl
    push hl
    ; hl = pointer to names table
    ld h,(hl)
    ld l,a
    ld a,h
    ; low 6 bits
    and 03fh                                ; retain only the fourteen-bit physical entry offset
    ld h,a                                  ; restore the clean offset high byte
    ; are we at the end of the table?
    sbc hl,de
    pop hl
    jr z,.renderCurrentSymbolEntry           ; format this symbol when the vector selects the current entry
    dec bc
    ld a,b
    or c
    jr nz,.findVectorForDisplayedSymbol
    ld a,MESSAGE_SOURCE_ERROR
    jp signalError
.renderCurrentSymbolEntry:
    ld c,(hl)
    pop hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    push de                                 ; save the value while the name is copied into the display buffer
    ex de,hl
    ld hl,lineBuffer
    ld (hl),020h                            ; reserve the leading lock-indicator cell as a blank
    ; locked entry?
    bit 7,c
    jr z,.copySymbolNameForDisplay           ; retain a blank indicator for an unlocked symbol
    ld (hl),"*"
.copySymbolNameForDisplay:
    inc hl
    push bc                                 ; preserve the remaining count and vector flags across string output
    ; symbol length
    ld b,LABEL_LENGTH
    call printFromDEtoHLpaddedLeft
    pop bc
    ex de,hl                                ; exchange name-source and row-destination roles after the copy
    ex (sp),hl                              ; recover the saved symbol value while preserving the row cursor
    ex de,hl
    ld a,c
    ; either DEFINED (bit 6) or LOCKED (bit 7) makes the value known
    and 0c0h
    jr nz,.formatDefinedSymbolValue          ; format the stored numeric value when it is known
    ; symbol undefined
    ; print 5-times "."
    ld bc,0052eh
    call atHLrepeatBTimesC
    ld (hl),b
    jr .outputSymbolTableLine
.formatDefinedSymbolValue:
    ; print address
    push hl                                 ; move the value-field destination into IX for number formatting
    pop ix                                  ; complete the HL-to-IX transfer without disturbing the value
    ex de,hl                                ; place the stored symbol value in HL for the numeric formatter
    ld c,000h                               ; request the editor’s current default decimal/hex display mode
    call printNumberToIX
.outputSymbolTableLine:
    ld hl,lineBuffer
    call displayCharactersAtHLUntil0Character
varcPrintSymbolTable:
    ; 1 - display and print symbol table
    ; 0 - display symbol table
    ld a,000h
    or a
    call nz,printLineBufferToChannel3       ; also send this row to channel 3 only for TABLE P
    pop hl
    pop bc
    dec bc
    pop af
    add a,008h
    cp 0a9h
    jp c,.displayNextSymbolTableRow
    ret


.symbolTableNonlockingOptions:
    ; print table
    ld b,"P"
    call compareWithCharacterInB
    ; a = 1  - print
    ; a = 0  - display only
    ld a,001h                               ; assume printer duplication is enabled for TABLE P
    jr z,.storeSymbolTablePrintMode          ; retain print mode when the P modifier matched
    dec a                                   ; otherwise convert the mode to screen-only display
.storeSymbolTablePrintMode:
    ld (varcPrintSymbolTable+1),a           ; patch the per-row optional printer call for this TABLE invocation
    ld a,MESSAGE_ANY_KEY
    call printStatusBar                     ; show the paging prompt before repainting symbol rows
    ; set display to highlight every second line
    ld hl,THIRD_LINE_ATTRIBUTE_ADDRESS
configurationPatchTarget05SymbolTableNormalAttribute: equ $+1 ; @config-patch 05
    ld a,TEXT_COLOR
    ; Store the normal row attribute in alternate AF so the fill loop can alternate colors without memory state.
    ex af,af'
    ; access line color
configurationPatchTarget13SymbolTableHighlightAttribute: equ $+1 ; @config-patch 13
    ld a,HIGHLIGHT_COLOR
    ld c,SYMBOL_TABLE_LINES_COUNT
.fillSymbolTableRowAttributes:
    ld b,CHARACTERS_PER_LINE
.fillOneSymbolTableAttributeRow:
    ld (hl),a
    inc hl
    djnz .fillOneSymbolTableAttributeRow
    ; swap highling/normal oclor
    ; Swap normal and highlighted row attributes before coloring the next table row.
    ex af,af'
    dec c
    jr nz,.fillSymbolTableRowAttributes      ; alternate attributes until the whole table area is prepared
    ; end of setting of color display
    ld hl,(varcSymbolTablePt+1)             ; load the moving symbol-table base
    ; BC = number of symbol table entries
    ld c,(hl)
    inc hl
    ld b,(hl)
    inc hl
    ; hl = hl + 2*bc
    add hl,bc
    add hl,bc
    ld (varcEndOfSymbolTable+1),hl          ; patch the entry-area anchor used to identify each displayed symbol
.displaySymbolTablePage:
    ; empty symbol table?
    ld a,b
    or c
    jr z,.leaveSymbolTableDisplay            ; leave the TABLE viewer without repainting when nothing remains
    exx                                     ; switch to the display-driver register set while preserving table traversal
    ld a,010h                               ; start clearing at the first table bitmap row
.clearSymbolTableDisplayRowsLoop:
    push af                                 ; preserve the row coordinate across the shared line clearer
    call clearLine
    pop af
    add a,008h
    cp 0a9h
    jr c,.clearSymbolTableDisplayRowsLoop
    exx
    xor a
    call displaySymbolTableColumn
    ld a,088h
    call displaySymbolTableColumn
    exx
    call processKey                         ; wait for the paging or exit key after a full table page
    ; BREAK
    cp " "
.leaveSymbolTableDisplay:
    jp z,startPrometheus
    exx
    jr .displaySymbolTablePage


; =============================================================================
; TABLE command
; =============================================================================
; TABLE       display forty symbols per page, two columns
; TABLE P     display and print one symbol per printer line
; TABLE L     SET bit 7 in every vector (lock)
; TABLE U     RES bit 7 in every vector (unlock)
; TABLE C     remove symbols not referenced by source and not locked
;
; Vector high-byte flags:
;   bit 7  LOCKED.  The value survives CLEAR/TABLE C and is accepted as known.
;   bit 6  DEFINED during normal assembly.  TABLE C temporarily reuses this bit
;          as a mark saying "referenced by the current source" and clears it
;          again after compaction.
;
; L/U/C operate directly on the vector array; value/name records never contain
; these state bits.
invokeTable:
    ; clear table option
    ld b,"C"
    call containsInputBufferCharacterInB
    jr z,.removeUnusedSymbolsAndResetDefinitions ; run reference-based symbol garbage collection when requested
    ; lock table option
    ld b,"L"
    call compareWithCharacterInB
    ; set value for the code modification, cb fe = set 7,(hl)
    ; = label locked
    ld c,0feh
    jr z,processSymbolTableItems            ; apply LOCKED to every vector when TABLE L matched
    ; unloack table option
    ld b,"U"
    call compareWithCharacterInB
    jr nz,.symbolTableNonlockingOptions      ; fall through to display or TABLE P for every non-U option
    ; for cb be = res 7,(hl)
    ; = label unlocked
    ld c,0beh
processSymbolTableItems:
    ; C is the second opcode byte of SET/RES 6/7,(HL); it is patched
    ; into varcSymbolVectorFlagInstruction and applied to every vector high byte.
    ld a,c
    ld (varcSymbolVectorFlagInstruction+1),a ; patch the vector-state operation performed inside the scan loop
    ld hl,(varcSymbolTablePt+1)             ; start at the symbol-table count field
    ld c,(hl)
    inc hl
    ld b,(hl)
    inc hl
.modifyNextSymbolVectorFlags:
    ld a,b
    or c
    ret z
    inc hl
varcSymbolVectorFlagInstruction:
    ; this instruction is set to RES or SET directly by modification
    ; of the second byte.
    ; bit 7 - locks or unlocks the symbol table record (label)
    ; bit 6 - label is defined / undefined
    set 7,(hl)
    inc hl
    dec bc
    jr .modifyNextSymbolVectorFlags


invokeClear:
    ; check "y" in the input buffer
    ld b,"y"
    call containsInputBufferCharacterInB
    ret nz                                  ; leave all source and symbols intact when CLEAR was not confirmed
    ld hl,sourceBufferAccessLine
    ld (varcSelectedBlockStart+1),hl        ; make the selected deletion block begin at the source start
    call getSourceEndPosition               ; derive the dynamic source-end sentinel before the symbol table
    ld (varcSelectedBlockEnd+1),hl          ; make the selected deletion block include the complete source
    call invokeDelete
; -----------------------------------------------------------------------------
; TABLE C / post-CLEAR symbol-table garbage collection
; -----------------------------------------------------------------------------
; 1. Clear DEFINED/mark bit 6 in every vector, preserving LOCKED bit 7.
; 2. Scan every compressed source record and set bit 6 for every referenced
;    ordinal, whether the reference is a line label or occurs in an expression.
; 3. Remove each vector with both flag bits clear.  Its two-byte value plus
;    high-bit-terminated name are removed from the sorted entry area as well.
; 4. Adjust offsets in surviving vectors, decrement the symbol count, and
;    rewrite every source ordinal greater than the removed ordinal.
; 5. Clear bit 6 again.  Retained unlocked symbols are therefore undefined until
;    the next first assembly pass; locked symbols retain bit 7 and their value.
;
; The implementation compacts in place and may be slow, which explains why the
; manual recommends TABLE C only occasionally.
.removeUnusedSymbolsAndResetDefinitions:
    call printStatusBarWithWaitPlease
    ; set table modifier to CB B6 = res 6,(HL)
    ; = label undefined
    ld c,0b6h
    call processSymbolTableItems            ; clear bit 6 in every vector while preserving LOCKED state
    ld hl,sourceBufferAccessLine
    call findNextSymbolReferenceInSource    ; locate the first encoded line-label or expression symbol ordinal
.markSourceReferencedSymbolsLoop:
    jr nc,.prepareSymbolTableCompaction      ; begin vector compaction after the source contains no further references
    push hl
    ld l,(hl)
    and 07fh
    ld h,a
    add hl,hl                               ; scale the ordinal to the two-byte vector width
    ld de,(varcSymbolTablePt+1)             ; current symbol-table base
    add hl,de                               ; index the selected ordinal vector from that base
    inc hl
    set 6,(hl)                              ; mark this symbol as referenced by setting temporary bit 6
    pop hl
    inc hl
    call findNextSymbolReferenceInPayload
    jr .markSourceReferencedSymbolsLoop
.prepareSymbolTableCompaction:
    ld hl,(varcSymbolTablePt+1)             ; restart at the symbol-table count for the removal pass
    ld c,(hl)
    inc hl
    ld b,(hl)
    inc hl
    push hl
    add hl,bc
    add hl,bc                               ; complete the two-byte-per-vector offset
    ld (varcSymbolEntryAreaBaseForCleanup+1),hl ; patch the current value/name entry-area base for physical deletion
    pop hl
.symbolCompactionVectorLoop:
    ld a,b
    or c
    jr nz,.testCurrentSymbolForRemoval       ; inspect the next vector while symbols remain
    ; set table modifier to CB B6 = res 6,(HL)
    ; = label undefined
    ld c,0b6h
    jp processSymbolTableItems
.testCurrentSymbolForRemoval:
    dec bc
    ld (varcCurrentCompactionVectorPointer+1),hl ; save its low-byte pointer so source ordinal rewriting can resume here
    ld e,(hl)
    inc hl
    ld a,(hl)
    and 0c0h
    ld a,(hl)                               ; reload the complete high byte for later offset extraction
    inc hl
    jr nz,.symbolCompactionVectorLoop        ; retain referenced or locked symbols without moving their data
    and 03fh                                ; strip state flags from an unreferenced unlocked symbol’s offset high byte
    ld d,a
    push bc                                 ; preserve the remaining-vector count across physical compaction
    push hl                                 ; preserve the following-vector pointer across entry deletion
varcSymbolEntryAreaBaseForCleanup:
    ld hl,00000h
    add hl,de                               ; locate the removable entry by adding its vector offset
    ld (varcRemovedSymbolEntryOffset+1),de  ; remember that offset as the threshold for surviving-vector adjustment
    ld d,h
    ld e,l
    inc de
    inc de
.findRemovedSymbolEntryEnd:
    ld a,(de)
    inc de
    rlca                                    ; rotate the terminator bit into carry
    jr nc,.findRemovedSymbolEntryEnd         ; continue until the final name character marks the entry boundary
    call closeDeletedSymbolDataGap
    and a
    sbc hl,de                               ; derive the removed entry length as old occupied end minus compacted end
    ld b,h
    ld c,l
    ld hl,varcCodeEndPt+1                   ; select the moving end-of-resident-storage pointer
    call subtractBCFromPointerAtHL
    pop hl
    push bc                                 ; preserve the entry byte count while deleting the vector itself
    ld d,h
    ld e,l
    dec hl
    dec hl
    call closeDeletedSymbolDataGap
    ld bc,00002h                            ; prepare the fixed vector width removed from the table header area
    ld hl,varcSymbolEntryAreaBaseForCleanup+1 ; select the patched entry-area base pointer
    call subtractBCFromPointerAtHL
    ld hl,varcCodeEndPt+1                   ; select the moving end-of-resident-storage pointer again
    call subtractBCFromPointerAtHL
    pop bc
    push bc                                 ; retain it while clearing the bytes vacated at the physical end
    inc bc
    inc bc
.clearVacatedSymbolBytesLoop:
    xor a
    ld (de),a
    inc de
    dec bc
    ld a,b
    or c
    jr nz,.clearVacatedSymbolBytesLoop       ; clear every byte released by this symbol removal
    ld hl,(varcSymbolTablePt+1)             ; reload the current symbol-table base and count field
    push hl                                 ; preserve the base while decrementing its symbol count
    inc bc                                  ; convert zeroed BC into the one-symbol decrement value
    call subtractBCFromPointerAtHL
    pop ix
    pop bc
.adjustRemainingVectorOffsetsLoop:
    ld a,d                                  ; test the high byte of the offset-adjustment loop control retained in DE
    or e                                    ; combine both loop-control bytes to detect completion of offset adjustment
    jr z,.rewriteSourceOrdinalsAfterSymbolRemoval ; rewrite compressed-source ordinals when the offset-adjustment control reaches zero
    push de                                 ; preserve the offset-adjustment loop control around one vector lookup
    call advanceSymbolVectorAndLoadOffset   ; advance IX and decode the next surviving vector’s clean entry offset
varcRemovedSymbolEntryOffset:
    ld de,00000h                            ; load the removed entry’s offset threshold
    and a                                   ; clear carry before comparing this surviving entry offset
    sbc hl,de
    jr c,.continueVectorOffsetAdjustment     ; leave offsets before the removed entry unchanged
    push ix
    pop hl
    call subtractBCFromPointerAtHL          ; subtract the removed entry length from this vector’s stored offset
.continueVectorOffsetAdjustment:
    pop de
    dec de                                  ; decrement the offset-adjustment loop control
    jr .adjustRemainingVectorOffsetsLoop
.rewriteSourceOrdinalsAfterSymbolRemoval:
    ld hl,(varcCurrentCompactionVectorPointer+1) ; reload the saved low-byte pointer of the ordinal that was removed
    ld de,(varcSymbolTablePt+1)             ; current symbol-table base for ordinal derivation
    sbc hl,de                               ; convert the removed vector address into a byte offset from the base
    ex de,hl                                ; move that byte offset into DE for division by vector width
    srl d                                   ; shift the high byte while dividing the vector offset by two
    rr e
    ld hl,sourceBufferAccessLine
    call findNextSymbolReferenceInSource    ; locate the first encoded symbol ordinal to compare with the removed one
.rewriteSourceSymbolOrdinalsLoop:
    jr nc,.resumeSymbolCompactionAtSavedVector ; resume table compaction when the complete source has been rewritten
    push hl
    ld l,(hl)
    ld h,a
    push hl
    res 7,h
    or a
    sbc hl,de                               ; compute encoded ordinal minus removed ordinal
    pop hl
    jr nc,.decrementEncodedSymbolOrdinal     ; decrement this reference when it followed the removed symbol
    pop hl
.continueSourceOrdinalRewrite:
    inc hl
    call findNextSymbolReferenceInPayload
    jr .rewriteSourceSymbolOrdinalsLoop
.decrementEncodedSymbolOrdinal:
    dec hl
    ld b,h
    ld c,l
    pop hl
    ld (hl),c
    dec hl
    ld (hl),b
    inc hl
    jr .continueSourceOrdinalRewrite
.resumeSymbolCompactionAtSavedVector:
varcCurrentCompactionVectorPointer:
    ld hl,00000h                            ; reload the saved pointer to the vector following the removed one
    pop bc
    jp .symbolCompactionVectorLoop
advanceSymbolVectorAndLoadOffset:
    inc ix
    ld l,(ix+001h)                          ; load the next vector offset low byte through the original +1 convention
    inc ix
    ld a,(ix+001h)
    and 03fh                                ; remove DEFINED/LOCKED bits from the entry offset
    ld h,a
    ret


; Scan the compressed source for the next two-byte symbol ordinal.
;
; Entry: HL is a source position.  Exit with carry set returns A as the tagged
; high ordinal byte and HL one byte past it; carry clear means the dynamic
; source/symbol-data end was reached.  The scanner understands both optional
; line-label references and symbol references embedded in expression payloads,
; skipping literal bytes and $C0+length record terminators.
findNextSymbolReferenceInSource:
.findNextSourceRecordWithSymbolReference:
    call comparePositionWithCodeEnd
    ret nc                                  ; return carry clear when no further source record exists
    inc hl
    ld a,(hl)
    and 00fh
    inc hl
    jr z,.findNextSourceRecordWithSymbolReference
    and 008h
    jr nz,.returnFoundSymbolReference        ; return that label reference before scanning the remaining expression payload
findNextSymbolReferenceInPayload:
.scanSourcePayloadForSymbolReference:
    ld a,(hl)
    inc hl
    cp 0c0h                                 ; recognize the $C0-plus-length record terminator class
    jr nc,.findNextSourceRecordWithSymbolReference ; continue with the next source record after reaching this record’s end
    cp 080h
    jr c,.scanSourcePayloadForSymbolReference
    dec hl
.returnFoundSymbolReference:
    ld a,(hl)
    inc hl
    scf                                     ; signal a successfully located symbol reference with carry
    ret


; =============================================================================
; SAVE COMMAND: WRITE COMPRESSED SOURCE PLUS ITS COMPLETE SYMBOL TABLE
; =============================================================================
; Command forms implemented by this path:
;   SAVE :name      whole source, explicit ten-character CODE name
;   SAVE            whole source, previously retained name
;   SAVE b:name     inclusive selected block, explicit name
;   SAVE b          inclusive selected block, retained name
;
; IX points at a 17-byte Spectrum tape header assembled in the bottom bitmap
; line.  Header byte 0 is CODE type 3; bytes 1..10 are the space-padded name;
; bytes 11..12 are total payload length; bytes 15..16 are repurposed to store
; the source-record portion length.  The standard CODE destination parameter is
; not used by PROMETHEUS because LOAD chooses its own temporary destination.
;
; Whole-source bounds are sourceBufferAccessLine through the byte twelve bytes
; below varcSymbolTablePt.  Those twelve bytes are the fixed empty-record tail
; separating editable source records from the dynamic table.  Block SAVE calls
; getSelectedBlock and advances once past the inclusive final record, producing
; the same half-open [start,end) convention.
;
; The payload layout reconstructed from both SAVE length arithmetic and LOAD's
; resolver setup is:
;
;   source bytes [sourceLength]
;   two-byte bridge generated by the chained tape writer
;   complete symbol-table bytes [symbolTableLength]
;
; Therefore totalLength = sourceLength + symbolTableLength + 2.  The source is
; emitted first with ROM SaveControl.  A compact continuation sequence beginning
; one byte before the symbol table emits the bridge and table as one logical CODE
; payload.  The precise ROM-level roles of the two bridge bytes are deliberately
; not guessed here; LOAD demonstrably skips both before using the table.
;
; Four self-modified values are retained for VERIFY, which explains the manual's
; requirement that VERIFY be used immediately after SAVE:
;   varcLastSavedSourceStart
;   varcLastSavedSourceLength
;   varcLastSavedSymbolTableStart
;   varcLastSavedAuxiliarySegmentLength
invokeSave:
    ld ix,BOTTOM_LINE_VRAM_ADDRESS
    ld (ix+000h),003h                       ; mark the saved payload as Spectrum CODE type 3
    call containsInputBufferCharacterB
    push af                                 ; retain the whole-source/block decision while parsing the filename
    ld b,03ah
    cp b
    jr z,.saveFilenameDelimiterChecked       ; skip one input read when the delimiter was already found by the B test
    call readInputCharacterSkippingCursorAndAdvance
.saveFilenameDelimiterChecked:
    jr nz,.copySaveNameIntoCodeHeader        ; reuse the retained filename when no colon follows the command
    call readFileNameFromInput              ; parse and retain a new ten-character filename after ':'
.copySaveNameIntoCodeHeader:
    ld hl,fileNameBuffer
    ld de,BOTTOM_LINE_VRAM_ADDRESS+1
    ld bc,0000ah
    ldir                                    ; populate the header filename field without changing its persistent source
    pop af
    jr z,.selectSaveBlockRange               ; choose selected-block bounds when command parameter B was present
    ld hl,(varcSymbolTablePt+1)             ; current symbol-table base, immediately above editable source
    ld de,0fff4h                            ; prepare -12 to exclude the fixed empty-record tail
    add hl,de                               ; derive the exclusive end of meaningful whole-source records
    ld de,sourceBufferAccessLine
    jr .storeSaveRangeMetadata
.selectSaveBlockRange:
    call getSelectedBlock                   ; normalize the two editor block margins into DE=first and HL=last
    ex de,hl
    call getNextSourceRecord
.storeSaveRangeMetadata:
    push de
    ld (varcLastSavedSourceStart+2),de      ; patch VERIFY with this SAVE's source start
    or a
    sbc hl,de                               ; calculate sourceEnd-sourceStart
    push hl
    ld (varcLastSavedSourceLength+1),hl     ; patch VERIFY with this SAVE's source length
    ld (BOTTOM_LINE_VRAM_ADDRESS+15),hl
    ld hl,(varcCodeEndPt+1)                 ; current end of the combined source/symbol region
    ld de,(varcSymbolTablePt+1)             ; current symbol-table base
    and a
    sbc hl,de
    ld (varcLastSavedSymbolTableStart+2),de ; patch VERIFY with this SAVE's symbol-table start
    inc hl
    ld (varcLastSavedAuxiliarySegmentLength+1),hl ; retain that chained auxiliary length for VERIFY
    dec hl
    pop de
    push de
    add hl,de
    inc hl
    inc hl
    ld (BOTTOM_LINE_VRAM_ADDRESS + 11),hl
    ld a,MESSAGE_START_TAPE
    push ix                                 ; preserve the header pointer while the status bar uses IX internally
    call printStatusBar
    pop ix
    call waitForKeyAndWriteTapeHeader
    pop de
    pop ix
    ld a,0ffh                               ; select the standard $FF data-block flag
    call ROM_SaveControl_4c6
varcLastSavedSymbolTableStart:
    ld ix,00000h
    dec ix
varcLastSavedAuxiliarySegmentLength:
    ld de,00000h
    ld l,0ffh
    ld a,h
    xor l
    ld h,a
    ld a,001h
    scf                                     ; set carry for the ROM save-marker path
    rl l                                    ; rotate the standard data flag into the marker state
    ld b,037h                               ; supply the ROM SA-SET timing/state constant used by the chained writer
    call ROM_SA_SET
    jp abortCurrentOperationIfSpacePressed
; Wait for the user to start the recorder and write the 17-byte tape header.
;
; The initial busy delay lets the status message become visible.  Any key exits
; the keyboard wait.  IX is preserved by callers as the header address; DE=17
; and A=0 select a header block in the Spectrum ROM SAVE routine.  A second delay
; separates the header from the following data block.  This helper is shared by
; assembler SAVE and the monitor's arbitrary memory-block SAVE.
waitForKeyAndWriteTapeHeader:
    ld h,001h                               ; seed the compact busy delay before showing the recorder-start key state
.saveHeaderInitialDelayLoop:
    inc hl
    inc h
    dec h
    jr nz,.saveHeaderInitialDelayLoop        ; repeat the busy delay until the low-byte wrap changes H's test result
.waitForTapeStartKey:
    xor a
    ; read keyboard
    in a,(0feh)                             ; read the keyboard matrix
    cpl                                     ; convert active-low key bits to active-high
    and 01fh
    jr z,.waitForTapeStartKey                ; keep waiting while no physical key is pressed
    ld de,00011h
    xor a
    call ROM_SaveControl_4c6
.saveHeaderPostDelayLoop:
    dec de
    dec d
    inc d
    jr nz,.saveHeaderPostDelayLoop           ; delay until DE's wrap produces the loop's terminal zero condition
    ret


; Parse an optional colon-prefixed tape filename.
;
; If no ':' is present, return without modifying fileNameBuffer, thereby reusing
; the most recent SAVE/LOAD name.  After ':', copy at most ten characters and
; pad the remainder with spaces.  The initial retained default is "prometheus".
; The lower-level copy entry is also used by monitor tape commands with a caller-
; supplied destination rather than fileNameBuffer.
readFileNameWithColon:
    ld b,":"
    call containsInputBufferCharacterInB
    ret nz                                  ; retain the previous filename when no colon is present
readFileNameFromInput:
    ld de,fileNameBuffer
copyFileNameFromHLToDE:
    ld b,MAX_FILE_NAME_LENGTH
.copyFileNameCharacterLoop:
    call atHLorNextIfOne
    inc hl
    or a
    jr z,.padFileNameWithSpaces              ; space-pad the unused filename tail after an early terminator
    ld (de),a
    inc de
    dec b
    jr nz,.copyFileNameCharacterLoop
    ret
.padFileNameWithSpaces:
    ld a," "
.padFileNameLoop:
    ld (de),a
    inc de
    djnz .padFileNameLoop
    ret

fileNameBuffer:
    defb "prometheus"


; =============================================================================
; VERIFY COMMAND: COMPARE THE MOST RECENT SAVE AGAINST TAPE
; =============================================================================
; VERIFY accepts no filename or range argument.  It repeatedly reads CODE
; headers until the ten-byte name equals fileNameBuffer, then compares exactly
; the ranges patched by the preceding SAVE.
;
; Carry is clear on entry to the first ROM LD-BYTES call, selecting VERIFY rather
; than LOAD.  The source segment uses varcLastSavedSourceStart/Length.  The
; auxiliary symbol-table segment uses the start and length retained by SAVE and
; the same chained-marker protocol as the writer.  Any header/data failure or
; explicit SPACE cancellation follows the common tape-error/editor-return path.
invokeVerify:
    call scanTapeForNextCodeHeader
    call compareRequestedNameWithLoadedHeaderExact
    jr nz,invokeVerify
    xor a
    dec a                                   ; form expected data flag $FF without setting carry
varcLastSavedSourceStart:
    ld ix,00000h
varcLastSavedSourceLength:
    ld de,00000h
    call performTapeLoadOrVerifyOrReportError
    ld ix,(varcLastSavedSymbolTableStart+2) ; load the retained live symbol-table start into IX
    ld de,(varcLastSavedAuxiliarySegmentLength+1) ; load the chained auxiliary length retained by SAVE
    dec de
    ld b,0b0h                               ; supply the ROM marker-state constant for the auxiliary continuation
    ; Move the first auxiliary-marker state to AF' while primary AF is rebuilt for the verify continuation.
    ex af,af'
    xor a
    dec a                                   ; form $FF while keeping VERIFY carry clear
    ; Return the rebuilt marker state to AF' before entering the ROM chained-load helper.
    ex af,af'
    call ROM_LD_MARKER
    call abortCurrentOperationIfSpacePressed
    jr .returnIfTapeOperationSucceeded       ; normalize final carry through the shared tape success/error tail
performTapeLoadOrVerifyOrReportError:
    call callRomTapeLoadOrVerify
.returnIfTapeOperationSucceeded:
    ret c
    ld a,MESSAGE_TAPE_ERROR
.displayStatusAndAbortCommand:
    call printStatusBar
    jp abortCommandAndReturnToEditor


; =============================================================================
; LOAD COMMAND: STAGE A SAVED PAYLOAD, THEN RE-INSERT EACH SOURCE RECORD
; =============================================================================
; LOAD never raw-copies imported records into the live source region.  The full
; CODE payload is first loaded just below U-TOP.  Each imported compressed record
; is then expanded through its imported symbol table, copied into inputBuffer,
; and submitted through the ordinary editor tokenizer/inserter.  Consequently:
;
; - imported symbol ordinals are translated by name into the current table;
; - syntax is checked exactly as for keyboard input;
; - records are inserted after the current access line;
; - there is no separate replace mode (CLEAR y before LOAD gives replacement);
; - records successfully inserted before BREAK, Memory full, or a source error
;   remain inserted; there is no transactional rollback.
;
; varcPostCommandContinuationJump is temporarily redirected so every successful
; submitted line resumes the import loop.  The resolver's LD opcode is patched
; between direct imported-base mode ($21 = LD HL,nn) and normal indirect current-
; table mode ($2A = LD HL,(nn)).
invokeLoad:
    call prepareTapeSourceImport
    ld hl,continueSourceImportAfterSubmittedLine
    ld (varcPostCommandContinuationJump+1),hl ; patch normal line submission to resume this import loop
varcImportedDataCursor:
    ld hl,00000h
    push hl
    push hl
    pop ix
    call getNextSourceRecord                ; decode its variable length and locate the following staged record
    ld (varcImportedDataCursor+1),hl        ; advance the persistent import cursor before submitting the current line
    pop hl
varcImportedSourceEnd:
    ld de,00000h
    and a
    sbc hl,de
    jr nc,.finishSourceImport                ; finish before interpreting bridge/table bytes as source
    ld a,021h                               ; select opcode $21 (LD HL,nn) for direct staged-table addressing
varcImportedSymbolTableBase:
    ld hl,00000h                            ; load the staged symbol-table base calculated from the header metadata
    call patchSymbolReferenceResolverBase
    call expandSourceRecordToLineBuffer
    ld a,02ah                               ; select opcode $2A (LD HL,(nn)) for normal live-table indirection
    ld hl,varcSymbolTablePt+1               ; restore the live symbol-table pointer operand
    call patchSymbolReferenceResolverBase   ; restore ordinary editor symbol resolution immediately after expansion
    ld a,(varcLastStatusBarMessage+1)       ; inspect the status message left by source expansion
    cp MESSAGE_SOURCE_ERROR
    jr z,.displayStatusAndAbortCommand       ; show the source error and retain the offending text for repair
    ld hl,lineBuffer
    ld de,inputBufferStart
    ld bc,00020h
    ldir                                    ; transfer imported text and cursor marker into normal editor input state
    call clearStringBuffers
    jp submitInputLineOrDispatchCommand
; Continuation after one imported line has passed normal editor insertion.
;
; No key: continue silently.  Any non-SPACE key intentionally falls through to
; renderVisibleSourceRecords, showing import progress.  SPACE jumps through the
; common abort path.  Before the next record, compare the growing live source/
; table end with the next staged record pointer; collision means the old and
; imported tables no longer coexist and raises Memory full.
continueSourceImportAfterSubmittedLine:
    call pollImportKeyboardAndRefreshIfRequested
    ld de,(varcImportedDataCursor+1)        ; load the next staged record address
    ld hl,(varcCodeEndPt+1)                 ; load the growing live source/symbol end
    and a
    sbc hl,de
    jr c,varcImportedDataCursor
    ld a,MESSAGE_MEMORY_FULL                ; select Memory full after a late merge collision
    jp signalError
.finishSourceImport:
    ld hl,prometheusWarmStart
    ld (varcPostCommandContinuationJump+1),hl ; restore normal post-command dispatch after import completion
    jp (hl)


; =============================================================================
; GENS/MASM IMPORT: CONVERT LINE-NUMBERED CR-TERMINATED TEXT THROUGH THE EDITOR
; =============================================================================
; Documented external format:
;
;   two bytes ignored as the foreign assembler's line number
;   textual source bytes
;   $0D carriage return terminating every line
;
; The command accepts the same optional/reused filename syntax as LOAD.  The
; matching CODE payload is staged immediately below U-TOP by
; prepareTapeSourceImport.  Unlike native PROMETHEUS LOAD, this path ignores the
; repurposed CODE-header source-length and symbol-table fields: the foreign
; payload is treated as a flat byte stream ending at U-TOP.
;
; G, I, and J command-token slots all enter the same routine.  Only GENS is a
; documented user command.  The shared entry is a fact of the static dispatch
; table; it does not by itself prove that ordinary editor input can generate the
; undocumented I/J tokens in every context.
;
; Import is deliberately incremental.  Each converted line is submitted through
; submitInputLineOrDispatchCommand, so it receives the same syntax checking,
; symbol creation, compression, insertion, and error behavior as a line typed by
; the user.  Successfully inserted earlier lines remain if import is cancelled
; or a later line fails.
invokeGens:
invokeGensTokenAliasI:
invokeGensTokenAliasJ:
    call prepareTapeSourceImport
    ld hl,continueGensImportAfterSubmittedLine ; select the continuation after one converted foreign line is accepted
    ld (varcPostCommandContinuationJump+1),hl ; patch normal submission to resume GENS/MASM import
; Convert one foreign line into PROMETHEUS's 32-byte edit buffer.
;
; B starts at 1 because one of the 32 edit-buffer positions is reserved for the
; editor's $01 cursor/end marker.  DE is the next destination byte.  HL is loaded
; from varcImportedDataCursor and advanced twice, unconditionally discarding the
; foreign two-byte line number.
;
; Accepted text capacity is therefore 31 characters.  Once incrementing B sets
; bit 5 (B >= 32), subsequent bytes are discarded, but scanning continues until
; CR so the next line remains aligned.  There is no separate truncation error;
; the surviving 31-character prefix is passed to the normal parser.
.importNextGensLine:
    ld b,001h
    ld de,inputBufferStart
    ld hl,(varcImportedDataCursor+1)        ; current position in the staged foreign byte stream
    inc hl
    inc hl
; Read foreign bytes until CR.
;
; $0D terminates the line before any normalization.  For bytes retained within
; the 31-character limit:
;
;   $00-$1F except CR -> one ordinary space
;   $20-$FF           -> value with bit 7 cleared
;
; Thus TAB and other controls are not expanded to tab stops; each becomes one
; space.  Repeated spaces are retained.  The manual's note that one space is
; sufficient is advice for preparing compact input, not an implemented collapse
; of whitespace.  High-bit stripping converts GENS/MASM text to 7-bit input.
.scanNextGensLineByte:
    ld a,(hl)
    inc hl
    cp 00dh
    jr z,.finishCurrentGensLine              ; finish and submit the converted line at CR
    bit 5,b
    jr nz,.scanNextGensLineByte              ; discard excess text but keep scanning to the line's CR boundary
    cp 020h                                 ; classify foreign control characters below ASCII space
    jr nc,.storeNormalizedGensLineByte       ; retain printable/high-bit source bytes for seven-bit normalization
    ld a,020h
.storeNormalizedGensLineByte:
    and 07fh                                ; strip the foreign assembler's high-bit text marking
    ld (de),a
    inc de
    inc b
    jr .scanNextGensLineByte
; Commit the foreign stream cursor and terminate the editor line.
;
; varcImportedDataCursor is patched to the byte immediately after CR.  A $01
; marker is written after the retained text, matching the editor's movable cursor
; convention used by atHLorNextIfOne.  The rest of the fixed input area is filled
; with zeroes before ordinary parsing begins.
.finishCurrentGensLine:
    ld (varcImportedDataCursor+1),hl        ; patch the next import iteration to start immediately after CR
    ld a,001h
    ld (de),a
.clearRemainingGensInputBuffer:
    inc de
    xor a
    ld (de),a
    inc b
    bit 5,b
    jr z,.clearRemainingGensInputBuffer
    call clearStringBuffers                 ; reset parser scratch state before treating the converted line as user input
    jp submitInputLineOrDispatchCommand
; Continue after one converted GENS line was inserted successfully.
;
; The shared import keyboard poll behaves exactly as native LOAD: no key keeps
; importing, SPACE aborts, and another key refreshes the visible source listing.
; The next foreign line is processed while varcImportedDataCursor is below U-TOP;
; equality or a higher address finishes and restores the normal editor
; continuation.
;
; The bound is checked only between lines, not while scanning characters.  A
; malformed final line without CR can therefore run across U-TOP before control
; returns here.  The manual specifically warns that U-TOP=$FFFF may let scanning
; wrap into the first ROM bytes; using a slightly lower U-TOP avoids that edge.
continueGensImportAfterSubmittedLine:
    call pollImportKeyboardAndRefreshIfRequested
    ld hl,(varcImportedDataCursor+1)        ; load the next foreign line position
    ld de,(varcUTop+1)                      ; load U-TOP, which is the exclusive end of the staged foreign payload
    and a
    sbc hl,de
    jr c,.importNextGensLine                 ; convert the next line while the cursor remains below U-TOP
    jr .finishSourceImport


; Patch the first instruction of resolveSymbolReferenceToName.
;
; A is the desired opcode and HL its two-byte operand:
;   $21  LD HL,nn      use the staged imported table directly
;   $2A  LD HL,(nn)    load the current dynamic table pointer indirectly
;
; This is not a table-size setter: it switches the resolver's addressing mode
; while an imported record is expanded, then restores normal editor operation.
patchSymbolReferenceResolverBase:
    ld (varcSymbolTableBasePointer),a       ; patch the resolver opcode selecting direct or indirect table addressing
    ld (varcSymbolTableBasePointer+1),hl    ; patch the corresponding two-byte table-base operand
    ret


; Find the requested CODE header and stage its payload below U-TOP.
;
; Header bytes 11..12 give total payload length.  Capacity is checked while the
; current source/table remains resident, because LOAD needs both old and imported
; tables simultaneously.  The temporary start is U-TOP-totalLength, so the data
; occupies the high free region without changing live source pointers.
;
; Header bytes 15..16 give sourceLength.  The saved source therefore ends at
; temporaryStart+sourceLength.  The imported symbol resolver starts two bytes
; later, confirming the payload's two-byte bridge.  The entire data block is then
; read in LOAD mode.  A failed ROM operation reports Tape error before any source
; record has been inserted.
loadMatchingCodePayloadToTemporaryMemory:
    call scanTapeForNextCodeHeader
    call acceptLoadedHeaderIfNameMatchesOrWildcard
    jr nz,loadMatchingCodePayloadToTemporaryMemory ; resume scanning after a name mismatch
    ld hl,(BOTTOM_LINE_VRAM_ADDRESS + 11)
    ld b,h
    ld c,l
    call ensureBCBytesFitBelowUTop
    ex de,hl
    ld hl,(varcUTop+1)                      ; load the configured exclusive U-TOP boundary
    and a
    sbc hl,de                               ; derive temporaryStart=U-TOP-totalLength
    push hl
    ld (varcImportedDataCursor+1),hl        ; patch the import cursor to the beginning of staged data
    ld bc,(BOTTOM_LINE_VRAM_ADDRESS + 15)
    add hl,bc                               ; derive the exclusive end of staged native source records
    ld (varcImportedSourceEnd+1),hl         ; patch native LOAD's source-end guard
    inc hl
    inc hl
    ld (varcImportedSymbolTableBase+1),hl   ; patch imported symbol resolution to the staged table base
    pop ix
    scf
    sbc a,a                                 ; form expected standard data flag $FF while preserving carry set
    call performTapeLoadOrVerifyOrReportError ; load the complete payload or report Tape error before any merge begins
setBorderColor:
configurationPatchTarget11NormalBorderColor: equ $+1 ; @config-patch 11
    ld a,007h
    out (0feh),a                            ; write the restored border colour to the ULA
    ret


; =============================================================================
; Two-pass assembly controller
; =============================================================================
; The optional command parameter B selects block-only assembly.  The helper
; containsInputBufferCharacterB returns Z when B is present, so the stored scope
; byte is deliberately inverted from the natural wording:
;
;   varcCompileWholeSource = 0   process only records inside the selected block
;   varcCompileWholeSource = 1   process every source record
;
; At entry all unlocked symbols lose DEFINED bit 6; LOCKED symbols retain bit 7
; and remain usable for separately compiled lower layers.  The controller then
; installs firstPassProcessSourceRecord into a self-modified CALL, initializes
; both the logical address and physical output pointer to one byte beyond the
; current dynamic source/symbol region, and scans source records in address
; order.  For block assembly, records outside the inclusive selected bounds are
; skipped in both passes.
;
; After the first scan, varcAssemblyPassTransitionCounter changes from 1 to 0,
; the CALL target is patched to secondPassEmitSourceRecord, and the same scan is
; repeated.  After the second scan the counter underflows to $FF and the routine
; returns.  No listing or code-size report is generated; success is reported by
; the caller as MESSAGE_ASSEMBLY_COMPLETE.
;
; Self-modified fields:
;   varcAssemblyPassHandlerCall+1       current per-record handler address
;   varcNextAssemblyRecordPointer+1     next record in the linear scan
;   reportAssemblyErrorAtSourceRecord+1 current record for error positioning
;   varcAssemblyPassTransitionCounter+1 pass transition state
processCompilation:
    ; Z means command parameter B was found: store 0 for block-only mode
    call containsInputBufferCharacterB
    ld a,000h
    jr z,.storeCompilationScope              ; retain block-only mode when B was present
    inc a
.storeCompilationScope:
    ld (varcCompileWholeSource+1),a         ; persist the selected whole-source or block-only scope
    ; clear DEFINED bit 6 in every symbol vector; LOCKED bit 7 survives
    ; C=$B6 patches RES 6,(HL) into the shared vector modifier
    ld c,0b6h
    call processSymbolTableItems            ; clear DEFINED on every unlocked symbol before pass one
    ld a,001h                               ; seed the two-pass transition state before the first scan
    ld (varcAssemblyPassTransitionCounter+1),a ; store the initial first-to-second-pass transition state
    ld hl,firstPassProcessSourceRecord
    ld (varcAssemblyPassHandlerCall+1),hl   ; install the first-pass processor in the self-modified dispatch call
.initializeAssemblyPass:
    ld hl,(varcCodeEndPt+1)                 ; start generated code immediately after current source/symbol storage
    inc hl
    ld (varcAddressCounter+1),hl            ; initialize the logical address used by labels and the $ atom
    ld (varcAssemblyOutputPointer+1),hl     ; initialize physical emission at the same post-source address
    ld hl,sourceBufferAccessLine
.processNextAssemblyRecord:
    call comparePositionWithCodeEnd
    jr nc,varcAssemblyPassTransitionCounter ; transition passes when the scan reaches the dynamic source end
    ld (reportAssemblyErrorAtSourceRecord+1),hl ; remember this record so any error can highlight it
    push hl                                 ; preserve the current record while finding its successor
    call getNextSourceRecord                ; calculate the successor before processing the current record
    ld (varcNextAssemblyRecordPointer+1),hl ; cache the successor before processing can change IX or HL
    pop ix
varcCompileWholeSource:
    ; 0 - compile only the selected block (B parameter present)
    ; 1 - compile the entire source (no B parameter)
    ld a,000h
    or a
    jr nz,varcAssemblyPassHandlerCall       ; process every record when whole-source mode is active
    call testSourceRecordOutsideSelectedBlock
    jr c,varcNextAssemblyRecordPointer      ; skip records outside the selected block
varcAssemblyPassHandlerCall:
    call firstPassProcessSourceRecord
varcNextAssemblyRecordPointer:
    ld hl,00000h                            ; reload the successor cached before processing this record
    jr .processNextAssemblyRecord
varcAssemblyPassTransitionCounter:
    ld a,000h
    dec a
    ld (varcAssemblyPassTransitionCounter+1),a ; persist the decremented pass-transition state
    ld hl,secondPassEmitSourceRecord
    ld (varcAssemblyPassHandlerCall+1),hl   ; replace the pass-one handler with the pass-two emitter
    jr z,.initializeAssemblyPass             ; restart from the source beginning only for the second pass
    ret


; ASSEMBLY command completion path.
;
; processCompilation either returns after two successful passes or leaves via
; signalError.  A normal return therefore needs only to select the documented
; "Assembly complete" status and re-enter the editor warm start.
invokeAssembly:
    call processCompilation
    ld a,MESSAGE_ASSEMBLY_COMPLETE
    jp prometheusWarmStartWithMessage


; -----------------------------------------------------------------------------
; Execute one non-machine source record during pass two
; -----------------------------------------------------------------------------
; Entry: IX addresses the record header and any optional line-label ordinal has
; been skipped before its operand is evaluated.
;
; Pseudo-opcode dispatch:
;   $00 empty line / $01 comment   no action
;   $02 ENT                        save RUN target; decrement ENT balance
;   $03 EQU                        no pass-two action (value was set in pass one)
;   $04 ORG                        set logical address and physical output pointer
;   $05 PUT                        set physical output pointer only
;   $06 DEFB                       evaluate list; emit one checked byte per item
;   $07 DEFM                       emit quoted bytes; apostrophe form tags last
;                                  byte with bit 7
;   $08 DEFS                       advance both pointers; emit no memory bytes
;   $09 DEFW                       emit little-endian words from expression list
;
; Important implementation detail: contrary to a sentence in the manual, EQU
; is actually evaluated in pass one, not pass two.  Its expression may use only
; symbols already DEFINED earlier in that scan or retained as LOCKED; any still-
; undefined symbol follows the normal Unknown error path.
.executePseudoInstructionSecondPass:
    ld a,(ix+000h)
    call skipEncodedLineLabelIfPresent      ; position IX at pseudo-instruction operands after an optional label
    sub 002h                                ; normalize pseudo-opcodes so ENT becomes dispatch case zero
    ret c                                   ; ignore empty and comment records during pass two
    jr nz,.testEquOrgAndPutPseudoOpcodes
    call evaluateEncodedExpressionAtIX
    ld (varcRunEntryCallTarget+1),hl        ; patch RUN with the assembled entry address
    ld hl,varcRunEntDirectiveBalance+1      ; select the exact-one-ENT balance byte
    dec (hl)
    ret
.testEquOrgAndPutPseudoOpcodes:
    dec a
    ret z                                   ; leave EQU unchanged because pass one already assigned it
    dec a
    jp z,setOrgAddressAndOutputPointer      ; apply ORG semantics when selected
    dec a
    jr nz,.testDefbPseudoOpcode
    call evaluateEncodedExpressionAtIX
    jp setOutputPointerFromBC
.testDefbPseudoOpcode:
    dec a
    jr nz,.testDefmPseudoOpcode
.emitDefbExpressionsLoop:
    call evaluateEncodedExpressionAtIX
    jp c,validateAndEmitImmediateByte       ; emit the final DEFB item when the expression ended the record
    call validateAndEmitImmediateByte
    inc ix
    jr .emitDefbExpressionsLoop
.testDefmPseudoOpcode:
    dec a
    jr nz,.testDefsPseudoOpcode
.emitDefmCharactersLoop:
    call scanNextDefmCharacter              ; decode one logical string character and final-byte status
    jr nz,.emitFinalDefmCharacter            ; route the final string byte through delimiter-specific handling
    call emitByteAtAssemblyOutput
    jr .emitDefmCharactersLoop
.emitFinalDefmCharacter:
    ld a,e
    cp 027h
    jr nz,.emitCurrentDefmCharacter
    set 7,d                                 ; mark the last apostrophe-delimited byte with bit 7
.emitCurrentDefmCharacter:
    ld a,d
    jr emitByteAtAssemblyOutput

; Return the next logical character of a DEFM quoted string.
;
; IX advances through the encoded payload one byte at a time.  D receives the
; candidate character and E the following byte.  A doubled double quote inside
; a double-quoted string is collapsed to one literal quote by advancing once
; more.  The final BIT test returns Z for an ordinary character and NZ when the
; byte following E is the record's $C0+length terminator, meaning D is the last
; data character and E is the closing delimiter.
;
; The caller sets bit 7 only on the final character when that delimiter is an
; apostrophe, implementing the manual's extended DEFM 'text' form.
scanNextDefmCharacter:
    call advanceIXAndLoadSymbolReference    ; advance to the next encoded character and look ahead one byte
    bit 7,(ix+004h)
    ret nz                                  ; return final-character status without consuming beyond the record
    ld a,d
    cp 022h
    jr nz,.testDefmRecordEnd
    cp e
    call z,advanceIXAndLoadSymbolReference  ; collapse the doubled quote by advancing one extra encoded byte
.testDefmRecordEnd:
    bit 7,(ix+004h)
    ret
.testDefsPseudoOpcode:
    dec a
    jp z,advancePointersForDefsExpressions  ; reserve storage without emission when DEFS is selected
.emitDefwExpressionsLoop:
    call evaluateEncodedExpressionAtIX
    jp c,emitWordBCAtAssemblyOutput         ; emit the final word when the expression reaches record end
    call emitWordBCAtAssemblyOutput
    inc ix
    jr .emitDefwExpressionsLoop
; -----------------------------------------------------------------------------
; Emit or execute one compressed record during the second assembly pass
; -----------------------------------------------------------------------------
; B receives the record information byte.  DD+FD together ($30) identify the
; pseudo-instruction namespace; all other records are machine instructions.
;
; For ordinary instructions emitMachineInstructionBytes writes prefixes,
; opcode, and operand bytes.  DDCB/FDCB indexed rotate/bit records need the Z80
; byte order "DD/FD, CB, displacement, opcode".  The common emitter naturally
; produces "DD/FD, CB, opcode, displacement", so those two final bytes are
; swapped after emission.  This compact special case avoids a separate encoder.
secondPassEmitSourceRecord:
    ld b,(ix+001h)
    ld a,b
    and 030h                                ; isolate the DD/FD family bits
    cp 030h
    jr z,.executePseudoInstructionSecondPass ; execute pseudo semantics instead of emitting a machine opcode
    ld a,b
    and 0b0h                                ; retain DD/FD/CB family bits used by the indexed-CB special case
    cp 090h
    jr c,emitMachineInstructionBytes
    call emitMachineInstructionBytes        ; emit the indexed-CB instruction in the common order first
    ld hl,(varcAssemblyOutputPointer+1)     ; load the physical pointer just past the emitted instruction
    dec hl
    ld a,(hl)
    dec hl
    ld b,(hl)
    ld (hl),a
    inc hl
    ld (hl),b
    ret
; Emit prefix bytes, opcode, and the operand selected by information bits 2-0.
;
; Prefix emission order is DD, FD, CB, ED, followed by the stored opcode.  The
; valid table entries ensure only meaningful combinations occur.  The optional
; line-label ordinal is then skipped and operand class is dispatched:
;
;   0  no operand bytes
;   1  one byte, accepting 0..255 or 16-bit representations of -256..-1
;   2  little-endian word
;   3  signed relative displacement to absolute target
;   4  signed IX/IY displacement
;   5  signed IX/IY displacement followed by checked immediate byte
;   6  RST vector folded into the opcode; only 0,8,...,56 are valid
;
; Every actual byte is routed through emitByteAtAssemblyOutput, so logical
; address advancement and protected-memory checks are identical for prefixes,
; opcodes, immediates, and data pseudo-instructions.
emitMachineInstructionBytes:
    ld a,0ddh
    bit 5,b
    call nz,emitByteAtAssemblyOutput        ; emit DD only for IX-prefixed records
    ld a,0fdh
    bit 4,b
    call nz,emitByteAtAssemblyOutput        ; emit FD only for IY-prefixed records
    ld a,0cbh
    bit 7,b
    call nz,emitByteAtAssemblyOutput        ; emit CB only when requested by the information byte
    ld a,0edh
    bit 6,b
    call nz,emitByteAtAssemblyOutput        ; emit ED only when requested
    ld a,(ix+000h)
    call emitByteAtAssemblyOutput           ; emit the opcode after all selected prefixes
    call skipEncodedLineLabelIfPresent      ; position IX at the operand after any line-label ordinal
    ld a,b
    and 007h
    ret z                                   ; finish immediately when the instruction has no operand bytes
    dec a                                   ; normalize class 1 to dispatch index zero
    push af                                 ; preserve the class index across expression evaluation
    call evaluateEncodedExpressionAtIX
    pop af
    jr nz,.dispatchNonByteOperandClass       ; route classes 2 through 6 to their specialized encoders
; Validate PROMETHEUS's documented broad one-byte range.
;
; The evaluated value in BC is accepted only when B is $00 or $FF.  Therefore
; values 0..255 and -256..-1 (represented as $FF00..$FFFF) are accepted and the
; low byte C is emitted.  Any other high byte raises MESSAGE_BIG_NUMBER.
validateAndEmitImmediateByte:
    ld a,b
    inc a
    and 0feh                                ; mask the sign bit so every other high-byte pattern remains nonzero
    jr nz,.reportAssemblyBigNumber           ; reject values outside the documented broad one-byte range
    ld a,c
; Store one generated byte and advance both assembly pointers.
;
; Inputs:
;   A  byte to write
; State:
;   varcAssemblyOutputPointer  physical destination in RAM
;   varcAddressCounter         logical address represented by '$'
;
; The destination is legal only when it is either below the relocated resident
; PROMETHEUS image, or strictly above varcCodeEndPt (the current end of the
; resident image plus compressed source/symbol storage), and not above U-TOP.
; Thus generated code cannot overwrite PROMETHEUS, source text, the symbol
; table, or the user-protected upper region.  The test is performed for every
; byte, so crossing a boundary in the middle of an instruction is caught at the
; first illegal destination and reported as Bad PUT (ORG).
;
; On success A is written, the physical pointer increments, and the logical
; address counter increments independently.  ORG changes both pointers; PUT
; changes only the physical pointer.
emitByteAtAssemblyOutput:
    ld de,DISK_DRIVER_BASE            ; protect the driver as part of the resident image
varcAssemblyOutputPointer:
    ld hl,00000h
    and a
    sbc hl,de                               ; compute destination minus resident start and retain its boundary flags
    add hl,de
    ex de,hl
    jr c,varcUTop                           ; allow destinations below the resident image to continue at the U-TOP test
    ld hl,(varcCodeEndPt+1)                 ; load the moving end of resident source and symbol storage
    sbc hl,de
    jr nc,.reportBadPutOrOrgOutputAddress    ; reject destinations inside or immediately after occupied resident storage
varcUTop:
    ld hl,0ffffh
    and a
    sbc hl,de                               ; compute U-TOP minus destination
    jr c,.reportBadPutOrOrgOutputAddress     ; reject destinations above the configured ceiling
    ld (de),a
    inc de
    ld (varcAssemblyOutputPointer+1),de     ; persist the next output pointer in the self-modified operand
varcAddressCounter:
    ; logical address counter used by '$'; distinct from physical output pointer
    ld hl,00000h
    inc hl
    ld (varcAddressCounter+1),hl            ; persist the updated value used by the current-address symbol
    ret
.reportBadPutOrOrgOutputAddress:
    ld a,008h
    jr reportAssemblyErrorAtSourceRecord
.dispatchNonByteOperandClass:
    dec a
    jr nz,.testRelativeOperandClass
emitWordBCAtAssemblyOutput:
    ld a,c
    call emitByteAtAssemblyOutput
    ld a,b
    jr emitByteAtAssemblyOutput
; Compute an 8-bit relative displacement from an absolute expression target.
;
; At this point prefixes and opcode have already incremented the logical address
; counter.  The code adds one more for the displacement byte itself, computes
;
;     target - address_after_complete_instruction
;
; and accepts only -128..127.  The low byte is then emitted.  The same signed
; validator is reused for IX/IY displacements.
.testRelativeOperandClass:
    dec a
    jr nz,.testIndexedDisplacementOperandClass
    ld hl,(varcAddressCounter+1)            ; load the logical address after prefixes and opcode
    inc hl
    push bc                                 ; preserve the absolute target while exchanging register roles
    ex (sp),hl                              ; place the target on the stack and the completed PC in HL
    pop bc
    and a
    sbc hl,bc                               ; compute the signed relative displacement
; Accept HL only in the signed-byte ranges $0000..$007F or $FF80..$FFFF.
;
; Positive values with bit 7 set and all values with any other high byte are
; rejected as Big number.  The accepted low byte L is emitted through the common
; protected output routine.
.validateSignedByteInHLAndEmitL:
    ld a,l
    inc h
    jr z,.validateNegativeSignedByteL
    dec h
    jr nz,.reportAssemblyBigNumber           ; reject every positive value above $00FF
    cp 080h
    jr nc,.reportAssemblyBigNumber           ; report positive values outside the signed-byte range
.emitValidatedSignedByteL:
    jr emitByteAtAssemblyOutput
.validateNegativeSignedByteL:
    cp 080h
    jr nc,.emitValidatedSignedByteL          ; emit a valid negative displacement
.reportAssemblyBigNumber:
    ld a,003h
    jr reportAssemblyErrorAtSourceRecord
.testIndexedDisplacementOperandClass:
    dec a
    jr nz,.testIndexedDisplacementImmediateClass
validateAndEmitSignedBC:
    ld h,b                                  ; move the evaluated signed displacement high byte into HL
    ld l,c
    jr .validateSignedByteInHLAndEmitL
.testIndexedDisplacementImmediateClass:
    dec a
    jr nz,.foldRstVectorIntoEmittedOpcode
    call validateAndEmitSignedBC
    inc ix
    call evaluateEncodedExpressionAtIX
    jr validateAndEmitImmediateByte
; Validate and encode an RST vector.
;
; BC must be one of 0,8,16,24,32,40,48,56.  The instruction-table opcode is the
; base RST opcode; the vector value is added directly to the byte most recently
; emitted.  Invalid low bits, bit 6/7, or a nonzero high byte produce
; MESSAGE_BAD_INSTRUCTION rather than MESSAGE_BIG_NUMBER.
.foldRstVectorIntoEmittedOpcode:
    ld a,c
    and 0c7h
    or b
    ld a,006h
    jr nz,reportAssemblyErrorAtSourceRecord
    ld a,c
    ld hl,(varcAssemblyOutputPointer+1)     ; load the physical pointer after the already emitted base opcode
    dec hl
    add a,(hl)                              ; fold the vector bits into the base RST opcode
    ld (hl),a                               ; replace the emitted opcode with its final vector form
    ret


; -----------------------------------------------------------------------------
; First assembly pass: define labels and advance the logical address counter
; -----------------------------------------------------------------------------
; IX points at one compressed source record.  If information bit 3 is set, the
; line-label ordinal is resolved.  A vector already carrying DEFINED or LOCKED
; is an "Already defined" error; otherwise bit 6 is set and the current address
; counter is written into the symbol entry's first two bytes.
;
; Machine instructions advance the address counter by opcode/prefix/operand
; length without emitting bytes.  Pseudo-instructions are accounted specially:
; EQU evaluates now and overwrites the current line label's value, ORG changes
; both logical and output pointers, PUT changes only the output pointer, and
; DEFB/DEFM/DEFS/DEFW calculate their generated/storage lengths.
;
; This routine is installed only for pass one.  processCompilation patches the
; per-record call to the code-emitting second-pass routine afterwards.
firstPassProcessSourceRecord:
    bit 3,(ix+001h)
    jr z,.accountSourceRecordLength          ; skip directly to length accounting when no label is present
    call resolveRecordLabelAfterHeader
    ld (varcCurrentLineLabelEntry+1),de     ; remember the value/name entry for a possible EQU assignment
    ld a,(hl)
    and 0c0h
    jr z,.defineLineLabelAtCurrentAddress    ; define the label when neither state bit is set
    ld a,MESSAGE_ALREADY_DEFINED
reportAssemblyErrorAtSourceRecord:
    ld hl,00000h
    ld (varcSourceBufferActiveLine+1),hl    ; highlight that record in the editor after the error
    jp signalError
.defineLineLabelAtCurrentAddress:
    set 6,(hl)
    ld hl,(varcAddressCounter+1)            ; current logical assembly address
    ex de,hl                                ; move the value-entry pointer into HL while preserving the address in DE
    dec hl
    ld (hl),d
    dec hl
    ld (hl),e
.accountSourceRecordLength:
    ld a,(ix+001h)
    and 030h                                ; isolate DD/FD versus pseudo namespace bits
    cp 030h
    jr z,.accountPseudoInstructionLength     ; use directive-specific pass-one semantics for pseudo records
    ld a,(ix+001h)
    and 007h
    ld c,a                                  ; retain the class as a table index
    ld b,000h                               ; zero-extend that index
    ld hl,operandClassLengthAdjustments
    add hl,bc
    ld a,(hl)                               ; load the operand contribution encoded by table bytes/opcodes
    inc a
    ld bc,00400h
    ld d,(ix+001h)
.countInstructionPrefixBytesLoop:
    rl d
    adc a,c
    djnz .countInstructionPrefixBytesLoop
    jr .addRecordLengthToAddressCounter
operandClassLengthAdjustments:
    nop                                     ; encode zero additional bytes for classes 0 and 3 via NOP opcode value
    ld bc,00102h                            ; encode class-1/class-2 adjustments in the immediate bytes of LD BC
    ld bc,00002h                            ; encode class-4/class-5/class-6 adjustments in the next table bytes
    nop
skipEncodedLineLabelIfPresent:
    bit 3,(ix+001h)
    ret z                                   ; leave IX unchanged when no label ordinal is present
    inc ix
    inc ix
    ret
.accountPseudoInstructionLength:
    ld a,(ix+000h)
    call skipEncodedLineLabelIfPresent      ; position IX at directive operands after an optional line label
    sub 003h                                ; normalize EQU to dispatch case zero
    ret c                                   ; ignore empty, comment, and ENT during first-pass length handling
    jr nz,.handlePseudoInstructionLengthCase
    call evaluateEncodedExpressionAtIX
varcCurrentLineLabelEntry:
    ld hl,00000h
    dec hl
    ld (hl),b
    dec hl
    ld (hl),c
    ret
.handlePseudoInstructionLengthCase:
    dec a
    jr nz,.accountRemainingPseudoInstructionCases
setOrgAddressAndOutputPointer:
    call evaluateEncodedExpressionAtIX
    ld (varcAddressCounter+1),bc            ; replace the logical address counter with the ORG value
setOutputPointerFromBC:
    ld (varcAssemblyOutputPointer+1),bc     ; replace the physical output pointer with the PUT/ORG value
    ret
.accountRemainingPseudoInstructionCases:
    dec a
    ret z
    dec a
    jr nz,.countDefmOutputBytes
    call countCommaSeparatedDefinitionItems ; count the encoded DEFB list items
    ld a,c
    jr .addRecordLengthToAddressCounter
.countDefmOutputBytes:
    dec a
    jr nz,.accountDefsStorage
    ld c,a
.countDefmCharactersLoop:
    inc c
    call scanNextDefmCharacter              ; decode it using the same escaped-quote rules as pass two
    jr z,.countDefmCharactersLoop            ; continue until the decoder marks the final character
    ld a,c
    jr .addRecordLengthToAddressCounter
.accountDefsStorage:
    dec a
    jr nz,.accountDefwItems
; Implement DEFS by advancing logical and physical pointers without writing.
;
; Each encoded expression is evaluated and added to both varcAddressCounter and
; varcAssemblyOutputPointer.  Comma-separated values are accepted by the shared
; encoded-expression loop even though the manual documents the usual one-value
; form.  Because no byte is written here, protected-memory validation is deferred
; until a later instruction or data directive actually emits at the new PUT/ORG
; destination.
advancePointersForDefsExpressions:
    call evaluateEncodedExpressionAtIX
    push af                                 ; preserve the expression terminator flags across pointer updates
    ld hl,varcAddressCounter+1              ; select the logical address storage operand
    call increaseAtHLbyBC
    ld hl,varcAssemblyOutputPointer+1       ; select the physical output-pointer storage operand
    call increaseAtHLbyBC
    pop af
    inc ix
    jr nc,advancePointersForDefsExpressions ; continue while the expression evaluator did not reach record end
    ret
.accountDefwItems:
    call countCommaSeparatedDefinitionItems ; count encoded DEFW list items
    ld a,c
    add a,c                                 ; convert words to generated bytes
.addRecordLengthToAddressCounter:
    ld b,000h                               ; zero-extend the generated byte count
    ld c,a
    ld hl,varcAddressCounter+1              ; select the logical address counter storage
    jp increaseAtHLbyBC

countCommaSeparatedDefinitionItems:
    ld c,001h                               ; seed the item count with the mandatory first definition value
.scanDefinitionItemLoop:
    ld a,(ix+002h)                          ; inspect the next encoded definition byte
    cp 02ch
    jr nz,.testQuotedDefinitionItem
    inc c
    jr .advanceDefinitionItemScanner
.testQuotedDefinitionItem:
    cp 022h
    jr nz,.finishDefinitionItemCount         ; finish or process symbol/literal bytes when not quoted
.skipQuotedDefinitionStringLoop:
    inc ix
    ld a,(ix+002h)
    cp 022h
    jr nz,.skipQuotedDefinitionStringLoop    ; ignore all embedded bytes until the quote closes
.advanceDefinitionItemScanner:
    inc ix
    jr .scanDefinitionItemLoop
.finishDefinitionItemCount:
    cp 0c0h
    ret nc
    cp 080h
    jr c,.advanceDefinitionItemScanner
    inc ix                                  ; skip the second byte of an encoded symbol ordinal
    jr .advanceDefinitionItemScanner
; -----------------------------------------------------------------------------
; Evaluate an expression directly from a compressed source record
; -----------------------------------------------------------------------------
; IX remains based on the record header; expression bytes are read at IX+2.
; Literal characters are ASCII, while $80-$BF introduces a two-byte symbol
; ordinal.  A referenced symbol is accepted when either DEFINED or LOCKED is
; set; otherwise MESSAGE_UNKNOWN identifies the unresolved symbol.
;
; Evaluation is strictly left-to-right.  Supported operators are +, -, *, /,
; and ? (remainder).  A leading '-' negates an atom before the previous binary
; operator is applied.  The result is returned in BC, matching the first-pass
; length/directive callers.
evaluateEncodedExpressionAtIX:
    ld hl,00000h
    ld a,02bh
.evaluateEncodedExpressionLoop:
    push hl                                 ; save the accumulated value while decoding the next atom
    push af
    ld a,(ix+002h)                          ; peek at the atom’s first encoded byte
    push af                                 ; save that byte as the possible unary sign
    cp 02dh
    jr nz,.evaluateEncodedExpressionAtom     ; decode the atom directly when no unary minus is present
    inc ix
.evaluateEncodedExpressionAtom:
    ld a,(ix+002h)                          ; load the atom’s first encoded byte
    cp 024h
    ld de,(varcAddressCounter+1)            ; prepare the current logical address as the candidate atom value
    jr z,.advancePastEncodedExpressionAtom
    cp 080h
    jp c,.parseNumericOrQuotedConstantAtIX
    ld d,a
    ld e,(ix+003h)
    inc ix
    call resolveSymbolReferenceToName       ; resolve the ordinal through the current symbol table
    ld a,(hl)
    and 0c0h
    jr nz,.loadDefinedSymbolValue
    ld (varcUnknownSymbolNameAddress+1),de  ; patch the Unknown diagnostic with this symbol’s spelling
    ld a,009h
    jp reportAssemblyErrorAtSourceRecord
.loadDefinedSymbolValue:
    dec de
    ex de,hl
    ld d,(hl)
    dec hl
    ld e,(hl)
.advancePastEncodedExpressionAtom:
    inc ix
    jr .applyUnarySignAndPreviousOperator
readEncodedExpressionOperatorOrEnd:
    ld a,(ix+002h)
    xor 02ch
    ld b,h
    ld c,l
    ret z
    xor 033h
    ret z                                   ; return at the encoded record terminator
    cp 0c0h
    ccf                                     ; invert carry to the evaluator’s end/non-end convention
    ret c                                   ; return when the marker ended this expression
    xor 01fh
    inc ix
    jp .evaluateEncodedExpressionLoop
.parseQuotedCharacterConstant:
    ld de,00000h
    inc ix
    call readQuotedConstantByte
    jr c,.prepareQuotedConstantValue
    ld e,a
    call readQuotedConstantByte
    jr c,.prepareQuotedConstantValue         ; finish a two-byte constant when the quote closes
    ld d,e
    ld e,a
    inc ix
.prepareQuotedConstantValue:
    ex de,hl                                ; normalize the quoted value through the common HL/DE exchange
.returnLiteralValueInDE:
    ex de,hl
.applyUnarySignAndPreviousOperator:
    pop af                                  ; recover the saved unary-sign character
    call negateDEIfOperatorIsMinus
    pop af
    pop hl
    ld bc,readEncodedExpressionOperatorOrEnd
    push bc                                 ; route operator execution back through that continuation
; Apply the operator in A to 16-bit operands HL and DE.
;
;   '+'  HL := HL + DE
;   '-'  HL := HL - DE
;   '*'  HL := low 16 bits of HL * DE
;   '/'  HL := unsigned HL / DE
;   '?'  HL := unsigned HL modulo DE
;
; divideHLByDE is a sixteen-step restoring divider.  With DE=0, every trial
; subtraction succeeds and the quotient becomes $FFFF, reproducing the manual's
; explicitly documented division-by-zero result rather than raising an error.
applyExpressionOperatorToHLAndDE:
    cp 02bh
    jr z,.addExpressionOperands
    cp 02dh
    jr z,.subtractExpressionOperands
    cp 02ah
    jr z,multiplyHLByDE
    cp 02fh
    jr z,.returnDivisionQuotient
divideHLByDE:
    ld a,h
    ld c,l
    ld hl,00000h
    ld b,010h
.unsignedDivideLoop:
    sli c
    rla
    adc hl,hl
    sbc hl,de
    jr nc,.unsignedDivideKeepBit             ; keep the quotient bit when the trial remainder stayed nonnegative
    add hl,de
    dec c
.unsignedDivideKeepBit:
    djnz .unsignedDivideLoop
    ret
.returnDivisionQuotient:
    call divideHLByDE
    ld h,a
    ld l,c
    ret
multiplyHLByDE:
    ld b,010h
    ld a,h
    ld c,l
    ld hl,00000h
.unsignedMultiplyLoop:
    add hl,hl
    rl c
    rla
    jr nc,.unsignedMultiplySkipAdd           ; skip addition when this multiplier bit is zero
    add hl,de
.unsignedMultiplySkipAdd:
    djnz .unsignedMultiplyLoop
    ret
.addExpressionOperands:
    add hl,de
    ret
.subtractExpressionOperands:
    or a
    sbc hl,de
negateDEIfOperatorIsMinus:
    cp 02dh                                 ; test whether the saved sign/operator byte is minus
    ret nz
    ld a,d
    cpl
    ld d,a
    ld a,e
    cpl
    ld e,a
    inc de
    ret
.parseNumericOrQuotedConstantAtIX:
    ld a,(ix+002h)
    cp 022h
    jr z,.parseQuotedCharacterConstant       ; use quoted-byte decoding for that form
    ld c,00ah                               ; default unprefixed numbers to decimal radix
    cp 025h
    jr nz,.testHexadecimalPrefix
    inc ix
    ld c,002h
.testHexadecimalPrefix:
    cp 023h
    jr nz,.initializeRadixAccumulator        ; begin digit accumulation when it is absent
    inc ix
    ld c,010h
.initializeRadixAccumulator:
    ld hl,00000h
.parseRadixDigitsLoop:
    ld a,(ix+002h)
    sub 030h                                ; convert ASCII 0–9 to its numeric value
    cp 00ah
    jr c,.validateRadixDigit
    sub 007h                                ; map uppercase A–F to values 10–15
    cp 00ah
    jp c,.returnLiteralValueInDE             ; finish the literal when this byte is not a digit
.validateRadixDigit:
    cp c
    jp nc,.returnLiteralValueInDE
    push af
    ld a,c
    dec a                                   ; convert radix to the required extra-add count
    ld d,h
    ld e,l
.multiplyAccumulatorByRadixLoop:
    add hl,de                               ; add one old accumulator to form accumulator × radix
    dec a
    jr nz,.multiplyAccumulatorByRadixLoop    ; complete the radix scaling
    pop af
    ld d,000h                               ; zero-extend the digit value
    ld e,a
    add hl,de                               ; append the digit to the scaled accumulator
    inc ix
    jr .parseRadixDigitsLoop
readQuotedConstantByte:
    ld a,(ix+002h)
    cp 022h
    jr nz,.acceptQuotedConstantByte
    cp (ix+003h)
    inc ix
    jr z,.acceptQuotedConstantByte
    scf                                     ; mark a single quote as the closing delimiter
    ret
.acceptQuotedConstantByte:
    inc ix
    or a
    ret


; Shared wrapper around Spectrum ROM LD-BYTES ($0562).
;
; Caller supplies IX=destination/comparison address, DE=length, A=expected block
; flag, and carry state (set=LOAD, clear=VERIFY).  The alternate accumulator is
; arranged as required by the ROM, interrupts are disabled, and the tape border/
; MIC state is selected.  Carry returned by ROM is preserved unless SPACE is
; currently pressed, in which case control jumps to the dynamically configurable
; command-abort entry.
callRomTapeLoadOrVerify:
    inc d                                   ; derive the ROM-required alternate flag state from D+1 while preserving caller carry
    ; Transfer expected flag and LOAD/VERIFY carry into AF', where ROM LD-BYTES expects them on entry.
    ex af,af'
    dec d
    di                                      ; disable interrupts as required while ROM tape code owns timing
    ld a,00fh
    out (0feh),a                            ; drive port $FE before entering ROM LD-BYTES
    call ROM_LoadBytes_562
; Preserve AF/carry and abort only when the SPACE key is held.
;
; Keyboard row $7F contains SPACE in bit 0.  If it is not pressed, the original
; AF—including ROM tape success carry—is restored.  The helper is also used by
; PRINT and import progress polling, so its target is patched when the monitor
; temporarily owns the shared error machinery.
abortCurrentOperationIfSpacePressed:
    push af                                 ; preserve ROM carry and flags across the SPACE keyboard poll
    ld a,07fh
    in a,(0feh)                             ; sample SPACE from the active-low Spectrum keyboard matrix
    rra                                     ; rotate the SPACE bit into carry
    jp nc,abortCommandAndReturnToEditor     ; abort to the editor when SPACE is pressed
    pop af
    ret


invokeMonitor:
    ; check if the compilation is requested
    ld b,"a"
    call containsInputBufferCharacterInB
    call z,processCompilation               ; compile the current source only when parameter A was present
    call clearDisplayToSpaces               ; clear the editor bitmap to spaces before monitor front-panel drawing
assemblerOnlyMonitorFallbackOpcode:
    defb 0c3h                               ; encode JP so its operand can be named for installer patching
assemblerOnlyMonitorFallbackAddress:
    defw startMonitor


invokeQuit:
    ld b,"y"
    call containsInputBufferCharacterInB
    ret nz
    rst 0                                   ; restart the machine through ROM reset only after explicit Y confirmation


; Scan tape until a valid Spectrum CODE header is read.
;
; Headers are loaded into the 17-byte workspace at BOTTOM_LINE_VRAM_ADDRESS.
; Failed reads and non-CODE types are skipped.  For every CODE header, display
; MESSAGE_FOUND and its ten-character name, replacing non-printable bytes with
; '?'.  Filename acceptance is performed separately so callers may continue
; scanning for a requested name.
scanTapeForNextCodeHeader:
    ld ix,BOTTOM_LINE_VRAM_ADDRESS
    ld de,00011h                            ; request the exact Spectrum header payload length
    xor a
    scf
    call callRomTapeLoadOrVerify
    jr nc,scanTapeForNextCodeHeader         ; ignore tape failures/non-header blocks and continue scanning
    ld a,MESSAGE_FOUND
    call signalMessage
    ld hl,BOTTOM_LINE_VRAM_ADDRESS+1
    ld b,00ah
.displayLoadedHeaderNameLoop:
    ld a,(hl)
    cp " "
    jr c,.replaceInvalidHeaderNameCharacter  ; replace such control bytes before display
    cp 080h
    jr c,.displayLoadedHeaderNameCharacter
.replaceInvalidHeaderNameCharacter:
    ld a,"?"
.displayLoadedHeaderNameCharacter:
    call displayCharacterSafely
    inc hl
    djnz .displayLoadedHeaderNameLoop
    ld a,(BOTTOM_LINE_VRAM_ADDRESS)
    cp 003h
    jr nz,scanTapeForNextCodeHeader
    ret


; Accept the loaded header for wildcard or exact-name LOAD.
;
; The manual describes a name made entirely of spaces as wildcard.  The actual
; code repeatedly tests only fileNameBuffer[0] (HL is intentionally/notably not
; incremented), so the precise implementation is broader: any requested name
; whose first character is a space is accepted as wildcard.  Otherwise execution
; falls through to the exact ten-byte comparison.  This discrepancy is preserved
; and documented, not corrected.
acceptLoadedHeaderIfNameMatchesOrWildcard:
    ld b,MAX_FILE_NAME_LENGTH
    ld hl,fileNameBuffer
.testWildcardNameFirstCharacterLoop:
    ld a,(hl)
    cp " "
    jr nz,.compareRequestedNameWithLoadedHeader ; fall through to exact comparison when the first byte is non-space
    djnz .testWildcardNameFirstCharacterLoop
    ret
.compareRequestedNameWithLoadedHeader:
compareRequestedNameWithLoadedHeaderExact:
    ld b,MAX_FILE_NAME_LENGTH
    ld hl,fileNameBuffer
    ld de,BOTTOM_LINE_VRAM_ADDRESS+1
.compareLoadedHeaderNameLoop:
    ld a,(de)
    cp (hl)
    inc hl
    inc de
    ret nz                                  ; return mismatch immediately when any byte differs
    djnz .compareLoadedHeaderNameLoop
    ret


containsInputBufferCharacterB:
    ; Test whether the input line contains optional parameter B, accepting either ASCII case.
    ld b,042h
containsInputBufferCharacterInB:
    ld hl,inputBufferStart+1
; Read one logical character from the shared input line and advance HL.
;
; atHLorNextIfOne skips the movable $01 cursor marker when it occupies the
; current position.  This wrapper then increments HL once past the returned
; character.  FIND uses it while parsing optional `s`, `b`, and `:` prefixes;
; SAVE uses the same contract to inspect a delimiter following optional `b`.
readInputCharacterSkippingCursorAndAdvance:
    call atHLorNextIfOne                    ; read the current logical input character while skipping a movable cursor marker
    inc hl
compareWithCharacterInB:
    ; Compare A with uppercase B first, then with B folded to lowercase.
    ; Return Z for either spelling; B is intentionally modified by the fold.
    cp b                                    ; accept an exact match before applying ASCII case folding
    ret z                                   ; return immediately when the input already matches the requested character
    set 5,b                                 ; convert the requested uppercase character in B to its lowercase ASCII form
    cp b
    ret


; Toggle decimal/hexadecimal rendering for status values and symbol-table
; output.  The manual binds this immediate action to SYMBOL SHIFT+H.
invokeToggleNumberBase:
    ld hl,varcHexMode+1                     ; select the self-modified radix-mode byte
    jr invertLogicAtHLAndRet


; Toggle editor insertion mode.  Stored value 0 means INSERT; 1 means
; OVERWRITE.  EDIT forces OVERWRITE temporarily, while normal submission resets
; the mode to INSERT through restoreInsertModeAndContinue.
invokeToggleInsertOverwrite:
    ; swaps the insert mode
    ; 0 - insert mode
    ; 1 - overwrite mode
    ld hl,varcInsertMode+1                  ; select the self-modified INSERT/OVERWRITE mode byte
invertLogicAtHLAndRet:
    ; inverts logical value at address given by HL
    ld a,(hl)
    xor 001h
    ld (hl),a
    ret


invokeBasic:
    ld iy,05c3ah
    im 1                                    ; restore Spectrum interrupt mode 1
    ei                                      ; re-enable normal ROM interrupt handling
    ld sp,(SYSVAR_ERR_SP)
    jp ROM_StatementReturn


; Convert the text-row Y coordinate in A to a Spectrum bitmap address and copy
; one complete 32-character, eight-pixel-high row to DE.  This is the fast
; scrolling primitive used while an arrow key remains held.
copyScreenTextRowAtYToDE:
    push af                                 ; preserve the text-row coordinate across the ROM address calculation
    ld c,000h                               ; request the first pixel column of the selected text row
    call ROM_PixelAddress_22b0              ; translate the text-row coordinate to Spectrum bitmap memory
    push hl                                 ; preserve the translated source bitmap-row address
    call copyEightBitmapRows
    pop de
    pop af
    ret


writeLineOfCodeAndTestKeyboard:
    push hl
    pop ix
    call renderSourceRecord
    ; read keyboard
    ld a,0efh
    in a,(0feh)                             ; sample that row directly for autorepeat
    ret


; Compute the preceding compressed source record and commit it only when it is
; not before sourceBufferAccessLine.  The caller's return address is temporarily
; removed so an invalid move can jump directly to redraw without corrupting SP.
moveActiveLineToPreviousSourceRecord:
    call getRecordBeforeActiveLine
    call compareHLWithSourceBufferStart
    ccf                                     ; invert the comparison carry to match the common commit convention
    jr .commitActiveLineMoveIfValid
; Compute the following compressed source record and commit it only when it is
; still inside the source region.
moveActiveLineToNextSourceRecord:
    call getRecordAfterActiveLine
    call comparePositionWithCodeEnd
.commitActiveLineMoveIfValid:
    pop de                                  ; remove the caller return address before a possible redraw jump
    ; do not move if the position would move behind the code end
    jr nc,prometheusWarmStartWithCurrentBuffers ; redraw without committing when navigation crossed a boundary
    push de                                 ; restore the caller return address for a valid move
    ; else move the position
    ld (varcSourceBufferActiveLine+1),hl    ; commit the bounded source-record pointer
    ret


copyEightBitmapRows:
    push hl
    push de
    ld b,008h
.copyNextBitmapRow:
    push hl
    push de
    ld c,020h
.copyNextByteInBitmapRow:
    ld a,(hl)
    ld (de),a
    inc l
    inc e
    dec c
    jr nz,.copyNextByteInBitmapRow
    pop de
    pop hl
    inc h
    inc d
    djnz .copyNextBitmapRow
    pop de
    pop hl
    ret


; Append A to the reconstructed replacement line at DE and decrement remaining
; capacity C.  If the 31-character buffer is exhausted, abandon the operation
; via the normal warm start rather than writing beyond inputBufferStart.
appendReplacementCharacterOrAbort:
    ld (de),a
    inc de
    dec c
    ret nz
    jr prometheusWarmStart
clearDisplayToSpaces:
    ld e,020h
clearDisplay:
    ld bc,00003h
.clearDisplayCharacterLoop:
    ld a,e
    call displayNormalCharacter
    djnz .clearDisplayCharacterLoop
    dec c
    jr nz,.clearDisplayCharacterLoop         ; clear the complete display bitmap
    ret


; RUN command: compile, require exactly one ENT, then call generated code.
;
; varcRunEntDirectiveBalance starts at 1.  Every pass-two ENT decrements it and
; stores its evaluated address in the operand of varcRunEntryCallTarget.  The
; balance is zero only when exactly one ENT was encountered; zero ENT leaves 1,
; while two or more underflow to a nonzero value.  Either case reports "ENT ?".
;
; A valid target is called with interrupts still disabled, as documented.  If
; the generated program returns normally, execution resumes at
; returnFromCompiledProgram and waits for the editor's next key event.
invokeRun:
    ld a,001h
    ld (varcRunEntDirectiveBalance+1),a     ; initialize the pass-two ENT balance
    call processCompilation                 ; assemble the current source before execution
varcRunEntDirectiveBalance:
    ld a,000h
    or a
    ld a,MESSAGE_ENT
    jp nz,signalError                       ; reject zero or multiple entry directives
    call clearDisplayToSpaces               ; clear the editor display before running user code
varcRunEntryCallTarget:
    call 00000h                             ; call the entry address patched by the ENT directive
returnFromCompiledProgram:
    call processKey                         ; wait for a key after the generated program returns

; =====================================================================
; ASSEMBLER/EDITOR MAIN ENTRY AND WARM-START LOOP
; =====================================================================
;
; startPrometheus is used after installation and when leaving the monitor.  It
; disables interrupts, clears the display through the internal renderer, and
; enters the editor warm start.  The warm-start variants preserve progressively
; more state: message, buffers, and active source pointer.
; =====================================================================
startPrometheus:
    di                                      ; keep resident initialization and editor execution non-interruptible
    ld e,SEPARATOR_CHARCODE
    call clearDisplay                       ; initialize the complete display through the internal renderer
prometheusWarmStart:
    ; fill the access line with the highlight color
    ld hl,ACCESS_LINE_ATTRIBUTE_ADDRESS
configurationPatchTarget12WarmStartAccessLineAttribute: equ $+1 ; @config-patch 12
    ld bc,02000h+HIGHLIGHT_COLOR
    call atHLrepeatBTimesC                  ; mark the active input row before any redraw
    ld a,MESSAGE_COPYRIGHT
prometheusWarmStartWithMessage:
    call printStatusBar
    ; clean all buffers
    ld hl,lineBuffer
    ld bc,(l9478-1-lineBuffer)*256          ; encode the buffer length and zero fill byte for the shared filler
    call atHLrepeatBTimesC                  ; clear line, input, operand and formatting workspaces
    ld hl,inputBufferStart
    ; reinitialize input buffer
    ld (hl),001h                            ; restore the single movable cursor marker
    ; reinitialize inputBufferGuardByte
    dec hl
    ld (hl),080h
prometheusWarmStartWithCurrentBuffers:
    ; reinitialize stack
    ld sp,internalStackTop
    call renderVisibleSourceRecords
; Main interactive editor loop: repaint the edit line, restore border colour,
; read one normalized key, refresh the status bar, then dispatch immediate
; editor controls or update the edit buffer.
.readInputLineLoop:
    call repaintEditLine
    call setBorderColor
    call processKey
    push af                                 ; preserve the key while refreshing status
varcLastStatusBarMessage:
    ld a,MESSAGE_COPYRIGHT
    call printStatusBar                     ; redraw the status bar after key input
    ld a,MESSAGE_COPYRIGHT
    ld (varcLastStatusBarMessage+1),a       ; persist that default in the self-modified operand
    pop af
    ; SS + Q - clear the edit line
    cp 015h
    jr z,prometheusWarmStart                ; discard current input through a full warm start
    ; CS + 1 - Edit key
    cp 004h
    jr nz,.checkToggleInsertOverwriteKey
    ; Edit
    ; fill the input buffer from the active line
    ld ix,(varcSourceBufferActiveLine+1)    ; select the active compressed source record
    ld hl,inputBufferStart
    push hl
    ; clear input buffer
    ld bc,02000h
    call atHLrepeatBTimesC
    pop hl
    call expandSourceRecordToHL
    ld a,001h
    ld (varcInsertMode+1),a                 ; ensure the submitted edit replaces rather than inserts
    jr .refreshAfterImmediateEditorCommand
.checkToggleInsertOverwriteKey:
    ; SS + W - switch insert/overwrite
    cp 014h                                 ; recognize the INSERT/OVERWRITE toggle shortcut
    jr nz,.checkPageAndLineNavigationKeys
    call invokeToggleInsertOverwrite
.refreshAfterImmediateEditorCommand:
    ld a,MESSAGE_COPYRIGHT
    call printStatusBar
    jr prometheusWarmStartWithCurrentBuffers
; Navigation dispatch.  PROMETHEUS accelerates held arrow keys by shifting the
; existing bitmap rows and drawing only the newly exposed source line instead
; of repainting the entire 16-line source window.
.checkPageAndLineNavigationKeys:
    ld b,014h                               ; move twenty source records for one page command
    ; CS + 3 (TRUE VIDEO) - advance one displayed page
    cp 006h
    jr nz,.checkNextLineKey
.nextPageAdvanceLoop:
    call moveActiveLineToNextSourceRecord
    djnz .nextPageAdvanceLoop
.refreshAfterNavigation:
    jr prometheusWarmStartWithCurrentBuffers
.checkNextLineKey:
    ; CS + 6 (down arrow) - move to the next compressed source record
    cp 009h
    jr nz,.checkPreviousPageKey
.repeatNextLineWhileKeyHeld:
    call moveActiveLineToNextSourceRecord
    ld de,04040h
    ld a,018h                               ; start with the source row below the header
.scrollDisplayForNextLineLoop:
    call copyScreenTextRowAtYToDE
    add a,008h
    cp 0a9h
    jr c,.scrollDisplayForNextLineLoop
    ld hl,050a0h
    call clearLineAtHL                      ; erase stale pixels before drawing the new line
    ld b,006h                               ; walk six records below the active line for the bottom window row
    ld hl,(varcSourceBufferActiveLine+1)    ; start that walk at the active compressed record
.locateNewBottomVisibleLineLoop:
    call getNextSourceRecord
    djnz .locateNewBottomVisibleLineLoop
    call writeLineOfCodeAndTestKeyboard
    ; test key "6", DOWN, see http://www.breakintoprogram.co.uk/computers/zx-spectrum/keyboard
    bit 4,a
    jr z,.repeatNextLineWhileKeyHeld
.repeatInputLineLoop:
    jr .readInputLineLoop
.checkPreviousPageKey:
    ; CS + 4 (INVERSE VIDEO) - retreat one displayed page
    cp 007h
    jr nz,.checkPreviousLineKey
.previousPageRetreatLoop:
    call moveActiveLineToPreviousSourceRecord
    djnz .previousPageRetreatLoop
.refreshAfterPreviousNavigation:
    jr .refreshAfterNavigation
.checkPreviousLineKey:
    ; CS + 7 (up arrow) - move to the previous compressed source record
    cp 00ah
    jr nz,.checkDeleteActiveLineKey
.repeatPreviousLineWhileKeyHeld:
    call moveActiveLineToPreviousSourceRecord
    ld de,050a0h
    ld a,0a0h                               ; start with the last visible source row
.scrollDisplayForPreviousLineLoop:
    call copyScreenTextRowAtYToDE
    sub 008h
    cp 010h
    jr nc,.scrollDisplayForPreviousLineLoop
    ld hl,04040h
    call clearLineAtHL                      ; erase stale pixels before drawing the new line
    ld b,00dh                               ; walk thirteen records above the active line for the top window row
    ld hl,(varcSourceBufferActiveLine+1)    ; start that walk at the active compressed record
.locateNewTopVisibleLineLoop:
    call getPreviousSourceRecord
    djnz .locateNewTopVisibleLineLoop
    call writeLineOfCodeAndTestKeyboard
    ; test key "7", UP, see http://www.breakintoprogram.co.uk/computers/zx-spectrum/keyboard
    bit 3,a
    jr z,.repeatPreviousLineWhileKeyHeld
.repeatInputLineLoopFar:
    jr .repeatInputLineLoop
.checkDeleteActiveLineKey:
    ; CS + 9 - clear current line and return one line back
    cp 00ch
    jr nz,.checkSetBlockBoundaryKey
    ld bc,00001h                            ; delete exactly one compressed record
    ld hl,(varcSourceBufferActiveLine+1)    ; select the active record as the deletion start
    call deleteSourceLinesAndRestoreTailPadding
    call compareHLWithSourceBufferStart
    jr z,.refreshAfterPreviousNavigation     ; keep the first record selected when deletion occurred there
    call nc,getPreviousSourceRecord         ; otherwise step back to the preceding surviving record
    ld (varcSourceBufferActiveLine+1),hl    ; make that survivor the active line
.refreshAfterLineOrBlockChange:
    jr .refreshAfterPreviousNavigation
.checkSetBlockBoundaryKey:
    ; CS + SS - set block margin
    cp 00eh
    jr nz,.processInputLineKeyOrCommand      ; send other keys to edit-buffer mutation
    ld hl,(varcSelectedBlockEnd+1)          ; move the previous upper boundary into the lower boundary
    ld (varcSelectedBlockStart+1),hl        ; persist the shifted block start
    ld hl,(varcSourceBufferActiveLine+1)    ; select the current active record as the new upper boundary
    ld (varcSelectedBlockEnd+1),hl          ; persist the new block end
    jr .refreshAfterLineOrBlockChange
.processInputLineKeyOrCommand:
    call updateInputBuffer
    jr nz,.repeatInputLineLoopFar            ; return to input when no complete line was submitted
; Hide the edit-line attributes, inspect the first input token, and choose:
;
;   token >= $80  -> dispatch an A-Z command through commandHandlerTable
;   token <  $80  -> parse, compress, and insert/overwrite a source line
;
; Before command dispatch, the normal warm-start address is pushed as a return
; target, so handlers that simply RET redraw the editor automatically.
submitInputLineOrDispatchCommand:
    ld hl,LEFT_BOTTOM_ATTRIBUTE_ADDRESS
    ; color for hiding of the edit line (0x3f)
    ;   - ink color replaced by the paper color
configurationPatchTarget09HiddenEditLineAttribute: equ $+1 ; @config-patch 09
    ld bc,0203fh
    call atHLrepeatBTimesC                  ; blank the visible edit row before parsing
    ld hl,inputBufferStart
    call atHLorNextIfOne
    ld d,000h                               ; zero-extend command tokens for table indexing
    ld c,009h                               ; retain the source parser's default field width
    cp 080h
    jr c,parseAndInsertSourceLine           ; send non-command text to the source encoder
    ld hl,prometheusWarmStart
    ld (varcPostCommandContinuationJump+1),hl ; restore that target before invoking any handler
    push hl
    ld h,d                                  ; clear the high byte of the token-derived index
    ld l,a
    ; a=0xc1 for Assembly, 0xc2 for Basic etc.
    ld de,commandHandlerTable-(0xc1*2)      ; bias the table base so token $C1 indexes entry zero
    add hl,hl                               ; convert the token to a two-byte handler offset
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    jp (hl)
parseAndInsertSourceLine:
    call encodeInputLineToSourceRecord      ; encode the submitted source line into compressed form
    call getRecordAfterActiveLine           ; insert after the current active record
    push hl
    ld (varcInsertionPointForPointerAdjustment+1),hl ; make moving-pointer adjustment use this insertion boundary
    ld de,encodedRecordStorageLength
    ld a,(de)
    ld c,a
    inc de
    call insertByteRangeAtHLFromDE          ; open a gap and copy the encoded record into source memory
    pop hl
    ld (varcSourceBufferActiveLine+1),hl    ; make the new record active
varcInsertMode:
    ; 0 - insert, 1 - overwrite
    ld a,000h
    or a
    jr z,.finishSourceLineInsertion
    call getRecordBeforeActiveLine
    ld (varcSourceBufferActiveLine+1),hl    ; make that old record the active deletion target
    ld bc,00001h                            ; delete exactly one old compressed record
    call deleteSourceLinesAtHL
.finishSourceLineInsertion:
    ld a,MESSAGE_COPYRIGHT
    ld (varcLastStatusBarMessage+1),a       ; persist it for the next editor cycle
restoreInsertModeAndContinue:
    xor a
    ld (varcInsertMode+1),a                 ; commit the default mode after every submission
; Self-modifying command completion hook.  Normally this JP targets
; prometheusWarmStart.  Tape insertion and REPLACE temporarily redirect it to a
; continuation, then restore the normal target before returning to the editor.
varcPostCommandContinuationJump:
    jp prometheusWarmStart


; =============================================================================
; EDIT-LINE BUFFER MUTATION
; =============================================================================
; The edit line is a zero-terminated byte string containing one movable $01
; cursor marker.  varcInputBufferPosition points at that marker after every
; repaint.  Cursor-left/right exchange the marker with its neighbour; DELETE
; removes the byte immediately before it and shifts the remaining tail left.
;
; Printable insertion uses an in-place byte-swap chain: the new character is
; exchanged with the marker and then with every following byte until the old
; terminating zero has been moved one position right.  This avoids a separate
; memmove and preserves tokenized command bytes already present in the line.
;
; SPACE invokes the editor's automatic source-field tabulation when the line is
; neither a comment nor an expanded command token.  It pads to character offset
; 9 (mnemonic field) or 14 (operand field), matching the manual's 9/5/rest
; layout.  varcInputColumnAfterCursor is patched by repaintEditLine with the
; physical screen column immediately after the cursor glyph; zero means that
; rendering wrapped at column 32 and no further insertion is permitted.
;
; Return convention used by the main editor loop:
;   Z set     ENTER was pressed; submit the line
;   Z clear   line changed or key was ignored; repaint and continue
updateInputBuffer:
varcInputBufferPosition:
    ld hl,inputBufferStart+1
    ; ENTER key pressed?
    cp 00dh
    ret z                                   ; return zero immediately so the editor submits the line
    ; CS + 5 - left arrow
    cp 008h
    jr nz,.checkCursorRightKey
    ld b,(hl)
    dec hl
    ld a,(hl)
    rlca
    jr c,.incAAndRet                         ; refuse to cross the protected token/command prefix
    ld c,(hl)
    ld (hl),b
    inc hl
    ld (hl),c
    jr .incAAndRet
.checkCursorRightKey:
    cp 00bh
    jr nz,.checkDeletePreviousCharacterKey   ; test backspace when the key is not cursor-right
    ld b,(hl)
    inc hl
    ld a,(hl)
    and a
    jr z,.incAAndRet                         ; refuse to move the cursor beyond the end of the line
    ld (hl),b
    dec hl
    ld (hl),a
    ret
.checkDeletePreviousCharacterKey:
    ; backspace
    cp 003h
    jr nz,.checkCapsLockToggleKey            ; test CAPS LOCK when the key is not backspace
    ld d,h
    ld e,l
    dec hl
    ld a,(hl)
    cp 080h
    jr z,.incAAndRet
.shiftInputTailLeftAfterDeleteLoop:
    ld a,(de)
    ld (hl),a
    inc hl
    inc de
    or a
    jr nz,.shiftInputTailLeftAfterDeleteLoop
.incAAndRet:
    inc a
    ret
.checkCapsLockToggleKey:
    ; CS + 2 - Caps Lock
    cp 005h
    jr nz,.processPrintableInputCharacter
    ld hl,varcCapsLockEnabled+1             ; address the immediate byte that stores CAPS LOCK state
    ld a,0f7h                               ; prepare the arithmetic complement constant used by the original toggle
    sub (hl)                                ; toggle the state between $00 and $F7
    ld (hl),a
    jr .incAAndRet
.processPrintableInputCharacter:
    ; <= 0x20
    cp " "
    ret c
    ld b,a
    jr nz,.insertCharacterAtInputCursor
    ld de,inputBufferStart
    ld a,(de)
    ; does the input buffer contain a comment
    cp ";"
    jr z,.insertCharacterAtInputCursor       ; move the first byte's high bit into carry
    rlca
    jr c,.insertCharacterAtInputCursor       ; preserve the cursor-marker pointer during field-offset calculation
    push hl                                 ; measure cursor position relative to inputBufferStart
    sbc hl,de
    ld a,00dh                               ; subtract the current offset from that target
    sub l
    pop hl
    jr c,.insertCharacterAtInputCursor       ; distinguish padding to column nine from padding to column fourteen
    cp 005h                                 ; use the first derived distance when the cursor is before column nine
    jr c,.insertAutomaticSourceFieldPadding  ; otherwise convert the distance to the mnemonic-field width
    sub 005h
.insertAutomaticSourceFieldPadding:
    ld b,a                                  ; use the derived padding count as the fill length
    inc b
    ld c,020h
    call atHLrepeatBTimesC
    ld (hl),001h                            ; restore the movable cursor marker after the padded field
    jr .incAAndRet
.insertCharacterAtInputCursor:
varcInputColumnAfterCursor:
    ld a,007h
    or a                                    ; test whether rendering has wrapped beyond column thirty-one
    jr z,.incAAndRet                         ; reject insertion when no visible column remains
    ld a,b
.shiftInputTailRightForInsertionLoop:
    ; Move the character being inserted to alternate AF before reading the byte currently under the cursor.
    ex af,af'
    ld a,(hl)
    ; Recover the inserted/displaced byte so it can be written into the current edit-buffer position.
    ex af,af'
    ld (hl),a
    cp 0c5h
    ret z
    cp 0c8h
    ret z
    cp 0cbh
    ret z
    cp 0d7h
    ret z
    inc hl
    ; Move the next displaced byte back into primary AF for the zero-terminator test and next exchange.
    ex af,af'
    or a
    jr nz,.shiftInputTailRightForInsertionLoop
    jr .incAAndRet


; -----------------------------------------------------------------------------
; Encode a comment source line
; -----------------------------------------------------------------------------
; Entry:
;   HL points at the first character of the editor input line and A contains it.
;   The first character is known to be ';'.
;
; Persistent record produced in the temporary encoding workspace:
;
;   +0  $01        pseudo-opcode identifying a comment
;   +1  $37        pseudo-instruction information byte
;   +2  characters copied verbatim, including the leading semicolon
;   ... $C0+n      terminal/back-link marker
;
; B deliberately starts at $FF.  The first call of
; storeAtIXMoveToNextAndIncB stores the semicolon and wraps B to zero; B then
; counts only bytes following that first copied character in the exact way
; expected by .finalizeEncodedSourceRecord.  The zero byte ending the editor
; input is examined but is not retained: IX is backed up before finalization.
;
; This is a distinct path because comments are not split into label, mnemonic,
; and operands and their text is not lower-cased or symbol-compressed.
.encodeCommentSourceRecord:
    ld ix,encodedRecordPayload
    ld (ix-002h),001h                       ; store the comment pseudo-opcode in record byte zero
    ld (ix-001h),037h                       ; store the pseudo/comment information byte in record byte one
    ld b,0ffh                               ; bias the variable-byte counter so the leading semicolon establishes zero
    jr .storeCommentCharacterAndContinue
.encodeCommentCharacterLoop:
    call advanceInputPointerAndRead
.storeCommentCharacterAndContinue:
    call storeAtIXMoveToNextAndIncB
    or a
    jr nz,.encodeCommentCharacterLoop
    dec ix
    jp .finalizeEncodedSourceRecord

; -----------------------------------------------------------------------------
; Convert the editor's 31-column text representation into one compressed record
; -----------------------------------------------------------------------------
; The manual describes the editable line as three logical fields: a nine-byte
; label field, a five-byte mnemonic field, and the operand area.  The editor
; uses byte $01 as an internal field/tab marker; readInputByteSkippingFieldMarker
; transparently steps over that marker while parsing.
;
; High-level stages:
;   1. Detect the special comment form.
;   2. Read an optional label, the mnemonic, and up to two operands.
;   3. Match the mnemonic and register-like operands against compact tables.
;   4. Find the exact five-byte instruction-table record whose opcode, prefix
;      family, mnemonic, and operand descriptors agree.
;   5. Emit opcode/information bytes and, when present, a two-byte symbol number.
;   6. Compress expression text, replacing symbol names by two-byte references.
;   7. Add the terminal/back-link marker and publish the temporary byte count.
;
; Output:
;   encodedRecordStorageLength contains the number of persistent bytes to copy.
;   encodedRecordHeader begins the byte sequence copied into the source buffer.
;
; Errors leave through the common status-bar error paths.  This routine does
; not insert the record itself; parseAndInsertSourceLine performs that step.
encodeInputLineToSourceRecord:
    cp ";"
    jr z,.encodeCommentSourceRecord
    cp " "
    call nz,readSourceFieldUntilSpace       ; read the optional label only when present
    call skipSpaces
    ld de,parsedMnemonicBuffer
    ld c,005h                               ; enforce the five-character mnemonic field limit
    call readSourceFieldUntilSpace
    call skipSpaces
    ld de,varLowercasedOperands             ; select the normalized first-operand buffer
    ld c,012h                               ; limit one parsed operand to eighteen bytes
    call readFirstOperandUntilComma         ; capture the first operand while respecting nested syntax
    jr nz,.parseSecondOperandText
    inc hl
    ld (firstOperandDelimiterByte),a
.parseSecondOperandText:
    ld de,commandArgumentBuffer
    ld c,012h
    call readSecondOperandToEnd
    call validateParsedOperandBuffers
    ld hl,parsedMnemonicBuffer
    ld a,(hl)
    or a
    jr z,.storeParsedMnemonicIndex           ; store pseudo-opcode zero without a mnemonic lookup
    push hl                                 ; preserve the mnemonic start across length-bucket selection
    call lengthUpToZero
    ld hl,mnemonicLookupByLengthDescriptors ; select the compact length-index descriptor table
    call prepareLengthBucketLookup
    pop hl
    call compareWithMnemonics               ; resolve the spelling to its compact mnemonic index
    jp c,badMnemonicError                   ; reject the line when no mnemonic matches
.storeParsedMnemonicIndex:
    ld (varcMnemonicIndex+1),a              ; persist the resolved mnemonic index in the table-search operand
    cp 03ah                                 ; recognize the first definition pseudo-mnemonic index
    jr c,.mnemonicIsNotDef
    cp 03eh
    jp c,.encodeDefinitionPseudoInstruction  ; use the dedicated definition encoder for DEFB through DEFW
.mnemonicIsNotDef:
    ld hl,varLowercasedOperands             ; select the normalized first operand
    push hl                                 ; preserve its start while measuring length
    call lengthUpToZero
    pop hl
    ld a,b
    dec a
    jr nz,.classifyFirstOperandText
    ld a,(varcMnemonicIndex+1)              ; reload the mnemonic index for IM/BIT/RES/SET validation
    cp 006h
    jr nz,.mnemonicIsNotIM
    ld a,(hl)
    sub 02fh                                ; map characters 0–3 to compact values 1–4 for range testing
    cp 004h
.validateSmallNumericOperandRange:
    jp nc,badOperandError                   ; reject a value above the mnemonic-specific maximum
    or a                                    ; test the lower bound after the biased conversion
    jp z,badOperandError                    ; reject the value zero produced by an invalid character
    jr .storeFirstOperandClass
.mnemonicIsNotIM:
; is the mnemonic BIT?
    cp 011h
    jr z,.validateBitNumberOperand           ; share bit-number range validation for BIT
; is the mnemonic RES?
    cp 026h
    jr z,.validateBitNumberOperand
; is the mnemonic SET?
    cp 031h
    jr nz,.classifyFirstOperandText
.validateBitNumberOperand:
    ld a,(hl)
    sub 02fh                                ; map characters 0–8 to compact values 1–9
    cp 009h
    jr .validateSmallNumericOperandRange
.classifyFirstOperandText:
    call classifyOperandText                ; classify the first operand against fixed-token and expression forms
.storeFirstOperandClass:
    ld (varcFirstOperandClass+1),a          ; persist the first operand descriptor for table matching and encoding
    ld hl,commandArgumentBuffer
    call classifyOperandText                ; classify the second operand independently
    ld (varcSecondOperandClass+1),a         ; persist its descriptor
    xor a
    ld (varcUseIYPrefix+1),a                ; clear the IY-normalization flag before examining operands
varcSecondOperandClass:
    ld a,000h
    call normalizeIndexOperandClass         ; normalize IX/IY variants and update the IY flag
    add a,a                                 ; shift the descriptor toward its packed table-key position
    add a,a
    ld e,a
varcFirstOperandClass:
    ld a,000h
    call normalizeIndexOperandClass         ; normalize its IX/IY variant as well
    ld d,a
    ld b,003h                               ; prepare three cross-byte shifts for the packed operand key
.packOperandClassesLoop:
    sla e
    rl d
    djnz .packOperandClassesLoop             ; complete the packed D:E operand descriptor
varcMnemonicIndex:
    ld a,000h                               ; load the resolved mnemonic index
    rla                                     ; rotate its low bit into carry for compact table comparison setup
    ld hl,instructionsTable-2               ; position before the first five-byte instruction-table record
    ld bc,INSTRUCTIONS_TABLE_SIZE
; Search the packed five-byte instruction records.
;
; D:E contains the packed operand-class key, A' contains the mnemonic key, and
; HL walks instructionsTable.  The table is ordered principally by opcode, so
; the code can skip records rapidly and then compare mnemonic/prefix/operand
; fields.  A successful match leaves HL at that table record; failure reaches
; badInstructionError.  All arithmetic here is table navigation only--it does
; not emit bytes into the source record.
.scanInstructionTableOuter:
    inc hl
    ; Preserve the mnemonic comparison key in the alternate accumulator.
    ex af,af'
.scanInstructionTableRecord:
    inc hl
    ; Restore the mnemonic key for comparison with this candidate record.
    ex af,af'
; move to instructionRecord[2]
    inc hl                                  ; position at the record’s mnemonic-index byte
    inc hl
    cpi                                     ; compare the candidate mnemonic byte and advance the bounded table cursor
    jp po,badInstructionError               ; report failure when the bounded table search is exhausted
    jr nz,.scanInstructionTableOuter         ; skip to the next outer record when the mnemonic differs
    ; Preserve the mnemonic key again after a matching table entry.
    ex af,af'
    ld a,(hl)
    inc hl
    cp d                                    ; compare the packed first-operand portion
    jr nz,.scanInstructionTableRecord
    ld a,(hl)
    and 0e0h                                ; retain only the packed second-operand class bits
    cp e                                    ; compare the packed second-operand key
    jr nz,.scanInstructionTableRecord
    dec hl
    dec hl
    dec hl
    ld d,(hl)
    dec hl
    ld e,(hl)
varcUseIYPrefix:
    ld a,000h
    or a
    jr z,.initializeEncodedRecordHeader      ; retain the DD-family prefix when no IY spelling was present
    res 5,d
    set 4,d
.initializeEncodedRecordHeader:
    call initializeRecordHeaderAndOptionalLabel ; initialize opcode/information bytes and optional line-label payload
    ld a,(varcFirstOperandClass+1)          ; reload the first operand descriptor
    cp 02ch
    ld de,varLowercasedOperands             ; select the first operand’s normalized text
    call nc,encodeOperandExpression         ; encode its expression payload only when required
    ld a,(varcSecondOperandClass+1)         ; reload the second operand descriptor
    jr c,.encodeSecondOperand                ; encode it immediately when the first expression ended at a separator
    cp 02ch                                 ; distinguish fixed second operands from expression-bearing forms
    jr c,.finalizeEncodedSourceRecord        ; finish when no second expression bytes are needed
    ld (ix+000h),01fh                       ; insert the internal $1F separator between two encoded expressions
    inc ix
    inc b
.encodeSecondOperand:
    ld de,commandArgumentBuffer
    cp 02ch
    call nc,encodeOperandExpression
; Finish the temporary source record.
;
; B is the number of variable bytes after the two-byte header.  For B != 0 the
; final byte is formed by setting bits 7 and 6, yielding $C0 + B.  Its low six
; bits are therefore a backward distance used by getPreviousSourceRecord.
;
; A copy count is then published as:
;     fixed record:    2 bytes
;     variable record: B payload bytes + terminal marker + 2 header bytes
;
; encodedRecordStorageLength is a temporary wrapper byte only.  It is consumed
; by the insertion routine and is NOT part of the persistent source format.
.finalizeEncodedSourceRecord:
    ld a,b
    or a
    jr z,.storeEncodedRecordStorageLength    ; omit a terminal marker for the fixed two-byte form
    set 7,b
    set 6,b                                 ; set the second terminal tag bit, forming $C0+length
    ld (ix+000h),b
    inc a
.storeEncodedRecordStorageLength:
    add a,002h
    ld (encodedRecordStorageLength),a       ; publish the number of bytes to insert into source memory
    ret
.encodeDefinitionPseudoInstruction:
    push af                                 ; preserve the definition mnemonic index
    sub 034h                                ; map DEFB/DEFM/DEFS/DEFW indices to pseudo-opcodes 6–9
    ld e,a
    ld d,037h
    call initializeRecordHeaderAndOptionalLabel
    push bc                                 ; preserve variable-byte count and parser state across list normalization
    ld hl,firstOperandBufferReadGuard
    xor a
    ld c,a                                  ; initialize the normalized definition-list length
.findEndOfFirstDefinitionArgument:
    inc hl
    inc c                                   ; count one normalized byte
    cp (hl)
    jr nz,.findEndOfFirstDefinitionArgument
    ld de,commandArgumentBuffer
    ld a,(de)
    or a
    jr z,.appendSecondDefinitionArgument     ; skip separator insertion when the second argument buffer is empty
    ld (hl),02ch
    inc hl
    xor a
.appendSecondDefinitionArgument:
    ex de,hl
.copySecondDefinitionArgumentLoop:
    cp (hl)
    jr z,.validateDefinitionArgumentBufferLength ; validate the combined length when copying is complete
    ldi                                     ; copy one argument byte while advancing both pointers
    inc c
    inc c
    jr .copySecondDefinitionArgumentLoop
.validateDefinitionArgumentBufferLength:
    ld a,012h                               ; select the maximum normalized definition-list length
    cp c
    jr c,syntaxError
    pop bc
    pop af                                  ; restore the definition mnemonic index
    cp 03bh
    jr z,.encodeDefmStringLiteral
    ld de,varLowercasedOperands
.encodeNextDefinitionArgument:
    ld a,02ch                               ; seed the expression encoder’s expected comma separator
    call encodeOperandExpression            ; encode one definition expression into the persistent payload
    ld a,(de)                               ; inspect the remaining normalized definition text
    or a
.finishOrSeparateDefinitionArgument:
    jr z,.finalizeEncodedSourceRecord        ; finalize the record when no further argument remains
    ld (ix+000h),02ch                       ; append a comma to the persistent encoded list
    inc ix
    inc b
    jr .encodeNextDefinitionArgument
.encodeDefmStringLiteral:
    ld hl,varLowercasedOperands
    call quotesExpected
    call storeAtIXMoveToNextAndIncB
    inc hl
    ld a,(hl)
    call storeAtIXMoveToNextAndIncB
    inc hl
    ld a,(hl)
.copyDefmStringLiteralLoop:
    call storeAtIXMoveToNextAndIncB
    inc hl
    ld a,(hl)
    or a
    jr nz,.copyDefmStringLiteralLoop         ; copy the complete normalized quoted string
    dec hl
    call quotesExpected
    jr .finishOrSeparateDefinitionArgument


; Capacity check used before inserting or copying BC bytes into the combined
; source/symbol region.  It verifies codeEnd+BC does not wrap and remains below
; the current U-TOP ceiling; otherwise MESSAGE_MEMORY_FULL is raised.
ensureBCBytesFitBelowUTop:
    push hl
    push de
    ld hl,(varcCodeEndPt+1)                 ; current end of combined source and symbol storage
    add hl,bc                               ; calculate the proposed new end after BC-byte growth
    jr c,.memoryFullError                    ; reject 16-bit wraparound immediately
    ld de,(varcUTop+1)                      ; current U-TOP ceiling
    sbc hl,de
    pop de
    pop hl
    ret c                                   ; return only when the proposed end remains strictly below U-TOP

.memoryFullError:
    ld a,MESSAGE_MEMORY_FULL
    jr signalError

badMnemonicError:
    ld a,MESSAGE_BAD_MNEMONIC
    jr signalError

badOperandError:
    ld a,MESSAGE_BAD_OPERAND
    jr signalError

bigNumberError:
    ld a,MESSAGE_BIG_NUMBER
    jr signalError

syntaxError:
    ld a,MESSAGE_SYNTAX_HORROR
    jr signalError


quotesExpected:
    ld a,(hl)
    cp "'"
    ret z
    cp "\""
    ret z
badStringError:
    ld a,MESSAGE_BAD_STRING
    jr signalError
badInstructionError:
    ld a,MESSAGE_BAD_INSTRUCTION
signalError:
    ; Preserve the selected error number in the alternate accumulator.
    ex af,af'
    call beep
    ; Recover the selected diagnostic after the audible alert.
    ex af,af'
errorAction:
    ; Default error action: print the selected status message, then return to editor.
    call printStatusBar
; Common cancellation/error return after status has optionally been printed.
;
; Clear temporary string buffers, keep the active source pointer inside the live
; region (step back if it equals the end marker), and resume the editor without
; discarding the command line.  Earlier monitor setup can patch the first CALL at
; this entry, which is why tape/PRINT cancellation shares this compact path.
abortCommandAndReturnToEditor:
    call clearStringBuffers
    ld hl,(varcSourceBufferActiveLine+1)    ; load the currently active source record
    call comparePositionWithCodeEnd
    call z,getPreviousSourceRecord          ; step back to the last real record when necessary
    ld (varcSourceBufferActiveLine+1),hl    ; persist the repaired active-line pointer
    jp prometheusWarmStartWithCurrentBuffers
signalMessage:
    ld hl,VRAM_ADDRESS
; Display one indexed PROMETHEUS message at bitmap row HL.
;
; Entry:
;   A  = one-based message number
;   HL = first bitmap byte of the destination text row
;
; The row is cleared first.  Message strings are packed consecutively and mark
; their final character with bit 7.  MESSAGE_UNKNOWN has an extra prefix: the
; current undefined symbol spelling, whose address is patched into
; varcUnknownSymbolNameAddress, is printed before the normal error text.
; displayHighBitTerminatedString clears bit 7 only in the glyph renderer; the
; source table is never modified.
displayIndexedMessageAtBitmapRow:
    call clearLineAtHL                      ; clear the destination row before writing the message
    cp 009h
    jr nz,.selectIndexedErrorMessage
    push af                                 ; preserve the message index while rendering the symbol name
varcUnknownSymbolNameAddress:
    ld hl,symbolString
    call displayHighBitTerminatedString     ; render that symbol name before the standard error text
    ld hl,symbolString
    ld (varcUnknownSymbolNameAddress+1),hl  ; reset the self-modified Unknown-name pointer for later errors
    pop af
.selectIndexedErrorMessage:
    ld hl,errorMessages                     ; select the packed error-message table
.skipHighBitTerminatedMessageLoop:
    ; end of string?
    bit 7,(hl)                              ; test whether the current byte terminates this packed string
    inc hl
    jr z,.skipHighBitTerminatedMessageLoop
    dec a
    jr nz,.skipHighBitTerminatedMessageLoop  ; continue until the requested one-based message index is reached
displayHighBitTerminatedString:
    ld a,(hl)                               ; read the next packed message character
    call displayUninvertedCharacter         ; render it with the terminator bit masked by the glyph path
    bit 7,(hl)
    inc hl
    jr z,displayHighBitTerminatedString
    ret

symbolString:
    defb "Symbo",0xec

getSelectedBlock:
    ; get selected code block (from HL to DE)
varcSelectedBlockStart:
    ld hl,sourceBufferAccessLine
varcSelectedBlockEnd:
    ld de,sourceBufferAccessLine
    push hl                                 ; preserve the first endpoint across comparison
    ; swap if order if necessary
    xor a
    sbc hl,de
    pop hl
    ret c                                   ; retain the order when HL is already below DE
    ex de,hl
    ret


; Test whether the current record IX is outside the inclusive selected block.
;
; getSelectedBlock normalizes the two user-set boundary pointers into ascending
; HL=start and DE=end.  The current record is compared first with start and then
; with end.  Carry is returned set when IX < start or IX > end; carry clear means
; the record is inside the block and should be processed.  Alternate registers
; preserve the assembly loop's live HL/DE/BC state.
testSourceRecordOutsideSelectedBlock:
    exx                                     ; switch to alternate registers to protect the assembly loop state
    push ix
    call getSelectedBlock                   ; normalize the selected-block endpoints
    ld b,h
    ld c,l
    pop hl
    push hl
    xor a
    sbc hl,bc
    pop hl
    jr c,.returnSourceRecordBlockMembership  ; exchange the upper endpoint into HL
    ex de,hl
    sbc hl,de
.returnSourceRecordBlockMembership:
    exx
    ret


advanceIXAndLoadSymbolReference:
    inc ix                                  ; advance IX so the ordinal begins at the standard +2 offset
loadSymbolReferenceAtIXPlus2:
    ld d,(ix+002h)
    ld e,(ix+003h)
    ret


resolveRecordLabelAfterHeader:
    ; skip size
    call loadSymbolReferenceAtIXPlus2
; Convert a compact two-byte symbol ordinal into its stored label text.
;
; The source record does not contain a pointer into movable memory.  It contains
; an ordinal relative to the symbol-table index.  This routine clears the tag
; bit, indexes the symbol pointer array, follows the selected entry, and returns
; DE pointing at the high-bit-terminated symbol spelling.  This indirection is
; why source records remain valid while insertion/deletion moves the combined
; source and symbol region.
; Resolve a compact one-based symbol ordinal.
;
; Table layout at varcSymbolTablePt:
;   +0..1                    symbol count N
;   +2..+2N+1               N two-byte vectors
;   following bytes         sorted entries: valueLo,valueHi,name...
;
; A vector's low fourteen bits select its value/name record relative to the
; computed entry-area anchor; bits 6 and 7 of the vector high byte are state
; flags and are masked before address formation.  On return HL addresses the
; selected vector's high/flag byte and DE addresses the first name character
; (the two-byte value lies immediately before DE).
resolveSymbolReferenceToName:
varcSymbolTableBasePointer:
    ld hl,(varcSymbolTablePt+1)             ; current symbol-table base
    push hl                                 ; preserve it for later entry-area address formation
    res 7,d                                 ; clear the ordinal tag bit before indexing
    add hl,de                               ; scale the ordinal once relative to the table base
    add hl,de                               ; scale it to the two-byte vector width
    ld e,(hl)
    inc hl
    ld a,(hl)
    and 03fh                                ; discard DEFINED and LOCKED flags from the offset
    ld d,a
    ex (sp),hl                              ; exchange the table base with the vector-high-byte pointer on stack
    push hl
    ex de,hl                                ; move the entry offset into HL for address arithmetic
    ex (sp),hl                              ; recover the table base from the stack while retaining the offset
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ex de,hl
    inc hl                                  ; convert symbol count to vector-array byte size
    add hl,hl
    add hl,de
    pop de                                  ; recover the selected entry offset
    add hl,de                               ; add that offset to locate the value/name record
    ex de,hl
    pop hl
    ret


; Expand one persistent compressed source record into editor text.
;
; IX points to record byte 0.  The default entry expands into lineBuffer; the
; secondary entry accepts any destination in HL.  The destination is first
; cleared to 32 zero bytes.
;
; Comment records are copied directly.  Structured records are reconstructed as
; fixed editor fields: optional label (nine columns), mnemonic (five columns),
; then operands.  Byte $01 is inserted as the editor's field/tab marker.  Symbol
; references in labels or expressions are resolved through the current symbol
; table.  No source-buffer bytes are modified.
expandSourceRecordToLineBuffer:
    ld hl,lineBuffer
expandSourceRecordToHL:
    push hl
    ; clear line buffer
    ld bc,02000h
    call atHLrepeatBTimesC
    pop hl
    ; check comment, sequence 0x01,0x37
    ld a,(ix+000h)
    dec a
    jr nz,.expandStructuredSourceRecord
    ld a,(ix+001h)
    cp 037h
    jr nz,.expandStructuredSourceRecord
.expandCommentRecordLoop:
    ; write comment content
    ld a,(ix+002h)
    cp 0c0h
    ; try to write EOL...
    ld (hl),001h                            ; prewrite the editor end marker at the current destination
    ret nc
    ; ...but overwrite if the line does not end
    inc ix
    ld (hl),a
    inc hl
    jr .expandCommentRecordLoop
.expandStructuredSourceRecord:
    ; not a comment
    ld b,LABEL_LENGTH
    ; label present? (bit 3 of information byte)
    bit 3,(ix+001h)
    ; label not present, print spaces instead of label
    call z,fillHLWithBSpaces
    jr z,.decodeRecordInstructionMetadata    ; skip label resolution when the record has none
    push hl                                 ; preserve the output cursor across symbol resolution
    call resolveRecordLabelAfterHeader
    pop hl
    ld b,LABEL_LENGTH
    call printFromDEtoHLpaddedLeft
.decodeRecordInstructionMetadata:
    push hl                                 ; preserve the text output cursor across instruction-table decoding
    ld b,(ix+000h)
    ld a,(ix+001h)
    ; get instruction type (top 3 bytes of information byte)
    and 0f0h
    ld c,a
    call decodeInstructionTableRecord
    pop hl
    jr z,.appendExpandedMnemonic             ; append the mnemonic only when metadata decoding succeeded
    ld a,010h
    ld (varcLastStatusBarMessage+1),a       ; retain that error for the editor repaint
    ret
.appendExpandedMnemonic:
    ld (hl),001h                            ; insert the editor field marker before the mnemonic
    or a
    ret z                                   ; finish when there is no mnemonic index
    cp 03ah
    jr c,.lookupMnemonicText                 ; use the decoded mnemonic index directly below the definition range
    cp 03eh
    jr nc,.lookupMnemonicText                ; use the decoded index directly above the definition range
    ld d,02ch                               ; map definition pseudo-records to their shared mnemonic-table slot
.lookupMnemonicText:
    push de                                 ; preserve operand descriptors while resolving mnemonic text
    ld de,mnemonicsReferences               ; select the packed mnemonic string table
    call getStringFromTableDE               ; resolve the mnemonic index to its spelling
    ld b,005h
    call printFromDEtoHLpaddedLeft
    pop de
    ld (hl),001h                            ; insert the editor field marker before operands
    inc hl
    bit 3,(ix+001h)                         ; test for an encoded line-label ordinal
    jr z,.expandOperandsAfterOptionalLabel   ; begin operand expansion immediately when no label payload precedes it
    inc ix
    inc ix
.expandOperandsAfterOptionalLabel:
    push de                                 ; preserve both operand descriptors while expanding the first
    ld a,d
    call expandOperandByDescriptor
    pop de
    ld a,e
    or a
    ret z                                   ; finish when the record has only one operand
    ld (hl),02ch
    inc hl
; Render one operand described by the instruction-table operand index.
;
; Descriptor values below $2C name fixed strings such as registers and
; conditions.  Values $2C and above describe expression-bearing forms,
; including parenthesized addresses and IX/IY displacement syntax.  The encoded
; expression is consumed from IX+2 because IX remains based on the two-byte
; source-record header while this routine runs.
expandOperandByDescriptor:
    or a
    ret z                                   ; return without output for descriptor zero
    cp 02ch
    jr nc,.expandExpressionOperand
    ld de,operandsReferences                ; select the packed operand-name string table
    call getStringFromTableDE
copyResolvedSymbolNameToLine:
    ld b,009h
printFromDEtoHLwithDecB:
    ; From (de) print at (hl) and decrease B meanwhile.
    ; Report source error if you end before the expected string end
    ld a,(de)                               ; read the next packed string character
    ; character without line end-of-string mark
    and 07fh
    ld (hl),a
    dec b
    jr nz,.continueTableStringCopy
    ld a,MESSAGE_SOURCE_ERROR
    ld (varcLastStatusBarMessage+1),a       ; retain that status for the editor repaint
    pop af                                  ; discard the caller return address used by this compact failure path
    ret
.continueTableStringCopy:
    ld a,(de)                               ; reload the packed source byte for terminator testing
    and 080h                                ; isolate its high-bit end marker
    inc hl
    inc de
    jr z,printFromDEtoHLwithDecB
    ret

.expandExpressionOperand:
    push af
    cp 02dh                                 ; distinguish plain expression from parenthesized forms
    jr c,.expandEncodedExpressionLoop        ; expand plain expression text without an opening parenthesis
    ld (hl),028h
    inc hl
    cp 02eh                                 ; distinguish indirect address from IX/IY displacement forms
    jr c,.expandEncodedExpressionLoop
    ld (hl),069h                            ; append the fixed “i” of an index register name
    inc hl
    ld b,078h                               ; prepare “x” as the default index-register suffix
    cp 02fh
    jr c,.appendIndexRegisterLetter          ; retain “x” for IX forms
    ld b,079h                               ; select “y” for IY forms
.appendIndexRegisterLetter:
    ld (hl),b                               ; append the selected index-register suffix
    inc hl
    ld a,(ix+002h)                          ; inspect the first encoded displacement byte
    cp 02dh
    jr z,.expandEncodedExpressionLoop        ; preserve its minus sign when already encoded
    ld (hl),02bh                            ; insert a plus sign before nonnegative displacement text
    inc hl
.expandEncodedExpressionLoop:
    ld a,(ix+002h)                          ; read the next encoded expression byte
    cp 01fh
    jr z,.finishExpressionOperand
    cp 0c0h
    jr nc,.finishExpressionOperand           ; finish at the end of the encoded payload
    cp 080h
    jr nc,.expandEncodedSymbolReference      ; resolve tagged symbol references rather than copying their bytes
    ld (hl),a
    inc hl
    inc ix
    jr .expandEncodedExpressionLoop
.expandEncodedSymbolReference:
    ld d,a
    ld e,(ix+003h)
    inc ix
    inc ix
    push hl                                 ; preserve the expanded-line cursor across symbol resolution
    call resolveSymbolReferenceToName
    pop hl
    call copyResolvedSymbolNameToLine
    jr .expandEncodedExpressionLoop
.finishExpressionOperand:
    pop af
    inc ix
    cp 02dh
    ret c
    ld (hl),029h
    inc hl
    ret


getRecordBeforeActiveLine:
    ld hl,(varcSourceBufferActiveLine+1)    ; load the active compressed-record pointer before stepping to its predecessor
; Return the start address of the preceding compressed source record.
;
; HL initially points to the current record.  The byte immediately before it is
; inspected:
;   * value < $C0: the previous record is the fixed two-byte form;
;   * value >= $C0: low six bits give the previous record's variable-byte count.
;
; This backward marker makes reverse editor navigation constant-time without a
; separate line index.  SBC is safe here because all callers reach the routine
; with carry clear through the preceding comparisons/control paths.
getPreviousSourceRecord:
    ; inspect the byte immediately before the current record
    dec hl
    ld a,(hl)
    ; highest 2 bits
    cp 0c0h                                 ; distinguish a variable-record marker ($C0+) from a fixed two-byte record
    jr c,.previousRecordIsFixedLength        ; use the fixed-record path when no encoded variable length is present
    ; lowest 6 bits
    and 03fh                                ; extract the variable payload length from the marker's low six bits
    ld e,a
    ld d,000h                               ; zero-extend the payload length to 16 bits
    sbc hl,de
    dec hl
.previousRecordIsFixedLength:
    dec hl
    ret


getRecordAfterActiveLine:
    ld hl,(varcSourceBufferActiveLine+1)    ; load the active record start before entering the common forward scanner
; Return the address immediately following the record at HL.
;
; After reading the information byte, an optional two-byte line-label reference
; is skipped.  A record with no label and operand type zero is exactly two bytes.
; Otherwise the variable stream is scanned until a byte >= $C0 is found.
; Bytes $80-$BF introduce a two-byte symbol reference, so their following low
; byte is skipped and can never be mistaken for a terminal marker.
getNextSourceRecord:
    inc hl
    ld a,(hl)
    inc hl
    ; label?
    bit 3,a                                 ; test whether a two-byte encoded label ordinal is present
    jr z,.testFixedLengthRecord              ; classify an unlabeled record for the fixed two-byte fast path
    ; label number included, skip
    inc hl                                  ; skip encoded label ordinal high byte
    inc hl                                  ; skip encoded label ordinal low byte
    jr .scanVariableLengthRecord
.testFixedLengthRecord:
    and 007h
    ; no label and class zero: the record ends after its two-byte header
    ret z
.scanVariableLengthRecord:
    ld a,(hl)
    inc hl
    ; end of the expression?
    cp 0c0h                                 ; recognize the terminal marker stored in the $C0-$FF range
    ret nc
    ; end of token
    cp 080h
continueVariableLengthRecordScan:
    jr c,.scanVariableLengthRecord
    inc hl                                  ; skip the low ordinal byte following a $80-$BF symbol lead byte
    jr .scanVariableLengthRecord


; Poll during PROMETHEUS or GENS source import.
;
; With no key pressed, return immediately.  With SPACE pressed, the common abort
; helper returns to the editor and leaves the last command/current line available.
; Any other key returns from the SPACE test and deliberately falls through into
; renderVisibleSourceRecords, providing the manual's on-demand progress display.
pollImportKeyboardAndRefreshIfRequested:
    xor a
    ; read keyboard
    in a,(0feh)                             ; sample the active-low keyboard matrix during import
    cpl                                     ; convert pressed keys to active-high bits
    and 01fh
    ret z
    call abortCurrentOperationIfSpacePressed ; abort on SPACE; any other key falls through to repaint visible source

; Repaint the sixteen source rows around the editor access line.
;
; Starting from the active record, walk backward LINES_BEFORE_ACCESS_LINE records
; to find the top visible record.  Each record is expanded into lineBuffer,
; optionally marked as part of the selected block, printed, and advanced using
; getNextSourceRecord.  The compressed source itself remains untouched.
renderVisibleSourceRecords:
varcSourceBufferActiveLine:
    ld hl,sourceBufferAccessLine
    ; Position the top row thirteen records before the active access-line record.
    ld b,LINES_BEFORE_ACCESS_LINE
.findTopVisibleSourceRecordLoop:
    call getPreviousSourceRecord            ; move to the preceding compressed record, clamping at the source start sentinel
    djnz .findTopVisibleSourceRecordLoop
    ld a,010h                               ; start rendering at bitmap row $10, the first source-window text row
.renderVisibleSourceRecordLoop:
    push af                                 ; preserve the current bitmap row across record rendering
    push hl
    push hl
    call clearLine                          ; clear the destination display row before drawing expanded source text
    pop ix
    call renderSourceRecord
    pop hl
    call getNextSourceRecord
    pop af
    add a,008h                              ; advance by one Spectrum character row in bitmap-address high-byte form
    cp 0a9h
    jr c,.renderVisibleSourceRecordLoop      ; render another source record while the next row remains on screen
    ret


; =============================================================================
; PERSISTENT COMPRESSED SOURCE-RECORD FORMAT
; =============================================================================
; There is no leading record-length byte in the source buffer.
;
; Byte 0: opcode or pseudo-opcode
; --------------------------------
; For a real Z80 instruction this is the instruction opcode.  The prefix family
; is carried in byte 1.  Pseudo-instruction opcodes are:
;
;   $00 empty line       $05 PUT
;   $01 comment          $06 DEFB
;   $02 ENT              $07 DEFM
;   $03 EQU              $08 DEFS
;   $04 ORG              $09 DEFW
;
; Byte 1: information byte
; ------------------------
;   bit 7  CB-family record
;   bit 6  ED-family record
;   bit 5  DD-family record
;   bit 4  FD-family record
;   bit 3  a source-line label reference follows the header
;   bit 2..0 operand/storage class:
;            0 no expression payload
;            1 one-byte value
;            2 two-byte value
;            3 signed relative byte
;            4 (IX/IY+d)
;            5 (IX/IY+d),n
;            6 RST operand encoded in opcode
;            7 pseudo-instruction / not a machine instruction
;
; Variable part
; -------------
; If bit 3 is set, the first two variable bytes are the line label's symbol
; ordinal.  In expressions, each symbol name is likewise replaced by two bytes:
;
;   high ordinal byte with bit 7 set, then low ordinal byte
;
; Literal expression characters remain ASCII.  Consequently:
;
;   $00-$7F  literal expression/comment byte
;   $80-$BF  first byte of a two-byte symbol reference
;   $C0-$FF  terminal/back-link marker
;
; Variable records end in $C0+n, where n is the number of bytes between the
; two-byte header and the marker.  The low six bits let reverse traversal find
; the preceding record without rescanning from sourceBufferStart.
;
; Fixed two-byte records
; ----------------------
; A record with no line label and operand/storage class zero has only bytes 0
; and 1 and therefore no terminal marker.  The initial empty-line record is
; $00,$30.  Empty/pseudo records with a label use information bit 3 and become
; variable records because the two-byte symbol ordinal must follow.
;
; Example expression: 2*LABEL+#23
; --------------------------------
; Conceptually the variable bytes are:
;
;   '2','*',($80 | high(symbolOrdinal)),low(symbolOrdinal),'+','#','2','3',
;   $C0+8
;
; The exact symbol ordinal is stable as an index, not as a direct address.
; =============================================================================

; Render one compressed source record through the shared 32-column text path.
;
; After expansion, a record inside the selected block receives marker byte $03
; at lineBufferMarkerPosition.  printExpandedSourceLineWithRoutine then scans the
; expanded line, skips internal $01 field markers, tracks quote parity, and
; applies the installation-selected case conversion only outside quoted text.
; The output CALL is self-modified so editor display, printer output, FIND and
; other line consumers can reuse the same scanner without duplicating parsing.
renderSourceRecord:
    push ix
    call expandSourceRecordToLineBuffer
    pop ix
    call testSourceRecordOutsideSelectedBlock
    jr c,.selectExpandedSourceLineRenderer   ; retain normal colouring for records outside the block
    ; add the character for block selection - code 0x03. The computed character bitmap address is
    ; then located in the unused block of ROM that is filled with 0xFF values on 48k Spectrum.
    ; However, some other ROMs use this part of memory in a different way so the character may
    ; be corrupted or not visible at all on some machines
    ld hl,lineBufferMarkerPosition
    ld (hl),003h
.selectExpandedSourceLineRenderer:
    ld hl,displayCharacterSafely
printExpandedSourceLineWithRoutine:
    ld (varcExpandedSourceCharacterRendererCall+1),hl ; patch the shared source scanner's output callback
    ld hl,lineBuffer
    ld c,000h
.readNextExpandedSourceCharacter:
    ld a,(hl)
    inc hl
    dec a
    jr z,.readNextExpandedSourceCharacter
    inc a                                   ; recognize quote delimiters that toggle literal state
    ret z
    cp 022h                                 ; toggle the quote-state bit
    jr nz,.applySourceCaseModeOutsideQuotes  ; preserve quote state across the output callback
    inc c
    ld a,022h
.applySourceCaseModeOutsideQuotes:
    bit 0,c
    jr nz,varcExpandedSourceCharacterRendererCall ; leave source spelling unchanged when case conversion is disabled
    call isLetter                           ; classify the current byte before uppercasing
    jr nz,varcExpandedSourceCharacterRendererCall
    ; font modifier:
    ;  230, 255 - normal
    ;  230, 223 - uppercase
    ;  246, 32  - lowercase
configurationPatchTarget02SourceCaseTransform: ; @config-patch 02 (two-byte instruction)
    and 0ffh
varcExpandedSourceCharacterRendererCall:
    call displayCharacterSafely             ; emit the current character through the caller-patched renderer
    jr .readNextExpandedSourceCharacter


getStringFromTableDE:
    ; Resolve DE+A+table[A] from a self-relative string table while preserving HL.
    push hl                                 ; preserve the caller's HL while the relative string table is resolved through HL
    ex de,hl
    ld d,000h                               ; zero-extend the one-byte table index used as the first displacement
    ld e,a                                  ; copy the selected entry index from A into the low displacement byte
    add hl,de                               ; address the self-relative offset byte at tableBase plus index
    ld e,(hl)
    ; D remains zero so the stored one-byte displacement is treated as unsigned.
    add hl,de                               ; add the stored displacement to obtain the packed string's address
    ex de,hl                                ; return the resolved packed-string pointer in DE
    pop hl
    ret


printFromDEtoHLpaddedLeft:
    ; Copy a packed string left-aligned within a B-cell field, then space-pad the remainder.
    ; An overlong spelling is truncated through the shared Source error path.
    call printFromDEtoHLwithDecB            ; copy the packed string while reducing B to the unused field width
fillHLWithBSpaces:
    ld c," "
    jr atHLrepeatBTimesC

clearStringBuffers:
    ; Clear the contiguous 55-byte number, line and input-buffer workspace.
    ld bc,03700h
    ld hl,numberStringBuffer

atHLrepeatBTimesC:
    ld (hl),c
    inc hl
    djnz atHLrepeatBTimesC
    ret


; Build the first part of an encoded record.
;
; Input convention established by the caller:
;   D = information byte, E = opcode or pseudo-opcode.
;   inputBufferStart contains the optional source label.
;
; The routine stores E,D as the persistent two-byte header.  If the input line
; begins with a label, information bit 3 is set and findOrCreateSymbol returns
; the symbol-table ordinal.  That ordinal is stored immediately after the
; header with bit 7 set in its high byte, matching expression symbol references.
;
; Returns:
;   IX -> first free byte after header and optional line-label reference
;   B  -> 0 without a label, 2 with a label
initializeRecordHeaderAndOptionalLabel:
    ld b,000h                               ; initialize the variable-payload count for a record without a line label
    ld hl,inputBufferStart
    call atHLorNextIfOne                    ; read the first visible label character while skipping a movable cursor marker
    cp 041h                                 ; classify bytes below ASCII A as an empty label field
    jr c,.storeRecordOpcodeAndInfo           ; store the fixed header immediately when no syntactic label begins the line
    set 3,d                                 ; mark the record information byte so expansion expects a two-byte label ordinal
.storeRecordOpcodeAndInfo:
    ld (encodedRecordHeader),de
    push af                                 ; preserve the first label character and its comparison flags across header validation
    ld a,e
    cp 003h                                 ; recognize pseudo-opcode three, whose all-ones information form is forbidden
    jr nz,.positionRecordPayloadWritePointer ; skip the special invalid-record test for every other opcode
    ld a,d
    cp 037h
    jp z,badInstructionError                ; reject the reserved opcode/information combination before any symbol is created
.positionRecordPayloadWritePointer:
    pop af
    ld ix,encodedRecordPayload
    ret c
    call findOrCreateSymbolOrdinal
    ld ix,encodedRecordPayloadAfterLabel
    set 7,h                                 ; tag the ordinal high byte as a compressed-source symbol reference
    ld (ix-002h),h
    ld (ix-001h),l
    ld b,002h                               ; account for the two label-reference bytes in the variable payload length
    ret


; Recover mnemonic and operand descriptors from opcode/prefix metadata.
;
; Entry:
;   B = opcode from source record byte 0
;   C = prefix-family bits from source record byte 1
;
; The instruction table has multiple records for a single opcode (plain, CB,
; ED, DD/FD, and pseudo-instructions).  This routine locates the matching record
; and unpacks its bit-packed mnemonic index and two operand descriptor indexes.
; DD and FD share records: varcIndexRegisterVariantOffset records which textual
; spelling (IX or IY) must be selected during expansion.
;
; Return:
;   A = mnemonic-table index
;   D = first operand descriptor
;   E = second operand descriptor
;   Z set on a valid match; non-Z indicates damaged/inconsistent source data.
decodeInstructionTableRecord:
    ld de,00352h                            ; seed the binary-search stride with the initial half-table displacement
    ld a,001h                               ; assume the DD/IX textual variant until prefix bits prove otherwise
    ; prefix DD?
    bit 5,c
    jr nz,.rememberIndexPrefixVariant        ; keep the default IX variant when the DD prefix bit is present
    ; prefix FD?
    bit 4,c
    jr z,.rememberIndexPrefixVariant         ; leave non-indexed prefix families unchanged
    dec a
    res 4,c                                 ; normalize FD metadata to the shared DD-family key used by the instruction table
    set 5,c                                 ; set the normalized index-prefix bit used by the packed metadata comparison
.rememberIndexPrefixVariant:
    ; prefix DD and not FD
    ld (varcIndexRegisterVariantOffset+1),a ; patch operand spelling for the IX/IY variant
    ; label in instructionTable
    ld hl,l9e8a
    exx                                     ; switch to the alternate register set so B/C can remain the immutable search key
    ld b,00bh                               ; limit the stride-halving search to eleven ordered comparisons
.instructionRecordSearchIteration:
    exx
    ld a,(hl)
    cp b
    jr nz,.adjustInstructionSearchWindow
    inc hl
    ld a,(hl)
    dec hl
    and 0f0h
    cp c                                    ; compare only the normalized prefix-family nibble
    jr z,.decodeMatchedInstructionRecord     ; unpack this record when opcode and prefix family both match
.adjustInstructionSearchWindow:
    jr c,.moveInstructionSearchForward       ; choose the lower or upper ordered half from the unsigned key comparison
    sbc hl,de                               ; move backward by the current record-aligned search stride for a lower key
    jr .halveInstructionSearchStride
.moveInstructionSearchForward:
    add hl,de                               ; move forward by the current record-aligned search stride for a higher key
.halveInstructionSearchStride:
    srl d
    rr e                                    ; rotate the low byte through carry to complete the 16-bit division by two
    jr nc,.continueInstructionRecordSearch   ; use an already record-aligned even half-stride without correction
    inc de
    inc de
    inc de                                  ; finish aligning the next candidate displacement to a whole metadata record
.continueInstructionRecordSearch:
    exx                                     ; return to the alternate register set holding the search-depth counter
    djnz .instructionRecordSearchIteration
    inc b
    exx
    ret
.decodeMatchedInstructionRecord:
    inc hl
    inc hl                                  ; advance to the packed mnemonic-index byte
    ld a,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ld e,(hl)
    srl a                                   ; shift the low mnemonic bit into the descriptor unpacking chain
    ld b,003h                               ; select three cross-byte rotations for the packed operand fields
    rr d                                    ; rotate the mnemonic carry into the first operand descriptor
    jr .unpackOperandDescriptorsStep
.unpackOperandDescriptorsLoop:
    srl d
.unpackOperandDescriptorsStep:
    rr e                                    ; rotate the corresponding packed bit into the second-operand descriptor
    djnz .unpackOperandDescriptorsLoop
    srl e
    srl e                                   ; discard the final non-descriptor bit and leave E as the operand-two index
varcIndexRegisterVariantOffset:
    ld b,001h
    dec b                                   ; convert the stored one-based selector to a zero/nonzero adjustment request
    ret z
    push af                                 ; preserve the unpacked mnemonic index while operand classes are normalized
    ld a,e
    inc a                                   ; bias the descriptor to the one-based class numbering expected by normalization
    call normalizeIndexOperandClass         ; map any IY-only descriptor to the common IX class and set the IY flag
    jr nz,.retainFirstOperandDescriptor      ; keep the original second descriptor when it is not an index-register class
    inc e
.retainFirstOperandDescriptor:
    ld a,d
    inc a                                   ; bias it to the one-based class numbering expected by normalization
    call normalizeIndexOperandClass         ; map any IY-only descriptor to the common IX class and set the IY flag
    jr nz,.retainSecondOperandDescriptor     ; keep the original first descriptor when it is not an index-register class
    inc d
.retainSecondOperandDescriptor:
    pop af                                  ; restore the mnemonic-table index after descriptor normalization
    cp a                                    ; force Z on the successful decode return path
    ret


validateParsedOperandBuffers:
    ld hl,commandArgumentBuffer
    ld b,"("
    ld c,001h                               ; seed the compact structural count with the mandatory terminator state
    xor a
.countOperandBufferZeroBytesLoop:
    cp (hl)
    inc hl
    jr z,.countOperandBufferZeroByte         ; skip structural-count growth for zero terminators
    inc c
.countOperandBufferZeroByte:
    djnz .countOperandBufferZeroBytesLoop
    ld a,012h
    cp c
    jr c,.rejectUnexpectedExpressionEnd      ; reject a combined operand form whose nonzero content exceeds that bound
    ret


; Compress one textual operand expression into the current source record.
;
; DE scans a zero-terminated operand buffer; IX is the destination; B is the
; variable-byte count.  Ordinary characters are copied unchanged.  A symbol
; name is looked up/created and replaced by two bytes:
;
;     byte 0 = high(symbol ordinal) with bit 7 set
;     byte 1 = low(symbol ordinal)
;
; Bytes $80-$BF can consequently be distinguished from literal ASCII while a
; record is traversed.  Operators + - * / ? and numeric/string forms are syntax
; checked as they are copied.  Carry on return marks an expression boundary
; encountered by the caller (comma, closing parenthesis, or end).
encodeOperandExpression:
    cp ","
    jr z,.beginExpressionTokenScan           ; start token scanning without skipping text for that direct expression class
    inc de
    cp "-"                                  ; recognize class $2D through its ASCII-equivalent descriptor value
    jr z,.beginExpressionTokenScan           ; start token scanning after the opening parenthesis for a generic indirect expression
    inc de                                  ; skip the normalized i of an IX/IY indexed-displacement operand
    inc de                                  ; skip x or y and position DE at the displacement sign
.beginExpressionTokenScan:
    call testClosingBracketOrComma
.rejectUnexpectedExpressionEnd:
    jp c,syntaxError                        ; report syntax when an operand begins or continues at a boundary
    cp "+"
    jr z,.readExpressionAfterUnaryMinus      ; consume unary plus without storing it in the compressed expression
    cp "-"                                  ; recognize unary minus as the only stored leading sign
    jr nz,.classifyExpressionAtom            ; classify an ordinary atom when no unary minus is present
    call storeAtIXMoveToNextAndIncB         ; append unary minus to the encoded payload before reading its atom
.readExpressionAfterUnaryMinus:
    call testClosingBracketOrComma
    jr c,.rejectUnexpectedExpressionEnd      ; reject a sign that is immediately followed by comma, closing bracket, or end
.classifyExpressionAtom:
    cp "$"
    jr nz,.classifyIdentifierOrLiteral       ; use identifier/literal classification for every other atom form
    call storeAndTestNextClosingBracketOrComma
    jr .continueExpressionAfterAtom
.classifyIdentifierOrLiteral:
    ld c,a                                  ; retain the original first atom byte while testing a case-folded copy
    or 020h                                 ; force alphabetic case bit 5 so the common letter classifier accepts either case
    call isLetter
    jr nz,.encodeLiteralExpressionCharacter  ; encode nonletters through the numeric or quoted-literal parser
    push bc
    dec de
    push de
    push ix                                 ; preserve the encoded-record destination across symbol-table services
    ex de,hl                                ; present the identifier text in HL to the normalized symbol resolver
    call findOrCreateSymbolOrdinal
    pop ix                                  ; restore the encoded-record destination after symbol resolution
    set 7,h                                 ; tag the symbol ordinal high byte for compressed expression storage
    ld (ix+000h),h
    inc ix
    ld (ix+000h),l
    inc ix
    pop bc
    ld hl,(numberStringBuffer)
    ld h,000h                               ; clear its unused high byte before pointer arithmetic
    add hl,bc
    ex de,hl
    pop bc
    inc b
    inc b
    call testClosingBracketOrComma
    jr .continueExpressionAfterAtom
.encodeLiteralExpressionCharacter:
    ld a,c
    call encodeQuotedOrNumericAtom
.continueExpressionAfterAtom:
    ccf                                     ; invert the boundary carry so a completed operand can return directly
    ret nc                                  ; return when comma, closing parenthesis, or end terminated the expression
    cp "+"
    jr z,.storeExpressionOperatorAndContinue
    cp "-"
    jr z,.storeExpressionOperatorAndContinue
    cp "*"
    jr z,.storeExpressionOperatorAndContinue
    cp "/"
    jr z,.storeExpressionOperatorAndContinue
    cp "?"
.rejectInvalidExpressionOperator:
    jp nz,syntaxError                       ; report syntax for any post-atom byte that is neither a boundary nor supported operator
.storeExpressionOperatorAndContinue:
    call storeAndTestNextClosingBracketOrComma
    jr .rejectUnexpectedExpressionEnd


; Parse one textual numeric or quoted expression atom and copy its canonical
; spelling into the temporary encoded-expression area.
;
; Numeric forms are decimal, %binary, and #hexadecimal.  The accumulator is
; multiplied by the selected radix through repeated 16-bit addition, with every
; carry reported as Big number.  convertInputCharacterToRadixDigit accepts
; decimal and alphabetic hexadecimal digits, normalizes lower-case A-F, and
; returns carry clear when the next byte is not a valid digit for the radix.
;
; A quoted atom contains one or two bytes.  A doubled quote is treated as a
; literal quote; a third character before closure produces Bad string.  The
; copied closing delimiter is retained because expression re-expansion expects
; the original textual representation.
encodeQuotedOrNumericAtom:
    cp "\""
    jr z,.encodeQuotedNumericLiteral
    ld c,00ah                               ; select decimal radix ten as the default numeric form
    call isNumber                           ; classify an ordinary decimal digit without consuming a radix prefix
    jr z,.initializeRadixLiteralAccumulator  ; begin accumulation immediately when the atom starts with a decimal digit
    ; binary
    cp "%"
    jr nz,.checkHexadecimalLiteralPrefix     ; try hexadecimal-prefix recognition when the atom is not binary
    ld c,002h
    jr .consumeRadixPrefixAndBeginLiteral
.checkHexadecimalLiteralPrefix:
    ;  hexadecimal
    cp "#"
    jr nz,.rejectInvalidExpressionOperator
    ld c,010h
.consumeRadixPrefixAndBeginLiteral:
    call storeAndTestNextClosingBracketOrComma
    jp c,syntaxError                        ; report syntax when the prefix is immediately followed by a boundary
.initializeRadixLiteralAccumulator:
    ld hl,00000h
.parseNextRadixDigit:
    call convertInputCharacterToRadixDigit  ; convert the current character to a normalized digit while preserving its original spelling
    ret nc                                  ; finish the literal when the current byte is not a valid radix digit
    push de                                 ; preserve the source pointer while DE is reused as the multiplicand
    push af                                 ; preserve the normalized digit while A controls repeated multiplication
    ld a,c
    dec a
    ld d,h
    ld e,l
.multiplyLiteralAccumulatorByRadixLoop:
    add hl,de
.signalNumericLiteralOverflow:
    jp c,bigNumberError                     ; report Big number when any multiplication addition exceeds sixteen bits
    dec a
    jr nz,.multiplyLiteralAccumulatorByRadixLoop
    pop af
    cp c
    jp nc,bigNumberError                    ; report Big number for a digit outside the chosen radix's legal range
    ld d,000h                               ; zero-extend the normalized digit before adding it to the accumulator
    ld e,a
    add hl,de
    jr c,.signalNumericLiteralOverflow       ; share the overflow error path when the digit addition wraps
    pop de
    ; preserve the original input character in alternate AF for exact textual copying
    ex af,af'
    call storeAndTestNextClosingBracketOrComma
    ret c                                   ; return when that fetched byte terminates the numeric atom
    jr .parseNextRadixDigit
.encodeQuotedNumericLiteral:
    ld hl,00000h
    call readNextQuotedLiteralCharacter
    or a                                    ; classify zero as a closing delimiter rather than a literal data byte
    jr z,.appendQuotedLiteralClosingDelimiter ; finish an empty quoted literal by appending its closing quote
    ld l,a
    call readNextQuotedLiteralCharacter
    or a                                    ; classify zero as closure after a one-byte literal
    jr z,.appendQuotedLiteralClosingDelimiter ; finish the one-byte form by appending its closing quote
    ld h,l
    ld l,a
    call readNextQuotedLiteralCharacter
    or a
    jp nz,badStringError
.appendQuotedLiteralClosingDelimiter:
    jr .storeClosingQuoteInEncodedExpression
readNextQuotedLiteralCharacter:
    call storeAndTestNextClosingBracketOrComma
    or a
    jp z,badStringError                     ; report Bad string when input ends before a closing quote
    cp "\""
    jr z,.distinguishEscapedOrClosingQuote   ; inspect doubled-versus-closing quote handling when a quote was fetched
    and a
    ret
.distinguishEscapedOrClosingQuote:
    ld a,(de)
    cp "\""
    ld a,000h
    ret nz
.storeClosingQuoteInEncodedExpression:
    ld a,"\""
storeAndTestNextClosingBracketOrComma:
    call storeAtIXMoveToNextAndIncB
testClosingBracketOrComma:
    ld a,(de)
    inc de
    cp ")"
    jr z,.setFlagForSyntaxError              ; return carry set for a closing parenthesis
    cp ","
    jr z,.setFlagForSyntaxError              ; return carry set for a comma
    or a
    ret nz                                  ; return an ordinary nonzero operator or atom character with carry clear
.setFlagForSyntaxError:
    scf                                     ; set carry to mark comma or closing parenthesis as a caller-visible boundary
    ret


convertInputCharacterToRadixDigit:
    push af
    ; move the original character into alternate AF so exact spelling can later be restored
    ex af,af'
    pop af
    sub 030h                                ; bias ASCII zero through nine to numeric values zero through nine
    cp 00ah                                 ; test whether the biased value is a decimal digit
    ret c
    sub 007h                                ; translate uppercase A through F toward numeric values ten through fifteen
    cp 00ah
    jr c,.returnInvalidRadixDigit
    cp 010h
    ret c
    sub 020h                                ; translate lowercase candidates toward the same numeric range
    cp 00ah
    jr c,.returnInvalidRadixDigit
    cp 010h
    jr nc,.returnInvalidRadixDigit           ; reject letters above lowercase f
    ; restore the original source character into primary AF for canonicalization
    ex af,af'
    sub 020h                                ; convert a lowercase hexadecimal spelling to uppercase text
    ; preserve that canonical source character in alternate AF
    ex af,af'
    ret c                                   ; return the normalized lowercase-origin digit with carry set
.returnInvalidRadixDigit:
    ; restore the original non-digit character for boundary/operator processing
    ex af,af'
    and a
    ret


normalizeIndexOperandClass:
    cp 01ah                                 ; recognize the IY descriptor paired with the first indexed operand class
    jr z,.convertIYClassToIXClass            ; map that descriptor to its common IX counterpart
    cp 01ch                                 ; recognize the IY descriptor paired with the second indexed operand class
    jr z,.convertIYClassToIXClass            ; map that descriptor to its common IX counterpart
    cp 01eh                                 ; recognize the IY descriptor paired with the third indexed operand class
    jr z,.convertIYClassToIXClass            ; map that descriptor to its common IX counterpart
    cp 02ah                                 ; recognize the IY descriptor used by an indexed memory expression
    jr z,.convertIYClassToIXClass            ; map that descriptor to its common IX counterpart
    cp 02fh                                 ; recognize the final IY indexed-displacement descriptor
    ret nz
.convertIYClassToIXClass:
    dec a
    push hl                                 ; preserve the caller's text pointer while recording prefix selection
    ld hl,varcUseIYPrefix+1                 ; address the self-modified IY-prefix flag used during instruction-record creation
    ld (hl),001h
    pop hl
    cp a                                    ; force Z to report that an index-class conversion occurred
    ret


; Classify an operand before instruction-table matching.
;
; Short strings are first compared with the register/condition operand table.
; Non-table text is classified as a generic expression, parenthesized address,
; or IX/IY displacement form.  normalizeIndexOperandClass maps IY forms onto
; the common IX descriptor family and separately records that the final source
; information byte must use FD rather than DD.
classifyOperandText:
    push hl                                 ; preserve the operand text start while its zero-terminated length is measured
    call lengthUpToZero                     ; measure the normalized operand spelling into B
    pop hl
    ld a,b
    or a
    ret z                                   ; return class zero for an absent operand
    cp 005h
    jr nc,.classifyNonRegisterOperand        ; classify longer spellings directly as expression-bearing operands
    push hl                                 ; preserve the operand start across compact length-bucket selection
    ld hl,operandLookupByLengthDescriptors
    call prepareLengthBucketLookup          ; resolve the candidate count and packed-word start for this exact length
    pop hl                                  ; restore the normalized operand text pointer
    call compareWithMnemonics
    ret nc                                  ; carry clear returns a fixed operand; carry set requests structural classification
.classifyNonRegisterOperand:
    ld a,(hl)
    cp "("
    ld a,02ch
    ret nz                                  ; return the generic direct-expression class when no opening parenthesis is present
    inc hl
    ld a,(hl)
    cp "i"
    jr nz,.returnGenericExpressionOperandClass ; fall back to a generic parenthesized address when it is not an index register
    inc hl
    ld a,(hl)
    cp "x"
    ld b,02eh
    jr z,.returnIndexDisplacementOperandClass ; accept IX and continue with displacement-sign validation
    cp "y"                                  ; recognize y as the alternate index-register spelling
    ld b,02fh
    jr nz,.returnGenericExpressionOperandClass ; fall back to a generic parenthesized address for any other i-prefixed text
.returnIndexDisplacementOperandClass:
    inc hl
    ld a,(hl)
    cp "+"                                  ; accept plus as a valid indexed-displacement form
    jr z,.returnRegisterOperandClass
    cp "-"                                  ; recognize minus as the only other valid indexed-displacement sign
.returnGenericExpressionOperandClass:
    ld a,02dh
    ret nz                                  ; return that generic indirect-expression class when the IX/IY sign test failed
.returnRegisterOperandClass:
    ld a,b
    ret


; Return the length of the zero-terminated string at HL in B.
;
; No maximum is enforced here; callers have already constrained their temporary
; buffers.  HL is advanced internally but callers that need the original pointer
; preserve it around this routine.
lengthUpToZero:
    xor a
    ld b,a
.countZeroTerminatedStringLoop:
    cp (hl)
    ret z                                   ; return when the end of the normalized field is reached
    inc hl
    inc b
    jr .countZeroTerminatedStringLoop


compareWithMnemonics:
; compare instructions with the table records (pointer in DE)
    push hl                                 ; preserve the candidate input-string start for retries against later packed words
.compareLookupWordCharacters:
    ld a,(de)                               ; read the current packed lookup-table character
    and 07fh
    cp (hl)                                 ; compare the normalized candidate character with the lookup character
; does the letter match?
    jr nz,.skipMismatchedLookupWord          ; skip this packed word immediately on a character mismatch
; letter matches, compare until the end of the word
    ld a,(de)                               ; reload the packed byte so its terminal high bit can be tested
    inc hl
    inc de
    and 080h                                ; isolate the high-bit word terminator from the matched packed byte
    jr z,.compareLookupWordCharacters        ; continue character-by-character until the terminal encoded byte matches
; all word corresponds, A will contain its index
    pop hl
    xor a
    ld a,c                                  ; return the current candidate index accumulated in C
    ret
.skipMismatchedLookupWord:
; the first letter does not match
; find the end of the word
    pop hl                                  ; restore the candidate input pointer before trying the next packed table word
.scanToLookupWordTerminatorLoop:
    ld a,(de)
    and 080h                                ; isolate the end-of-word marker without changing the packed table byte
    inc de
    jr z,.scanToLookupWordTerminatorLoop
    inc c                                   ; advance the logical candidate index for the next packed word
    djnz compareWithMnemonics
; no word found, set carry
    scf                                     ; set carry when no candidate in this exact-length bucket matched
    ret


; Compact length-bucket descriptors used before textual lookup.
; Each logical bucket is `(candidate count, byte offset into the self-relative
; reference vector)`. Several bytes intentionally disassemble as Z80 opcodes.
mnemonicLookupByLengthDescriptors:
    defw mnemonicsReferences                ; point mnemonic length buckets at the self-relative mnemonic reference vector
    defb 0x01                               ; encode the one-character bucket count as one special mnemonic
    ld bc,0020ch                            ; encode one-character start offset 1 and the two-character bucket as count 12, offset 2
    add hl,hl                               ; encode the three-character mnemonic bucket count as 41
    ld c,017h                               ; encode three-character offset 14 and four-character count 23
    scf                                     ; encode the four-character mnemonic bucket start offset as 55

operandLookupByLengthDescriptors:
    defw operandsReferences                 ; point operand length buckets at the self-relative operand reference vector
    defb 0x0c                               ; encode the one-character fixed-operand bucket count as 12
    add hl,bc                               ; encode the one-character fixed-operand start offset as 9
    rrca                                    ; encode the two-character fixed-operand bucket count as 15
    dec d                                   ; encode the two-character fixed-operand start offset as 21
    ld (bc),a                               ; encode the three-character fixed-operand bucket count as two
    inc h                                   ; encode the three-character fixed-operand start offset as 36
    ld b,026h                               ; encode the four-character bucket as count six and start offset 38


prepareLengthBucketLookup:
    ld a,b
    add a,a
    ld c,a                                  ; retain the descriptor byte offset in C
    xor a
    ld b,a                                  ; clear B so BC is the unsigned descriptor offset
    push hl                                 ; preserve the descriptor-table base while indexing its bucket pair
    add hl,bc                               ; advance to the selected `(count, vector offset)` pair
    ld b,(hl)
    inc hl                                  ; advance to the packed-word vector offset byte
    ld c,(hl)
    pop hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld h,a                                  ; clear H for an unsigned eight-bit vector offset
    ld l,c                                  ; move the bucket's vector offset into L
    add hl,de
    ld e,(hl)
    ld d,a
    add hl,de                               ; add the displacement to reach the packed word addressed by that reference
    ex de,hl                                ; exchange the resolved packed-word pointer into DE for compareWithMnemonics
    ret


; Field readers used by the source-line tokenizer.
;
; HL scans the editor buffer, DE receives a zero-terminated working string, and
; C is the remaining destination capacity.  The three entries differ only in
; their delimiter: space for label/mnemonic, comma for operand one, and NUL for
; operand two.  Outside quotes letters are normalized to lower case.  Quoted
; text is copied verbatim until its matching quote.  Buffer exhaustion is a
; syntax error rather than silent truncation.
readSourceFieldUntilSpace:
    ld b," "
    jr .readDelimitedFieldLoop
readFirstOperandUntilComma:
    ld b,","
    jr .readDelimitedFieldLoop
readSecondOperandToEnd:
    ld b,000h
.readDelimitedFieldLoop:
    ; the input buffer string ends with 1,0
    call atHLorNextIfOne                    ; read the current visible input byte while transparently skipping cursor marker $01
    cp "\""
    jr z,.storeQuotedFieldCharacter          ; copy the opening double quote without case folding or delimiter interpretation
    cp "'"
    jr z,.storeQuotedFieldCharacter
.testFieldDelimiter:
    cp b
    ret z
    ; skip spaces
    cp " "
    inc hl
    jr z,.readDelimitedFieldLoop
    ;
    dec hl
    or a
    jr nz,.storeLowercasedFieldCharacter
    inc a                                   ; convert zero to a nonzero return status distinguishing end-of-line from delimiter
    ; end of line
    ret
.storeLowercasedFieldCharacter:
    inc hl
    ; uppercase
    set 5,a                                 ; force alphabetic bit 5 so normalized source fields use lowercase spellings
    ; store
    ld (de),a                               ; store the normalized character in the selected temporary field buffer
    inc de
    ; decrease the characters counter and repeat if we still can read
    dec c
    jr nz,.readDelimitedFieldLoop
    ; else syntax error
    jr .fieldTooLongSyntaxError
.copyQuotedFieldCharacterLoop:
    call advanceInputPointerAndRead
    or a
    jr z,.testFieldDelimiter                 ; route end-of-line through the ordinary delimiter/end handling
    cp "\""
    jr z,.testFieldDelimiter
.storeQuotedFieldCharacter:
    ; store character and decrease characters counter
    ld (de),a
    inc de
    dec c
    jr nz,.copyQuotedFieldCharacterLoop
.fieldTooLongSyntaxError:
    jp syntaxError                          ; report syntax when normalized or quoted field text exceeds its fixed work buffer


advanceInputPointerAndRead:
    inc hl
atHLorNextIfOne:
    ld a,(hl)
    cp 001h
    ret nz
    inc hl
    ld a,(hl)
    ret


skipSpaces:
    call atHLorNextIfOne                    ; read the current visible byte while ignoring an intervening marker $01
    cp " "
    ret nz
    inc hl
    jr skipSpaces


; =============================================================================
; SHARED ASSEMBLER/MONITOR EDIT-LINE RENDERER
; =============================================================================
; repaintEditLine selects the assembler token-offset table and the fixed bottom
; bitmap row.  The monitor selects monitorTables and enters directly at
; renderInputLineAtBitmapAddress with its configurable panel edit-row address.
;
; The byte immediately before inputBufferStart is a guard used by the common
; pre-increment scanner.  Bytes below $80 are ordinary characters.  Bytes $80+
; index a compact token-offset table and expand to a high-bit-terminated word.
; Byte $01 is the movable cursor marker; byte $00 terminates the line.
;
; While scanning, the physical column after the currently rendered element is
; copied to varcInputColumnAfterCursor.  When the marker is encountered its
; address becomes varcInputBufferPosition and a cursor glyph is drawn.  Scanning
; then continues to the zero terminator so the patched column reflects the
; position immediately after that glyph.
repaintEditLine:
    ld hl,l96a4-1
    ld (varcTokenExpansionTableBase+1),hl   ; select assembler token expansion for the bottom edit row
    ld hl,BOTTOM_LINE_VRAM_ADDRESS
renderInputLineAtBitmapAddress:
    call clearLineAtHL
    ld hl,inputBufferGuardByte
.renderNextInputBufferElement:
    inc hl                                  ; next element for tracking cursor column and decoding the next input-buffer byte
    ld a,(varcPrintingPosition+1)
    and 01fh                                ; retain only 01fh bits that control how routines track cursor column and decoding the next input-buffer byte
    ld (varcInputColumnAfterCursor+1),a     ; patch varc input column after cursor+1 to track cursor column and decoding the next input-buffer byte
    ld a,(hl)
    dec a
    jr z,.renderInputCursorMarker
    inc a                                   ; next element for tracking cursor column and decoding the next input-buffer byte
    ret z
    call displayInputTokenOrCharacter
    jr .renderNextInputBufferElement
.renderInputCursorMarker:
    ld (varcInputBufferPosition+1),hl       ; patch varc input buffer position+1 to record the cursor-marker address and draw its CAPS-state glyph
    push hl
    ld a,(varcCapsLockEnabled+1)
    add a,0cch                              ; record the cursor-marker address and draw its CAPS-state glyph
    call displayNormalCharacter
    pop hl
    jr .renderNextInputBufferElement


; Clear one complete 32-character bitmap text row.
;
; clearLine converts Spectrum character-row C into a bitmap address through the
; ROM pixel-address helper.  clearLineAtHL also installs that address as the next
; printing position.  clearBitmapTextRow writes 32 zero bytes in each of the
; eight pixel planes by incrementing H, which follows the Spectrum's interleaved
; bitmap layout for one character row.  Attributes are intentionally untouched.
clearLine:
    ld c,000h
    call ROM_PixelAddress_22b0
clearLineAtHL:
    ld (varcPrintingPosition+1),hl          ; patch varc printing position+1 to install the row origin as the text cursor before clearing
clearBitmapTextRow:
    ld b,008h
.clearNextBitmapPlaneRow:
    push hl                                 ; preserve HL while clear one 32-byte pixel plane while preserving its origin
    ld c,020h
.clearThirtyTwoBitmapBytesLoop:
    ld (hl),000h
    inc l
    dec c
    jr nz,.clearThirtyTwoBitmapBytesLoop
    pop hl
    inc h
    djnz .clearNextBitmapPlaneRow
    ret


; Obtain one normalized key code, converting ordinary letters to lower case.
;
; processKey performs matrix scanning, modifier translation, CAPS LOCK case
; inversion, debounce, click/beep feedback and held-key repeat.  readKeyCode is
; the monitor-facing wrapper: it protects the alternate register bank used by
; monitor code and then forces letters to lower case for command dispatch.
readKeyCode:
    exx
    call processKey
    exx
    call isLetter
    ret nz
    or 020h                                 ; decide whether to obtain a normalized monitor command key while preserving alternate registers
    ret

.advanceHeldKeyRepeatCounter:
varcHeldKeyRepeatScanCounter:
    ld hl,00000h
    inc hl
    ld (varcHeldKeyRepeatScanCounter+1),hl  ; patch varc held key repeat scan counter+1 to load and update the persistent repeat-delay counter
    ld a,h
    cp 005h
    jr nz,processKey
varcRepeatedKeyCode:
    ld a,00dh
    jr .acceptNormalizedKeyAndBeep
.waitForStableKeyPress:
    ; number of repeats when keypress is not detected
    ld h,002h
.keyReleaseDebounceLoop:
    call getKeypressCodeOrZero
    ; keypress detected again?
    jr nz,.resetKeyRepeatStateAndRescan
    ; keypress still not detected
    dec hl
    inc h
    dec h
    jr nz,.keyReleaseDebounceLoop
    call resetLastPressedKeyComparison
.resetKeyRepeatStateAndRescan:
; some key was pressed
    ld hl,00000h
    ld (varcHeldKeyRepeatScanCounter+1),hl  ; patch varc held key repeat scan counter+1 to clear repeat timing and restart normalized key processing

; Normalize one Spectrum keyboard event and implement autorepeat.
;
; ROM_KeyboardScanning returns a key-table index in E and a modifier class in D.
; Ordinary keys use the ROM key tables.  CAPS SHIFT maps digits to editor control
; codes and changes letter case; SYMBOL SHIFT uses symbolCharacters, except that
; on an otherwise empty input line SYMBOL SHIFT+letter may become a tokenized
; command code with bit 7 set.  varcCapsLockEnabled inverts the resulting case of
; letters, matching the manual's nonstandard CAPS LOCK description.
;
; Two self-modified bytes retain repeat state.  A newly accepted key is clicked,
; delayed, and remembered in varcRepeatedKeyCode.  Repeated sightings increment
; varcHeldKeyRepeatScanCounter; only after its high byte reaches five is the key
; emitted again.  A release interval resets the comparison byte before another
; key is accepted.  These counters are timing loops, not real-time clocks.
processKey:
    call getKeypressCodeOrZero
    jr z,.waitForStableKeyPress
    ; bc = e
    ld b,000h
    ld c,e
    ld a,e
    ld (varcLastPressedKey+1),a             ; remember the translated key for repeat handling
    ld hl,ROM_Key_Tables-1
    ld a,d
    ; SS + something
    cp 019h
    jr z,.keyCombinationWithSS
    add hl,bc                               ; translate ROM key indices, modifiers, CAPS LOCK and repeat state into one key code
    ; get ASCII code related to the key
    ld a,(hl)
    ; space
    cp 020h
    ld b,a
    jr c,.compareLastPressedKey
    ld a,d
    ; CS + something
    cp 028h
    ld a,b
    ; lowercase
    set 5,a                                 ; translate ROM key indices, modifiers, CAPS LOCK and repeat state into one key code
    jr nz,.applyCapsLockCaseInversion
    call isNumber
    jr nz,.uppercaseCapsShiftLetter
    sub 02dh
    jr .compareLastPressedKey
.uppercaseCapsShiftLetter:
    call isLetter
    jr nz,.applyCapsLockCaseInversion
    ; uppercase
    res 5,a                                 ; uppercase a CAPS SHIFT letter while leaving nonletters unchanged
.applyCapsLockCaseInversion:
    ld b,a
varcCapsLockEnabled:
    ld a,000h
    or a
    ld a,b
    jr z,.compareLastPressedKey
    call isLetter
    jr nz,.compareLastPressedKey
    ld a," "
    xor b
.compareLastPressedKey:
    ld b,a
    or a
    jr z,processKey
    cp 080h
    jr z,processKey
    ld b,a
varcLastPressedKey:
    ld a,022h
varcLastPressedKeyComparisonValue:
    cp 022h
    ld (varcLastPressedKeyComparisonValue+1),a ; patch varc last pressed key comparison value+1 to compare and update the previous normalized-key state
    ld a,b
    jp z,.advanceHeldKeyRepeatCounter
.acceptNormalizedKeyAndBeep:
    push af                                 ; preserve AF while acknowledge a new/repeated key and establish repeat delays
    call keypressBeep
    pop af
    ld h,014h
.initialKeyRepeatDelayLoop:
    dec hl
    inc h
    dec h
    jr nz,.initialKeyRepeatDelayLoop
    bit 7,a                                 ; option bit selects how to provide the initial held-key delay
    ld (varcRepeatedKeyCode+1),a            ; store the key code used by autorepeat
    ret z
    ld h,04eh
.extendedKeyRepeatDelayLoop:
    dec hl
    inc h
    dec h
    jr nz,.extendedKeyRepeatDelayLoop

resetLastPressedKeyComparison:
    ld hl,varcLastPressedKeyComparisonValue+1
    ld (hl),000h
    ret


; Low-level wrapper around ROM_KeyboardScanning.
;
; Returns the raw key index in E and modifier class in D.  A is zero when no
; usable key is present or when the scan reports only a standalone SHIFT key;
; otherwise A is nonzero.  The arithmetic tests for E=$FF, SYMBOL SHIFT and CAPS
; SHIFT are inherited directly from the Spectrum ROM scanning convention.
getKeypressCodeOrZero:
; get code of a pressed key in E. A is 0 if no key or a special key (SS or CS) was pressed
    push hl                                 ; preserve HL while wrapping the ROM matrix scanner while rejecting modifier-only states
    call ROM_KeyboardScanning
    pop hl
    jr z,.filterModifierOnlyKeypress
    xor a
    ret
.filterModifierOnlyKeypress:
    ld a,e
    inc e                                   ; next element for distinguishing no key, standalone shifts and a usable key index
    ret z
    inc d                                   ; next element for distinguishing no key, standalone shifts and a usable key index
    ret nz
; any key pressed
    ld a,e
; SS pressed?
    sub 019h                                ; distinguish no key, standalone shifts and a usable key index
    ret z
; CS pressed?
    sub 00fh                                ; distinguish no key, standalone shifts and a usable key index
    ret


.keyCombinationWithSS:
; a key in combination with SS was pressed
    ex de,hl
    ld a,c
; was SS+O pressed? (";", start of a comment)
    cp 01bh
    jr z,.standardKeyPlusSSPressed
; are we on the beginning of the line so commands can be accecpted?
    ld hl,inputBufferStart
    ld a,(hl)
    dec a
    jr nz,.standardKeyPlusSSPressed
    inc hl
    or (hl)                                 ; decide whether to translate SYMBOL SHIFT into command tokens or symbol characters
    jr nz,.standardKeyPlusSSPressed
    ex de,hl
    add hl,bc                               ; translate SYMBOL SHIFT into command tokens or symbol characters
    ld a,(hl)
    call isLetter
    jr nz,.standardKeyPlusSSPressed
    set 7,a                                 ; translate SYMBOL SHIFT into command tokens or symbol characters
    jr .compareLastPressedKey
.standardKeyPlusSSPressed:
    ld hl,symbolCharacters-1
    add hl,bc                               ; look up the ordinary SYMBOL SHIFT character
    ld a,(hl)
    jr .compareLastPressedKey

symbolCharacters:
     defb "*", "^", "[", "&", "%", ">", "}", "/", ",", "-"
     defb "]", "'", "$", "<", "{", "?", ".", "+", 0x7f, "("
     defb "#", 0x00, "\\", "`", 0x00, "=", ";", ")", "@", 0x14
    ; Final ten SYMBOL SHIFT translation bytes; the embedded semicolon and quote make a trailing source comment ambiguous.
     defb "|", ":", " ", 0x0d, """, "_", "!", 0x15, "~", 0x00


keypressBeep:
    ; beep length
    ;   reasonable values: 1-30
configurationPatchTarget03KeypressBeepDuration: equ $+1 ; @config-patch 03
    ld e,00ah                         ; floppy version uses a shorter key click
    jr .beepLengthE

beep:
    ld e,000h
.beepLengthE:
    ld hl,0012ch
    ; set border color
configurationPatchTarget10KeypressBeepBorderColor: equ $+1 ; @config-patch 10
    ld a,007h                         ; floppy version starts from the unbright border/speaker state
.beepToggleLoop:
    ld b,e
    xor 010h
.beepPulseDelayLoop:
    out (0feh),a                            ; drive the ULA output state needed to hold one speaker phase for the selected delay
    djnz .beepPulseDelayLoop
    dec hl
    inc h
    dec h
    jr nz,.beepToggleLoop

isNumber:
    cp "0"
    ret c
    cp "9"
    ret nc
    cp a
    ret


isLetter:
; ignore if the command key is not in a-z or A-Z
    cp "A"
    ret c
    cp "z"
    ret nc
    cp "Z"+1
    jr c,.returnCharacterIsLetter
    cp "a"
    ret c
.returnCharacterIsLetter:
    cp a
    ret


displaySpaceSafely:
    ld a," "
    jr displayCharacterSafely
displayCharacterAtHL:
    ld a,(hl)
    and 07fh                                ; retain only 07fh bits that control how routines fetch and mask one packed character before safe rendering
displayCharacterSafely:
    exx
    call displayCharacter
    exx
    ret


; Render either one character or one compact token.
;
; A<$80 is displayed directly with inversion removed.  A>=$80 indexes the
; currently selected offset table at varcTokenExpansionTableBase.  The table byte
; is a relative offset from its own entry to a packed word whose final character
; has bit 7 set.  The word is rendered character by character and followed by one
; space.  HL and DE are preserved so callers can continue scanning input text.
displayInputTokenOrCharacter:
    cp 080h
    jr c,displayUninvertedCharacter
    push hl                                 ; preserve HL while rendering an ordinary byte or expand a compact token
    push de                                 ; preserve DE while rendering an ordinary byte or expand a compact token
varcTokenExpansionTableBase:
    ld hl,l96a4-1                     ; symbolic rebasing replaces the historical fixed absolute word
    ld d,000h
    ld e,a
    add hl,de                               ; select the caller-specific token-offset table
    ld e,(hl)
    add hl,de                               ; select the caller-specific token-offset table
.displayExpandedTokenCharactersLoop:
    ld a,(hl)
    inc hl
    push af                                 ; preserve AF while rendering one packed token word through its high-bit terminator
    call displayUninvertedCharacter
    pop af
    rlca
    jr nc,.displayExpandedTokenCharactersLoop
    pop de
    pop hl
displaySpace:
    ld a," "
displayUninvertedCharacter:
    res 7,a                                 ; remove inverse-video selection before normal text output
; Render A at the current bitmap cursor and assign its attribute cell.
;
; displayCharacter writes the eight glyph rows and advances the bitmap cursor.
; The returned bitmap high byte is then converted to the corresponding $5800-
; $5AFF attribute row by adding $0A and, where necessary, repeated $07 steps.
; varcTextColor supplies the attribute value.  The conversion works for all
; three Spectrum bitmap thirds without calling a ROM printing routine.
displayNormalCharacter:
    exx
    call displayCharacter
    ld a,h
    add a,00ah                              ; render a glyph and assign the corresponding attribute cell
    cp 05ah
    jr z,.storeTextAttribute
.mapBitmapRowToAttributeRowLoop:
    add a,007h                              ; map an interleaved bitmap high byte into attribute memory
    cp 058h
    jr c,.mapBitmapRowToAttributeRowLoop
.storeTextAttribute:
    ld h,a
varcTextColor:
configurationPatchTarget06GenericTextAttribute: equ $+1 ; @config-patch 06
    ld (hl),038h
    exx
    ret


; Low-level 8x8 glyph renderer.
;
; A bit 7 selects inverse video.  The low seven bits are transformed into an
; eight-byte ROM-font address.  Each glyph row is optionally ORed with itself by
; the self-modified font-thickness instruction (NOP for normal, OR (HL) for the
; bold installation option), XORed with the inversion mask, and stored through
; the interleaved bitmap planes.
;
; varcPrintingPosition is advanced one byte horizontally.  When L wraps, H is
; advanced to the next Spectrum bitmap text row, with $58 wrapping back to $40.
; The routine does not modify attributes; displayNormalCharacter does that in a
; separate step.
displayCharacter:
    add a,a                                 ; derive a ROM glyph, render eight scanlines and advance the bitmap cursor
    ld h,00fh
    ld l,a
    sbc a,a                                 ; derive a ROM glyph, render eight scanlines and advance the bitmap cursor
    ld c,a
    add hl,hl                               ; derive a ROM glyph, render eight scanlines and advance the bitmap cursor
    add hl,hl                               ; derive a ROM glyph, render eight scanlines and advance the bitmap cursor
varcPrintingPosition:
    ld de,SECOND_LINE_ADDRESS
    push de
    ld b,008h
.renderEightGlyphRowsLoop:
    ld a,(hl)
    ; font modifier:
    ;   0 - normal
    ;  15 - bold
configurationPatchTarget01CharacterBoldTransform: ; @config-patch 01
    nop
    or (hl)
    xor c
    ld (de),a
    inc hl
    inc d
    djnz .renderEightGlyphRowsLoop
    pop hl
    push hl
    inc l
    jr nz,.commitNextCharacterBitmapPosition
    ld a,h
    add a,008h                              ; apply bold/inverse transforms and write one glyph scanline
    cp 058h
    jr nz,.storeWrappedBitmapRowHighByte
    ld a,040h
.storeWrappedBitmapRowHighByte:
    ld h,a
.commitNextCharacterBitmapPosition:
    ld (varcPrintingPosition+1),hl          ; patch varc printing position+1 to persist the next character cursor while restoring the caller's HL
    pop hl
    ret


; -----------------------------------------------------------------------------
; Normalize an identifier and search the ordinal vector table
; -----------------------------------------------------------------------------
; Starting at HL, accept at most eight letters, digits, or underscores.  Letters
; are normalized to uppercase.  The final stored character is tagged with bit 7
; so names require no length byte in the persistent table.  A temporary length
; byte is retained only in numberStringBuffer for comparison/insertion.
;
; The vectors are searched from the highest ordinal down.  On success carry is
; clear and HL is the one-based ordinal.  On failure carry is set; the normalized
; temporary spelling remains available to findOrCreateSymbolOrdinal.
parseSymbolNameAndFindOrdinal:
    ld de,numberStringBuffer+1
    ld b,000h                               ; clear the temporary symbol-name length
.collectNormalizedSymbolNameLoop:
    call atHLorNextIfOne                    ; fetch the visible source byte while transparently skipping the editor cursor marker
    call isNumber                           ; classify an unchanged decimal digit as a valid identifier character
    jr z,.storeNormalizedSymbolCharacter     ; append a digit immediately when numeric classification succeeds
    ; uppercase
    res 5,a                                 ; clear ASCII bit 5 so a possible letter is normalized to uppercase
    cp "_"
    jr z,.storeNormalizedSymbolCharacter
    call isLetter
    jr nz,.finishNormalizedSymbolName        ; finish the name at the first byte outside letter, digit, or underscore
.storeNormalizedSymbolCharacter:
    ld (de),a
    inc de
    inc hl
    inc b
    ld a,b
    cp LABEL_LENGTH
    jr c,.collectNormalizedSymbolNameLoop    ; collect another character while the maximum has not been exceeded
    jp syntaxError
.finishNormalizedSymbolName:
    ld a,b
    ld (numberStringBuffer),a
    dec de
    ex de,hl
    set 7,(hl)
varcSymbolTablePt:
    ld hl,symbolTableDefaultPt
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    push de
    ex de,hl                                ; move the count into HL while retaining the first-vector address in DE
    inc hl
    add hl,hl
    add hl,de
    ld (varcSymbolEntryAreaBase+1),hl       ; set the entry-area anchor used by name lookup and insertion
    dec hl
    dec hl
    ld (varcNewSymbolVectorSlot+1),hl       ; set the ordinal-vector slot opened for the new symbol
    pop bc
    jr .continueSymbolOrdinalSearch
.searchSymbolVectorsBackward:
    push bc                                 ; preserve the current candidate ordinal while its vector is resolved
    dec hl
    ld a,(hl)
    and 03fh                                ; remove DEFINED and LOCKED bits from the stored name offset
    ld d,a
    dec hl                                  ; step to the vector offset low byte
    ld e,(hl)
    push hl                                 ; preserve the vector position while the candidate spelling is compared
varcSymbolEntryAreaBase:
    ld hl,00000h
    add hl,de                               ; add the candidate vector offset to locate its persistent name
    ld de,numberStringBuffer
    ld a,(de)
    ld b,a
    inc de
.compareCandidateSymbolNameLoop:
    ld a,(de)
    cp (hl)
    jr nz,.candidateSymbolNameMismatch
    inc hl
    inc de
    djnz .compareCandidateSymbolNameLoop
    pop af
    pop hl
    xor a
    ret
.candidateSymbolNameMismatch:
    pop hl
    pop bc
    dec bc
.continueSymbolOrdinalSearch:
    ld a,b
    or c
    jr nz,.searchSymbolVectorsBackward       ; resolve the next lower vector while a candidate remains
    scf                                     ; set carry to report that no existing spelling matched
    ret


; -----------------------------------------------------------------------------
; Return an existing symbol ordinal or insert a new alphabetically sorted entry
; -----------------------------------------------------------------------------
; Existing symbols return immediately.  For a new symbol the routine:
;   1. reserves two bytes for a new ordinal vector;
;   2. locates the alphabetical insertion point in the value/name area;
;   3. inserts two placeholder value bytes followed by the high-bit-terminated
;      normalized name;
;   4. increments the table count;
;   5. adjusts all vector offsets affected by the inserted name bytes; and
;   6. stores the new vector and returns its one-based ordinal in HL.
;
; Source records therefore never retain a direct address.  Alphabetical movement
; changes vector offsets, while the ordinal encoded in source remains stable.
findOrCreateSymbolOrdinal:
    call parseSymbolNameAndFindOrdinal      ; normalize the source spelling and search for its stable ordinal
    ret nc                                  ; return immediately when an existing symbol cleared carry
varcCodeEndPt:
    ld hl,codeEndDefaultPt
    ld bc,0000ch
    call ensureBCBytesFitBelowUTop
varcNewSymbolVectorSlot:
    ld de,00000h
    xor a
    sbc hl,de
    ld b,h
    ld c,l
    ld h,d
    ld l,e
    inc de
    inc de
    call moveMemoryBlockOverlapSafe
    ld hl,varcCodeEndPt+1                   ; address the stored code-end pointer operand
    call increaseAtHLByTwo
    ld hl,(varcSymbolTablePt+1)             ; reload the current symbol-table base
    ld c,(hl)
    inc hl
    ld b,(hl)
    ld hl,(varcSymbolEntryAreaBase+1)       ; load the pre-growth first-name anchor used to scan sorted records
    jr .continueNameInsertionSearch
.chooseCurrentSymbolInsertionPoint:
    pop hl
    pop af
    jr .insertNewSymbolEntry
.scanSortedSymbolNamesForInsertion:
    push bc
    push hl
    inc hl
    ld de,numberStringBuffer+1              ; address the first temporary normalized name character
.compareNewNameWithStoredName:
    inc hl
    ld c,(hl)
    res 7,c
    ld a,(de)
    and 07fh
    cp c
    jr c,.chooseCurrentSymbolInsertionPoint  ; choose this record when the new spelling is lexically smaller
    jr nz,.skipStoredSymbolName              ; skip this record when the new character is lexically greater
    ld a,(de)
    and 080h
    jr nz,.chooseCurrentSymbolInsertionPoint ; insert here when the new name is a prefix of the stored spelling
    bit 7,(hl)
    jr nz,.skipStoredSymbolName
    inc de
    jr .compareNewNameWithStoredName
.skipStoredSymbolName:
    bit 7,(hl)
    inc hl
    jr z,.skipStoredSymbolName
    pop af
    pop bc
    dec bc
.continueNameInsertionSearch:
    ld a,b
    or c
    jr nz,.scanSortedSymbolNamesForInsertion ; compare the next physical value/name record while one remains
.insertNewSymbolEntry:
    push hl                                 ; preserve the selected physical insertion point for new-vector offset derivation
    ex de,hl
    ld hl,(varcCodeEndPt+1)                 ; current end of combined source and symbol data
    xor a
    sbc hl,de
    ex de,hl                                ; retain that trailing length in DE while restoring HL to the insertion point
    push hl
    ld b,a                                  ; clear the high byte used to form the small entry length
    ld a,(numberStringBuffer)               ; load the normalized symbol-name length
    add a,002h
    ld c,a
    push bc                                 ; preserve the entry length across opening the sorted-data gap
    push hl
    add hl,bc                               ; calculate the destination immediately above the new entry-sized gap
    ld b,d
    ld c,e
    ex de,hl
    pop hl
    call moveMemoryBlockOverlapSafe
    pop bc
    ld hl,varcCodeEndPt+1                   ; address the stored code-end pointer operand
    call increaseAtHLbyBC
    pop de
    ld hl,symbolEntryCreationPrefix
    ld (hl),000h
    push bc                                 ; preserve the entry size across copying the staged symbol record
    call moveMemoryBlockOverlapSafe
    ld hl,(varcSymbolTablePt+1)             ; reload the symbol-table base containing the sixteen-bit symbol count
    call increaseAtHL
    pop bc
    dec de
    ex de,hl
    ex (sp),hl                              ; recover the saved insertion point while retaining repair-loop state on the stack
    ld de,(varcSymbolEntryAreaBase+1)       ; load the old first-name anchor
    xor a                                   ; clear carry before deriving the new entry's vector offset
    sbc hl,de
    ex de,hl                                ; retain the new symbol's offset in DE while restoring the anchor in HL
    inc hl
    inc hl
    ld (varcSymbolEntryAreaBase+1),hl       ; set the first-name anchor after vector expansion
    dec hl
    dec hl
    ld ix,(varcSymbolTablePt+1)             ; start vector traversal at the symbol-table base
    ex (sp),hl                              ; exchange the prepared repair state with the saved stack value
    jr .testMoreVectorOffsetsToAdjust
.adjustExistingVectorOffsetsForInsertedName:
    call advanceSymbolVectorAndLoadOffset
    sbc hl,de                               ; compare that existing offset with the new entry's insertion offset
    jr c,.advanceVectorOffsetAdjustment      ; leave vectors before the inserted record unchanged
    push de                                 ; preserve the new-entry offset across an in-place vector update
    push ix
    pop hl                                  ; complete the IX-to-HL transfer through the stack
    call increaseAtHLbyBC                   ; add the inserted value/name byte count to this displaced vector offset
    pop de                                  ; restore the new-entry offset for the next comparison
.advanceVectorOffsetAdjustment:
    ex (sp),hl                              ; exchange vector scratch state with the repair-loop state retained on the stack
    dec hl
.testMoreVectorOffsetsToAdjust:
    ld a,h
    or l
    ex (sp),hl
    jr nz,.adjustExistingVectorOffsetsForInsertedName ; repair the next existing vector while the loop state is nonzero
    pop hl
    ld (ix+002h),e                          ; store the new symbol vector offset low byte in the appended ordinal slot
    ld (ix+003h),d                          ; store the clean offset high byte with both state flags initially clear
    ld hl,(varcSymbolTablePt+1)             ; reload the symbol-table base
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ret


closeDeletedSymbolDataGap:
    push hl
    ld hl,(varcCodeEndPt+1)                 ; locate the current high end of source and symbol data
    and a
    sbc hl,de
    ld b,h
    ld c,l
    ex de,hl
    pop de
; memmove-style primitive.
;
; Entry: HL=source, DE=destination, BC=length.
; Uses LDIR when destination is below source and LDDR when an upward move would
; overlap.  A zero length is a no-op.  This routine is central to both source
; insertion and deletion.
moveMemoryBlockOverlapSafe:
    ld a,b
    or c
    ret z                                   ; leave memory unchanged for an empty range
    push hl
    xor a
    sbc hl,de
    pop hl
    jr c,.moveMemoryBlockBackward            ; use reverse copying when an upward move would overlap
    ldir                                    ; copy forward when destination is below source
    ret
.moveMemoryBlockBackward:
    add hl,bc
    dec hl
    ex de,hl
    add hl,bc
    dec hl
    ex de,hl
    lddr                                    ; copy backward to preserve overlapping data
    ret


; Format HL into a zero-terminated printable number.
;
; varcHexMode selects decimal or `#`-prefixed hexadecimal output.  Digits are
; generated by repeated subtraction of fixed divisors.  C bit 0 controls leading
; zero suppression: general numbers suppress zeroes until the first nonzero
; digit, while fixed-width byte-listing callers clear C and therefore obtain
; exactly two hexadecimal or three decimal digits.  A-F are produced by adding
; the ASCII gap after `9`.
printNumberToStringBuffer:
    ld c,000h                               ; enable leading-zero suppression for general 16-bit formatting
    ld ix,numberStringBuffer
printNumberToIX:
varcHexMode:
    ; 0 - dec, 1 - hex
    ld a,000h
    or a
    jr z,printDecNumberToIX                 ; branch to decimal formatting when hexadecimal mode is disabled
printHexNumberToIX:
    ld (ix+000h),"#"
    inc ix
    ld de,01000h
    call storeNumberOrderToIX
    ld d,001h
    call storeNumberOrderToIX               ; derive and append the hundreds hexadecimal digit before the shared byte tail
; Format the low byte in HL as exactly two hexadecimal digits.
;
; The caller has already emitted `#`.  Divisors 16 and 1 produce the high and low
; nibbles.  C=0 in memory-list callers prevents leading-zero suppression.
printTwoDigitHexByteToIX:
    ld de,00010h
    call storeNumberOrderToIX
    jr .formatUnitsDigit
printDecNumberToIX:
    ld de,10000
    call storeNumberOrderToIX
    ld de,1000
    call storeNumberOrderToIX
; Format the low byte in HL as exactly three decimal digits.
;
; Divisors 100, 10, and 1 are used.  With C=0 this yields 000..255, which is the
; fixed-width representation required by the five-byte numeric memory listing.
printThreeDigitDecimalByteToIX:
    ld de,100
    call storeNumberOrderToIX
    ld e,10
    call storeNumberOrderToIX
.formatUnitsDigit:
    ld e,001h
    ld c,000h
storeNumberOrderToIX:
    ; HL - number
    ; DE - divisor
    ld a,-1
.countDigitByRepeatedSubtraction:
    inc a
    and a
    sbc hl,de
    jr nc,.countDigitByRepeatedSubtraction
    add hl,de
    bit 0,c
    jr z,.emitNumericDigit
    or a                                    ; test the derived digit value
    ret z                                   ; suppress a leading zero in general-width output
.emitNumericDigit:
    res 0,c
    add a,"0"                               ; convert digit 0-9 to ASCII
    cp "9"+1
    jr c,.storeFormattedDigitAndTerminate
    ; skip 7 characters in the ASCII table
    add a,"A"-("9"+1)                       ; translate hexadecimal values 10-15 to ASCII A-F
.storeFormattedDigitAndTerminate:
    call storeAtIXAndMoveToNext
    ld (ix+000h),000h                       ; maintain a zero terminator after the newly appended digit
    ret


storeAtIXMoveToNextAndIncB:
    inc b
storeAtIXAndMoveToNext:
    ld (ix+000h),a
    inc ix
    ret


; HL points to a stored 16-bit source-related pointer.  If its value is at or
; above varcInsertionPointForPointerAdjustment, add BC so it follows the memory
; block shifted upward by an insertion.
adjustPointerAtHLIfAtOrAfterInsertion:
    push hl
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
varcInsertionPointForPointerAdjustment:
    ld de,defaultPointerAdjustmentSentinel
    and a
    sbc hl,de
    pop hl
    ret c
    jr increaseAtHLbyBC


increaseAtHLByTwo:
    ld bc,00002h
    jr increaseAtHLbyBC

increaseAtHL:
    ld bc,00001h
increaseAtHLbyBC:
    ; (hl) = (hl) + bc
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    add hl,bc
.atDEminusOnePutHLAndRet:
    ex de,hl
    ld (hl),d
    dec hl
    ld (hl),e
    ret


; Delete BC compressed records beginning at HL.
;
; 1. Walk BC records to find the byte address immediately after the range.
; 2. Move the remaining source/symbol bytes downward over the deleted bytes.
; 3. Clear the vacated high-address bytes.
; 4. Adjust block boundaries that lay after/inside the removed range.
; 5. Subtract the removed byte count from code-end and symbol-table pointers.
;
; varcDeletionStartForPointerAdjustment stores the low boundary for the pointer
; fix-up phase.  The routine works in bytes even though its public count is in
; compressed source records.
deleteSourceLinesAtHL:
    push hl
    ld (varcDeletionStartForPointerAdjustment+1),hl ; set the lower boundary for moving-pointer repair
    push bc
.findEndOfDeletedLineRangeLoop:
    call getNextSourceRecord
    dec bc
    ld a,b
    or c
    jr nz,.findEndOfDeletedLineRangeLoop
    pop bc
    pop de
    push hl
    and a
    sbc hl,de
    ld b,h
    ld c,l
    pop hl
    push bc
    push de
    push hl
    ld hl,(varcCodeEndPt+1)                 ; load the moving high end of combined source/symbol data
    and a
    pop de
    sbc hl,de
    ex de,hl
    ld b,d
    ld c,e
    pop de
    call moveMemoryBlockOverlapSafe
    pop bc
    push bc
.clearVacatedSourceBytesLoop:
    xor a
    ld (de),a
    inc de
    dec bc
    ld a,b
    or c
    jr nz,.clearVacatedSourceBytesLoop       ; clear the complete vacated range
    pop bc
    ld hl,varcSelectedBlockStart+1          ; select the first stored block boundary
    call adjustPointerAtHLForDeletion       ; clamp or shift it according to the deleted range
    ld hl,varcSelectedBlockEnd+1            ; select the second stored block boundary
    call adjustPointerAtHLForDeletion
    ld hl,varcCodeEndPt+1                   ; select the combined source/symbol end pointer
    call subtractBCFromPointerAtHL
    ld hl,varcSymbolTablePt+1               ; select the symbol-table base pointer
subtractBCFromPointerAtHL:
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    and a
    sbc hl,bc
    jr .atDEminusOnePutHLAndRet


adjustPointerAtHLForDeletion:
    push hl
    ld e,(hl)
    inc hl
    ld d,(hl)
varcDeletionStartForPointerAdjustment:
    ld hl,09c28h                            ; patched deletion start
    and a
    sbc hl,de
    pop hl
    ret nc
    jr subtractBCFromPointerAtHL


; Common LOAD/GENS setup.
;
; Force INSERT mode, parse/reuse the filename, find a matching CODE block, check
; capacity, and load it into temporary high memory.  PROMETHEUS LOAD then uses
; sourceLength and the imported symbol table.  GENS ignores those native metadata
; fields and consumes the staged payload as line-numbered CR-terminated text.
prepareTapeSourceImport:
    xor a
    ld (varcInsertMode+1),a                 ; force imported records to insert rather than overwrite the active line
    call readFileNameWithColon
    call loadMatchingCodePayloadToTemporaryMemory

printStatusBarWithWaitPlease:
    ld a,MESSAGE_WAIT_PLEASE
; Render the editor status row.
;
; signalMessage prints the selected message at the beginning of the row.  The
; printing cursor is then moved to STATUS_BAR_MODE_POSITION and the current
; INSERT/OVERWRITE letter is emitted, followed by the current combined
; source/symbol end address and U-TOP in the selected decimal/hexadecimal mode.
printStatusBar:
    ; prints the status bar with the message index in A
    call signalMessage                      ; render the selected status/error message at the start of the row
    ld a,STATUS_BAR_MODE_POSITION
    ld (varcPrintingPosition+1),a           ; patch the shared print cursor's column byte
    ld a,(varcInsertMode+1)                 ; load the self-modified INSERT/OVERWRITE mode
    or a
    ld a,"O"
    jr nz,.displayInsertOverwriteModeCharacter ; retain `O` when the mode flag is nonzero
    ld a,"I"                                ; otherwise select the insert-mode glyph
.displayInsertOverwriteModeCharacter:
    call displayCharacterSafely             ; render the mode letter without exposing alternate-register use
    ; print code ending address
    ld hl,(varcCodeEndPt+1)                 ; current combined source/symbol end address
    call displaySpaceThenCurrentRadixNumber
    ; print U-Top address
    ld hl,(varcUTop+1)                      ; current U-TOP memory boundary
displaySpaceThenCurrentRadixNumber:
    call displaySpaceSafely
    call printNumberToStringBuffer          ; format HL into the shared zero-terminated number buffer
    ld hl,numberStringBuffer

displayCharactersAtHLUntil0Character:
    ld a,(hl)
    or a
    ret z
    call displayCharacterAtHL               ; display the current byte while preserving the scanner register bank
    inc hl
    jr displayCharactersAtHLUntil0Character


; Compare HL with sourceBufferAccessLine while preserving HL and DE.  Carry set
; means HL is below the permanent source-buffer start.
compareHLWithSourceBufferStart:
    push hl
    push de
    ld de,sourceBufferAccessLine
    and a
    sbc hl,de
    pop de
    pop hl                                  ; restore the candidate pointer while retaining flags
    ret


comparePositionWithCodeEnd:
    ; HL=HL+12-varcSymbolTablePt
    ; in most cases interest in carry (<=0)
    push hl
    push de
    ; probably LINES_BEFORE_ACCESS_LINE-1
    ld de,0000ch
    add hl,de                               ; convert the candidate to the symbol-table comparison basis
    ld de,(varcSymbolTablePt+1)             ; current symbol-table base
    ; reset carry
    and a
    sbc hl,de
    pop de
    pop hl                                  ; restore the candidate pointer while retaining flags
    ret


; =====================================================================
; COPY SELECTED BLOCK
; =====================================================================
;
; COPY inserts the inclusive selected block immediately before the active line.
; The initial comparisons reject an insertion point inside the selected block,
; exactly as the manual states.  The upper boundary is advanced to obtain an
; exclusive end; subtraction then yields the compressed byte length.  If the
; insertion point lies after the source block, the source pointer is corrected
; for the upward shift before the common insertion primitive performs memmove
; and LDIR.
; =====================================================================
invokeCopy:
    call getSelectedBlock                   ; normalize the selected block into lower HL and upper DE
    push hl
    push de
    ld bc,(varcSourceBufferActiveLine+1)
    and a
    sbc hl,bc
    jr nc,.copyInsertionPointOutsideSelectedBlock ; skip the upper-bound test when insertion is before the block
    ex de,hl
    ccf                                     ; invert carry for the inclusive upper-bound test
    sbc hl,bc
    ccf                                     ; normalize carry to mean invalid insertion
.copyInsertionPointOutsideSelectedBlock:
    pop hl
    pop de
    ret c                                   ; reject COPY when the insertion point lies inside the selection
    push bc
    call getNextSourceRecord
    sbc hl,de
    ld b,h
    ld c,l
    pop hl
    ld (varcInsertionPointForPointerAdjustment+1),hl ; set the insertion boundary for moving-pointer repair
    ex de,hl
    push hl
    sbc hl,de
    pop hl
    jr c,.copyInsertionPointAdjusted         ; keep it unchanged when source lies above the insertion
    add hl,bc
.copyInsertionPointAdjusted:
    ex de,hl
    jr .insertByteRangeCommon


; Insert a byte range into the combined source/symbol region.
;
; Entry:
;   HL = insertion address
;   DE = source bytes to copy
;   BC = byte count
;
; The routine checks U-TOP, shifts everything from the insertion address through
; code end upward with overlap protection, updates code-end/symbol-table/block
; pointers, then copies the requested bytes into the new gap.  Parser insertion
; enters here with B=0 and C=record length; COPY enters with a full 16-bit count.
insertByteRangeAtHLFromDE:
    ld b,000h                               ; zero-extend a parser record length held in C
.insertByteRangeCommon:
    push de
    push hl
    call ensureBCBytesFitBelowUTop
    push bc
    push bc
    ex de,hl
    ld hl,(varcCodeEndPt+1)                 ; current high end of combined source/symbol data
    and a
    sbc hl,de
    ex (sp),hl
    ex de,hl
    push hl
    add hl,bc                               ; add the insertion size to form the upward destination
    pop de
    ex de,hl
    pop bc
    call moveMemoryBlockOverlapSafe
    pop bc
    ld hl,varcCodeEndPt+1                   ; select the moving code-end pointer
    call increaseAtHLbyBC
    ld hl,varcSymbolTablePt+1               ; select the moving symbol-table base
    call increaseAtHLbyBC
    ld hl,varcSelectedBlockStart+1          ; select the first block boundary
    call adjustPointerAtHLIfAtOrAfterInsertion
    ld hl,varcSelectedBlockEnd+1            ; select the second block boundary
    call adjustPointerAtHLIfAtOrAfterInsertion
    pop de
    pop hl
    ldir                                    ; fill the opened gap with the requested byte range
    ret
                               ;

; BLOCK 'data_93d8' (start 0x93d8 end 0xa574)
; One-byte predecessor guard for lineBuffer.
;
; Several renderers start at this byte because advanceInputPointerAndRead
; increments HL before fetching.  The guard is not part of the visible 32-byte
; line and its value is irrelevant to those readers.
lineBufferReadGuard:
    defb 000h
lineBuffer:
    defs 8, 020h                            ; initialize the first eight visible line-buffer cells to spaces
lineBufferMarkerPosition:
    defb 020h                               ; initialize the marker cell to a visible space
    defb 001h
    defs 23                                 ; reserve and clear the remaining twenty-three line-buffer cells
; One-byte prefix used only while creating a new symbol entry.
;
; Together with numberStringBuffer it forms the temporary sequence copied into
; the persistent entry area:
;   $00, temporary-name-length, normalized-name-bytes...
; The first two bytes are merely undefined value placeholders.  Once the symbol
; is defined, both are overwritten by the real little-endian value; persistent
; names are delimited by bit 7 on their final character, not by the temporary
; length byte.
symbolEntryCreationPrefix:
    defb 000h
numberStringBuffer:
    defb "65535"
    defs 5                                  ; reserve five trailing bytes for shorter numbers, symbol names and terminators
commandArgumentBuffer:
    defb 000h                               ; provide the shared first command/header byte, initially zero
; Monitor SAVE header workspace embedded in commandArgumentBuffer.
;
; Physical Spectrum header fields used by the monitor:
;   commandArgumentBuffer      +0       type = 3 (CODE)
;   monitorTapeHeaderFileName  +1..10   filename
;   monitorTapeHeaderDataLength+11..12  data length
;   monitorTapeHeaderParameter1+13..14  load/start address (First)
;   following two bytes        +15..16  parameter 2
;
; The monitor SAVE path does not explicitly store parameter 2.  However, every
; Leader prompt runs clearStringBuffers, which zero-fills this shared workspace
; before colon input returns without expression evaluation.  Parameter 2 is thus
; zero in the normal `:filename` path, and standard CODE loading ignores it.
monitorTapeHeaderFileName:
    defs 10                                 ; reserve the ten-byte monitor CODE filename field
monitorTapeHeaderDataLength:
    defw 0                                  ; initialize the monitor CODE data-length word to zero
monitorTapeHeaderParameter1:
    defs 6                                  ; reserve parameter 1 and zero-cleared parameter 2 fields
; One-byte predecessor guard for varLowercasedOperands.
;
; Definition-pseudo-instruction code starts here and increments before scanning,
; allowing the same compact pre-increment idiom used by other text buffers.
firstOperandBufferReadGuard:
    defb 000h                               ; provide the pre-increment guard byte before the first operand workspace
varLowercasedOperands:
    defs 19                                 ; reserve the nineteen-byte normalized first-operand workspace
; Extra byte immediately after the first-operand working buffer.
;
; When readFirstOperandUntilComma returns on a comma, the tokenizer advances HL
; past that delimiter and stores the comma here.  The first operand can therefore
; be treated later as a zero/padded field with an explicit boundary byte without
; enlarging its normal 19-byte workspace.  The following parsedMnemonicBuffer is
; separate and begins at the next address.
firstOperandDelimiterByte:
    defb 000h                               ; reserve the explicit delimiter byte following the first operand workspace
parsedMnemonicBuffer:
    defs 5                                  ; reserve the five-byte normalized mnemonic workspace
; Guard byte immediately before inputBufferStart.
;
; It is reset to $80 whenever the shared monitor/editor input area is initialized.
; Renderers and parsers use the address as a safe predecessor for pre-increment
; reads; the byte is not part of the submitted input line.
inputBufferGuardByte:
    defb 080h                               ; initialize the input predecessor guard with the high-bit empty marker
inputBufferStart:
    defb 0c2h                               ; seed the input buffer with the BASIC command token used by its empty template
    defb 001h                               ; store the field separator byte following the initial input token
    defs 10                                 ; reserve ten bytes for editable command text or a tape header name
; Named views into the 18-byte Y-command tape buffer.
;
; inputBufferStart itself holds the retained tape flag and header type.  These
; labels expose the three little-endian words at standard header offsets after
; that extra flag byte.
loadedTapeHeaderDataLength:
    defs 2
loadedTapeHeaderParameter1:
    defs 2
loadedTapeHeaderParameter2:
    defs 14                                 ; reserve parameter 2 and the remaining shared input/tape workspace
; Four-byte tail of the temporary processor-state capture workspace.
;
; captureUserStateAfterSequentialFlow temporarily places SP immediately after
; this area.  PUSH AF after `LD A,I` stores its flags/value in the first two
; bytes; the original AF occupies the next two.  The preceding two bytes hold
; flags/value from `LD A,R`.  .saveRemainingUserState ORs the P/V flag bytes from
; the R and I captures to derive varcInterruptEnableState, then the same memory is
; free for its ordinary input/tape-buffer role again.
interruptStateCaptureScratch:
    defs 4                                  ; reserve four bytes for temporary I/AF interrupt-state capture
; Temporary record-construction workspace.
;
; encodedRecordStorageLength is outside the persistent byte sequence.  The
; insertion code reads it, increments DE, and copies exactly that many bytes
; beginning at encodedRecordHeader.  The following labels expose the actual
; layout used while constructing a record:
;   encodedRecordHeader             opcode byte
;   encodedRecordInfoByte           information byte
;   encodedRecordPayload            optional label reference / expression data
;   encodedRecordPayloadAfterLabel  first byte after a two-byte label reference
encodedRecordStorageLength:
    defb 0                                  ; initialize the transient encoded-record byte count to zero
encodedRecordHeader:
    defb 0                                  ; initialize the transient encoded-record opcode byte to zero
encodedRecordInfoByte:
    defb 0                                  ; initialize the transient encoded-record information byte to zero
encodedRecordPayload:
    defw 0                                  ; reserve the optional encoded label ordinal or first payload word
encodedRecordPayloadAfterLabel:
    defw 0                                  ; reserve the first payload word after an optional encoded label ordinal
encodedRecordPayloadWorkspace:
    defs 28                                 ; reserve twenty-eight bytes for the remaining encoded expression payload
l9478:
    ; the next data are probably junk, the documentation talks
    ; about 100 bytes of stack space
    defs 22                                 ; reserve the first twenty-two bytes of the preserved internal-stack backing area
    defb 002h, 0c2h, 001h
    defs 38                                 ; reserve the next thirty-eight bytes of the internal-stack backing area
    defb 09fh, 050h
    defw DISK_PAYLOAD_ORIGIN+029adh     ; historical $876D stack word, rebased from original $5DC0 origin
    defb 02eh, 06fh, 023h, 06eh, 02ah, 05dh
    defb 0d0h, 001h, 09ch, 05eh, 0e4h, 050h
    defw DISK_PAYLOAD_ORIGIN+029adh     ; second copy of the same preserved stack word
    defb 019h, 040h, 01fh, 040h
    defw DISK_PAYLOAD_ORIGIN+02988h     ; historical $8748 stack word
    defw DISK_PAYLOAD_ORIGIN+02c61h     ; historical $8A21 stack word
    defw DISK_PAYLOAD_ORIGIN+01f43h     ; historical $7D03 stack word
    defw DISK_PAYLOAD_ORIGIN+01f0fh     ; historical $7CCF stack word
internalStackTop:

errorMessages:
    defb 080h
    defb "Bad mnemoni",0xe3
    defb "Bad operan",0xe4
    defb "Big numbe",0xf2
    defb "Syntax horro",0xf2
    defb "Bad strin",0xe7
    defb "Bad instructio",0xee
    defb "Memory ful",0xec
    defb "Bad PUT (ORG",0xa9
    defb " unknow",0xee
    defb "Wait pleas",0xe5
    defb "Assembly complet",0xe5
    defb "Start tap",0xe5
    defb "Tape erro",0xf2
    defb "Any ke",0xf9
    defb "(C) 90 UNIVERSU",0xcd
    defb "Source ERRO",0xd2
    defb "Found",0xba
    defb "Already define",0xe4
    defb "ENT ",0xbf


; Self-relative mnemonic reference vector. Entry address plus stored byte yields
; the corresponding high-bit-terminated spelling in mnemonicsTable.
mnemonicsReferences:
                    defb 000h               ; reserve mnemonic index 0 for a label-only or no-mnemonic record
                    defb 04dh
mnemonics00:        defb mnemonicsTable00-mnemonics00
mnemonics01:        defb mnemonicsTable01-mnemonics01
mnemonics02:        defb mnemonicsTable02-mnemonics02
mnemonics03:        defb mnemonicsTable03-mnemonics03
mnemonics04:        defb mnemonicsTable04-mnemonics04
mnemonics05:        defb mnemonicsTable05-mnemonics05
mnemonics06:        defb mnemonicsTable06-mnemonics06
mnemonics07:        defb mnemonicsTable07-mnemonics07
mnemonics08:        defb mnemonicsTable08-mnemonics08
mnemonics09:        defb mnemonicsTable09-mnemonics09
mnemonics10:        defb mnemonicsTable10-mnemonics10
mnemonics11:        defb mnemonicsTable11-mnemonics11
mnemonics12:        defb mnemonicsTable12-mnemonics12
mnemonics13:        defb mnemonicsTable13-mnemonics13
mnemonics14:        defb mnemonicsTable14-mnemonics14
mnemonics15:        defb mnemonicsTable15-mnemonics15
mnemonics16:        defb mnemonicsTable16-mnemonics16
mnemonics17:        defb mnemonicsTable17-mnemonics17
mnemonics18:        defb mnemonicsTable18-mnemonics18
mnemonics19:        defb mnemonicsTable19-mnemonics19
mnemonics20:        defb mnemonicsTable20-mnemonics20
mnemonics21:        defb mnemonicsTable21-mnemonics21
mnemonics22:        defb mnemonicsTable22-mnemonics22
mnemonics23:        defb mnemonicsTable23-mnemonics23
mnemonics24:        defb mnemonicsTable24-mnemonics24
mnemonics25:        defb mnemonicsTable25-mnemonics25
mnemonics26:        defb mnemonicsTable26-mnemonics26
mnemonics27:        defb mnemonicsTable27-mnemonics27
mnemonics28:        defb mnemonicsTable28-mnemonics28
mnemonics29:        defb mnemonicsTable29-mnemonics29
mnemonics30:        defb mnemonicsTable30-mnemonics30
mnemonics31:        defb mnemonicsTable31-mnemonics31
mnemonics32:        defb mnemonicsTable32-mnemonics32
mnemonics33:        defb mnemonicsTable33-mnemonics33
mnemonics34:        defb mnemonicsTable34-mnemonics34
mnemonics35:        defb mnemonicsTable35-mnemonics35
mnemonics36:        defb mnemonicsTable36-mnemonics36
mnemonics37:        defb mnemonicsTable37-mnemonics37
mnemonics38:        defb mnemonicsTable38-mnemonics38
mnemonics39:        defb mnemonicsTable39-mnemonics39
mnemonics40:        defb mnemonicsTable40-mnemonics40
mnemonics41:        defb mnemonicsTable41-mnemonics41
mnemonics42:        defb mnemonicsTable42-mnemonics42
mnemonics43:        defb mnemonicsTable43-mnemonics43
mnemonics44:        defb mnemonicsTable44-mnemonics44
mnemonics45:        defb mnemonicsTable45-mnemonics45
mnemonics46:        defb mnemonicsTable46-mnemonics46
mnemonics47:        defb mnemonicsTable47-mnemonics47
mnemonics48:        defb mnemonicsTable48-mnemonics48
mnemonics49:        defb mnemonicsTable49-mnemonics49
mnemonics50:        defb mnemonicsTable50-mnemonics50
mnemonics51:        defb mnemonicsTable51-mnemonics51
mnemonics52:        defb mnemonicsTable52-mnemonics52
mnemonics53:        defb mnemonicsTable53-mnemonics53
mnemonics54:        defb mnemonicsTable54-mnemonics54
mnemonics55:        defb mnemonicsTable55-mnemonics55
mnemonics56:        defb mnemonicsTable56-mnemonics56
mnemonics57:        defb mnemonicsTable57-mnemonics57
mnemonics58:        defb mnemonicsTable58-mnemonics58
mnemonics59:        defb mnemonicsTable59-mnemonics59
mnemonics60:        defb mnemonicsTable60-mnemonics60
mnemonics61:        defb mnemonicsTable61-mnemonics61
mnemonics62:        defb mnemonicsTable62-mnemonics62
mnemonics63:        defb mnemonicsTable63-mnemonics63
mnemonics64:        defb mnemonicsTable64-mnemonics64
mnemonics65:        defb mnemonicsTable65-mnemonics65
mnemonics66:        defb mnemonicsTable66-mnemonics66
mnemonics67:        defb mnemonicsTable67-mnemonics67
mnemonics68:        defb mnemonicsTable68-mnemonics68
mnemonics69:        defb mnemonicsTable69-mnemonics69
mnemonics70:        defb mnemonicsTable70-mnemonics70
mnemonics71:        defb mnemonicsTable71-mnemonics71
mnemonics72:        defb mnemonicsTable72-mnemonics72
mnemonics73:        defb mnemonicsTable73-mnemonics73
mnemonics74:        defb mnemonicsTable74-mnemonics74
mnemonics75:        defb mnemonicsTable75-mnemonics75
                    defb 0bbh               ; store the high-bit-terminated semicolon text used by mnemonic index 1

mnemonicsTable:
mnemonicsTable00:   defb "c", 0xF0
mnemonicsTable01:   defb "d", 0xE9
mnemonicsTable02:   defb "e", 0xE9
mnemonicsTable03:   defb "e", 0xF8
mnemonicsTable04:   defb "i", 0xED
mnemonicsTable05:   defb "i", 0xEE
mnemonicsTable06:   defb "j", 0xF0
mnemonicsTable07:   defb "j", 0xF2
mnemonicsTable08:   defb "l", 0xE4
mnemonicsTable09:   defb "o", 0xF2
mnemonicsTable10:   defb "r", 0xEC
mnemonicsTable11:   defb "r", 0xF2
mnemonicsTable12:   defb "ad", 0xE3
mnemonicsTable13:   defb "ad", 0xE4
mnemonicsTable14:   defb "an", 0xE4
mnemonicsTable15:   defb "bi", 0xF4
mnemonicsTable16:   defb "cc", 0xE6
mnemonicsTable17:   defb "cp", 0xE4
mnemonicsTable18:   defb "cp", 0xE9
mnemonicsTable19:   defb "cp", 0xEC
mnemonicsTable20:   defb "da", 0xE1
mnemonicsTable21:   defb "de", 0xE3
mnemonicsTable22:   defb "en", 0xF4
mnemonicsTable23:   defb "eq", 0xF5
mnemonicsTable24:   defb "ex", 0xF8
mnemonicsTable25:   defb "in", 0xE3
mnemonicsTable26:   defb "in", 0xE4
mnemonicsTable27:   defb "in", 0xE9
mnemonicsTable28:   defb "ld", 0xE4
mnemonicsTable29:   defb "ld", 0xE9
mnemonicsTable30:   defb "ne", 0xE7
mnemonicsTable31:   defb "no", 0xF0
mnemonicsTable32:   defb "or", 0xE7
mnemonicsTable33:   defb "ou", 0xF4
mnemonicsTable34:   defb "po", 0xF0
mnemonicsTable35:   defb "pu", 0xF4
mnemonicsTable36:   defb "re", 0xF3
mnemonicsTable37:   defb "re", 0xF4
mnemonicsTable38:   defb "rl", 0xE1
mnemonicsTable39:   defb "rl", 0xE3
mnemonicsTable40:   defb "rl", 0xE4
mnemonicsTable41:   defb "rr", 0xE1
mnemonicsTable42:   defb "rr", 0xE3
mnemonicsTable43:   defb "rr", 0xE4
mnemonicsTable44:   defb "rs", 0xF4
mnemonicsTable45:   defb "sb", 0xE3
mnemonicsTable46:   defb "sc", 0xE6
mnemonicsTable47:   defb "se", 0xF4
mnemonicsTable48:   defb "sl", 0xE1
mnemonicsTable49:   defb "sr", 0xE1
mnemonicsTable50:   defb "sr", 0xEC
mnemonicsTable51:   defb "su", 0xE2
mnemonicsTable52:   defb "xo", 0xF2
mnemonicsTable53:   defb "cal", 0xEC
mnemonicsTable54:   defb "cpd", 0xF2
mnemonicsTable55:   defb "cpi", 0xF2
mnemonicsTable56:   defb "def", 0xE2        ; encode the packed mnemonic DEFB
mnemonicsTable57:   defb "def", 0xED
mnemonicsTable58:   defb "def", 0xF3
l96a4:
mnemonicsTable59:   defb "def", 0xF7
mnemonicsTable60:   defb "djn", 0xFA
mnemonicsTable61:   defb "hal", 0xF4
mnemonicsTable62:   defb "ind", 0xF2
mnemonicsTable63:   defb "ini", 0xF2
mnemonicsTable64:   defb "ldd", 0xF2
mnemonicsTable65:   defb "ldi", 0xF2
mnemonicsTable66:   defb "otd", 0xF2
mnemonicsTable67:   defb "oti", 0xF2
mnemonicsTable68:   defb "out", 0xE4
mnemonicsTable69:   defb "out", 0xE9
mnemonicsTable70:   defb "pus", 0xE8
mnemonicsTable71:   defb "ret", 0xE9
mnemonicsTable72:   defb "ret", 0xEE
mnemonicsTable73:   defb "rlc", 0xE1
mnemonicsTable74:   defb "rrc", 0xE1
mnemonicsTable75:   defb "sli", 0xE1


; Self-relative fixed-operand reference vector. Descriptor zero is rejected before
; lookup; descriptors 1..43 resolve to the packed strings below.
operandsReferences:
                    defb 0x20               ; retain the unused descriptor-zero placeholder; valid lookup starts at index 1
operand00:          defb operandsTable00-operand00
operand01:          defb operandsTable01-operand01
operand02:          defb operandsTable02-operand02
operand03:          defb operandsTable03-operand03
operand04:          defb operandsTable04-operand04
operand05:          defb operandsTable05-operand05
operand06:          defb operandsTable06-operand06
operand07:          defb operandsTable07-operand07
operand08:          defb operandsTable08-operand08
operand09:          defb operandsTable09-operand09
operand10:          defb operandsTable10-operand10
operand11:          defb operandsTable11-operand11
operand12:          defb operandsTable12-operand12
operand13:          defb operandsTable13-operand13
operand14:          defb operandsTable14-operand14
operand15:          defb operandsTable15-operand15
operand16:          defb operandsTable16-operand16
operand17:          defb operandsTable17-operand17
operand18:          defb operandsTable18-operand18
operand19:          defb operandsTable19-operand19
operand20:          defb operandsTable20-operand20
operand21:          defb operandsTable21-operand21
operand22:          defb operandsTable22-operand22
operand23:          defb operandsTable23-operand23
operand24:          defb operandsTable24-operand24
operand25:          defb operandsTable25-operand25
operand26:          defb operandsTable26-operand26
operand27:          defb operandsTable27-operand27
operand28:          defb operandsTable28-operand28
operand29:          defb operandsTable29-operand29
operand30:          defb operandsTable30-operand30
operand31:          defb operandsTable31-operand31
operand32:          defb operandsTable32-operand32
operand33:          defb operandsTable33-operand33
operand34:          defb operandsTable34-operand34
operand35:          defb operandsTable35-operand35
operand36:          defb operandsTable36-operand36
operand37:          defb operandsTable37-operand37
operand38:          defb operandsTable38-operand38
operand39:          defb operandsTable39-operand39
operand40:          defb operandsTable40-operand40
operand41:          defb operandsTable41-operand41
operand42:          defb operandsTable42-operand42

;table of operands

operandsTable:
operandsTable00:    defb "", 0xB0
operandsTable01:    defb "", 0xB1
operandsTable02:    defb "", 0xB2
operandsTable03:    defb "", 0xB3
operandsTable04:    defb "", 0xB4
operandsTable05:    defb "", 0xB5
operandsTable06:    defb "", 0xB6
operandsTable07:    defb "", 0xB7
operandsTable08:    defb "", 0xE1
operandsTable09:    defb "", 0xE2
operandsTable10:    defb "", 0xE3
operandsTable11:    defb "", 0xE4
operandsTable12:    defb "", 0xE5
operandsTable13:    defb "", 0xE8
operandsTable14:    defb "", 0xE9
operandsTable15:    defb "", 0xEC
operandsTable16:    defb "", 0xED
operandsTable17:    defb "", 0xF0
operandsTable18:    defb "", 0xF2
operandsTable19:    defb "", 0xFA
operandsTable20:    defb "a", 0xE6
operandsTable21:    defb "b", 0xE3
operandsTable22:    defb "d", 0xE5
operandsTable23:    defb "h", 0xEC
operandsTable24:    defb "h", 0xF8
operandsTable25:    defb "h", 0xF9
operandsTable26:    defb "i", 0xF8
operandsTable27:    defb "i", 0xF9
operandsTable28:    defb "l", 0xF8
operandsTable29:    defb "l", 0xF9
operandsTable30:    defb "n", 0xE3
operandsTable31:    defb "n", 0xFA
operandsTable32:    defb "p", 0xE5
operandsTable33:    defb "p", 0xEF
operandsTable34:    defb "s", 0xF0
operandsTable35:    defb "(c", 0xA9
operandsTable36:    defb "af", 0xA7
operandsTable37:    defb "(bc", 0xA9
operandsTable38:    defb "(de", 0xA9
operandsTable39:    defb "(hl", 0xA9
operandsTable40:    defb "(ix", 0xA9
operandsTable41:    defb "(iy", 0xA9
operandsTable42:    defb "(sp", 0xA9

; Preserved self-relative command-name vector. Duplicate entries are historical
; aliases and remain distinct slots even when they resolve to the same spelling.
operationLabels:
operationLabels00:  defb operationLabelAssembly - operationLabels00
operationLabels01:  defb operationLabelBasic - operationLabels01
operationLabels02:  defb operationLabelCopy - operationLabels02
operationLabels03:  defb operationLabelDelete - operationLabels03
operationLabels05:  defb operationLabelDelete - operationLabels05
operationLabels06:  defb operationLabelFind - operationLabels06
operationLabels07:  defb operationLabelGens - operationLabels07
operationLabels08:  defb operationLabelGens - operationLabels08
operationLabels09:  defb operationLabelGens - operationLabels09
operationLabels10:  defb operationLabelGens - operationLabels10
operationLabels11:  defb operationLabelGens - operationLabels11
operationLabels12:  defb operationLabelLoad - operationLabels12
operationLabels13:  defb operationLabelMonitor - operationLabels13
operationLabels14:  defb operationLabelNew - operationLabels14
operationLabels15:  defb operationLabelNew - operationLabels15
operationLabels16:  defb operationLabelPrint - operationLabels16
operationLabels17:  defb operationLabelQuit - operationLabels17
operationLabels18:  defb operationLabelRun - operationLabels18
operationLabels19:  defb operationLabelSave - operationLabels19
operationLabels20:  defb operationLabelTable - operationLabels20
operationLabels21:  defb operationLabelUTop - operationLabels21
operationLabels22:  defb operationLabelVerify - operationLabels22
operationLabels23:  defb operationLabelVerify - operationLabels23
operationLabels24:  defb operationLabelClear - operationLabels24
operationLabels25:  defb operationLabelClear - operationLabels25
operationLabels26:  defb operationLabelReplace - operationLabels26

operationLabelAssembly:
    defb "ASSEMBL", 0xD9                    ; encode the high-bit-terminated command name ASSEMBLY
operationLabelBasic:
    defb "BASI", 0xC3
operationLabelCopy:
    defb "COP", 0xD9
operationLabelDelete:
    defb "DELET", 0xC5
operationLabelFind:
    defb "FIN", 0xC4
operationLabelGens:
    defb "GEN", 0xD3
operationLabelLoad:
    defb "LOA", 0xC4
operationLabelMonitor:
    defb "MONITO", 0xD2
operationLabelNew:
    defb "NE", 0xD7
operationLabelPrint:
    defb "PRIN", 0xD4
operationLabelQuit:
    defb "QUI", 0xD4
operationLabelRun:
    defb "RU", 0xCE
operationLabelSave:
    defb "SAV", 0xC5
operationLabelTable:
    defb "TABL", 0xC5
operationLabelUTop:
    defb "U-TO", 0xD0
operationLabelVerify:
    defb "VERIF", 0xD9
operationLabelClear:
    defb "CLEA", 0xD2
operationLabelReplace:
    defb "REPLAC", 0xC5


include "instructionTable.asm"

; Initial compressed source image.
;
; An empty line is the fixed record $00,$30.  Twenty such records are supplied
; so the editor can position its access line with valid records above and below
; it before the user has entered any source.  The source grows upward into the
; movable symbol-table region.
sourceBufferStart:
    ; initial setup of the source buffer, 20 empty lines
    defb 0x00, 0x30
    defb 0x00, 0x30
    defb 0x00, 0x30
    defb 0x00, 0x30
    defb 0x00, 0x30
    defb 0x00, 0x30
    defb 0x00, 0x30
    defb 0x00, 0x30
    defb 0x00, 0x30
    defb 0x00, 0x30
    defb 0x00, 0x30
    defb 0x00, 0x30
sourceBufferPreviousLine:
    defb 0x00, 0x30
sourceBufferAccessLine:
    defb 0x00, 0x30
    defb 0x00, 0x30
    defb 0x00, 0x30
    defb 0x00, 0x30
    defb 0x00, 0x30
    defb 0x00, 0x30
    defb 0x00, 0x30

; Initial empty symbol table: a zero 16-bit count.
; The dynamic table grows above the compressed source.  varcSymbolTablePt moves
; when source records are inserted/deleted; varcCodeEndPt is the protected end
; marker for the combined resident/source/symbol region.  Default generated output
; begins at varcCodeEndPt+1, leaving the marker itself inside the protected area.
symbolTableDefaultPt:
    defw 0                                  ; initialize the symbol-table entry count to zero
codeEndDefaultPt:
    defs 6                                  ; reserve the six-byte initial symbol/code-end tail inside protected memory
; Static default operand for varcInsertionPointForPointerAdjustment.
;
; Every real source-line insertion and COPY operation patches the comparison
; operand with its actual insertion address before pointer repair begins.  This
; word lies beyond the initial code-end marker and serves only as a harmless
; pre-operation sentinel if the helper were reached before such initialization;
; no persistent source or symbol-table structure is rooted here.
defaultPointerAdjustmentSentinel:
    defw 0                                  ; initialize the harmless pre-operation pointer-adjustment sentinel to zero

; End marker used by the multi-origin relocation generator and symbolic
; installer length expressions.  It emits no bytes.
relocatablePayloadEnd:
