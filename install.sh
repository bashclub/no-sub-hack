#!/bin/bash

mkdir -p /opt/bashclub
cp ./no-sub-hack.sh /opt/bashclub
cp ./80bashclubapthook /etc/apt/apt.conf.d/
chmod +x /opt/bashclub/no-sub-hack.sh
