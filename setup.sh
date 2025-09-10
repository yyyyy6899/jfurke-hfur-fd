#!/bin/bash

# Make self executable (optional safety)
SCRIPT_PATH="$(realpath "$0")"
chmod +x "$SCRIPT_PATH"

# Exit on error
set -e

# Get current user and path
USER_NAME=$(whoami)
INSTALL_PATH=$(pwd)

echo "📦 Installing dependencies..."
sudo apt-get update
sudo apt-get install -y tmate tzdata expect ufw

echo "🌐 Setting timezone to Asia/Kathmandu..."
sudo ln -fs /usr/share/zoneinfo/Asia/Kathmandu /etc/localtime
sudo dpkg-reconfigure -f noninteractive tzdata

echo "🔓 Opening ports 8444 and 443..."
sudo ufw allow 8444/tcp
sudo ufw allow 443/tcp
sudo ufw reload

echo "🧹 Making start.sh executable..."
chmod +x "$INSTALL_PATH/start.sh"

echo "⚙️ Creating systemd service for persistent tmate session..."

SERVICE_CONTENT="[Unit]
Description=Persistent tmate session
After=network.target

[Service]
ExecStart=$INSTALL_PATH/start.sh
Restart=always
User=$USER_NAME

[Install]
WantedBy=multi-user.target"

echo "$SERVICE_CONTENT" | sudo tee /etc/systemd/system/tmate-session.service > /dev/null

echo "🔁 Reloading and enabling tmate service..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable tmate-session
sudo systemctl start tmate-session

echo ""
echo "✅ All done!"
echo "📜 To check logs: sudo journalctl -u tmate-session -f"
echo "🚀 tmate session is now running as a background service."
