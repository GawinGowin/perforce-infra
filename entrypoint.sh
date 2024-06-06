#!/bin/bash
chown -R perforce:perforce ${P4D_ROOT}
/opt/perforce/sbin/configure-helix-p4d.sh master -n -r ${P4D_ROOT} -p ${PORT} -P ${P4D_PASSWORD} --unicode

p4dctl start master

tail -F ${P4D_ROOT}/logs/log
