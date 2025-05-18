# sonic-lab

-- run once:
1) make kvm/install/deps        -> install requred package
2) make kvm/download/image      -> download latest sonic vs image, copy to requred destinations
3) make fix/networkmanager      -> disable NetworkManager for sonic-net-01 and sonic-net-02 bridges

-- run multiple times:
4) make kvm/sonic/up            -> start two sonic vs switches
5) make kvm/sonic/configure     -> (first start only, to provide configuration via telnet session). if this will not work, do stuff arter Post lan Start... manually
6) make kvm/sonic/down          -> stop two sonic vs switches

Post lab Start Tasks:

telnet 127.0.0.1 7001
    admin/YourPaSsWoRd

    sudo ip addr add 172.16.181.11/24 dev eth0
    echo admin:$(LANG=C perl -e 'print crypt("admin", "salt"),"\n"') | sudo chpasswd -e
    scp ./deployments/sonic-kvm-xml/config_db_01.json admin@172.16.181.11:/home/admin
    sudo mv /home/admin/config_db_01.json /etc/sonic/config_db.json
    sudo reboot

telnet 127.0.0.1 7002
    admin/YourPaSsWoRd

    sudo ip addr add 172.16.181.12/24 dev eth0
    echo admin:$(LANG=C perl -e 'print crypt("admin", "salt"),"\n"') | sudo chpasswd -e
    scp ./deployments/sonic-kvm-xml/config_db_02.json admin@172.16.181.12:/home/admin
    sudo mv /home/admin/config_db_02.json /etc/sonic/config_db.json
    sudo reboot

After:
 ssh admin@172.16.181.11    password: admin
 ssh admin@172.16.181.12    password: admin