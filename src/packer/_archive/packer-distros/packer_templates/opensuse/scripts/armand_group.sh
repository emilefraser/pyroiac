#!/bin/sh -eux

# User 'armand' belogs to the 'users' group by default so we need to
# create a new group 'armand' and put our user there.

groupadd -f armand
gpasswd -a armand armand
