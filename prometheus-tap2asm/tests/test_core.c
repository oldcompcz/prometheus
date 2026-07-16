#include "promtap_internal.h"

#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef _WIN32
#include <direct.h>
#else
#include <sys/stat.h>
#include <sys/types.h>
#endif

typedef struct {
    uint8_t opcode;
    uint8_t prefix;
    uint8_t storage_class;
    const char *source_template;
} Case;

static const Case cases[] = {
#include "instruction_cases.inc"
};

static unsigned tests_run;
static unsigned tests_failed;

#define CHECK(condition, ...) do { \
    ++tests_run; \
    if (!(condition)) { \
        ++tests_failed; \
        fprintf(stderr, "FAIL %s:%d: ", __FILE__, __LINE__); \
        fprintf(stderr, __VA_ARGS__); \
        fputc('\n', stderr); \
    } \
} while (0)

typedef struct {
    uint8_t *data;
    size_t length;
    size_t capacity;
} Buffer;

static void die(const char *message)
{
    fprintf(stderr, "fatal test setup error: %s\n", message);
    exit(2);
}


static void make_directory(const char *path)
{
#ifdef _WIN32
    int result = _mkdir(path);
#else
    int result = mkdir(path, 0777);
#endif
    if (result != 0 && errno != EEXIST) {
        die("cannot create fixture directory");
    }
}

static void reserve(Buffer *buffer, size_t extra)
{
    size_t required = buffer->length + extra;
    if (required > buffer->capacity) {
        size_t capacity = buffer->capacity == 0 ? 256 : buffer->capacity;
        uint8_t *replacement;
        while (capacity < required) {
            capacity *= 2;
        }
        replacement = (uint8_t *)realloc(buffer->data, capacity);
        if (replacement == NULL) {
            die("out of memory");
        }
        buffer->data = replacement;
        buffer->capacity = capacity;
    }
}

static void append(Buffer *buffer, const void *data, size_t size)
{
    reserve(buffer, size);
    if (size != 0) {
        memcpy(buffer->data + buffer->length, data, size);
    }
    buffer->length += size;
}

static void append_u8(Buffer *buffer, uint8_t value)
{
    append(buffer, &value, 1);
}

static void append_le16(Buffer *buffer, uint16_t value)
{
    uint8_t bytes[2] = {(uint8_t)value, (uint8_t)(value >> 8)};
    append(buffer, bytes, 2);
}

static int contains_text(const unsigned char *data, size_t size, const char *needle)
{
    size_t needle_size = strlen(needle);
    size_t i;
    if (needle_size == 0) return 1;
    if (needle_size > size) return 0;
    for (i = 0; i <= size - needle_size; ++i) {
        if (memcmp(data + i, needle, needle_size) == 0) return 1;
    }
    return 0;
}

static char *dupstr(const char *s)
{
    size_t n = strlen(s);
    char *copy = (char *)malloc(n + 1);
    if (copy == NULL) {
        die("out of memory");
    }
    memcpy(copy, s, n + 1);
    return copy;
}

static char *replace_once_test(const char *source, const char *needle, const char *replacement)
{
    const char *match = strstr(source, needle);
    size_t prefix;
    size_t size;
    char *result;
    if (match == NULL) {
        die("test template lacks expected placeholder");
    }
    prefix = (size_t)(match - source);
    size = prefix + strlen(replacement) + strlen(match + strlen(needle));
    result = (char *)malloc(size + 1);
    if (result == NULL) {
        die("out of memory");
    }
    memcpy(result, source, prefix);
    memcpy(result + prefix, replacement, strlen(replacement));
    strcpy(result + prefix + strlen(replacement), match + strlen(needle));
    return result;
}

static char *iy_spelling_test(const char *source)
{
    Buffer b = {0};
    size_t i = 0;
    while (source[i]) {
        if (source[i] == 'i' && source[i + 1] == 'x') {
            append(&b, "iy", 2);
            i += 2;
        } else if (source[i] == 'h' && source[i + 1] == 'x') {
            append(&b, "hy", 2);
            i += 2;
        } else if (source[i] == 'l' && source[i + 1] == 'x') {
            append(&b, "ly", 2);
            i += 2;
        } else {
            append_u8(&b, (uint8_t)source[i++]);
        }
    }
    append_u8(&b, 0);
    return (char *)b.data;
}

static void split_expected(const char *line, char **mnemonic, char **operands)
{
    const char *space = strchr(line, ' ');
    if (space == NULL) {
        *mnemonic = dupstr(line);
        *operands = dupstr("");
    } else {
        size_t n = (size_t)(space - line);
        const char *rest = space;
        *mnemonic = (char *)malloc(n + 1);
        if (*mnemonic == NULL) die("out of memory");
        memcpy(*mnemonic, line, n);
        (*mnemonic)[n] = 0;
        while (*rest == ' ') ++rest;
        *operands = dupstr(rest);
    }
}

