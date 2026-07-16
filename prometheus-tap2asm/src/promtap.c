#include "promtap_internal.h"

#include <ctype.h>
#include <errno.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define PT_ARRAY_COUNT(a) (sizeof(a) / sizeof((a)[0]))

typedef struct {
    uint8_t *bytes;
    size_t length;
    size_t file_offset;
    uint8_t flag;
    const uint8_t *payload;
    size_t payload_length;
    int checksum_ok;
} TapBlock;

typedef struct {
    TapBlock *blocks;
    size_t count;
} TapImage;

typedef struct {
    char **names;
    size_t count;
} SymbolTable;

typedef struct {
    unsigned char *data;
    size_t length;
    size_t capacity;
} ByteBuffer;

typedef struct {
    char *data;
    size_t length;
    size_t capacity;
} StringBuffer;

static const PtInstruction g_instructions[] = {
#include "instructions.inc"
};

static void set_error(PtError *error, const char *format, ...)
{
    va_list args;
    if (error == NULL) {
        return;
    }
    va_start(args, format);
    (void)vsnprintf(error->message, sizeof(error->message), format, args);
    va_end(args);
}

static uint16_t read_le16(const uint8_t *p)
{
    return (uint16_t)(p[0] | ((uint16_t)p[1] << 8));
}

static int bb_reserve(ByteBuffer *buffer, size_t extra, PtError *error)
{
    size_t required;
    size_t capacity;
    unsigned char *replacement;

    if (extra > SIZE_MAX - buffer->length) {
        set_error(error, "output size overflow");
        return 0;
    }
    required = buffer->length + extra;
    if (required <= buffer->capacity) {
        return 1;
    }
    capacity = buffer->capacity == 0 ? 1024 : buffer->capacity;
    while (capacity < required) {
        if (capacity > SIZE_MAX / 2) {
            capacity = required;
            break;
        }
        capacity *= 2;
    }
    replacement = (unsigned char *)realloc(buffer->data, capacity);
    if (replacement == NULL) {
        set_error(error, "out of memory while growing output buffer");
        return 0;
    }
    buffer->data = replacement;
    buffer->capacity = capacity;
    return 1;
}

static int bb_append(ByteBuffer *buffer, const void *data, size_t size, PtError *error)
{
    if (!bb_reserve(buffer, size, error)) {
        return 0;
    }
    if (size != 0) {
        memcpy(buffer->data + buffer->length, data, size);
    }
    buffer->length += size;
    return 1;
}

static int sb_reserve(StringBuffer *buffer, size_t extra, PtError *error)
{
    size_t required;
    size_t capacity;
    char *replacement;

    if (extra > SIZE_MAX - buffer->length - 1) {
        set_error(error, "string size overflow");
        return 0;
    }
    required = buffer->length + extra + 1;
    if (required <= buffer->capacity) {
        return 1;
    }
    capacity = buffer->capacity == 0 ? 64 : buffer->capacity;
    while (capacity < required) {
        if (capacity > SIZE_MAX / 2) {
            capacity = required;
            break;
        }
        capacity *= 2;
    }
    replacement = (char *)realloc(buffer->data, capacity);
    if (replacement == NULL) {
        set_error(error, "out of memory while growing string");
        return 0;
    }
    buffer->data = replacement;
    buffer->capacity = capacity;
    if (buffer->length == 0) {
        buffer->data[0] = '\0';
    }
    return 1;
}

static int sb_append_n(StringBuffer *buffer, const char *text, size_t size, PtError *error)
{
    if (!sb_reserve(buffer, size, error)) {
        return 0;
    }
    if (size != 0) {
        memcpy(buffer->data + buffer->length, text, size);
    }
    buffer->length += size;
    buffer->data[buffer->length] = '\0';
    return 1;
}

static int sb_append(StringBuffer *buffer, const char *text, PtError *error)
{
    return sb_append_n(buffer, text, strlen(text), error);
}

static int sb_append_char(StringBuffer *buffer, char value, PtError *error)
{
    return sb_append_n(buffer, &value, 1, error);
}

static char *duplicate_n(const char *text, size_t size)
{
    char *copy = (char *)malloc(size + 1);
    if (copy == NULL) {
        return NULL;
    }
    if (size != 0) {
        memcpy(copy, text, size);
    }
    copy[size] = '\0';
    return copy;
}

static char *duplicate_string(const char *text)
{
    return duplicate_n(text, strlen(text));
}

static int read_file(const char *path, uint8_t **bytes, size_t *length, PtError *error)
{
    FILE *file;
    long end;
    uint8_t *data;
    size_t got;

    *bytes = NULL;
    *length = 0;
    file = fopen(path, "rb");
    if (file == NULL) {
        set_error(error, "cannot open '%s': %s", path, strerror(errno));
        return 0;
    }
    if (fseek(file, 0, SEEK_END) != 0 || (end = ftell(file)) < 0 || fseek(file, 0, SEEK_SET) != 0) {
        set_error(error, "cannot determine size of '%s'", path);
        fclose(file);
        return 0;
    }
    if ((unsigned long)end > SIZE_MAX) {
        set_error(error, "file '%s' is too large", path);
        fclose(file);
        return 0;
    }
    data = (uint8_t *)malloc((size_t)end == 0 ? 1 : (size_t)end);
    if (data == NULL) {
        set_error(error, "out of memory while reading '%s'", path);
        fclose(file);
        return 0;
    }
    got = fread(data, 1, (size_t)end, file);
    if (got != (size_t)end || ferror(file)) {
        set_error(error, "cannot read '%s' completely", path);
        free(data);
        fclose(file);
        return 0;
    }
    fclose(file);
    *bytes = data;
    *length = got;
    return 1;
}

static void tap_free(TapImage *tap)
{
    size_t i;
    if (tap == NULL) {
        return;
    }
    for (i = 0; i < tap->count; ++i) {
        free(tap->blocks[i].bytes);
    }
    free(tap->blocks);
    tap->blocks = NULL;
    tap->count = 0;
}

static int tap_parse(const uint8_t *bytes, size_t length, TapImage *tap, int strict, PtError *error)
{
    size_t offset = 0;
    TapBlock *blocks = NULL;
    size_t count = 0;
    size_t capacity = 0;

    memset(tap, 0, sizeof(*tap));
    while (offset < length) {
        uint16_t block_length;
        TapBlock block;
        uint8_t checksum = 0;
        size_t i;

        if (length - offset < 2) {
            set_error(error, "truncated TAP length word at file offset 0x%zx", offset);
            goto fail;
        }
        block_length = read_le16(bytes + offset);
        if (block_length < 2) {
            set_error(error, "invalid TAP block length %u at file offset 0x%zx", (unsigned)block_length, offset);
            goto fail;
        }
        if ((size_t)block_length > length - offset - 2) {
            set_error(error, "truncated TAP block at file offset 0x%zx (declared %u bytes)", offset, (unsigned)block_length);
            goto fail;
        }
        memset(&block, 0, sizeof(block));
        block.length = block_length;
        block.file_offset = offset;
        block.bytes = (uint8_t *)malloc(block_length);
        if (block.bytes == NULL) {
            set_error(error, "out of memory while parsing TAP block");
            goto fail;
        }
        memcpy(block.bytes, bytes + offset + 2, block_length);
        block.flag = block.bytes[0];
        block.payload = block.bytes + 1;
        block.payload_length = block_length - 2;
        for (i = 0; i < block_length; ++i) {
            checksum ^= block.bytes[i];
        }
        block.checksum_ok = checksum == 0;
        if (strict && !block.checksum_ok) {
            set_error(error, "checksum failure in TAP block at file offset 0x%zx", offset);
            free(block.bytes);
            goto fail;
        }
        if (count == capacity) {
            size_t new_capacity = capacity == 0 ? 16 : capacity * 2;
            TapBlock *replacement = (TapBlock *)realloc(blocks, new_capacity * sizeof(*blocks));
            if (replacement == NULL) {
                set_error(error, "out of memory while indexing TAP blocks");
                free(block.bytes);
                goto fail;
            }
            blocks = replacement;
            capacity = new_capacity;
        }
        blocks[count++] = block;
        offset += 2 + block_length;
    }
    tap->blocks = blocks;
    tap->count = count;
    return 1;

fail:
    if (blocks != NULL) {
        size_t i;
        for (i = 0; i < count; ++i) {
            free(blocks[i].bytes);
        }
    }
    free(blocks);
    return 0;
}

