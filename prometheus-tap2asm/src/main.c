#include "promtap.h"

#include <ctype.h>
#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void usage(FILE *out)
{
    fprintf(out,
            "prometheus-tap2asm " PT_VERSION "\n"
            "Convert native PROMETHEUS assembler sources from TAP or BetaDisk/TR-DOS images.\n\n"
            "Usage:\n"
            "  prometheus-tap2asm --list [--salvage] IMAGE.tap|IMAGE.trd\n"
            "  prometheus-tap2asm [options] IMAGE.tap NAME\n"
            "  prometheus-tap2asm [options] IMAGE.trd SOURCE [SYMBOLS]\n\n"
            "TR-DOS selectors use an optional one-character type, for example SOURCE.C.\n"
            "When SYMBOLS is omitted, a unique matching symbol-table file is selected automatically.\n\n"
            "Input and output:\n"
            "  -l, --list                 list TAP blocks or the TR-DOS catalogue\n"
            "  -o, --output FILE          write FILE (default: SOURCE.asm)\n"
            "      --stdout               write assembly text to standard output\n"
            "      --validate-only        validate and decode without writing assembly text\n"
            "      --symbols NAME         select a separate TR-DOS symbol-table file\n"
            "      --line-endings MODE    lf (default) or crlf\n\n"
            "Layout:\n"
            "      --format MODE          prometheus, compact, tabs, or separated\n"
            "                               tabs = 2 TABs before/after labels, 1 before operands\n"
            "      --indent-char CHAR     space or tab; selects separated layout\n"
            "      --instruction-indent N characters before an unlabelled instruction\n"
            "      --label-gap N          characters between label and instruction\n"
            "      --operand-gap N        characters between instruction and operands\n\n"
            "Assembler syntax:\n"
            "      --pseudo-style STYLE   prometheus (default) or db (db/dw/db/ds)\n"
            "      --map-pseudo OLD=NEW   override defb, defw, defm, defs, ent, equ, org, or put\n"
            "      --hex-style STYLE      keep, hash, dollar, 0x, or suffix\n"
            "      --bin-style STYLE      keep, percent, 0b, or suffix\n"
            "      --number-case CASE     preserve, lower, or upper\n"
            "      --comments MODE        all, source, generated, or none\n"
            "      --no-generated-comments preserve source comments but omit diagnostics\n"
            "      --no-comments          omit all comment records and diagnostics\n\n"
            "Selection and recovery:\n"
            "      --ignore-case          compare TAP/TR-DOS names case-insensitively\n"
            "      --index N              source occurrence among duplicate matching names\n"
            "      --symbols-index N      symbol-file occurrence among duplicate names\n"
            "      --source-offset N      skip N bytes at start of a TR-DOS source file\n"
            "      --source-length N      decode exactly N source bytes (default: remainder)\n"
            "      --symbols-offset N     skip N bytes at start of a TR-DOS symbol file\n"
            "      --strict               reject damaged image/source data (default)\n"
            "      --salvage              tolerate checksums/directory damage where possible\n"
            "  -h, --help                 show this help\n"
            "      --version              show version\n");
}

static int parse_unsigned(const char *text, unsigned *value)
{
    char *end;
    unsigned long parsed;
    errno = 0;
    parsed = strtoul(text, &end, 0);
    if (errno != 0 || end == text || *end != '\0' || parsed > 0xffffffffUL) {
        return 0;
    }
    *value = (unsigned)parsed;
    return 1;
}

static int parse_size(const char *text, size_t *value)
{
    char *end;
    unsigned long long parsed;
    errno = 0;
    parsed = strtoull(text, &end, 0);
    if (errno != 0 || end == text || *end != '\0' || parsed > (unsigned long long)SIZE_MAX) {
        return 0;
    }
    *value = (size_t)parsed;
    return 1;
}

static int parse_indent_count(const char *text, unsigned *value)
{
    if (!parse_unsigned(text, value) || *value > 1024U) {
        return 0;
    }
    return 1;
}

static int valid_mnemonic_name(const char *name)
{
    size_t i;
    size_t length = strlen(name);
    if (length == 0 || length >= PT_DIRECTIVE_NAME_CAPACITY) return 0;
    for (i = 0; i < length; ++i) {
        unsigned char c = (unsigned char)name[i];
        if (isspace(c) || c < 0x21U || c == '=') return 0;
    }
    return 1;
}