static size_t make_case_record(const Case *item, int iy, uint8_t record[128], char **expected_line)
{
    uint8_t prefix = item->prefix;
    uint8_t info;
    size_t length = 2;
    const char *payload1 = NULL;
    const char *payload2 = NULL;
    char *template_text;
    char *step = NULL;
    char *indexed = NULL;

    if (iy) {
        prefix = (uint8_t)((prefix & ~0x20U) | 0x10U);
    }
    info = (uint8_t)(prefix | item->storage_class);
    record[0] = item->opcode;
    record[1] = info;

    if (strcmp(item->source_template, "comment") == 0) {
        payload1 = ";exhaustive";
        *expected_line = dupstr(payload1);
    } else if (strcmp(item->source_template, "empty line") == 0) {
        *expected_line = dupstr("");
    } else {
        template_text = iy ? iy_spelling_test(item->source_template) : dupstr(item->source_template);
        switch (item->storage_class) {
            case 0:
                *expected_line = dupstr(template_text);
                break;
            case 1:
            case 2:
            case 3:
            case 6:
                payload1 = "123";
                *expected_line = replace_once_test(template_text, "N", payload1);
                break;
            case 4:
                payload1 = "5";
                indexed = dupstr(iy ? "(iy+5)" : "(ix+5)");
                *expected_line = replace_once_test(template_text, iy ? "(iy+d)" : "(ix+d)", indexed);
                break;
            case 5:
                payload1 = "-3";
                payload2 = "42";
                indexed = dupstr(iy ? "(iy-3)" : "(ix-3)");
                step = replace_once_test(template_text, iy ? "(iy+d)" : "(ix+d)", indexed);
                *expected_line = replace_once_test(step, "N", payload2);
                break;
            case 7:
                if (strcmp(template_text, "defm") == 0) payload1 = "\"Hi\"";
                else if (strcmp(template_text, "defb") == 0 || strcmp(template_text, "defw") == 0) payload1 = "1,2,#FF";
                else if (strcmp(template_text, "defs") == 0) payload1 = "16";
                else payload1 = "123";
                if (strncmp(template_text, "def", 3) == 0) {
                    size_t n = strlen(template_text) + 1 + strlen(payload1);
                    *expected_line = (char *)malloc(n + 1);
                    if (*expected_line == NULL) die("out of memory");
                    snprintf(*expected_line, n + 1, "%s %s", template_text, payload1);
                } else {
                    *expected_line = replace_once_test(template_text, "N", payload1);
                }
                break;
            default:
                die("unexpected storage class");
        }
        free(template_text);
    }

    if (payload1 != NULL) {
        size_t n = strlen(payload1);
        memcpy(record + length, payload1, n);
        length += n;
    }
    if (payload2 != NULL) {
        record[length++] = 0x1f;
        memcpy(record + length, payload2, strlen(payload2));
        length += strlen(payload2);
    }
    if (!(item->storage_class == 0 && payload1 == NULL)) {
        size_t payload_length = length - 2;
        if (payload_length > 63) die("test record too large");
        record[length++] = (uint8_t)(0xc0U + payload_length);
    }
    free(step);
    free(indexed);
    return length;
}

static void test_instruction_table_exhaustive(void)
{
    size_t i;
    size_t iy_cases = 0;
    for (i = 0; i < sizeof(cases) / sizeof(cases[0]); ++i) {
        int variants = ((cases[i].prefix & 0x20U) != 0 && (cases[i].prefix & 0x10U) == 0) ? 2 : 1;
        int variant;
        for (variant = 0; variant < variants; ++variant) {
            uint8_t record[128];
            size_t record_size;
            char *expected_line;
            char *expected_mnemonic = NULL;
            char *expected_operands = NULL;
            PtDecodedRecord decoded;
            PtError error = {{0}};
            int ok;
            record_size = make_case_record(&cases[i], variant == 1, record, &expected_line);
            ok = pt_decode_record_for_test(record, record_size, NULL, 0, 1, &decoded, &error);
            CHECK(ok, "case %zu (%02x/%02x '%s') failed: %s",
                  i, cases[i].opcode, cases[i].prefix, cases[i].source_template, error.message);
            if (ok) {
                if (strcmp(cases[i].source_template, "comment") == 0) {
                    CHECK(decoded.comment != NULL && strcmp(decoded.comment, expected_line) == 0,
                          "comment case %zu mismatch", i);
                } else if (strcmp(cases[i].source_template, "empty line") == 0) {
                    CHECK(decoded.blank, "empty-line case %zu not marked blank", i);
                } else {
                    split_expected(expected_line, &expected_mnemonic, &expected_operands);
                    CHECK(decoded.mnemonic != NULL && strcmp(decoded.mnemonic, expected_mnemonic) == 0,
                          "case %zu mnemonic expected '%s' got '%s'", i, expected_mnemonic,
                          decoded.mnemonic == NULL ? "<null>" : decoded.mnemonic);
                    CHECK(decoded.operands != NULL && strcmp(decoded.operands, expected_operands) == 0,
                          "case %zu operands expected '%s' got '%s'", i, expected_operands,
                          decoded.operands == NULL ? "<null>" : decoded.operands);
                }
                CHECK(decoded.bytes_consumed == record_size,
                      "case %zu consumed %zu of %zu bytes", i, decoded.bytes_consumed, record_size);
                pt_decoded_record_free(&decoded);
            }
            free(expected_mnemonic);
            free(expected_operands);
            free(expected_line);
            if (variant == 1) ++iy_cases;
        }
    }
    CHECK(sizeof(cases) / sizeof(cases[0]) == 686, "instruction case count changed");
    CHECK(iy_cases == 117, "expected 117 IY-normalization variants, got %zu", iy_cases);
}

static const Case *find_case(const char *template_text)
{
    size_t i;
    for (i = 0; i < sizeof(cases) / sizeof(cases[0]); ++i) {
        if (strcmp(cases[i].source_template, template_text) == 0) return &cases[i];
    }
    die("required instruction template not found");
    return NULL;
}

