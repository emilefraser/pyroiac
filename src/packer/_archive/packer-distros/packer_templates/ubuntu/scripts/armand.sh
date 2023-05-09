#!/bin/bash -eux

pubkey_url="https://gist.githubusercontent.com/armsultan/80af823619061b9d4e2d302d4373f8af/raw/a0a63919d716ab59e37486d2bc1215d23391c67f/id_rsa.pub";
mkdir -p $HOME_DIR/.ssh;
if command -v wget >/dev/null 2>&1; then
    wget --no-check-certificate "$pubkey_url" -O $HOME_DIR/.ssh/authorized_keys;
elif command -v curl >/dev/null 2>&1; then
    curl --insecure --location "$pubkey_url" > $HOME_DIR/.ssh/authorized_keys;
else
    echo "Cannot download armand public key";
    exit 1;
fi
chown -R armand $HOME_DIR/.ssh;
chmod -R go-rwsx $HOME_DIR/.ssh;
