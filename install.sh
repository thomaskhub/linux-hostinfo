#!/usr/bin/bash
#
# Install the script 
#
INSTALL_PATH=/usr/local/bin/linux-hostinfo.sh
CFG_PATH=/etc/linux-hostinfo
GIT_RAW_URL_SYSTEMD=https://raw.githubusercontent.com/thomaskhub/linux-hostinfo/main/linux-hostinfo.service

#
# Prepare installation 
#
mkdir -p $CFG_PATH

cp linux-hostinfo.sh $INSTALL_PATH
chmod +x $INSTALL_PATH

# Downlaod linux-hostinfo.service from raw github url with curl into the /tmo directory 
# and copy it to systemd
curl -o /tmp/linux-hostinfo.service $GIT_RAW_URL_SYSTEMD
cp /tmp/linux-hostinfo.service /etc/systemd/system


#
# Enable and start the systemd service 
#
systemctl daemon-reload
systemctl enable linux-hostinfo
systemctl start linux-hostinfo






