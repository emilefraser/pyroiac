#!/bin/sh -eux

#apk add libressl
apk add openssl
apk add open-vm-tools
rc-update add open-vm-tools
/etc/init.d/open-vm-tools start