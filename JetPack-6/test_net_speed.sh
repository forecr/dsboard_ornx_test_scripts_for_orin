#!/bin/bash
echo "Available Networks:"
ip -br address | grep UP
read -p "Enter the network name: " net_name
sudo ethtool $net_name | grep Speed
read -p 'Press [Enter] to exit' quit_key

