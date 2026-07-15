# Appendix F: Routine and Table Index

This index connects the reconstructed source labels in **prometheus-resurrection v042** to the explanatory chapters and appendices. It is intentionally more complete than a conventional hand-picked routine list: every global colon label in `src/prometheus.asm` appears here, either alone or grouped with an adjacent alias. Dot-prefixed local labels remain under the global routine that owns them.

The source line is a coordinate in v042, not a historical load address. “Principal callers or consumers” is a compact static cross-reference derived from code and data references; it is not a claim that emulator traces observed every listed path. Conversely, an entry with no static caller may be an external entry, fall-through point, alias, data boundary or generated-metadata anchor rather than dead code.

## F.1 How to use the index

| Column | Meaning |
|---|---|
| Label | Global source label. Adjacent aliases sharing one position or one immediately following definition are grouped with `/`. |
| Purpose | Short operational description, normally taken from the source commentary or the coverage ledger. |
| Physical source region | Functional region and v042 source line. |
| Principal callers or consumers | Up to three strongest direct static references. |
| Book | Main explanatory chapters or reference appendix. |

The index accounts for **981 global labels** in **960 grouped entries**. The separate 687-record instruction table is represented by its include boundary and major consumers rather than by an invented label for every fixed-size record.

## F.2 Spectrum constants and external addresses

| Label | Purpose | Physical source region | Principal callers or consumers | Book |
|---|---|---|---|---|
| `INSTALLATION_ADDRESS` | Installation address. | Spectrum constants and external addresses, line 167 | `MESSAGE_ENT` | Ch. 3, 8; App. B–C |
| `VRAM_ADDRESS` | Vram address. | Spectrum constants and external addresses, line 168 | `bootstrapEntry`, `bootstrapRecoverLoadAddress`, `installerEntryAt5000` | Ch. 3, 8; App. B–C |
| `ATTRIBUTES_ADDRESS` | Attributes address. | Spectrum constants and external addresses, line 169 | `varcMonitorInstallFlag`, `invokeFrontPanelEditor` | Ch. 3, 8; App. B–C |
| `LOADER_ADDRESS` | Loader address. | Spectrum constants and external addresses, line 170 | `varcInstallationAddressCursor`, `varcKeyboardEchoDelay`, `varcInstallerCaseMode` | Ch. 3, 8; App. B–C |
| `ROM_PrintACharacter` | Printer/tape-era ROM output use; command workflows remain open. | Spectrum constants and external addresses, line 174 | `outputLineBufferToChannel3` | Ch. 8 |
| `ROM_MaskableInterrupt` | Spectrum ROM entry used by PROMETHEUS. | Spectrum constants and external addresses, line 175 | `frontPanelFormatToggleKeyTable` | Ch. 3, 8; App. B–C |
| `ROM_Key_Tables` | Spectrum ROM entry used by PROMETHEUS. | Spectrum constants and external addresses, line 176 | `processKey` | Ch. 3, 8; App. B–C |
| `ROM_KeyboardScanning` | Returns raw key index/modifier state. | Spectrum constants and external addresses, line 177 | `varcKeyboardEchoDelay`, `getKeypressCodeOrZero` | Ch. 8, 10 |
| `ROM_KeyboardTest` | Spectrum ROM entry used by PROMETHEUS. | Spectrum constants and external addresses, line 178 | `varcKeyboardEchoDelay` | Ch. 3, 8; App. B–C |
| `ROM_BreakKey` | Spectrum ROM entry used by PROMETHEUS. | Spectrum constants and external addresses, line 179 | `monSlowTracing`, `varcFastTraceStopAddress` | Ch. 3, 8; App. B–C |
| `ROM_LoadBytes_562` | Spectrum ROM entry used by PROMETHEUS. | Spectrum constants and external addresses, line 180 | `monReadTapeHeaderOrLeader`, `callRomTapeLoadOrVerify` | Ch. 3, 8; App. B–C |
| `ROM_SaveControl_4c6` | Writes source first and continues through the bridge/table without an intermediate RAM copy. | Spectrum constants and external addresses, line 181 | `monSaveBlockFirstLength`, `invokeSave`, `waitForKeyAndWriteTapeHeader` | Ch. 29 |
| `ROM_SA_SET` | Writes source first and continues through the bridge/table without an intermediate RAM copy. | Spectrum constants and external addresses, line 182 | `varcLastSavedAuxiliarySegmentLength` | Ch. 29 |
| `ROM_LD_MARKER` | Spectrum ROM entry used by PROMETHEUS. | Spectrum constants and external addresses, line 183 | `varcLastSavedSourceLength` | Ch. 3, 8; App. B–C |
| `ROM_ChannelOpen` | Printer/tape-era ROM output use; command workflows remain open. | Spectrum constants and external addresses, line 184 | `outputLineBufferToChannel3` | Ch. 8 |
| `ROM_PixelAddress_22b0` | Character-row to bitmap-address service. | Spectrum constants and external addresses, line 185 | `varcSymbolTableColumnPosition`, `copyScreenTextRowAtYToDE`, `clearLine` | Ch. 8 |
| `ROM_NEWCommandRoutine` | Spectrum ROM entry used by PROMETHEUS. | Spectrum constants and external addresses, line 186 | `commandHandlerTable` | Ch. 3, 8; App. B–C |
| `ROM_ImmediateRET` | CALL manufactures physical next PC; DEC SP/POP BC recovers the consumed return word. | Spectrum constants and external addresses, line 187 | `bootstrapEntry` | Ch. 51 |
| `ROM_StatementReturn` | Spectrum ROM entry used by PROMETHEUS. | Spectrum constants and external addresses, line 188 | `invokeBasic` | Ch. 3, 8; App. B–C |
| `SYSVAR_ERR_SP` | Address of item on machine stack to use as error return. | Spectrum constants and external addresses, line 192 | `invokeBasic` | Ch. 3, 8; App. B–C |
| `INSTRUCTIONS_TABLE_SIZE` | Bounded 687-record/3,435-byte source-entry search. | Spectrum constants and external addresses, line 196 | `varcMnemonicIndex` | Ch. 20 |
| `TEXT_COLOR` | white paper, black color. | Spectrum constants and external addresses, line 197 | `configurationPatchTarget05SymbolTableNormalAttribute` | Ch. 3, 8; App. B–C |
| `HIGHLIGHT_COLOR` | yellow paper, black color. | Spectrum constants and external addresses, line 198 | `configurationPatchTarget13SymbolTableHighlightAttribute`, `configurationPatchTarget12WarmStartAccessLineAttribute` | Ch. 3, 8; App. B–C |
| `FRONT_PANEL_EDITOR_COLOR` | as text color with bit 0 inverted. | Spectrum constants and external addresses, line 199 | `configurationPatchTarget07FrontPanelEditorFillAttribute`, `configurationPatchTarget08FrontPanelEditorCompareAttribute` | Ch. 3, 8; App. B–C |
| `LABEL_LENGTH` | Label length. | Spectrum constants and external addresses, line 200 | `expandSourceRecordToHL`, `appendRangeEndpointToDisplayLine`, `varcEndOfSymbolTable` | Ch. 3, 8; App. B–C |
| `MAX_FILE_NAME_LENGTH` | Max file name length. | Spectrum constants and external addresses, line 201 | `copyFileNameFromHLToDE`, `acceptLoadedHeaderIfNameMatchesOrWildcard`, `compareRequestedNameWithLoadedHeaderExact` | Ch. 3, 8; App. B–C |
| `SEPARATOR_CHARCODE` | Separator charcode. | Spectrum constants and external addresses, line 202 | `startPrometheus` | Ch. 3, 8; App. B–C |
| `SECOND_LINE_ADDRESS` | Second line address. | Spectrum constants and external addresses, line 203 | `varcPrintingPosition` | Ch. 3, 8; App. B–C |
| `BOTTOM_LINE_VRAM_ADDRESS` | Bottom line vram address. | Spectrum constants and external addresses, line 204 | `invokeSave`, `scanTapeForNextCodeHeader`, `loadMatchingCodePayloadToTemporaryMemory` | Ch. 3, 8; App. B–C |
| `LEFT_BOTTOM_ATTRIBUTE_ADDRESS` | Left bottom attribute address. | Spectrum constants and external addresses, line 205 | `submitInputLineOrDispatchCommand` | Ch. 3, 8; App. B–C |
| `ACCESS_LINE_ATTRIBUTE_ADDRESS` | Access line attribute address. | Spectrum constants and external addresses, line 206 | `prometheusWarmStart` | Ch. 3, 8; App. B–C |
| `THIRD_LINE_ATTRIBUTE_ADDRESS` | Third line attribute address. | Spectrum constants and external addresses, line 207 | `varcPrintSymbolTable` | Ch. 3, 8; App. B–C |
| `STATUS_BAR_MODE_POSITION` | Status bar mode position. | Spectrum constants and external addresses, line 208 | `printStatusBar` | Ch. 3, 8; App. B–C |
| `LINES_BEFORE_ACCESS_LINE` | Thirteen-record offset from top visible row to active record. | Spectrum constants and external addresses, line 209 | `varcSourceBufferActiveLine` | Ch. 15 |
| `CALLS_STACK_SIZE` | Calls stack size. | Spectrum constants and external addresses, line 210 | `monitorNavigationAddressStack`, `monLevelDown` | Ch. 3, 8; App. B–C |
| `CHARACTERS_PER_LINE` | Characters per line. | Spectrum constants and external addresses, line 211 | `configurationPatchTarget13SymbolTableHighlightAttribute` | Ch. 3, 8; App. B–C |
| `SYMBOL_TABLE_LINES_COUNT` | Symbol table lines count. | Spectrum constants and external addresses, line 212 | `configurationPatchTarget13SymbolTableHighlightAttribute` | Ch. 3, 8; App. B–C |
| `MESSAGE_BAD_MNEMONIC` | Message bad mnemonic. | Spectrum constants and external addresses, line 216 | `badMnemonicError` | Ch. 3, 8; App. B–C |
| `MESSAGE_BAD_OPERAND` | Message bad operand. | Spectrum constants and external addresses, line 217 | `badOperandError` | Ch. 3, 8; App. B–C |
| `MESSAGE_BIG_NUMBER` | Message big number. | Spectrum constants and external addresses, line 218 | `bigNumberError` | Ch. 3, 8; App. B–C |
| `MESSAGE_SYNTAX_HORROR` | Message syntax horror. | Spectrum constants and external addresses, line 219 | `syntaxError` | Ch. 3, 8; App. B–C |
| `MESSAGE_BAD_STRING` | Message bad string. | Spectrum constants and external addresses, line 220 | `badStringError` | Ch. 3, 8; App. B–C |
| `MESSAGE_BAD_INSTRUCTION` | Message bad instruction. | Spectrum constants and external addresses, line 221 | `badInstructionError` | Ch. 3, 8; App. B–C |
| `MESSAGE_MEMORY_FULL` | Message memory full. | Spectrum constants and external addresses, line 222 | `continueSourceImportAfterSubmittedLine`, `ensureBCBytesFitBelowUTop` | Ch. 3, 8; App. B–C |
| `MESSAGE_BAD_PUT_ORG` | Message bad put org. | Spectrum constants and external addresses, line 223 | fall-through, alias, emitted data or external entry | Ch. 3, 8; App. B–C |
| `MESSAGE_UNKNOWN` | Message unknown. | Spectrum constants and external addresses, line 224 | `evaluateExpressionAtHL` | Ch. 3, 8; App. B–C |
| `MESSAGE_WAIT_PLEASE` | Message wait please. | Spectrum constants and external addresses, line 225 | `printStatusBarWithWaitPlease` | Ch. 3, 8; App. B–C |
| `MESSAGE_ASSEMBLY_COMPLETE` | Message assembly complete. | Spectrum constants and external addresses, line 226 | `invokeAssembly` | Ch. 3, 8; App. B–C |
| `MESSAGE_START_TAPE` | Message start tape. | Spectrum constants and external addresses, line 227 | `invokeSave` | Ch. 3, 8; App. B–C |
| `MESSAGE_TAPE_ERROR` | Message tape error. | Spectrum constants and external addresses, line 228 | `performTapeLoadOrVerifyOrReportError` | Ch. 3, 8; App. B–C |
| `MESSAGE_ANY_KEY` | Message any key. | Spectrum constants and external addresses, line 229 | `varcPrintSymbolTable` | Ch. 3, 8; App. B–C |
| `MESSAGE_COPYRIGHT` | Message copyright. | Spectrum constants and external addresses, line 230 | `varcLastStatusBarMessage`, `configurationPatchTarget12WarmStartAccessLineAttribute`, `varcInsertMode` | Ch. 3, 8; App. B–C |
| `MESSAGE_SOURCE_ERROR` | Message source error. | Spectrum constants and external addresses, line 231 | `varcEndOfSymbolTable`, `varcImportedSymbolTableBase`, `printFromDEtoHLwithDecB` | Ch. 3, 8; App. B–C |
| `MESSAGE_FOUND` | Message found. | Spectrum constants and external addresses, line 232 | `scanTapeForNextCodeHeader` | Ch. 3, 8; App. B–C |
| `MESSAGE_ALREADY_DEFINED` | Message already defined. | Spectrum constants and external addresses, line 233 | `firstPassProcessSourceRecord` | Ch. 3, 8; App. B–C |

## F.3 Relocation-safe bootstrap

| Label | Purpose | Physical source region | Principal callers or consumers | Book |
|---|---|---|---|---|
| `MESSAGE_ENT` | Message ent. | Relocation-safe bootstrap, line 234 | `varcRunEntDirectiveBalance` | Ch. 50–51 |
| `bootstrapEntry` | Identifies the position-independent physical self-location and installer copy region. | Relocation-safe bootstrap, line 276 | `bootstrapRecoverLoadAddress` | Ch. 51 |
| `bootstrapRecoverLoadAddress` | physical address of bootstrapEntry. | Relocation-safe bootstrap, line 290 | fall-through, alias, emitted data or external entry | Ch. 50–51 |
| `bootstrapCopiedFragmentEnd` | Identifies the position-independent physical self-location and installer copy region. | Relocation-safe bootstrap, line 304 | fall-through, alias, emitted data or external entry | Ch. 50–51 |

## F.4 Temporary installer at $5000

| Label | Purpose | Physical source region | Principal callers or consumers | Book |
|---|---|---|---|---|
| `installerEntryAt5000` | Separates installer UI, image selection/copy, configuration walk, relocation decoder, generated includes and logo tail. | Temporary installer at $5000, line 330 | `varcInstallationAddressCursor`, `varcKeyboardEchoDelay`, `varcInstallerCaseMode` | Ch. 51, 52 |
| `installerRedrawAndWait` | Complete screen redraw becomes the return target of ordinary key handlers. | Temporary installer at $5000, line 358 | `varcKeyboardEchoDelay` | Ch. 52 |
| `installationAddressString` | Installation address string. | Temporary installer at $5000, line 374 | `installerEntryAt5000`, `varcInstallationAddressCursor`, `varcInstallerSavedStackPointer` | Ch. 52–56; App. C, E |
| `varcMonitorInstallFlag` | 11,000-byte assembler-only image. | Temporary installer at $5000, line 389 | `varcKeyboardEchoDelay`, `varcInstallerSavedStackPointer` | Ch. 52–56; App. C, E |
| `varcInstallerTextAttribute` | ink on white paper, normal brightness. | Temporary installer at $5000, line 436 | `varcKeyboardEchoDelay`, `varcInstallationAddressCursor` | Ch. 52–56; App. C, E |
| `varcInstallerHighlightAttribute` | on yellow paper. | Temporary installer at $5000, line 443 | `varcKeyboardEchoDelay`, `varcInstallationAddressCursor` | Ch. 52–56; App. C, E |
| `varcKeyboardEchoDelay` | count, so larger values produce a longer audible key echo. | Temporary installer at $5000, line 454 | `varcInstallationAddressCursor` | Ch. 52–56; App. C, E |
| `varcInstallerCaseMode` | Cycles and copies complete two-byte case-transform instructions. | Temporary installer at $5000, line 603 | fall-through, alias, emitted data or external entry | Ch. 52 |
| `installerCaseModeInstructionTable` | Cycles and copies complete two-byte case-transform instructions. | Temporary installer at $5000, line 629 | `varcInstallerCaseMode` | Ch. 52 |
| `varcInstallationAddressCursor` | Self-modified cursor pointer and shift/add multiply-by-ten parsing. | Temporary installer at $5000, line 637 | `varcKeyboardEchoDelay` | Ch. 52, 53 |
| `varcInstallerSavedStackPointer` | exhausted. ENTER patched this LD SP,nn operand with the live SP value. | Temporary installer at $5000, line 725 | `varcInstallationAddressCursor` | Ch. 52–56; App. C, E |
| `installerPrepareAssemblerOnlyImage` | Patches one retained word, skips the 5,000-byte monitor prefix and selects suffix length. | Temporary installer at $5000, line 772 | fall-through, alias, emitted data or external entry | Ch. 3, 53 |
| `installerStoreAAndAdvancePatchPointer` | Fuses one-byte write with movement to the next generated target. | Temporary installer at $5000, line 882 | `varcInstallationAddressCursor` | Ch. 54 |
| `installerAdvancePatchPointer` | Preserves CALL return, pops delta through SP, advances HL and returns over remaining stream. | Temporary installer at $5000, line 889 | `varcInstallationAddressCursor` | Ch. 54 |
| `installerEmitDecimalDigit` | ASCII '0'. The failing subtraction is repaired by ADD HL,DE. | Temporary installer at $5000, line 908 | `installerEntryAt5000` | Ch. 52–56; App. C, E |
| `installerConfigurationPatchDeltas` | Fourteen generated signed little-endian displacements in installer write order. | Temporary installer at $5000, line 926 | `varcInstallationAddressCursor` | Ch. 54 |
| `attributeCopyPaperColourToInk` | part of the interface; A and B are clobbered. | Temporary installer at $5000, line 937 | `varcInstallerHighlightAttribute`, `varcInstallationAddressCursor` | Ch. 52–56; App. C, E |
| `installerPrintInlineString` | Pops inline high-bit string pointer, renders ROM glyphs and jumps beyond the final character. | Temporary installer at $5000, line 970 | `installerRedrawAndWait`, `varcMonitorInstallFlag`, `installationAddressString` | Ch. 4, 6, 52 |
| `varcInstallerCaseTransform` | Cycles and copies complete two-byte case-transform instructions. | Temporary installer at $5000, line 992 | `varcInstallerCaseMode`, `varcInstallationAddressCursor`, `installerPrintInlineString` | Ch. 52 |
| `varcInstallerStringDestination` | operand. Installer strings do not cross a 256-byte bitmap boundary. | Temporary installer at $5000, line 1008 | `installerPrintInlineString`, `varcInstallerBoldTransform` | Ch. 52–56; App. C, E |
| `varcInstallerBoldTransform` | NOP/RRCA opcode toggle previewed in installer and copied into resident renderer. | Temporary installer at $5000, line 1025 | `varcKeyboardEchoDelay`, `varcInstallationAddressCursor` | Ch. 52, 54 |
| `installerApplyRelocationTable` | Destructive synthetic count, running DE pointer, BC addend and little-endian word rewrite. | Temporary installer at $5000, line 1073 | `installerPrepareAssemblerOnlyImage` | Ch. 55 |
| `installerDrawLogoRow` | Maps linear 20x8 logo columns into the Spectrum bitmap by incrementing D vertically and E horizontally. | Temporary installer at $5000, line 1130 | `installerEntryAt5000` | Ch. 52 |
| `relocationSecondStreamTerminatorAndLogoStart` | together with the generated table before using the remaining 320 bytes. | Temporary installer at $5000, line 1155 | `bootstrapRecoverLoadAddress` | Ch. 52–56; App. C, E |

## F.5 Resident monitor data and panel framework

| Label | Purpose | Physical source region | Principal callers or consumers | Book |
|---|---|---|---|---|
| `relocatablePayloadStart` / `ENTRY_POINT_WITH_MONITOR` | Connects full-entry semantics, origin-zero words and the optional prefix; adjacent labels are aliases or nested public anchors. | Resident monitor data and panel framework, line 1182 | fall-through, alias, emitted data or external entry; `installerPrepareAssemblerOnlyImage`, `varcInstallerSavedStackPointer`, `relocationExceptionMonitorEntryDescriptorWord` | Ch. 3, 50 |
| `frontPanelItemDescriptors` / `frontPanelEditLineItem` | Complete seven-byte position, heading, source, format, size/capability and value-address language; adjacent labels are aliases or nested public anchors. | Resident monitor data and panel framework, line 1233 | `varcActiveFrontPanelItemOffset`, `redrawEntireFrontPanel`; `getMonitorEditLineBitmapRowStart` | Ch. 6, 33, 34 |
| `frontPanelListWindowItem` | so user panel editing may move or resize the window without changing the list. | Resident monitor data and panel framework, line 1249 | `monClearListWindow`, `appendLineBufferToMonitorListWindow` | Ch. 33–38, 43; App. C–D |
| `frontPanelListWindowSizeFlags` | Front panel list window size flags. | Resident monitor data and panel framework, line 1255 | `appendLineBufferToMonitorListWindow` | Ch. 33–38, 43; App. C–D |
| `frontPanelDisassemblyWindowItem` | Front panel disassembly window item. | Resident monitor data and panel framework, line 1258 | `redrawFrontPanelFromDisassemblyAddress` | Ch. 33–38, 43; App. C–D |
| `frontPanelRegistersItems` | Front panel registers items. | Resident monitor data and panel framework, line 1273 | `restartRegisterAssignmentInput` | Ch. 33–38, 43; App. C–D |
| `defbDisassemblyAreaTable` | Biased count, hidden dynamic resident range and five user classification windows. | Resident monitor data and panel framework, line 1501 | `monitorRangeTablePointers`, `clearPendingDisassemblySeparatorAndReturn` | Ch. 6, 38, 39 |
| `customDefbDisassemblyAreas` | Custom defb disassembly areas. | Resident monitor data and panel framework, line 1504 | fall-through, alias, emitted data or external entry | Ch. 33–38, 43; App. C–D |
| `defwDisassemblyAreaTable` | Biased count, hidden dynamic resident range and five user classification windows. | Resident monitor data and panel framework, line 1512 | `monitorRangeTablePointers`, `clearPendingDisassemblySeparatorAndReturn` | Ch. 6, 38, 39 |
| `customDefwDisassemblyAreas` | Custom defw disassembly areas. | Resident monitor data and panel framework, line 1515 | fall-through, alias, emitted data or external entry | Ch. 33–38, 43; App. C–D |
| `monitorNavigationAddressStack` | Independent ten-level user navigation history for child-address visits. | Resident monitor data and panel framework, line 1535 | `monLevelUp`, `monLevelDown` | Ch. 35 |
| `setReadProtectedAreas` | Common inclusive range representation for traced instruction controls. | Resident monitor data and panel framework, line 1562 | `varcInstructionControlsDisabled`, `monitorRangeTablePointers` | Ch. 38 |
| `customReadProtectedAreas` | Custom read protected areas. | Resident monitor data and panel framework, line 1565 | fall-through, alias, emitted data or external entry | Ch. 33–38, 43; App. C–D |
| `setWriteProtectedAreas` | Common inclusive range representation for traced instruction controls. | Resident monitor data and panel framework, line 1573 | `varcInstructionControlsDisabled`, `monitorRangeTablePointers` | Ch. 38 |
| `writeProtectionDynamicRangeSlot` | Write protection dynamic range slot. | Resident monitor data and panel framework, line 1575 | `checkRangeAgainstResidentRegionOnly` | Ch. 33–38, 43; App. C–D |
| `customWriteProtectedAreas` | Custom write protected areas. | Resident monitor data and panel framework, line 1577 | fall-through, alias, emitted data or external entry | Ch. 33–38, 43; App. C–D |
| `setExecutionProtectedAreas` | Common inclusive range representation for traced instruction controls. | Resident monitor data and panel framework, line 1585 | `monitorRangeTablePointers`, `stepInstructionAtHL` | Ch. 38 |
| `customExecutionProtectedAreas` | Custom execution protected areas. | Resident monitor data and panel framework, line 1588 | fall-through, alias, emitted data or external entry | Ch. 33–38, 43; App. C–D |
| `directCallAddressList` | duplicate values are accepted. | Resident monitor data and panel framework, line 1612 | `monEditDirectCallAddressList`, `simulateRelativeControlFlow` | Ch. 33–38, 43; App. C–D |
| `directCallAddressStorage` | Direct call address storage. | Resident monitor data and panel framework, line 1615 | fall-through, alias, emitted data or external entry | Ch. 33–38, 43; App. C–D |
| `outputMonitorListLineAndPollContinuation` | Held-key streaming, deliberate continuation key and EDIT fall-through into `startMonitor`. | Resident monitor data and panel framework, line 1639 | `monListDisassembly`, `monListMemoryFromTheCurrentAddress`, `monCharactersFromTheCurrentAddress` | Ch. 33 |

