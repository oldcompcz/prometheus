#ifndef PROMTAP_INTERNAL_H
#define PROMTAP_INTERNAL_H

#include "promtap.h"
#include <stdint.h>

typedef struct {
    uint8_t opcode;
    uint8_t prefix;
    uint8_t storage_class;
    const char *source_template;
} PtInstruction;

typedef struct {
    char *label;
    char *mnemonic;
    char *operands;
    char *comment;
    int blank;
    size_t bytes_consumed;
} PtDecodedRecord;

const PtInstruction *pt_instruction_table(size_t *count);

int pt_decode_record_for_test(const uint8_t *record,
                              size_t available,
                              const char *const *symbols,
                              size_t symbol_count,
                              int strict,
                              PtDecodedRecord *decoded,
                              PtError *error);

void pt_decoded_record_free(PtDecodedRecord *decoded);

int pt_convert_split_buffers(const uint8_t *source,
                             size_t source_length,
                             const uint8_t *symbols,
                             size_t symbols_length,
                             const PtConvertOptions *options,
                             unsigned char **output,
                             size_t *output_size,
                             PtConvertReport *report,
                             PtError *error);

int pt_validate_split_buffers(const uint8_t *source,
                              size_t source_length,
                              const uint8_t *symbols,
                              size_t symbols_length,
                              const PtConvertOptions *options,
                              PtConvertReport *report,
                              PtError *error);

int pt_probe_symbol_table(const uint8_t *symbols,
                          size_t symbols_length,
                          unsigned *symbol_count);

#endif
