#!/bin/bash

ansible-playbook -i instances.txt -u hadoop -K all.yml -T 30
