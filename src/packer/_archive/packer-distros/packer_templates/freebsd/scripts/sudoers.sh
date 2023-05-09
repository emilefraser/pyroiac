#!/bin/sh -eux

pkg install -y sudo;
echo "armand ALL=(ALL) NOPASSWD: ALL" >>/usr/local/etc/sudoers;
