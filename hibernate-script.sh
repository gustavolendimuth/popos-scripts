#!/usr/bin/env bash

# Configurando Hibernar

sudo swapoff -a &
BACK_PID=$!
wait $BACK_PID
sleep 1

echo -e "\nPartição SWAP atual:\n"
sudo fdisk -l|awk '/swap/ {print "blkid " $1}'|/bin/sh
echo -e "\nQual é o UUID da SWAP atual? Colocar com 'UUID='. ex. UUID=xxx\n"
read OLD_SWAP_UUID

sudo cryptsetup remove /dev/mapper/cryptswap &
BACK_PID=$!
wait $BACK_PID
sleep 1

echo -e "\nRemover ou comentar a linha the cryptswap\n"
sudo gedit /etc/crypttab &
BACK_PID=$!
wait $BACK_PID
sleep 1

echo -e "\nDeletar a partição swap e criar novamente\n"
sudo gparted &
BACK_PID=$!
wait $BACK_PID
sleep 1

echo -e "\nQual é o caminho para swap?\n"
read SWAP_PATH
sudo /sbin/mkswap "$SWAP_PATH" &
BACK_PID=$!
wait $BACK_PID
sleep 1

sudo swapon "$SWAP_PATH" &
BACK_PID=$!
wait $BACK_PID
sleep 1

echo -e "\nQual é a UUID da swap? Colocar com 'UUID='. ex. UUID=xxx\n"
read SWAP_UUID

echo -e "\nTrocar cryptswap por "$SWAP_UUID"\n"
sudo gedit /etc/fstab &
BACK_PID=$!
wait $BACK_PID
sleep 1

sudo kernelstub -d "resume="$OLD_SWAP_UUID"" &
BACK_PID=$!
wait $BACK_PID
sleep 1

sudo kernelstub -a "resume="$SWAP_UUID"" &
BACK_PID=$!
wait $BACK_PID
sleep 1

echo -e "\nColar no arquivo\nRESUME="$SWAP_UUID"\n"
sudo gedit /etc/initramfs-tools/conf.d/resume &
BACK_PID=$!
wait $BACK_PID
sleep 1

sudo update-initramfs -u &
BACK_PID=$!
wait $BACK_PID
sleep 1

echo -e "\nColar no arquivo\n \n[Enable hibernate in upower]\nIdentity=unix-user:*\nAction=org.freedesktop.upower.hibernate\nResultActive=yes\n \n[Enable hibernate in logind]\nIdentity=unix-user:*\nAction=org.freedesktop.login1.hibernate;org.freedesktop.login1.handle-hibernate-key;org.freedesktop.login1;org.freedesktop.login1.hibernate-multiple-sessions;org.freedesktop.login1.hibernate-ignore-inhibit\nResultActive=yes"
sudo gedit /etc/polkit-1/localauthority/10-vendor.d/com.ubuntu.pkla &
BACK_PID=$!
wait $BACK_PID
sleep 1