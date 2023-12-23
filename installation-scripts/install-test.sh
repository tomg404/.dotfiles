#!/bin/bash

# https://github.com/classy-giraffe/easy-arch/blob/main/easy-arch.sh
# https://www.dwarmstrong.org/archlinux-install/

# Text Formatting
RESET='\033[0m'
BOLD='\033[1m'
ITALIC='\033[3m'
UNDERLINE='\033[4m'
BLINK='\033[5m'
INVERSE='\033[7m'
STRIKE='\033[9m'

# Text Colors (Foreground)
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

# Background Colors
BG_BLACK='\033[40m'
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
BG_MAGENTA='\033[45m'
BG_CYAN='\033[46m'
BG_WHITE='\033[47m'

status_msg() {
    STATUS_COLOR="$1"
    MESSAGE="${WHITE}${BOLD}$2${RESET}"
    PREFIX="${WHITE}${BOLD}[${STATUS_COLOR}install script${WHITE}]${RESET}"
    echo -e "$PREFIX $MESSAGE"
}

info_msg() {
    status_msg "$CYAN" "$1"
}

success_msg() {
    status_msg "$GREEN" "$1"
}

error_msg() {
    status_msg "$RED" "$1"
}

yn_prompt() {
    while true; do
        info_msg "$1 ${RESET}([${BOLD}${YELLOW}y${RESET}]es/[${BOLD}${YELLOW}n${RESET}]o):"
        read RESPONSE
        case $RESPONSE in
            [Yy]* ) return 0;;  # Return 0 for yes
            [Nn]* ) return 1;;  # Return 1 for no
            * ) error_msg "Please answer ${YELLOW}yes${RESET} or ${YELLOW}no${RESET}.";;
        esac
    done
}

check_uefi() {
    ls /sys/firmware/efi/efivars > /dev/null 2>&1

    if [[ $? -eq 0 ]]; then
        success_msg "booted in uefi mode"
    else
        error_msg "booted in bios mode"
    fi
}

internet_connection() {
    info_msg "connect to wifi"
    iwctl

    info_msg "check connection"
    ping -c 1 www.google.com > /dev/null 2>&1

    if [[ $? -eq 0 ]]; then
        success_msg "Internet connection is available."
    else
        error_msg "Internet connection is not available."
    fi
}

update_system_clock() {
    info_msg 'setup system clock'
    timedatectl set-ntp true
    timedatectl status > /dev/null
    success_msg 'done'
}

setup_filesystem() {
    # select disk
    info_msg "available disks"
    AVAILABLE_DISKS="$(fdisk -l | grep -e "/dev/.*:" --color=always)"
    printf "%s\n" "$AVAILABLE_DISKS"

    info_msg "input disk to use (full path):"
    read -r DISK

    ls $DISK
    if [[ $? -ne 0 ]] ; then
        error_msg "Disk $DISK not available"
        setup_filesystem
    fi

    # delete old partition layout
    info_msg "wiping $DISK"
    wipefs --all --force $DISK
    #sgdisk --zap-all --clear $DISK
    sgdisk -Zo $DISK
    partprobe $DISK

    # fill disk with random data
    if yn_prompt "overwrite data?" ; then
        cryptsetup open --type plain -d /dev/urandom $DISK CRYPTROOT
        dd if=/dev/zero of=/dev/mapper/CRYPTROOT bs=1M status=progress oflag=direct
        cryptsetup close CRYPTROOT
    fi
    partprobe $DISK

    # create partitions
    info_msg "creating partitions"
    sgdisk --new=0:0:+512MiB --typecode=0:ef00 --change-name=0:ESP $DISK # ef00 = EFI system partition
    sgdisk --new=0:0:0 --typecode=0:8309 --change-name=0:CRYPTROOT $DISK # 8309 = LUKS
    partprobe $DISK

    info_msg "new partition table"
    sgdisk -p $DISK

    ESP="/dev/disk/by-partlabel/ESP"
    CRYPTROOT="/dev/disk/by-partlabel/CRYPTROOT"

    # initialize luks root partition
    info_msg "enter luks password"
    read -r LUKS_PASSWORD
    echo -n "$LUKS_PASSWORD" | cryptsetup luksFormat "$CRYPTROOT" -d -
    echo -n "$LUKS_PASSWORD" | cryptsetup open "$CRYPTROOT" cryptroot -d -

    # formatting partitions
    BTRFS="/dev/mapper/cryptroot"
    info_msg "formatting efi partition"
    mkfs.vfat -F 32 "$ESP"
    info_msg "formatting btrfs partition"
    mkfs.btrfs "$BTRFS"

    # create btrfs volumes
    info_msg "creating btrfs subvolumes"
    mount "$BTRFS" /mnt
    btrfs subvolume create /mnt/@home #&>/dev/null
    btrfs subvolume create /mnt/@root #&>/dev/null
    btrfs subvolume create /mnt/@snapshots #&>/dev/null
    btrfs subvolume create /mnt/@var_log #&>/dev/null
    btrfs subvolume create /mnt/@var_pkgs #&>/dev/null

    # mount created volumes
    umount /mnt

    # filesystem-independent mount options (man 8 mount)
    # * rw
    # * noatime
    # filesystem-specific mount options (man 5 btrfs)
    # * compress-force=zstd:XX (1-15) higher=more compression/lower speeds
    # * discard=async does the same as weekly fstrim
    info_msg "mount btrfs volumes"
    MOUNT_OPTIONS="rw,noatime,compress-force=zstd:3,discard=async"
    mount -o "$MOUNT_OPTIONS",subvolid=5 "$BTRFS" /mnt # subvolid=5 == subvol=@
    
    # create mount points
    mkdir -p /mnt/{home,root,snapshots,var/{log,cache/pacman/pkg},boot}

    # mount btrfs volumes in disk
    mount -o "$MOUNT_OPTIONS",subvol=@home "$BTRFS" /mnt/home
    mount -o "$MOUNT_OPTIONS",subvol=@root "$BTRFS" /mnt/root
    mount -o "$MOUNT_OPTIONS",subvol=@snapshots "$BTRFS" /mnt/snapshots
    mount -o "$MOUNT_OPTIONS",subvol=@var_log "$BTRFS" /mnt/var/log
    mount -o "$MOUNT_OPTIONS",subvol=@var_pkgs "$BTRFS" /mnt/var/cache/pacman/pkg
    
    chmod 750 /mnt/root # owner: rwx, group: r-x, other: ---
    chattr +C /mnt/var/log # disable copy-on-write on this folder

    # mount ESP partition
    info_msg "mount efi partition"
    mount "$ESP" /mnt/boot/
}

