#!/bin/bash

in="${1}"
out="${in/.qcow2/.vmdk}"

qemu-img convert -O vmdk "${in}" "${out}"
