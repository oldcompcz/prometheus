; Common 23-byte self-locating bootstrap used by both floppy distributions.
; Loaded at the CODE block address (normally $5DC0), it discovers its physical
; location through ROM RET, copies the common 457-byte installer front section
; to $4017, and jumps there.  The copied code then copies the variant-specific
; continuation that follows it in the distribution image.

ROM_ImmediateRET: equ 00052h
INSTALLER_TEMP:   equ 04017h
COMMON_FRONT_LEN: equ 001c9h     ; 457 bytes

    org 05dc0h
floppyBootstrap:
    di
    call ROM_ImmediateRET
    dec sp
    dec sp
    pop hl
    push hl
    ld bc,floppyInstallerImage-floppyBootstrap
    add hl,bc
    ld bc,COMMON_FRONT_LEN
    ld de,INSTALLER_TEMP
    ldir
    jp INSTALLER_TEMP

floppyInstallerImage:
    ; The variant-specific copied installer starts here in the CODE block.
