PACKER ?= packer

.PHONY: all clean

all: centos7.tar.gz

centos7.tar.gz: clean
	sudo ${PACKER} init centos7.pkr.hcl && sudo PACKER_LOG=1 ${PACKER} build centos7.pkr.hcl
	reset

clean:
	sudo ${RM} -rf output-qemu centos7.tar.gz
