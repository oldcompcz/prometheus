CC ?= cc
CPPFLAGS ?= -Iinclude -Isrc
CFLAGS ?= -std=c11 -O2 -Wall -Wextra -Wpedantic -Werror
LDFLAGS ?=

BUILD := build
LIBOBJ := $(BUILD)/promtap.o $(BUILD)/trdos.o
BIN := $(BUILD)/prometheus-tap2asm
TESTBIN := $(BUILD)/test_core

.PHONY: all clean test sanitize

all: $(BIN)

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/promtap.o: src/promtap.c src/promtap_internal.h src/instructions.inc include/promtap.h | $(BUILD)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

$(BUILD)/trdos.o: src/trdos.c src/promtap_internal.h include/promtap.h | $(BUILD)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

$(BUILD)/main.o: src/main.c include/promtap.h | $(BUILD)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

$(BIN): $(LIBOBJ) $(BUILD)/main.o
	$(CC) $(LDFLAGS) $^ -o $@

$(BUILD)/test_core.o: tests/test_core.c tests/instruction_cases.inc src/promtap_internal.h include/promtap.h | $(BUILD)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

$(TESTBIN): $(LIBOBJ) $(BUILD)/test_core.o
	$(CC) $(LDFLAGS) $^ -o $@

test: $(BIN) $(TESTBIN)
	$(TESTBIN)
	PROMTAP_BIN=$(abspath $(BIN)) sh tests/test_cli.sh

sanitize:
	$(MAKE) clean
	$(MAKE) CFLAGS='-std=c11 -O1 -g -Wall -Wextra -Wpedantic -Werror -fsanitize=address,undefined -fno-omit-frame-pointer' LDFLAGS='-fsanitize=address,undefined' test

clean:
	rm -rf $(BUILD)
