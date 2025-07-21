#!/bin/bash
# Proxmox no-subsscription hack
set -euo pipefail

filename=/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js

# Finde die erste Zeile mit checked_command
first_line=$(grep -n -m1 'checked_command' "$filename" | cut -d':' -f1)
# Hole die Einrückung der Startzeile
indent=$(sed -n "${first_line}p" "$filename" | grep -o '^[[:space:]]*')
# Suche ab first_line die erste Zeile, die mit identischer Einrückung und '},' endet
last_line=$(( $(tail -n "+${first_line}" "$filename" | grep -nxm1 "^${indent}},$" | cut -d':' -f1) + first_line - 1 ))

# Entferne den Block
sed -i "${first_line},${last_line}d" "$filename"

# Füge die neue checked_command-Funktion an der richtigen Stelle ein
insert_line=$(( first_line - 1 ))
ex "$filename" <<eof
${insert_line} insert
${indent}checked_command: function(orig_cmd) { orig_cmd(); },
.
xit
eof
