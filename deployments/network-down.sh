#!/bin/bash

nmcli conn down sonic-net-01
nmcli conn down sonic-net-02
nmcli conn delete sonic-net-01
nmcli conn delete sonic-net-02