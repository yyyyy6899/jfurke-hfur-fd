#!/bin/bash

set -e

# Detect user
USER_NAME=$(whoami)
INSTALL_PATH="/home/$USER_NAME/tmate-auto"  # adjust if you clone elsewhere

# Install packages
sudo apt-get update && \
sudo apt-get install -y tmate tzdata expect ufw

# Set timezone
sudo ln -fs /usr/share/zoneinfo/Asia/Kathmandu /etc/localtime
sudo dpkg-reconfigure -f noninteractive tzdata

# Open ports
sudo ufw allow 8444/tcp
sudo ufw allow 443/tcp
sudo ufw reload

# Make start.sh executable
chmod +x "$INSTALL_PATH/start.sh"

# Copy systemd service and set correct paths
SERVICE_PATH="/etc/systemd/system/tmate-session.service"
sudo cp "$INSTALL_PATH/tmate-session.service" "$SERVICE_PATH"
sudo sed -i "s|/home/youruser/tmate-auto|$INSTALL_PATH|g" "$SERVICE_PATH"
sudo sed -i "s|User=youruser|User=$USER_NAME|g" "$SERVICE_PATH"

# Reload and start service
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable tmate-session
sudo systemctl start tmate-session

echo "✅ Setup complete. tmate session started."
echo "ℹ️  You can check logs with: sudo journalctl -u tmate-session -f"
