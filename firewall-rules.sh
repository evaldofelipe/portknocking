#!/bin/bash

set -o errexit
set -o nounset

# Set the ports to tknocking
port1="xxx"
port2="xxx"
port3="xxx"

# Set ips to withelist
withelist1="0.0.0.0"
withelist2="0.0.0.0"

# Create the CHAINS on iptalbes
iptables -N KNOCKING
iptables -N GATE1
iptables -N GATE2
iptables -N GATE3
iptables -N PASSED

# Add rules to each CHAIN and specify the knock doors
iptables -A GATE1 -p tcp --dport $port1 -m recent --name AUTH1 --set -j DROP
iptables -A GATE1 -j RETURN
iptables -A GATE2 -m recent --name AUTH1 --remove
iptables -A GATE2 -p tcp --dport $port2 -m recent --name AUTH2 --set -j DROP
iptables -A GATE2 -j GATE1
iptables -A GATE3 -m recent --name AUTH2 --remove
iptables -A GATE3 -p tcp --dport $port3 -m recent --name AUTH3 --set -j DROP
iptables -A GATE3 -j GATE1
iptables -A PASSED -m recent --name AUTH3 --remove
iptables -A PASSED -p tcp --dport 22 -j ACCEPT
iptables -A PASSED -j GATE1

# Add rules to jump between the CHAINS
iptables -I INPUT -j KNOCKING
iptables -A KNOCKING -p tcp --dport 22 -s $withelist1  -j ACCEPT
iptables -A KNOCKING -p tcp --dport 22 -s $withelist2  -j ACCEPT
iptables -A KNOCKING -p tcp --dport 22 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A KNOCKING -m recent --rcheck --seconds 30 --name AUTH3 -j PASSED
iptables -A KNOCKING -m recent --rcheck --seconds 10 --name AUTH2 -j GATE3
iptables -A KNOCKING -m recent --rcheck --seconds 10 --name AUTH1 -j GATE2
iptables -A KNOCKING -j GATE1
iptables -A KNOCKING -p tcp --dport 22 -m limit --limit 3/min -j LOG --log-level 4 --log-prefix '[KNOCKING BLOCK] '
iptables -A KNOCKING -p tcp --dport 22 -j DROP