static void append_record(Buffer *source,
                          const Case *item,
                          uint8_t prefix,
                          int label_ordinal,
                          const uint8_t *payload,
                          size_t payload_length)
{
    uint8_t info = (uint8_t)(prefix | item->storage_class | (label_ordinal ? 0x08 : 0));
    size_t variable = (label_ordinal ? 2 : 0) + payload_length;
    append_u8(source, item->opcode);
    append_u8(source, info);
    if (label_ordinal) {
        append_u8(source, (uint8_t)(0x80U | ((unsigned)label_ordinal >> 8)));
        append_u8(source, (uint8_t)label_ordinal);
    }
    append(source, payload, payload_length);
    if (!(item->storage_class == 0 && variable == 0)) {
        append_u8(source, (uint8_t)(0xc0U + variable));
    }
}

static Buffer build_symbol_table(void)
{
    Buffer table = {0};
    const uint8_t start_name[] = {'S','T','A','R',(uint8_t)('T' | 0x80)};
    const uint8_t value_name[] = {'V','A','L','U',(uint8_t)('E' | 0x80)};
    append_le16(&table, 2);
    append_le16(&table, 0);
    append_le16(&table, 7);
    append_le16(&table, 0x8000);
    append(&table, start_name, sizeof(start_name));
    append_le16(&table, 0x1234);
    append(&table, value_name, sizeof(value_name));
    return table;
}

static void append_tap_block(Buffer *tap, uint8_t flag, const uint8_t *payload, size_t payload_length)
{
    uint8_t checksum = flag;
    size_t i;
    if (payload_length + 2 > 65535) die("TAP block too large");
    append_le16(tap, (uint16_t)(payload_length + 2));
    append_u8(tap, flag);
    append(tap, payload, payload_length);
    for (i = 0; i < payload_length; ++i) checksum ^= payload[i];
    append_u8(tap, checksum);
}

static void append_source_file(Buffer *tap, const char *name, const Buffer *source, const Buffer *symbols)
{
    Buffer payload = {0};
    uint8_t header[17] = {0};
    size_t name_length = strlen(name);
    uint16_t total;
    if (name_length > 10) die("name too long");
    append(&payload, source->data, source->length);
    append_u8(&payload, 0);
    append_u8(&payload, 0);
    append(&payload, symbols->data, symbols->length);
    if (payload.length > 65535 || source->length > 65535) die("fixture too large");
    total = (uint16_t)payload.length;
    header[0] = 3;
    memset(header + 1, ' ', 10);
    memcpy(header + 1, name, name_length);
    header[11] = (uint8_t)total;
    header[12] = (uint8_t)(total >> 8);
    header[13] = 0x00;
    header[14] = 0x80;
    header[15] = (uint8_t)source->length;
    header[16] = (uint8_t)(source->length >> 8);
    append_tap_block(tap, 0x00, header, sizeof(header));
    append_tap_block(tap, 0xff, payload.data, payload.length);
    free(payload.data);
}

static void write_bytes(const char *path, const uint8_t *data, size_t size)
{
    FILE *file = fopen(path, "wb");
    if (file == NULL) die("cannot create fixture");
    if (fwrite(data, 1, size, file) != size) die("cannot write fixture");
    fclose(file);
}


typedef struct {
    Buffer image;
    unsigned next_entry;
    unsigned next_sector;
} TrdBuilder;

static void trd_builder_init(TrdBuilder *builder)
{
    size_t image_size = 40U * 16U * 256U;
    reserve(&builder->image, image_size);
    memset(builder->image.data, 0, image_size);
    builder->image.length = image_size;
    builder->next_entry = 0;
    builder->next_sector = 16;
}

static void trd_builder_add(TrdBuilder *builder,
                            const char *name,
                            uint8_t type,
                            uint16_t parameter,
                            const uint8_t *data,
                            size_t length)
{
    uint8_t *entry;
    size_t name_length = strlen(name);
    unsigned sectors = (unsigned)((length + 255U) / 256U);
    unsigned start_sector = builder->next_sector % 16U;
    unsigned start_track = builder->next_sector / 16U;
    size_t data_offset = (size_t)builder->next_sector * 256U;
    if (name_length == 0 || name_length > 8) die("invalid TRD fixture name");
    if (builder->next_entry >= 128 || sectors > 255) die("TRD fixture full");
    if (data_offset + length > builder->image.length) die("TRD fixture data overflow");
    entry = builder->image.data + builder->next_entry * 16U;
    memset(entry, ' ', 8);
    memcpy(entry, name, name_length);
    entry[8] = type;
    entry[9] = (uint8_t)parameter;
    entry[10] = (uint8_t)(parameter >> 8);
    entry[11] = (uint8_t)length;
    entry[12] = (uint8_t)(length >> 8);
    entry[13] = (uint8_t)sectors;
    entry[14] = (uint8_t)start_sector;
    entry[15] = (uint8_t)start_track;
    if (length != 0) memcpy(builder->image.data + data_offset, data, length);
    builder->next_sector += sectors;
    ++builder->next_entry;
}

static void trd_builder_write(TrdBuilder *builder, const char *path)
{
    write_bytes(path, builder->image.data, builder->image.length);
    free(builder->image.data);
    memset(builder, 0, sizeof(*builder));
}

static void trd_builder_write_partial(TrdBuilder *builder, const char *path)
{
    size_t used = (size_t)builder->next_sector * 256U;
    if (used < 9U * 256U) used = 9U * 256U;
    write_bytes(path, builder->image.data, used);
    free(builder->image.data);
    memset(builder, 0, sizeof(*builder));
}

