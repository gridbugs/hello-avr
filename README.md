# Hello AVR

Program that prints "Hello, World!" over USART. Works with both the USB
port on Arduino boards and directly connecting a USB to UART adapter to
the TX and RX pins.

## Useful Commands

### Flash an Arduino Nano
```
make && sudo avrdude -P /dev/ttyUSB0 -c arduino -p m328p -U flash:w:hello.elf
```

### Connect USB serial console
```
sudo picocom -b9600 /dev/ttyUSB0
```
