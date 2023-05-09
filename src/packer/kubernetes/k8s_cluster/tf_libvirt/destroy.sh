#!/bin/bash
virsh undefine --domain k8scpnode
virsh undefine --domain k8wrknode1
virsh undefine --domain k8wrknode2

terraform destroy -auto-approve