select_package_mirrors() {
    info_msg "selecting package mirrors"
    pacman -Syy # sync package database
    reflector --verbose \
        --protocol https \
        --latest 5 \
        --sort rate \
        --country Germany \
        --save /etc/pacman.d/mirrorlist
}

install_base_system() {
    # detect microcode
    VENDOR=$(grep vendor_id /proc/cpuinfo)
    if [[ $VENDOR == *"Intel"* ]] ; then
        MICROCODE="intel-ucode"
    elif [[ $VENDOR == *"AMD"* ]] ; then
        MICROCODE="amd-ucode"
    else
        echo "YOUR INSTALL SCRIPT SUCKS!!1!!1!!"
        exit 1
    fi

    pacstrap /mnt \
        base base-devel \
        ${MICROCODE} \
        btrfs-progs \
        linux linux-lts linux-firmware \
        grub efibootmgr \
        cryptsetup \
        man-db neovim \
        networkmanager openssh \
        pacman-contrib pkgfile reflector \
        sudo tmux

    genfstab -U -p /mnt >> /mnt/etc/fstab
}

configure_system() {
    arch-chroot /mnt /bin/bash

    # set timezone and update systemclock
    ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
    hwclock --systohc

    # set hostname
    HOSTNAME="arch"
    echo "$HOSTNAME" > /etc/hostname

    # add matching entries to /etc/hosts
    echo "127.0.0.1 $HOSTNAME" > /etc/hosts
    echo "::1 $HOSTNAME" > /etc/hosts

    # set locale
    LOCALE="en_US.UTF-8"
    sed -i "s/^#\(${LOCALE}\)/\1/" /etc/locale.gen
    echo "LANG=${LOCALE}" > /etc/locale.conf
    locale-gen
    
    # set system-wide environment variables
    # echo "KEY=val" > /etc/environment

    # setup network
    # TODO

    # configure locale and console keymap
    KEYMAP="us"
    sed -i "/^#$LOCALE/s/^#//" /etc/locale.gen
    echo "LANG=$LOCALE" > /etc/locale.conf
    echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf

    # setup mkinitcpio
    echo "FILES=()" > /etc/mkinitcpio.conf # maybe setup keyfile
    echo "MODULES=()" >> /etc/mkinitcpio.conf 
    echo "HOOKS=(systemd keyboard autodetect modconf block sd-vconsole sd-encrypt filesystems fsck)" >> /etc/mkinitcpio.conf
    mkinitcpio -P

    # configure grub
    UUID=$(blkid -s UUID -o value $CRYPTROOT)
    sed -i "\,^GRUB_CMDLINE_LINUX=\"\",s,\",&rd.luks.name=$UUID=cryptroot root=$BTRFS," /mnt/etc/default/grub


}

check_uefi;
internet_connection;
update_system_clock;
setup_filesystem;
select_package_mirrors;
install_base_system;
configure_system;
