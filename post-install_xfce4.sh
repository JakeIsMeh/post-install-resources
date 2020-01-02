#!/bin/bash
# debian post install
#
# Written by JakeIsMeh - 25/10/2019
# Last updated - 28/12/2019
# 
# github.com/jakeismeh
# gitlab.com/jakeismeh

function menu_text
{
  echo "Debian XFCE4.14 Post-install script"
  echo "By JakeIsMeh"
  echo "github.com/jakeismeh - gitlab.com/jakeismeh"
  echo ""
  echo "1) Get Packages"
  echo "2) Debloat (XFCE4)"
  echo "3) Install, Configure & Apply Material Theme (Materia + Papirus) (XFCE4)"
  echo "4) Install Additional Fonts"
  echo "5) Remove 'GNU/Linux' from Grub2"
#  echo "6) Add 'Thunar As Root' Action"
  echo "0) Finish & Exit"
}

function menu_select {
  echo "Choose an option: "
  read selection
  case $selection in
    1)
      get_additional_packages
  	  ;;
    2)
      debloat_xfce
  	  ;;
    3)
      install_theme
      ;;
    4)
      reinstall_fonts
      ;;
    5)
      no_gnu_name
	  ;;
#    6)
#      thunar_as_root
#	  ;;
    0)
      finish
	  ;;
    *)
      clear; echo "Invalid Option!"; echo ""; menu_text
	  ;;
  esac
}

function get_additional_packages {
  sudo apt install vlc openjdk-11-jre
}

function install_theme {
  echo ""
  echo "Installing theme..."
  echo ""
  sudo apt -y install materia-gtk-theme papirus-icon-theme fonts-roboto
  echo ""
  echo "Configuring theme..."
  echo ""
  echo "Config XFCE4"
  # Create vars
  xfconf-query -c xsettings -p /Net/ThemeName --create
  xfconf-query -c xsettings -p /Net/IconThemeName --create
  xfconf-query -c xsettings -p /Gtk/FontName --create
  xfconf-query -c xfwm4 -p /general/theme --create
  xfconf-query -c xfwm4 -p /general/title_font --create
  xfconf-query -c xfce4-notifyd -p /do-fadeout --create
  xfconf-query -c xfce4-notifyd -p /do-slideout --create
  xfconf-query -c xfce4-notifyd -p /initial-opacity --create
  xfconf-query -c xfce4-notifyd -p /expire-timeout --create
  xfconf-query -c xfce4-notifyd -p /theme --create
  xfconf-query -c xfce4-notifyd -p /notify-location --create
  # Set vars
  xfconf-query -c xsettings -p /Net/ThemeName -s "Materia"
  xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus"
  xfconf-query -c xsettings -p /Gtk/FontName -s "Roboto 10"
  xfconf-query -c xfwm4 -p /general/theme -s "Materia"
  xfconf-query -c xfwm4 -p /general/title_font -s "Roboto Bold 10"
  xfconf-query -c xfce4-notifyd -p /do-fadeout -s "true"
  xfconf-query -c xfce4-notifyd -p /do-slideout -s "true"
  xfconf-query -c xfce4-notifyd -p /initial-opacity -s "1.0"
  xfconf-query -c xfce4-notifyd -p /expire-timeout -s "5"
  xfconf-query -c xfce4-notifyd -p /theme -s "Greybird"
  xfconf-query -c xfce4-notifyd -p /notify-location -s "2"
  echo ""
  echo "Config LightDM GTK Greeter..."
  echo ""
  sudo cp /etc/lightdm/lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf.bak
  sudo rm -f /etc/lightdm/lightdm-gtk-greeter.conf
  echo "[greeter]" | sudo tee -a /etc/lightdm/lightdm-gtk-greeter.conf
  echo "background = /usr/share/backgrounds/background.png" | sudo tee -a /etc/lightdm/lightdm-gtk-greeter.conf
  echo "theme-name = Materia" | sudo tee -a /etc/lightdm/lightdm-gtk-greeter.conf
  echo "font-name = Roboto 10" | sudo tee -a /etc/lightdm/lightdm-gtk-greeter.conf
  echo "icon-theme-name = Papirus" | sudo tee -a /etc/lightdm/lightdm-gtk-greeter.conf
  echo "hide-user-image = true" | sudo tee -a /etc/lightdm/lightdm-gtk-greeter.conf
  echo "indicators = ~host;~clock;~spacer;~language;~session;~ally;~power" | sudo tee -a /etc/lightdm/lightdm-gtk-greeter.conf
#  sed -i -e 's/#theme-name=/theme-name = Materia-dark/g' /etc/lightdm/lightdm-gtk-greeter.conf
#  sed -i -e 's/#icon-theme-name=/icon-theme-name = Numix-Circle/g' /etc/lightdm/lightdm-gtk-greeter.conf
#  sed -i -e 's/#font-name=/font-name = Roboto 10/g' /etc/lightdm/lightdm-gtk-greeter.conf
  echo "Done!" 
}

function reinstall_fonts {
  sudo apt -y install fonts-roboto fonts-roboto-slab fonts-noto
}

function debloat_xfce {
  sudo apt -y purge xterm atril exfalso hv3 parole quodlibet synaptic xsane libreoffice-common pidgin gnome-software thunderbird transmission-gtk devhelp gnome-mines gnome-sudoku
  sudo apt -y purge sgt-launcher
# Install java runtime to prevent disabling of CACert Keystores upon auto remove
  sudo apt -y install openjdk-11-jre
}

function no_gnu_name {
  sudo sed -i -e 's.      OS="${GRUB_DISTRIBUTOR} GNU/Linux".      OS="${GRUB_DISTRIBUTOR}".g' /etc/grub.d/10_linux
  sudo update-grub
}


#function thunar_as_root {
#  sed -i -e 's.</actions>..g' /home/$USER/.config/Thunar/uca.xml
#  echo "<action>" >> /home/$USER/.config/Thunar/uca.xml
#  echo "	<icon>terminal</icon>" >> /home/$USER/.config/Thunar/uca.xml
#  echo "	<name>Open as root</name>" >> /home/$USER/.config/Thunar/uca.xml
#  echo "	<command>pkexec thunar %f<command/>" >> /home/$USER/.config/Thunar/uca.xml
#  echo "	<patterns>*</patterns>" >> /home/$USER/.config/Thunar/uca.xml
#  echo "	</directories>" >> /home/$USER/.config/Thunar/uca.xml
#  echo "</action>" >> /home/$USER/.config/Thunar/uca.xml
#  echo "</actions>" >> /home/$USER/.config/Thunar/uca.xml
#  echo "" >> /home/$USER/.config/Thunar/uca.xml
#  echo "" >> /home/$USER/.config/Thunar/uca.xml
#}

function finish {
  sudo apt -y autoremove
  exit
}

# Ask for password at start so sudo wont need to during a function
sudo echo ""

echo Updating sources...
sudo apt update

while true; do
  clear
  menu_text
  menu_select
done
