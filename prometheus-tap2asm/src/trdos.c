#include "promtap_internal.h"

#include <ctype.h>
#include <errno.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TRD_SECTOR_SIZE 256U
#define TRD_SECTORS_PER_TRACK 16U
#define TRD_DIRECTORY_BYTES (8U * TRD_SECTOR_SIZE)
#define TRD_MINIMUM_BYTES (9U * TRD_SECTOR_SIZE)
#define TRD_MAX_ENTRIES 128U

typedef struct {
    uint8_t raw[16];
    unsigned directory_index;
    char name[9];
    uint8_t type;
    uint16_t parameter;
    size_t length;
    uint8_t sectors;
    uint8_t start_sector;
    uint8_t start_track;
    size_t data_offset;
    const uint8_t *data;
} TrdEntry;

typedef struct {
    uint8_t *bytes;
    size_t length;
    TrdEntry *entries;
    size_t count;
    unsigned warnings;
} TrdImage;

typedef struct {
    uint8_t name[8];
    int has_type;
    uint8_t type;
} TrdSelector;

static void trd_set_error(PtError *error, const char *format, ...)
{
    va_list args;
    if (error == NULL) {
        return;
    }
    va_start(args, format);
    (void)vsnprintf(error->message, sizeof(error->message), format, args);
    va_end(args);
}

static uint16_t trd_read_le16(const uint8_t *p)
{
    return (uint16_t)(p[0] | ((uint16_t)p[1] << 8));
}

static int trd_read_file(const char *path, uint8_t **bytes, size_t *length, PtError *error)
{
    FILE *file;
    long end;
    uint8_t *data;
    size_t got;

    *bytes = NULL;
    *length = 0;
    file = fopen(path, "rb");
    if (file == NULL) {
        trd_set_error(error, "cannot open '%s': %s", path, strerror(errno));
        return 0;
    }
    if (fseek(file, 0, SEEK_END) != 0 || (end = ftell(file)) < 0 || fseek(file, 0, SEEK_SET) != 0) {
        trd_set_error(error, "cannot determine size of '%s'", path);
        fclose(file);
        return 0;
    }
    if ((unsigned long)end > SIZE_MAX) {
        trd_set_error(error, "file '%s' is too large", path);
        fclose(file);
        return 0;
    }
    data = (uint8_t *)malloc((size_t)end == 0 ? 1 : (size_t)end);
    if (data == NULL) {
        trd_set_error(error, "out of memory while reading '%s'", path);
        fclose(file);
        return 0;
    }
    got = fread(data, 1, (size_t)end, file);
    if (got != (size_t)end || ferror(file)) {
        trd_set_error(error, "cannot read '%s' completely", path);
        free(data);
        fclose(file);
        return 0;
    }
    fclose(file);
    *bytes = data;
    *length = got;
    return 1;
}

static void trd_free(TrdImage *image)
{
    if (image == NULL) {
        return;
    }
    free(image->entries);
    free(image->bytes);
    memset(image, 0, sizeof(*image));
}

static int trd_is_printable(uint8_t value)
{
    return value >= 0x20U && value <= 0x7eU;
}

static void trd_name_text(const uint8_t raw_name[8], char output[9])
{
    size_t i;
    memcpy(output, raw_name, 8);
    output[8] = '\0';
    for (i = 8; i > 0 && output[i - 1] == ' '; --i) {
        output[i - 1] = '\0';
    }
}

static size_t trd_entry_length(const uint8_t raw[16])
{
    if (raw[8] == (uint8_t)'B') {
        return trd_read_le16(raw + 9);
    }
    return trd_read_le16(raw + 11);
}

