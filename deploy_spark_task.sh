#!/bin/bash
# Set script to fail on any errors
set -e

read -p "Enter input textfile name you want to use for Word2Vec: " input_text || exit 1

input_name="${input_text%.*}"
output_csv="${input_name}.csv"
output_image="${input_name}.png"

echo
echo "Input text file used: $input_text"
echo "Output vectors csv file used: $output_csv"
echo "Output vectors image file used: $output_image"
echo

read -p "Do you want to restart all services before starting the Spark task? (Y/N): " \
  confirm || exit 1

start_services_flag=false
if [[ "$confirm" =~ ^[yY]$ || "$confirm" =~ ^[yY][eE][sS]$ ]]; then
    start_services_flag=true
fi

ansible-playbook -i inventory.ini -u hadoop spark_task.yml -T 30 \
  --extra-vars "input_text=${input_text} output_csv=${output_csv} output_image=${output_image} \
  start_services_flag=${start_services_flag}"

gio open $output_image
