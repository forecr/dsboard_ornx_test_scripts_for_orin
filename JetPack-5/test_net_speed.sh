#!/bin/bash
echo "Available Networks:"
ip -br address | grep UP
echo "Selecting eth0"
sudo ethtool eth0 | grep Speed
read -p 'Press [Enter] to exit' quit_key

