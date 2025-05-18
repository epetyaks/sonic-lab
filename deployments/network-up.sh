#!/bin/bash

sudo ip link add name sonic-net-01 type bridge
sudo ip link add name sonic-net-02 type bridge
sudo ip link add name sonic-net-03 type bridge
sudo ip link add name sonic-net-04 type bridge
sudo ip address add 172.16.181.100/24 dev sonic-net-01
sudo ip address add 172.16.182.100/24 dev sonic-net-02
sudo ip link set dev sonic-net-01 up
sudo ip link set dev sonic-net-02 up
sudo ip link set dev sonic-net-03 up
sudo ip link set dev sonic-net-04 up
sudo brctl stp sonic-net-01 off
sudo brctl stp sonic-net-02 off
sudo brctl stp sonic-net-03 off
sudo brctl stp sonic-net-04 off
sudo ip link set sonic-net-01 mtu 1500
sudo ip link set sonic-net-02 mtu 1500
sudo ip link set sonic-net-03 mtu 1500
sudo ip link set sonic-net-04 mtu 1500