static Buffer build_basic_source(void)
{
    Buffer source = {0};
    const Case *comment = find_case("comment");
    const Case *empty = find_case("empty line");
    const Case *ld_imm = find_case("ld a,N");
    const Case *ld_index = find_case("ld a,(ix+d)");
    const Case *defb = find_case("defb");
    const uint8_t comment_text[] = "; hello";
    const uint8_t expression[] = {0x80, 0x02, '+', '1'};
    const uint8_t displacement[] = {'-', '2'};
    const uint8_t bytes[] = "1,2,#FF";
    append_record(&source, comment, comment->prefix, 0, comment_text, sizeof(comment_text) - 1);
    append_record(&source, empty, empty->prefix, 1, NULL, 0);
    append_record(&source, ld_imm, ld_imm->prefix, 0, expression, sizeof(expression));
    append_record(&source, ld_index, (uint8_t)((ld_index->prefix & ~0x20U) | 0x10U), 0, displacement, sizeof(displacement));
    append_record(&source, defb, defb->prefix, 0, bytes, sizeof(bytes) - 1);
    return source;
}

static Buffer build_formatting_source(void)
{
    Buffer source = {0};
    const Case *comment = find_case("comment");
    const Case *ld = find_case("ld a,N");
    const Case *defb = find_case("defb");
    const Case *defw = find_case("defw");
    const Case *defm = find_case("defm");
    const Case *defs = find_case("defs");
    const Case *ent = find_case("ent N");
    const Case *equ = find_case("equ N");
    const Case *org = find_case("org N");
    const Case *put = find_case("put N");
    const uint8_t comment_text[] = "; format";
    const uint8_t expression[] = "#Af+%1010";
    const uint8_t bytes[] = "#ff,%0011";
    const uint8_t words[] = "#1234";
    const uint8_t message[] = "\"#No%,\",#41";
    const uint8_t reserve[] = "%100";
    const uint8_t entry[] = "#8000";
    const uint8_t equal[] = "%10";
    const uint8_t origin[] = "#9000";
    const uint8_t output[] = "%1";

    append_record(&source, comment, comment->prefix, 0, comment_text, sizeof(comment_text) - 1);
    append_record(&source, ld, ld->prefix, 1, expression, sizeof(expression) - 1);
    append_record(&source, defb, defb->prefix, 0, bytes, sizeof(bytes) - 1);
    append_record(&source, defw, defw->prefix, 0, words, sizeof(words) - 1);
    append_record(&source, defm, defm->prefix, 0, message, sizeof(message) - 1);
    append_record(&source, defs, defs->prefix, 0, reserve, sizeof(reserve) - 1);
    append_record(&source, ent, ent->prefix, 0, entry, sizeof(entry) - 1);
    append_record(&source, equ, equ->prefix, 0, equal, sizeof(equal) - 1);
    append_record(&source, org, org->prefix, 0, origin, sizeof(origin) - 1);
    append_record(&source, put, put->prefix, 0, output, sizeof(output) - 1);
    return source;
}

