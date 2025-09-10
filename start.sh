#!/bin/bash

# Set timezone
export DEBIAN_FRONTEND=noninteractive
ln -fs /usr/share/zoneinfo/Asia/Kathmandu /etc/localtime
dpkg-reconfigure -f noninteractive tzdata

# Open ports 443 and 8444 using iptables
echo "🔓 Opening ports 443 and 8444..."
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 8444 -j ACCEPT

# Start tmate session
tmate -S /tmp/tmate.sock new-session -d
tmate -S /tmp/tmate.sock wait tmate-ready

# Display connection info
echo "✅ SSH access:"
tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}'
echo "🌐 Web access (read-write):"
tmate -S /tmp/tmate.sock display -p '#{tmate_web}'

# Infinite loop without delay (be careful – no sleep at all)
echo "🔁 Keeping session alive..."
while true; do
    tmate -S /tmp/tmate.sock send-keys "echo alive && date" C-m
done

