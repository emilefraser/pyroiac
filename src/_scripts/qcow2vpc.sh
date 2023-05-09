#!/bin/bash

in="${1}"
out="${in/.qcow2/.vpc}"

qemu-img convert -O vpc "${in}" "${out}"
