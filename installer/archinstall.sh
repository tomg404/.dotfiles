#!/bin/bash

# Disclaimer: This script is my OWN arch bootstrap script
# and configures the system exactly how I want it to be.
# So it may contain things you do not like.
# The script is adapted from various other arch install
# scripts and guides. Most notably:
# - https://github.com/classy-giraffe/easy-arch/
# - https://www.dwarmstrong.org/archlinux-install/

# Text Formatting
RESET='\033[0m'
BOLD='\033[1m'
ITALIC='\033[3m'
UNDERLINE='\033[4m'
BLINK='\033[5m'
INVERSE='\033[7m'
STRIKE='\033[9m'
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
BG_BLACK='\033[40m'
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
BG_MAGENTA='\033[45m'
BG_CYAN='\033[46m'
BG_WHITE='\033[47m'

#############################
# STATUS / HELPER FUNCTIONS #
#############################

# this function handles printing script status.
# arguments: color, message_text, is_input
status_msg() {
    STATUS_COLOR="$1"
    MESSAGE="${WHITE}${BOLD}$2${RESET}"
    PREFIX="${WHITE}${BOLD}[${STATUS_COLOR}install script${WHITE}]${RESET}"
    if [[ "$3" == "input" ]]; then
        echo -ne "$PREFIX $MESSAGE" # without newline at the end
    else
        echo -e "$PREFIX $MESSAGE" # with newline
    fi
}

# arguments: message_text, is_input
info_msg() {
    status_msg "$CYAN" "$1" "$2"
}

# arguments: message_text, is_input
success_msg() {
    status_msg "$GREEN" "$1" "$2"
}

# arguments: message_text, is_input
error_msg() {
    status_msg "$RED" "$1" "$2"
}

# arguments: TODO
yn_prompt() {
    while true; do
        info_msg "$1 ${RESET}([${BOLD}${YELLOW}y${RESET}]es/[${BOLD}${YELLOW}n${RESET}]o):" "input"
        read RESPONSE
        echo ""
        case $RESPONSE in
            [Yy]* ) return 0;;  # Return 0 for yes
            [Nn]* ) return 1;;  # Return 1 for no
            * ) error_msg "Please answer ${YELLOW}yes${RESET} or ${YELLOW}no${RESET}.";;
        esac
    done
}

pw_prompt() {
    MESSAGE="$1"
    info_msg "$MESSAGE" "input"
    read -r -s "PASSWORD"
    echo ""
    info_msg "enter again: " "input"
    read -r -s "PASSWORD_AGAIN"
    echo ""
    if [[ "$PASSWORD" != "$PASSWORD_AGAIN" ]]; then
        error_msg "passwords don't match, please try again!"
        return 1
    fi
    return 0
}

welcome_msg() {
    # toilet -f smbraille "text" --rainbow
    echo -ne "[0;1;35;95m╺┳[0;1;31;91m╸┏[0;1;33;93m━┓[0;1;32;92m┏┳[0;1;36;96m┓╻[0;1;34;94m┏━[0;1;35;95m┓[0m   [0;1;33;93m╻┏[0;1;32;92m┓╻[0;1;36;96m┏━[0;1;34;94m┓╺[0;1;35;95m┳╸[0;1;31;91m┏━[0;1;33;93m┓╻[0m  [0;1;36;96m╻[0m     [0;1;31;91m┏━[0;1;33;93m┓┏[0;1;32;92m━╸[0;1;36;96m┏━[0;1;34;94m┓╻[0;1;35;95m┏━[0;1;31;91m┓╺[0;1;33;93m┳╸[0m\n [0;1;31;91m┃[0m [0;1;33;93m┃[0m [0;1;32;92m┃[0;1;36;96m┃┃[0;1;34;94m┃[0m [0;1;35;95m┗━[0;1;31;91m┓[0m   [0;1;32;92m┃┃[0;1;36;96m┗┫[0;1;34;94m┗━[0;1;35;95m┓[0m [0;1;31;91m┃[0m [0;1;33;93m┣━[0;1;32;92m┫┃[0m  [0;1;34;94m┃[0m     [0;1;33;93m┗━[0;1;32;92m┓┃[0m  [0;1;34;94m┣┳[0;1;35;95m┛┃[0;1;31;91m┣━[0;1;33;93m┛[0m [0;1;32;92m┃[0m\n [0;1;33;93m╹[0m [0;1;32;92m┗[0;1;36;96m━┛[0;1;34;94m╹[0m [0;1;35;95m╹[0m [0;1;31;91m┗━[0;1;33;93m┛[0m   [0;1;36;96m╹╹[0m [0;1;34;94m╹[0;1;35;95m┗━[0;1;31;91m┛[0m [0;1;33;93m╹[0m [0;1;32;92m╹[0m [0;1;36;96m╹┗[0;1;34;94m━╸[0;1;35;95m┗━[0;1;31;91m╸[0m   [0;1;32;92m┗━[0;1;36;96m┛┗[0;1;34;94m━╸[0;1;35;95m╹┗[0;1;31;91m╸╹[0;1;33;93m╹[0m   [0;1;36;96m╹[0m\n"
    yn_prompt "start installation?"
    if [[ $? -eq 1 ]]; then
        exit 1
    fi
}