static int tap_load(const char *path, TapImage *tap, int strict, PtError *error)
{
    uint8_t *bytes;
    size_t length;
    int ok;
    if (!read_file(path, &bytes, &length, error)) {
        return 0;
    }
    ok = tap_parse(bytes, length, tap, strict, error);
    free(bytes);
    return ok;
}

static int ascii_equal_char(unsigned char a, unsigned char b, int ignore_case)
{
    if (!ignore_case) {
        return a == b;
    }
    return tolower(a) == tolower(b);
}

static int header_name_matches(const uint8_t header_name[10], const char *requested, int ignore_case)
{
    uint8_t padded[10];
    size_t length = strlen(requested);
    size_t i;
    if (length > 10) {
        return 0;
    }
    memset(padded, ' ', sizeof(padded));
    memcpy(padded, requested, length);
    for (i = 0; i < 10; ++i) {
        if (!ascii_equal_char(header_name[i], padded[i], ignore_case)) {
            return 0;
        }
    }
    return 1;
}

static void header_name_text(const uint8_t header_name[10], char output[11])
{
    size_t i;
    memcpy(output, header_name, 10);
    output[10] = '\0';
    for (i = 10; i > 0 && output[i - 1] == ' '; --i) {
        output[i - 1] = '\0';
    }
}

static const char *header_type_name(uint8_t type)
{
    switch (type) {
        case 0: return "PROGRAM";
        case 1: return "NUMBER_ARRAY";
        case 2: return "CHAR_ARRAY";
        case 3: return "CODE";
        default: return "UNKNOWN";
    }
}

static void symbol_table_free(SymbolTable *table)
{
    size_t i;
    if (table == NULL) {
        return;
    }
    for (i = 0; i < table->count; ++i) {
        free(table->names[i]);
    }
    free(table->names);
    table->names = NULL;
    table->count = 0;
}

static int symbol_table_parse(const uint8_t *bytes,
                              size_t length,
                              int strict,
                              SymbolTable *table,
                              unsigned *warnings,
                              PtError *error)
{
    uint16_t count;
    size_t vectors_end;
    size_t name_anchor;
    size_t i;
    uint8_t *name_starts = NULL;

    memset(table, 0, sizeof(*table));
    if (length < 2) {
        set_error(error, "symbol table is shorter than its two-byte count");
        return 0;
    }
    count = read_le16(bytes);
    vectors_end = 2 + (size_t)count * 2;
    if (vectors_end > length) {
        set_error(error, "symbol table declares %u vectors but only %zu bytes remain", (unsigned)count, length);
        return 0;
    }
    name_anchor = vectors_end + 2;
    if (count != 0 && name_anchor > length) {
        set_error(error, "symbol table has vectors but no value/name records");
        return 0;
    }
    if (strict) {
        size_t physical = vectors_end;
        size_t records = 0;
        name_starts = (uint8_t *)calloc(length == 0 ? 1 : length, 1);
        if (name_starts == NULL) {
            set_error(error, "out of memory while validating symbol-table records");
            return 0;
        }
        while (physical < length) {
            size_t position;
            int terminated = 0;
            if (length - physical < 3) {
                set_error(error, "truncated physical symbol record at table offset 0x%zx", physical);
                free(name_starts);
                return 0;
            }
            position = physical + 2;
            name_starts[position] = 1;
            while (position < length) {
                uint8_t value = bytes[position++];
                if ((value & 0x80U) != 0) {
                    terminated = 1;
                    break;
                }
            }
            if (!terminated) {
                set_error(error, "physical symbol record at table offset 0x%zx has no name terminator", physical);
                free(name_starts);
                return 0;
            }
            physical = position;
            ++records;
        }
        if (records != count) {
            set_error(error,
                      "symbol table declares %u symbols but contains %zu physical records",
                      (unsigned)count,
                      records);
            free(name_starts);
            return 0;
        }
    }
    table->names = (char **)calloc(count == 0 ? 1 : count, sizeof(char *));
    if (table->names == NULL) {
        set_error(error, "out of memory while reading symbol table");
        return 0;
    }
    table->count = count;
    for (i = 0; i < count; ++i) {
        uint16_t vector = read_le16(bytes + 2 + i * 2);
        size_t name_offset = (size_t)(vector & 0x3fffU);
        size_t position;
        size_t start;
        StringBuffer name = {0};
        int terminated = 0;

        if (name_offset > SIZE_MAX - name_anchor) {
            set_error(error, "symbol ordinal %zu has an overflowing name offset", i + 1);
            goto fail;
        }
        position = name_anchor + name_offset;
        start = position;
        if (strict && (position >= length || name_starts[position] == 0)) {
            set_error(error,
                      "symbol ordinal %zu points to 0x%zx, which is not a physical name boundary",
                      i + 1,
                      position);
            goto fail;
        }
        if (position >= length) {
            if (strict) {
                set_error(error, "symbol ordinal %zu points outside the symbol table", i + 1);
                goto fail;
            }
            if (warnings != NULL) {
                ++*warnings;
            }
            table->names[i] = duplicate_string("<BAD-SYMBOL>");
            if (table->names[i] == NULL) {
                set_error(error, "out of memory while creating salvage symbol");
                goto fail;
            }
            continue;
        }
        while (position < length) {
            uint8_t value = bytes[position++];
            char character = (char)(value & 0x7fU);
            if (character < 0x20 || character == 0x7f) {
                if (strict) {
                    set_error(error, "symbol ordinal %zu contains non-printable byte 0x%02x", i + 1, value);
                    free(name.data);
                    goto fail;
                }
                character = '?';
                if (warnings != NULL) {
                    ++*warnings;
                }
            }
            if (!sb_append_char(&name, character, error)) {
                free(name.data);
                goto fail;
            }
            if ((value & 0x80U) != 0) {
                terminated = 1;
                break;
            }
            if (strict && position - start > 8) {
                set_error(error, "symbol ordinal %zu exceeds PROMETHEUS's eight-character limit", i + 1);
                free(name.data);
                goto fail;
            }
        }
        if (!terminated) {
            if (strict) {
                set_error(error, "symbol ordinal %zu has no high-bit name terminator", i + 1);
                free(name.data);
                goto fail;
            }
            if (warnings != NULL) {
                ++*warnings;
            }
        }
        if (name.data == NULL) {
            name.data = duplicate_string("");
            if (name.data == NULL) {
                set_error(error, "out of memory while storing symbol name");
                goto fail;
            }
        }
        table->names[i] = name.data;
    }
    free(name_starts);
    return 1;

fail:
    free(name_starts);
    symbol_table_free(table);
    return 0;
}

static uint16_t symbol_ordinal(const uint8_t *bytes)
{
    return (uint16_t)(((uint16_t)(bytes[0] & 0x7fU) << 8) | bytes[1]);
}

