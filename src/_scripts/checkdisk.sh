#!/bin/bash

in="${1}"

qemu-img check "${in}"
