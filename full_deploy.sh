#!/bin/bash

# Set script to fail on any errors
set -e

# Start Vagrant (equivalent to vagrant up)
echo "Starting Vagrant..."
vagrant up

# Remove old SSH keys for hadoop@master and workers
echo "Removing old SSH keys..."
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "master" 2>/dev/null || true
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "worker1" 2>/dev/null || true
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "worker2" 2>/dev/null || true
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "worker3" 2>/dev/null || true

# Re-add SSH keys by establishing connections
echo "Re-adding SSH keys for nodes..."
ssh-keyscan -H master >> "$HOME/.ssh/known_hosts"
ssh-keyscan -H worker1 >> "$HOME/.ssh/known_hosts"
ssh-keyscan -H worker2 >> "$HOME/.ssh/known_hosts"
ssh-keyscan -H worker3 >> "$HOME/.ssh/known_hosts"

# Execute the Ansible script
echo "Executing Ansible playbook..."
ansible-playbook -i inventory.ini -u hadoop -K all.yml -T 30

echo "Process completed successfully!"

