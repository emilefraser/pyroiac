#!/bin/sh -eux

sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers;

# Set up password-less sudo for the armand user
echo 'armand ALL=(ALL) NOPASSWD:ALL' >/etc/sudoers.d/99_armand;
chmod 440 /etc/sudoers.d/99_armand;
