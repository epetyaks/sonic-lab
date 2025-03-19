CURRENT_USER := $(USER)
SONIC_IMG_URI := https://sonic-build.azurewebsites.net/api/sonic/artifacts?branchName=master&platform=vs&target=target/sonic-vs.img.gz
SONIC_TMP_GZ_LOC := /tmp/sonic-vs.img.gz
SONIC_TMP_IM_LOC := /tmp/sonic-vs.img
NM_FILE := /etc/NetworkManager/NetworkManager.conf
NM_APPEND := "unmanaged-devices=interface-name:sonic-net-01;interface-name:sonic-net-02"


.PHONY: kvm/install/deps
kvm/install/deps:
	- sudo apt update
	sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils -y
	sudo adduser ${CURRENT_USER} libvirt
	sudo adduser ${CURRENT_USER} kvm


.PHONY: kvm/download/image
kvm/download/image:
	- sudo apt update
	- sudo apt install wget gzip
	wget "${SONIC_IMG_URI}" -O ${SONIC_TMP_GZ_LOC}
	gunzip ${SONIC_TMP_GZ_LOC}
	sudo cp ${SONIC_TMP_IM_LOC} /var/lib/libvirt/images/sonic-vs-01.img
	sudo cp /var/lib/libvirt/images/sonic-vs-01.img /var/lib/libvirt/images/sonic-vs-02.img
	sudo cp ./deployments/sonic-kvm-xml/sonic-vs-01.xml /etc/libvirt/qemu/
	sudo cp ./deployments/sonic-kvm-xml/sonic-vs-02.xml /etc/libvirt/qemu/


.PHONY: fix/networkmanager
fix/networkmanager:
	- sudo grep -q "sonic-net-01" ${NM_FILE} || sudo bash -c 'echo [keyfile] >> ${NM_FILE}' && sudo bash -c 'echo ${NM_APPEND} >> ${NM_FILE}'
	- sudo systemctl restart NetworkManager

.PHONY: kvm/sonic/up
kvm/sonic/up:
	- ./deployments/network-up.sh
	sudo systemctl restart libvirtd
	- sudo virsh net-define ./deployments/sonic-kvm-xml/sonic-net-01.xml
	- sudo virsh net-define ./deployments/sonic-kvm-xml/sonic-net-02.xml
	- sudo virsh net-start sonic-net-01
	- sudo virsh net-start sonic-net-01
	- sudo virsh net-autostart sonic-net-01
	- sudo virsh net-autostart sonic-net-01
	sudo virsh start sonic-vs-01
	sudo virsh start sonic-vs-02

.PHONY: kvm/sonic/down
kvm/sonic/down:
	- sudo virsh destroy sonic-vs-01
	- sudo virsh destroy sonic-vs-02
	- ./deployments/network-down.sh
