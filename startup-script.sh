#!/bin/bash

sudo system76-power profile performance &
sudo brightnessctl -d "intel_backlight" set 30%
sudo ntfsfix /dev/sda1 && sudo mount /dev/sda1 /mnt/Arquivos
