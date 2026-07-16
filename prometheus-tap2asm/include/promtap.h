#ifndef PROMTAP_H
#define PROMTAP_H

#include <stddef.h>
#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

#define PT_VERSION "1.2.0"
#define PT_LENGTH_AUTO ((size_t)-1)
#define PT_DIRECTIVE_NAME_CAPACITY 32

/* Legacy column layout, legacy compact layout, or fixed separators. */
typedef enum {
    PT_FORMAT_PROMETHEUS = 0,
    PT_FORMAT_COMPACT = 1,
    PT_FORMAT_SEPARATED = 2
} PtFormat;

typedef enum {
    PT_EOL_LF = 0,
    PT_EOL_CRLF = 1
} PtLineEndings;

typedef enum {
    PT_INDENT_SPACE = 0,
    PT_INDENT_TAB = 1
} PtIndentCharacter;

typedef enum {
    PT_HEX_KEEP = 0,
    PT_HEX_HASH = 1,
    PT_HEX_DOLLAR = 2,
    PT_HEX_0X = 3,
    PT_HEX_SUFFIX_H = 4
} PtHexStyle;

typedef enum {
    PT_BINARY_KEEP = 0,
    PT_BINARY_PERCENT = 1,
    PT_BINARY_0B = 2,
    PT_BINARY_SUFFIX_B = 3
} PtBinaryStyle;

typedef enum {
    PT_NUMBER_CASE_PRESERVE = 0,
    PT_NUMBER_CASE_LOWER = 1,
    PT_NUMBER_CASE_UPPER = 2
} PtNumberCase;

enum {
    PT_COMMENT_SOURCE = 1U << 0,
    PT_COMMENT_GENERATED = 1U << 1,
    PT_COMMENT_ALL = PT_COMMENT_SOURCE | PT_COMMENT_GENERATED
};

typedef struct {
    char defb[PT_DIRECTIVE_NAME_CAPACITY];
    char defw[PT_DIRECTIVE_NAME_CAPACITY];
    char defm[PT_DIRECTIVE_NAME_CAPACITY];
    char defs[PT_DIRECTIVE_NAME_CAPACITY];
    char ent[PT_DIRECTIVE_NAME_CAPACITY];
    char equ[PT_DIRECTIVE_NAME_CAPACITY];
    char org[PT_DIRECTIVE_NAME_CAPACITY];
    char put[PT_DIRECTIVE_NAME_CAPACITY];
} PtDirectiveNames;

typedef struct {
    PtFormat format;
    PtLineEndings line_endings;

    /* Used by PT_FORMAT_SEPARATED. Counts are literal characters. */
    PtIndentCharacter indent_character;
    unsigned instruction_indent;
    unsigned label_separator;
    unsigned operand_separator;

    PtHexStyle hex_style;
    PtBinaryStyle binary_style;
    PtNumberCase number_case;
    unsigned comment_flags;
    PtDirectiveNames directives;

    int strict;
    int ignore_case;
    unsigned occurrence;
    unsigned symbol_occurrence;
    size_t source_offset;
    size_t source_length;
    size_t symbols_offset;
} PtConvertOptions;

typedef struct {
    char message[512];
} PtError;

typedef struct {
    unsigned warnings;
    unsigned records;
    unsigned selected_occurrence;
    unsigned selected_symbol_occurrence;
} PtConvertReport;

void pt_default_options(PtConvertOptions *options);
void pt_set_prometheus_directives(PtDirectiveNames *directives);
void pt_set_db_directives(PtDirectiveNames *directives);

/* Generic entry points. Input is selected from the filename suffix: .trd or TAP otherwise. */
int pt_list_file(const char *path, FILE *out, int strict, PtError *error);

int pt_convert_file(const char *path,
                    const char *source_name,
                    const char *symbols_name,
                    const PtConvertOptions *options,
                    unsigned char **output,
                    size_t *output_size,
                    PtConvertReport *report,
                    PtError *error);

int pt_validate_file(const char *path,
                     const char *source_name,
                     const char *symbols_name,
                     const PtConvertOptions *options,
                     PtConvertReport *report,
                     PtError *error);

/* TAP-specific compatibility API retained from version 1.0. */
int pt_list_tap_file(const char *path, FILE *out, int strict, PtError *error);

int pt_convert_tap_file(const char *path,
                        const char *name,
                        const PtConvertOptions *options,
                        unsigned char **output,
                        size_t *output_size,
                        PtConvertReport *report,
                        PtError *error);

int pt_validate_tap_file(const char *path,
                         const char *name,
                         const PtConvertOptions *options,
                         PtConvertReport *report,
                         PtError *error);

/* TR-DOS/BetaDisk .trd image API. symbols_name may be NULL for strict auto-pairing. */
int pt_list_trd_file(const char *path, FILE *out, int strict, PtError *error);

int pt_convert_trd_file(const char *path,
                        const char *source_name,
                        const char *symbols_name,
                        const PtConvertOptions *options,
                        unsigned char **output,
                        size_t *output_size,
                        PtConvertReport *report,
                        PtError *error);

int pt_validate_trd_file(const char *path,
                         const char *source_name,
                         const char *symbols_name,
                         const PtConvertOptions *options,
                         PtConvertReport *report,
                         PtError *error);

void pt_free(void *pointer);

#ifdef __cplusplus
}
#endif

#endif
