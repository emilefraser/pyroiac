#!/bin/sh -eux

# set a default HOME_DIR environment variable if not set
HOME_DIR="${HOME_DIR:-/home/armand}";

case "$PACKER_BUILDER_TYPE" in
virtualbox-iso|virtualbox-ovf)
    apk add virtualbox-guest-additions virtualbox-guest-modules-virt
    ;;
esac
