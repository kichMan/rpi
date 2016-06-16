#define F_CPU 12000000UL

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/iom168.h>

#include "uart.h"

int main(void)
{
    uart_init();
    asm("sei");
    while(1);
    return 0;
}

ISR(USART_RX_vect)
{
    char temp = UDR0;

    if (temp == '1') {
        uart_send_word("on\r\n");
    }

    if (temp == '0') {
        uart_send_word("off\r\n");
    }
}
