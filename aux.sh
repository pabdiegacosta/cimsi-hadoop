#!/bin/bash

# Playbook for testing
ansible-playbook -i inventory.ini -u hadoop aux.yml -T 30
