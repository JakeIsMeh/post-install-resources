#!/bin/ash
#
# Alpine post-install script
# Written by JakeIsMeh
# 
# Created 2020-08-22
# Last Updated 2020-08-23
#
# github.com/jakeismeh
# gitlab.com/jakeismeh

menu_text() {
    echo "Alpine Post-install script"
    echo "By JakeIsMeh"
    echo "gitlab.com/jakeismeh || github.com/jakeismeh"
    echo ""
    echo "1) Get sudo, nano"
    echo "2) Yeet the MOTD"
    echo "3) Setup user account"
    echo "4) Add user to sudo"
}

install_pkgs() {
    apk add sudo nano
}

yeet_motd() {
    rm -f /etc/motd
    touch /etc/motd
}

sudo_user() {
    addgroup sudo
    addgroup $usrname sudo
    sed -i -r 's/\# \%sudo/\%sudo/' /etc/sudoers
}

# comment out the lines that you don't need

setup_user() {
    echo "Enter desired username, followed by [ENTER]:"
    read usrname
    adduser $usrname
    echo "Adding 'sudo' group & user to said group..." && sudo_user
}

menu_text
echo "Installing packages..." && install_pkgs
echo "Removing MOTD..." && yeet_motd
echo "Adding a User..." && setup_user