## F.6 Monitor interface and interactive tools

| Label | Purpose | Physical source region | Principal callers or consumers | Book |
|---|---|---|---|---|
| `startMonitor` | Navigation, input, memory, tape, block, reverse-disassembly and native execution commands. | Monitor interface and interactive tools, line 1686 | `monRunToTemporaryBreakpoint`, `keyCodeLimit`, `monitorInputLoop` | Ch. 1, 33 |
| `monitorKeyboardActions` / `monSetCurrentAddress` | Forty bindings stored as cumulative one-byte handler deltas plus normalized key codes; adjacent labels are aliases or nested public anchors. | Monitor interface and interactive tools, line 1788 | `startMonitor`, `monitorKeyboardActionsTable`; `monitorKeyboardActionsTable` | Ch. 33 |
| `monOneByteBack` | Mon one byte back. | Monitor interface and interactive tools, line 1794 | `monitorKeyboardActionsTable` | Ch. 33–42; App. E |
| `monOneByteForward` | Mon one byte forward. | Monitor interface and interactive tools, line 1798 | `monitorKeyboardActionsTable` | Ch. 33–42; App. E |
| `setMonitorCurrentAddressAndRet` | Set monitor current address and ret. | Monitor interface and interactive tools, line 1800 | `monLevelUp`, `varcMonitorCurrentAddress`, `monOneInstructionForward` | Ch. 33–42; App. E |
| `monLevelUp` | Mon level up. | Monitor interface and interactive tools, line 1804 | `monitorKeyboardActionsTable` | Ch. 33–42; App. E |
| `monLevelDown` | Mon level down. | Monitor interface and interactive tools, line 1818 | `monitorKeyboardActionsTable` | Ch. 33–42; App. E |
| `varcMonitorCurrentAddress` | PC remains separate from the contiguous image and is committed after a successful step. | Monitor interface and interactive tools, line 1831 | `startMonitor`, `setMonitorCurrentAddressAndRet`, `monFastTracingToAddress` | Ch. 33, 35, 45 |
| `monOneInstructionForward` | Mon one instruction forward. | Monitor interface and interactive tools, line 1839 | `monitorKeyboardActionsTable` | Ch. 33–42; App. E |
| `monListDisassemblyFromGivenAddress` | Unbounded list-window destination with ordinary continuation-key behavior. | Monitor interface and interactive tools, line 1856 | `monitorKeyboardActionsTable` | Ch. 39, 40 |
| `monListDisassembly` | Unbounded list-window destination with ordinary continuation-key behavior. | Monitor interface and interactive tools, line 1860 | `monitorKeyboardActionsTable` | Ch. 39, 40 |
| `monClearListWindow` | Mon clear list window. | Monitor interface and interactive tools, line 1866 | `monitorKeyboardActionsTable` | Ch. 33–42; App. E |
| `monitorKeyboardActionsTable` | Forty bindings stored as cumulative one-byte handler deltas plus normalized key codes. | Monitor interface and interactive tools, line 1883 | `startMonitor` | Ch. 33 |
| `monMemoryEditingOneShot` | Mon memory editing one shot. | Monitor interface and interactive tools, line 2006 | `monitorKeyboardActionsTable`, `monMemoryEditing` | Ch. 33–42; App. E |
| `editOneMonitorAssemblyLine` | sequence of lines while SPACE performs exactly one line. | Monitor interface and interactive tools, line 2022 | `monMemoryEditing` | Ch. 33–42; App. E |
| `promptForMonitorValue` | Inline prompt tokens, shared edit buffer, expression completion, colon escape and saved-SP error recovery. | Monitor interface and interactive tools, line 2051 | `promptForFirstAndLength`, `promptForFirstAndLast`, `monSetCurrentAddress` | Ch. 19, 26, 33, 35 |
| `monitorInputRestart` | Monitor input restart. | Monitor interface and interactive tools, line 2074 | `promptForMonitorValue`, `retryMonitorInputAfterError` | Ch. 33–42; App. E |
| `monitorInputCompletionDispatch` | `$C3` expression completion versus `$21` fall-through assembly completion. | Monitor interface and interactive tools, line 2091 | `promptForMonitorValue` | Ch. 35, 36 |
| `assembleMonitorInputLine` | Self-modified completion opcode selects temporary-record assembly through ordinary first/second pass handlers. | Monitor interface and interactive tools, line 2102 | fall-through, alias, emitted data or external entry | Ch. 19, 26, 33 and related chapters |
| `getMonitorEditLineBitmapRowStart` | preserved because monitor error display passes its message number in A. | Monitor interface and interactive tools, line 2122 | `startMonitor`, `displayMonitorInputErrorAndDelay`, `renderMonitorInputLine` | Ch. 33–42; App. E |
| `displayMonitorInputErrorAndDelay` | pacing only; no persistent monitor state is changed. | Monitor interface and interactive tools, line 2139 | `retryMonitorInputAfterError`, `retryRegisterAssignmentAfterError` | Ch. 33–42; App. E |
| `retryMonitorInputAfterError` | therefore be corrected without corrupting nested command-handler returns. | Monitor interface and interactive tools, line 2157 | `monitorInputRestart` | Ch. 33–42; App. E |
| `monMemoryEditing` | Mon memory editing. | Monitor interface and interactive tools, line 2161 | `monitorKeyboardActionsTable` | Ch. 33–42; App. E |
| `monToggleInstructionControls` | L, O, MOVE, and FILL have their own previously documented protection behavior. | Monitor interface and interactive tools, line 2179 | `monitorKeyboardActionsTable` | Ch. 33–42; App. E |
| `monCycleDirectCallMode` | the manual's warning that direct CALL/RST modes invalidate timing measurements. | Monitor interface and interactive tools, line 2196 | `monitorKeyboardActionsTable` | Ch. 33–42; App. E |
| `monToggleNumericDisassemblyAddresses` | flag to zero so a decimal/hexadecimal address is not mistaken for source text. | Monitor interface and interactive tools, line 2221 | `monitorKeyboardActionsTable` | Ch. 33–42; App. E |
| `monCycleDisassemblyAddressMode` | +1 substitution applies only to two-byte operand values. | Monitor interface and interactive tools, line 2236 | `monitorKeyboardActionsTable` | Ch. 33–42; App. E |
| `monSlowTracing` | Repeats the common step, normally redraws, suppresses display under CAPS SHIFT+ENTER. | Monitor interface and interactive tools, line 2259 | `monitorKeyboardActionsTable` | Ch. 48 |
| `waitForAllKeysReleased` | paths share the same release wait. | Monitor interface and interactive tools, line 2269 | `varcFastTraceStopAddress`, `varcRangedDisassemblyOutputCall`, `acknowledgeMonitorOperationError` | Ch. 33–42; App. E |
| `monFastTracingToAddress` | Repeats without normal redraw, optionally displays, and tests Last after each committed step. | Monitor interface and interactive tools, line 2285 | `monitorKeyboardActionsTable` | Ch. 48 |
| `varcFastTraceStopAddress` | Self-modified operand or instruction carrying persistent runtime state. | Monitor interface and interactive tools, line 2293 | `monFastTracingToAddress` | Ch. 33–42; App. E |
| `monToggleInterruptEnableState` | panel's EI/DI item also reads this same self-modified immediate. | Monitor interface and interactive tools, line 2307 | `monitorKeyboardActionsTable` | Ch. 33–42; App. E |
| `monSaveBlockFirstLast` | Inclusive range or First/Length monitor block SAVE. | Monitor interface and interactive tools, line 2334 | `monitorKeyboardActionsTable` | Ch. 41 |
| `monSaveBlockFirstLength` | Inclusive range or First/Length monitor block SAVE. | Monitor interface and interactive tools, line 2338 | `monitorKeyboardActionsTable` | Ch. 41 |
| `prepareMonitorTapeBlockParameters` | Stack-held First/Last conversion to IX=start, DE=length and A=low Leader byte. | Monitor interface and interactive tools, line 2398 | `monSaveBlockFirstLength`, `monLoadBlockFirstLength` | Ch. 41 |
| `monLoadBlockFirstLast` | Raw exact-flag/length LOAD with resident destination protection. | Monitor interface and interactive tools, line 2428 | `monitorKeyboardActionsTable` | Ch. 41 |
| `monLoadBlockFirstLength` | Raw exact-flag/length LOAD with resident destination protection. | Monitor interface and interactive tools, line 2432 | `monitorKeyboardActionsTable` | Ch. 41 |
| `monReadTapeHeaderOrLeader` | Eighteen-byte retained flag/header read, full header display or raw leader display. | Monitor interface and interactive tools, line 2483 | `monitorKeyboardActionsTable` | Ch. 41 |
| `monSwapPrimaryAndAlternateRegisters` | Bytewise swap of saved BC/DE/HL/AF and BC'/DE'/HL'/AF' without disturbing monitor live registers. | Monitor interface and interactive tools, line 2561 | `monitorKeyboardActionsTable` | Ch. 43 |
| `monDisassemblyOnPrinter` | Selects channel-3 output as the per-line sink for ranged disassembly. | Monitor interface and interactive tools, line 2587 | `monitorKeyboardActionsTable` | Ch. 40 |
| `varcRangedDisassemblyOutputCall` | Self-modified CALL operand selects printer or source insertion without duplicating the range driver. | Monitor interface and interactive tools, line 2631 | `monDisassemblyOnPrinter` | Ch. 5, 40 |
| `finishRangedDisassembly` | Finish ranged disassembly. | Monitor interface and interactive tools, line 2644 | `monDisassemblyOnPrinter`, `monDisassembleIntoSource` | Ch. 33–42; App. E |
| `recoverRangedDisassemblyInsertionError` | Saved-SP recovery, interactive correction, retry and non-transactional partial completion. | Monitor interface and interactive tools, line 2657 | `monDisassemblyOnPrinter` | Ch. 40 |
| `monDisassembleIntoSource` | Disables numeric prefixes and selects canonical editor-source insertion. | Monitor interface and interactive tools, line 2679 | `monitorKeyboardActionsTable` | Ch. 40 |
| `copyDisassemblyLineToInputBuffer` | Fixed 32-byte transfer followed by ordinary parser, symbol and compressed-record machinery. | Monitor interface and interactive tools, line 2691 | `monDisassembleIntoSource` | Ch. 40 |
| `parseAndInsertDisassemblyLine` | Fixed 32-byte transfer followed by ordinary parser, symbol and compressed-record machinery. | Monitor interface and interactive tools, line 2702 | `recoverRangedDisassemblyInsertionError` | Ch. 40 |
| `monSetBreakpointRunStartOrExecute` | W patches the later native run-start operand; SYMBOL SHIFT+U enters breakpoint execution. | Monitor interface and interactive tools, line 2741 | `monitorKeyboardActionsTable` | Ch. 44 |
| `monRunToTemporaryBreakpoint` | Saves three bytes, installs protected JP to capture, runs natively and restores displaced bytes after a hit. | Monitor interface and interactive tools, line 2747 | `monitorKeyboardActionsTable`, `monSetBreakpointRunStartOrExecute` | Ch. 44 |
| `varcBreakpointRunStartAddress` | Self-modified native JP target remembered by W. | Monitor interface and interactive tools, line 2760 | `monSetBreakpointRunStartOrExecute` | Ch. 44 |
| `copyThreeBytesFromHLToDE` | Single three-byte breakpoint slot and raw post-capture restoration. | Monitor interface and interactive tools, line 2771 | `monRunToTemporaryBreakpoint` | Ch. 44 |
| `adjustSavedRefreshRegisterLow7` | Compensates known monitor/trampoline fetches while preserving R bit 7. | Monitor interface and interactive tools, line 2781 | `restoreUserStateAndExecuteTrampoline`, `varcRestoreMonitorStackAfterExecution` | Ch. 43, 44, 48 |
| `savedBreakpointOriginalBytes` | Single three-byte breakpoint slot and raw post-capture restoration. | Monitor interface and interactive tools, line 2794 | `monRunToTemporaryBreakpoint` | Ch. 44 |
| `monCallSubroutineWithSavedState` | Prompted real CALL using saved registers and user SP; native body is untraced and untimed. | Monitor interface and interactive tools, line 2806 | `monitorKeyboardActionsTable` | Ch. 44 |
| `executeNativeCallOrJumpThroughTrampoline` | Common DI/EI + CALL/JP + two-capture-exit builder. | Monitor interface and interactive tools, line 2822 | `varcBreakpointRunStartAddress` | Ch. 44, 45 |
| `monMoveBlockFirstLast` | Inclusive source range, destination-end calculation, resident check and overlap-safe move. | Monitor interface and interactive tools, line 2846 | `monitorKeyboardActionsTable` | Ch. 37 |
| `monMoveBlockFirstLength` | Inclusive source range, destination-end calculation, resident check and overlap-safe move. | Monitor interface and interactive tools, line 2850 | `monitorKeyboardActionsTable` | Ch. 37 |
| `monFillBlockFirstLast` | Low-byte fill value, explicit first store and LDIR replication. | Monitor interface and interactive tools, line 2885 | `monitorKeyboardActionsTable` | Ch. 37 |
| `monFillBlockFirstLength` | Low-byte fill value, explicit first store and LDIR replication. | Monitor interface and interactive tools, line 2889 | `monitorKeyboardActionsTable` | Ch. 37 |
| `monListMemoryFromAGivenAddress` | reads RAM and does not consult the configurable READ-protection windows. | Monitor interface and interactive tools, line 2934 | `monitorKeyboardActionsTable` | Ch. 33–42; App. E |
| `monListMemoryFromTheCurrentAddress` | Mon list memory from the current address. | Monitor interface and interactive tools, line 2938 | `monitorKeyboardActionsTable` | Ch. 33–42; App. E |
| `monCharactersFromAGivenAddress` | configurable READ-protection windows. | Monitor interface and interactive tools, line 3010 | `monitorKeyboardActionsTable` | Ch. 33–42; App. E |
| `monCharactersFromTheCurrentAddress` | Mon characters from the current address. | Monitor interface and interactive tools, line 3014 | `monitorKeyboardActionsTable` | Ch. 33–42; App. E |
| `appendMemoryByteAsDisplayCharacter` | Dot substitution for control codes while preserving bit-7 inverse state. | Monitor interface and interactive tools, line 3040 | `monListMemoryFromTheCurrentAddress`, `monCharactersFromTheCurrentAddress` | Ch. 34, 36 |
| `monEditDirectCallAddressList` | The display formatter may show a matching symbol beside each numeric value. | Monitor interface and interactive tools, line 3067 | `monitorKeyboardActionsTable` | Ch. 33–42; App. E |
| `monFindSequence` | Five expression/colon prompts, low-byte values, `$FF/$00` masks and self-modified prompt digit. | Monitor interface and interactive tools, line 3116 | `monitorKeyboardActionsTable` | Ch. 37 |
| `monNextSequence` | Reuses saved pattern, begins at current+1 and scans the 16-bit address ring candidate by candidate. | Monitor interface and interactive tools, line 3142 | `monitorKeyboardActionsTable` | Ch. 37 |
| `testKeysForAreas` | Keys 1–5 select one general range-table editor. | Monitor interface and interactive tools, line 3209 | `startMonitor` | Ch. 38 |
| `monitorRangeTablePointers` | Keys 1–5 select one general range-table editor. | Monitor interface and interactive tools, line 3263 | `testKeysForAreas` | Ch. 38 |
| `monitorFindByteMaskPairs` | Five adjacent `(value,mask)` pairs using `(memory XOR value) AND mask`. | Monitor interface and interactive tools, line 3269 | `monFindSequence`, `monNextSequence` | Ch. 6, 37 |
| `retryRegisterAssignmentAfterError` | Retry register assignment after error. | Monitor interface and interactive tools, line 3297 | `setRegisterValue` | Ch. 33–42; App. E |
| `setRegisterValue` | Descriptor-driven register/name matching, expression assignment and F-bit shorthand. | Monitor interface and interactive tools, line 3332 | `startMonitor` | Ch. 35 |
| `restartRegisterAssignmentInput` | Restart register assignment input. | Monitor interface and interactive tools, line 3339 | `retryRegisterAssignmentAfterError`, `setRegisterValue` | Ch. 33–42; App. E |
| `flagToggleSelectorMaskPairs` | Flag toggle selector mask pairs. | Monitor interface and interactive tools, line 3388 | `restartRegisterAssignmentInput` | Ch. 33–42; App. E |
| `writeMonitorTextToDE` | Write monitor text to de. | Monitor interface and interactive tools, line 3428 | `displayAndEditDirectCallAddressList`, `varcRangeTableDisplayCarrySetup` | Ch. 33–42; App. E |
| `displayAndEditFiveRangeTable` | Hidden pair skipped, I insertion, reversed-range rejection and 0–4 deletion/compaction. | Monitor interface and interactive tools, line 3477 | `testKeysForAreas` | Ch. 38 |
| `displayAndEditDirectCallAddressList` | remains in carry-set mode for the five range/protection-table editors. | Monitor interface and interactive tools, line 3488 | `monEditDirectCallAddressList` | Ch. 33–42; App. E |
| `varcRangeTableDisplayCarrySetup` | Self-modified operand or instruction carrying persistent runtime state. | Monitor interface and interactive tools, line 3505 | `displayAndEditDirectCallAddressList` | Ch. 33–42; App. E |
| `varcRangeTableSkipHiddenEntryTest` | Self-modified operand or instruction carrying persistent runtime state. | Monitor interface and interactive tools, line 3514 | `displayAndEditDirectCallAddressList` | Ch. 33–42; App. E |
| `varcAddressTableSecondWordCarrySetup` | Self-modified operand or instruction carrying persistent runtime state. | Monitor interface and interactive tools, line 3532 | `displayAndEditDirectCallAddressList` | Ch. 33–42; App. E |
| `keyCodeLimit` | Key code limit. | Monitor interface and interactive tools, line 3546 | `displayAndEditDirectCallAddressList` | Ch. 33–42; App. E |
| `appendRangeEndpointToDisplayLine` | Append range endpoint to display line. | Monitor interface and interactive tools, line 3552 | `varcRangeTableSkipHiddenEntryTest`, `varcAddressTableSecondWordCarrySetup` | Ch. 33–42; App. E |
| `initializeMonitorLineAssembler` | Monitor one-line assembly invokes the ordinary first- and second-pass handlers. | Monitor interface and interactive tools, line 3588 | `assembleMonitorInputLine`, `monMemoryEditingOneShot`, `monMemoryEditing` | Ch. 19, 26 |
| `monitorInputBuffersInitialization` | Shared guarded cursor line, protected prompt tokens, ENTER and EDIT behavior. | Monitor interface and interactive tools, line 3602 | `startMonitor`, `promptForMonitorValue`, `setRegisterValue` | Ch. 35 |
| `renderMonitorInputLine` | tokens into text. The assembler later restores its own token table. | Monitor interface and interactive tools, line 3617 | `startMonitor`, `monitorInputLoop`, `showMonitorOperationError` | Ch. 33–42; App. E |
| `monitorInputLoop` | Shared guarded cursor line, protected prompt tokens, ENTER and EDIT behavior. | Monitor interface and interactive tools, line 3633 | `monitorInputRestart`, `recoverRangedDisassemblyInsertionError`, `restartRegisterAssignmentInput` | Ch. 35 |
| `promptForFirstAndLength` | Several block commands then share the same implementation as their First/Last. | Monitor interface and interactive tools, line 3662 | `monSaveBlockFirstLength`, `monLoadBlockFirstLength`, `monMoveBlockFirstLength` | Ch. 33–42; App. E |
| `promptForFirstAndLast` | therefore compact data plus executable continuation, not an actual branch. | Monitor interface and interactive tools, line 3678 | `monSaveBlockFirstLast`, `monLoadBlockFirstLast`, `monDisassemblyOnPrinter` | Ch. 33–42; App. E |
| `preserveBlockRangeAndCheckResidentWrite` | synthesized resident/source interval and reports Read/Write ERROR on overlap. | Monitor interface and interactive tools, line 3693 | `monLoadBlockFirstLength`, `monReadTapeHeaderOrLeader`, `monFillBlockFirstLength` | Ch. 33–42; App. E |
| `checkBlockDestinationAgainstResidentRegion` | preserves and documents that behavior rather than silently changing it. | Monitor interface and interactive tools, line 3712 | `monMoveBlockFirstLength` | Ch. 33–42; App. E |
| `showMonitorReadWriteError` | Rebuilds monitor error line, restores saved R, acknowledges and warm-restarts monitor. | Monitor interface and interactive tools, line 3724 | `varcInstructionControlsDisabled`, `validateMatchedMemoryAccess`, `monLoadBlockFirstLength` | Ch. 47 |
| `showMonitorOperationError` | Rebuilds monitor error line, restores saved R, acknowledges and warm-restarts monitor. | Monitor interface and interactive tools, line 3726 | `stepInstructionAtHL`, `validateInstructionBeforeExecution` | Ch. 47 |
| `varcRestoreRBeforeOperationError` | Preserves the user-visible saved R value for rejected pre-execution paths. | Monitor interface and interactive tools, line 3733 | `stepInstructionAtHL` | Ch. 49 |
| `acknowledgeMonitorOperationError` | Acknowledge monitor operation error. | Monitor interface and interactive tools, line 3736 | `checkBlockDestinationAgainstResidentRegion` | Ch. 33–42; App. E |