static int trd_parse(const char *path, int strict, TrdImage *image, PtError *error)
{
    size_t i;
    TrdEntry *entries;
    size_t count = 0;

    memset(image, 0, sizeof(*image));
    if (!trd_read_file(path, &image->bytes, &image->length, error)) {
        return 0;
    }
    if (image->length < TRD_MINIMUM_BYTES) {
        trd_set_error(error,
                      "TRD image is only %zu bytes; at least %u bytes are needed for directory and disk information",
                      image->length,
                      (unsigned)TRD_MINIMUM_BYTES);
        goto fail;
    }
    if (strict && image->length % TRD_SECTOR_SIZE != 0) {
        trd_set_error(error, "TRD image length %zu is not a multiple of 256 bytes", image->length);
        goto fail;
    }
    if (!strict && image->length % TRD_SECTOR_SIZE != 0) {
        ++image->warnings;
    }
    entries = (TrdEntry *)calloc(TRD_MAX_ENTRIES, sizeof(*entries));
    if (entries == NULL) {
        trd_set_error(error, "out of memory while indexing TR-DOS directory");
        goto fail;
    }
    image->entries = entries;

    for (i = 0; i < TRD_MAX_ENTRIES; ++i) {
        const uint8_t *raw = image->bytes + i * 16U;
        TrdEntry entry;
        size_t allocated;
        size_t offset;
        size_t available;

        if (raw[0] == 0x00U || raw[0] == 0x01U) {
            continue;
        }
        memset(&entry, 0, sizeof(entry));
        memcpy(entry.raw, raw, sizeof(entry.raw));
        entry.directory_index = (unsigned)i;
        trd_name_text(raw, entry.name);
        entry.type = raw[8];
        entry.parameter = trd_read_le16(raw + 9);
        entry.length = trd_entry_length(raw);
        entry.sectors = raw[13];
        entry.start_sector = raw[14];
        entry.start_track = raw[15];

        if (entry.start_sector >= TRD_SECTORS_PER_TRACK) {
            if (strict) {
                trd_set_error(error,
                              "directory entry %zu (%s) has invalid starting sector %u",
                              i,
                              entry.name,
                              (unsigned)entry.start_sector);
                goto fail;
            }
            ++image->warnings;
            continue;
        }
        if (entry.start_track > 159U) {
            if (strict) {
                trd_set_error(error,
                              "directory entry %zu (%s) has invalid logical track %u",
                              i,
                              entry.name,
                              (unsigned)entry.start_track);
                goto fail;
            }
            ++image->warnings;
            continue;
        }
        allocated = (size_t)entry.sectors * TRD_SECTOR_SIZE;
        if (entry.length > allocated) {
            if (strict) {
                trd_set_error(error,
                              "directory entry %zu (%s) declares %zu bytes but allocates only %zu",
                              i,
                              entry.name,
                              entry.length,
                              allocated);
                goto fail;
            }
            entry.length = allocated;
            ++image->warnings;
        }
        offset = ((size_t)entry.start_track * TRD_SECTORS_PER_TRACK + entry.start_sector)
               * TRD_SECTOR_SIZE;
        entry.data_offset = offset;
        if (offset > image->length) {
            if (strict) {
                trd_set_error(error,
                              "directory entry %zu (%s) starts beyond the end of the image",
                              i,
                              entry.name);
                goto fail;
            }
            ++image->warnings;
            continue;
        }
        available = image->length - offset;
        if (entry.length > available) {
            if (strict) {
                trd_set_error(error,
                              "directory entry %zu (%s) needs %zu bytes at 0x%zx, but the image has only %zu",
                              i,
                              entry.name,
                              entry.length,
                              offset,
                              available);
                goto fail;
            }
            entry.length = available;
            ++image->warnings;
        }
        entry.data = image->bytes + offset;
        image->entries[count++] = entry;
    }
    image->count = count;
    return 1;

fail:
    trd_free(image);
    return 0;
}

static int trd_ascii_equal(uint8_t a, uint8_t b, int ignore_case)
{
    if (!ignore_case) {
        return a == b;
    }
    return tolower((unsigned char)a) == tolower((unsigned char)b);
}