static void create_fixtures(void)
{
    Buffer source = build_basic_source();
    Buffer formatting_source = build_formatting_source();
    Buffer symbols = build_symbol_table();
    Buffer tap = {0};
    Buffer formatting_tap = {0};
    Buffer duplicate = {0};
    Buffer second_source = {0};
    Buffer broken_source = {0};
    Buffer broken_tap = {0};
    Buffer empty_symbols = {0};
    const Case *comment = find_case("comment");
    const Case *ld_imm = find_case("ld a,N");
    const uint8_t second[] = "; second";
    const uint8_t broken_comment[] = "; before damage";
    TrdBuilder trd = {0};
    TrdBuilder duplicate_trd = {0};
    TrdBuilder duplicate_source_trd = {0};
    TrdBuilder partial_trd = {0};
    TrdBuilder wrapped_trd = {0};
    TrdBuilder bad_trd = {0};
    Buffer wrapped_source = {0};
    Buffer wrapped_symbols = {0};

    make_directory("build");
    make_directory("build/test-fixtures");
    append_source_file(&tap, "file", &source, &symbols);
    write_bytes("build/test-fixtures/basic.tap", tap.data, tap.length);
    append_source_file(&formatting_tap, "format", &formatting_source, &symbols);
    write_bytes("build/test-fixtures/formatting.tap", formatting_tap.data, formatting_tap.length);

    append_source_file(&duplicate, "file", &source, &symbols);
    append_record(&second_source, comment, comment->prefix, 0, second, sizeof(second) - 1);
    append_le16(&empty_symbols, 0);
    append_source_file(&duplicate, "file", &second_source, &empty_symbols);
    append_record(&broken_source, comment, comment->prefix, 0,
                  broken_comment, sizeof(broken_comment) - 1);
    append_u8(&broken_source, ld_imm->opcode);
    append_u8(&broken_source, (uint8_t)(ld_imm->prefix | ld_imm->storage_class));
    append_u8(&broken_source, '1');
    append_source_file(&broken_tap, "broken", &broken_source, &empty_symbols);
    write_bytes("build/test-fixtures/broken.tap", broken_tap.data, broken_tap.length);
    write_bytes("build/test-fixtures/duplicate.tap", duplicate.data, duplicate.length);

    if (tap.length < 1) die("empty TAP fixture");
    tap.data[tap.length - 1] ^= 0x01;
    write_bytes("build/test-fixtures/bad-checksum.tap", tap.data, tap.length);

    trd_builder_init(&trd);
    trd_builder_add(&trd, "SOURCE", 'C', 0x8000, source.data, source.length);
    trd_builder_add(&trd, "SYMBOL", 'S', 0, symbols.data, symbols.length);
    trd_builder_add(&trd, "NOTES", 'T', 0, (const uint8_t *)"not prometheus", 14);
    trd_builder_write(&trd, "build/test-fixtures/basic.trd");

    trd_builder_init(&duplicate_trd);
    trd_builder_add(&duplicate_trd, "SOURCE", 'C', 0x8000, source.data, source.length);
    trd_builder_add(&duplicate_trd, "SYMBOL", 'S', 0, symbols.data, symbols.length);
    trd_builder_add(&duplicate_trd, "SYMBOL", 'S', 0, symbols.data, symbols.length);
    trd_builder_write(&duplicate_trd, "build/test-fixtures/duplicate-symbols.trd");

    trd_builder_init(&duplicate_source_trd);
    trd_builder_add(&duplicate_source_trd, "SOURCE", 'C', 0x8000, source.data, source.length);
    trd_builder_add(&duplicate_source_trd, "SOURCE", 'C', 0x8100, second_source.data, second_source.length);
    trd_builder_add(&duplicate_source_trd, "SYMONE", 'S', 0, symbols.data, symbols.length);
    trd_builder_add(&duplicate_source_trd, "SYMTWO", 'S', 0, empty_symbols.data, empty_symbols.length);
    trd_builder_write(&duplicate_source_trd, "build/test-fixtures/duplicate-sources.trd");

    trd_builder_init(&partial_trd);
    trd_builder_add(&partial_trd, "SOURCE", 'C', 0x8000, source.data, source.length);
    trd_builder_add(&partial_trd, "SYMBOL", 'S', 0, symbols.data, symbols.length);
    trd_builder_write_partial(&partial_trd, "build/test-fixtures/partial.trd");

    append_u8(&wrapped_source, 0xaa);
    append_u8(&wrapped_source, 0x55);
    append(&wrapped_source, source.data, source.length);
    append_u8(&wrapped_source, 0xee);
    append_u8(&wrapped_symbols, 0x11);
    append_u8(&wrapped_symbols, 0x22);
    append_u8(&wrapped_symbols, 0x33);
    append(&wrapped_symbols, symbols.data, symbols.length);
    trd_builder_init(&wrapped_trd);
    trd_builder_add(&wrapped_trd, "WRAPSRC", 'C', 0x8000, wrapped_source.data, wrapped_source.length);
    trd_builder_add(&wrapped_trd, "WRAPSYM", 'S', 0, wrapped_symbols.data, wrapped_symbols.length);
    trd_builder_write(&wrapped_trd, "build/test-fixtures/wrapped.trd");

    trd_builder_init(&bad_trd);
    trd_builder_add(&bad_trd, "SOURCE", 'C', 0x8000, source.data, source.length);
    trd_builder_add(&bad_trd, "SYMBOL", 'S', 0, symbols.data, symbols.length);
    bad_trd.image.data[13] = 0;
    trd_builder_write(&bad_trd, "build/test-fixtures/bad-directory.trd");

    free(wrapped_source.data);
    free(wrapped_symbols.data);
    free(source.data);
    free(formatting_source.data);
    free(symbols.data);
    free(tap.data);
    free(formatting_tap.data);
    free(duplicate.data);
    free(second_source.data);
    free(broken_source.data);
    free(broken_tap.data);
    free(empty_symbols.data);
}

static void test_end_to_end(void)
{
    PtConvertOptions options;
    PtConvertReport report;
    PtError error = {{0}};
    unsigned char *output = NULL;
    size_t output_size = 0;
    const char expected[] =
        "; hello\n"
        "START\n"
        "    ld a,VALUE+1\n"
        "    ld a,(iy-2)\n"
        "    defb 1,2,#FF\n";

    create_fixtures();
    pt_default_options(&options);
    options.format = PT_FORMAT_COMPACT;
    CHECK(pt_convert_tap_file("build/test-fixtures/basic.tap", "file", &options,
                              &output, &output_size, &report, &error),
          "end-to-end conversion failed: %s", error.message);
    if (output != NULL) {
        CHECK(output_size == sizeof(expected) - 1,
              "end-to-end size expected %zu got %zu", sizeof(expected) - 1, output_size);
        CHECK(output_size == sizeof(expected) - 1 && memcmp(output, expected, output_size) == 0,
              "end-to-end output mismatch");
        pt_free(output);
    }
    CHECK(report.records == 5, "expected 5 records, got %u", report.records);
    CHECK(report.warnings == 0, "unexpected warnings: %u", report.warnings);

    pt_default_options(&options);
    options.format = PT_FORMAT_COMPACT;
    options.ignore_case = 1;
    CHECK(pt_validate_tap_file("build/test-fixtures/basic.tap", "FILE", &options, &report, &error),
          "ignore-case validation failed: %s", error.message);

    pt_default_options(&options);
    options.format = PT_FORMAT_COMPACT;
    options.occurrence = 1;
    output = NULL;
    output_size = 0;
    CHECK(pt_convert_tap_file("build/test-fixtures/duplicate.tap", "file", &options,
                              &output, &output_size, &report, &error),
          "duplicate occurrence conversion failed: %s", error.message);
    if (output != NULL) {
        CHECK(output_size == strlen("; second\n") && memcmp(output, "; second\n", output_size) == 0,
              "duplicate occurrence selected wrong block");
        pt_free(output);
    }

    pt_default_options(&options);
    CHECK(!pt_validate_tap_file("build/test-fixtures/bad-checksum.tap", "file", &options, &report, &error),
          "strict validation accepted bad checksum");
    options.strict = 0;
    CHECK(pt_validate_tap_file("build/test-fixtures/bad-checksum.tap", "file", &options, &report, &error),
          "salvage validation rejected checksum-only damage: %s", error.message);
}