static int set_directive_mapping(PtDirectiveNames *directives, const char *assignment)
{
    const char *equals = strchr(assignment, '=');
    size_t key_length;
    const char *replacement;
    char *destination = NULL;
    if (equals == NULL || equals == assignment) return 0;
    key_length = (size_t)(equals - assignment);
    replacement = equals + 1;
    if (!valid_mnemonic_name(replacement)) return 0;

#define MATCH_DIRECTIVE(field, text) \
    if (key_length == sizeof(text) - 1 && strncmp(assignment, text, sizeof(text) - 1) == 0) \
        destination = directives->field
    MATCH_DIRECTIVE(defb, "defb");
    else MATCH_DIRECTIVE(defw, "defw");
    else MATCH_DIRECTIVE(defm, "defm");
    else MATCH_DIRECTIVE(defs, "defs");
    else MATCH_DIRECTIVE(ent, "ent");
    else MATCH_DIRECTIVE(equ, "equ");
    else MATCH_DIRECTIVE(org, "org");
    else MATCH_DIRECTIVE(put, "put");
#undef MATCH_DIRECTIVE

    if (destination == NULL) return 0;
    (void)snprintf(destination, PT_DIRECTIVE_NAME_CAPACITY, "%s", replacement);
    return 1;
}

static void select_separated_layout(PtConvertOptions *options)
{
    options->format = PT_FORMAT_SEPARATED;
}

static void select_tab_layout(PtConvertOptions *options)
{
    options->format = PT_FORMAT_SEPARATED;
    options->indent_character = PT_INDENT_TAB;
    options->instruction_indent = 2;
    options->label_separator = 2;
    options->operand_separator = 1;
}

static char *default_output_name(const char *name)
{
    size_t length = strlen(name);
    size_t i;
    char *result = (char *)malloc(length + 5);
    if (result == NULL) {
        return NULL;
    }
    for (i = 0; i < length; ++i) {
        unsigned char c = (unsigned char)name[i];
        if (c == '/' || c == '\\' || c == ':' || c < 0x20) {
            result[i] = '_';
        } else {
            result[i] = (char)c;
        }
    }
    memcpy(result + length, ".asm", 5);
    return result;
}

static int write_file(const char *path, const unsigned char *data, size_t size)
{
    FILE *file = fopen(path, "wb");
    if (file == NULL) {
        fprintf(stderr, "prometheus-tap2asm: cannot open '%s' for writing: %s\n", path, strerror(errno));
        return 0;
    }
    if (size != 0 && fwrite(data, 1, size, file) != size) {
        fprintf(stderr, "prometheus-tap2asm: cannot write '%s' completely\n", path);
        fclose(file);
        return 0;
    }
    if (fclose(file) != 0) {
        fprintf(stderr, "prometheus-tap2asm: cannot close '%s' cleanly\n", path);
        return 0;
    }
    return 1;
}

