#!/bin/bash

# Playbook for testing
ansible-playbook -i inventory.ini -u hadoop test.yml -T 30
