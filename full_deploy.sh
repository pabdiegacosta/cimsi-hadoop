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
echo "Executing Ansible playbook for Hadoop and Spark configuration..."
ansible-playbook -i inventory.ini -u hadoop configuration.yml -T 30

echo "Process completed successfully!"

read -p "Continue with executing word2vec task on Spark nodes? (Y/N): " confirm && [[ $confirm == [yY] ]] || [[ $confirm == [yY][eE][sS] ]] || exit 0

read -p "Enter input text for word2vec: " input_text

input_name="${input_text%.*}"

output_csv="${input_name}.csv"
output_image="${input_name}.png"

echo "Input text file used: $input_text"
echo "Output vectors csv file used: $output_csv"
echo "Output vectors image file used: $output_image"

ansible-playbook -i inventory.ini -u hadoop spark_task.yml -T 30 --extra-vars "input_text=${input_text} output_csv=${output_csv} output_image=${output_image}" || exit 1

gio open $output_image