## F.7 Execution, tracing and control-flow repair

| Label | Purpose | Physical source region | Principal callers or consumers | Book |
|---|---|---|---|---|
| `stepAtCurrentMonitorAddress` | State restoration/capture, control-flow repair, scratch construction and READ/WRITE prediction. | Execution, tracing and control-flow repair, line 3744 | `monSlowTracing`, `monFastTracingToAddress` | Ch. 49 |
| `stepInstructionAtHL` | Complete controller from committed current address through redraw-policy return. | Execution, tracing and control-flow repair, line 3770 | `startMonitor` | Ch. 49 |
| `varcPostTakenControlFlowCallback` | Self-modified operand or instruction carrying persistent runtime state. | Execution, tracing and control-flow repair, line 3829 | `stepInstructionAtHL` | Ch. 43–49; App. A, G |
| `testCapsShiftEnter` | Final state commit and caller-neutral redraw policy. | Execution, tracing and control-flow repair, line 3842 | `varcRangedDisassemblyOutputCall` | Ch. 48, 49 |
| `restoreUserStateAndExecuteTrampoline` | Complete POP restoration, user-SP activation and jump into generated scratch code. | Execution, tracing and control-flow repair, line 3855 | `executeNativeCallOrJumpThroughTrampoline`, `stepInstructionAtHL` | Ch. 43, 45, 49 |
| `captureUserStateAfterTakenFlow` | Common serializer with path-specific PC and timing inputs. | Execution, tracing and control-flow repair, line 3886 | `appendSequentialAndTakenCaptureJumps` | Ch. 43, 45 |
| `varcTakenFlowTStates` | Handler-adjusted timing paired with the taken logical PC. | Execution, tracing and control-flow repair, line 3903 | `stepInstructionAtHL` | Ch. 46, 48 |
| `varcTakenFlowNextAddress` | Neutral initialization followed by handler-specific logical taken target. | Execution, tracing and control-flow repair, line 3905 | `stepInstructionAtHL` | Ch. 43, 45, 49 |
| `breakpointHitCaptureEntry` | Compatible one-byte fall-through into the common sequential state serializer. | Execution, tracing and control-flow repair, line 3914 | `monRunToTemporaryBreakpoint`, `varcBreakpointRunStartAddress` | Ch. 43, 44 |
| `captureUserStateAfterSequentialFlow` | Common serializer with path-specific PC and timing inputs. | Execution, tracing and control-flow repair, line 3922 | `appendSequentialAndTakenCaptureJumps` | Ch. 43, 45 |
| `varcDecodedInstructionTStates` | Decoder-patched base timing used by sequential capture. | Execution, tracing and control-flow repair, line 3944 | `decodeInstructionAtHL`, `stepInstructionAtHL`, `directCallModeGateOpcode` | Ch. 48 |
| `varcSequentialNextAddress` | Neutral initialization followed by handler-specific logical taken target. | Execution, tracing and control-flow repair, line 3946 | `stepInstructionAtHL`, `replaceScratchCallReturnAddress`, `simulateRelativeControlFlow` | Ch. 43, 45, 49 |
| `varcRestoreMonitorStackAfterExecution` | Self-modified `LD SP,nn` reactivates the dormant monitor call chain after capture. | Execution, tracing and control-flow repair, line 3974 | `restoreUserStateAndExecuteTrampoline` | Ch. 5, 43, 45 |
| `replaceScratchCallReturnAddress` | Converts the real scratch CALL return word into the original program's sequential PC. | Execution, tracing and control-flow repair, line 3993 | `directCallModeGateOpcode` | Ch. 46 |
| `advanceSavedStackAfterReturn` | Applies the logical two-byte stack pop only after a taken simulated return. | Execution, tracing and control-flow repair, line 4008 | `directCallModeGateOpcode` | Ch. 46 |
| `noPostFlowStackAdjustment` | No post flow stack adjustment. | Execution, tracing and control-flow repair, line 4013 | `stepInstructionAtHL`, `varcPostTakenControlFlowCallback` | Ch. 43–49; App. A, G |
| `tracedControlFlowHandlerOffsets` | Opcode-shaped bytes are compact offsets to eight neighboring simulation handlers. | Execution, tracing and control-flow repair, line 4022 | `stepInstructionAtHL` | Ch. 46 |
| `simulateRelativeControlFlow` | Rewrites `$FE` to scratch displacement `+3`, retains logical `$8002`, selects taken timing. | Execution, tracing and control-flow repair, line 4037 | `stepInstructionAtHL` | Ch. 46, 49 |
| `restoreStackAfterDirectCallScan` | Restore stack after direct call scan. | Execution, tracing and control-flow repair, line 4087 | `simulateRelativeControlFlow` | Ch. 43–49; App. A, G |
| `directCallModeGateOpcode` | NOP/RET Z/RET encode NON/DEF/ALL; SP is temporarily reused as target-list iterator. | Execution, tracing and control-flow repair, line 4090 | `startMonitor`, `monCycleDirectCallMode` | Ch. 33, 44, 46, 48 |
| `buildInstructionExecutionTrampoline` | Exact two-byte `DJNZ` example with saved DI and paired capture jumps. | Execution, tracing and control-flow repair, line 4160 | `stepInstructionAtHL` | Ch. 45, 49 |
| `appendSequentialAndTakenCaptureJumps` | Fixed pair of absolute exits supports ordinary fall-through and later rewritten taken flow. | Execution, tracing and control-flow repair, line 4170 | `executeNativeCallOrJumpThroughTrampoline`, `directCallModeGateOpcode` | Ch. 45 |
| `writeJumpAtHL` | Fixed pair of absolute exits supports ordinary fall-through and later rewritten taken flow. | Execution, tracing and control-flow repair, line 4174 | `appendSequentialAndTakenCaptureJumps` | Ch. 45 |
| `writeDEWordAtHLAndAdvance` | Write deword at hland advance. | Execution, tracing and control-flow repair, line 4176 | `directCallModeGateOpcode` | Ch. 43–49; App. A, G |
| `beginExecutionTrampoline` | Maps Boolean saved interrupt state to opcode `$F3` DI or `$FB` EI. | Execution, tracing and control-flow repair, line 4183 | `executeNativeCallOrJumpThroughTrampoline`, `buildInstructionExecutionTrampoline` | Ch. 43, 45 |
| `validateInstructionBeforeExecution` | Rejects exact HALT under saved DI before the controls-disabled switch. | Execution, tracing and control-flow repair, line 4199 | `stepInstructionAtHL` | Ch. 47 |
| `varcInstructionControlsDisabled` | Inverse Boolean: zero enables READ/WRITE/RUN checks; nonzero skips them. | Execution, tracing and control-flow repair, line 4233 | `startMonitor`, `monToggleInstructionControls`, `stepInstructionAtHL` | Ch. 47, 48 |
| `validateMatchedMemoryAccess` | Checks one or two addresses separately, preserving `$FFFF` to `$0000` wrap behavior. | Execution, tracing and control-flow repair, line 4314 | `varcInstructionControlsDisabled` | Ch. 47 |
| `matchInstructionAccessDescriptor` | Shared masked-opcode/prefix matcher returns low selector bits and width through flags. | Execution, tracing and control-flow repair, line 4351 | `varcInstructionControlsDisabled`, `stepInstructionAtHL` | Ch. 46, 47 |
| `effectiveAddressAccessorOffsets` | Selects saved BC, DE, HL, IX+d, IY+d, SP, SP-2 or decoded NN. | Execution, tracing and control-flow repair, line 4391 | `validateMatchedMemoryAccess`, `matchInstructionAccessDescriptor` | Ch. 47 |
| `loadEffectiveAddressFromBC` | Load effective address from bc. | Execution, tracing and control-flow repair, line 4399 | `validateMatchedMemoryAccess`, `matchInstructionAccessDescriptor` | Ch. 43–49; App. A, G |
| `varcDecodedInstructionOperandWord` | LD HL,nn / RET accessor. | Execution, tracing and control-flow repair, line 4428 | `stepInstructionAtHL` | Ch. 43–49; App. A, G |
| `disassembleNextLineToBuffer` | Neutral line buffer, protection checks, list output and descriptor-driven panel. | Execution, tracing and control-flow repair, line 4480 | `monListDisassembly`, `monDisassemblyOnPrinter`, `clearPendingDisassemblySeparatorAndReturn` | Ch. 2, 38, 39 |
| `clearMonitorLineBuffer` | after clearing its self-modified flag. | Execution, tracing and control-flow repair, line 4490 | `beginMonitorListOutputWithBlankLine` | Ch. 43–49; App. A, G |
| `clearPendingDisassemblySeparatorAndReturn` | unchanged so the next call decodes the address that follows the transfer. | Execution, tracing and control-flow repair, line 4502 | `varcInterruptEnableState` | Ch. 43–49; App. A, G |
| `dispatchDisassemblyOperandHandler` | Self-relative handler-vector example. | Execution, tracing and control-flow repair, line 4552 | `stepInstructionAtHL`, `validateMatchedMemoryAccess`, `matchInstructionAccessDescriptor` | Ch. 4, 6 |
| `disassemblyOperandHandlerOffsets` | Full disassembler consumer remains for Part V. | Execution, tracing and control-flow repair, line 4563 | `clearPendingDisassemblySeparatorAndReturn` | Ch. 6 |
| `normalizeSignedDisplacementMagnitude` | literal '+' between IX/IY and a positive displacement. | Execution, tracing and control-flow repair, line 4577 | `formatIndexedDisplacementOperand` | Ch. 43–49; App. A, G |
| `formatIndexedDisplacementOperand` | Format indexed displacement operand. | Execution, tracing and control-flow repair, line 4586 | `clearPendingDisassemblySeparatorAndReturn` | Ch. 43–49; App. A, G |
| `varcDisassemblyInstructionAddress` | symbolic-prefix rendering. | Execution, tracing and control-flow repair, line 4609 | `varcDisassemblyAddressMode`, `varcDecodedInstructionOperandWord`, `clearPendingDisassemblySeparatorAndReturn` | Ch. 43–49; App. A, G |
| `varcDisassemblyAddressMode` | text, so the ordinary expander resolves their spelling and case. | Execution, tracing and control-flow repair, line 4621 | `monCycleDisassemblyAddressMode` | Ch. 43–49; App. A, G |
| `varcShowNumericDisassemblyAddresses` | Self-modified operand or instruction carrying persistent runtime state. | Execution, tracing and control-flow repair, line 4679 | `monToggleNumericDisassemblyAddresses`, `monDisassembleIntoSource` | Ch. 43–49; App. A, G |
| `skipOneColumnAndPrintFixedWidthNumberToIX` | controlled by varcHexMode. | Execution, tracing and control-flow repair, line 4696 | `monReadTapeHeaderOrLeader` | Ch. 43–49; App. A, G |
| `printFixedWidthNumberToIX` | Print fixed width number to ix. | Execution, tracing and control-flow repair, line 4698 | `monCharactersFromTheCurrentAddress`, `appendRangeEndpointToDisplayLine`, `varcShowNumericDisassemblyAddresses` | Ch. 43–49; App. A, G |
| `printCompactNumberToIX` | Print compact number to ix. | Execution, tracing and control-flow repair, line 4701 | `monReadTapeHeaderOrLeader`, `formatIndexedDisplacementOperand`, `varcDisassemblyAddressMode` | Ch. 43–49; App. A, G |
| `appendTaggedSymbolOrdinalToDisassemblyRecord` | it is also used for the +1 suffix. | Execution, tracing and control-flow repair, line 4710 | `varcDisassemblyAddressMode` | Ch. 43–49; App. A, G |
| `appendTwoBytesToDisassemblyExpression` | Append two bytes to disassembly expression. | Execution, tracing and control-flow repair, line 4712 | `varcDisassemblyAddressMode` | Ch. 43–49; App. A, G |
| `findSymbolOrdinalByValue` | Exact operand/address substitution, optional `symbol+1` and first-ordinal behavior. | Execution, tracing and control-flow repair, line 4727 | `varcDisassemblyAddressMode`, `appendRangeEndpointToDisplayLine` | Ch. 39 |
| `varcSymbolValueAreaBase` | Self-modified operand or instruction carrying persistent runtime state. | Execution, tracing and control-flow repair, line 4763 | `findSymbolOrdinalByValue` | Ch. 43–49; App. A, G |

## F.8 Instruction decoding and front-panel rendering

| Label | Purpose | Physical source region | Principal callers or consumers | Book |
|---|---|---|---|---|
| `decodeInstructionAtHL` | Supplies validity, sequential PC, raw operand, metadata and base timing without executing. | Instruction decoding and front-panel rendering, line 4811 | `monOneInstructionForward`, `stepInstructionAtHL`, `clearPendingDisassemblySeparatorAndReturn` | Ch. 39, 49 |
| `addAtoHL` | Register-role reading rather than a complete arithmetic catalogue. | Instruction decoding and front-panel rendering, line 4909 | `testKeysForAreas`, `stepInstructionAtHL`, `validateMatchedMemoryAccess` | Ch. 4 |
| `checkRangeAgainstResidentRegionOnly` | Hard-coded biased count two checks exactly the synthesized resident/source range. | Instruction decoding and front-panel rendering, line 4932 | `checkBlockDestinationAgainstResidentRegion` | Ch. 37, 38 |
| `checkRangeAgainstProtectionTable` | Dynamic pair installation, table-as-stack traversal, inclusive overlap and malformed-range result. | Instruction decoding and front-panel rendering, line 4953 | `varcInstructionControlsDisabled` | Ch. 38 |
| `restoreProtectionCheckStackAndReturn` | Restore protection check stack and return. | Instruction decoding and front-panel rendering, line 4993 | `checkRangeAgainstProtectionTable`, `checkRangeAgainstResidentRegionOnly` | Ch. 34, 39–40; App. D |
| `checkAddressAgainstProtectionTable` | Single-address containment with the same hidden-slot and SP-restoration technique. | Instruction decoding and front-panel rendering, line 5005 | `validateMatchedMemoryAccess`, `clearPendingDisassemblySeparatorAndReturn`, `stepInstructionAtHL` | Ch. 38 |
| `restoreAddressCheckStackAndReturn` | Restore address check stack and return. | Instruction decoding and front-panel rendering, line 5030 | `checkAddressAgainstProtectionTable` | Ch. 34, 39–40; App. D |
| `beginMonitorListOutputWithBlankLine` | at the start of an operation. | Instruction decoding and front-panel rendering, line 5040 | `monListDisassembly`, `monReadTapeHeaderOrLeader`, `monListMemoryFromTheCurrentAddress` | Ch. 34, 39–40; App. D |
| `appendLineBufferToMonitorListWindow` | across the entire operation so listing loops keep their memory pointer. | Instruction decoding and front-panel rendering, line 5054 | `monReadTapeHeaderOrLeader`, `outputMonitorListLineAndPollContinuation`, `monDisassemblyOnPrinter` | Ch. 34, 39–40; App. D |
| `renderLineBufferAtMonitorListCursor` | that bit to invert ink and paper. | Instruction decoding and front-panel rendering, line 5084 | `varcFrontPanelDisassemblyAddress` | Ch. 34, 39–40; App. D |
| `invokeFrontPanelEditor` | Attribute-screen occupancy map, cyclic descriptor selection, movement, size and format editing. | Instruction decoding and front-panel rendering, line 5122 | `startMonitor`, `configurationPatchTarget04MonitorNormalTextAttribute` | Ch. 34 |
| `configurationPatchTarget07FrontPanelEditorFillAttribute` | @config-patch 07. | Instruction decoding and front-panel rendering, line 5129 | installer/generated metadata | Ch. 34, 39–40; App. D |
| `configurationPatchTarget08FrontPanelEditorCompareAttribute` | @config-patch 08. | Instruction decoding and front-panel rendering, line 5141 | installer/generated metadata | Ch. 34, 39–40; App. D |
| `varcActiveFrontPanelItemOffset` | Self-modified operand or instruction carrying persistent runtime state. | Instruction decoding and front-panel rendering, line 5167 | `configurationPatchTarget04MonitorNormalTextAttribute` | Ch. 34, 39–40; App. D |
| `configurationPatchTarget14MonitorAccessLineAttribute` | @config-patch 14. | Instruction decoding and front-panel rendering, line 5173 | installer/generated metadata | Ch. 34, 39–40; App. D |
| `configurationPatchTarget04MonitorNormalTextAttribute` | @config-patch 04. | Instruction decoding and front-panel rendering, line 5178 | installer/generated metadata | Ch. 34, 39–40; App. D |
| `frontPanelFormatToggleKeyTable` | Generic `(key, capability, XOR bit)` property edits. | Instruction decoding and front-panel rendering, line 5298 | `configurationPatchTarget04MonitorNormalTextAttribute` | Ch. 34 |
| `redrawFrontPanelAtCurrentAddress` | Ordinary 32-item redraw preserves edit/list areas; complete 34-item redraw supports panel editing. | Instruction decoding and front-panel rendering, line 5320 | `startMonitor`, `monSlowTracing`, `monFastTracingToAddress` | Ch. 33, 34 |
| `redrawFrontPanelFromDisassemblyAddress` | Redraw front panel from disassembly address. | Instruction decoding and front-panel rendering, line 5322 | `monMemoryEditing` | Ch. 34, 39–40; App. D |
| `redrawEntireFrontPanel` | Ordinary 32-item redraw preserves edit/list areas; complete 34-item redraw supports panel editing. | Instruction decoding and front-panel rendering, line 5333 | `configurationPatchTarget07FrontPanelEditorFillAttribute` | Ch. 33, 34 |
| `renderFrontPanelItemIfEnabled` | Generic visibility, data-source resolution, heading and multi-format value rendering. | Instruction decoding and front-panel rendering, line 5363 | `redrawEntireFrontPanel` | Ch. 34 |
| `renderFrontPanelItem` | Generic visibility, data-source resolution, heading and multi-format value rendering. | Instruction decoding and front-panel rendering, line 5380 | `configurationPatchTarget14MonitorAccessLineAttribute` | Ch. 34 |
| `clearOrRenderFrontPanelSpecialArea` | the current EI/DI mnemonic from varcInterruptEnableState. | Instruction decoding and front-panel rendering, line 5495 | `monClearListWindow` | Ch. 34, 39–40; App. D |
| `varcInterruptEnableState` | Boolean state shared by panel, toggle, HALT guard and DI/EI trampoline generation. | Instruction decoding and front-panel rendering, line 5516 | `monToggleInterruptEnableState`, `varcRestoreMonitorStackAfterExecution`, `beginExecutionTrampoline` | Ch. 43, 48 |
| `varcFrontPanelDisassemblyAddress` | Fixed descriptor-sized disassembly destination using the same decoder and renderer. | Instruction decoding and front-panel rendering, line 5533 | `redrawEntireFrontPanel` | Ch. 34, 40 |
| `setPrintingPositionForItemData` | Set printing position for item data. | Instruction decoding and front-panel rendering, line 5546 | `renderFrontPanelItem`, `clearOrRenderFrontPanelSpecialArea`, `frontPanelFlagBitHeadingText` | Ch. 34, 39–40; App. D |
| `frontPanelFlagBitHeadingText` | Front panel flag bit heading text. | Instruction decoding and front-panel rendering, line 5553 | fall-through, alias, emitted data or external entry | Ch. 34, 39–40; App. D |
| `frontPanelConditionNameSelectionTable` | is data and that apparent control-flow edge is not executable. | Instruction decoding and front-panel rendering, line 5637 | `frontPanelFlagBitHeadingText` | Ch. 34, 39–40; App. D |
| `frontPanelValueRendererOffsetTablePrefix` | Compact resident lookup or descriptor table. | Instruction decoding and front-panel rendering, line 5646 | `renderFrontPanelItem` | Ch. 34, 39–40; App. D |
| `dispatchFrontPanelValueRendererWithSeparator` | JP (IX) dispatches without a conventional address table. | Instruction decoding and front-panel rendering, line 5660 | `renderFrontPanelItem`, `renderFrontPanelBinaryByteFromA` | Ch. 34, 39–40; App. D |
| `frontPanelValueRendererCodeBase` | Eight byte/word decimal, hex, binary and character renderers selected through compact offsets. | Instruction decoding and front-panel rendering, line 5673 | `renderFrontPanelItem` | Ch. 34 |
| `renderFrontPanelBinaryByteFromA` | Render front panel binary byte from a. | Instruction decoding and front-panel rendering, line 5702 | `frontPanelFlagBitHeadingText`, `frontPanelValueRendererCodeBase` | Ch. 34, 39–40; App. D |
| `renderFrontPanelCharacterFromA` | Render front panel character from a. | Instruction decoding and front-panel rendering, line 5719 | `renderFrontPanelBinaryByteFromA` | Ch. 34, 39–40; App. D |
| `renderFrontPanelDecimalWord` | Render front panel decimal word. | Instruction decoding and front-panel rendering, line 5731 | `redrawEntireFrontPanel` | Ch. 34, 39–40; App. D |
| `prepareFrontPanelByteValue` | Prepare front panel byte value. | Instruction decoding and front-panel rendering, line 5738 | `frontPanelValueRendererCodeBase` | Ch. 34, 39–40; App. D |
| `prepareFrontPanelNumberBuffer` | Prepare front panel number buffer. | Instruction decoding and front-panel rendering, line 5740 | `frontPanelValueRendererCodeBase` | Ch. 34, 39–40; App. D |
| `renderFrontPanelOperandName` | Render front panel operand name. | Instruction decoding and front-panel rendering, line 5746 | `renderFrontPanelItem`, `frontPanelFlagBitHeadingText` | Ch. 34, 39–40; App. D |
| `resolveAndRenderFrontPanelOperandName` | Resolve and render front panel operand name. | Instruction decoding and front-panel rendering, line 5748 | `varcInterruptEnableState` | Ch. 34, 39–40; App. D |
| `renderFrontPanelHighBitTerminatedText` | This is shared by operand names and the symbolic flags heading. | Instruction decoding and front-panel rendering, line 5755 | `frontPanelFlagBitHeadingText` | Ch. 34, 39–40; App. D |
| `advanceBitmapAddressOneColumnWrappingScreen` | one-column move left while preserving screen wrap semantics. | Instruction decoding and front-panel rendering, line 5776 | `configurationPatchTarget04MonitorNormalTextAttribute` | Ch. 34, 39–40; App. D |
| `advanceBitmapAddressOneTextRow` | and front-panel rendering. | Instruction decoding and front-panel rendering, line 5795 | `appendLineBufferToMonitorListWindow`, `configurationPatchTarget04MonitorNormalTextAttribute`, `renderFrontPanelItem` | Ch. 34, 39–40; App. D |
| `savedRegisterR` | Thirty-byte stack-shaped user image: R, I, alternate bank, index registers, primary bank, SP, accumulated T states and monitor X/Y. | Instruction decoding and front-panel rendering, line 5826 | `frontPanelRegistersItems`, `adjustSavedRefreshRegisterLow7`, `varcRestoreRBeforeOperationError` | Ch. 43 |
| `savedRegisterI` | Saved register i. | Instruction decoding and front-panel rendering, line 5828 | `frontPanelRegistersItems` | Ch. 34, 39–40; App. D |
| `savedAlternateRegisterSet` | Saved alternate register set. | Instruction decoding and front-panel rendering, line 5830 | `monSwapPrimaryAndAlternateRegisters` | Ch. 34, 39–40; App. D |
| `savedRegisterIY` | Saved register iy. | Instruction decoding and front-panel rendering, line 5832 | `frontPanelRegistersItems`, `directCallModeGateOpcode`, `loadEffectiveAddressFromBC` | Ch. 34, 39–40; App. D |
| `savedRegisterIYHigh` | Saved register iyhigh. | Instruction decoding and front-panel rendering, line 5834 | `frontPanelRegistersItems`, `directCallModeGateOpcode`, `loadEffectiveAddressFromBC` | Ch. 34, 39–40; App. D |
| `savedRegisterIX` | Saved register ix. | Instruction decoding and front-panel rendering, line 5836 | `frontPanelRegistersItems` | Ch. 34, 39–40; App. D |
| `savedRegisterIXHigh` | Saved register ixhigh. | Instruction decoding and front-panel rendering, line 5838 | `frontPanelRegistersItems` | Ch. 34, 39–40; App. D |
| `savedRegisterBC` | Saved register bc. | Instruction decoding and front-panel rendering, line 5840 | `frontPanelRegistersItems`, `monSwapPrimaryAndAlternateRegisters`, `varcInstructionControlsDisabled` | Ch. 34, 39–40; App. D |
| `savedRegisterB` | Little-endian byte labels let panel descriptors show individual 8-bit registers or complete pairs without copying. | Instruction decoding and front-panel rendering, line 5842 | `frontPanelRegistersItems` | Ch. 43 |
| `savedRegisterDE` | Saved register de. | Instruction decoding and front-panel rendering, line 5844 | `frontPanelRegistersItems`, `varcInstructionControlsDisabled`, `loadEffectiveAddressFromBC` | Ch. 34, 39–40; App. D |
| `savedRegisterD` | Little-endian byte labels let panel descriptors show individual 8-bit registers or complete pairs without copying. | Instruction decoding and front-panel rendering, line 5846 | `frontPanelRegistersItems`, `directCallModeGateOpcode`, `varcInstructionControlsDisabled` | Ch. 43 |
| `savedRegisterHL` | Saved register hl. | Instruction decoding and front-panel rendering, line 5848 | `frontPanelRegistersItems` | Ch. 34, 39–40; App. D |
| `savedRegisterH` | Saved register h. | Instruction decoding and front-panel rendering, line 5850 | `frontPanelRegistersItems` | Ch. 34, 39–40; App. D |
| `savedRegisterAF` | Saved register af. | Instruction decoding and front-panel rendering, line 5852 | `frontPanelRegistersItems`, `flagToggleSelectorMaskPairs` | Ch. 34, 39–40; App. D |
| `savedRegisterA` | Little-endian byte labels let panel descriptors show individual 8-bit registers or complete pairs without copying. | Instruction decoding and front-panel rendering, line 5854 | `frontPanelRegistersItems` | Ch. 43 |
| `savedRegisterSP` | Saved register sp. | Instruction decoding and front-panel rendering, line 5856 | `frontPanelRegistersItems`, `captureUserStateAfterTakenFlow`, `captureUserStateAfterSequentialFlow` | Ch. 34, 39–40; App. D |
| `accumulatedTStates` | Sixteen-bit committed traced timing with natural wraparound. | Instruction decoding and front-panel rendering, line 5858 | `varcPostTakenControlFlowCallback`, `frontPanelRegistersItems` | Ch. 34, 48 |
| `monitorAddressX` | Monitor address x. | Instruction decoding and front-panel rendering, line 5860 | `frontPanelRegistersItems` | Ch. 34, 39–40; App. D |
| `monitorAddressY` | Thirty-byte stack-shaped user image: R, I, alternate bank, index registers, primary bank, SP, accumulated T states and monitor X/Y. | Instruction decoding and front-panel rendering, line 5862 | `frontPanelRegistersItems` | Ch. 43 |

