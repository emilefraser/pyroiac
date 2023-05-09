#!/bin/bash

disk="${1}"
size="${2}"

qemu-img create -f raw -o size ${size} ${disk}
