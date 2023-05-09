#!/bin/bash

in="${1}"
out="${in/.qcow2/.vdi}"

qemu-img convert -O vdi "${in}" "${out}"