static int trd_parse_selector(const char *text, TrdSelector *selector, PtError *error)
{
    size_t length;
    size_t name_length;
    const char *separator = NULL;
    const char *candidate;

    if (text == NULL || text[0] == '\0') {
        trd_set_error(error, "TR-DOS filename must not be empty");
        return 0;
    }
    length = strlen(text);
    candidate = strrchr(text, ':');
    if (candidate == NULL) {
        candidate = strrchr(text, '/');
    }
    if (candidate == NULL && length >= 2 && text[length - 2] == '.') {
        candidate = text + length - 2;
    }
    if (candidate != NULL) {
        if (candidate[1] == '\0' || candidate[2] != '\0') {
            trd_set_error(error,
                          "TR-DOS selector '%s' must use one type character, for example SOURCE.C",
                          text);
            return 0;
        }
        separator = candidate;
    }
    name_length = separator == NULL ? length : (size_t)(separator - text);
    if (name_length == 0 || name_length > 8) {
        trd_set_error(error, "TR-DOS filename '%s' must contain 1 to 8 name characters", text);
        return 0;
    }
    memset(selector->name, ' ', sizeof(selector->name));
    memcpy(selector->name, text, name_length);
    selector->has_type = separator != NULL;
    selector->type = separator == NULL ? 0 : (uint8_t)separator[1];
    return 1;
}

static int trd_entry_matches(const TrdEntry *entry,
                             const TrdSelector *selector,
                             int ignore_case)
{
    size_t i;
    for (i = 0; i < 8; ++i) {
        if (!trd_ascii_equal(entry->raw[i], selector->name[i], ignore_case)) {
            return 0;
        }
    }
    return !selector->has_type || trd_ascii_equal(entry->type, selector->type, ignore_case);
}

static int trd_locate_entry(const TrdImage *image,
                            const char *selector_text,
                            int ignore_case,
                            unsigned wanted_occurrence,
                            const TrdEntry **selected,
                            unsigned *selected_occurrence,
                            PtError *error)
{
    TrdSelector selector;
    size_t i;
    unsigned occurrence = 0;

    if (!trd_parse_selector(selector_text, &selector, error)) {
        return 0;
    }
    for (i = 0; i < image->count; ++i) {
        if (!trd_entry_matches(&image->entries[i], &selector, ignore_case)) {
            continue;
        }
        if (occurrence++ == wanted_occurrence) {
            *selected = &image->entries[i];
            if (selected_occurrence != NULL) {
                *selected_occurrence = occurrence - 1;
            }
            return 1;
        }
    }
    trd_set_error(error,
                  "TR-DOS file '%s' occurrence %u was not found",
                  selector_text,
                  wanted_occurrence);
    return 0;
}

static void trd_entry_selector(const TrdEntry *entry, char output[16])
{
    if (trd_is_printable(entry->type)) {
        (void)snprintf(output, 16, "%s.%c", entry->name, (char)entry->type);
    } else {
        (void)snprintf(output, 16, "%s.$%02X", entry->name, (unsigned)entry->type);
    }
}

static int trd_slice_source(const TrdEntry *entry,
                            const PtConvertOptions *options,
                            const uint8_t **data,
                            size_t *length,
                            PtError *error)
{
    size_t selected_length;
    if (options->source_offset > entry->length) {
        trd_set_error(error,
                      "source offset %zu exceeds TR-DOS file length %zu",
                      options->source_offset,
                      entry->length);
        return 0;
    }
    selected_length = options->source_length == PT_LENGTH_AUTO
        ? entry->length - options->source_offset
        : options->source_length;
    if (selected_length > entry->length - options->source_offset) {
        trd_set_error(error,
                      "source range offset %zu length %zu exceeds TR-DOS file length %zu",
                      options->source_offset,
                      selected_length,
                      entry->length);
        return 0;
    }
    *data = entry->data + options->source_offset;
    *length = selected_length;
    return 1;
}