## F.9 Saved processor image and monitor metadata

| Label | Purpose | Physical source region | Principal callers or consumers | Book |
|---|---|---|---|---|
| `readAccessDescriptorTable` | Packed rows classify protected reads without reproducing every table entry. | Saved processor image and monitor metadata, line 5869 | `varcInstructionControlsDisabled` | Ch. 47 |
| `monitorTables` | Compact resident lookup or descriptor table. | Saved processor image and monitor metadata, line 5894 | `frontPanelRegistersItems`, `customDefbDisassemblyAreas`, `monitorNavigationAddressStack` | Ch. 34, 43, 47–48; App. C–D |
| `writeAccessDescriptorTable` | Packed rows classify protected writes, including stack and immediate-address forms. | Saved processor image and monitor metadata, line 5955 | `varcInstructionControlsDisabled` | Ch. 47 |
| `relocationExceptionMonitorEntryDescriptorWord` | Single `@noreloc` origin-dependent word is opcode-shaped descriptor data rather than a pointer. | Saved processor image and monitor metadata, line 6045 | installer/generated metadata | Ch. 55 |
| `controlFlowDescriptorTable` | Fourteen masked opcode/prefix rows classify relative, absolute, return, restart and indirect flow. | Saved processor image and monitor metadata, line 6053 | `stepInstructionAtHL` | Ch. 46 |
| `monitorTextReferences` / `monitorTextLength` | Monitor text references; adjacent labels are aliases or nested public anchors. | Saved processor image and monitor metadata, line 6098 | fall-through, alias, emitted data or external entry | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextFirst` | Monitor text first. | Saved processor image and monitor metadata, line 6100 | fall-through, alias, emitted data or external entry | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextLast` | Monitor text last. | Saved processor image and monitor metadata, line 6101 | fall-through, alias, emitted data or external entry | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextMemory` | Monitor text memory. | Saved processor image and monitor metadata, line 6102 | fall-through, alias, emitted data or external entry | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextLd` | Monitor text ld. | Saved processor image and monitor metadata, line 6103 | fall-through, alias, emitted data or external entry | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextUniversum` | Monitor text universum. | Saved processor image and monitor metadata, line 6104 | fall-through, alias, emitted data or external entry | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextOn` | Monitor text on. | Saved processor image and monitor metadata, line 6105 | fall-through, alias, emitted data or external entry | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextOff` | Monitor text off. | Saved processor image and monitor metadata, line 6106 | fall-through, alias, emitted data or external entry | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextNon` | Monitor text non. | Saved processor image and monitor metadata, line 6107 | fall-through, alias, emitted data or external entry | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextDef` | Monitor text def. | Saved processor image and monitor metadata, line 6108 | fall-through, alias, emitted data or external entry | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextAll` | Monitor text all. | Saved processor image and monitor metadata, line 6109 | fall-through, alias, emitted data or external entry | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextCall` | Monitor text call. | Saved processor image and monitor metadata, line 6110 | `customExecutionProtectedAreas` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextReadWrite` | Monitor text read write. | Saved processor image and monitor metadata, line 6111 | fall-through, alias, emitted data or external entry | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextRun` | Monitor text run. | Saved processor image and monitor metadata, line 6112 | fall-through, alias, emitted data or external entry | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextInterrupt` | Monitor text interrupt. | Saved processor image and monitor metadata, line 6113 | fall-through, alias, emitted data or external entry | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextError` | Monitor text error. | Saved processor image and monitor metadata, line 6114 | fall-through, alias, emitted data or external entry | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextNoRun` | Monitor text no run. | Saved processor image and monitor metadata, line 6115 | `customWriteProtectedAreas` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextNoWrite` | Monitor text no write. | Saved processor image and monitor metadata, line 6116 | `customReadProtectedAreas` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextNoRead` | Monitor text no read. | Saved processor image and monitor metadata, line 6117 | `monitorNavigationAddressStack` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextDefb` | Monitor text defb. | Saved processor image and monitor metadata, line 6118 | `frontPanelRegistersItems` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextDefw` | Monitor text defw. | Saved processor image and monitor metadata, line 6119 | `customDefbDisassemblyAreas` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextWindows` | Monitor text windows. | Saved processor image and monitor metadata, line 6120 | `varcRangeTableDisplayCarrySetup` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextWith` | Monitor text with. | Saved processor image and monitor metadata, line 6121 | fall-through, alias, emitted data or external entry | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextTo` | Monitor text to. | Saved processor image and monitor metadata, line 6122 | fall-through, alias, emitted data or external entry | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextLeader` | Monitor text leader. | Saved processor image and monitor metadata, line 6123 | fall-through, alias, emitted data or external entry | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextFirstByte` | Monitor text first byte. | Saved processor image and monitor metadata, line 6124 | fall-through, alias, emitted data or external entry | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextsTable` / `monitorTextsTable02` | Compact resident lookup or descriptor table; adjacent labels are aliases or nested public anchors. | Saved processor image and monitor metadata, line 6126 | fall-through, alias, emitted data or external entry; `monitorTextLength` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextsTable03` | Compact resident lookup or descriptor table. | Saved processor image and monitor metadata, line 6128 | `monitorTextFirst` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextsTable04` | Compact resident lookup or descriptor table. | Saved processor image and monitor metadata, line 6129 | `monitorTextLast` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextsTable05` | Compact resident lookup or descriptor table. | Saved processor image and monitor metadata, line 6130 | `monitorTextMemory` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextsTable06` | Compact resident lookup or descriptor table. | Saved processor image and monitor metadata, line 6131 | `monitorTextLd` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextsTable07` | Compact resident lookup or descriptor table. | Saved processor image and monitor metadata, line 6132 | `monitorTextUniversum` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextsTable08` | Compact resident lookup or descriptor table. | Saved processor image and monitor metadata, line 6133 | `monitorTextOn` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextsTable09` | Compact resident lookup or descriptor table. | Saved processor image and monitor metadata, line 6134 | `monitorTextOff` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextsTable10` | Compact resident lookup or descriptor table. | Saved processor image and monitor metadata, line 6135 | `monitorTextNon` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextsTable11` | Compact resident lookup or descriptor table. | Saved processor image and monitor metadata, line 6136 | `monitorTextDef` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextsTable12` | Compact resident lookup or descriptor table. | Saved processor image and monitor metadata, line 6137 | `monitorTextAll` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextsTable13` | Compact resident lookup or descriptor table. | Saved processor image and monitor metadata, line 6138 | `monitorTextCall` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextsTable14` | Compact resident lookup or descriptor table. | Saved processor image and monitor metadata, line 6139 | `monitorTextReadWrite` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextsTable15` | Compact resident lookup or descriptor table. | Saved processor image and monitor metadata, line 6140 | `monitorTextRun` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextsTable16` | Compact resident lookup or descriptor table. | Saved processor image and monitor metadata, line 6141 | `monitorTextInterrupt` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextsTable17` | Compact resident lookup or descriptor table. | Saved processor image and monitor metadata, line 6142 | `monitorTextError` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextsTable18` | Compact resident lookup or descriptor table. | Saved processor image and monitor metadata, line 6143 | `monitorTextNoRun` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextsTable19` | Compact resident lookup or descriptor table. | Saved processor image and monitor metadata, line 6144 | `monitorTextNoWrite` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextsTable20` | Compact resident lookup or descriptor table. | Saved processor image and monitor metadata, line 6145 | `monitorTextNoRead` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextsTable21` | Compact resident lookup or descriptor table. | Saved processor image and monitor metadata, line 6146 | `monitorTextDefb` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextsTable22` | Compact resident lookup or descriptor table. | Saved processor image and monitor metadata, line 6147 | `monitorTextDefw` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextsTable23` | Compact resident lookup or descriptor table. | Saved processor image and monitor metadata, line 6148 | `monitorTextWindows` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextsTable24` | Compact resident lookup or descriptor table. | Saved processor image and monitor metadata, line 6149 | `monitorTextWith` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextsTable25` | Compact resident lookup or descriptor table. | Saved processor image and monitor metadata, line 6150 | `monitorTextTo` | Ch. 34, 43, 47–48; App. C–D |
| `monitorTextsTable26` | Compact resident lookup or descriptor table. | Saved processor image and monitor metadata, line 6151 | `monitorTextLeader` | Ch. 34, 43, 47–48; App. C–D |
| `monitorFindBytePromptDigit` / `monitorTextsTable27` | byte-level alias exists because only the ordinal digit is self-modified. | Saved processor image and monitor metadata, line 6157 | `monFindSequence`; `monitorTextFirstByte` | Ch. 34, 43, 47–48; App. C–D |

## F.10 Editor commands, symbols and tape workflows

| Label | Purpose | Physical source region | Principal callers or consumers | Book |
|---|---|---|---|---|
| `ENTRY_POINT_WITHOUT_MONITOR` | Starts the assembler/editor suffix and its independent installation path. | Editor commands, symbols and tape workflows, line 6164 | `installerPrepareAssemblerOnlyImage` | Ch. 1, 3, 9, 50 |
| `commandHandlerTable` | Dense `$C1`–`$DA` alphabetic dispatch. | Editor commands, symbols and tape workflows, line 6197 | `configurationPatchTarget09HiddenEditLineAttribute` | Ch. 9, 10 |
| `invokeGoToSourceStart` | loop redraws the listing around this pointer after the handler returns. | Editor commands, symbols and tape workflows, line 6233 | `commandHandlerTable` | Ch. 10, 17, 23–32; App. E |
| `invokeGoToSourceEnd` | once backward converts that sentinel into the start address of the last line. | Editor commands, symbols and tape workflows, line 6247 | `commandHandlerTable` | Ch. 10, 17, 23–32; App. E |
| `getSourceEndPosition` | tail area maintained between the visible source window and the table. | Editor commands, symbols and tape workflows, line 6259 | `invokeGoToSourceEnd`, `invokeClear` | Ch. 10, 17, 23–32; App. E |
| `invokeUTop` | $FFFF through 16-bit arithmetic. | Editor commands, symbols and tape workflows, line 6275 | `commandHandlerTable` | Ch. 10, 17, 23–32; App. E |
| `evaluateInputExpression` | Direct command-text evaluation, current-address atom, symbol lookup and stack-held accumulator/operator. | Editor commands, symbols and tape workflows, line 6286 | `monitorInputCompletionDispatch`, `invokeUTop` | Ch. 22 |
| `evaluateExpressionAtHL` | Direct command-text evaluation, current-address atom, symbol lookup and stack-held accumulator/operator. | Editor commands, symbols and tape workflows, line 6310 | `flagToggleSelectorMaskPairs` | Ch. 22 |
| `varcTextAtomUnarySign` | Two's-complement unary minus and self-modified sign state. | Editor commands, symbols and tape workflows, line 6371 | `evaluateExpressionAtHL` | Ch. 22 |
| `deleteSourceLinesAndRestoreTailPadding` | Reinsertion of fixed empty records after large deletion. | Editor commands, symbols and tape workflows, line 6389 | `invokeDelete`, `varcLastStatusBarMessage` | Ch. 7, 16 |
| `invokeReplace` | Expanded-line reconstruction through the normal edit buffer and parser. | Editor commands, symbols and tape workflows, line 6427 | `commandHandlerTable` | Ch. 17, 18 |
| `replaceCommitContinuation` | Restores normal completion and resumes FIND after commit. | Editor commands, symbols and tape workflows, line 6504 | `invokeReplace` | Ch. 17 |
| `invokeFind` | Whole-source, block and continuation forms with persistent pattern/scope state. | Editor commands, symbols and tape workflows, line 6526 | `commandHandlerTable` | Ch. 17 |
| `findNextOccurrence` | Generic callback-driven compressed-record scanner. | Editor commands, symbols and tape workflows, line 6558 | `replaceCommitContinuation` | Ch. 17 |
| `varcFindScanPosition` | Persistent scan cursor and scope flag. | Editor commands, symbols and tape workflows, line 6568 | `invokeFind`, `varcLineScanCallback`, `invokeReplace` | Ch. 17 |
| `varcFindRestrictToBlock` | Persistent scan cursor and scope flag. | Editor commands, symbols and tape workflows, line 6578 | `invokeFind`, `invokePrint` | Ch. 17 |
| `varcLineScanCallback` | FIND/PRINT per-line callback selection. | Editor commands, symbols and tape workflows, line 6589 | `findNextOccurrence` | Ch. 17 |
| `storeLowercaseCommandArgument` | Shared length-prefixed FIND/REPLACE argument storage. | Editor commands, symbols and tape workflows, line 6599 | `invokeReplace`, `invokeFind` | Ch. 17 |
| `invokePrint` | Generic record scan with channel-3 output callback and BREAK handling. | Editor commands, symbols and tape workflows, line 6629 | `commandHandlerTable` | Ch. 17 |
| `printLineBufferToChannel3` | Generic record scan with channel-3 output callback and BREAK handling. | Editor commands, symbols and tape workflows, line 6644 | `invokePrint`, `varcPrintSymbolTable` | Ch. 17 |
| `outputLineBufferToChannel3` | Shared channel-3 line sink used by editor PRINT and monitor D. | Editor commands, symbols and tape workflows, line 6648 | `monDisassemblyOnPrinter` | Ch. 17, 40 |
| `invokeDelete` | Inclusive record counting, common compaction and semantic selection reset. | Editor commands, symbols and tape workflows, line 6671 | `commandHandlerTable`, `invokeClear` | Ch. 7, 16, 18 |
| `findTextInLineBuffer` | Every-position search, separator skipping and case-insensitive matching. | Editor commands, symbols and tape workflows, line 6698 | `findNextOccurrence`, `varcLineScanCallback` | Ch. 17 |
| `matchSearchTextAtDE` | Every-position search, separator skipping and case-insensitive matching. | Editor commands, symbols and tape workflows, line 6717 | `invokeReplace`, `findTextInLineBuffer` | Ch. 17 |
| `searchTextLength` | Persistent FIND pattern workspace. | Editor commands, symbols and tape workflows, line 6738 | `invokeReplace`, `matchSearchTextAtDE` | Ch. 17 |
| `searchTextCharacters` | Persistent FIND pattern workspace. | Editor commands, symbols and tape workflows, line 6740 | `invokeFind` | Ch. 17 |
| `replacementTextStorageBaseMinusOne` | Compact persistent replacement workspace. | Editor commands, symbols and tape workflows, line 6767 | `invokeReplace` | Ch. 17 |
| `displaySymbolTableColumn` | Alphabetical display with reverse vector lookup for state flags and forty-symbol paging. | Editor commands, symbols and tape workflows, line 6801 | `configurationPatchTarget13SymbolTableHighlightAttribute` | Ch. 23 |
| `varcSymbolTableColumnPosition` | Self-modified operand or instruction carrying persistent runtime state. | Editor commands, symbols and tape workflows, line 6817 | `displaySymbolTableColumn` | Ch. 10, 17, 23–32; App. E |
| `varcEndOfSymbolTable` | Alphabetical display with reverse vector lookup for state flags and forty-symbol paging. | Editor commands, symbols and tape workflows, line 6825 | `configurationPatchTarget13SymbolTableHighlightAttribute` | Ch. 23 |
| `varcPrintSymbolTable` | Self-modified operand or instruction carrying persistent runtime state. | Editor commands, symbols and tape workflows, line 6902 | fall-through, alias, emitted data or external entry | Ch. 10, 17, 23–32; App. E |
| `configurationPatchTarget05SymbolTableNormalAttribute` | @config-patch 05. | Editor commands, symbols and tape workflows, line 6933 | installer/generated metadata | Ch. 10, 17, 23–32; App. E |
| `configurationPatchTarget13SymbolTableHighlightAttribute` | @config-patch 13. | Editor commands, symbols and tape workflows, line 6938 | installer/generated metadata | Ch. 10, 17, 23–32; App. E |
| `invokeTable` | TABLE and TABLE P traversal and visible lock/undefined conventions. | Editor commands, symbols and tape workflows, line 7009 | `commandHandlerTable` | Ch. 23 |
| `processSymbolTableItems` | Self-modified SET/RES loop for LOCKED bit 7 and temporary DEFINED/mark bit 6. | Editor commands, symbols and tape workflows, line 7028 | `invokeClear`, `invokeTable`, `processCompilation` | Ch. 5, 23, 24 |
| `varcSymbolVectorFlagInstruction` | Self-modified SET/RES loop for LOCKED bit 7 and temporary DEFINED/mark bit 6. | Editor commands, symbols and tape workflows, line 7043 | `processSymbolTableItems` | Ch. 5, 23, 24 |
| `invokeClear` | Invoke clear. | Editor commands, symbols and tape workflows, line 7054 | `commandHandlerTable` | Ch. 10, 17, 23–32; App. E |
| `varcSymbolEntryAreaBaseForCleanup` | Dynamic physical record-area base used while deleting entries. | Editor commands, symbols and tape workflows, line 7135 | `invokeClear` | Ch. 24 |
| `varcRemovedSymbolEntryOffset` | Threshold for decreasing offsets of physical records displaced by deletion. | Editor commands, symbols and tape workflows, line 7191 | `varcSymbolEntryAreaBaseForCleanup` | Ch. 24 |
| `varcCurrentCompactionVectorPointer` | Resumption point after source ordinals are rewritten for one removed vector. | Editor commands, symbols and tape workflows, line 7239 | `invokeClear`, `varcRemovedSymbolEntryOffset` | Ch. 24 |
| `advanceSymbolVectorAndLoadOffset` | Shared vector traversal and clean fourteen-bit offset extraction. | Editor commands, symbols and tape workflows, line 7243 | `varcSymbolEntryAreaBaseForCleanup`, `varcNewSymbolVectorSlot` | Ch. 24 |
| `findNextSymbolReferenceInSource` | Direct scan of compressed labels and expression ordinals without source expansion. | Editor commands, symbols and tape workflows, line 7260 | `invokeClear`, `varcRemovedSymbolEntryOffset` | Ch. 24 |
| `findNextSymbolReferenceInPayload` | Direct scan of compressed labels and expression ordinals without source expansion. | Editor commands, symbols and tape workflows, line 7271 | `invokeClear`, `varcRemovedSymbolEntryOffset` | Ch. 24 |
| `invokeSave` | Whole/block selection, filename/header construction, length arithmetic, VERIFY state retention and two-segment writer. | Editor commands, symbols and tape workflows, line 7327 | `commandHandlerTable` | Ch. 29 |
| `varcLastSavedSymbolTableStart` | Chained table/bridge state retained for VERIFY. | Editor commands, symbols and tape workflows, line 7386 | `invokeSave`, `varcLastSavedSourceLength` | Ch. 29 |
| `varcLastSavedAuxiliarySegmentLength` | Chained table/bridge state retained for VERIFY. | Editor commands, symbols and tape workflows, line 7389 | `invokeSave`, `varcLastSavedSourceLength` | Ch. 29 |
| `waitForKeyAndWriteTapeHeader` | Start-tape delay, physical-key wait, 17-byte ROM header write and post-header delay. | Editor commands, symbols and tape workflows, line 7408 | `monSaveBlockFirstLength`, `invokeSave` | Ch. 29 |
| `readFileNameWithColon` | Optional colon syntax, ten-character limit and space padding. | Editor commands, symbols and tape workflows, line 7440 | `prepareTapeSourceImport` | Ch. 29 |
| `readFileNameFromInput` | Optional colon syntax, ten-character limit and space padding. | Editor commands, symbols and tape workflows, line 7444 | `invokeSave` | Ch. 29 |
| `copyFileNameFromHLToDE` | Optional colon syntax, ten-character limit and space padding. | Editor commands, symbols and tape workflows, line 7446 | `monSaveBlockFirstLength` | Ch. 29 |
| `fileNameBuffer` | Persistent ten-byte name initialized to `prometheus`, shared across SAVE and LOAD. | Editor commands, symbols and tape workflows, line 7466 | `invokeSave`, `readFileNameFromInput`, `acceptLoadedHeaderIfNameMatchesOrWildcard` | Ch. 29 |
| `invokeVerify` | Exact-name header scan followed by remembered source and chained auxiliary comparison. | Editor commands, symbols and tape workflows, line 7482 | `commandHandlerTable` | Ch. 30 |
| `varcLastSavedSourceStart` | Self-modified exact source range retained for immediate VERIFY. | Editor commands, symbols and tape workflows, line 7488 | `invokeSave` | Ch. 29 |
| `varcLastSavedSourceLength` | Self-modified exact source range retained for immediate VERIFY. | Editor commands, symbols and tape workflows, line 7490 | `invokeSave` | Ch. 29 |
| `performTapeLoadOrVerifyOrReportError` | Shared success/error normalization and `Tape error` path. | Editor commands, symbols and tape workflows, line 7506 | `varcLastSavedSourceLength`, `loadMatchingCodePayloadToTemporaryMemory` | Ch. 30 |
| `invokeLoad` | Record traversal, imported-table expansion, line-buffer transfer and ordinary editor submission. | Editor commands, symbols and tape workflows, line 7535 | `commandHandlerTable` | Ch. 30 |
| `varcImportedDataCursor` | Self-modified staged-region state used during incremental import. | Editor commands, symbols and tape workflows, line 7539 | `continueSourceImportAfterSubmittedLine`, `invokeGensTokenAliasJ`, `continueGensImportAfterSubmittedLine` | Ch. 30 |
| `varcImportedSourceEnd` | Self-modified staged-region state used during incremental import. | Editor commands, symbols and tape workflows, line 7547 | `loadMatchingCodePayloadToTemporaryMemory` | Ch. 30 |
| `varcImportedSymbolTableBase` | Self-modified staged-region state used during incremental import. | Editor commands, symbols and tape workflows, line 7553 | `loadMatchingCodePayloadToTemporaryMemory` | Ch. 30 |
| `continueSourceImportAfterSubmittedLine` | Resume path, keyboard/progress behavior and live/staged collision check. | Editor commands, symbols and tape workflows, line 7576 | `invokeLoad` | Ch. 30 |
| `invokeGens` / `invokeGensTokenAliasI` / `invokeGensTokenAliasJ` | Shared foreign-source import entry; only GENS is documented as the ordinary user command; adjacent labels are aliases or nested public anchors. | Editor commands, symbols and tape workflows, line 7616 | `commandHandlerTable` | Ch. 31 |
| `continueGensImportAfterSubmittedLine` | Resumes after ordinary parser insertion, supports cancel/progress keys and terminates at U-TOP. | Editor commands, symbols and tape workflows, line 7698 | `invokeGensTokenAliasJ` | Ch. 31 |
| `patchSymbolReferenceResolverBase` | Switches resolver opcode between direct staged table and indirect live table. | Editor commands, symbols and tape workflows, line 7716 | `varcImportedSymbolTableBase` | Ch. 30 |
| `loadMatchingCodePayloadToTemporaryMemory` | Capacity check, `U-TOP-totalLength` placement, native source/table boundary derivation and pre-merge load. | Editor commands, symbols and tape workflows, line 7734 | `prepareTapeSourceImport` | Ch. 30 |
| `setBorderColor` / `configurationPatchTarget11NormalBorderColor` | ULA border output; adjacent labels are aliases or nested public anchors. | Editor commands, symbols and tape workflows, line 7758 | `startMonitor`, `prometheusWarmStartWithCurrentBuffers`; installer/generated metadata | Ch. 8 |

## F.11 Two-pass assembler and expression engine

| Label | Purpose | Physical source region | Principal callers or consumers | Book |
|---|---|---|---|---|
| `processCompilation` | Pass controller, emitters, encoded expressions, tape/cancellation bridges and RUN. | Two-pass assembler and expression engine, line 7794 | `invokeAssembly`, `invokeMonitor`, `invokeRun` | Ch. 2, 19, 25, 28 |
| `varcCompileWholeSource` | Inverted whole-source/block-only mode used by the common scan. | Two-pass assembler and expression engine, line 7824 | `processCompilation` | Ch. 19, 25 |
| `varcAssemblyPassHandlerCall` | Self-modified strategy call changed from first-pass accounting to second-pass emission. | Two-pass assembler and expression engine, line 7832 | `processCompilation`, `varcCompileWholeSource`, `varcAssemblyPassTransitionCounter` | Ch. 5, 19, 25 |
| `varcNextAssemblyRecordPointer` | Successor calculated before handlers reuse registers. | Two-pass assembler and expression engine, line 7834 | `processCompilation`, `varcCompileWholeSource` | Ch. 19, 25 |
| `varcAssemblyPassTransitionCounter` | Compact first-pass, second-pass and completion state. | Two-pass assembler and expression engine, line 7837 | `processCompilation` | Ch. 19, 25 |
| `invokeAssembly` | Command entry, successful completion message and warm editor return. | Two-pass assembler and expression engine, line 7852 | `commandHandlerTable` | Ch. 2, 10, 19 |
| `scanNextDefmCharacter` | Shared pass-one/pass-two string decoder, doubled quotes and apostrophe final-bit convention. | Two-pass assembler and expression engine, line 7937 | `invokeAssembly`, `setOutputPointerFromBC` | Ch. 25, 27 |
| `secondPassEmitSourceRecord` | Shows opcode, immediate and relative-byte generation in source order. | Two-pass assembler and expression engine, line 7969 | `assembleMonitorInputLine`, `varcAssemblyPassTransitionCounter` | Ch. 19, 26, 28 |
| `emitMachineInstructionBytes` | DD/FD/CB/ED prefix order, opcode emission and low-three-bit operand recipe dispatch. | Two-pass assembler and expression engine, line 8006 | `secondPassEmitSourceRecord` | Ch. 26 |
| `validateAndEmitImmediateByte` | Accepts high byte `$00` or `$FF`, then emits the low byte. | Two-pass assembler and expression engine, line 8035 | `invokeAssembly`, `validateAndEmitSignedBC` | Ch. 26, 27 |
| `emitByteAtAssemblyOutput` | Places the exact five-byte result at `$8000` while applying resident/dynamic/U-TOP checks. | Two-pass assembler and expression engine, line 8060 | `emitMachineInstructionBytes`, `emitWordBCAtAssemblyOutput`, `invokeAssembly` | Ch. 26, 28 |
| `varcAssemblyOutputPointer` | Physical RAM write position, independent after PUT. | Two-pass assembler and expression engine, line 8062 | `monRunToTemporaryBreakpoint`, `initializeMonitorLineAssembler`, `processCompilation` | Ch. 5, 19, 25, 27 |
| `varcUTop` | Self-modified operand or instruction carrying persistent runtime state. | Two-pass assembler and expression engine, line 8072 | `invokeUTop`, `continueGensImportAfterSubmittedLine`, `loadMatchingCodePayloadToTemporaryMemory` | Ch. 19–28; App. D–E |
| `varcAddressCounter` | Logical label and `$` address, independent after PUT. | Two-pass assembler and expression engine, line 8080 | `advancePointersForDefsExpressions`, `assembleMonitorInputLine`, `initializeMonitorLineAssembler` | Ch. 5, 19, 25, 27 |
| `emitWordBCAtAssemblyOutput` | Common little-endian word output for instruction operands and DEFW. | Two-pass assembler and expression engine, line 8092 | `scanNextDefmCharacter`, `monRunToTemporaryBreakpoint` | Ch. 26, 27 |
| `validateAndEmitSignedBC` | Adapts evaluated BC displacement into the shared HL validator. | Two-pass assembler and expression engine, line 8140 | fall-through, alias, emitted data or external entry | Ch. 26 |
| `firstPassProcessSourceRecord` | Shows exact label values and size changes for every example record. | Two-pass assembler and expression engine, line 8187 | `assembleMonitorInputLine`, `processCompilation`, `varcAssemblyPassHandlerCall` | Ch. 19, 25, 28 |
| `reportAssemblyErrorAtSourceRecord` | Patched current record returns deep assembly errors to the correct editor line. | Two-pass assembler and expression engine, line 8196 | `editOneMonitorAssemblyLine`, `processCompilation`, `varcAddressCounter` | Ch. 19, 25, 26 |
| `operandClassLengthAdjustments` | Opcode-shaped byte table mapping emission classes to base instruction lengths. | Two-pass assembler and expression engine, line 8228 | `decodeInstructionAtHL`, `reportAssemblyErrorAtSourceRecord` | Ch. 25 |
| `skipEncodedLineLabelIfPresent` | Uniformly rebases `IX+2` onto directive or operand material. | Two-pass assembler and expression engine, line 8233 | `invokeAssembly`, `emitMachineInstructionBytes` | Ch. 25, 27 |
| `varcCurrentLineLabelEntry` | Remembers the label value/name entry that `EQU` overwrites after ordinary definition. | Two-pass assembler and expression engine, line 8246 | `firstPassProcessSourceRecord` | Ch. 25 |
| `setOrgAddressAndOutputPointer` | ORG changes both coordinate systems; PUT changes only physical output. | Two-pass assembler and expression engine, line 8256 | `invokeAssembly` | Ch. 25, 27 |
| `setOutputPointerFromBC` | ORG changes both coordinate systems; PUT changes only physical output. | Two-pass assembler and expression engine, line 8259 | `invokeAssembly` | Ch. 25, 27 |
| `advancePointersForDefsExpressions` | Evaluates one or more reserve counts and advances without writing. | Two-pass assembler and expression engine, line 8291 | `scanNextDefmCharacter` | Ch. 25, 27 |
| `countCommaSeparatedDefinitionItems` | Structural DEFB/DEFW item count without premature expression evaluation. | Two-pass assembler and expression engine, line 8312 | `setOutputPointerFromBC`, `advancePointersForDefsExpressions` | Ch. 25, 27 |
| `evaluateEncodedExpressionAtIX` | Direct evaluation of compressed expression bytes and tagged symbol ordinals during assembler passes. | Two-pass assembler and expression engine, line 8350 | `invokeAssembly`, `scanNextDefmCharacter`, `emitMachineInstructionBytes` | Ch. 22 |
| `readEncodedExpressionOperatorOrEnd` | Distinguishes operators, operand boundaries and `$C0+` source-record terminal markers. | Two-pass assembler and expression engine, line 8387 | fall-through, alias, emitted data or external entry | Ch. 22 |
| `applyExpressionOperatorToHLAndDE` | Shared left-to-right `+ - * / ?` dispatch with 16-bit wraparound. | Two-pass assembler and expression engine, line 8434 | `varcTextAtomUnarySign` | Ch. 22 |
| `divideHLByDE` | Sixteen-step restoring unsigned divide, quotient/remainder contract and documented zero-divisor result. | Two-pass assembler and expression engine, line 8443 | fall-through, alias, emitted data or external entry | Ch. 22 |
| `multiplyHLByDE` | Sixteen-step unsigned shift/add multiplication retaining the low sixteen bits. | Two-pass assembler and expression engine, line 8464 | `varcInstructionControlsDisabled`, `applyExpressionOperatorToHLAndDE` | Ch. 22 |
| `negateDEIfOperatorIsMinus` | Two's-complement unary minus and self-modified sign state. | Two-pass assembler and expression engine, line 8484 | `varcTextAtomUnarySign`, `readEncodedExpressionOperatorOrEnd` | Ch. 22 |
| `readQuotedConstantByte` | Read quoted constant byte. | Two-pass assembler and expression engine, line 8537 | `readEncodedExpressionOperatorOrEnd` | Ch. 19–28; App. D–E |
| `callRomTapeLoadOrVerify` | Shared AF'/carry ROM contract; monitor paths select LOAD. | Two-pass assembler and expression engine, line 8560 | `monLoadBlockFirstLength`, `performTapeLoadOrVerifyOrReportError`, `scanTapeForNextCodeHeader` | Ch. 30, 41 |
| `abortCurrentOperationIfSpacePressed` | temporarily owns the shared error machinery. | Two-pass assembler and expression engine, line 8575 | `printLineBufferToChannel3`, `varcLastSavedAuxiliarySegmentLength`, `varcLastSavedSourceLength` | Ch. 19–28; App. D–E |
| `invokeMonitor` | Optional `A` compilation, editor-screen clear and full/assembler-only monitor destination patch. | Two-pass assembler and expression engine, line 8585 | `commandHandlerTable` | Ch. 33 |
| `assemblerOnlyMonitorFallbackOpcode` | Named final jump patched when the monitor prefix is omitted; relocation mechanics remain Part VII. | Two-pass assembler and expression engine, line 8591 | fall-through, alias, emitted data or external entry | Ch. 33 |
| `assemblerOnlyMonitorFallbackAddress` | Post-stream suffix patch redirects absent MONITOR command to assembler/editor entry. | Two-pass assembler and expression engine, line 8593 | `installerPrepareAssemblerOnlyImage` | Ch. 33, 55 |
| `invokeQuit` | Invoke quit. | Two-pass assembler and expression engine, line 8597 | `commandHandlerTable` | Ch. 19–28; App. D–E |
| `scanTapeForNextCodeHeader` | Repeated 17-byte reads, printable Found-name display and CODE-type filtering. | Two-pass assembler and expression engine, line 8611 | `invokeVerify`, `loadMatchingCodePayloadToTemporaryMemory` | Ch. 30 |
| `acceptLoadedHeaderIfNameMatchesOrWildcard` | Actual wildcard condition is a space in the first retained-name byte, broader than the manual wording. | Two-pass assembler and expression engine, line 8648 | `loadMatchingCodePayloadToTemporaryMemory` | Ch. 30 |
| `compareRequestedNameWithLoadedHeaderExact` | Fixed ten-byte padded filename comparison. | Two-pass assembler and expression engine, line 8658 | `invokeVerify` | Ch. 30 |
| `containsInputBufferCharacterB` | Contains input buffer character b. | Two-pass assembler and expression engine, line 8672 | `invokePrint`, `invokeSave`, `processCompilation` | Ch. 19–28; App. D–E |
| `containsInputBufferCharacterInB` | Contains input buffer character in b. | Two-pass assembler and expression engine, line 8675 | `invokeReplace`, `invokeFind`, `invokeTable` | Ch. 19–28; App. D–E |
| `readInputCharacterSkippingCursorAndAdvance` | SAVE uses the same contract to inspect a delimiter following optional b. | Two-pass assembler and expression engine, line 8683 | `invokeFind`, `invokeSave` | Ch. 19–28; App. D–E |
| `compareWithCharacterInB` | Compare with character in b. | Two-pass assembler and expression engine, line 8686 | `invokeFind`, `invokeTable`, `varcPrintSymbolTable` | Ch. 19–28; App. D–E |
| `invokeToggleNumberBase` | output. The manual binds this immediate action to SYMBOL SHIFT+H. | Two-pass assembler and expression engine, line 8698 | `startMonitor`, `commandHandlerTable` | Ch. 19–28; App. D–E |
| `invokeToggleInsertOverwrite` | Source-record insertion versus replacement. | Two-pass assembler and expression engine, line 8706 | `commandHandlerTable`, `varcLastStatusBarMessage` | Ch. 11 |
| `invertLogicAtHLAndRet` | Invert logic at hland ret. | Two-pass assembler and expression engine, line 8711 | `monToggleInstructionControls`, `invokeToggleNumberBase` | Ch. 19–28; App. D–E |
| `invokeBasic` | Restores ROM interrupt/stack assumptions and returns to BASIC. | Two-pass assembler and expression engine, line 8719 | `commandHandlerTable` | Ch. 8, 9 |
| `copyScreenTextRowAtYToDE` | Fast source-window scrolling while navigation remains record-based. | Two-pass assembler and expression engine, line 8730 | `varcLastStatusBarMessage` | Ch. 8, 9, 15 |
| `writeLineOfCodeAndTestKeyboard` | Edge-line redraw plus direct held-key test during accelerated scrolling. | Two-pass assembler and expression engine, line 8741 | `varcLastStatusBarMessage` | Ch. 8, 9, 15 |
| `moveActiveLineToPreviousSourceRecord` | Boundary-checked structural movement and shared commit path. | Two-pass assembler and expression engine, line 8754 | `varcLastStatusBarMessage` | Ch. 9, 15 |
| `moveActiveLineToNextSourceRecord` | Boundary-checked structural movement and shared commit path. | Two-pass assembler and expression engine, line 8761 | `varcLastStatusBarMessage` | Ch. 9, 15 |
| `copyEightBitmapRows` | Fast source-window scrolling while navigation remains record-based. | Two-pass assembler and expression engine, line 8774 | `appendLineBufferToMonitorListWindow`, `copyScreenTextRowAtYToDE` | Ch. 8, 9, 15 |
| `appendReplacementCharacterOrAbort` | Shared 31-visible-character capacity enforcement. | Two-pass assembler and expression engine, line 8802 | `invokeReplace` | Ch. 17 |
| `clearDisplayToSpaces` | Complete display initialization paths. | Two-pass assembler and expression engine, line 8808 | `invokeMonitor`, `varcRunEntDirectiveBalance` | Ch. 8, 9 |
| `clearDisplay` | Complete display initialization paths. | Two-pass assembler and expression engine, line 8810 | `startMonitor`, `startPrometheus` | Ch. 8, 9 |
| `invokeRun` | Compiles, requires exactly one ENT, clears display and calls generated entry. | Two-pass assembler and expression engine, line 8831 | `commandHandlerTable` | Ch. 9, 19, 27 |
| `varcRunEntDirectiveBalance` | `ENT START` produces a runnable `$8000` call target and exact-one-ENT balance. | Two-pass assembler and expression engine, line 8835 | `invokeAssembly`, `invokeRun` | Ch. 27, 28 |
| `varcRunEntryCallTarget` | `ENT START` produces a runnable `$8000` call target and exact-one-ENT balance. | Two-pass assembler and expression engine, line 8841 | `invokeAssembly` | Ch. 2, 5, 27, 28 |
| `returnFromCompiledProgram` | Return from compiled program. | Two-pass assembler and expression engine, line 8843 | `displaySymbolTableColumn` | Ch. 19–28; App. D–E |

## F.12 Editor loop, parser, source encoding and display

| Label | Purpose | Physical source region | Principal callers or consumers | Book |
|---|---|---|---|---|
| `startPrometheus` | Submission, input editing, source encoding/expansion, navigation, keyboard and display. | Editor loop, parser, source encoding and display, line 8855 | `ENTRY_POINT_WITH_MONITOR`, `startMonitor`, `ENTRY_POINT_WITHOUT_MONITOR` | Ch. 1, 2, 9 |
| `prometheusWarmStart` | Three restart levels and stack reset. | Editor loop, parser, source encoding and display, line 8859 | `startMonitor`, `replaceCommitContinuation`, `continueSourceImportAfterSubmittedLine` | Ch. 9 |
| `configurationPatchTarget12WarmStartAccessLineAttribute` | @config-patch 12. | Editor loop, parser, source encoding and display, line 8862 | installer/generated metadata | Ch. 9–18; App. D–E |
| `prometheusWarmStartWithMessage` | Prometheus warm start with message. | Editor loop, parser, source encoding and display, line 8866 | `invokeAssembly` | Ch. 9–18; App. D–E |
| `prometheusWarmStartWithCurrentBuffers` | Prometheus warm start with current buffers. | Editor loop, parser, source encoding and display, line 8878 | `varcLastStatusBarMessage`, `moveActiveLineToNextSourceRecord`, `abortCommandAndReturnToEditor` | Ch. 9–18; App. D–E |
| `varcLastStatusBarMessage` | Persistent default/status selection. | Editor loop, parser, source encoding and display, line 8890 | `varcImportedSymbolTableBase`, `varcInsertMode`, `expandSourceRecordToHL` | Ch. 9 |
| `submitInputLineOrDispatchCommand` | Junction between temporary input, command dispatch and source parsing. | Editor loop, parser, source encoding and display, line 9030 | `invokeReplace`, `varcImportedSymbolTableBase`, `invokeGensTokenAliasJ` | Ch. 9, 11, 18 |
| `configurationPatchTarget09HiddenEditLineAttribute` | @config-patch 09. | Editor loop, parser, source encoding and display, line 9034 | installer/generated metadata | Ch. 9–18; App. D–E |
| `parseAndInsertSourceLine` | Staged semantic record to committed moving source storage. | Editor loop, parser, source encoding and display, line 9057 | `parseAndInsertDisassemblyLine`, `configurationPatchTarget09HiddenEditLineAttribute` | Ch. 11, 13, 16, 18 |
| `varcInsertMode` | OVERWRITE implemented by inserting the replacement then deleting the old record. | Editor loop, parser, source encoding and display, line 9069 | `invokeReplace`, `invokeToggleInsertOverwrite`, `varcLastStatusBarMessage` | Ch. 11, 16, 18 |
| `restoreInsertModeAndContinue` | Restore insert mode and continue. | Editor loop, parser, source encoding and display, line 9081 | `replaceCommitContinuation` | Ch. 9–18; App. D–E |
| `varcPostCommandContinuationJump` | Normal warm return and temporary multi-stage REPLACE/import continuation. | Editor loop, parser, source encoding and display, line 9087 | `startMonitor`, `monDisassemblyOnPrinter`, `monDisassembleIntoSource` | Ch. 5, 9, 11 and related chapters |
| `updateInputBuffer` / `varcInputBufferPosition` | ENTER, cursor, backspace, CAPS LOCK, tabulation and insertion; adjacent labels are aliases or nested public anchors. | Editor loop, parser, source encoding and display, line 9114 | `monitorInputLoop`, `varcLastStatusBarMessage`; `monitorInputLoop`, `renderInputLineAtBitmapAddress` | Ch. 11 |
| `varcInputColumnAfterCursor` | Physical screen-width guard. | Editor loop, parser, source encoding and display, line 9204 | `renderInputLineAtBitmapAddress` | Ch. 11 |
| `encodeInputLineToSourceRecord` | Complete text-to-temporary-record pipeline. | Editor loop, parser, source encoding and display, line 9293 | `assembleMonitorInputLine`, `parseAndInsertSourceLine` | Ch. 13 |
| `varcSecondOperandClass` | Classified operand shapes packed into the instruction-table search key. | Editor loop, parser, source encoding and display, line 9374 | `encodeInputLineToSourceRecord`, `varcUseIYPrefix` | Ch. 13, 20, 21 |
| `varcFirstOperandClass` | Classified operand shapes packed into the instruction-table search key. | Editor loop, parser, source encoding and display, line 9380 | `encodeInputLineToSourceRecord`, `varcUseIYPrefix` | Ch. 13, 20, 21 |
| `varcMnemonicIndex` | Patched compact mnemonic key used during instruction-form matching. | Editor loop, parser, source encoding and display, line 9389 | `encodeInputLineToSourceRecord` | Ch. 13, 20 |
| `varcUseIYPrefix` | Preserves the user's IY spelling after shared instruction-table lookup. | Editor loop, parser, source encoding and display, line 9432 | `encodeInputLineToSourceRecord`, `normalizeIndexOperandClass` | Ch. 13, 14, 21 |
| `ensureBCBytesFitBelowUTop` | Strict code-end growth check, wraparound detection and U-TOP boundary. | Editor loop, parser, source encoding and display, line 9553 | `loadMatchingCodePayloadToTemporaryMemory`, `varcCodeEndPt`, `insertByteRangeAtHLFromDE` | Ch. 7, 16 |
| `badMnemonicError` | Bad mnemonic error. | Editor loop, parser, source encoding and display, line 9569 | `encodeInputLineToSourceRecord` | Ch. 9–18; App. D–E |
| `badOperandError` | Bad operand error. | Editor loop, parser, source encoding and display, line 9573 | `encodeInputLineToSourceRecord`, `restartRegisterAssignmentInput` | Ch. 9–18; App. D–E |
| `bigNumberError` | Big number error. | Editor loop, parser, source encoding and display, line 9577 | `encodeQuotedOrNumericAtom` | Ch. 9–18; App. D–E |
| `syntaxError` | Syntax error. | Editor loop, parser, source encoding and display, line 9581 | `encodeOperandExpression`, `evaluateExpressionAtHL`, `varcUseIYPrefix` | Ch. 9–18; App. D–E |
| `quotesExpected` | Quotes expected. | Editor loop, parser, source encoding and display, line 9586 | `varcUseIYPrefix` | Ch. 9–18; App. D–E |
| `badStringError` | Bad string error. | Editor loop, parser, source encoding and display, line 9592 | `encodeQuotedOrNumericAtom`, `readNextQuotedLiteralCharacter` | Ch. 9–18; App. D–E |
| `badInstructionError` | Bad instruction error. | Editor loop, parser, source encoding and display, line 9595 | `varcMnemonicIndex`, `initializeRecordHeaderAndOptionalLabel` | Ch. 9–18; App. D–E |
| `signalError` | Signal error. | Editor loop, parser, source encoding and display, line 9597 | `evaluateExpressionAtHL`, `varcEndOfSymbolTable`, `continueSourceImportAfterSubmittedLine` | Ch. 9–18; App. D–E |
| `errorAction` | Error action. | Editor loop, parser, source encoding and display, line 9603 | `startMonitor`, `monitorInputRestart`, `monDisassemblyOnPrinter` | Ch. 9–18; App. D–E |
| `abortCommandAndReturnToEditor` | Steps back from an end-boundary pointer before warm restart. | Editor loop, parser, source encoding and display, line 9612 | `startMonitor`, `checkBlockDestinationAgainstResidentRegion`, `performTapeLoadOrVerifyOrReportError` | Ch. 15 |
| `signalMessage` | Signal message. | Editor loop, parser, source encoding and display, line 9619 | `scanTapeForNextCodeHeader`, `printStatusBar` | Ch. 9–18; App. D–E |
| `displayIndexedMessageAtBitmapRow` | source table is never modified. | Editor loop, parser, source encoding and display, line 9633 | `displayMonitorInputErrorAndDelay` | Ch. 9–18; App. D–E |
| `varcUnknownSymbolNameAddress` | Self-modified operand or instruction carrying persistent runtime state. | Editor loop, parser, source encoding and display, line 9638 | `evaluateEncodedExpressionAtIX` | Ch. 9–18; App. D–E |
| `displayHighBitTerminatedString` | Display high bit terminated string. | Editor loop, parser, source encoding and display, line 9653 | `varcUnknownSymbolNameAddress` | Ch. 9–18; App. D–E |
| `symbolString` | Symbol string. | Editor loop, parser, source encoding and display, line 9661 | `varcUnknownSymbolNameAddress` | Ch. 9–18; App. D–E |
| `getSelectedBlock` / `varcSelectedBlockStart` | Converts inclusive editor block endpoints into a half-open byte interval; adjacent labels are aliases or nested public anchors. | Editor loop, parser, source encoding and display, line 9664 | `invokeDelete`, `invokeSave`, `testSourceRecordOutsideSelectedBlock`; `invokeDelete`, `invokeClear`, `varcLastStatusBarMessage` | Ch. 15, 17, 29 |
| `varcSelectedBlockEnd` | External inclusive record pointers, normalized independently of active-line movement. | Editor loop, parser, source encoding and display, line 9668 | `varcLastStatusBarMessage`, `invokeDelete`, `invokeClear` | Ch. 9, 12, 15 |
| `testSourceRecordOutsideSelectedBlock` | Inclusive selected-block membership used to filter both assembly passes. | Editor loop, parser, source encoding and display, line 9687 | `varcFindRestrictToBlock`, `varcCompileWholeSource`, `renderSourceRecord` | Ch. 15, 17, 19 |
| `advanceIXAndLoadSymbolReference` | Advance ixand load symbol reference. | Editor loop, parser, source encoding and display, line 9706 | `scanNextDefmCharacter` | Ch. 9–18; App. D–E |
| `loadSymbolReferenceAtIXPlus2` | Load symbol reference at ixplus2. | Editor loop, parser, source encoding and display, line 9708 | `resolveRecordLabelAfterHeader` | Ch. 9–18; App. D–E |
| `resolveRecordLabelAfterHeader` | Ordinal-to-vector-to-name resolution, state flags and preceding value word. | Editor loop, parser, source encoding and display, line 9714 | `firstPassProcessSourceRecord`, `expandSourceRecordToHL` | Ch. 14, 22, 23 |
| `resolveSymbolReferenceToName` / `varcSymbolTableBasePointer` | Tagged one-based ordinal to vector flags, physical name and preceding value word; adjacent labels are aliases or nested public anchors. | Editor loop, parser, source encoding and display, line 9737 | `appendRangeEndpointToDisplayLine`, `varcDisassemblyAddressMode`, `evaluateExpressionAtHL`; `patchSymbolReferenceResolverBase` | Ch. 14, 22, 23 |
| `expandSourceRecordToLineBuffer` | Complete comment/structured expansion into the neutral 32-byte line buffer. | Editor loop, parser, source encoding and display, line 9779 | `varcDisassemblyAddressMode`, `invokeReplace`, `varcFindRestrictToBlock` | Ch. 9, 12, 14 |
| `expandSourceRecordToHL` | Expand source record to hl. | Editor loop, parser, source encoding and display, line 9781 | `varcLastStatusBarMessage` | Ch. 9–18; App. D–E |
| `expandOperandByDescriptor` | Fixed operand names and expression-bearing templates. | Editor loop, parser, source encoding and display, line 9871 | `expandSourceRecordToHL` | Ch. 14 |
| `copyResolvedSymbolNameToLine` | Copy resolved symbol name to line. | Editor loop, parser, source encoding and display, line 9878 | `printFromDEtoHLwithDecB` | Ch. 9–18; App. D–E |
| `printFromDEtoHLwithDecB` | Print from deto hlwith dec b. | Editor loop, parser, source encoding and display, line 9880 | `printFromDEtoHLpaddedLeft` | Ch. 9–18; App. D–E |
| `getRecordBeforeActiveLine` | Active-pointer wrappers used by bounded editor navigation and mutation. | Editor loop, parser, source encoding and display, line 9955 | `moveActiveLineToPreviousSourceRecord`, `varcInsertMode` | Ch. 12, 15 |
| `getPreviousSourceRecord` | Constant-time reverse traversal and its role in window derivation. | Editor loop, parser, source encoding and display, line 9967 | `varcLastStatusBarMessage`, `invokeGoToSourceEnd`, `invokeDelete` | Ch. 12, 15 |
| `getRecordAfterActiveLine` | Active-pointer wrappers used by bounded editor navigation and mutation. | Editor loop, parser, source encoding and display, line 9985 | `moveActiveLineToNextSourceRecord`, `parseAndInsertSourceLine` | Ch. 12, 15 |
| `getNextSourceRecord` | Converts inclusive editor block endpoints into a half-open byte interval. | Editor loop, parser, source encoding and display, line 9994 | `varcFindScanPosition`, `invokeDelete`, `invokeSave` | Ch. 12, 15, 29 |
| `continueVariableLengthRecordScan` | Continue variable length record scan. | Editor loop, parser, source encoding and display, line 10017 | fall-through, alias, emitted data or external entry | Ch. 9–18; App. D–E |
| `pollImportKeyboardAndRefreshIfRequested` | No key continues, SPACE aborts, other keys repaint progress. | Editor loop, parser, source encoding and display, line 10029 | `continueSourceImportAfterSubmittedLine`, `continueGensImportAfterSubmittedLine` | Ch. 15, 30 |
| `renderVisibleSourceRecords` / `varcSourceBufferActiveLine` | Derives the twenty-record window by walking thirteen records above the active line; adjacent labels are aliases or nested public anchors. | Editor loop, parser, source encoding and display, line 10044 | `prometheusWarmStartWithCurrentBuffers`; `varcLastStatusBarMessage`, `abortCommandAndReturnToEditor`, `editOneMonitorAssemblyLine` | Ch. 9, 15 |
| `renderSourceRecord` | Neutral expansion, selected-block marker and callback-driven output. | Editor loop, parser, source encoding and display, line 10144 | `writeLineOfCodeAndTestKeyboard`, `varcSourceBufferActiveLine` | Ch. 9, 12, 14 |
| `printExpandedSourceLineWithRoutine` | Skips field markers, tracks quotes, applies case policy and invokes a patched sink. | Editor loop, parser, source encoding and display, line 10158 | `outputLineBufferToChannel3` | Ch. 9, 14 |
| `configurationPatchTarget02SourceCaseTransform` | Configurable case transform suppressed inside quoted text. | Editor loop, parser, source encoding and display, line 10182 | installer/generated metadata | Ch. 14 |
| `varcExpandedSourceCharacterRendererCall` | Patched screen/printer/FIND/REPLACE output callback. | Editor loop, parser, source encoding and display, line 10184 | `printExpandedSourceLineWithRoutine` | Ch. 9, 14 |
| `getStringFromTableDE` | One-byte self-relative string-vector resolution. | Editor loop, parser, source encoding and display, line 10189 | `restartRegisterAssignmentInput`, `resolveAndRenderFrontPanelOperandName`, `expandSourceRecordToHL` | Ch. 14 |
| `printFromDEtoHLpaddedLeft` | Print from deto hlpadded left. | Editor loop, parser, source encoding and display, line 10204 | `expandSourceRecordToHL`, `appendRangeEndpointToDisplayLine`, `varcDisassemblyAddressMode` | Ch. 9–18; App. D–E |
| `fillHLWithBSpaces` | Fill hlwith bspaces. | Editor loop, parser, source encoding and display, line 10208 | `expandSourceRecordToHL` | Ch. 9–18; App. D–E |
| `clearStringBuffers` | Clear string buffers. | Editor loop, parser, source encoding and display, line 10212 | `startMonitor`, `monitorInputRestart`, `parseAndInsertDisassemblyLine` | Ch. 9–18; App. D–E |
| `atHLrepeatBTimesC` | At hlrepeat btimes c. | Editor loop, parser, source encoding and display, line 10217 | `monitorInputBuffersInitialization`, `varcEndOfSymbolTable`, `configurationPatchTarget12WarmStartAccessLineAttribute` | Ch. 9–18; App. D–E |
| `initializeRecordHeaderAndOptionalLabel` | Header creation and optional line-label ordinal. | Editor loop, parser, source encoding and display, line 10238 | `varcUseIYPrefix` | Ch. 13 |
| `decodeInstructionTableRecord` | Reverse lookup of mnemonic and operand descriptors from opcode/prefix metadata. | Editor loop, parser, source encoding and display, line 10284 | `decodeInstructionAtHL`, `expandSourceRecordToHL` | Ch. 14, 20, 26, 39 |
| `varcIndexRegisterVariantOffset` | Restores IX/IY textual distinction after normalized metadata lookup. | Editor loop, parser, source encoding and display, line 10352 | `decodeInstructionTableRecord` | Ch. 14 |
| `validateParsedOperandBuffers` | Rejects oversized or structurally inconsistent normalized operand workspace. | Editor loop, parser, source encoding and display, line 10374 | `encodeInputLineToSourceRecord` | Ch. 21 |
| `encodeOperandExpression` | Outer-operand skipping, unary signs, atom/operator sequencing and tagged ordinal emission. | Editor loop, parser, source encoding and display, line 10405 | `varcUseIYPrefix` | Ch. 13, 21, 22 |
| `encodeQuotedOrNumericAtom` | Decimal, `%` binary, `#` hexadecimal and one/two-byte quoted constants with line-entry validation. | Editor loop, parser, source encoding and display, line 10492 | `evaluateExpressionAtHL`, `encodeOperandExpression` | Ch. 13, 22 |
| `readNextQuotedLiteralCharacter` | Read next quoted literal character. | Editor loop, parser, source encoding and display, line 10557 | `encodeQuotedOrNumericAtom` | Ch. 9–18; App. D–E |
| `storeAndTestNextClosingBracketOrComma` | Shared expression-boundary protocol using carry for comma, closing parenthesis or input end. | Editor loop, parser, source encoding and display, line 10572 | `encodeOperandExpression`, `encodeQuotedOrNumericAtom`, `readNextQuotedLiteralCharacter` | Ch. 22 |
| `testClosingBracketOrComma` | Shared expression-boundary protocol using carry for comma, closing parenthesis or input end. | Editor loop, parser, source encoding and display, line 10574 | `evaluateExpressionAtHL`, `encodeOperandExpression` | Ch. 22 |
| `convertInputCharacterToRadixDigit` | Radix digit conversion, lowercase hexadecimal canonicalization and invalid-digit boundary return. | Editor loop, parser, source encoding and display, line 10588 | `encodeQuotedOrNumericAtom` | Ch. 13, 22 |
| `normalizeIndexOperandClass` | Maps IY class pairs to shared IX metadata while recording FD-prefix choice. | Editor loop, parser, source encoding and display, line 10619 | `varcIndexRegisterVariantOffset`, `varcSecondOperandClass`, `varcFirstOperandClass` | Ch. 13, 14, 21 |
| `classifyOperandText` | Fixed dictionary, direct expression, indirect expression and IX/IY displacement classification. | Editor loop, parser, source encoding and display, line 10647 | `encodeInputLineToSourceRecord` | Ch. 13, 21 |
| `lengthUpToZero` | Supplies exact field length for dictionary bucket selection. | Editor loop, parser, source encoding and display, line 10698 | `encodeInputLineToSourceRecord`, `classifyOperandText` | Ch. 13, 20, 21 |
| `compareWithMnemonics` | Shared high-bit-terminated comparator for mnemonics and fixed operands. | Editor loop, parser, source encoding and display, line 10709 | `encodeInputLineToSourceRecord`, `classifyOperandText` | Ch. 13, 20 |
| `mnemonicLookupByLengthDescriptors` | Four compact `(candidate count, vector offset)` buckets encoded as opcode-shaped data. | Editor loop, parser, source encoding and display, line 10748 | `encodeInputLineToSourceRecord` | Ch. 13, 20 |
| `operandLookupByLengthDescriptors` | Length buckets for fixed register, condition and parenthesized operand spellings. | Editor loop, parser, source encoding and display, line 10756 | `classifyOperandText` | Ch. 13, 20, 21 |
| `prepareLengthBucketLookup` | Resolves bucket count and first packed word through the self-relative reference vector. | Editor loop, parser, source encoding and display, line 10767 | `encodeInputLineToSourceRecord`, `classifyOperandText` | Ch. 13, 20 |
| `readSourceFieldUntilSpace` | Shared delimiter-driven field reader with quote handling and case normalization. | Editor loop, parser, source encoding and display, line 10800 | `encodeInputLineToSourceRecord` | Ch. 13 |
| `readFirstOperandUntilComma` | Quote-aware normalized split into at most two operand workspaces. | Editor loop, parser, source encoding and display, line 10803 | `encodeInputLineToSourceRecord` | Ch. 13, 21 |
| `readSecondOperandToEnd` | Quote-aware normalized split into at most two operand workspaces. | Editor loop, parser, source encoding and display, line 10806 | `evaluateExpressionAtHL`, `encodeInputLineToSourceRecord` | Ch. 13, 21 |
| `advanceInputPointerAndRead` | Advance input pointer and read. | Editor loop, parser, source encoding and display, line 10857 | `renderLineBufferAtMonitorListCursor`, `varcInputColumnAfterCursor`, `readSecondOperandToEnd` | Ch. 9–18; App. D–E |
| `atHLorNextIfOne` | Logical input read that skips the cursor marker. | Editor loop, parser, source encoding and display, line 10859 | `restartRegisterAssignmentInput`, `invokeReplace`, `monitorInputRestart` | Ch. 11 |
| `skipSpaces` | Skip spaces. | Editor loop, parser, source encoding and display, line 10868 | `encodeInputLineToSourceRecord` | Ch. 9–18; App. D–E |
| `repaintEditLine` | Select token table and render bottom row. | Editor loop, parser, source encoding and display, line 10893 | `prometheusWarmStartWithCurrentBuffers` | Ch. 11 |
| `renderInputLineAtBitmapAddress` | Character/token/cursor stream renderer. | Editor loop, parser, source encoding and display, line 10897 | `renderMonitorInputLine` | Ch. 11 |
| `clearLine` | bitmap layout for one character row. Attributes are intentionally untouched. | Editor loop, parser, source encoding and display, line 10929 | `configurationPatchTarget13SymbolTableHighlightAttribute`, `varcSourceBufferActiveLine` | Ch. 9–18; App. D–E |
| `clearLineAtHL` | Spectrum interleaved bitmap row clearing. | Editor loop, parser, source encoding and display, line 10932 | `varcLastStatusBarMessage`, `displayIndexedMessageAtBitmapRow`, `renderInputLineAtBitmapAddress` | Ch. 8 |
| `clearBitmapTextRow` | Spectrum interleaved bitmap row clearing. | Editor loop, parser, source encoding and display, line 10934 | `startMonitor`, `monitorInputLoop` | Ch. 8 |
| `readKeyCode` | Monitor wrapper preserving alternate registers and lowercasing letters. | Editor loop, parser, source encoding and display, line 10956 | `outputMonitorListLineAndPollContinuation`, `startMonitor`, `monReadTapeHeaderOrLeader` | Ch. 10 |
| `varcHeldKeyRepeatScanCounter` | Autorepeat persistence and delay. | Editor loop, parser, source encoding and display, line 10966 | `varcRepeatedKeyCode` | Ch. 10 |
| `varcRepeatedKeyCode` | Autorepeat persistence and delay. | Editor loop, parser, source encoding and display, line 10973 | `varcLastPressedKeyComparisonValue` | Ch. 10 |
| `processKey` | Translation, modifiers, CAPS LOCK, repeat and click. | Editor loop, parser, source encoding and display, line 11008 | `varcCapsLockEnabled`, `monitorInputLoop`, `acknowledgeMonitorOperationError` | Ch. 10 |
| `varcCapsLockEnabled` | Case inversion and cursor-glyph state. | Editor loop, parser, source encoding and display, line 11046 | `varcInputBufferPosition`, `renderInputLineAtBitmapAddress` | Ch. 10, 11 |
| `varcLastPressedKey` | New-versus-held key state. | Editor loop, parser, source encoding and display, line 11062 | `processKey` | Ch. 10 |
| `varcLastPressedKeyComparisonValue` | New-versus-held key state. | Editor loop, parser, source encoding and display, line 11064 | `resetLastPressedKeyComparison` | Ch. 10 |
| `resetLastPressedKeyComparison` | Stable-release reset. | Editor loop, parser, source encoding and display, line 11089 | `varcRepeatedKeyCode` | Ch. 10 |
| `getKeypressCodeOrZero` | Filters no-key and modifier-only states. | Editor loop, parser, source encoding and display, line 11101 | `varcRepeatedKeyCode`, `processKey` | Ch. 10 |
| `symbolCharacters` | Private SYMBOL SHIFT translation table. | Editor loop, parser, source encoding and display, line 11153 | `getKeypressCodeOrZero` | Ch. 10 |
| `keypressBeep` / `configurationPatchTarget03KeypressBeepDuration` | Speaker/border port and accepted-key click; adjacent labels are aliases or nested public anchors. | Editor loop, parser, source encoding and display, line 11161 | `varcLastPressedKeyComparisonValue`; installer/generated metadata | Ch. 8, 10 |
| `beep` | Speaker/border port and accepted-key click. | Editor loop, parser, source encoding and display, line 11168 | `acknowledgeMonitorOperationError`, `signalError` | Ch. 8, 10 |
| `configurationPatchTarget10KeypressBeepBorderColor` | @config-patch 10. | Editor loop, parser, source encoding and display, line 11173 | installer/generated metadata | Ch. 9–18; App. D–E |
| `isNumber` | Translation classifiers. | Editor loop, parser, source encoding and display, line 11186 | `encodeQuotedOrNumericAtom`, `processKey`, `parseSymbolNameAndFindOrdinal` | Ch. 10 |
| `isLetter` | Translation classifiers. | Editor loop, parser, source encoding and display, line 11195 | `renderFrontPanelHighBitTerminatedText`, `evaluateExpressionAtHL`, `printExpandedSourceLineWithRoutine` | Ch. 10 |
| `displaySpaceSafely` | Display space safely. | Editor loop, parser, source encoding and display, line 11210 | `displaySpaceThenCurrentRadixNumber` | Ch. 9–18; App. D–E |
| `displayCharacterAtHL` | Alternate-register protection and packed-character handling. | Editor loop, parser, source encoding and display, line 11213 | `displayCharactersAtHLUntil0Character` | Ch. 8 |
| `displayCharacterSafely` | Alternate-register protection and packed-character handling. | Editor loop, parser, source encoding and display, line 11216 | `scanTapeForNextCodeHeader`, `renderSourceRecord`, `varcExpandedSourceCharacterRendererCall` | Ch. 8 |
| `displayInputTokenOrCharacter` | Character or compact-token expansion. | Editor loop, parser, source encoding and display, line 11230 | `renderInputLineAtBitmapAddress` | Ch. 6, 8, 11 |
| `varcTokenExpansionTableBase` | Redirects the shared token renderer from assembler commands to monitor vocabulary. | Editor loop, parser, source encoding and display, line 11235 | `startMonitor`, `renderMonitorInputLine`, `repaintEditLine` | Ch. 6, 11, 33 |
| `displaySpace` | Display space. | Editor loop, parser, source encoding and display, line 11252 | `frontPanelFlagBitHeadingText`, `dispatchFrontPanelValueRendererWithSeparator` | Ch. 9–18; App. D–E |
| `displayUninvertedCharacter` | Common normal text path. | Editor loop, parser, source encoding and display, line 11254 | `redrawEntireFrontPanel`, `clearOrRenderFrontPanelSpecialArea`, `renderFrontPanelHighBitTerminatedText` | Ch. 8 |
| `displayNormalCharacter` | Glyph plus attribute assignment. | Editor loop, parser, source encoding and display, line 11263 | `renderLineBufferAtMonitorListCursor`, `redrawEntireFrontPanel`, `renderFrontPanelItem` | Ch. 8 |
| `varcTextColor` / `configurationPatchTarget06GenericTextAttribute` | Shared screen cursor and attribute state; adjacent labels are aliases or nested public anchors. | Editor loop, parser, source encoding and display, line 11276 | `configurationPatchTarget14MonitorAccessLineAttribute`, `configurationPatchTarget04MonitorNormalTextAttribute`; installer/generated metadata | Ch. 8 |
| `displayCharacter` | ROM glyph lookup, inverse/bold transform and bitmap write. | Editor loop, parser, source encoding and display, line 11295 | `displayCharacterSafely`, `displayNormalCharacter` | Ch. 8 |
| `varcPrintingPosition` | Shared screen cursor and attribute state. | Editor loop, parser, source encoding and display, line 11303 | `renderFrontPanelItem`, `appendLineBufferToMonitorListWindow`, `setPrintingPositionForItemData` | Ch. 8 |
| `configurationPatchTarget01CharacterBoldTransform` | @config-patch 01. | Editor loop, parser, source encoding and display, line 11312 | installer/generated metadata | Ch. 9–18; App. D–E |

