#!/bin/bash

in="${1}"
out="${in/.qcow2/}"

qemu-img convert -f qcow2 -O raw "${in}" "${out}"
