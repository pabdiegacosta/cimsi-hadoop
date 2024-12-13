#!/bin/bash

# Add nodes to hostfile
echo "192.168.56.20 master" >> /etc/hosts
echo "192.168.56.21 worker1" >> /etc/hosts
echo "192.168.56.22 worker2" >> /etc/hosts
echo "192.168.56.23 worker3" >> /etc/hosts

# Add nodes to ansible hostfile
echo "[nodos]" >> /etc/ansible/hosts
echo "192.168.56.20" >> /etc/ansible/hosts
echo "192.168.56.21" >> /etc/ansible/hosts
echo "192.168.56.22" >> /etc/ansible/hosts
echo "192.168.56.23" >> /etc/ansible/hosts