static const char *symbol_name(const char *const *symbols,
                               size_t symbol_count,
                               uint16_t ordinal,
                               int strict,
                               StringBuffer *fallback,
                               unsigned *warnings,
                               PtError *error)
{
    if (ordinal >= 1 && ordinal <= symbol_count && symbols[ordinal - 1] != NULL) {
        return symbols[ordinal - 1];
    }
    if (strict) {
        set_error(error, "source record references missing symbol ordinal %u", (unsigned)ordinal);
        return NULL;
    }
    if (warnings != NULL) {
        ++*warnings;
    }
    fallback->length = 0;
    if (fallback->data != NULL) {
        fallback->data[0] = '\0';
    }
    {
        char temp[32];
        (void)snprintf(temp, sizeof(temp), "<SYM#%u>", (unsigned)ordinal);
        if (!sb_append(fallback, temp, error)) {
            return NULL;
        }
    }
    return fallback->data;
}

static const PtInstruction *find_instruction(uint8_t opcode, uint8_t prefix)
{
    size_t low = 0;
    size_t high = PT_ARRAY_COUNT(g_instructions);
    unsigned key = ((unsigned)opcode << 8) | prefix;

    while (low < high) {
        size_t middle = low + (high - low) / 2;
        unsigned candidate = ((unsigned)g_instructions[middle].opcode << 8) | g_instructions[middle].prefix;
        if (candidate < key) {
            low = middle + 1;
        } else {
            high = middle;
        }
    }
    if (low < PT_ARRAY_COUNT(g_instructions)
        && g_instructions[low].opcode == opcode
        && g_instructions[low].prefix == prefix) {
        return &g_instructions[low];
    }
    return NULL;
}

static int append_expression(const uint8_t *bytes,
                             size_t start,
                             size_t end,
                             const char *const *symbols,
                             size_t symbol_count,
                             int strict,
                             StringBuffer *output,
                             unsigned *warnings,
                             PtError *error)
{
    size_t position = start;
    StringBuffer fallback = {0};
    while (position < end) {
        uint8_t value = bytes[position++];
        if (value >= 0x80U) {
            uint16_t ordinal;
            const char *name;
            if (value >= 0xc0U) {
                set_error(error, "unexpected terminal byte inside expression");
                free(fallback.data);
                return 0;
            }
            if (position >= end) {
                set_error(error, "truncated symbol reference inside expression");
                free(fallback.data);
                return 0;
            }
            ordinal = symbol_ordinal(bytes + position - 1);
            ++position;
            name = symbol_name(symbols, symbol_count, ordinal, strict, &fallback, warnings, error);
            if (name == NULL || !sb_append(output, name, error)) {
                free(fallback.data);
                return 0;
            }
        } else {
            if (!sb_append_char(output, (char)value, error)) {
                free(fallback.data);
                return 0;
            }
        }
    }
    free(fallback.data);
    return 1;
}

static int find_payload_end(const uint8_t *record,
                            size_t available,
                            uint8_t storage_class,
                            int has_label,
                            int strict,
                            size_t *payload_end,
                            size_t *record_size,
                            unsigned *warnings,
                            PtError *error)
{
    size_t position;

    if (storage_class == 0 && !has_label) {
        *payload_end = 2;
        *record_size = 2;
        return 1;
    }
    position = 2;
    while (position < available) {
        uint8_t value = record[position];
        if (value >= 0xc0U) {
            size_t actual_payload = position - 2;
            size_t encoded_payload = value & 0x3fU;
            if (actual_payload != encoded_payload) {
                if (strict) {
                    set_error(error,
                              "record terminal says %zu payload bytes but %zu were scanned",
                              encoded_payload,
                              actual_payload);
                    return 0;
                }
                if (warnings != NULL) {
                    ++*warnings;
                }
            }
            *payload_end = position;
            *record_size = position + 1;
            return 1;
        }
        if (value >= 0x80U) {
            if (position + 1 >= available) {
                set_error(error, "truncated two-byte symbol reference while scanning record");
                return 0;
            }
            position += 2;
        } else {
            ++position;
        }
    }
    set_error(error, "variable source record has no terminal/back-link marker");
    return 0;
}

static char *replace_once(const char *source, const char *needle, const char *replacement, PtError *error)
{
    const char *match = strstr(source, needle);
    size_t prefix;
    size_t result_size;
    char *result;
    if (match == NULL) {
        set_error(error, "internal instruction template '%s' lacks placeholder '%s'", source, needle);
        return NULL;
    }
    prefix = (size_t)(match - source);
    if (prefix > SIZE_MAX - strlen(replacement)
        || prefix + strlen(replacement) > SIZE_MAX - strlen(match + strlen(needle))) {
        set_error(error, "instruction template expansion overflow");
        return NULL;
    }
    result_size = prefix + strlen(replacement) + strlen(match + strlen(needle));
    result = (char *)malloc(result_size + 1);
    if (result == NULL) {
        set_error(error, "out of memory while expanding instruction template");
        return NULL;
    }
    memcpy(result, source, prefix);
    memcpy(result + prefix, replacement, strlen(replacement));
    strcpy(result + prefix + strlen(replacement), match + strlen(needle));
    return result;
}

static char *apply_iy_spelling(const char *source, PtError *error)
{
    StringBuffer output = {0};
    size_t i = 0;
    while (source[i] != '\0') {
        if (source[i] == 'i' && source[i + 1] == 'x') {
            if (!sb_append(&output, "iy", error)) {
                free(output.data);
                return NULL;
            }
            i += 2;
        } else if (source[i] == 'h' && source[i + 1] == 'x') {
            if (!sb_append(&output, "hy", error)) {
                free(output.data);
                return NULL;
            }
            i += 2;
        } else if (source[i] == 'l' && source[i + 1] == 'x') {
            if (!sb_append(&output, "ly", error)) {
                free(output.data);
                return NULL;
            }
            i += 2;
        } else {
            if (!sb_append_char(&output, source[i], error)) {
                free(output.data);
                return NULL;
            }
            ++i;
        }
    }
    if (output.data == NULL) {
        output.data = duplicate_string("");
    }
    return output.data;
}

static char *indexed_operand(const char *index_name, const char *expression, PtError *error)
{
    StringBuffer output = {0};
    if (!sb_append_char(&output, '(', error)
        || !sb_append(&output, index_name, error)
        || (expression[0] != '-' && !sb_append_char(&output, '+', error))
        || !sb_append(&output, expression, error)
        || !sb_append_char(&output, ')', error)) {
        free(output.data);
        return NULL;
    }
    return output.data;
}

static int split_expression_ranges(const uint8_t *record,
                                   size_t start,
                                   size_t end,
                                   size_t *first_end,
                                   size_t *second_start)
{
    size_t position = start;
    while (position < end) {
        uint8_t value = record[position];
        if (value == 0x1fU) {
            *first_end = position;
            *second_start = position + 1;
            return 1;
        }
        if (value >= 0x80U && value < 0xc0U) {
            position += 2;
        } else {
            ++position;
        }
    }
    return 0;
}

static int split_template(const char *expanded, char **mnemonic, char **operands, PtError *error)
{
    const char *space = strchr(expanded, ' ');
    if (space == NULL) {
        *mnemonic = duplicate_string(expanded);
        *operands = duplicate_string("");
    } else {
        const char *rest = space;
        while (*rest == ' ') {
            ++rest;
        }
        *mnemonic = duplicate_n(expanded, (size_t)(space - expanded));
        *operands = duplicate_string(rest);
    }
    if (*mnemonic == NULL || *operands == NULL) {
        free(*mnemonic);
        free(*operands);
        *mnemonic = NULL;
        *operands = NULL;
        set_error(error, "out of memory while splitting decoded source line");
        return 0;
    }
    return 1;
}

