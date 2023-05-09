packer build template.json
multipass launch file://$PWD/output-qemu/packer-qemu --disk 5G

# Launched: tolerant-hammerhead 
multipass shell tolerant-hammerhead
#buntu@tolerant-hammerhead ~:$)