## F.13 Low-level symbols, packed-memory movement and workspaces

| Label | Purpose | Physical source region | Principal callers or consumers | Book |
|---|---|---|---|---|
| `parseSymbolNameAndFindOrdinal` | Eight-character uppercase normalization, high-bit temporary termination and backward ordinal search. | Low-level symbols, packed-memory movement and workspaces, line 11348 | `evaluateExpressionAtHL`, `findOrCreateSymbolOrdinal` | Ch. 22, 24 |
| `varcSymbolTablePt` | Moving table base immediately above packed source and fixed editor padding. | Low-level symbols, packed-memory movement and workspaces, line 11376 | `varcNewSymbolVectorSlot`, `invokeClear`, `invokeSave` | Ch. 3, 7, 12 and related chapters |
| `varcSymbolEntryAreaBase` | Dynamic first-name anchor after count, vector array and first value word. | Low-level symbols, packed-memory movement and workspaces, line 11402 | `varcNewSymbolVectorSlot`, `varcSymbolTablePt` | Ch. 23, 24 |
| `findOrCreateSymbolOrdinal` | Existing-symbol fast path, new vector slot, sorted entry insertion, offset repair and appended ordinal. | Low-level symbols, packed-memory movement and workspaces, line 11446 | `initializeRecordHeaderAndOptionalLabel`, `encodeOperandExpression` | Ch. 22, 24 |
| `varcCodeEndPt` | First unused byte above combined source and table; detailed pass/output uses remain later. | Low-level symbols, packed-memory movement and workspaces, line 11449 | `varcNewSymbolVectorSlot`, `varcSymbolEntryAreaBaseForCleanup`, `deleteSourceLinesAtHL` | Ch. 2, 3, 7 and related chapters |
| `varcNewSymbolVectorSlot` | Two-byte vector-array expansion before the alphabetical entry area. | Low-level symbols, packed-memory movement and workspaces, line 11453 | `varcSymbolTablePt` | Ch. 24 |
| `closeDeletedSymbolDataGap` | In-place value/name or vector gap closure through the overlap-safe movement primitive. | Low-level symbols, packed-memory movement and workspaces, line 11582 | `varcSymbolEntryAreaBaseForCleanup` | Ch. 24 |
| `moveMemoryBlockOverlapSafe` | Direction choice for overlapping blocks. | Low-level symbols, packed-memory movement and workspaces, line 11597 | `varcNewSymbolVectorSlot`, `monMoveBlockFirstLength`, `deleteSourceLinesAtHL` | Ch. 7 |
| `printNumberToStringBuffer` | the ASCII gap after 9. | Low-level symbols, packed-memory movement and workspaces, line 11627 | `renderFrontPanelDecimalWord`, `displaySpaceThenCurrentRadixNumber` | Ch. 7, 16, 23–24; App. C–D |
| `printNumberToIX` / `varcHexMode` | Print number to ix; adjacent labels are aliases or nested public anchors. | Low-level symbols, packed-memory movement and workspaces, line 11630 | `monListMemoryFromTheCurrentAddress`, `printCompactNumberToIX`, `varcEndOfSymbolTable`; `monListMemoryFromTheCurrentAddress`, `invokeToggleNumberBase` | Ch. 7, 16, 23–24; App. C–D |
| `printHexNumberToIX` | Print hex number to ix. | Low-level symbols, packed-memory movement and workspaces, line 11636 | `frontPanelValueRendererCodeBase` | Ch. 7, 16, 23–24; App. C–D |
| `printTwoDigitHexByteToIX` | nibbles. C=0 in memory-list callers prevents leading-zero suppression. | Low-level symbols, packed-memory movement and workspaces, line 11647 | `monListMemoryFromTheCurrentAddress`, `frontPanelValueRendererCodeBase` | Ch. 7, 16, 23–24; App. C–D |
| `printDecNumberToIX` | Print dec number to ix. | Low-level symbols, packed-memory movement and workspaces, line 11651 | `frontPanelValueRendererCodeBase`, `varcHexMode` | Ch. 7, 16, 23–24; App. C–D |
| `printThreeDigitDecimalByteToIX` | fixed-width representation required by the five-byte numeric memory listing. | Low-level symbols, packed-memory movement and workspaces, line 11660 | `monListMemoryFromTheCurrentAddress`, `frontPanelValueRendererCodeBase` | Ch. 7, 16, 23–24; App. C–D |
| `storeNumberOrderToIX` | Store number order to ix. | Low-level symbols, packed-memory movement and workspaces, line 11668 | `printHexNumberToIX`, `printDecNumberToIX`, `printThreeDigitDecimalByteToIX` | Ch. 7, 16, 23–24; App. C–D |
| `storeAtIXMoveToNextAndIncB` | Store at ixmove to next and inc b. | Low-level symbols, packed-memory movement and workspaces, line 11695 | `varcUseIYPrefix`, `varcInputColumnAfterCursor`, `encodeOperandExpression` | Ch. 7, 16, 23–24; App. C–D |
| `storeAtIXAndMoveToNext` | Store at ixand move to next. | Low-level symbols, packed-memory movement and workspaces, line 11697 | `storeNumberOrderToIX` | Ch. 7, 16, 23–24; App. C–D |
| `adjustPointerAtHLIfAtOrAfterInsertion` | Conditional selected-block endpoint movement. | Low-level symbols, packed-memory movement and workspaces, line 11706 | `insertByteRangeAtHLFromDE` | Ch. 7, 16 |
| `varcInsertionPointForPointerAdjustment` | Dynamic boundary used to repair record pointers at or above an insertion. | Low-level symbols, packed-memory movement and workspaces, line 11712 | `parseAndInsertSourceLine`, `invokeCopy` | Ch. 7, 16 |
| `increaseAtHLByTwo` | Shared little-endian pointer growth helpers. | Low-level symbols, packed-memory movement and workspaces, line 11721 | `varcNewSymbolVectorSlot` | Ch. 7, 16 |
| `increaseAtHL` | Shared little-endian pointer growth helpers. | Low-level symbols, packed-memory movement and workspaces, line 11725 | `varcNewSymbolVectorSlot` | Ch. 7, 16 |
| `increaseAtHLbyBC` | Shared little-endian pointer growth helpers. | Low-level symbols, packed-memory movement and workspaces, line 11727 | `advancePointersForDefsExpressions`, `varcNewSymbolVectorSlot`, `insertByteRangeAtHLFromDE` | Ch. 7, 16 |
| `deleteSourceLinesAtHL` | Record-count-to-byte-range conversion, downward compaction and tail clearing. | Low-level symbols, packed-memory movement and workspaces, line 11753 | `deleteSourceLinesAndRestoreTailPadding`, `varcInsertMode` | Ch. 7, 16 |
| `subtractBCFromPointerAtHL` | Packed-region boundary reduction. | Low-level symbols, packed-memory movement and workspaces, line 11801 | `varcSymbolEntryAreaBaseForCleanup`, `varcRemovedSymbolEntryOffset`, `deleteSourceLinesAtHL` | Ch. 7, 16 |
| `adjustPointerAtHLForDeletion` | Mechanical repair for stored source pointers above deletion start. | Low-level symbols, packed-memory movement and workspaces, line 11811 | `deleteSourceLinesAtHL` | Ch. 7, 16 |
| `varcDeletionStartForPointerAdjustment` | Mechanical repair for stored source pointers above deletion start. | Low-level symbols, packed-memory movement and workspaces, line 11816 | `deleteSourceLinesAtHL` | Ch. 7, 16 |
| `prepareTapeSourceImport` | Reuses filename selection, CODE-header scanning, capacity checking and staging while ignoring native source/table metadata. | Low-level symbols, packed-memory movement and workspaces, line 11831 | `invokeLoad`, `invokeGensTokenAliasJ` | Ch. 30, 31 |
| `printStatusBarWithWaitPlease` | Print status bar with wait please. | Low-level symbols, packed-memory movement and workspaces, line 11837 | `findNextOccurrence`, `invokeClear` | Ch. 7, 16, 23–24; App. C–D |
| `printStatusBar` | source/symbol end address and U-TOP in the selected decimal/hexadecimal mode. | Low-level symbols, packed-memory movement and workspaces, line 11845 | `varcLastStatusBarMessage`, `startMonitor`, `varcPrintSymbolTable` | Ch. 9 |
| `displaySpaceThenCurrentRadixNumber` | Display space then current radix number. | Low-level symbols, packed-memory movement and workspaces, line 11862 | `printStatusBar` | Ch. 7, 16, 23–24; App. C–D |
| `displayCharactersAtHLUntil0Character` | Display characters at hluntil0 character. | Low-level symbols, packed-memory movement and workspaces, line 11867 | `varcEndOfSymbolTable` | Ch. 7, 16, 23–24; App. C–D |
| `compareHLWithSourceBufferStart` | Earliest legal active-record boundary, distinct from physical top padding. | Low-level symbols, packed-memory movement and workspaces, line 11878 | `moveActiveLineToPreviousSourceRecord`, `varcLastStatusBarMessage` | Ch. 4, 7, 15 |
| `comparePositionWithCodeEnd` | Upper navigation test preserving six empty tail records before the symbol table. | Low-level symbols, packed-memory movement and workspaces, line 11889 | `deleteSourceLinesAndRestoreTailPadding`, `varcFindScanPosition`, `invokeDelete` | Ch. 7, 15 |
| `invokeCopy` | Inclusive block measurement, insertion-point validation and moving-source correction. | Low-level symbols, packed-memory movement and workspaces, line 11918 | `commandHandlerTable` | Ch. 7, 16, 18 |
| `insertByteRangeAtHLFromDE` | Gap creation, packed-suffix movement, pointer repair and final copy. | Low-level symbols, packed-memory movement and workspaces, line 11963 | `deleteSourceLinesAndRestoreTailPadding`, `parseAndInsertSourceLine` | Ch. 7, 16 |
| `lineBufferReadGuard` | line and its value is irrelevant to those readers. | Low-level symbols, packed-memory movement and workspaces, line 12004 | `renderLineBufferAtMonitorListCursor` | Ch. 7, 16, 23–24; App. C–D |
| `lineBuffer` | Shared by memory views, disassembly, panel, printer, source insertion and header display. | Low-level symbols, packed-memory movement and workspaces, line 12006 | `varcEndOfSymbolTable`, `prometheusWarmStartWithMessage`, `monReadTapeHeaderOrLeader` | Ch. 14, 39, 40 and related chapters |
| `lineBufferMarkerPosition` | Neutral canonical line and view-only selection marker. | Low-level symbols, packed-memory movement and workspaces, line 12008 | `renderSourceRecord` | Ch. 14 |
| `symbolEntryCreationPrefix` | Temporary zero/value/name staging bytes copied directly into a permanent record. | Low-level symbols, packed-memory movement and workspaces, line 12021 | `varcNewSymbolVectorSlot` | Ch. 24 |
| `numberStringBuffer` | Number string buffer. | Low-level symbols, packed-memory movement and workspaces, line 12023 | `parseSymbolNameAndFindOrdinal`, `varcNewSymbolVectorSlot`, `frontPanelValueRendererCodeBase` | Ch. 7, 16, 23–24; App. C–D |
| `commandArgumentBuffer` | Type, ten-byte filename, length, parameter 1 and normally zero parameter 2. | Low-level symbols, packed-memory movement and workspaces, line 12026 | `encodeInputLineToSourceRecord`, `varcUseIYPrefix`, `monSaveBlockFirstLength` | Ch. 41 |
| `monitorTapeHeaderFileName` | zero in the normal :filename path, and standard CODE loading ignores it. | Low-level symbols, packed-memory movement and workspaces, line 12041 | `monSaveBlockFirstLength` | Ch. 7, 16, 23–24; App. C–D |
| `monitorTapeHeaderDataLength` | Monitor tape header data length. | Low-level symbols, packed-memory movement and workspaces, line 12043 | `monSaveBlockFirstLength` | Ch. 7, 16, 23–24; App. C–D |
| `monitorTapeHeaderParameter1` | Monitor tape header parameter1. | Low-level symbols, packed-memory movement and workspaces, line 12045 | `monSaveBlockFirstLength` | Ch. 7, 16, 23–24; App. C–D |
| `firstOperandBufferReadGuard` | allowing the same compact pre-increment idiom used by other text buffers. | Low-level symbols, packed-memory movement and workspaces, line 12051 | `varcUseIYPrefix` | Ch. 7, 16, 23–24; App. C–D |
| `varLowercasedOperands` | Var lowercased operands. | Low-level symbols, packed-memory movement and workspaces, line 12053 | `varcUseIYPrefix`, `encodeInputLineToSourceRecord` | Ch. 7, 16, 23–24; App. C–D |
| `firstOperandDelimiterByte` | Retains the first-operand delimiter needed by definition and expression encoding paths. | Low-level symbols, packed-memory movement and workspaces, line 12062 | `encodeInputLineToSourceRecord` | Ch. 13, 21 |
| `parsedMnemonicBuffer` | Parsed mnemonic buffer. | Low-level symbols, packed-memory movement and workspaces, line 12064 | `encodeInputLineToSourceRecord` | Ch. 7, 16, 23–24; App. C–D |
| `inputBufferGuardByte` | Pre-increment guard and left boundary. | Low-level symbols, packed-memory movement and workspaces, line 12071 | `monitorInputBuffersInitialization`, `renderInputLineAtBitmapAddress` | Ch. 11 |
| `inputBufferStart` | Native and foreign importers both produce ordinary editor input and reuse one semantic entrance. | Low-level symbols, packed-memory movement and workspaces, line 12073 | `monReadTapeHeaderOrLeader`, `startMonitor`, `varcInputBufferPosition` | Ch. 6, 10, 11 and related chapters |
| `loadedTapeHeaderDataLength` | Named views used by the Y display and optional J follow-up. | Low-level symbols, packed-memory movement and workspaces, line 12082 | `monReadTapeHeaderOrLeader` | Ch. 41 |
| `loadedTapeHeaderParameter1` | Named views used by the Y display and optional J follow-up. | Low-level symbols, packed-memory movement and workspaces, line 12084 | `monReadTapeHeaderOrLeader` | Ch. 41 |
| `loadedTapeHeaderParameter2` | Named views used by the Y display and optional J follow-up. | Low-level symbols, packed-memory movement and workspaces, line 12086 | `monReadTapeHeaderOrLeader` | Ch. 41 |
| `interruptStateCaptureScratch` | Temporary LD A,I / LD A,R flag workspace used to reconstruct Boolean interrupt enable. | Low-level symbols, packed-memory movement and workspaces, line 12096 | `varcRestoreMonitorStackAfterExecution` | Ch. 43 |
| `encodedRecordStorageLength` | Temporary source-record workspace becomes executable scratch RAM during stepping/native operations. | Low-level symbols, packed-memory movement and workspaces, line 12108 | `restoreUserStateAndExecuteTrampoline`, `captureUserStateAfterTakenFlow`, `captureUserStateAfterSequentialFlow` | Ch. 11, 13, 45 |
| `encodedRecordHeader` | Opcode/pseudo-opcode and prefix/label/class fields, including construction. | Low-level symbols, packed-memory movement and workspaces, line 12110 | `directCallModeGateOpcode`, `initializeMonitorLineAssembler`, `initializeRecordHeaderAndOptionalLabel` | Ch. 12, 13 |
| `encodedRecordInfoByte` | Opcode/pseudo-opcode and prefix/label/class fields, including construction. | Low-level symbols, packed-memory movement and workspaces, line 12112 | `directCallModeGateOpcode`, `simulateRelativeControlFlow`, `clearPendingDisassemblySeparatorAndReturn` | Ch. 12, 13 |
| `encodedRecordPayload` | Optional line-label ordinal followed by compressed expression or definition material. | Low-level symbols, packed-memory movement and workspaces, line 12114 | `varcInputColumnAfterCursor`, `initializeRecordHeaderAndOptionalLabel` | Ch. 12, 13 |
| `encodedRecordPayloadAfterLabel` | Optional line-label ordinal followed by compressed expression or definition material. | Low-level symbols, packed-memory movement and workspaces, line 12116 | `initializeRecordHeaderAndOptionalLabel` | Ch. 12, 13 |
| `encodedRecordPayloadWorkspace` | Temporary construction capacity. | Low-level symbols, packed-memory movement and workspaces, line 12118 | `directCallModeGateOpcode` | Ch. 12 |
| `l9478` | L9478. | Low-level symbols, packed-memory movement and workspaces, line 12120 | `prometheusWarmStartWithMessage` | Ch. 7, 16, 23–24; App. C–D |

