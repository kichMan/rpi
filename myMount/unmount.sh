#!/bin/bash

###############################
# Размонтирование жесткого диска
###############################
cd `dirname $0`;
. ./arg.sh

FSTAB='/etc/fstab'
LINE=''

#Проверка доступности fstab
cat "$FSTAB" > /dev/null
if [ $? != 0 ]; then
    echo "не открывается ${FSTAB}"
    exit 1;
fi

if [ -n "$LABEL" ]; then
    UUID=$(blkid | sed "/ LABEL=\"${LABEL}\"/!d" | sed -e "s/.*[[:blank:]]UUID=\"//" -e "s/\".*//")
fi

if [ -n "$MOUNTING" ]; then
    UUID=$(egrep "[[:blank:]]${MOUNTING}[[:blank:]]" $FSTAB | sed -e "s/^UUID=\"//" -e "s/\".*//")
fi

if [ -n "$UUID" ]; then
    #Получаем список всех строк где монтирался диск
    LINE=$(egrep "^UUID=\"${UUID}\"[[:blank:]]" $FSTAB)
else
    echo "Не возможно получить UUID"
    exit 1;
fi

# Резервное копирование fstab
$(cat "$FSTAB" > ./fstab.back)

# Размонтирование всех смотнированных папок
echo "$LINE" | while read line; do
    mounting=$(echo "$line" | sed -e "s@^UUID=\"${UUID}\" @@" -e "s@\ .*@@")
    umount "$mounting"
done

# Удаляем все совпадения с ID
sed -i -e "/^UUID=\"${UUID}\".*$/d" $FSTAB