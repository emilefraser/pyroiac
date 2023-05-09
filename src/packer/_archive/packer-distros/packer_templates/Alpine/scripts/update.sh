#!/bin/sh -eux

echo http://dl-cdn.alpinelinux.org/alpine/v3.12/community >> /etc/apk/repositories

#
# Note, apk does *NOT* set exit code to non-zero when
# an error occurs. Which seems to be fairly frequent...
# TODO: fix this when new apk which *does* exit correctly
# is released to main.
#

#
# give update/upgrade three attempts
#
for i in `seq 3`; do

    apk update
    #apk upgrade -U --available

done

apk add sudo
apk add -U curl