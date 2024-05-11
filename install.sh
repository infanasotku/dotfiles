#!/bin/bash

# Main script

# Intalling system core.
./src/pre_system_install.sh
# Configuring installed core.
cp src/system_install.sh /mnt/tmp/
arch-chroot /mnt ./tmp/system_install.sh
rm /mnt/tmp/system_install.sh

# Installing packages.
# TODO: Complete install package script

# End
reboot