static int decode_record(const uint8_t *record,
                         size_t available,
                         const char *const *symbols,
                         size_t symbol_count,
                         int strict,
                         PtDecodedRecord *decoded,
                         unsigned *warnings,
                         PtError *error)
{
    uint8_t opcode;
    uint8_t info;
    uint8_t prefix;
    uint8_t lookup_prefix;
    uint8_t storage_class;
    int has_label;
    int iy_variant;
    size_t payload_end;
    size_t record_size;
    size_t cursor;
    const PtInstruction *instruction;
    char *template_text = NULL;
    char *expanded = NULL;
    StringBuffer expression1 = {0};
    StringBuffer expression2 = {0};

    memset(decoded, 0, sizeof(*decoded));
    if (available < 2) {
        set_error(error, "truncated source record header");
        return 0;
    }
    opcode = record[0];
    info = record[1];
    prefix = info & 0xf0U;
    storage_class = info & 0x07U;
    has_label = (info & 0x08U) != 0;
    iy_variant = (prefix & 0x10U) != 0 && (prefix & 0x20U) == 0;
    lookup_prefix = prefix;
    if (iy_variant) {
        lookup_prefix = (uint8_t)((lookup_prefix & ~0x10U) | 0x20U);
    }
    instruction = find_instruction(opcode, lookup_prefix);
    if (instruction == NULL) {
        set_error(error, "unknown opcode/prefix record key %02x/%02x", opcode, prefix);
        return 0;
    }
    if (instruction->storage_class != storage_class) {
        if (strict) {
            set_error(error,
                      "source record class %u disagrees with instruction-table class %u for key %02x/%02x",
                      (unsigned)storage_class,
                      (unsigned)instruction->storage_class,
                      opcode,
                      prefix);
            return 0;
        }
        if (warnings != NULL) {
            ++*warnings;
        }
        storage_class = instruction->storage_class;
    }
    if (!find_payload_end(record, available, storage_class, has_label, strict,
                          &payload_end, &record_size, warnings, error)) {
        return 0;
    }
    decoded->bytes_consumed = record_size;
    cursor = 2;

    if (has_label) {
        uint16_t ordinal;
        StringBuffer fallback = {0};
        const char *name;
        if (payload_end - cursor < 2 || record[cursor] < 0x80U || record[cursor] >= 0xc0U) {
            set_error(error, "record label flag is set but no tagged ordinal follows the header");
            return 0;
        }
        ordinal = symbol_ordinal(record + cursor);
        name = symbol_name(symbols, symbol_count, ordinal, strict, &fallback, warnings, error);
        if (name == NULL) {
            free(fallback.data);
            return 0;
        }
        decoded->label = duplicate_string(name);
        free(fallback.data);
        if (decoded->label == NULL) {
            set_error(error, "out of memory while storing decoded label");
            return 0;
        }
        cursor += 2;
    } else {
        decoded->label = duplicate_string("");
        if (decoded->label == NULL) {
            set_error(error, "out of memory while storing empty label");
            return 0;
        }
    }

    if (strcmp(instruction->source_template, "empty line") == 0) {
        decoded->blank = 1;
        decoded->mnemonic = duplicate_string("");
        decoded->operands = duplicate_string("");
        if (decoded->mnemonic == NULL || decoded->operands == NULL) {
            set_error(error, "out of memory while decoding empty line");
            goto fail;
        }
        return 1;
    }
    if (strcmp(instruction->source_template, "comment") == 0) {
        decoded->comment = duplicate_n((const char *)record + cursor, payload_end - cursor);
        decoded->mnemonic = duplicate_string("");
        decoded->operands = duplicate_string("");
        if (decoded->comment == NULL || decoded->mnemonic == NULL || decoded->operands == NULL) {
            set_error(error, "out of memory while decoding comment");
            goto fail;
        }
        return 1;
    }

    template_text = iy_variant
        ? apply_iy_spelling(instruction->source_template, error)
        : duplicate_string(instruction->source_template);
    if (template_text == NULL) {
        if (error != NULL && error->message[0] == '\0') {
            set_error(error, "out of memory while copying instruction template");
        }
        goto fail;
    }

    switch (storage_class) {
        case 0:
            expanded = duplicate_string(template_text);
            break;

        case 1:
        case 2:
        case 3:
        case 6:
            if (!append_expression(record, cursor, payload_end, symbols, symbol_count,
                                   strict, &expression1, warnings, error)) {
                goto fail;
            }
            expanded = replace_once(template_text, "N", expression1.data == NULL ? "" : expression1.data, error);
            break;

        case 4: {
            char *indexed;
            const char *index_name = iy_variant ? "iy" : "ix";
            if (!append_expression(record, cursor, payload_end, symbols, symbol_count,
                                   strict, &expression1, warnings, error)) {
                goto fail;
            }
            indexed = indexed_operand(index_name, expression1.data == NULL ? "" : expression1.data, error);
            if (indexed == NULL) {
                goto fail;
            }
            expanded = replace_once(template_text,
                                    iy_variant ? "(iy+d)" : "(ix+d)",
                                    indexed,
                                    error);
            free(indexed);
            break;
        }

        case 5: {
            size_t first_end;
            size_t second_start;
            char *indexed;
            char *step;
            const char *index_name = iy_variant ? "iy" : "ix";
            if (!split_expression_ranges(record, cursor, payload_end, &first_end, &second_start)) {
                set_error(error, "two-expression source record lacks the internal 0x1f separator");
                goto fail;
            }
            if (!append_expression(record, cursor, first_end, symbols, symbol_count,
                                   strict, &expression1, warnings, error)
                || !append_expression(record, second_start, payload_end, symbols, symbol_count,
                                      strict, &expression2, warnings, error)) {
                goto fail;
            }
            indexed = indexed_operand(index_name,
                                      expression1.data == NULL ? "" : expression1.data,
                                      error);
            if (indexed == NULL) {
                goto fail;
            }
            step = replace_once(template_text,
                                iy_variant ? "(iy+d)" : "(ix+d)",
                                indexed,
                                error);
            free(indexed);
            if (step == NULL) {
                goto fail;
            }
            expanded = replace_once(step, "N", expression2.data == NULL ? "" : expression2.data, error);
            free(step);
            break;
        }

        case 7:
            if (!append_expression(record, cursor, payload_end, symbols, symbol_count,
                                   strict, &expression1, warnings, error)) {
                goto fail;
            }
            if (strcmp(template_text, "defb") == 0
                || strcmp(template_text, "defm") == 0
                || strcmp(template_text, "defs") == 0
                || strcmp(template_text, "defw") == 0) {
                StringBuffer line = {0};
                if (!sb_append(&line, template_text, error)
                    || (expression1.length != 0 && !sb_append_char(&line, ' ', error))
                    || (expression1.length != 0 && !sb_append(&line, expression1.data, error))) {
                    free(line.data);
                    goto fail;
                }
                expanded = line.data;
            } else {
                expanded = replace_once(template_text, "N", expression1.data == NULL ? "" : expression1.data, error);
            }
            break;

        default:
            set_error(error, "unsupported source storage class %u", (unsigned)storage_class);
            goto fail;
    }

    if (expanded == NULL) {
        if (error != NULL && error->message[0] == '\0') {
            set_error(error, "out of memory while decoding instruction");
        }
        goto fail;
    }
    if (!split_template(expanded, &decoded->mnemonic, &decoded->operands, error)) {
        goto fail;
    }
    free(template_text);
    free(expanded);
    free(expression1.data);
    free(expression2.data);
    return 1;

fail:
    free(template_text);
    free(expanded);
    free(expression1.data);
    free(expression2.data);
    pt_decoded_record_free(decoded);
    return 0;
}

