#!/bin/sh -eux

# Set user
USER=armand

# set a default HOME_DIR environment variable if not set
HOME_DIR="${HOME_DIR:-/home/$USER}";

# Set correct permissions in case
chown -R $USER:$USER /home/$USER/

# Get public key
pubkey_url="https://gist.githubusercontent.com/armsultan/80af823619061b9d4e2d302d4373f8af/raw/a0a63919d716ab59e37486d2bc1215d23391c67f/id_rsa.pub";
mkdir -p $HOME_DIR/.ssh;
if command -v wget >/dev/null 2>&1; then
    wget --no-check-certificate "$pubkey_url" -O $HOME_DIR/.ssh/authorized_keys;
elif command -v curl >/dev/null 2>&1; then
    curl --insecure --location "$pubkey_url" > $HOME_DIR/.ssh/authorized_keys;
elif command -v fetch >/dev/null 2>&1; then
    fetch -am -o $HOME_DIR/.ssh/authorized_keys "$pubkey_url";
else
    echo "Cannot download $USER public key";
    exit 1;
fi

# Set correct permissions
chown -R $USER $HOME_DIR/.ssh;
chmod -R go-rwsx $HOME_DIR/.ssh;