#!/bin/bash

ansible-playbook -i inventory.ini -u hadoop aux.yml -T 30

. deploy_spark_task.sh