static int append_repeated(StringBuffer *line,
                           char value,
                           unsigned count,
                           PtError *error)
{
    unsigned i;
    for (i = 0; i < count; ++i) {
        if (!sb_append_char(line, value, error)) {
            return 0;
        }
    }
    return 1;
}

static char number_case_char(char value, PtNumberCase mode)
{
    unsigned char c = (unsigned char)value;
    if (mode == PT_NUMBER_CASE_LOWER) {
        return (char)tolower(c);
    }
    if (mode == PT_NUMBER_CASE_UPPER) {
        return (char)toupper(c);
    }
    return value;
}

static int append_cased_digits(StringBuffer *output,
                               const char *digits,
                               size_t length,
                               PtNumberCase mode,
                               PtError *error)
{
    size_t i;
    for (i = 0; i < length; ++i) {
        if (!sb_append_char(output, number_case_char(digits[i], mode), error)) {
            return 0;
        }
    }
    return 1;
}

static int append_hex_literal(StringBuffer *output,
                              const char *digits,
                              size_t length,
                              const PtConvertOptions *options,
                              PtError *error)
{
    char first;
    switch (options->hex_style) {
        case PT_HEX_KEEP:
        case PT_HEX_HASH:
            if (!sb_append_char(output, '#', error)) return 0;
            break;
        case PT_HEX_DOLLAR:
            if (!sb_append_char(output, '$', error)) return 0;
            break;
        case PT_HEX_0X:
            if (!sb_append(output,
                           options->number_case == PT_NUMBER_CASE_UPPER ? "0X" : "0x",
                           error)) return 0;
            break;
        case PT_HEX_SUFFIX_H:
            first = number_case_char(digits[0], options->number_case);
            if ((first >= 'a' && first <= 'f') || (first >= 'A' && first <= 'F')) {
                if (!sb_append_char(output, '0', error)) return 0;
            }
            break;
        default:
            set_error(error, "invalid hexadecimal output style %d", (int)options->hex_style);
            return 0;
    }
    if (!append_cased_digits(output, digits, length, options->number_case, error)) return 0;
    if (options->hex_style == PT_HEX_SUFFIX_H) {
        char suffix = options->number_case == PT_NUMBER_CASE_UPPER ? 'H' : 'h';
        if (!sb_append_char(output, suffix, error)) return 0;
    }
    return 1;
}

static int append_binary_literal(StringBuffer *output,
                                 const char *digits,
                                 size_t length,
                                 const PtConvertOptions *options,
                                 PtError *error)
{
    switch (options->binary_style) {
        case PT_BINARY_KEEP:
        case PT_BINARY_PERCENT:
            if (!sb_append_char(output, '%', error)) return 0;
            break;
        case PT_BINARY_0B:
            if (!sb_append(output,
                           options->number_case == PT_NUMBER_CASE_UPPER ? "0B" : "0b",
                           error)) return 0;
            break;
        case PT_BINARY_SUFFIX_B:
            break;
        default:
            set_error(error, "invalid binary output style %d", (int)options->binary_style);
            return 0;
    }
    if (!append_cased_digits(output, digits, length, options->number_case, error)) return 0;
    if (options->binary_style == PT_BINARY_SUFFIX_B) {
        char suffix = options->number_case == PT_NUMBER_CASE_UPPER ? 'B' : 'b';
        if (!sb_append_char(output, suffix, error)) return 0;
    }
    return 1;
}

static char *format_numeric_literals(const char *source,
                                     const PtConvertOptions *options,
                                     PtError *error)
{
    StringBuffer output = {0};
    size_t i = 0;
    while (source[i] != '\0') {
        char c = source[i];
        if (c == '\'' || c == '"') {
            char quote = c;
            if (!sb_append_char(&output, c, error)) goto fail;
            ++i;
            while (source[i] != '\0') {
                c = source[i++];
                if (!sb_append_char(&output, c, error)) goto fail;
                if (c == '\\' && source[i] != '\0') {
                    if (!sb_append_char(&output, source[i++], error)) goto fail;
                } else if (c == quote) {
                    break;
                }
            }
        } else if (c == '<' && strncmp(source + i, "<SYM#", 5) == 0) {
            do {
                c = source[i++];
                if (!sb_append_char(&output, c, error)) goto fail;
            } while (c != '>' && source[i] != '\0');
        } else if (c == '#' && isxdigit((unsigned char)source[i + 1])) {
            size_t start = ++i;
            while (isxdigit((unsigned char)source[i])) ++i;
            if (!append_hex_literal(&output, source + start, i - start, options, error)) goto fail;
        } else if (c == '%' && (source[i + 1] == '0' || source[i + 1] == '1')) {
            size_t start = ++i;
            while (source[i] == '0' || source[i] == '1') ++i;
            if (!append_binary_literal(&output, source + start, i - start, options, error)) goto fail;
        } else {
            if (!sb_append_char(&output, c, error)) goto fail;
            ++i;
        }
    }
    if (output.data == NULL) {
        output.data = duplicate_string("");
        if (output.data == NULL) {
            set_error(error, "out of memory while formatting numeric literals");
        }
    }
    return output.data;

fail:
    free(output.data);
    return NULL;
}

static const char *mapped_mnemonic(const PtConvertOptions *options, const char *mnemonic)
{
    if (strcmp(mnemonic, "defb") == 0) return options->directives.defb;
    if (strcmp(mnemonic, "defw") == 0) return options->directives.defw;
    if (strcmp(mnemonic, "defm") == 0) return options->directives.defm;
    if (strcmp(mnemonic, "defs") == 0) return options->directives.defs;
    if (strcmp(mnemonic, "ent") == 0) return options->directives.ent;
    if (strcmp(mnemonic, "equ") == 0) return options->directives.equ;
    if (strcmp(mnemonic, "org") == 0) return options->directives.org;
    if (strcmp(mnemonic, "put") == 0) return options->directives.put;
    return mnemonic;
}