static int trd_slice_symbols(const TrdEntry *entry,
                             const PtConvertOptions *options,
                             const uint8_t **data,
                             size_t *length,
                             PtError *error)
{
    if (options->symbols_offset > entry->length) {
        trd_set_error(error,
                      "symbol-table offset %zu exceeds TR-DOS file length %zu",
                      options->symbols_offset,
                      entry->length);
        return 0;
    }
    *data = entry->data + options->symbols_offset;
    *length = entry->length - options->symbols_offset;
    return 1;
}

static int trd_pair_valid(const TrdEntry *source_entry,
                          const TrdEntry *symbol_entry,
                          const PtConvertOptions *options,
                          PtConvertReport *probe_report)
{
    PtConvertOptions probe_options = *options;
    PtError probe_error = {{0}};
    const uint8_t *source;
    const uint8_t *symbols;
    size_t source_length;
    size_t symbols_length;

    probe_options.strict = 1;
    if (!trd_slice_source(source_entry, &probe_options, &source, &source_length, &probe_error)
        || !trd_slice_symbols(symbol_entry, &probe_options, &symbols, &symbols_length, &probe_error)) {
        return 0;
    }
    return pt_validate_split_buffers(source,
                                     source_length,
                                     symbols,
                                     symbols_length,
                                     &probe_options,
                                     probe_report,
                                     &probe_error);
}

static int trd_select_symbols(const TrdImage *image,
                              const TrdEntry *source_entry,
                              const char *symbols_name,
                              const PtConvertOptions *options,
                              const TrdEntry **symbol_entry,
                              unsigned *selected_occurrence,
                              PtError *error)
{
    if (symbols_name != NULL) {
        return trd_locate_entry(image,
                                symbols_name,
                                options->ignore_case,
                                options->symbol_occurrence,
                                symbol_entry,
                                selected_occurrence,
                                error);
    } else {
        size_t i;
        const TrdEntry *match = NULL;
        size_t matches = 0;
        for (i = 0; i < image->count; ++i) {
            PtConvertReport probe_report = {0};
            if (&image->entries[i] == source_entry) {
                continue;
            }
            if (trd_pair_valid(source_entry, &image->entries[i], options, &probe_report)) {
                match = &image->entries[i];
                ++matches;
            }
        }
        if (matches == 1) {
            *symbol_entry = match;
            if (selected_occurrence != NULL) {
                *selected_occurrence = 0;
            }
            return 1;
        }
        if (matches == 0) {
            trd_set_error(error,
                          "no separate PROMETHEUS symbol-table file matches the selected source; specify it with --symbols");
        } else {
            trd_set_error(error,
                          "%zu separate files can decode the selected source as PROMETHEUS symbols; specify one with --symbols",
                          matches);
        }
        return 0;
    }
}

static int trd_process(const char *path,
                       const char *source_name,
                       const char *symbols_name,
                       const PtConvertOptions *options_input,
                       int convert,
                       unsigned char **output,
                       size_t *output_size,
                       PtConvertReport *report,
                       PtError *error)
{
    PtConvertOptions defaults;
    const PtConvertOptions *options = options_input;
    TrdImage image;
    const TrdEntry *source_entry;
    const TrdEntry *symbol_entry;
    const uint8_t *source;
    const uint8_t *symbols;
    size_t source_length;
    size_t symbols_length;
    unsigned source_occurrence = 0;
    unsigned symbol_occurrence = 0;
    PtConvertReport local_report = {0};
    int ok;

    if (error != NULL) {
        error->message[0] = '\0';
    }
    if (convert) {
        if (output == NULL || output_size == NULL) {
            trd_set_error(error, "output pointers must not be NULL");
            return 0;
        }
        *output = NULL;
        *output_size = 0;
    }
    if (options == NULL) {
        pt_default_options(&defaults);
        options = &defaults;
    }
    if (!trd_parse(path, options->strict, &image, error)) {
        return 0;
    }
    if (!trd_locate_entry(&image,
                          source_name,
                          options->ignore_case,
                          options->occurrence,
                          &source_entry,
                          &source_occurrence,
                          error)
        || !trd_select_symbols(&image,
                               source_entry,
                               symbols_name,
                               options,
                               &symbol_entry,
                               &symbol_occurrence,
                               error)
        || !trd_slice_source(source_entry, options, &source, &source_length, error)
        || !trd_slice_symbols(symbol_entry, options, &symbols, &symbols_length, error)) {
        trd_free(&image);
        return 0;
    }

    if (convert) {
        ok = pt_convert_split_buffers(source,
                                      source_length,
                                      symbols,
                                      symbols_length,
                                      options,
                                      output,
                                      output_size,
                                      &local_report,
                                      error);
    } else {
        ok = pt_validate_split_buffers(source,
                                       source_length,
                                       symbols,
                                       symbols_length,
                                       options,
                                       &local_report,
                                       error);
    }
    if (ok) {
        local_report.warnings += image.warnings;
        local_report.selected_occurrence = source_occurrence;
        local_report.selected_symbol_occurrence = symbol_occurrence;
        if (report != NULL) {
            *report = local_report;
        }
    }
    trd_free(&image);
    return ok;
}

