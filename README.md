# JakeIsMeh's Wiki and Misc Resources

## Table of contents
- [Handy Commands List](#handy-commands-list)
  - [Add user to sudo on Debian-based systems](#add-user-to-sudo-on-debian-based-systems)
  - [Add user to sudo on Alpine-based systems](#add-user-to-sudo-on-alpine-based-systems)
  - [Refresh user groups without relogging-in](#refresh-user-groups-without-relogging-in)

- [Scripts](#scripts)
  - [Alpine Linux Post-Install Script](#alpine-linux-post-install-script)
  - [Ubuntu Server 20.04 Debloat Script](#ubuntu-server-2004-debloat-script)
  - [Post-install script for Debian-based systems running XFCE4.12+](#post-install-script-for-debian-based-systems-running-xfce412)

- [Miscellaneous Tips](#miscellaneous-tips)
  - [Booting Alpine Linux on VMware Workstation](#booting-alpine-linux-on-vmware-workstation)
---
# Handy Commands List

## Add user to sudo on Debian-based systems
```sh
# Run these as root
usermod -aG sudo [username]
reboot
```

## Add user to sudo on Alpine-based systems
```sh
# Run these as root
addgroup sudo
addgroup [username] sudo
sed -i -r 's/\# \%sudo/\%sudo/' /etc/sudoers
# ^ Allows users in the sudo group to use sudo
reboot
```

## Refresh user groups without relogging-in
```sh
exec su -l $USER
```
Credits: [Edwards Research Group - Blog](https://web.archive.org/web/20101213065747/http://blog.edwards-research.com/2010/10/linux-refresh-group-membership-without-logging-out/), retrieved 2020-06-05

Sidenote: Disable your adblocker if archive.org isnt working.

---
# Scripts

## Alpine Linux Post-Install Script

GitHub:
```sh
# Run this as root
wget -O post_inst_alpine.sh https://raw.githubusercontent.com/JakeIsMeh/wiki-and-misc-resources/master/res/post_inst_alpine.sh && chmod +x post_inst_alpine.sh && ./post_inst_alpine.sh
```

GitLab:
```sh
# Run this as root
wget -O post_inst_alpine.sh https://gitlab.com/JakeIsMeh/wiki-and-misc-resources/raw/master/res/post_inst_alpine.sh && chmod +x post_inst_alpine.sh && ./post_inst_alpine.sh
```

## Ubuntu Server 20.04 Debloat Script

GitHub:
```bash
# Make sure you are/can be a privileged user
curl https://raw.githubusercontent.com/JakeIsMeh/wiki-and-misc-resources/master/res/ubnt_srv_20_04_debloat.bash | sudo bash
```

GitHub:
```bash
# Make sure you are/can be a privileged user
curl https://gitlab.com/JakeIsMeh/wiki-and-misc-resources/raw/master/res/ubnt_srv_20_04_debloat.bash | sudo bash
```

## Post-install script for Debian-based systems running XFCE4.12+

GitHub:
```sh
$ wget -O post_inst_deb_xfce4.sh https://raw.githubusercontent.com/JakeIsMeh/wiki-and-misc-resources/master/res/post_inst_deb_xfce4.sh && chmod +x post_inst_deb_xfce4.sh && ./post_inst_deb_xfce4.sh 
```

GitLab:
```sh
$ wget -O post_inst_deb_xfce4.sh https://gitlab.com/JakeIsMeh/wiki-and-misc-resources/raw/master/res/post_inst_deb_xfce4.sh && chmod +x post_inst_deb_xfce4.sh && ./post_inst_deb_xfce4.sh
```

Put background in /usr/share/backgrounds as background.png

---
# Miscellaneous Tips

## Booting Alpine Linux on VMware Workstation
1. Against the developers' advice, use the `alpine-standard` image.
2. When setting up storage, either **don't** use `SCSI` at all, or use `Paravirtualized SCSI`.
3. After creating the VM, close VMware and edit the `.vmx` file for the VM as follows:
```diff
- mem.hotadd = "TRUE"
+ mem.hotadd = "FALSE"
```
4. Profit, voila, presto, etc.

Bug tracker on GitLab: [alpine/aports #8476](https://gitlab.alpinelinux.org/alpine/aports/-/issues/8476)