static int append_line(ByteBuffer *output,
                       const PtDecodedRecord *record,
                       const PtConvertOptions *options,
                       int generated_comment,
                       PtError *error)
{
    StringBuffer line = {0};
    const char *eol = options->line_endings == PT_EOL_CRLF ? "\r\n" : "\n";
    const char *mnemonic = record->mnemonic == NULL ? "" : mapped_mnemonic(options, record->mnemonic);
    char *operands = NULL;

    if (record->comment != NULL) {
        unsigned required_flag = generated_comment ? PT_COMMENT_GENERATED : PT_COMMENT_SOURCE;
        if ((options->comment_flags & required_flag) == 0) {
            return 1;
        }
        if (!sb_append(&line, record->comment, error)) {
            free(line.data);
            return 0;
        }
    } else if (record->blank) {
        if (record->label != NULL && record->label[0] != '\0') {
            if (!sb_append(&line, record->label, error)) {
                free(line.data);
                return 0;
            }
        }
    } else {
        operands = format_numeric_literals(record->operands == NULL ? "" : record->operands,
                                           options,
                                           error);
        if (operands == NULL) {
            free(line.data);
            return 0;
        }

        if (options->format == PT_FORMAT_COMPACT) {
            if (record->label != NULL && record->label[0] != '\0') {
                if (!sb_append(&line, record->label, error)) goto fail;
                if (mnemonic[0] != '\0' && !sb_append_char(&line, ' ', error)) goto fail;
            } else if (mnemonic[0] != '\0') {
                if (!sb_append(&line, "    ", error)) goto fail;
            }
            if (!sb_append(&line, mnemonic, error)) goto fail;
            if (operands[0] != '\0') {
                if (!sb_append_char(&line, ' ', error) || !sb_append(&line, operands, error)) goto fail;
            }
        } else if (options->format == PT_FORMAT_SEPARATED) {
            char separator = options->indent_character == PT_INDENT_TAB ? '\t' : ' ';
            int has_label = record->label != NULL && record->label[0] != '\0';
            if (has_label) {
                if (!sb_append(&line, record->label, error)) goto fail;
                if (mnemonic[0] != '\0'
                    && !append_repeated(&line, separator, options->label_separator, error)) goto fail;
            } else if (mnemonic[0] != '\0'
                       && !append_repeated(&line, separator, options->instruction_indent, error)) goto fail;
            if (!sb_append(&line, mnemonic, error)) goto fail;
            if (operands[0] != '\0') {
                if (!append_repeated(&line, separator, options->operand_separator, error)
                    || !sb_append(&line, operands, error)) goto fail;
            }
        } else if (options->format == PT_FORMAT_PROMETHEUS) {
            size_t label_length = record->label == NULL ? 0 : strlen(record->label);
            size_t mnemonic_length = strlen(mnemonic);
            size_t i;
            if (label_length != 0 && !sb_append(&line, record->label, error)) goto fail;
            if (mnemonic_length != 0) {
                for (i = label_length; i < 9; ++i) {
                    if (!sb_append_char(&line, ' ', error)) goto fail;
                }
                if (!sb_append(&line, mnemonic, error)) goto fail;
                if (mnemonic_length < 5) {
                    for (i = mnemonic_length; i < 5; ++i) {
                        if (!sb_append_char(&line, ' ', error)) goto fail;
                    }
                } else if (operands[0] != '\0') {
                    if (!sb_append_char(&line, ' ', error)) goto fail;
                }
                if (operands[0] != '\0' && !sb_append(&line, operands, error)) goto fail;
            }
        } else {
            set_error(error, "invalid output format %d", (int)options->format);
            goto fail;
        }
    }

    if (!bb_append(output, line.data == NULL ? "" : line.data, line.length, error)
        || !bb_append(output, eol, strlen(eol), error)) {
        goto fail;
    }
    free(operands);
    free(line.data);
    return 1;

fail:
    free(operands);
    free(line.data);
    return 0;
}

static int directive_name_valid(const char name[PT_DIRECTIVE_NAME_CAPACITY])
{
    const char *end = (const char *)memchr(name, '\0', PT_DIRECTIVE_NAME_CAPACITY);
    const char *p;
    if (end == NULL || end == name) return 0;
    for (p = name; p < end; ++p) {
        unsigned char c = (unsigned char)*p;
        if (isspace(c) || c < 0x21U || c == '=') return 0;
    }
    return 1;
}

static int validate_output_options(const PtConvertOptions *options, PtError *error)
{
    const char *directive_names[] = {
        options->directives.defb, options->directives.defw,
        options->directives.defm, options->directives.defs,
        options->directives.ent, options->directives.equ,
        options->directives.org, options->directives.put
    };
    size_t i;
    if (options->format < PT_FORMAT_PROMETHEUS || options->format > PT_FORMAT_SEPARATED) {
        set_error(error, "invalid output format %d", (int)options->format);
        return 0;
    }
    if (options->line_endings < PT_EOL_LF || options->line_endings > PT_EOL_CRLF) {
        set_error(error, "invalid line-ending mode %d", (int)options->line_endings);
        return 0;
    }
    if (options->indent_character < PT_INDENT_SPACE || options->indent_character > PT_INDENT_TAB) {
        set_error(error, "invalid indentation character %d", (int)options->indent_character);
        return 0;
    }
    if (options->instruction_indent > 1024U
        || options->label_separator > 1024U
        || options->operand_separator > 1024U) {
        set_error(error, "indentation counts must not exceed 1024 characters");
        return 0;
    }
    if (options->hex_style < PT_HEX_KEEP || options->hex_style > PT_HEX_SUFFIX_H) {
        set_error(error, "invalid hexadecimal output style %d", (int)options->hex_style);
        return 0;
    }
    if (options->binary_style < PT_BINARY_KEEP || options->binary_style > PT_BINARY_SUFFIX_B) {
        set_error(error, "invalid binary output style %d", (int)options->binary_style);
        return 0;
    }
    if (options->number_case < PT_NUMBER_CASE_PRESERVE
        || options->number_case > PT_NUMBER_CASE_UPPER) {
        set_error(error, "invalid numeric-letter case %d", (int)options->number_case);
        return 0;
    }
    if ((options->comment_flags & ~PT_COMMENT_ALL) != 0) {
        set_error(error, "invalid comment flags 0x%x", options->comment_flags);
        return 0;
    }
    for (i = 0; i < PT_ARRAY_COUNT(directive_names); ++i) {
        if (!directive_name_valid(directive_names[i])) {
            set_error(error, "pseudo-operation name %zu is empty, unterminated, or contains whitespace", i);
            return 0;
        }
    }
    return 1;
}

static int validate_source_bytes(const uint8_t *source,
                                 size_t source_length,
                                 const SymbolTable *symbols,
                                 const PtConvertOptions *options,
                                 ByteBuffer *output,
                                 PtConvertReport *report,
                                 PtError *error)
{
    size_t offset = 0;
    if (!validate_output_options(options, error)) {
        return 0;
    }
    while (offset < source_length) {
        PtDecodedRecord decoded;
        PtError local_error = {{0}};
        unsigned before_warnings = report == NULL ? 0 : report->warnings;
        if (!decode_record(source + offset,
                           source_length - offset,
                           (const char *const *)symbols->names,
                           symbols->count,
                           options->strict,
                           &decoded,
                           report == NULL ? NULL : &report->warnings,
                           &local_error)) {
            if (options->strict) {
                set_error(error, "source record at byte offset 0x%zx: %s", offset, local_error.message);
                return 0;
            }
            if (report != NULL) {
                if (report->warnings == before_warnings) {
                    ++report->warnings;
                }
            }
            if (output != NULL) {
                char diagnostic[640];
                int written = snprintf(diagnostic,
                                       sizeof(diagnostic),
                                       "; [prometheus-tap2asm: stopped at source offset 0x%zx: %s]",
                                       offset,
                                       local_error.message[0] == '\0' ? "unknown decode error" : local_error.message);
                PtDecodedRecord salvage;
                memset(&salvage, 0, sizeof(salvage));
                salvage.comment = duplicate_n(diagnostic, written < 0 ? 0 : (size_t)written);
                if (salvage.comment == NULL || !append_line(output, &salvage, options, 1, error)) {
                    pt_decoded_record_free(&salvage);
                    return 0;
                }
                pt_decoded_record_free(&salvage);
            }
            return 1;
        }
        if (decoded.bytes_consumed == 0 || decoded.bytes_consumed > source_length - offset) {
            pt_decoded_record_free(&decoded);
            set_error(error, "decoder returned an invalid record length at source offset 0x%zx", offset);
            return 0;
        }
        if (output != NULL && !append_line(output, &decoded, options, 0, error)) {
            pt_decoded_record_free(&decoded);
            return 0;
        }
        offset += decoded.bytes_consumed;
        if (report != NULL) {
            ++report->records;
        }
        pt_decoded_record_free(&decoded);
    }
    return 1;
}

