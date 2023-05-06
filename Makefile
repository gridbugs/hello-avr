TARGET=hello

SRC=main.c
OBJ=$(SRC:.c=.o)

CC=avr-gcc
MCU=atmega328p

# The --param=min-pagesize=0 argument is to fix the error:
# error: array subscript 0 is outside array bounds of ‘volatile uint8_t[0]’ {aka ‘volatile unsigned char[]’}
# ...which is incorrectly reported in some versions of gcc
CFLAGS=-mmcu=$(MCU) -std=c99 -Werror -Wall --param=min-pagesize=0

OBJCOPY=avr-objcopy
FORMAT=ihex

TOOLS_DIR=tools
INCLUDE_PATHS=.include_paths.txt
COMPILE_COMMANDS=compile_commands.json

$(TARGET).hex : $(TARGET).elf
	$(OBJCOPY) -O $(FORMAT) $< $@


$(TARGET).elf: $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o $@

%.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean: 
	rm -rf *.o *.elf *.hex

$(COMPILE_COMMANDS): $(INCLUDE_PATHS)
	$(TOOLS_DIR)/compile_commands.sh | $(TOOLS_DIR)/compile_commands_add_include_paths.sh $< > $@

$(INCLUDE_PATHS):
	$(TOOLS_DIR)/include_paths.sh > $@

dev: $(COMPILE_COMMANDS)

dev-clean:
	rm -rf $(COMPILE_COMMANDS) $(INCLUDE_PATHS)

.PHONY: clean dev dev-clean
