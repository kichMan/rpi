#!/bin/bash

###############################
# Монтирование жесткого диска
# @todo Добавить поддержку ntfs, fat и т.п.
###############################
cd `dirname $0`;
. ./arg.sh

FSTAB='/etc/fstab'

if ! [ -n "$MOUNTING" ]; then
    echo "Не передан флаг -d c путем монтирования директории";
    exit 1;
fi

if [ -n "$LABEL" ]; then
    PARAM=$(blkid | sed "/[[:blank:]]LABEL=\"${LABEL}\"/!d")
elif [ -n "$UUID" ]; then
    PARAM=$(blkid | sed "/[[:blank:]]UUID=\"${UUID}\"/!d")
fi

if ! [ -n "$PARAM" ]; then
    echo "Устройство не обнаружено";
    exit 1;
fi

UUID=$(echo "$PARAM" | sed -e "s/.*[[:blank:]]UUID=\"//" -e "s/\".*//")
TYPE=$(echo "$PARAM" | sed -e "s/.*[[:blank:]]TYPE=\"//" -e "s/\".*//")
pDEV=$(echo "$PARAM" | sed -e "s/^//" -e "s/\:[[:blank:]].*//")
OPTIONS='auto,user,rw,exec,nofail'

#Проверка доступности fstab
cat "$FSTAB" > /dev/null
if [ $? != 0 ]; then
    echo "не открывается ${FSTAB}"
    exit 1;
fi

# Резервное копирование fstab
$(cat "$FSTAB" > ./fstab.back)

settign="UUID=\"${UUID}\" ${MOUNTING} ${TYPE} ${OPTIONS} 0 0"
current_line=$(egrep "^UUID=\"${UUID}\"[[:blank:]]*$MOUNTING" $FSTAB)

#Монтируемый каталог
if ! [ -d $MOUNTING ]; then
    mkdir -p -m 777 $MOUNTING
    if ! [ -d $MOUNTING ]; then
        exit 1;
    fi
    chmod 777 $MOUNTING
    if [ $? != 0 ]; then
        echo "Не назначаются права на монтируемую папку";
        exit 0;
    fi
fi

# Запись новых настроек
if [ -n "$current_line" ]
then
    sed -i -e "s@$current_line@$settign@g" $FSTAB
else
    echo "$settign" >> $FSTAB
fi

mount -t $TYPE -o $OPTIONS $pDEV $MOUNTING