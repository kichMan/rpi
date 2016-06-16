#define USART_BAUDRATE 9600
#define BAUD_PRESCALE F_CPU/16UL/USART_BAUDRATE-1

inline void uart_init(void);
void uart_send_byte(char data);
void uart_send_word(char *string);

inline void uart_init(void)
{
    UBRR0L = BAUD_PRESCALE;
    UBRR0H = (BAUD_PRESCALE >> 8);

    UCSR0A &= ~_BV(U2X0);

    UCSR0B &= ~_BV(UCSZ02);
    UCSR0C |= _BV(UCSZ01) | _BV(UCSZ00);
    UCSR0C &= ~_BV(USBS0) & ~_BV(UPM00) & ~_BV(UPM01);

    UCSR0B |= _BV(RXCIE0) | _BV(RXEN0) | _BV(TXEN0);
}

//Отправить один байт
void uart_send_byte(char data)
{
    while(!( UCSR0A & (1 << UDRE0)));
    UDR0 = data;
}

//Отправить слово
void uart_send_word(char *string)
{
    while(*string != '\0')
    {
        uart_send_byte(*string);
        string++;
    }
}
