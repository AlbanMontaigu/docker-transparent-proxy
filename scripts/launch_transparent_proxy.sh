#!/bin/sh

# Error handling
set -e

# Stop and delete existing container
echo "[INFO] Deleting existing transparent proxy container and network rules ..."
docker rm -f transparent-proxy 2>/dev/null || true

# First we added a new chain called 'TRANSPROXY' to the 'nat' table.
echo "[INFO] Set networking rules ..."
sudo iptables -t nat -N TRANSPROXY 2>/dev/null || true

# We then told iptables to redirect all port 80 connections to the http-relay port
sudo iptables -t nat -C TRANSPROXY -p tcp --dport 80 -j REDIRECT --to-ports 3128 -w 2>/dev/null || \
sudo iptables -t nat -A TRANSPROXY -p tcp --dport 80 -j REDIRECT --to-ports 3128 -w

# and all other connections to the http-connect port.
sudo iptables -t nat -C TRANSPROXY -p tcp -j REDIRECT --to-ports 12345 -w 2>/dev/null || \
sudo iptables -t nat -A TRANSPROXY -p tcp -j REDIRECT --to-ports 12345 -w

# Finally we tell iptables to use the ‘TRANSPROXY’ chain for all outgoing connection in docker containers
sudo iptables -t nat -C PREROUTING -p tcp -j TRANSPROXY -m addrtype --dst-type UNICAST ! --dst 172.0.0.0/8 2>/dev/null || \
sudo iptables -t nat -A PREROUTING -p tcp -j TRANSPROXY -m addrtype --dst-type UNICAST ! --dst 172.0.0.0/8

# Now starting transparent proxy service in a container
echo "[INFO] Launching transparent proxy service ..."
if [ -z $1 ];then
    # run transparent proxy using wpad
    echo "[INFO] Use proxy set in proxy pac"
    docker run --name=transparent-proxy --net=host -d amontaigu/transparent-proxy http://wpad/wpad.dat
else
    # run transparent with custom config
    echo "[INFO] Use your personal setting"
    docker run --name=transparent-proxy --net=host -v $1:/mnt/PAC -d amontaigu/transparent-proxy file:///mnt/PAC
fi
echo "[INFO] OK, transparent proxy is started"

# End of error handling
set +e
