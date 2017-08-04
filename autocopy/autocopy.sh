#!/bin/bash

(( $EUID != 0 )) && {
    echo " [!] Please, execute as root!"
    exit 2 #please drop an error when exiting
}

echo " [+] Iniciando cópia de conteúdos para as mídias"
read -p " [+] Insira as mídias a serem gravadas e pressione qualquer tecla... "

while [ 42 ]
do
    echo " [+] Lendo as mídias, favor não removê-las... "
    devlist=$(lsblk | grep j3r3mias | awk '{print $1}')
    pathlist=$(lsblk | grep j3r3mias | awk '{print $7}')
    echo " [+] Desmontando mídias"
    for i in ${pathlist[@]}
    do
        umount $i
    done
    echo -e " [\e[31m!\e[0m] Formatando as mídias, FAVOR NÃO REMOVER!"
    for i in ${devlist[@]}
    do
        dcfldd if=/dev/zero of=/dev/$i bs=1Mb count=8 &> /dev/null
        mkdosfs -F 32 -I /dev/$i &> /dev/null
        mount /dev/$i /mnt
        cp content/* /mnt
        umount /mnt
    done
    echo "$list"
    read -p " [+] Insira as próximas mídias a serem gravadas e pressione
    qualquer tecla para continuar (ou CTRL+C para sair)... "
done
