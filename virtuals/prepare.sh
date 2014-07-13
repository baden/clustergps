#!/bin/bash

# (username/password): ubuntu/reverse

OVA_IMAGE="./ubuntu-14.04-server-i386.ova"
VM='Cluster-virtual'
SSH_PORT=2222
#RELEASE="0.1.0"

#scp -P 2222 -rp ../_rel/clustergps/ ubuntu@127.1:
rsync -avz --delete --rsh='ssh -p2222' ../_rel/clustergps/ ubuntu@127.1:~/clustergps


exit 0

#ssh -p 2222 ubuntu@127.1 mkdir clustergps
#scp -P 2222 -rp ../_rel/clustergps/ ubuntu@127.1:
#ssh -p 2222 ubuntu@127.1 "cd clustergps && tar xvf clustergps-0.1.0.tar.gz"

VBoxManage controlvm $VM poweroff
VBoxManage unregistervm $VM --delete
VBoxManage import $OVA_IMAGE --vsys 0 --vmname $VM
#VBoxManage modifyvm $VM --nic1 bridged --bridgeadapter1 eth0
VBoxManage modifyvm $VM --natpf1 "guestssh,tcp,,$SSH_PORT,,22"
VBoxManage modifyvm $VM --natpf1 "guestcluster,tcp,,12080,,2080"
VBoxManage startvm $VM

echo "Waiting start Virtual Machine"

sleep 15

echo "Enter password in next phase: reverse"

ssh-copy-id -p $SSH_PORT ubuntu@127.1

echo "==============================================================="
echo "You can connect by ssh like: ssh ubuntu@127.1 -p $SSH_PORT"
echo -e "Add:\nUseDNS no\nto /etc/ssh/sshd_config if login to slow."
echo "==============================================================="
#

exit 0

VM='Cluster-virtual'
OS_TYPE="Linux"
#OS_TYPE='Linux_64'
DISKSIZE=32768

VBoxManage createhd --filename $VM.vdi --size $DISKSIZE
VBoxManage createvm --name $VM --ostype $OS_TYPE --register
VBoxManage storagectl $VM --name "SATA Controller" --add sata --controller IntelAHCI
VBoxManage storageattach $VM --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $VM.vdi
VBoxManage storagectl $VM --name "IDE Controller" --add ide
VBoxManage storageattach $VM --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium /path/to/windows_server_2008.iso
VBoxManage modifyvm $VM --ioapic on
VBoxManage modifyvm $VM --boot1 dvd --boot2 disk --boot3 none --boot4 none
VBoxManage modifyvm $VM --memory 1024 --vram 128
VBoxManage modifyvm $VM --nic1 bridged --bridgeadapter1 e1000g0
