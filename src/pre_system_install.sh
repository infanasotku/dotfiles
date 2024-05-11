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
