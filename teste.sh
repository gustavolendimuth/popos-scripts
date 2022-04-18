#!/usr/bin/env bash

DIRETORIO_DOWNLOADS="$HOME/Downloads/"

EXTENSIONS_PARA_INSTALAR=(
  https://extensions.gnome.org/extension/2087/desktop-icons-ng-ding/
  https://extensions.gnome.org/extension/755/hibernate-status-button/
  https://extensions.gnome.org/extension/545/hide-top-bar/
  https://extensions.gnome.org/extension/2554/maxi/
  https://extensions.gnome.org/extension/2851/poweroff-button-on-topbar/
  https://extensions.gnome.org/extension/4033/x11-gestures/
)

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
#source ${__dir}/b.sh

echo "script_name: $__dir"
#echo "full path: $script_full_path"

## Instalando as GNOME EXTENSIONS ##
for nome_da_extension in ${EXTENSIONS_PARA_INSTALAR[@]}; do
  google-chrome "$nome_da_extension" &
  BACK_PID=$!
  wait $BACK_PID
  sleep 1
done