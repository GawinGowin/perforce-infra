#!/bin/bash
/opt/perforce/sbin/configure-helix-p4d.sh master -n -r ${P4D_ROOT} -p tcp:${PORT} -P ${P4D_PASSWORD} --unicode

p4dctl start master

tail -F /opt/perforce/servers/master/logs/log
