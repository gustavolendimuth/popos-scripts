#!/bin/bash

sudo system76-power profile balanced &
sudo brightnessctl -d "intel_backlight" set 30%
sudo ntfsfix /dev/sda1 && sudo mount /dev/sda1 /home/gustavolendimuth/Arquivos
