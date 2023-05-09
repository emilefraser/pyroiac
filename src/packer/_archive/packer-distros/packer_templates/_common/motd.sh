#!/bin/sh -eux

custom=' This is a system is built by packer based on the Bento project by Chef
Software. More information can be found at https://www.packer.io and
https://github.com/chef/bento'

if [ -d /etc/update-motd.d ]; then
    MOTD_CONFIG='/etc/update-motd.d/99-custom'

    cat >> "$MOTD_CONFIG" <<CUSTOM
#!/bin/sh

cat <<'EOF'
$custom
EOF
CUSTOM

    chmod 0755 "$MOTD_CONFIG"
else
    echo "$custom" >> /etc/motd
fi
