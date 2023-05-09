#!/bin/bash -x

# version bump
echo "**********************************"
echo "starting the packer build process"
echo "**********************************"
echo "setting env vars PACKER_LOG,PACKER_LOG_PATH"
export PACKER_LOG=1
export PACKER_LOG_PATH=/home/pyromaniac/repos/iac/packer/packer-qemu-vm/packerlog
echo "setting env vars HCP_CLIENT_ID,HCP_CLIENT"
export HCP_CLIENT_ID=N4s1ydngwto5joRAqlXymXYlyTpgJjGF
export HCP_CLIENT_SECRET=jWvdUd-Jmdmpk-9Mrr1HISmksCQFicuPpGGBWcC2_dLFq6KxMEjNEGrTbANKfcnc
echo "bumping version"
ver=$(cat version | sed "s/^0*//")
ver=$((ver+1))
echo $ver | awk '{ printf("%04d\n", $1) }' > version
ver=$(cat version)
echo "new version: ${ver}"
echo "starting build:"
echo "packer build -force -var-file vars/linux.hcl template-image.pkr.hcl"
packer build -force -var-file vars/linux.hcl template-image.pkr.hcl
