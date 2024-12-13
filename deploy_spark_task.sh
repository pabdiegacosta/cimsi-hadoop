#!/bin/bash

read -p "Enter input text for word2vec: " input_text

input_name="${input_text%.*}"

output_csv="${input_name}.csv"
output_image="${input_name}.png"

echo "Input text file used: $input_text"
echo "Output vectors csv file used: $output_csv"
echo "Output vectors image file used: $output_image"

ansible-playbook -i inventory.ini -u hadoop spark_task.yml -T 30 --extra-vars "input_text=${input_text} output_csv=${output_csv} output_image=${output_image}" || exit 1

gio open $output_image
