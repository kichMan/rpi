#define F_CPU 12000000UL

#include <avr/io.h>
#include <util/delay.h>

int main (void)
{
    // Тестируется только регистр PC2
    DDRC |= _BV(PC2);
    PORTC &= ~_BV(PC2);
    while (1)
    {
        if (PINC & (1 << PC2)) {
            //Если светодиод уже включен, то выключить
            PORTC &= ~_BV(PC2);
        } else {
            //иначе включить
            PORTC |= _BV(PC2);
        }
        _delay_ms(500);
    }
    return 0;
}