static int source_payload_validate(const uint8_t *payload,
                                   size_t payload_length,
                                   uint16_t source_length,
                                   const PtConvertOptions *options,
                                   ByteBuffer *output,
                                   PtConvertReport *report,
                                   PtError *error)
{
    SymbolTable symbols;
    size_t table_offset;
    size_t table_length;
    unsigned *warnings = report == NULL ? NULL : &report->warnings;

    if ((size_t)source_length + 2 > payload_length) {
        set_error(error,
                  "header declares %u source bytes, but data block has only %zu bytes including bridge/table",
                  (unsigned)source_length,
                  payload_length);
        return 0;
    }
    table_offset = (size_t)source_length + 2;
    table_length = payload_length - table_offset;
    if (!symbol_table_parse(payload + table_offset,
                            table_length,
                            options->strict,
                            &symbols,
                            warnings,
                            error)) {
        return 0;
    }
    if (!validate_source_bytes(payload, source_length, &symbols, options, output, report, error)) {
        symbol_table_free(&symbols);
        return 0;
    }
    symbol_table_free(&symbols);
    return 1;
}


static int split_buffers_validate(const uint8_t *source,
                                  size_t source_length,
                                  const uint8_t *symbol_bytes,
                                  size_t symbol_length,
                                  const PtConvertOptions *options,
                                  ByteBuffer *output,
                                  PtConvertReport *report,
                                  PtError *error)
{
    SymbolTable symbols;
    unsigned *warnings = report == NULL ? NULL : &report->warnings;

    if (source == NULL && source_length != 0) {
        set_error(error, "source buffer is NULL");
        return 0;
    }
    if (symbol_bytes == NULL && symbol_length != 0) {
        set_error(error, "symbol-table buffer is NULL");
        return 0;
    }
    if (!symbol_table_parse(symbol_bytes,
                            symbol_length,
                            options->strict,
                            &symbols,
                            warnings,
                            error)) {
        return 0;
    }
    if (!validate_source_bytes(source, source_length, &symbols, options, output, report, error)) {
        symbol_table_free(&symbols);
        return 0;
    }
    symbol_table_free(&symbols);
    return 1;
}

int pt_convert_split_buffers(const uint8_t *source,
                             size_t source_length,
                             const uint8_t *symbols,
                             size_t symbols_length,
                             const PtConvertOptions *options_input,
                             unsigned char **output,
                             size_t *output_size,
                             PtConvertReport *report,
                             PtError *error)
{
    PtConvertOptions defaults;
    const PtConvertOptions *options = options_input;
    ByteBuffer converted = {0};
    PtConvertReport local_report = {0};

    if (output == NULL || output_size == NULL) {
        set_error(error, "output pointers must not be NULL");
        return 0;
    }
    *output = NULL;
    *output_size = 0;
    if (error != NULL) {
        error->message[0] = '\0';
    }
    if (options == NULL) {
        pt_default_options(&defaults);
        options = &defaults;
    }
    if (!split_buffers_validate(source,
                                source_length,
                                symbols,
                                symbols_length,
                                options,
                                &converted,
                                &local_report,
                                error)) {
        free(converted.data);
        return 0;
    }
    *output = converted.data;
    *output_size = converted.length;
    if (report != NULL) {
        *report = local_report;
    }
    return 1;
}

int pt_validate_split_buffers(const uint8_t *source,
                              size_t source_length,
                              const uint8_t *symbols,
                              size_t symbols_length,
                              const PtConvertOptions *options_input,
                              PtConvertReport *report,
                              PtError *error)
{
    PtConvertOptions defaults;
    const PtConvertOptions *options = options_input;
    PtConvertReport local_report = {0};

    if (error != NULL) {
        error->message[0] = '\0';
    }
    if (options == NULL) {
        pt_default_options(&defaults);
        options = &defaults;
    }
    if (!split_buffers_validate(source,
                                source_length,
                                symbols,
                                symbols_length,
                                options,
                                NULL,
                                &local_report,
                                error)) {
        return 0;
    }
    if (report != NULL) {
        *report = local_report;
    }
    return 1;
}

int pt_probe_symbol_table(const uint8_t *symbols,
                          size_t symbols_length,
                          unsigned *symbol_count)
{
    SymbolTable table;
    PtError error = {{0}};
    unsigned warnings = 0;
    int ok = symbol_table_parse(symbols,
                                symbols_length,
                                1,
                                &table,
                                &warnings,
                                &error);
    if (!ok) {
        return 0;
    }
    if (symbol_count != NULL) {
        *symbol_count = (unsigned)table.count;
    }
    symbol_table_free(&table);
    return 1;
}

static int locate_source_block(const TapImage *tap,
                               const char *name,
                               const PtConvertOptions *options,
                               const uint8_t **payload,
                               size_t *payload_length,
                               uint16_t *source_length,
                               unsigned *selected_occurrence,
                               unsigned *warnings,
                               PtError *error)
{
    size_t i;
    unsigned occurrence = 0;
    size_t requested_length = strlen(name);

    if (requested_length > 10) {
        set_error(error, "Spectrum tape filename '%s' exceeds ten characters", name);
        return 0;
    }
    for (i = 0; i < tap->count; ++i) {
        const TapBlock *header = &tap->blocks[i];
        uint16_t declared_data_length;
        const TapBlock *data;
        if (header->flag != 0x00U || header->payload_length != 17 || header->payload[0] != 3) {
            continue;
        }
        if (!header_name_matches(header->payload + 1, name, options->ignore_case)) {
            continue;
        }
        if (i + 1 >= tap->count) {
            if (options->strict) {
                set_error(error, "matching CODE header has no following data block");
                return 0;
            }
            continue;
        }
        data = &tap->blocks[i + 1];
        declared_data_length = read_le16(header->payload + 11);
        if (data->flag != 0xffU) {
            if (options->strict) {
                set_error(error, "matching CODE header is not followed by a standard data block");
                return 0;
            }
            continue;
        }
        if (options->strict && data->payload_length != declared_data_length) {
            set_error(error,
                      "matching CODE header declares %u bytes but following data block contains %zu",
                      (unsigned)declared_data_length,
                      data->payload_length);
            return 0;
        }
        if (occurrence++ != options->occurrence) {
            continue;
        }
        if (!options->strict && warnings != NULL) {
            if (!header->checksum_ok) {
                ++*warnings;
            }
            if (!data->checksum_ok) {
                ++*warnings;
            }
            if (data->payload_length != declared_data_length) {
                ++*warnings;
            }
        }
        *payload = data->payload;
        *payload_length = data->payload_length < declared_data_length
            ? data->payload_length
            : declared_data_length;
        *source_length = read_le16(header->payload + 15);
        *selected_occurrence = occurrence - 1;
        return 1;
    }
    set_error(error,
              "PROMETHEUS source CODE block named '%s' occurrence %u was not found",
              name,
              options->occurrence);
    return 0;
}

static void set_directive_name(char destination[PT_DIRECTIVE_NAME_CAPACITY], const char *source)
{
    (void)snprintf(destination, PT_DIRECTIVE_NAME_CAPACITY, "%s", source);
}

void pt_set_prometheus_directives(PtDirectiveNames *directives)
{
    if (directives == NULL) return;
    set_directive_name(directives->defb, "defb");
    set_directive_name(directives->defw, "defw");
    set_directive_name(directives->defm, "defm");
    set_directive_name(directives->defs, "defs");
    set_directive_name(directives->ent, "ent");
    set_directive_name(directives->equ, "equ");
    set_directive_name(directives->org, "org");
    set_directive_name(directives->put, "put");
}

void pt_set_db_directives(PtDirectiveNames *directives)
{
    if (directives == NULL) return;
    pt_set_prometheus_directives(directives);
    set_directive_name(directives->defb, "db");
    set_directive_name(directives->defw, "dw");
    set_directive_name(directives->defm, "db");
    set_directive_name(directives->defs, "ds");
}

