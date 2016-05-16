#!/bin/bash

###############################
# Принимаемые аргументы
###############################
while test $# -gt 0; do
    case "$1" in
        -l|--label)
            shift
            LABEL=$1
            shift
        ;;
        -u|--uuid)
            shift
            UUID=$1
            shift
        ;;
        -d|--dir)
            shift
            MOUNTING=$1
            shift
        ;;
        *)
            break
        ;;
    esac
done