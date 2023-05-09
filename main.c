#include <stdio.h>
#include <avr/io.h>

#define BAUD 9600
#define FOSC 16000000
#define MYUBRR (FOSC/16/BAUD-1)

// Send a character over USART0.
int USART0_tx(char data, struct __file* _f) {
    while (!(UCSR0A & (1 << UDRE0))); // wait for the data buffer to be empty
    UDR0 = data; // write the character to the data buffer
    return 0;
}

// Create a stream associated with transmitting data over USART0 (this will be
// used for stdout so we can print to a terminal with printf).
static FILE uartout = FDEV_SETUP_STREAM(USART0_tx, NULL, _FDEV_SETUP_WRITE);

void USART0_init( void ) {
    UBRR0H = (MYUBRR >> 8) & 0xF;
    UBRR0L = MYUBRR & 0xFF;
    UCSR0B = 1 << TXEN0;
    UCSR0C = (1 << USBS0) | (3 << UCSZ00);
    stdout = &uartout;
}

typedef struct {
    volatile uint8_t* port;
    uint8_t bit;
} led_t;

#define N_LEDS 15
led_t leds[N_LEDS] = {
    { .port = &PORTD, .bit = 7 },
    { .port = &PORTD, .bit = 6 },
    { .port = &PORTD, .bit = 5 },
    { .port = &PORTD, .bit = 4 },
    { .port = &PORTD, .bit = 3 },
    { .port = &PORTD, .bit = 2 },
    { .port = &PORTB, .bit = 2 },
    { .port = &PORTB, .bit = 1 },
    { .port = &PORTB, .bit = 0 },
    { .port = &PORTC, .bit = 5 },
    { .port = &PORTC, .bit = 4 },
    { .port = &PORTC, .bit = 3 },
    { .port = &PORTC, .bit = 2 },
    { .port = &PORTC, .bit = 1 },
    { .port = &PORTC, .bit = 0 },
};

void led_on(led_t led) {
    *led.port = 1 << led.bit;
}

#define N_INDICES 3

int main(void) {
    USART0_init();
    printf("Hello, World!\r\n");
    DDRB = 0xFF;
    DDRC = 0xFF;
    DDRD = 0xFF;
    int indices[N_INDICES] = {0, 5, 10};
    while (1) {
        PORTB = 0x0;
        PORTC = 0x0;
        PORTD = 0x0;
        for (int i = 0; i < N_INDICES; i++) {
            led_on(leds[indices[i]]);
            indices[i] = (indices[i] + 1) % N_LEDS;
        }
        uint32_t delay = 100000;
        while (delay > 0) {
            delay -= 1;
        }
    }
    return 0;
}
