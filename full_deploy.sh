#!/bin/bash

# Set script to fail on any errors
set -e

# Start Vagrant (equivalent to vagrant up)
echo "Starting Vagrant..."
vagrant up

# Remove old SSH keys for hadoop@master and workers
echo "Removing old SSH keys..."
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "master" >/dev/null 2>&1 || true
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "worker1" >/dev/null 2>&1 || true
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "worker2" >/dev/null 2>&1 || true
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "worker3" >/dev/null 2>&1 || true

# Re-add SSH keys by establishing connections
echo "Re-adding SSH keys for nodes..."
ssh-keyscan master >> "$HOME/.ssh/known_hosts" 2>/dev/null
ssh-keyscan worker1 >> "$HOME/.ssh/known_hosts" 2>/dev/null
ssh-keyscan worker2 >> "$HOME/.ssh/known_hosts" 2>/dev/null
ssh-keyscan worker3 >> "$HOME/.ssh/known_hosts" 2>/dev/null

# Execute the configuration playbook
echo "Executing Ansible playbook for Hadoop and Spark configuration..."
ansible-playbook -i inventory.ini -u hadoop configuration.yml -T 30

echo "Process completed successfully!"

# Execute the word2vec task on Spark node if user confirms
read -p "Continue with executing Word2Vec task on Spark nodes? (Y/N): " \
  confirm && [[ "$confirm" =~ ^[yY]$ || "$confirm" =~ ^[yY][eE][sS]$ ]] || exit 1
echo "Skipping service restart..."

read -p "Enter input textfile name you want to use for Word2Vec: " input_text || exit 1

input_name="${input_text%.*}"
output_csv="${input_name}.csv"
output_image="${input_name}.png"

echo
echo "Input text file used: $input_text"
echo "Output vectors csv file used: $output_csv"
echo "Output vectors image file used: $output_image"
echo

ansible-playbook -i inventory.ini -u hadoop spark_task.yml -T 30 \
  --extra-vars "input_text=${input_text} output_csv=${output_csv} output_image=${output_image} \
  start_services_flag=false"
gio open $output_image
