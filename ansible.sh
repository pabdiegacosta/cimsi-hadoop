#!/bin/bash

ansible-playbook -i inventory.ini -u hadoop -K all.yml -T 30
