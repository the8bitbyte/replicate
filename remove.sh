#!/bin/bash

# Confirm with the user before proceeding
read -p "Are you sure you want to completely remove OpenVPN and undo all changes? This will delete configurations, certificates, and keys. (y/n): " choice
if [[ "$choice" != "y" ]]; then
  echo "Aborting the process."
  exit 1
fi

# Stop the OpenVPN service if it's running
echo "Stopping OpenVPN service..."
sudo systemctl stop openvpn@server

# Disable OpenVPN service on boot
echo "Disabling OpenVPN service on boot..."
sudo systemctl disable openvpn@server

# Remove OpenVPN package and dependencies
echo "Removing OpenVPN..."
sudo apt-get purge --auto-remove openvpn -y

# Remove OpenVPN configuration files
echo "Removing OpenVPN configuration files..."
sudo rm -rf /etc/openvpn

# Revert UFW changes (allow OpenVPN port and any other related rules)
echo "Reverting UFW changes..."
sudo ufw delete allow 1194/udp
sudo ufw delete allow OpenSSH
sudo ufw reload

# Remove Easy-RSA files if they were used
if [ -d "$HOME/openvpn-ca" ]; then
  echo "Removing Easy-RSA directory..."
  rm -rf $HOME/openvpn-ca
fi

# Clean up the OpenVPN logs (optional)
echo "Cleaning up OpenVPN logs..."
sudo rm -rf /var/log/openvpn.log

# Optionally, remove any client configuration files if you created them
echo "Removing client configuration files..."
# Adjust the path if you saved .ovpn files elsewhere
sudo rm -rf /root/*.ovpn

# Check and confirm UFW status
echo "Rechecking UFW status..."
sudo ufw status verbose

echo "OpenVPN and all related configurations have been removed successfully."

