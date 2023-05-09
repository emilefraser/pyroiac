# Packer Templates

A collection of Packer Tempaltes to build "Golden images" of various OSes

All [Packer](https://www.packer.io/) templates are basked on the templates used
in the [Bento project](https://github.com/chef/bento) by Chef Software and have
been modifed for my own personal use and not intended for building
[Vagrant](https://www.vagrantup.com/) base boxes, for vagrant boxes see the
templates in the [project home](https://github.com/chef/bento and the ones published on the
[bento org](https://app.vagrantup.com/bento) on Vagrant Cloud.

### Building Virtual Machine images

#### Requirements

- [Packer](https://www.packer.io/)
- At least one of the following virtualization providers:
  - [VirtualBox](https://www.virtualbox.org)
  - [VMware Fusion](https://www.vmware.com/products/fusion.html)
  - [VMware Workstation](https://www.vmware.com/products/workstation.html)
  - [Parallels Desktop](http://www.parallels.com/products/desktop) also requires [Parallels Virtualization SDK](https://www.parallels.com/products/desktop/download/)
  - [KVM](https://www.linux-kvm.org/page/Main_Page) *
  - [Hyper-V](https://technet.microsoft.com/en-us/library/hh831531(v=ws.11).aspx) *

#### Using `packer`

To build an Ubuntu 20.04 box for only the Vmware provider

```bash
$ cd packer_templates/ubuntu
$ packer build -only=vmware-iso ubuntu-20.04-amd64.json
```

To build an Ubuntu 18.04 box for only the VirtualBox provider

```bash
$ cd packer_templates/ubuntu
$ packer build -only=virtualbox-iso ubuntu-18.04-amd64.json
```

To build Debian 10.4 32bit boxes for all possible providers (simultaneously)

```bash
$ cd packer_templates/debian
$ packer build debian-10.4-i386.json
```

To build CentOS 7.7 boxes for all providers except VMware and Parallels

```bash
$ cd packer_templates/centos
$ packer build -except=parallels-iso,vmware-iso centos-7.7-x86_64.json
```

To use an alternate mirror

```bash
$ cd packer_templates/fedora
$ packer build -var 'mirror=http://mirror.utexas.edu/fedora/linux' fedora-31-x86_64.json
```

To use a designated packer cache, create a folder and  set the environmental variable

```bash
$ mkdir /path/to/store/isodownload
$ PACKER_CACHE_DIR=/path/to/store/isodownload
$ cd packer_templates/fedora
$ packer build -only=vmware-iso fedora-31-x86_64.json
```

Configuring Packer logging

Packer depends on two environment variables being configured, `PACKER_LOG` and `PACKER_LOG_PATH`

```bash
$ export PACKER_LOG=1
$ export PACKER_LOG_PATH="packerlog.txt"
$ packer build -only=vmware-iso alpine-3.12-x86.json
$ tail -f packerlog.txt
```


If the build is successful, the Virtual Machine files will be in the `builds` directory at the root of the repository.

### CENTOS/RHEL/ORACLE Linux type OSes

CENTOS, RHEL and ORACLE Linux share the same kickstart, `ks.cfg`, and build scripts found in the `centos` folder.
These scripts set the hostname to `newvm`, so rename and adjust accordingly per build


### Proprietary Templates

Templates for operating systems (macOS, Red Hat Enterprise Linux, and SUSE Linux Enterprise)
that require license or subscription require you to add the correct links to the ISOs as they are not publicly available

The Packer templates expect the ISOs to be in `./packer_cache` folder relative to the Packer `.json` file

### Other helpful resources and troubleshooting tips

See links below

 * [Packer](https://www.packer.io/)
 * [Bento project](https://github.com/chef/bento) by Chef Software
 * Awesome projects:
  * https://github.com/boxcutter
  * https://github.com/mcandre/packer-templates
  * https://github.com/timsutton/osx-vm-templates
  * https://github.com/ferventcoder/vagrant-windows-puppet/tree/master/baseboxes
  * https://github.com/mrlesmithjr/packer-templates