# enable service for all users
# arguments: service_to_enable
en_service() {
    info_msg "systemctl enable $1"
    systemctl enable "$1" --root /mnt > /dev/null
}

# enable service for a single user\
# arguments: service_to_enable, user
en_service_user() {
    info_msg "systemctl --user enable $1"
arch-chroot /mnt /bin/bash -e <<EOF
    su - "$2"
    systemctl --user enable "$1"
EOF
}

# enable service for single user

##########################
# INSTALLATION FUNCTIONS #
##########################

# Check if system is booted in UEFI mode. If booted
# in BIOS mode end script.
check_uefi() {
    ls /sys/firmware/efi/efivars > /dev/null 2>&1

    if [[ $? -eq 0 ]]; then
        success_msg "booted in uefi mode"
    else
        error_msg "booted in bios mode. please boot in uefi mode"
        exit 1
    fi
}

# this functions checks if internet is connected. if not it starts iwctl.
# after exiting iwctl connection will be checked again.
internet_connection() {
    info_msg "checking connection..."
    ping -c 1 www.google.com > /dev/null 2>&1

    if [[ $? -eq 0 ]]; then
        success_msg "connection established"
    else
        error_msg "internet connection is ${BOLD}${RED}NOT${RESET} available."
        info_msg "please connect to wifi or exit if already connected"
        iwctl
        return 1
    fi
}

update_system_clock() {
    info_msg 'setup system clock...'
    timedatectl set-ntp true
    timedatectl status > /dev/null
    success_msg 'done'
}

