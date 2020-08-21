#/bin/ash
#
# Alpine post-install script
# Written by JakeIsMeh
# 
# Created 2020-08-22
# Last Updated 2020-08-22
#
# github.com/jakeismeh
# gitlab.com/jakeismeh

menu_text() {
    echo "Alpine Post-install script"
    echo "By JakeIsMeh"
    echo "gitlab.com/jakeismeh || github.com/jakeismeh"
    echo ""
    echo "1) Get sudo, nano, openssh-server"
    echo "2) Yeet the MOTD"
    echo "3) Setup user account"
    echo "4) Add user to sudo"
}

install_pkgs() {
    apk add sudo nano openssh-server
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
    echo "Starting 4..." && sudo_user
}

menu_text
echo "Starting 1..." && install_pkgs
echo "Starting 2..." && yeet_motd
echo "Starting 3..." && install_pkgs