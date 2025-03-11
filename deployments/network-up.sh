#!/bin/bash

nmcli con add ifname sonic-net-01 type bridge con-name sonic-net-01
nmcli con add ifname sonic-net-02 type bridge con-name sonic-net-02
nmcli connection modify sonic-net-01 ipv4.addresses '172.16.181.100/24'
nmcli connection modify sonic-net-02 ipv4.addresses '172.16.182.100/24'
nmcli conn up sonic-net-01
nmcli conn up sonic-net-02