void pt_default_options(PtConvertOptions *options)
{
    if (options == NULL) {
        return;
    }
    options->format = PT_FORMAT_PROMETHEUS;
    options->line_endings = PT_EOL_LF;
    options->indent_character = PT_INDENT_SPACE;
    options->instruction_indent = 4;
    options->label_separator = 1;
    options->operand_separator = 1;
    options->hex_style = PT_HEX_KEEP;
    options->binary_style = PT_BINARY_KEEP;
    options->number_case = PT_NUMBER_CASE_PRESERVE;
    options->comment_flags = PT_COMMENT_ALL;
    pt_set_prometheus_directives(&options->directives);
    options->strict = 1;
    options->ignore_case = 0;
    options->occurrence = 0;
    options->symbol_occurrence = 0;
    options->source_offset = 0;
    options->source_length = PT_LENGTH_AUTO;
    options->symbols_offset = 0;
}

int pt_list_tap_file(const char *path, FILE *out, int strict, PtError *error)
{
    TapImage tap;
    size_t i;
    unsigned header_number = 0;
    if (error != NULL) {
        error->message[0] = '\0';
    }
    if (!tap_load(path, &tap, strict, error)) {
        return 0;
    }
    fprintf(out, "#  Type          Name        Length  Param1  Param2  Data  Checksums  PROMETHEUS\n");
    for (i = 0; i < tap.count; ++i) {
        const TapBlock *header = &tap.blocks[i];
        if (header->flag == 0x00U && header->payload_length == 17) {
            uint8_t type = header->payload[0];
            uint16_t declared = read_le16(header->payload + 11);
            uint16_t param1 = read_le16(header->payload + 13);
            uint16_t param2 = read_le16(header->payload + 15);
            char name[11];
            const char *data_state = "missing";
            const char *checksum_state = header->checksum_ok ? "H:ok" : "H:BAD";
            const char *prometheus = "-";
            char checksum_buffer[32];
            char data_buffer[32];
            header_name_text(header->payload + 1, name);
            if (i + 1 < tap.count && tap.blocks[i + 1].flag == 0xffU) {
                const TapBlock *data = &tap.blocks[i + 1];
                (void)snprintf(data_buffer,
                               sizeof(data_buffer),
                               "%zu%s",
                               data->payload_length,
                               data->payload_length == declared ? "" : "!");
                data_state = data_buffer;
                (void)snprintf(checksum_buffer,
                               sizeof(checksum_buffer),
                               "%s D:%s",
                               checksum_state,
                               data->checksum_ok ? "ok" : "BAD");
                checksum_state = checksum_buffer;
                if (type == 3 && (size_t)param2 + 2 <= data->payload_length) {
                    PtConvertOptions options;
                    PtConvertReport report = {0};
                    PtError probe_error = {{0}};
                    pt_default_options(&options);
                    options.strict = 1;
                    if (source_payload_validate(data->payload,
                                                data->payload_length,
                                                param2,
                                                &options,
                                                NULL,
                                                &report,
                                                &probe_error)) {
                        static char probe[64];
                        (void)snprintf(probe, sizeof(probe), "yes (%u lines)", report.records);
                        prometheus = probe;
                    }
                }
            }
            fprintf(out,
                    "%-2u %-13s %-10s  %-6u  %-6u  %-6u  %-6s %-10s %s\n",
                    header_number++,
                    header_type_name(type),
                    name,
                    (unsigned)declared,
                    (unsigned)param1,
                    (unsigned)param2,
                    data_state,
                    checksum_state,
                    prometheus);
        }
    }
    tap_free(&tap);
    return 1;
}

int pt_convert_tap_file(const char *path,
                        const char *name,
                        const PtConvertOptions *options_input,
                        unsigned char **output,
                        size_t *output_size,
                        PtConvertReport *report,
                        PtError *error)
{
    PtConvertOptions defaults;
    const PtConvertOptions *options = options_input;
    TapImage tap;
    const uint8_t *payload;
    size_t payload_length;
    uint16_t source_length;
    unsigned occurrence;
    ByteBuffer converted = {0};
    PtConvertReport local_report = {0};

    if (output == NULL || output_size == NULL) {
        set_error(error, "output pointers must not be NULL");
        return 0;
    }
    *output = NULL;
    *output_size = 0;
    if (error != NULL) {
        error->message[0] = '\0';
    }
    if (options == NULL) {
        pt_default_options(&defaults);
        options = &defaults;
    }
    if (!tap_load(path, &tap, options->strict, error)) {
        return 0;
    }
    if (!locate_source_block(&tap,
                             name,
                             options,
                             &payload,
                             &payload_length,
                             &source_length,
                             &occurrence,
                             &local_report.warnings,
                             error)) {
        tap_free(&tap);
        return 0;
    }
    local_report.selected_occurrence = occurrence;
    if (!source_payload_validate(payload,
                                 payload_length,
                                 source_length,
                                 options,
                                 &converted,
                                 &local_report,
                                 error)) {
        free(converted.data);
        tap_free(&tap);
        return 0;
    }
    tap_free(&tap);
    *output = converted.data;
    *output_size = converted.length;
    if (report != NULL) {
        *report = local_report;
    }
    return 1;
}

int pt_validate_tap_file(const char *path,
                         const char *name,
                         const PtConvertOptions *options_input,
                         PtConvertReport *report,
                         PtError *error)
{
    PtConvertOptions defaults;
    const PtConvertOptions *options = options_input;
    TapImage tap;
    const uint8_t *payload;
    size_t payload_length;
    uint16_t source_length;
    unsigned occurrence;
    PtConvertReport local_report = {0};

    if (error != NULL) {
        error->message[0] = '\0';
    }
    if (options == NULL) {
        pt_default_options(&defaults);
        options = &defaults;
    }
    if (!tap_load(path, &tap, options->strict, error)) {
        return 0;
    }
    if (!locate_source_block(&tap,
                             name,
                             options,
                             &payload,
                             &payload_length,
                             &source_length,
                             &occurrence,
                             &local_report.warnings,
                             error)) {
        tap_free(&tap);
        return 0;
    }
    local_report.selected_occurrence = occurrence;
    if (!source_payload_validate(payload,
                                 payload_length,
                                 source_length,
                                 options,
                                 NULL,
                                 &local_report,
                                 error)) {
        tap_free(&tap);
        return 0;
    }
    tap_free(&tap);
    if (report != NULL) {
        *report = local_report;
    }
    return 1;
}

void pt_free(void *pointer)
{
    free(pointer);
}

const PtInstruction *pt_instruction_table(size_t *count)
{
    if (count != NULL) {
        *count = PT_ARRAY_COUNT(g_instructions);
    }
    return g_instructions;
}

int pt_decode_record_for_test(const uint8_t *record,
                              size_t available,
                              const char *const *symbols,
                              size_t symbol_count,
                              int strict,
                              PtDecodedRecord *decoded,
                              PtError *error)
{
    unsigned warnings = 0;
    if (error != NULL) {
        error->message[0] = '\0';
    }
    return decode_record(record,
                         available,
                         symbols,
                         symbol_count,
                         strict,
                         decoded,
                         &warnings,
                         error);
}

void pt_decoded_record_free(PtDecodedRecord *decoded)
{
    if (decoded == NULL) {
        return;
    }
    free(decoded->label);
    free(decoded->mnemonic);
    free(decoded->operands);
    free(decoded->comment);
    memset(decoded, 0, sizeof(*decoded));
}
