#!/bin/bash

in="${1}"
out="${in/.qcow2/.raw}"

qemu-img convert -O raw "${in}" "${out}"



