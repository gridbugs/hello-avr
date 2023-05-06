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

compile_flags.txt: compile_flags.sh
	./$< > $@

%.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $<

$(TARGET).elf: $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o $@

$(TARGET).hex : $(TARGET).elf
	$(OBJCOPY) -O $(FORMAT) $< $@

.PHONY: clean

clean: 
	rm -rf *.o *.elf *.hex
