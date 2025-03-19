# sonic-lab

-- run once:
1) make kvm/install/deps        -> install requred package
2) make kvm/download/image      -> download latest sonic vs image, copy to requred destinations
3) make fix/networkmanager      -> disable NetworkManager for sonic-net-01 and sonic-net-02 bridges

-- run multiple times:
4) make kvm/sonic/up            -> start two sonic vs switches
5) make kvm/sonic/down          -> stop two sonic vs switches

todo after lab start:

telnet 127.0.0.1 7001
    admin/YourPaSsWoRd
    sudo ip addr add 172.16.181.11/24 dev eth0
telnet 127.0.0.1 7002
    admin/YourPaSsWoRd
    sudo ip addr add 172.16.181.12/24 dev eth0