## F.14 Mnemonic, operand and command dictionaries

| Label | Purpose | Physical source region | Principal callers or consumers | Book |
|---|---|---|---|---|
| `internalStackTop` / `errorMessages` | `$0104` is added to final target `$2CDD`, producing logical stack offset `$2DE1`; PUSH BC/RET enters selected layout; adjacent labels are aliases or nested public anchors. | Mnemonic, operand and command dictionaries, line 12129 | `startMonitor`, `prometheusWarmStartWithCurrentBuffers`; `varcUnknownSymbolNameAddress` | Ch. 4, 8, 9 and related chapters |
| `mnemonicsReferences` | Bidirectional compact mnemonic vocabulary used by entry and expansion. | Mnemonic, operand and command dictionaries, line 12156 | `varcInterruptEnableState`, `expandSourceRecordToHL`, `mnemonicLookupByLengthDescriptors` | Ch. 14, 20 |
| `mnemonics00` | Mnemonics00. | Mnemonic, operand and command dictionaries, line 12159 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics01` | Mnemonics01. | Mnemonic, operand and command dictionaries, line 12160 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics02` | Mnemonics02. | Mnemonic, operand and command dictionaries, line 12161 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics03` | Mnemonics03. | Mnemonic, operand and command dictionaries, line 12162 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics04` | Mnemonics04. | Mnemonic, operand and command dictionaries, line 12163 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics05` | Mnemonics05. | Mnemonic, operand and command dictionaries, line 12164 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics06` | Mnemonics06. | Mnemonic, operand and command dictionaries, line 12165 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics07` | Mnemonics07. | Mnemonic, operand and command dictionaries, line 12166 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics08` | Mnemonics08. | Mnemonic, operand and command dictionaries, line 12167 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics09` | Mnemonics09. | Mnemonic, operand and command dictionaries, line 12168 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics10` | Mnemonics10. | Mnemonic, operand and command dictionaries, line 12169 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics11` | Mnemonics11. | Mnemonic, operand and command dictionaries, line 12170 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics12` | Mnemonics12. | Mnemonic, operand and command dictionaries, line 12171 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics13` | Mnemonics13. | Mnemonic, operand and command dictionaries, line 12172 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics14` | Mnemonics14. | Mnemonic, operand and command dictionaries, line 12173 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics15` | Mnemonics15. | Mnemonic, operand and command dictionaries, line 12174 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics16` | Mnemonics16. | Mnemonic, operand and command dictionaries, line 12175 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics17` | Mnemonics17. | Mnemonic, operand and command dictionaries, line 12176 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics18` | Mnemonics18. | Mnemonic, operand and command dictionaries, line 12177 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics19` | Mnemonics19. | Mnemonic, operand and command dictionaries, line 12178 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics20` | Mnemonics20. | Mnemonic, operand and command dictionaries, line 12179 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics21` | Mnemonics21. | Mnemonic, operand and command dictionaries, line 12180 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics22` | Mnemonics22. | Mnemonic, operand and command dictionaries, line 12181 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics23` | Mnemonics23. | Mnemonic, operand and command dictionaries, line 12182 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics24` | Mnemonics24. | Mnemonic, operand and command dictionaries, line 12183 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics25` | Mnemonics25. | Mnemonic, operand and command dictionaries, line 12184 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics26` | Mnemonics26. | Mnemonic, operand and command dictionaries, line 12185 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics27` | Mnemonics27. | Mnemonic, operand and command dictionaries, line 12186 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics28` | Mnemonics28. | Mnemonic, operand and command dictionaries, line 12187 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics29` | Mnemonics29. | Mnemonic, operand and command dictionaries, line 12188 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics30` | Mnemonics30. | Mnemonic, operand and command dictionaries, line 12189 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics31` | Mnemonics31. | Mnemonic, operand and command dictionaries, line 12190 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics32` | Mnemonics32. | Mnemonic, operand and command dictionaries, line 12191 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics33` | Mnemonics33. | Mnemonic, operand and command dictionaries, line 12192 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics34` | Mnemonics34. | Mnemonic, operand and command dictionaries, line 12193 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics35` | Mnemonics35. | Mnemonic, operand and command dictionaries, line 12194 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics36` | Mnemonics36. | Mnemonic, operand and command dictionaries, line 12195 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics37` | Mnemonics37. | Mnemonic, operand and command dictionaries, line 12196 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics38` | Mnemonics38. | Mnemonic, operand and command dictionaries, line 12197 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics39` | Mnemonics39. | Mnemonic, operand and command dictionaries, line 12198 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics40` | Mnemonics40. | Mnemonic, operand and command dictionaries, line 12199 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics41` | Mnemonics41. | Mnemonic, operand and command dictionaries, line 12200 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics42` | Mnemonics42. | Mnemonic, operand and command dictionaries, line 12201 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics43` | Mnemonics43. | Mnemonic, operand and command dictionaries, line 12202 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics44` | Mnemonics44. | Mnemonic, operand and command dictionaries, line 12203 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics45` | Mnemonics45. | Mnemonic, operand and command dictionaries, line 12204 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics46` | Mnemonics46. | Mnemonic, operand and command dictionaries, line 12205 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics47` | Mnemonics47. | Mnemonic, operand and command dictionaries, line 12206 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics48` | Mnemonics48. | Mnemonic, operand and command dictionaries, line 12207 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics49` | Mnemonics49. | Mnemonic, operand and command dictionaries, line 12208 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics50` | Mnemonics50. | Mnemonic, operand and command dictionaries, line 12209 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics51` | Mnemonics51. | Mnemonic, operand and command dictionaries, line 12210 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics52` | Mnemonics52. | Mnemonic, operand and command dictionaries, line 12211 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics53` | Mnemonics53. | Mnemonic, operand and command dictionaries, line 12212 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics54` | Mnemonics54. | Mnemonic, operand and command dictionaries, line 12213 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics55` | Mnemonics55. | Mnemonic, operand and command dictionaries, line 12214 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics56` | Mnemonics56. | Mnemonic, operand and command dictionaries, line 12215 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics57` | Mnemonics57. | Mnemonic, operand and command dictionaries, line 12216 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics58` | Mnemonics58. | Mnemonic, operand and command dictionaries, line 12217 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics59` | Mnemonics59. | Mnemonic, operand and command dictionaries, line 12218 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics60` | Mnemonics60. | Mnemonic, operand and command dictionaries, line 12219 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics61` | Mnemonics61. | Mnemonic, operand and command dictionaries, line 12220 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics62` | Mnemonics62. | Mnemonic, operand and command dictionaries, line 12221 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics63` | Mnemonics63. | Mnemonic, operand and command dictionaries, line 12222 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics64` | Mnemonics64. | Mnemonic, operand and command dictionaries, line 12223 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics65` | Mnemonics65. | Mnemonic, operand and command dictionaries, line 12224 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics66` | Mnemonics66. | Mnemonic, operand and command dictionaries, line 12225 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics67` | Mnemonics67. | Mnemonic, operand and command dictionaries, line 12226 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics68` | Mnemonics68. | Mnemonic, operand and command dictionaries, line 12227 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics69` | Mnemonics69. | Mnemonic, operand and command dictionaries, line 12228 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics70` | Mnemonics70. | Mnemonic, operand and command dictionaries, line 12229 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics71` | Mnemonics71. | Mnemonic, operand and command dictionaries, line 12230 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics72` | Mnemonics72. | Mnemonic, operand and command dictionaries, line 12231 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics73` | Mnemonics73. | Mnemonic, operand and command dictionaries, line 12232 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics74` | Mnemonics74. | Mnemonic, operand and command dictionaries, line 12233 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonics75` | Mnemonics75. | Mnemonic, operand and command dictionaries, line 12234 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable` / `mnemonicsTable00` | Bidirectional compact mnemonic vocabulary used by entry and expansion; adjacent labels are aliases or nested public anchors. | Mnemonic, operand and command dictionaries, line 12237 | fall-through, alias, emitted data or external entry; `mnemonics00` | Ch. 14, 20 |
| `mnemonicsTable01` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12239 | `mnemonics01` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable02` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12240 | `mnemonics02` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable03` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12241 | `mnemonics03` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable04` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12242 | `mnemonics04` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable05` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12243 | `mnemonics05` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable06` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12244 | `mnemonics06` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable07` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12245 | `mnemonics07` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable08` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12246 | `mnemonics08` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable09` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12247 | `mnemonics09` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable10` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12248 | `mnemonics10` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable11` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12249 | `mnemonics11` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable12` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12250 | `mnemonics12` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable13` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12251 | `mnemonics13` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable14` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12252 | `mnemonics14` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable15` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12253 | `mnemonics15` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable16` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12254 | `mnemonics16` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable17` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12255 | `mnemonics17` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable18` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12256 | `mnemonics18` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable19` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12257 | `mnemonics19` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable20` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12258 | `mnemonics20` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable21` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12259 | `mnemonics21` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable22` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12260 | `mnemonics22` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable23` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12261 | `mnemonics23` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable24` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12262 | `mnemonics24` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable25` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12263 | `mnemonics25` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable26` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12264 | `mnemonics26` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable27` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12265 | `mnemonics27` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable28` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12266 | `mnemonics28` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable29` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12267 | `mnemonics29` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable30` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12268 | `mnemonics30` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable31` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12269 | `mnemonics31` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable32` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12270 | `mnemonics32` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable33` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12271 | `mnemonics33` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable34` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12272 | `mnemonics34` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable35` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12273 | `mnemonics35` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable36` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12274 | `mnemonics36` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable37` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12275 | `mnemonics37` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable38` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12276 | `mnemonics38` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable39` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12277 | `mnemonics39` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable40` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12278 | `mnemonics40` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable41` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12279 | `mnemonics41` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable42` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12280 | `mnemonics42` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable43` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12281 | `mnemonics43` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable44` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12282 | `mnemonics44` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable45` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12283 | `mnemonics45` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable46` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12284 | `mnemonics46` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable47` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12285 | `mnemonics47` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable48` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12286 | `mnemonics48` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable49` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12287 | `mnemonics49` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable50` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12288 | `mnemonics50` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable51` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12289 | `mnemonics51` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable52` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12290 | `mnemonics52` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable53` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12291 | `mnemonics53` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable54` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12292 | `mnemonics54` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable55` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12293 | `mnemonics55` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable56` | encode the packed mnemonic DEFB. | Mnemonic, operand and command dictionaries, line 12294 | `mnemonics56` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable57` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12295 | `mnemonics57` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable58` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12296 | `mnemonics58` | Ch. 6, 20–21; App. D–E |
| `l96a4` / `mnemonicsTable59` | L96a4; adjacent labels are aliases or nested public anchors. | Mnemonic, operand and command dictionaries, line 12297 | `startMonitor`, `repaintEditLine`; `mnemonics59` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable60` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12299 | `mnemonics60` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable61` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12300 | `mnemonics61` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable62` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12301 | `mnemonics62` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable63` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12302 | `mnemonics63` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable64` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12303 | `mnemonics64` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable65` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12304 | `mnemonics65` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable66` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12305 | `mnemonics66` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable67` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12306 | `mnemonics67` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable68` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12307 | `mnemonics68` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable69` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12308 | `mnemonics69` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable70` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12309 | `mnemonics70` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable71` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12310 | `mnemonics71` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable72` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12311 | `mnemonics72` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable73` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12312 | `mnemonics73` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable74` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12313 | `mnemonics74` | Ch. 6, 20–21; App. D–E |
| `mnemonicsTable75` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12314 | `mnemonics75` | Ch. 6, 20–21; App. D–E |
| `operandsReferences` | Fixed-operand vocabulary whose indexes double as instruction-form classes. | Mnemonic, operand and command dictionaries, line 12319 | `restartRegisterAssignmentInput`, `renderFrontPanelOperandName`, `expandOperandByDescriptor` | Ch. 14, 20, 21 |
| `operand00` | Operand00. | Mnemonic, operand and command dictionaries, line 12321 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand01` | Operand01. | Mnemonic, operand and command dictionaries, line 12322 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand02` | Operand02. | Mnemonic, operand and command dictionaries, line 12323 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand03` | Operand03. | Mnemonic, operand and command dictionaries, line 12324 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand04` | Operand04. | Mnemonic, operand and command dictionaries, line 12325 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand05` | Operand05. | Mnemonic, operand and command dictionaries, line 12326 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand06` | Operand06. | Mnemonic, operand and command dictionaries, line 12327 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand07` | Operand07. | Mnemonic, operand and command dictionaries, line 12328 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand08` | Operand08. | Mnemonic, operand and command dictionaries, line 12329 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand09` | Operand09. | Mnemonic, operand and command dictionaries, line 12330 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand10` | Operand10. | Mnemonic, operand and command dictionaries, line 12331 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand11` | Operand11. | Mnemonic, operand and command dictionaries, line 12332 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand12` | Operand12. | Mnemonic, operand and command dictionaries, line 12333 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand13` | Operand13. | Mnemonic, operand and command dictionaries, line 12334 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand14` | Operand14. | Mnemonic, operand and command dictionaries, line 12335 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand15` | Operand15. | Mnemonic, operand and command dictionaries, line 12336 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand16` | Operand16. | Mnemonic, operand and command dictionaries, line 12337 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand17` | Operand17. | Mnemonic, operand and command dictionaries, line 12338 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand18` | Operand18. | Mnemonic, operand and command dictionaries, line 12339 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand19` | Operand19. | Mnemonic, operand and command dictionaries, line 12340 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand20` | Operand20. | Mnemonic, operand and command dictionaries, line 12341 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand21` | Operand21. | Mnemonic, operand and command dictionaries, line 12342 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand22` | Operand22. | Mnemonic, operand and command dictionaries, line 12343 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand23` | Operand23. | Mnemonic, operand and command dictionaries, line 12344 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand24` | Operand24. | Mnemonic, operand and command dictionaries, line 12345 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand25` | Operand25. | Mnemonic, operand and command dictionaries, line 12346 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand26` | Operand26. | Mnemonic, operand and command dictionaries, line 12347 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand27` | Operand27. | Mnemonic, operand and command dictionaries, line 12348 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand28` | Operand28. | Mnemonic, operand and command dictionaries, line 12349 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand29` | Operand29. | Mnemonic, operand and command dictionaries, line 12350 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand30` | Operand30. | Mnemonic, operand and command dictionaries, line 12351 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand31` | Operand31. | Mnemonic, operand and command dictionaries, line 12352 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand32` | Operand32. | Mnemonic, operand and command dictionaries, line 12353 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand33` | Operand33. | Mnemonic, operand and command dictionaries, line 12354 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand34` | Operand34. | Mnemonic, operand and command dictionaries, line 12355 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand35` | Operand35. | Mnemonic, operand and command dictionaries, line 12356 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand36` | Operand36. | Mnemonic, operand and command dictionaries, line 12357 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand37` | Operand37. | Mnemonic, operand and command dictionaries, line 12358 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand38` | Operand38. | Mnemonic, operand and command dictionaries, line 12359 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand39` | Operand39. | Mnemonic, operand and command dictionaries, line 12360 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand40` | Operand40. | Mnemonic, operand and command dictionaries, line 12361 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand41` | Operand41. | Mnemonic, operand and command dictionaries, line 12362 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operand42` | Operand42. | Mnemonic, operand and command dictionaries, line 12363 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operandsTable` / `operandsTable00` | Fixed-operand vocabulary whose indexes double as instruction-form classes; adjacent labels are aliases or nested public anchors. | Mnemonic, operand and command dictionaries, line 12367 | fall-through, alias, emitted data or external entry; `operand00` | Ch. 14, 20, 21 |
| `operandsTable01` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12369 | `operand01` | Ch. 6, 20–21; App. D–E |
| `operandsTable02` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12370 | `operand02` | Ch. 6, 20–21; App. D–E |
| `operandsTable03` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12371 | `operand03` | Ch. 6, 20–21; App. D–E |
| `operandsTable04` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12372 | `operand04` | Ch. 6, 20–21; App. D–E |
| `operandsTable05` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12373 | `operand05` | Ch. 6, 20–21; App. D–E |
| `operandsTable06` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12374 | `operand06` | Ch. 6, 20–21; App. D–E |
| `operandsTable07` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12375 | `operand07` | Ch. 6, 20–21; App. D–E |
| `operandsTable08` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12376 | `operand08` | Ch. 6, 20–21; App. D–E |
| `operandsTable09` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12377 | `operand09` | Ch. 6, 20–21; App. D–E |
| `operandsTable10` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12378 | `operand10` | Ch. 6, 20–21; App. D–E |
| `operandsTable11` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12379 | `operand11` | Ch. 6, 20–21; App. D–E |
| `operandsTable12` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12380 | `operand12` | Ch. 6, 20–21; App. D–E |
| `operandsTable13` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12381 | `operand13` | Ch. 6, 20–21; App. D–E |
| `operandsTable14` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12382 | `operand14` | Ch. 6, 20–21; App. D–E |
| `operandsTable15` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12383 | `operand15` | Ch. 6, 20–21; App. D–E |
| `operandsTable16` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12384 | `operand16` | Ch. 6, 20–21; App. D–E |
| `operandsTable17` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12385 | `operand17` | Ch. 6, 20–21; App. D–E |
| `operandsTable18` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12386 | `operand18` | Ch. 6, 20–21; App. D–E |
| `operandsTable19` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12387 | `operand19` | Ch. 6, 20–21; App. D–E |
| `operandsTable20` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12388 | `operand20` | Ch. 6, 20–21; App. D–E |
| `operandsTable21` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12389 | `operand21` | Ch. 6, 20–21; App. D–E |
| `operandsTable22` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12390 | `operand22` | Ch. 6, 20–21; App. D–E |
| `operandsTable23` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12391 | `operand23` | Ch. 6, 20–21; App. D–E |
| `operandsTable24` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12392 | `operand24` | Ch. 6, 20–21; App. D–E |
| `operandsTable25` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12393 | `operand25` | Ch. 6, 20–21; App. D–E |
| `operandsTable26` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12394 | `operand26` | Ch. 6, 20–21; App. D–E |
| `operandsTable27` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12395 | `operand27` | Ch. 6, 20–21; App. D–E |
| `operandsTable28` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12396 | `operand28` | Ch. 6, 20–21; App. D–E |
| `operandsTable29` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12397 | `operand29` | Ch. 6, 20–21; App. D–E |
| `operandsTable30` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12398 | `operand30` | Ch. 6, 20–21; App. D–E |
| `operandsTable31` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12399 | `operand31` | Ch. 6, 20–21; App. D–E |
| `operandsTable32` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12400 | `operand32` | Ch. 6, 20–21; App. D–E |
| `operandsTable33` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12401 | `operand33` | Ch. 6, 20–21; App. D–E |
| `operandsTable34` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12402 | `operand34` | Ch. 6, 20–21; App. D–E |
| `operandsTable35` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12403 | `operand35` | Ch. 6, 20–21; App. D–E |
| `operandsTable36` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12404 | `operand36` | Ch. 6, 20–21; App. D–E |
| `operandsTable37` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12405 | `operand37` | Ch. 6, 20–21; App. D–E |
| `operandsTable38` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12406 | `operand38` | Ch. 6, 20–21; App. D–E |
| `operandsTable39` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12407 | `operand39` | Ch. 6, 20–21; App. D–E |
| `operandsTable40` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12408 | `operand40` | Ch. 6, 20–21; App. D–E |
| `operandsTable41` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12409 | `operand41` | Ch. 6, 20–21; App. D–E |
| `operandsTable42` | Compact resident lookup or descriptor table. | Mnemonic, operand and command dictionaries, line 12410 | `operand42` | Ch. 6, 20–21; App. D–E |
| `operationLabels` / `operationLabels00` | aliases and remain distinct slots even when they resolve to the same spelling. | Mnemonic, operand and command dictionaries, line 12414 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operationLabels01` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12416 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operationLabels02` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12417 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operationLabels03` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12418 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operationLabels05` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12419 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operationLabels06` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12420 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operationLabels07` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12421 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operationLabels08` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12422 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operationLabels09` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12423 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operationLabels10` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12424 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operationLabels11` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12425 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operationLabels12` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12426 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operationLabels13` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12427 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operationLabels14` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12428 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operationLabels15` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12429 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operationLabels16` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12430 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operationLabels17` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12431 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operationLabels18` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12432 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operationLabels19` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12433 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operationLabels20` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12434 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operationLabels21` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12435 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operationLabels22` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12436 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operationLabels23` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12437 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operationLabels24` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12438 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operationLabels25` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12439 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operationLabels26` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12440 | fall-through, alias, emitted data or external entry | Ch. 6, 20–21; App. D–E |
| `operationLabelAssembly` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12442 | `operationLabels00` | Ch. 6, 20–21; App. D–E |
| `operationLabelBasic` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12444 | `operationLabels01` | Ch. 6, 20–21; App. D–E |
| `operationLabelCopy` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12446 | `operationLabels02` | Ch. 6, 20–21; App. D–E |
| `operationLabelDelete` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12448 | `operationLabels03`, `operationLabels05` | Ch. 6, 20–21; App. D–E |
| `operationLabelFind` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12450 | `operationLabels06` | Ch. 6, 20–21; App. D–E |
| `operationLabelGens` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12452 | `operationLabels07`, `operationLabels08`, `operationLabels09` | Ch. 6, 20–21; App. D–E |
| `operationLabelLoad` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12454 | `operationLabels12` | Ch. 6, 20–21; App. D–E |
| `operationLabelMonitor` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12456 | `operationLabels13` | Ch. 6, 20–21; App. D–E |
| `operationLabelNew` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12458 | `operationLabels14`, `operationLabels15` | Ch. 6, 20–21; App. D–E |
| `operationLabelPrint` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12460 | `operationLabels16` | Ch. 6, 20–21; App. D–E |
| `operationLabelQuit` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12462 | `operationLabels17` | Ch. 6, 20–21; App. D–E |
| `operationLabelRun` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12464 | `operationLabels18` | Ch. 6, 20–21; App. D–E |
| `operationLabelSave` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12466 | `operationLabels19` | Ch. 6, 20–21; App. D–E |
| `operationLabelTable` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12468 | `operationLabels20` | Ch. 6, 20–21; App. D–E |
| `operationLabelUTop` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12470 | `operationLabels21` | Ch. 6, 20–21; App. D–E |
| `operationLabelVerify` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12472 | `operationLabels22`, `operationLabels23` | Ch. 6, 20–21; App. D–E |
| `operationLabelClear` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12474 | `operationLabels24`, `operationLabels25` | Ch. 6, 20–21; App. D–E |
| `operationLabelReplace` | High-bit-terminated command name used by the command dictionary. | Mnemonic, operand and command dictionaries, line 12476 | `operationLabels26` | Ch. 6, 20–21; App. D–E |

