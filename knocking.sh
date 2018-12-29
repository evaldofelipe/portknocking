#!/bin/bash

set -o errexit
set -o nounset

# Set the ports that you configured on your server
ports="xxxx xxxx xxxx"

# Your server IP
host="0.0.0.0"

for port in $ports ; do
    nmap -Pn --initial-rtt-timeout 10ms --max-retries 0 -p $port $host
done
