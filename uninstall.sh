#!/usr/bin/bash
#
# Uninstall the linux-hostinfo service
#

#print info in blue color
sudo systemctl stop linux-hostinfo
sudo systemctl disable linux-hostinfo

sudo rm -f /etc/systemd/system/linux-hostinfo.service
sudo rm -f linux-hostinfo.sh /usr/local/bin/linux-hostinfo.sh
sudo rm -f hostinfo.yaml /etc/linux-hostinfo/hostinfo.yaml