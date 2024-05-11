#!/bin/bash

hostname=$1
username=$2

ln -sf /usr/share/zoneinfo/Asia/Novosibirsk /etc/localtime
hwclock —systohc
echo "LANG=en_US.UTF-8 UTF-8
LANG=ru_RU.UTF-8 UTF-8" | tee /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo $hostname > /etc/hostname
echo "127.0.0.1    localhost" >> /etc/hosts
echo "::1          localhost" >> /etc/hosts
echo "127.0.0.1    $hostname.localdomain    $hostname" >> /etc/hosts
pacman -S --noconfirm sudo
EDITOR=nano
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers # dirty

# Boot
pacman -S --noconfirm grub
pacman -S --noconfirm efibootmgr dosfstools os-prober mtools
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub # dirty
mkdir /boot/efi
mount /dev/nvme0n1p3 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
grub-mkconfig -o /boot/grub/grub.cfg

# Net
pacman -S --noconfirm dhcpcd

# User settings
useradd -m -g users -G audio,lp,optical,power,scanner,storage,video,wheel -s /bin/bash $username
echo "Enter root password:"
passwd
echo "Enter $username password:"
passwd $username