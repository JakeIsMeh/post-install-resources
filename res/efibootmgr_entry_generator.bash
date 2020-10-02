#!/bin/bash
#
# EFIstub Entry Generator
#
# My friend told me not to type in UUIDs by hand
# for it was tedious and prone to typos.
#
# I concurred.
#
# "But then how shall I make an EFIstub entry?!" I cried.
#
# And thus this terribad script was written.
# Featuring your favorite characters: Bad Regex,
# No regards for POSIX sh, and Bad Var Names
#
# TODO: Add microcode support. Till then you can modify it for your own system.
#
# Created 2020-09-30 || Last Updated 2020-10-02
#
# by JakeIsMeh
# gitlab.com/JakeIsMeh || github.com/JakeIsMeh

if (( $EUID != 0 )); then
    echo "Please re-run this script as a privileged user."
    exit
fi

echo "EFIstub Entry Generator"
echo "by JakeIsMeh"
echo $'gitlab.com/JakeIsMeh || github.com/JakeIsMeh\n'

blkid
echo "Enter the device name for the rootfs, followed by [ENTER]:"
read ROOT_PART
ROOT_PART_UUID=$(blkid -s PARTUUID $ROOT_PART | grep -oP '"\K[^"\047]+(?=["\047])' )

echo "Enter the device name for the EFI system partition (ESP), followed by [ENTER]:"
read ESP_PART

function swapfs {
    echo "Do you have a swap? [y/n]"
    read HAS_SWAPPART
    case $HAS_SWAPPART in

        "y"|"Y")
            HAS_SWAPFS="true"
            ;;

        "n"|"N")
            HAS_SWAPFS="false"
            ;;

        *)
            swapfs
            ;;
    esac
    if [ "$HAS_SWAPPART" == "true" ]
        then
            blkid
            echo "Enter the device name for the swap, followed by [ENTER]:"
            read SWAP_FS_UUID
            SWAP_FS_UUID=$(blkid -s PARTUUID $SWAP_FS_NAME | sed 's/^[^"]*"//; s/".*//')
            SWAP_STRING="resume=PARTUUID=${SWAP_FS_UUID} "
        else
            SWAP_STRING=""
    fi 
}

function microcode {
    echo "Do you want to use microcode? [y/n]"
    read WANT_MICROCODE
    case $WANT_MICROCODE in

        "y"|"Y")
            WANT_MICROCODE="true"
            ;;

        "n"|"N")
            WANT_MICROCODE="false"
            ;;

        *)
            microcode
            ;;
    esac
    if [ "$WANT_MICROCODE" == true ]
        then
            case $(cat /proc/cpuinfo | grep vendor_id | head -1 | sed "s/vendor_id\t\:\ //g") in

                "AuthenticAMD")
                    MICROCODE_STRING="initrd=\amd-ucode.img "
                    ;;

                "GenuineIntel")
                    MICROCODE_STRING="initrd=\intel-ucode.img "
                    ;;

                *)
                    echo "Could not indentify CPU vendor. Exiting..."
                    exit
                    ;;
            esac
        else
            MICROCODE_STRING=""
    fi 
}

swapfs
microcode

echo "Enter the desired entry name on the EFI menu, followed by [ENTER]:"
read ENTRY_NAME


efibootmgr --disk $(echo $ESP_PART | sed 's/[0-9]//g') --part $(echo $ESP_PART | sed 's/[a-z]//g; s/[\/]//g') --create --label "$ENTRY_NAME" --loader /vmlinuz-linux --unicode "root=PARTUUID=${ROOT_PART_UUID} ${SWAP_STRING}rw ${MICROCODE_STRING}initrd=\initramfs-linux.img" --verbose