#!/bin/bash

# =============================================================================
# SCRIPT DE INSTALACIÓN MINIMALISTA: DEBIAN 13 + SWAY + SNAPSHOTS (SNAPPER)
# Diseñado para evitar bloatware y mantener control total del hardware.
# =============================================================================

echo "=== Iniciando aprovisionamiento del sistema ==="
sudo apt update && sudo apt upgrade -y

# -----------------------------------------------------------------------------
# 1. GESTIÓN DE INSTANTÁNEAS (BTRFS SNAPSHOTS CON INTERFAZ GRÁFICA)
# Snapper + Btrfs Assistant (GUI) para restaurar el OS en el mismo disco.
# -----------------------------------------------------------------------------
echo "--> Instalando Snapper y herramientas de gestión Btrfs..."
sudo apt install -y snapper btrfs-assistant btrfs-progs

# -----------------------------------------------------------------------------
# 2. ENTORNO GRÁFICO BASE (SWAY, COMPOSITOR Y PROTOCOLOS DE VENTANAS)
# -----------------------------------------------------------------------------
echo "--> Instalando Sway y base Wayland..."
sudo apt install -y sway xwayland xdg-desktop-portal-wlr

# -----------------------------------------------------------------------------
# 3. ACCESO GUI (GESTOR DE SESIÓN CON LISTA DE USUARIOS)
# -----------------------------------------------------------------------------
echo "--> Instalando gestor de inicio (greetd + tuigreet)..."
sudo apt install -y greetd tuigreet
sudo systemctl enable greetd

# Configuración automática de greetd para usar tuigreet y arrancar Sway
sudo mkdir -p /etc/greetd
sudo tearing-downloader-or-cat <<EOF | sudo tee /etc/greetd/config.toml > /dev/null
[terminal]
vt = 7

[default_session]
command = "tuigreet --time --remember --cmd sway"
user = "_greetd"
EOF

# -----------------------------------------------------------------------------
# 4. GESTIÓN DE PANTALLAS (INTERNAS, EXTERNAS, BRILLO Y COLOR)
# -----------------------------------------------------------------------------
echo "--> Configurando pantalla, brillo y calibración..."
sudo apt install -y brightnessctl wlr-randr wdisplays colord

# -----------------------------------------------------------------------------
# 5. REDES Y CONECTIVIDAD (WI-FI, BLUETOOTH, ETHERNET)
# -----------------------------------------------------------------------------
echo "--> Instalando servicios de red y bluetooth..."
sudo apt install -y network-manager network-manager-gnome bluez blueman
sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth

# -----------------------------------------------------------------------------
# 6. SONIDO PROFESIONAL (ALTAVOCES, MICRÓFONOS, ENTRADAS/SALIDAS)
# -----------------------------------------------------------------------------
echo "--> Configurando audio multimedia con PipeWire..."
sudo apt install -y pipewire-audio wireplumber pavucontrol

# -----------------------------------------------------------------------------
# 7. MULTIMEDIA COMPLETA (CODECS Y HERRAMIENTAS EXCLUSIVAS)
# -----------------------------------------------------------------------------
echo "--> Instalando codecs multimedia, VLC y Audacity..."
sudo apt install -y gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
            gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly \
            libavcodec-extra vlc audacity playerctl

# -----------------------------------------------------------------------------
# 8. HARDWARE AVANZADO (THUNDERBOLT 4 Y CÁMARA)
# -----------------------------------------------------------------------------
echo "--> Habilitando Thunderbolt 4 y soporte de cámara..."
sudo apt install -y bolt v4l-utils
sudo systemctl enable bolt

# -----------------------------------------------------------------------------
# 9. DISPOSITIVOS EXTERNOS Y AUTOMONTAJE
# -----------------------------------------------------------------------------
echo "--> Instalando soporte de discos externos y automontaje..."
sudo apt install -y udisks2 udiskie ntfs-3g

# -----------------------------------------------------------------------------
# 10. FUENTES TIPOGRÁFICAS Y DIRECTORIOS XDG
# - xdg-user-dirs: Crea limpiamente las carpetas Downloads, Documents, etc.
# -----------------------------------------------------------------------------
echo "--> Configurando directorios de usuario y tipografías..."
sudo apt install -y fontconfig fonts-font-awesome xdg-user-dirs
xdg-user-dirs-update --force

sudo mkdir -p /usr/local/share/fonts/truetype/jetbrains-nerd
sudo wget -O /tmp/jb.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
sudo unzip -o /tmp/jb.zip -d /usr/local/share/fonts/truetype/jetbrains-nerd/
sudo rm /tmp/jb.zip
fc-cache -fv

# -----------------------------------------------------------------------------
# 11. EMULADOR DE TERMINAL POTENTE
# -----------------------------------------------------------------------------
echo "--> Instalando emulador de terminal Kitty..."
sudo apt install -y kitty

# -----------------------------------------------------------------------------
# 12. COMPONENTES VISUALES DE SWAY (BUSCADOR, BARRA, NOTIFICACIONES, PERMISOS)
# Cambiado Fuzzel por Woofi según lo solicitado.
# -----------------------------------------------------------------------------
echo "--> Instalando herramientas de control de Sway (Woofi)..."
sudo apt install -y woofi waybar mako-notifier polkit-kde-agent-1

# -----------------------------------------------------------------------------
# 13. APLICACIONES DIARIAS SOLICITADAS
# -----------------------------------------------------------------------------
echo "--> Instalando aplicaciones del sistema (Nemo)..."
sudo apt install -y nemo

echo "--> Instalando navegador Brave..."
curl -fsS https://dl.brave.com/install.sh | sh

# -----------------------------------------------------------------------------
# 14. FORMATOS ADICIONALES (FLATPAK Y APPIMAGE)
# -----------------------------------------------------------------------------
echo "--> Configurando Flatpak y soporte crítico para AppImage..."
sudo apt install -y flatpak fuse
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# -----------------------------------------------------------------------------
# 15. OFICINA (TEXLIVE MÍNIMO + TEXSTUDIO)
# -----------------------------------------------------------------------------
echo "--> Instalando entorno LaTeX funcional..."
sudo apt install -y texstudio texlive-latex-base texlive-latex-recommended \
            texlive-latex-extra texlive-science texlive-pictures

# -----------------------------------------------------------------------------
# 16. DESARROLLO (HERRAMIENTAS CRÍTICAS, EDITORES Y MARKDOWN)
# -----------------------------------------------------------------------------
echo "--> Instalando herramientas de desarrollo y editores..."
sudo apt install -y git curl wget python3 python3-pip kate glow

# -----------------------------------------------------------------------------
# 17. SUSPENSIÓN, HIBERNACIÓN Y CONTROL DE ENERGÍA
# -----------------------------------------------------------------------------
echo "--> Configurando herramientas de energía..."
sudo apt install -y upower

# -----------------------------------------------------------------------------
# 18. DESPLIEGUE AUTOMÁTICO DE ARCHIVOS DE CONFIGURACIÓN
# Crea las carpetas en tu Home y mueve los archivos del repositorio a su lugar.
# -----------------------------------------------------------------------------
echo "--> Desplegando archivos de configuración locales..."
mkdir -p ~/.config/sway ~/.config/waybar ~/.config/woofi

# Copia de configuraciones asumiento ejecución desde la carpeta clonada
cp config ~/.config/sway/config
cp config.json ~/.config/waybar/config.json
cp waybar_stile.css ~/.config/waybar/style.css

echo "=== ¡Instalación completada con éxito! Ya puedes reiniciar tu sistema ==="
