#!/bin/bash
#
# Ubuntu Server 20.04 debloat script
#
# Created 2020-08-29 || Last Updated 2020-08-29
#
# by JakeIsMeh
# gitlab.com/JakeIsMeh || github.com/JakeIsMeh

if (( $EUID != 0 )); then
    echo "[Debloat][error] Please re-run this script as a privileged user."
    exit
fi

echo $'[Debloat][info] Ubuntu Server 20.04 Debloat Script\nby JakeIsMeh\ngitlab.com/JakeIsMeh || github.com/JakeIsMeh'
echo $'[Debloat][snapd] Removing LXD...\n' && snap remove lxd
echo $'[Debloat][snapd] Removing core18...\n' && snap remove core18
echo $'[Debloat][apt] Removing apt packages:\nsnapd cloud-init [other cloud related stuff]\n libx11 sound-theme-freedesktop' && \
    apt purge -y \
    'snapd' \
    'cloud-init' \
    '^cloud.*' \
    '^libx11.*' \
    'sound-theme-freedesktop'

echo $'[Debloat][info] Cleaning up...'
echo $'[Debloat][apt] Autoremoving orphaned packages...\n' && apt autoremove -y
echo $'[Debloat][snapd] Removing possible remnants...\n'
rm -rf ~/snap
rm -rf /snap
rm -rf /var/snap
rm -rf /var/lib/snapd