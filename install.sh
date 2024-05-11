#!/bin/bash

# Input params
echo -n "Enter hostname: "
read hostname

echo -n "Enter username: "
read username

# Intalling system core.
src/pre_system_install.sh
# Configuring installed core.
mkdir /mnt/installing
cp src/system_install.sh /mnt/installing/
arch-chroot /mnt /installing/system_install.sh $hostname $username
rm /mnt/installing/system_install.sh

# Installing packages.
# TODO: Complete install package script

# End
reboot