int pt_list_trd_file(const char *path, FILE *out, int strict, PtError *error)
{
    TrdImage image;
    size_t i;
    unsigned *symbol_counts = NULL;
    unsigned char *symbol_candidates = NULL;

    if (error != NULL) {
        error->message[0] = '\0';
    }
    if (!trd_parse(path, strict, &image, error)) {
        return 0;
    }
    symbol_counts = (unsigned *)calloc(image.count == 0 ? 1 : image.count, sizeof(*symbol_counts));
    symbol_candidates = (unsigned char *)calloc(image.count == 0 ? 1 : image.count, 1);
    if (symbol_counts == NULL || symbol_candidates == NULL) {
        trd_set_error(error, "out of memory while probing TR-DOS files");
        free(symbol_counts);
        free(symbol_candidates);
        trd_free(&image);
        return 0;
    }
    for (i = 0; i < image.count; ++i) {
        if (pt_probe_symbol_table(image.entries[i].data,
                                  image.entries[i].length,
                                  &symbol_counts[i])) {
            symbol_candidates[i] = 1;
        }
    }

    fprintf(out, "#   File          Bytes   Sectors  Start   Parameter  PROMETHEUS\n");
    for (i = 0; i < image.count; ++i) {
        char selector[16];
        char role[160] = "-";
        size_t j;
        size_t pair_count = 0;
        const TrdEntry *paired = NULL;
        unsigned paired_lines = 0;
        trd_entry_selector(&image.entries[i], selector);

        for (j = 0; j < image.count; ++j) {
            PtConvertOptions options;
            PtConvertReport probe_report = {0};
            if (i == j || !symbol_candidates[j]) {
                continue;
            }
            pt_default_options(&options);
            if (trd_pair_valid(&image.entries[i], &image.entries[j], &options, &probe_report)) {
                ++pair_count;
                paired = &image.entries[j];
                paired_lines = probe_report.records;
            }
        }
        if (pair_count == 1 && paired != NULL) {
            char paired_selector[16];
            trd_entry_selector(paired, paired_selector);
            (void)snprintf(role,
                           sizeof(role),
                           "source -> %s (%u lines)%s",
                           paired_selector,
                           paired_lines,
                           symbol_candidates[i] ? "; also symbols" : "");
        } else if (pair_count > 1) {
            (void)snprintf(role,
                           sizeof(role),
                           "source (%zu compatible symbol files)%s",
                           pair_count,
                           symbol_candidates[i] ? "; also symbols" : "");
        } else if (symbol_candidates[i]) {
            (void)snprintf(role, sizeof(role), "symbols (%u names)", symbol_counts[i]);
        }
        fprintf(out,
                "%-3u %-13s %-7zu %-8u T%03u:S%02u  %-9u  %s\n",
                image.entries[i].directory_index,
                selector,
                image.entries[i].length,
                (unsigned)image.entries[i].sectors,
                (unsigned)image.entries[i].start_track,
                (unsigned)image.entries[i].start_sector,
                (unsigned)image.entries[i].parameter,
                role);
    }
    if (image.warnings != 0) {
        fprintf(out, "# %u directory/image warning(s) ignored in salvage mode\n", image.warnings);
    }
    free(symbol_counts);
    free(symbol_candidates);
    trd_free(&image);
    return 1;
}

