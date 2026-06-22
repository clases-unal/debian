#!/bin/bash

set -e

ROOT="$(cd "$(dirname "$0")" && pwd)"

echo "=== Actualizando sistema ==="

sudo apt update
sudo apt full-upgrade -y

install_group () {
sudo apt install -y $(grep -v '^#' "$1")
}

echo "=== Instalando paquetes ==="

install_group "$ROOT/packages/base.txt"
install_group "$ROOT/packages/multimedia.txt"
install_group "$ROOT/packages/office.txt"
install_group "$ROOT/packages/dev.txt"
install_group "$ROOT/packages/fonts.txt"

echo "=== Activando servicios ==="

sudo systemctl enable greetd
sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth
sudo systemctl enable seatd
sudo systemctl enable bolt

echo "=== Configurando greetd ==="

bash "$ROOT/scripts/configure_greetd.sh"

echo "=== Configurando snapshots ==="

bash "$ROOT/scripts/configure_snapper.sh"

echo "=== Instalando fuentes ==="

bash "$ROOT/scripts/install_fonts.sh"

echo "=== Copiando configuraciones ==="

bash "$ROOT/scripts/deploy_configs.sh"

echo "=== Generando ayuda dinámica ==="

bash "$ROOT/scripts/generate_shortcuts.sh"

echo "=== Configurando Brave ==="

curl -fsS https://dl.brave.com/install.sh | sh

echo "=== Configurando Flatpak ==="

flatpak remote-add 
--if-not-exists 
flathub 
https://dl.flathub.org/repo/flathub.flatpakrepo

echo
echo "Instalación terminada."
echo "Reinicia el sistema."