static void test_trdos_end_to_end(void)
{
    PtConvertOptions options;
    PtConvertReport report;
    PtError error = {{0}};
    unsigned char *output = NULL;
    size_t output_size = 0;
    Buffer source_shape = build_basic_source();
    const char expected[] =
        "; hello\n"
        "START\n"
        "    ld a,VALUE+1\n"
        "    ld a,(iy-2)\n"
        "    defb 1,2,#FF\n";
    FILE *listing;
    char list_text[2048];
    size_t list_size;

    pt_default_options(&options);
    options.format = PT_FORMAT_COMPACT;
    CHECK(pt_convert_trd_file("build/test-fixtures/basic.trd",
                              "SOURCE.C",
                              NULL,
                              &options,
                              &output,
                              &output_size,
                              &report,
                              &error),
          "TR-DOS auto-pair conversion failed: %s", error.message);
    if (output != NULL) {
        CHECK(output_size == sizeof(expected) - 1 && memcmp(output, expected, output_size) == 0,
              "TR-DOS auto-pair output mismatch");
        pt_free(output);
        output = NULL;
    }
    CHECK(report.records == 5, "TR-DOS expected 5 records, got %u", report.records);
    CHECK(report.warnings == 0, "TR-DOS unexpected warnings: %u", report.warnings);

    CHECK(pt_convert_file("build/test-fixtures/basic.trd",
                          "SOURCE",
                          "SYMBOL.S",
                          &options,
                          &output,
                          &output_size,
                          &report,
                          &error),
          "generic TR-DOS conversion failed: %s", error.message);
    if (output != NULL) {
        CHECK(output_size == sizeof(expected) - 1 && memcmp(output, expected, output_size) == 0,
              "generic TR-DOS output mismatch");
        pt_free(output);
        output = NULL;
    }

    options.ignore_case = 1;
    CHECK(pt_validate_trd_file("build/test-fixtures/basic.trd",
                               "source.c",
                               "symbol.s",
                               &options,
                               &report,
                               &error),
          "TR-DOS ignore-case validation failed: %s", error.message);

    pt_default_options(&options);
    options.format = PT_FORMAT_COMPACT;
    CHECK(!pt_validate_trd_file("build/test-fixtures/duplicate-symbols.trd",
                                "SOURCE.C",
                                NULL,
                                &options,
                                &report,
                                &error),
          "TR-DOS auto-pair accepted ambiguous symbol files");
    options.symbol_occurrence = 1;
    CHECK(pt_validate_trd_file("build/test-fixtures/duplicate-symbols.trd",
                               "SOURCE.C",
                               "SYMBOL.S",
                               &options,
                               &report,
                               &error),
          "TR-DOS explicit duplicate symbol occurrence failed: %s", error.message);
    CHECK(report.selected_symbol_occurrence == 1,
          "TR-DOS selected symbol occurrence expected 1 got %u",
          report.selected_symbol_occurrence);

    pt_default_options(&options);
    options.format = PT_FORMAT_COMPACT;
    options.source_offset = 2;
    options.source_length = source_shape.length;
    options.symbols_offset = 3;
    CHECK(pt_convert_trd_file("build/test-fixtures/wrapped.trd",
                              "WRAPSRC.C",
                              "WRAPSYM.S",
                              &options,
                              &output,
                              &output_size,
                              &report,
                              &error),
          "TR-DOS wrapped split conversion failed: %s", error.message);
    if (output != NULL) {
        CHECK(output_size == sizeof(expected) - 1 && memcmp(output, expected, output_size) == 0,
              "TR-DOS wrapped output mismatch");
        pt_free(output);
        output = NULL;
    }
    pt_default_options(&options);
    options.format = PT_FORMAT_COMPACT;
    options.occurrence = 1;
    CHECK(pt_convert_trd_file("build/test-fixtures/duplicate-sources.trd",
                              "SOURCE.C",
                              "SYMTWO.S",
                              &options,
                              &output,
                              &output_size,
                              &report,
                              &error),
          "TR-DOS duplicate source occurrence failed: %s", error.message);
    if (output != NULL) {
        CHECK(output_size == strlen("; second\n") && memcmp(output, "; second\n", output_size) == 0,
              "TR-DOS source occurrence selected wrong file");
        pt_free(output);
        output = NULL;
    }
    CHECK(report.selected_occurrence == 1,
          "TR-DOS selected source occurrence expected 1 got %u",
          report.selected_occurrence);

    pt_default_options(&options);
    CHECK(pt_validate_trd_file("build/test-fixtures/partial.trd",
                               "SOURCE.C",
                               "SYMBOL.S",
                               &options,
                               &report,
                               &error),
          "valid partial TRD image rejected: %s", error.message);

    pt_default_options(&options);
    options.format = PT_FORMAT_COMPACT;
    options.source_offset = 2;
    options.source_length = source_shape.length + 1000;
    options.symbols_offset = 3;
    CHECK(!pt_validate_trd_file("build/test-fixtures/wrapped.trd",
                                "WRAPSRC.C",
                                "WRAPSYM.S",
                                &options,
                                &report,
                                &error),
          "TR-DOS accepted source range beyond file");

    pt_default_options(&options);
    CHECK(!pt_validate_trd_file("build/test-fixtures/bad-directory.trd",
                                "SOURCE.C",
                                "SYMBOL.S",
                                &options,
                                &report,
                                &error),
          "TR-DOS strict mode accepted directory length beyond allocation");

    listing = tmpfile();
    if (listing == NULL) die("cannot create salvage-listing temporary file");
    CHECK(pt_list_trd_file("build/test-fixtures/bad-directory.trd", listing, 0, &error),
          "TR-DOS salvage listing rejected recoverable directory damage: %s", error.message);
    rewind(listing);
    list_size = fread(list_text, 1, sizeof(list_text) - 1, listing);
    list_text[list_size] = '\0';
    CHECK(strstr(list_text, "warning(s) ignored") != NULL,
          "TR-DOS salvage listing did not report warning: %s", list_text);
    fclose(listing);

    listing = tmpfile();
    if (listing == NULL) die("cannot create listing temporary file");
    CHECK(pt_list_trd_file("build/test-fixtures/basic.trd", listing, 1, &error),
          "TR-DOS listing failed: %s", error.message);
    rewind(listing);
    list_size = fread(list_text, 1, sizeof(list_text) - 1, listing);
    list_text[list_size] = '\0';
    CHECK(strstr(list_text, "SOURCE.C") != NULL, "TR-DOS listing lacks source file");
    CHECK(strstr(list_text, "source -> SYMBOL.S (5 lines)") != NULL,
          "TR-DOS listing lacks source/symbol detection: %s", list_text);
    fclose(listing);

    pt_default_options(&options);
    options.source_offset = 1;
    CHECK(!pt_validate_file("build/test-fixtures/basic.tap",
                            "file",
                            NULL,
                            &options,
                            &report,
                            &error),
          "generic TAP API accepted TR-DOS-only source offset");

    free(source_shape.data);
}

