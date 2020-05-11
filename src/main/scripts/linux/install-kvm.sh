#!/usr/bin/env bash
sudo apt-get install -y qemu-kvm
sudo apt-get install -y libvirt-bin
sudo apt-get install -y ubuntu-vm-builder
sudo apt-get install -y bridge-utils
sudo adduser `id -un` libvirtd
# virsh list --all
# sudo ls -la /var/run/libvirt/libvirt-sock
# sudo ls -l /dev/kvm
# sudo ls -la /var/run/libvirt/libvirt-sock
# groups
sudo chown root:libvirtd /dev/kvm
sudo apt-get install -y virt-manager
