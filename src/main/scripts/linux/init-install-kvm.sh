#!/usr/bin/env bash
sudo apt-get install qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils
sudo adduser `id -un` libvirtd
# virsh list --all
# sudo ls -la /var/run/libvirt/libvirt-sock
# sudo ls -l /dev/kvm
# sudo ls -la /var/run/libvirt/libvirt-sock
# groups
sudo chown root:libvirtd /dev/kvm
sudo apt-get install virt-manager