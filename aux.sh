#!/bin/bash

#ansible-playbook -i inventory.ini -u hadoop all.yml -T 30
#ansible-playbook -i inventory.ini -u hadoop spark.yml -T 30
ansible-playbook -i inventory.ini -u hadoop aux.yml -T 30
