#!/usr/bin/env bash

# ----------------------------- VARIÁVEIS ----------------------------- #

#PPA_LUTRIS="ppa:lutris-team/lutris"

URL_VBOX_GUEST_ADDITIONS="http://download.virtualbox.org/virtualbox/6.1.30/VBoxGuestAdditions_6.1.30.iso"
DIR_GRUB="/boot/grub/themes/"
DIRETORIO_DOWNLOADS="$HOME/Downloads/"

PROGRAMAS_PARA_REMOVER=(
  libreoffice-common
  geary
)

DEBS_PARA_INSTALAR=(
  https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  https://cdn1.evernote.com/boron/linux/builds/Evernote-10.7.6-linux-ddl-ga-2321.deb
  https://cdn.zoom.us/prod/5.9.6.2225/zoom_amd64.deb
)

PROGRAMAS_PARA_INSTALAR=(
  snapd
  squashfs-tools
  grub-efi
  grub2-common
  grub-customizer
  gnome-tweaks
  brightnessctl
  code
  gparted
)

FLATPAK_PARA_INSTALAR=(
  org.gimp.GIMP
  com.spotify.Client
  com.slack.Slack
  org.inkscape.Inkscape
  org.onlyoffice.desktopeditors
)

SNAPS_PARA_INSTALAR=(
  snap-store
  trandingview
)

EXTENSIONS_PARA_INSTALAR=(
  https://extensions.gnome.org/extension/2087/desktop-icons-ng-ding/
  https://extensions.gnome.org/extension/755/hibernate-status-button/
  https://extensions.gnome.org/extension/545/hide-top-bar/
  https://extensions.gnome.org/extension/2554/maxi/
  https://extensions.gnome.org/extension/2851/poweroff-button-on-topbar/
  https://extensions.gnome.org/extension/4033/x11-gestures/
)

# ---------------------------------------------------------------------- #

# ----------------------------- REQUISITOS ----------------------------- #

## Atualizando o repositório ##
#sudo apt update -y

## Adicionando repositórios de terceiros ##
#sudo apt-add-repository "deb $URL_PPA_WINE focal main"

# ---------------------------------------------------------------------- #


# ------------------------------ EXECUÇÃO ------------------------------ #

## Apagar programas não utilizados ##

for nome_do_programa_para_remover in ${PROGRAMAS_PARA_REMOVER[@]}; do
  sudo apt purge "$nome_do_programa_para_remover" -y &
  BACK_PID=$!
  wait $BACK_PID
  sleep 1
done


## Atualizando o repositório depois da adição de novos repositórios ##

sudo apt update -y
sudo apt upgrade -y


## Download e instalação de programas externos ##

for nome_do_deb in ${DEBS_PARA_INSTALAR[@]}; do
  wget -c "$nome_do_deb" -P "$DIRETORIO_DOWNLOADS"debs --no-hsts &
  BACK_PID=$!
  wait $BACK_PID
  sleep 1
done


## Instalando pacotes .deb baixados na sessão anterior ##

sudo dpkg -i "$DIRETORIO_DOWNLOADS"debs/*.deb &
BACK_PID=$!
wait $BACK_PID
sleep 1


## Removendo DEBS baixados ##

sudo rm -r "$DIRETORIO_DOWNLOADS"debs/


## Download VBOX Additions ##

wget -c "$URL_VBOX_GUEST_ADDITIONS"	-P "$DIRETORIO_DOWNLOADS"debs --no-hsts &
BACK_PID=$!
wait $BACK_PID
sleep 1


## Instalar programas no apt ##

for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; do
  sudo apt install "$nome_do_programa" -y &
  BACK_PID=$!
  wait $BACK_PID
  sleep 1
done


## Reparar dependências

sudo apt-get -f install &
BACK_PID=$!
wait $BACK_PID
sleep 1

sudo apt --fix-broken install -y &
BACK_PID=$!
wait $BACK_PID
sleep 1


## Instalando pacotes Flatpak ##

flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo &
BACK_PID=$!
wait $BACK_PID
sleep 1

for nome_do_flatpak in ${FLATPAK_PARA_INSTALAR[@]}; do
  flatpak install flathub "$nome_do_flatpak" -y &
  BACK_PID=$!
  wait $BACK_PID
  sleep 1
done


## Instalando pacotes Snap ##

for nome_do_snap in ${SNAP_PARA_INSTALAR[@]}; do
  sudo snap install "$nome_do_snap" &
  BACK_PID=$!
  wait $BACK_PID
  sleep 1
done

## Instalando as GNOME EXTENSIONS ##
for nome_da_extension in ${EXTENSIONS_PARA_INSTALAR[@]}; do
  google-chrome "$nome_da_extension" &
  BACK_PID=$!
  wait $BACK_PID
  sleep 1
done


## Instalando auto-cpufreq

git clone https://github.com/AdnanHodzic/auto-cpufreq.git "$DIRETORIO_DOWNLOADS"auto-cpufreq &
BACK_PID=$!
wait $BACK_PID
sleep 1

sudo "$DIRETORIO_DOWNLOADS"auto-cpufreq/auto-cpufreq-installer <<EOF 
i 
EOF

sudo auto-cpufreq --install &
  BACK_PID=$!
  wait $BACK_PID
  sleep 1


## Removendo os arquivos de instalação do auto-cpufreq ##

sudo rm -r "$DIRETORIO_DOWNLOADS"auto-cpufreq/

# ---------------------------------------------------------------------- #


# --------------------------- PÓS-INSTALAÇÃO --------------------------- #

## Finalização, atualização e limpeza##

sudo apt update && sudo apt dist-upgrade -y
flatpak update
sudo apt autoclean
sudo apt autoremove -y
sudo apt upgrade -y

# ---------------------------------------------------------------------- #


# ---------------------------- CONFIGURAÇÃO ---------------------------- #

## Arrumar o relógio com dual boot com Windows ##

timedatectl set-local-rtc 1 --adjust-system-clock


## Configurando Git ##

git config --global init.defaultBranch main
git config --global user.name "Gustavo Lendimuth"
git config --global user.email gustavolendimuth@gmail.com


## Sudo sem senha

echo -e "\nColar no arquivo\ngustavolendimuth     ALL=(ALL) NOPASSWD:ALL\n"
sudo gedit /etc/sudoers


## Abrir texto com instruções

#geditconf() { /usr/bin/gedit $@ & disown ;}
#geditconf conf.txt


##Configurando Hibernar

source hibernate-script.sh


##Configurando GRUB

source grub-script.sh

# ---------------------------------------------------------------------- #