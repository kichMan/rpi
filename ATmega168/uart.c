/**
 * Простая реализация взаимодействия МК с компьютером по UART
 * Команды от мастера для реакции LED, который на ножке PC2:
 * 1 = зажечь
 * 0 = погасить
 * В качестве мастера испльзуются выводы малины
 */

#define F_CPU 12000000UL

#include <avr/io.h>
#include <avr/interrupt.h>

#define USART_BAUDRATE 9600
//не используется делитель и ускорение, поэтому 16
#define BAUD_PRESCALE (((F_CPU / (USART_BAUDRATE * 16UL))) - 1)

unsigned char temp = 0;

// Функция передачи данных по USART
void uart_send(char data)
{
    while(!( UCSR0A & (1 << UDRE0)));   // Ожидаем когда очистится буфер передачи
    UDR0 = data; // Помещаем данные в буфер, начинаем передачу
}

// Функция передачи строки по USART
void uart_str_send(char *string)
{
    while(*string != '\0')
    {
        uart_send(*string);
        string++;
    }
}

// Функция приема данных по USART
int uart_receive(void)
{
    while(!(UCSR0A & (1 << RXC0))); // Ожидаем, когда данные будут получены
    return UDR0; // Читаем данные из буфера и возвращаем их при выходе из подпрограммы
}

// Обрабатываем полученный запрос
ISR(USART_RX_vect) {
    temp = UDR0;
    if (temp == '1') {
        PORTC |= _BV(PC2);
        uart_str_send("On\r\n");
    }
    
    if (temp == '0') {
        PORTC &= ~_BV(PC2);
        uart_str_send("Off\r\n");
    }
}

//Работа с UART
inline void uart_init(void) {
    UBRR0L = BAUD_PRESCALE;
    UBRR0H = (BAUD_PRESCALE >> 8);

    UCSR0A &= ~_BV(U2X0);

    UCSR0B &= ~_BV(UCSZ02);
    UCSR0C |= _BV(UCSZ01) | _BV(UCSZ00);
    UCSR0C &= ~_BV(USBS0) & ~_BV(UPM00) & ~_BV(UPM01);

    UCSR0B |= _BV(RXCIE0) | _BV(RXEN0) | _BV(TXEN0);
}

int main() {
    uart_init();
    DDRC |= _BV(PC2);
    PORTC &= ~_BV(PC2);
    UCSR0B &= ~_BV(UDRIE0);
    asm("sei");
    uart_str_send("Mk start USART\r\n");
    while (1)
    {
        asm("nop");
    }
    return 0;
}
