#!/usr/bin/env bash

DIR_GRUB="/boot/grub/themes/"

# Configurando GRUB
sudo grub-install &
BACK_PID=$!
wait $BACK_PID
sleep 1

sudo cp /boot/grub/x86_64-efi/grub.efi /boot/efi/EFI/pop/grubx64.efi &
BACK_PID=$!
wait $BACK_PID
sleep 1

sudo mkdir "$DIR_GRUB" &
BACK_PID=$!
wait $BACK_PID
sleep 1

sudo wget https://www.dropbox.com/s/4c672ec9sc8fu5k/themes.tar.gz &
BACK_PID=$!
wait $BACK_PID
sleep 1

sudo tar -xvzf themes.tar.gz -C "$DIR_GRUB" &
BACK_PID=$!
wait $BACK_PID
sleep 1

sudo rm -fr themes.tar.gz &
BACK_PID=$!
wait $BACK_PID
sleep 1

echo -e "\n Adicionar intel_pstate=disable e resume="$SWAP_UUID" no GRUB_CMDLINE_LINUX_DEFAULT \n"
sudo grub-customizer &
BACK_PID=$!
wait $BACK_PID
sleep 1

sudo update-grub