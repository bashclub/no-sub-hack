#!/bin/bash
# Proxmox no-subsscription hack
filename=/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
cat ${filename} | grep "checked_command: function(orig_cmd) { orig_cmd(); }," > /dev/null
if [ $? -gt 0 ]; then
    first_line=$(cat ${filename}  | grep -n -m1 checked_command | cut -d ':' -f1)
    last_line=$(( $(tail -n "+${first_line}" ${filename} | grep -xnm1 '    },' | cut -d':' -f1) + $first_line ))
    sed -i ${first_line},${last_line}d ${filename}
    insert_line=$(( ${first_line} - 1 ))
    ex ${filename} <<eof
${insert_line} insert
    checked_command: function(orig_cmd) { orig_cmd(); },
.
xit
eof
fi
