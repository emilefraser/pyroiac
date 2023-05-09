#!/bin/sh -eux


apk add sudo
USER=armand

# Add user to wheel
adduser $USER wheel
echo "Defaults exempt_group=wheel" > /etc/sudoers
echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers