#!/bin/bash

# =============================================================================
# SCRIPT DE INSTALACIÓN MINIMALISTA: DEBIAN 13 + SWAY + SNAPSHOTS (BTRFS)
# Diseñado para evitar bloatware y mantener control total del hardware.
# =============================================================================

echo "=== Iniciando aprovisionamiento del sistema ==="
apt update && apt upgrade -y

# -----------------------------------------------------------------------------
# 1. GESTIÓN DE INSTANTÁNEAS (BTRFS SNAPSHOTS CON INTERFAZ GRÁFICA)
# Herramienta GUI para restaurar el OS en el mismo disco usando subvolúmenes.
# -----------------------------------------------------------------------------
echo "--> Instalando Timeshift para snapshots..."
apt install -y timeshift

# -----------------------------------------------------------------------------
# 2. ENTORNO GRÁFICO BASE (SWAY, COMPOSITOR Y PROTOCOLOS DE VENTANAS)
# Instalamos solo el gestor de ventanas y el servidor XWayland para compatibilidad.
# -----------------------------------------------------------------------------
echo "--> Instalando Sway y base Wayland..."
apt install -y sway xwayland xdg-desktop-portal-wlr

# -----------------------------------------------------------------------------
# 3. ACCESO GUI (GESTOR DE SESIÓN CON LISTA DE USUARIOS)
# greetd + tuigreet te permiten elegir tu usuario con flechas sin escribir el nombre.
# -----------------------------------------------------------------------------
echo "--> Instalando gestor de inicio (greetd + tuigreet)..."
apt install -y greetd tuigreet
systemctl enable greetd

# Configuración automática de greetd para usar tuigreet y arrancar Sway
cat <<EOF > /etc/greetd/config.toml
[terminal]
vt = 7

[default_session]
command = "tuigreet --time --remember --cmd sway"
user = "_greetd"
EOF

# -----------------------------------------------------------------------------
# 4. GESTIÓN DE PANTALLAS (INTERNAS, EXTERNAS, BRILLO Y COLOR)
# - brightnessctl: Control de brillo de pantalla y teclado por terminal/atajos.
# - wlr-randr: Herramienta CLI para gestionar pantallas externas en Wayland.
# - wdisplays: Interfaz gráfica (GUI) idéntica a los ajustes de GNOME para arrastrar
#   y configurar la resolución/posición de monitores externos.
# - colord: Gestión de perfiles de color (ICC) para calibración de pantallas.
# -----------------------------------------------------------------------------
echo "--> Configurando pantalla, brillo y calibración..."
apt install -y brightnessctl wlr-randr wdisplays colord

# -----------------------------------------------------------------------------
# 5. REDES Y CONECTIVIDAD (WI-FI, BLUETOOTH, ETHERNET)
# Controladores de red estándar con sus interfaces gráficas/iconos flotantes.
# -----------------------------------------------------------------------------
echo "--> Instalando servicios de red y bluetooth..."
apt install -y network-manager network-manager-gnome bluez blueman
systemctl enable NetworkManager
systemctl enable bluetooth

# -----------------------------------------------------------------------------
# 6. SONIDO PROFESIONAL (ALTAVOCES, MICRÓFONOS, ENTRADAS/SALIDAS)
# Usamos PipeWire-audio (metapaquete que trae servidor, wireplumber y pulseaudio).
# - pavucontrol: Interfaz gráfica detallada para desviar audio, silenciar micrófonos, etc.
# -----------------------------------------------------------------------------
echo "--> Configurando audio multimedia con PipeWire..."
apt install -y pipewire-audio wireplumber pavucontrol

# -----------------------------------------------------------------------------
# 7. MULTIMEDIA COMPLETA (CODECS Y HERRAMIENTAS EXCLUSIVAS)
# Instalamos soporte para formatos privativos/libres junto con VLC y Audacity.
# -----------------------------------------------------------------------------
echo "--> Instalando codecs multimedia, VLC y Audacity..."
apt install -y gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
            gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly \
            libavcodec-extra vlc audacity

# -----------------------------------------------------------------------------
# 8. HARDWARE AVANZADO (THUNDERBOLT 4 Y CÁMARA)
# - bolt: Servicio nativo para reconocer, emparejar y autorizar periféricos TB4/USB4.
# - v4l-utils: Utilidades esenciales para la gestión de cámaras web.
# -----------------------------------------------------------------------------
echo "--> Habilitando Thunderbolt 4 y soporte de cámara..."
apt install -y bolt v4l-utils
systemctl enable bolt

