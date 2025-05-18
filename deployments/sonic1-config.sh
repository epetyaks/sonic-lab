#!/bin/bash

TELNET_HOST="127.0.0.1"
TELNET_PORT="7001"
SWITCH_USER="admin"
SWITCH_PASS="YourPaSsWoRd"
NEW_SWITCH_PASS="admin"
SWITCH_IP="172.16.181.11"
LOCAL_CONFIG_FILE="./deployments/sonic-kvm-xml/config_db_01.json"
REMOTE_CONFIG_FILE="/home/admin/config_db_01.json"
FINAL_CONFIG_LOCATION="/etc/sonic/config_db.json"


send_telnet_commands() {
    {   
        sleep 2
        echo "$SWITCH_USER"
        sleep 2
        echo "$SWITCH_PASS"
        sleep 2
        echo "sudo ip addr add $SWITCH_IP/24 dev eth0"
        sleep 2
        echo "echo '$SWITCH_USER:$(perl -e "print crypt(\"$NEW_SWITCH_PASS\", \"salt\")")' | sudo chpasswd -e"
        sleep 2
        echo "exit"
    } | telnet $TELNET_HOST $TELNET_PORT
}

echo "Configuring virtual switch via telnet..."
send_telnet_commands

echo "Waiting for network configuration to stabilize..."
sleep 5

echo "Copying configuration file to the switch..."
sshpass -p "$NEW_SWITCH_PASS" scp -o StrictHostKeyChecking=no \
  -o UserKnownHostsFile=/dev/null \
  "$LOCAL_CONFIG_FILE" \
  "$SWITCH_USER@$SWITCH_IP:$REMOTE_CONFIG_FILE"

# SSH to the switch and move the config file
echo "Moving configuration file to final location and rebooting..."
sshpass -p "$NEW_SWITCH_PASS" ssh \
  -o StrictHostKeyChecking=no \
  -o UserKnownHostsFile=/dev/null \
  "$SWITCH_USER@$SWITCH_IP" \
  "sudo mv $REMOTE_CONFIG_FILE $FINAL_CONFIG_LOCATION; sudo reboot"

echo "Switch configuration complete. The device is now rebooting."