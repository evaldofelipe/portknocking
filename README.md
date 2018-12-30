# Port knocking

Did you have that server with port 22 open to the world just waiting for the worst? don't worry! Use this scripts to create a set of IPtables rules to protect your server :D

Port knocking or Door knocking is a method of externally opening ports on a firewall by generating a connection attempt on a set of prespecified closed ports. Once a correct sequence of connection attempts is received, the firewall rules are dynamically modified to allow the host which sent the connection attempts to connect over specific port(s). Read more about [here](https://en.wikipedia.org/wiki/Port_knocking).

## Prerequisites

- IPtables on server-side (most common firewall over all Linux distro)
- [Nmap](https://nmap.org) on client-side

## Let's start

### Server-side

- Edit the file `firewall-rules.sh` with the tcp ports what you whant knock on your server (obviously choose ports has no one using) and if you have some external service or specific IP that use SSH for some reason, put there in whitelist.

```bash
# Set the ports to tknocking
port1="xxx"
port2="xxx"
port3="xxx"

# Set ips to withelist
withelist1="0.0.0.0"
withelist2="0.0.0.0"
```

- Execute this script inside your server as root.
- After this, your current connection will stay alive, but all new ssh connections won't work.

### Client-side

- Edit the file `knocking.sh` with the same ports that you enable on your server, and your server address.

```bash
# Set the ports that you configured on your server
ports="xxxx xxxx xxxx"

# Your server IP
host="0.0.0.0"
```

- Execute this script to make the knocking process properly.
- Make a new ssh connection to your server.

## Tips

- Create a alias to execute a knocking and ssh together and simplify the process.

```bash
alias server='bash /path/to/script/knocking.sh && ssh user@0.0.0.0'
```

## Improvements

- Create a script to automate all this stuffs