static void test_output_customization(void)
{
    Buffer source = build_formatting_source();
    Buffer symbols = build_symbol_table();
    PtConvertOptions options;
    PtConvertReport report;
    PtError error = {{0}};
    unsigned char *output = NULL;
    size_t output_size = 0;
    const char expected_tabs[] =
        "; format\n"
        "START\t\tld\ta,$AF+0B1010\n"
        "\t\tdb\t$FF,0B0011\n"
        "\t\tdw\t$1234\n"
        "\t\tdb\t\"#No%,\",$41\n"
        "\t\tds\t0B100\n"
        "\t\tENTRY\t$8000\n"
        "\t\tEQUAL\t0B10\n"
        "\t\tORIGIN\t$9000\n"
        "\t\tOUTPUT\t0B1\n";
    const char expected_suffix[] =
        "START  ld a,0AFH+1010B\n"
        "  db 0FFH,0011B\n"
        "  dw 1234H\n"
        "  db \"#No%,\",41H\n"
        "  ds 100B\n"
        "  ent 8000H\n"
        "  equ 10B\n"
        "  org 9000H\n"
        "  put 1B\n";

    pt_default_options(&options);
    options.format = PT_FORMAT_SEPARATED;
    options.indent_character = PT_INDENT_TAB;
    options.instruction_indent = 2;
    options.label_separator = 2;
    options.operand_separator = 1;
    options.hex_style = PT_HEX_DOLLAR;
    options.binary_style = PT_BINARY_0B;
    options.number_case = PT_NUMBER_CASE_UPPER;
    pt_set_db_directives(&options.directives);
    (void)snprintf(options.directives.ent, sizeof(options.directives.ent), "%s", "ENTRY");
    (void)snprintf(options.directives.equ, sizeof(options.directives.equ), "%s", "EQUAL");
    (void)snprintf(options.directives.org, sizeof(options.directives.org), "%s", "ORIGIN");
    (void)snprintf(options.directives.put, sizeof(options.directives.put), "%s", "OUTPUT");
    CHECK(pt_convert_split_buffers(source.data, source.length,
                                   symbols.data, symbols.length,
                                   &options, &output, &output_size, &report, &error),
          "custom tab/dialect conversion failed: %s", error.message);
    if (output != NULL) {
        CHECK(output_size == sizeof(expected_tabs) - 1
              && memcmp(output, expected_tabs, output_size) == 0,
              "custom tab/dialect output mismatch:\n%.*s", (int)output_size, output);
        pt_free(output);
        output = NULL;
    }
    CHECK(report.records == 10, "custom output expected 10 records, got %u", report.records);

    pt_default_options(&options);
    options.format = PT_FORMAT_SEPARATED;
    options.indent_character = PT_INDENT_SPACE;
    options.instruction_indent = 2;
    options.label_separator = 2;
    options.operand_separator = 1;
    options.hex_style = PT_HEX_SUFFIX_H;
    options.binary_style = PT_BINARY_SUFFIX_B;
    options.number_case = PT_NUMBER_CASE_UPPER;
    options.comment_flags = 0;
    pt_set_db_directives(&options.directives);
    CHECK(pt_convert_split_buffers(source.data, source.length,
                                   symbols.data, symbols.length,
                                   &options, &output, &output_size, &report, &error),
          "suffix/comment filtering conversion failed: %s", error.message);
    if (output != NULL) {
        CHECK(output_size == sizeof(expected_suffix) - 1
              && memcmp(output, expected_suffix, output_size) == 0,
              "suffix/comment filtering mismatch:\n%.*s", (int)output_size, output);
        pt_free(output);
        output = NULL;
    }

    {
        const Case *comment = find_case("comment");
        const Case *ld = find_case("ld a,N");
        Buffer broken = {0};
        Buffer empty_symbols = {0};
        const uint8_t source_comment[] = "; kept source";
        uint8_t malformed[3];
        const char source_only[] = "; kept source\n";
        append_record(&broken, comment, comment->prefix, 0,
                      source_comment, sizeof(source_comment) - 1);
        malformed[0] = ld->opcode;
        malformed[1] = (uint8_t)(ld->prefix | ld->storage_class);
        malformed[2] = '1';
        append(&broken, malformed, sizeof(malformed));
        append_le16(&empty_symbols, 0);

        pt_default_options(&options);
        options.strict = 0;
        options.format = PT_FORMAT_COMPACT;
        options.comment_flags = PT_COMMENT_SOURCE;
        CHECK(pt_convert_split_buffers(broken.data, broken.length,
                                       empty_symbols.data, empty_symbols.length,
                                       &options, &output, &output_size, &report, &error),
              "source-only salvage comments failed: %s", error.message);
        if (output != NULL) {
            CHECK(output_size == sizeof(source_only) - 1
                  && memcmp(output, source_only, output_size) == 0,
                  "generated salvage comment was not suppressed");
            pt_free(output);
            output = NULL;
        }

        options.comment_flags = PT_COMMENT_GENERATED;
        CHECK(pt_convert_split_buffers(broken.data, broken.length,
                                       empty_symbols.data, empty_symbols.length,
                                       &options, &output, &output_size, &report, &error),
              "generated-only salvage comments failed: %s", error.message);
        if (output != NULL) {
            CHECK(contains_text(output, output_size, "prometheus-tap2asm: stopped"),
                  "generated diagnostic missing");
            CHECK(!contains_text(output, output_size, "kept source"),
                  "source comment was not suppressed");
            pt_free(output);
            output = NULL;
        }
        free(broken.data);
        free(empty_symbols.data);
    }

    free(source.data);
    free(symbols.data);
}

