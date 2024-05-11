#!/bin/bash

# Input params
echo -n "Enter hostname: "
read hostname

echo -n "Enter username: "
read username

# Date
timedatectl set-ntp true
timedatectl set-timezone Asia/Novosibirsk

# Format disk
mkfs.fat -F32 /dev/nvme0n1p3
mkfs.ext4 -F /dev/nvme0n1p1
mkfs.ext4 -F /dev/nvme0n1p2

# Mounting
mount /dev/nvme0n1p1 /mnt
mkdir /mnt/efi
mkdir /mnt/home
mount /dev/nvme0n1p3 /mnt/efi
mount /dev/nvme0n1p2 /mnt/home

# Installing kernel
pacstrap /mnt base linux linux-firmware nano git linux-headers

# System settings
genfstab -U /mnt >> /mnt/etc/fstab
# under chroot
{
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
} | arch-chroot /mnt