## F.15 Instruction-table include and initial dynamic tail

| Label | Purpose | Physical source region | Principal callers or consumers | Book |
|---|---|---|---|---|
| `sourceBufferStart` | Twenty empty records, empty symbol table, code-end reserve, sentinel and non-emitting end marker. | Instruction-table include and initial dynamic tail, line 12488 | fall-through, alias, emitted data or external entry | Ch. 2, 3, 12, 15 |
| `sourceBufferPreviousLine` | Initial chain positions and earliest legal active record after thirteen-row top padding. | Instruction-table include and initial dynamic tail, line 12502 | `invokeFind`, `invokePrint` | Ch. 12, 15 |
| `sourceBufferAccessLine` | Initial chain positions and earliest legal active record after thirteen-row top padding. | Instruction-table include and initial dynamic tail, line 12504 | `invokeClear`, `invokeGoToSourceStart`, `getSourceEndPosition` | Ch. 12, 15 |
| `symbolTableDefaultPt` | Full symbol representation belongs to Part III. | Instruction-table include and initial dynamic tail, line 12518 | `getSourceEndPosition`, `varcSymbolTablePt` | Ch. 2, 3 |
| `codeEndDefaultPt` | Combined resident/source/symbol upper boundary. | Instruction-table include and initial dynamic tail, line 12520 | `varcCodeEndPt` | Ch. 2, 3, 7 |
| `defaultPointerAdjustmentSentinel` | no persistent source or symbol-table structure is rooted here. | Instruction-table include and initial dynamic tail, line 12529 | `varcInsertionPointForPointerAdjustment` | Ch. 12, 23, 39, 59, 61; App. C–D |
| `relocatablePayloadEnd` | Twenty empty records, empty symbol table, code-end reserve, sentinel and non-emitting end marker. | Instruction-table include and initial dynamic tail, line 12534 | `varcInstallerSavedStackPointer`, `installerPrepareAssemblerOnlyImage` | Ch. 3, 50 |

## F.16 Completeness notes

This appendix indexes source labels, not every machine-code byte. Complete accounting therefore has several layers:

- dot-prefixed labels are represented through their containing global entry;
- anonymous self-modified operands are described by the nearest `varc...` or configuration-patch anchor;
- the generated relocation and configuration streams are represented by their public boundaries and consumers;
- the 687 fixed instruction descriptors are represented as one compact language in Appendix D and by `instructionTable.asm` at the source boundary;
- dynamic execution-trace comments are evidence of observed origins, not an exhaustive static caller index;
- constants and Spectrum services are also expanded into register-level entries in Appendix B.

With those grouping rules, there is no unexplained global source island left outside the book’s chapter map. A future source release can mechanically compare its global-label set with this appendix to identify new, renamed or removed anchors.