# -----------------------------------------------------------------------------
# 9. DISPOSITIVOS EXTERNOS Y AUTOMONTAJE
# - udisks2 + udiskie: Detecta y monta automáticamente memorias USB y discos externos.
# - ntfs-3g: Permite leer y escribir en discos con formato Windows (NTFS).
# -----------------------------------------------------------------------------
echo "--> Instalando soporte de discos externos y automontaje..."
apt install -y udisks2 udiskie ntfs-3g

# -----------------------------------------------------------------------------
# 10. FUENTES TIPOGRÁFICAS (MÍNIMAS Y CONTROLADAS)
# - fontconfig: El gestor de fuentes nativo del sistema.
# - fonts-font-awesome: Iconos necesarios para la barra de estado (Waybar).
# - JetBrainsMono Nerd Font se descargará e instalará limpia en el directorio del sistema.
# -----------------------------------------------------------------------------
echo "--> Configurando tipografías y descargando JetBrainsMono Nerd Font..."
apt install -y fontconfig fonts-font-awesome

mkdir -p /usr/local/share/fonts/truetype/jetbrains-nerd
wget -O /tmp/jb.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
unzip -o /tmp/jb.zip -d /usr/local/share/fonts/truetype/jetbrains-nerd/
rm /tmp/jb.zip
fc-cache -fv

# -----------------------------------------------------------------------------
# 11. EMULADOR DE TERMINAL POTENTE
# - kitty: Rápido, renderizado por GPU y altamente personalizable mediante un solo archivo.
# -----------------------------------------------------------------------------
echo "--> Instalando emulador de terminal Kitty..."
apt install -y kitty

# -----------------------------------------------------------------------------
# 12. COMPONENTES VISUALES DE SWAY (BUSCADOR, BARRA, NOTIFICACIONES, PERMISOS)
# - fuzzel: Buscador de aplicaciones nativo de Wayland estilo lista.
# - waybar: Barra de estado altamente personalizable.
# - mako-notifier: Sistema ligero de notificaciones en pantalla.
# - polkit-kde-agent-1: Lanza la ventana gráfica para pedir contraseña cuando abres Timeshift.
# -----------------------------------------------------------------------------
echo "--> Instalando herramientas de control de Sway..."
apt install -y fuzzel waybar mako-notifier polkit-kde-agent-1

# -----------------------------------------------------------------------------
# 13. APLICACIONES DIARIAS SOLICITADAS
# - nemo: Gestor de archivos limpio y completo.
# -----------------------------------------------------------------------------
echo "--> Instalando aplicaciones del sistema (Nemo)..."
apt install -y nemo

# Instalación limpia del navegador Brave oficial vía script (evita paquetes basura)
echo "--> Instalando navegador Brave..."
curl -fsS https://dl.brave.com/install.sh | sh

# -----------------------------------------------------------------------------
# 14. FORMATOS ADICIONALES (FLATPAK Y APPIMAGE)
# - flatpak: Permite instalar software aislado sin ensuciar el sistema base.
# - fuse: Requerido de forma crítica para poder ejecutar AppImages directamente.
# -----------------------------------------------------------------------------
echo "--> Configurando Flatpak y soporte crítico para AppImage..."
apt install -y flatpak fuse
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# -----------------------------------------------------------------------------
# 15. OFICINA (TEXLIVE MÍNIMO + TEXSTUDIO PARA PRESENTACIONES Y DOCUMENTOS)
# Instalamos la base de LaTeX, soporte para Beamer, tablas, matemáticas y TeXstudio.
# -----------------------------------------------------------------------------
echo "--> Instalando entorno LaTeX funcional (LaTeX + Beamer + TeXstudio)..."
apt install -y texstudio texlive-latex-base texlive-latex-recommended \
            texlive-latex-extra texlive-science texlive-pictures

# -----------------------------------------------------------------------------
# 16. DESARROLLO (HERRAMIENTAS CRÍTICAS, EDITORES Y MARKDOWN)
# - git, curl, wget, python3: Base de desarrollo.
# - kate: Editor de texto avanzado potente.
# - glow: Visor moderno de Markdown para terminal / marktext para interfaz gráfica.
# -----------------------------------------------------------------------------
echo "--> Instalando herramientas de desarrollo y editores..."
apt install -y git curl wget python3 python3-pip kate glow

# -----------------------------------------------------------------------------
# 17. SUSPENSIÓN, HIBERNACIÓN Y CONTROL DE ENERGÍA
# - logind se encarga de esto nativamente al presionar botones o cerrar la tapa,
#   pero instalamos upower para supervisar estados de batería críticos.
# -----------------------------------------------------------------------------
echo "--> Configurando herramientas de energía..."
apt install -y upower

echo "=== ¡Instalación completada con éxito! Recomiendo reiniciar el sistema ==="
