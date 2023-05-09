#!/bin/sh
# These were only needed for building VMware/Virtualbox extensions:
zypper --non-interactive rm --clean-deps gcc kernel-default-devel
zypper clean

# Clean up network interface persistence
# rm -f /etc/udev/rules.d/70-persistent-net.rules;
# touch /etc/udev/rules.d/75-persistent-net-generator.rules;

# http://www.vcritical.com/2010/10/getting-eth0-back-in-a-sles-for-vmware-clone/
grep -v eth /etc/udev/rules.d/70-persistent-net.rules >/tmp/net.rules
mv /tmp/net.rules /etc/udev/rules.d/70-persistent-net.rules

# remove NAME= field to allow different network card to appear
cat <<ETH0 > /etc/sysconfig/network/ifcfg-eth0 
BOOTPROTO='dhcp'
STARTMODE='auto'
USERCONTROL='no'
ETH0

# truncate any logs that have built up during the install
find /var/log -type f -exec truncate --size=0 {} \;

# remove the contents of /tmp and /var/tmp
rm -rf /tmp/* /var/tmp/*

# clear the history so our install isn't there
export HISTSIZE=0
rm -f /root/.wget-hsts

#!/bin/bash -eux


