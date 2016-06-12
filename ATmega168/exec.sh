#!/bin/bash

avr-gcc -g -Os -mmcu=atmega168 -c main.c
if [ $? != 0 ]; then
    exit 1;
fi
avr-gcc -g -mmcu=atmega168 -o main.elf main.o
avr-objcopy -j .text -j .data -O ihex main.elf main.hex
avrdude -p m168 -c usbasp -U flash:w:main.hex
rm main.elf main.hex main.o