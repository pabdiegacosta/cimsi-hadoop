#!/bin/bash

#ansible-playbook -i inventory.ini -u hadoop -K all.yml -T 30
#ansible-playbook -i inventory.ini -u hadoop -K spark.yml -T 30
ansible-playbook -i inventory.ini -u hadoop -K aux.yml -T 30
