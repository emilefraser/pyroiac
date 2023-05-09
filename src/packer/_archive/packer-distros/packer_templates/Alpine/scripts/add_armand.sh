#!/bin/sh -eux

USER=armand

# set a default HOME_DIR environment variable if not set
HOME_DIR="/home/$USER";
adduser -D -H -h $HOME_DIR $USER
echo $USER:$USER | chpasswd
chown -R $USER:$USER /home/$USER/
