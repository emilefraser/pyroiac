#!/bin/bash

VM_NAME=$1
echo "VM Name: ${VM_NAME}"

echo "multipass launch -n $VM_NAME --cloud-init ./cloud-init.yaml -vvvv file://$PWD/image.qcow2"
multipass launch -n $VM_NAME --cloud-init ./cloud-init.yaml -vvvv file://$PWD/image.qcow2

#echo "ssh ubuntu@$VM_NAME.local"
#ssh ubuntu@$VM_NAME.local