int main(int argc, char **argv)
{
    PtConvertOptions options;
    PtConvertReport report = {0};
    PtError error = {{0}};
    const char *input = NULL;
    const char *source_name = NULL;
    const char *symbols_name = NULL;
    const char *symbols_option = NULL;
    const char *output_path = NULL;
    int list = 0;
    int stdout_mode = 0;
    int validate_only = 0;
    int i;

    pt_default_options(&options);
    for (i = 1; i < argc; ++i) {
        const char *arg = argv[i];
        if (strcmp(arg, "-h") == 0 || strcmp(arg, "--help") == 0) {
            usage(stdout);
            return 0;
        } else if (strcmp(arg, "--version") == 0) {
            puts("prometheus-tap2asm " PT_VERSION);
            return 0;
        } else if (strcmp(arg, "-l") == 0 || strcmp(arg, "--list") == 0) {
            list = 1;
        } else if (strcmp(arg, "--stdout") == 0) {
            stdout_mode = 1;
        } else if (strcmp(arg, "--validate-only") == 0) {
            validate_only = 1;
        } else if (strcmp(arg, "--ignore-case") == 0) {
            options.ignore_case = 1;
        } else if (strcmp(arg, "--strict") == 0) {
            options.strict = 1;
        } else if (strcmp(arg, "--salvage") == 0) {
            options.strict = 0;
        } else if (strcmp(arg, "-o") == 0 || strcmp(arg, "--output") == 0) {
            if (++i >= argc) {
                fprintf(stderr, "prometheus-tap2asm: %s requires a filename\n", arg);
                return 2;
            }
            output_path = argv[i];
        } else if (strcmp(arg, "--symbols") == 0) {
            if (++i >= argc) {
                fprintf(stderr, "prometheus-tap2asm: --symbols requires a TR-DOS filename\n");
                return 2;
            }
            symbols_option = argv[i];
        } else if (strcmp(arg, "--format") == 0) {
            if (++i >= argc) {
                fprintf(stderr, "prometheus-tap2asm: --format requires prometheus, compact, tabs, or separated\n");
                return 2;
            }
            if (strcmp(argv[i], "prometheus") == 0) {
                options.format = PT_FORMAT_PROMETHEUS;
            } else if (strcmp(argv[i], "compact") == 0) {
                options.format = PT_FORMAT_COMPACT;
            } else if (strcmp(argv[i], "tabs") == 0) {
                select_tab_layout(&options);
            } else if (strcmp(argv[i], "separated") == 0 || strcmp(argv[i], "custom") == 0) {
                select_separated_layout(&options);
            } else {
                fprintf(stderr, "prometheus-tap2asm: unknown format '%s'\n", argv[i]);
                return 2;
            }
        } else if (strcmp(arg, "--indent-char") == 0) {
            if (++i >= argc) {
                fprintf(stderr, "prometheus-tap2asm: --indent-char requires space or tab\n");
                return 2;
            }
            select_separated_layout(&options);
            if (strcmp(argv[i], "space") == 0 || strcmp(argv[i], "spaces") == 0) {
                options.indent_character = PT_INDENT_SPACE;
            } else if (strcmp(argv[i], "tab") == 0 || strcmp(argv[i], "tabs") == 0) {
                options.indent_character = PT_INDENT_TAB;
            } else {
                fprintf(stderr, "prometheus-tap2asm: unknown indentation character '%s'\n", argv[i]);
                return 2;
            }
        } else if (strcmp(arg, "--instruction-indent") == 0) {
            if (++i >= argc || !parse_indent_count(argv[i], &options.instruction_indent)) {
                fprintf(stderr, "prometheus-tap2asm: --instruction-indent requires an integer from 0 to 1024\n");
                return 2;
            }
            select_separated_layout(&options);
        } else if (strcmp(arg, "--label-gap") == 0) {
            if (++i >= argc || !parse_indent_count(argv[i], &options.label_separator)) {
                fprintf(stderr, "prometheus-tap2asm: --label-gap requires an integer from 0 to 1024\n");
                return 2;
            }
            select_separated_layout(&options);
        } else if (strcmp(arg, "--operand-gap") == 0) {
            if (++i >= argc || !parse_indent_count(argv[i], &options.operand_separator)) {
                fprintf(stderr, "prometheus-tap2asm: --operand-gap requires an integer from 0 to 1024\n");
                return 2;
            }
            select_separated_layout(&options);
        } else if (strcmp(arg, "--pseudo-style") == 0) {
            if (++i >= argc) {
                fprintf(stderr, "prometheus-tap2asm: --pseudo-style requires prometheus or db\n");
                return 2;
            }
            if (strcmp(argv[i], "prometheus") == 0) {
                pt_set_prometheus_directives(&options.directives);
            } else if (strcmp(argv[i], "db") == 0 || strcmp(argv[i], "db-dw") == 0) {
                pt_set_db_directives(&options.directives);
            } else {
                fprintf(stderr, "prometheus-tap2asm: unknown pseudo-op style '%s'\n", argv[i]);
                return 2;
            }
        } else if (strcmp(arg, "--map-pseudo") == 0) {
            if (++i >= argc || !set_directive_mapping(&options.directives, argv[i])) {
                fprintf(stderr, "prometheus-tap2asm: --map-pseudo requires OLD=NEW for a supported directive\n");
                return 2;
            }
        } else if (strcmp(arg, "--hex-style") == 0) {
            if (++i >= argc) {
                fprintf(stderr, "prometheus-tap2asm: --hex-style requires keep, hash, dollar, 0x, or suffix\n");
                return 2;
            }
            if (strcmp(argv[i], "keep") == 0 || strcmp(argv[i], "hash") == 0) options.hex_style = strcmp(argv[i], "keep") == 0 ? PT_HEX_KEEP : PT_HEX_HASH;
            else if (strcmp(argv[i], "dollar") == 0) options.hex_style = PT_HEX_DOLLAR;
            else if (strcmp(argv[i], "0x") == 0) options.hex_style = PT_HEX_0X;
            else if (strcmp(argv[i], "suffix") == 0 || strcmp(argv[i], "h") == 0) options.hex_style = PT_HEX_SUFFIX_H;
            else {
                fprintf(stderr, "prometheus-tap2asm: unknown hexadecimal style '%s'\n", argv[i]);
                return 2;
            }
        } else if (strcmp(arg, "--bin-style") == 0) {
            if (++i >= argc) {
                fprintf(stderr, "prometheus-tap2asm: --bin-style requires keep, percent, 0b, or suffix\n");
                return 2;
            }
            if (strcmp(argv[i], "keep") == 0 || strcmp(argv[i], "percent") == 0) options.binary_style = strcmp(argv[i], "keep") == 0 ? PT_BINARY_KEEP : PT_BINARY_PERCENT;
            else if (strcmp(argv[i], "0b") == 0) options.binary_style = PT_BINARY_0B;
            else if (strcmp(argv[i], "suffix") == 0 || strcmp(argv[i], "b") == 0) options.binary_style = PT_BINARY_SUFFIX_B;
            else {
                fprintf(stderr, "prometheus-tap2asm: unknown binary style '%s'\n", argv[i]);
                return 2;
            }
        } else if (strcmp(arg, "--number-case") == 0) {
            if (++i >= argc) {
                fprintf(stderr, "prometheus-tap2asm: --number-case requires preserve, lower, or upper\n");
                return 2;
            }
            if (strcmp(argv[i], "preserve") == 0) options.number_case = PT_NUMBER_CASE_PRESERVE;
            else if (strcmp(argv[i], "lower") == 0) options.number_case = PT_NUMBER_CASE_LOWER;
            else if (strcmp(argv[i], "upper") == 0) options.number_case = PT_NUMBER_CASE_UPPER;
            else {
                fprintf(stderr, "prometheus-tap2asm: unknown number case '%s'\n", argv[i]);
                return 2;
            }
        } else if (strcmp(arg, "--comments") == 0) {
            if (++i >= argc) {
                fprintf(stderr, "prometheus-tap2asm: --comments requires all, source, generated, or none\n");
                return 2;
            }
            if (strcmp(argv[i], "all") == 0) options.comment_flags = PT_COMMENT_ALL;
            else if (strcmp(argv[i], "source") == 0) options.comment_flags = PT_COMMENT_SOURCE;
            else if (strcmp(argv[i], "generated") == 0) options.comment_flags = PT_COMMENT_GENERATED;
            else if (strcmp(argv[i], "none") == 0) options.comment_flags = 0;
            else {
                fprintf(stderr, "prometheus-tap2asm: unknown comment mode '%s'\n", argv[i]);
                return 2;
            }
        } else if (strcmp(arg, "--no-generated-comments") == 0) {
            options.comment_flags &= ~PT_COMMENT_GENERATED;
        } else if (strcmp(arg, "--no-comments") == 0) {
            options.comment_flags = 0;
        } else if (strcmp(arg, "--line-endings") == 0) {
            if (++i >= argc) {
                fprintf(stderr, "prometheus-tap2asm: --line-endings requires lf or crlf\n");
                return 2;
            }
            if (strcmp(argv[i], "lf") == 0) {
                options.line_endings = PT_EOL_LF;
            } else if (strcmp(argv[i], "crlf") == 0) {
                options.line_endings = PT_EOL_CRLF;
            } else {
                fprintf(stderr, "prometheus-tap2asm: unknown line-ending mode '%s'\n", argv[i]);
                return 2;
            }
        } else if (strcmp(arg, "--index") == 0) {
            if (++i >= argc || !parse_unsigned(argv[i], &options.occurrence)) {
                fprintf(stderr, "prometheus-tap2asm: --index requires a non-negative integer\n");
                return 2;
            }
        } else if (strcmp(arg, "--symbols-index") == 0) {
            if (++i >= argc || !parse_unsigned(argv[i], &options.symbol_occurrence)) {
                fprintf(stderr, "prometheus-tap2asm: --symbols-index requires a non-negative integer\n");
                return 2;
            }
        } else if (strcmp(arg, "--source-offset") == 0) {
            if (++i >= argc || !parse_size(argv[i], &options.source_offset)) {
                fprintf(stderr, "prometheus-tap2asm: --source-offset requires a non-negative integer\n");
                return 2;
            }
        } else if (strcmp(arg, "--source-length") == 0) {
            if (++i >= argc || !parse_size(argv[i], &options.source_length)) {
                fprintf(stderr, "prometheus-tap2asm: --source-length requires a non-negative integer\n");
                return 2;
            }
        } else if (strcmp(arg, "--symbols-offset") == 0) {
            if (++i >= argc || !parse_size(argv[i], &options.symbols_offset)) {
                fprintf(stderr, "prometheus-tap2asm: --symbols-offset requires a non-negative integer\n");
                return 2;
            }
        } else if (arg[0] == '-') {
            fprintf(stderr, "prometheus-tap2asm: unknown option '%s'\n", arg);
            return 2;
        } else if (input == NULL) {
            input = arg;
        } else if (source_name == NULL) {
            source_name = arg;
        } else if (symbols_name == NULL) {
            symbols_name = arg;
        } else {
            fprintf(stderr, "prometheus-tap2asm: unexpected extra argument '%s'\n", arg);
            return 2;
        }
    }

    if (input == NULL) {
        usage(stderr);
        return 2;
    }
    if (symbols_option != NULL) {
        if (symbols_name != NULL) {
            fprintf(stderr, "prometheus-tap2asm: specify SYMBOLS either positionally or with --symbols, not both\n");
            return 2;
        }
        symbols_name = symbols_option;
    }
    if (options.symbol_occurrence != 0 && symbols_name == NULL) {
        fprintf(stderr, "prometheus-tap2asm: --symbols-index requires an explicit SYMBOLS selector\n");
        return 2;
    }
    if (list) {
        if (source_name != NULL || symbols_name != NULL || output_path != NULL || stdout_mode || validate_only) {
            fprintf(stderr, "prometheus-tap2asm: --list cannot be combined with conversion names or output options\n");
            return 2;
        }
        if (!pt_list_file(input, stdout, options.strict, &error)) {
            fprintf(stderr, "prometheus-tap2asm: %s\n", error.message);
            return 1;
        }
        return 0;
    }
    if (source_name == NULL) {
        fprintf(stderr, "prometheus-tap2asm: a TAP filename or TR-DOS source filename is required\n");
        return 2;
    }
    if (stdout_mode && output_path != NULL) {
        fprintf(stderr, "prometheus-tap2asm: --stdout and --output are mutually exclusive\n");
        return 2;
    }
    if (validate_only && (stdout_mode || output_path != NULL)) {
        fprintf(stderr, "prometheus-tap2asm: --validate-only cannot be combined with output selection\n");
        return 2;
    }

    if (validate_only) {
        if (!pt_validate_file(input, source_name, symbols_name, &options, &report, &error)) {
            fprintf(stderr, "prometheus-tap2asm: %s\n", error.message);
            return 1;
        }
        fprintf(stderr,
                "validated %u source records%s\n",
                report.records,
                report.warnings == 0 ? "" : " with warnings");
        return 0;
    } else {
        unsigned char *text = NULL;
        size_t text_size = 0;
        char *default_path = NULL;
        int ok;
        if (!pt_convert_file(input,
                             source_name,
                             symbols_name,
                             &options,
                             &text,
                             &text_size,
                             &report,
                             &error)) {
            fprintf(stderr, "prometheus-tap2asm: %s\n", error.message);
            return 1;
        }
        if (stdout_mode) {
            ok = text_size == 0 || fwrite(text, 1, text_size, stdout) == text_size;
            if (!ok) {
                fprintf(stderr, "prometheus-tap2asm: failed to write standard output\n");
            }
        } else {
            if (output_path == NULL) {
                default_path = default_output_name(source_name);
                if (default_path == NULL) {
                    fprintf(stderr, "prometheus-tap2asm: out of memory while constructing output filename\n");
                    pt_free(text);
                    return 1;
                }
                output_path = default_path;
            }
            ok = write_file(output_path, text, text_size);
            if (ok) {
                fprintf(stderr,
                        "wrote %u source records to %s%s\n",
                        report.records,
                        output_path,
                        report.warnings == 0 ? "" : " (salvaged with warnings)");
            }
        }
        free(default_path);
        pt_free(text);
        return ok ? 0 : 1;
    }
}