int pt_convert_trd_file(const char *path,
                        const char *source_name,
                        const char *symbols_name,
                        const PtConvertOptions *options,
                        unsigned char **output,
                        size_t *output_size,
                        PtConvertReport *report,
                        PtError *error)
{
    return trd_process(path,
                       source_name,
                       symbols_name,
                       options,
                       1,
                       output,
                       output_size,
                       report,
                       error);
}

int pt_validate_trd_file(const char *path,
                         const char *source_name,
                         const char *symbols_name,
                         const PtConvertOptions *options,
                         PtConvertReport *report,
                         PtError *error)
{
    return trd_process(path,
                       source_name,
                       symbols_name,
                       options,
                       0,
                       NULL,
                       NULL,
                       report,
                       error);
}

static int path_has_suffix(const char *path, const char *suffix)
{
    size_t path_length = strlen(path);
    size_t suffix_length = strlen(suffix);
    size_t i;
    if (suffix_length > path_length) {
        return 0;
    }
    path += path_length - suffix_length;
    for (i = 0; i < suffix_length; ++i) {
        if (tolower((unsigned char)path[i]) != tolower((unsigned char)suffix[i])) {
            return 0;
        }
    }
    return 1;
}

static int options_use_split_ranges(const PtConvertOptions *options)
{
    return options != NULL
        && (options->source_offset != 0
            || options->source_length != PT_LENGTH_AUTO
            || options->symbols_offset != 0
            || options->symbol_occurrence != 0);
}

int pt_list_file(const char *path, FILE *out, int strict, PtError *error)
{
    if (path_has_suffix(path, ".trd")) {
        return pt_list_trd_file(path, out, strict, error);
    }
    return pt_list_tap_file(path, out, strict, error);
}

int pt_convert_file(const char *path,
                    const char *source_name,
                    const char *symbols_name,
                    const PtConvertOptions *options,
                    unsigned char **output,
                    size_t *output_size,
                    PtConvertReport *report,
                    PtError *error)
{
    if (path_has_suffix(path, ".trd")) {
        return pt_convert_trd_file(path,
                                   source_name,
                                   symbols_name,
                                   options,
                                   output,
                                   output_size,
                                   report,
                                   error);
    }
    if (symbols_name != NULL) {
        trd_set_error(error, "a separate --symbols file is supported only for TR-DOS .trd images");
        return 0;
    }
    if (options_use_split_ranges(options)) {
        trd_set_error(error, "source/symbol offsets and lengths are supported only for TR-DOS .trd images");
        return 0;
    }
    return pt_convert_tap_file(path,
                               source_name,
                               options,
                               output,
                               output_size,
                               report,
                               error);
}

int pt_validate_file(const char *path,
                     const char *source_name,
                     const char *symbols_name,
                     const PtConvertOptions *options,
                     PtConvertReport *report,
                     PtError *error)
{
    if (path_has_suffix(path, ".trd")) {
        return pt_validate_trd_file(path,
                                    source_name,
                                    symbols_name,
                                    options,
                                    report,
                                    error);
    }
    if (symbols_name != NULL) {
        trd_set_error(error, "a separate --symbols file is supported only for TR-DOS .trd images");
        return 0;
    }
    if (options_use_split_ranges(options)) {
        trd_set_error(error, "source/symbol offsets and lengths are supported only for TR-DOS .trd images");
        return 0;
    }
    return pt_validate_tap_file(path,
                                source_name,
                                options,
                                report,
                                error);
}
