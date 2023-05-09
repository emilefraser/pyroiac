#!/bin/bash

in="${1}"
out="${in/.qcow2/.vhdx}"

qemu-img convert -O vhdx -o subformat=dynamic "${in}" "${out}"
