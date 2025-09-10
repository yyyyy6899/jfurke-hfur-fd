#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
ln -fs /usr/share/zoneinfo/Asia/Kathmandu /etc/localtime
dpkg-reconfigure -f noninteractive tzdata

tmate -S /tmp/tmate.sock new-session -d
tmate -S /tmp/tmate.sock wait tmate-ready

echo "SSH access:"
tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}'
echo "Web access (read-write):"
tmate -S /tmp/tmate.sock display -p '#{tmate_web}'

while true; do
    tmate -S /tmp/tmate.sock send-keys "echo alive && date" C-m
    sleep 300
done
