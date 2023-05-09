#!/bin/bash

DEV_PACKAGES="
build-essential
curl
emacs24-nox
htop
nmon
slurm
tcpdump
unzip
"

ESSENTIAL_PACKAGES="aria2"

echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections

if [[ $INSTALL_DEV_PACKAGES  == true ]] || [[ $INSTALL_DEV_PACKAGES == 1 ]] || [[ $INSTALL_DEV_PACKAGES == yes ]] ; then
  sudo apt-get -y -q install "$DEV_PACKAGES"
fi

sudo apt-get -y -q install "$ESSENTIAL_PACKAGES"

