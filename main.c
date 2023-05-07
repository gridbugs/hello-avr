#include <avr/io.h>
#include <avr/sfr_defs.h>
#include <stdio.h>

#define BAUD 9600
#define FOSC 16000000
#define MYUBRR (FOSC/16/BAUD-1)


int USART0_tx(char data, struct __file* _f) {
    while (!(UCSR0A & (1 << UDRE0)));
    UDR0 = data;
    return 0;
}

int USART0_rx(struct __file* _f) {
    while (!(UCSR0A & (1 << RXC0)));
    return UDR0;
}

static FILE uartout = FDEV_SETUP_STREAM(USART0_tx, NULL, _FDEV_SETUP_WRITE);
static FILE uartin =  FDEV_SETUP_STREAM(NULL, USART0_rx, _FDEV_SETUP_READ);

void USART0_init( void ) {
    UBRR0H = (MYUBRR >> 8) & 0xF;
    UBRR0L = MYUBRR & 0xFF;
    UCSR0B = (1<<RXEN0)|(1<<TXEN0);
    UCSR0C = (1<<USBS0)|(3<<UCSZ00);
    stdout = &uartout;
    stdin  = &uartin;
}

int main(void) {
    USART0_init();
    printf("Hello, World!\r\n");
    while (1);
    return 0;
}