# This function selects the main disk and creates
# two partitions: EFI and LUKS. The LUKS partition is
# formatted with the BTRFS filesystem and volumes are
# created and mounted.
setup_filesystem() {
    # select disk
    info_msg "available disks"
    AVAILABLE_DISKS="$(fdisk -l | grep -e "/dev/.*:" --color=always)"
    printf "%s\n" "$AVAILABLE_DISKS"

    info_msg "input disk to use (full path): " "input"
    read -r DISK

    ls $DISK > /dev/null 2>&1
    if [[ $? -ne 0 ]] ; then
        error_msg "Disk $DISK not available"
        return 1
    fi

    # delete old partition layout
    info_msg "wiping $DISK"
    wipefs --all --force $DISK > /dev/null
    #sgdisk --zap-all --clear $DISK > /dev/null 2>&1
    sgdisk -Zo $DISK > /dev/null
    partprobe $DISK > /dev/null

    # fill disk with random data
    if yn_prompt "overwrite data?" ; then
        cryptsetup open --type plain -d /dev/urandom $DISK CRYPTROOT
        info_msg "overwriting ..."
        dd if=/dev/zero of=/dev/mapper/CRYPTROOT bs=1M status=progress oflag=direct
        cryptsetup close CRYPTROOT
    fi
    partprobe $DISK

    # create partitions
    info_msg "creating partitions..."
    sgdisk --new=0:0:+512MiB --typecode=0:ef00 --change-name=0:ESP $DISK # ef00 = EFI system partition
    sgdisk --new=0:0:0 --typecode=0:8309 --change-name=0:CRYPTROOT $DISK # 8309 = LUKS
    partprobe $DISK

    info_msg "new partition table"
    sgdisk -p $DISK

    ESP="/dev/disk/by-partlabel/ESP"
    CRYPTROOT="/dev/disk/by-partlabel/CRYPTROOT"

    # initialize luks root partition
    until pw_prompt "enter LUKS password: "; do : ; done
    echo -n "$PASSWORD" | cryptsetup luksFormat "$CRYPTROOT" -d -
    echo -n "$PASSWORD" | cryptsetup open "$CRYPTROOT" cryptroot -d -

    # formatting partitions
    BTRFS="/dev/mapper/cryptroot"
    info_msg "formatting efi partition..."
    mkfs.vfat -F 32 "$ESP"
    info_msg "formatting btrfs partition..."
    mkfs.btrfs "$BTRFS"

    # create btrfs volumes
    info_msg "creating btrfs subvolumes..."
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
    info_msg "mount btrfs volumes..."
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
    info_msg "selecting package mirrors..."
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

    MAIN_KERNEL="linux"
    info_msg "installing base system ..."
    
    # todo : test
    sed -i "s/^#ParallelDownloads.*/ParallelDownloads = 10/" /etc/pacman.conf # enabling TUUUURBOOOO
    pacman-key --init
    pacman -Sy
    pacman -S archlinux-keyring --noconfirm
    
    pacstrap -K /mnt \
        base base-devel \
        "$MICROCODE" \
        "$MAIN_KERNEL" "$MAIN_KERNEL"-headers linux-firmware \
        btrfs-progs grub grub-btrfs snapper efibootmgr \
        pacman-contrib reflector \
        sudo git

    genfstab -U -p /mnt >> /mnt/etc/fstab
    success_msg "done installing base system"
}

