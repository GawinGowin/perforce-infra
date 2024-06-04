#!/bin/bash
P4D_PASSWORD=${P4D_PASSWORD:-default_password}

/opt/perforce/sbin/configure-helix-p4d.sh master -n -p tcp:1666 -P ${P4D_PASSWORD} --unicode

p4dctl start master

tail -F /opt/perforce/servers/master/logs/log