static void test_invalid_output_options(void)
{
    uint8_t empty_symbols[] = {0, 0};
    PtConvertOptions options;
    PtConvertReport report;
    PtError error = {{0}};

#define INVALID_OPTION(change, description) do { \
    pt_default_options(&options); \
    change; \
    CHECK(!pt_validate_split_buffers(NULL, 0, empty_symbols, sizeof(empty_symbols), \
                                     &options, &report, &error), \
          "accepted invalid output option: %s", description); \
} while (0)

    INVALID_OPTION(options.format = (PtFormat)99, "format");
    INVALID_OPTION(options.line_endings = (PtLineEndings)99, "line endings");
    INVALID_OPTION(options.indent_character = (PtIndentCharacter)99, "indent character");
    INVALID_OPTION(options.instruction_indent = 1025, "instruction indent");
    INVALID_OPTION(options.label_separator = 1025, "label separator");
    INVALID_OPTION(options.operand_separator = 1025, "operand separator");
    INVALID_OPTION(options.hex_style = (PtHexStyle)99, "hex style");
    INVALID_OPTION(options.binary_style = (PtBinaryStyle)99, "binary style");
    INVALID_OPTION(options.number_case = (PtNumberCase)99, "number case");
    INVALID_OPTION(options.comment_flags = 0x80, "comment flags");
    INVALID_OPTION(options.directives.defb[0] = '\0', "empty directive name");
    INVALID_OPTION(memset(options.directives.defb, 'x', sizeof(options.directives.defb)),
                   "unterminated directive name");
#undef INVALID_OPTION
}

static void test_malformed_records(void)
{
    const Case *ld = find_case("ld a,N");
    uint8_t missing_marker[] = {ld->opcode, (uint8_t)(ld->prefix | ld->storage_class), '1'};
    uint8_t bad_marker[] = {ld->opcode, (uint8_t)(ld->prefix | ld->storage_class), '1', 0xc0};
    uint8_t missing_symbol[] = {ld->opcode, (uint8_t)(ld->prefix | ld->storage_class), 0x80, 0x01, 0xc2};
    PtDecodedRecord decoded;
    PtError error = {{0}};
    CHECK(!pt_decode_record_for_test(missing_marker, sizeof(missing_marker), NULL, 0, 1, &decoded, &error),
          "accepted missing terminal marker");
    CHECK(!pt_decode_record_for_test(bad_marker, sizeof(bad_marker), NULL, 0, 1, &decoded, &error),
          "accepted inconsistent terminal marker");
    CHECK(!pt_decode_record_for_test(missing_symbol, sizeof(missing_symbol), NULL, 0, 1, &decoded, &error),
          "accepted missing symbol ordinal in strict mode");
    CHECK(pt_decode_record_for_test(missing_symbol, sizeof(missing_symbol), NULL, 0, 0, &decoded, &error),
          "salvage mode rejected missing symbol: %s", error.message);
    if (decoded.mnemonic != NULL) {
        CHECK(strcmp(decoded.operands, "a,<SYM#1>") == 0,
              "salvage symbol placeholder mismatch: '%s'", decoded.operands);
        pt_decoded_record_free(&decoded);
    }
}

int main(void)
{
    test_instruction_table_exhaustive();
    test_end_to_end();
    test_trdos_end_to_end();
    test_output_customization();
    test_invalid_output_options();
    test_malformed_records();
    if (tests_failed != 0) {
        fprintf(stderr, "%u/%u checks failed\n", tests_failed, tests_run);
        return 1;
    }
    printf("all %u checks passed (686 instruction records + 117 IY variants)\n", tests_run);
    return 0;
}