configure_system() {
    # === set timezone and update systemclock
    arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
    arch-chroot /mnt hwclock --systohc

    # === set hostname
    info_msg "input hostname: " "input"
    read -r HOSTNAME
    echo "$HOSTNAME" > /mnt/etc/hostname

    # add matching entries to /etc/hosts
    echo "127.0.0.1 $HOSTNAME" > /mnt/etc/hosts
    echo "::1 $HOSTNAME" > /mnt/etc/hosts

    # === set locale
    info_msg "configuring locale"
    LOCALE="en_US.UTF-8"
    KEYMAP="us"
    sed -i "/^#$LOCALE/s/^#//" /mnt/etc/locale.gen
    echo "LANG=$LOCALE" > /mnt/etc/locale.conf
    echo "KEYMAP=$KEYMAP" > /mnt/etc/vconsole.conf
    arch-chroot /mnt locale-gen > /dev/null
    
    # === setup system-wide environment variables
    # echo "KEY=val" > /etc/environment

    # === setup network
    info_msg "configuring network"
    pacstrap /mnt networkmanager iwd > /dev/null
    echo "[device]" > /mnt/etc/NetworkManager/conf.d/wifi_backend.conf
    echo "wifi.backend=iwd" >> /mnt/etc/NetworkManager/conf.d/wifi_backend.conf
    en_service "NetworkManager"

    # === setup users
    info_msg "setup users"
    until pw_prompt "enter root password: "; do : ; done
    echo "root:$PASSWORD" | arch-chroot /mnt chpasswd

    echo "%wheel ALL=(ALL:ALL) ALL" > /mnt/etc/sudoers.d/wheel
    info_msg "enter username:" "input"
    read -r USER_NAME
    arch-chroot /mnt useradd -m -G wheel -s /bin/bash "$USER_NAME"

    until pw_prompt "enter user password: "; do : ; done
    echo "$USER_NAME:$PASSWORD" | arch-chroot /mnt chpasswd
    success_msg "set root password and created $USER_NAME with root privileges"

    # === luks setup keyfile (password needed only once)
    info_msg "generating keyfile for LUKS"
    KEYFILE="/luks_keyfile.bin"
    dd bs=512 count=4 iflag=fullblock if=/dev/random of=/mnt/$KEYFILE
    chmod 600 /mnt/$KEYFILE
    info_msg "input password of your LUKS container:"
    cryptsetup luksAddKey $CRYPTROOT /mnt/$KEYFILE

    # === mkinitcpio
    info_msg "generating initramfs"
    echo "FILES=($KEYFILE)" > /mnt/etc/mkinitcpio.conf
    echo "MODULES=(btrfs)" >> /mnt/etc/mkinitcpio.conf 
    echo "HOOKS=(systemd keyboard autodetect modconf block sd-vconsole sd-encrypt filesystems fsck)" >> /mnt/etc/mkinitcpio.conf
    arch-chroot /mnt mkinitcpio -P # recreate initramfs

    # === configure grub
    info_msg "configuring grub"
    UUID=$(blkid -s UUID -o value $CRYPTROOT)
    sed -i "\,^GRUB_CMDLINE_LINUX=\"\",s,\",&rd.luks.name=$UUID=cryptroot root=$BTRFS," /mnt/etc/default/grub # `\,` at the start changes the default sed delimiter (`/`) to `,`
    info_msg "installing grub"
    arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/ --bootloader-id=GRUB
    arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

    # === configure pacman
    info_msg "configuring pacman"
    sed -i "s/^#ParallelDownloads.*/ParallelDownloads = 10/" /mnt/etc/pacman.conf
    sed -i "s/^#Color/Color\nILoveCandy/" /mnt/etc/pacman.conf

    # === enabling services
    en_service "reflector.timer"              # refresh pacman mirrors in certain interval (configure in /usr/lib/systemd/system/reflector.timer)
    en_service "btrfs-scrub@-.timer"         # btrfs scrub runs by default
    en_service "btrfs-scrub@home.timer"      # once every month and identifies and 
    en_service "btrfs-scrub@var-log.timer"   # repairs corrupt data
    en_service "btrfs-scrub@snapshots.timer" # escape paths with `systemd-escape -p /path/to/mountpoint`

    # === install yay
    info_msg "installing yay"
arch-chroot /mnt /bin/bash -e <<EOF
    su - "$USER_NAME"
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin
    makepkg -si
EOF

    # TODO: change shell to zsh
}

configure_system_more() {
    yn_prompt "now you have a working and fully encrypted arch system. install and configure more programs?"
    if [[ $? -eq 1 ]]; then
        success_msg "have fun :)"
        exit 0
    fi

    # === install desktop environment
    yn_prompt "install usable i3 desktop environment (with often used programs)?"
    if [[ $? -eq 0 ]]; then
        info-msg "installing i3 de..."
        pacstrap /mnt \
            acpilight alsa-firmware arandr bat blueberry bluez bluez-utils dmenu dunst \
            eza feh firefox flameshot fprintd git i3-wm keepassxc kitty lightdm lightdm-gtk-greeter neovim \
            networkmanager-openvpn networkmanager-vpnc obsidian okular openssh papirus-icon-theme \
            pavucontrol picom polybar pulseaudio rofi sof-firmware stow thunar thunar-volman \
            tlp tlp-rdw tmux ttf-firacode-nerd ueberzug xclip xdg-user-dirs xdg-utils \
            xss-lock xterm xtrlock zsh zsh-autosuggestions zsh-syntax-highlighting
            # TODO: add packages missing when starting i3
        success_msg "done installing!"
        
        en_service "lightdm"
        en_service_user "ssh-agent" "$USER_NAME"
    fi
    
    # === clone dotfiles

}

welcome_msg;
check_uefi;
until internet_connection; do : ; done
update_system_clock;
until setup_filesystem; do : ; done
select_package_mirrors;
install_base_system;
configure_system;
configure_system_more;