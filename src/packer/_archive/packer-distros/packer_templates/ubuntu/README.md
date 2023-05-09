## Modifications

1. In the `variables` section, add `username` and `hostname`

```json
  "variables": {
    "username": "armand",
    "hostname": "ubuntu",
    //...
  }
```

2. In the `boot_command` section of the Packer template `.json` file. replace
   `" netcfg/get_hostname=vagrant<wait>"` with
   `" netcfg/get_hostname={{ user `hostname` }}<wait>"`

3. Replace all other instances of `vagrant` in the Packer template `.json` file
   with `{{ user `username` }}`

4. Remove the `post-processors` section in the Packer template `.json` file that
   creates the vagrant box in the Packer template `.json` file

```json
  "post-processors": [
    {
      "output": "{{ user `build_directory` }}/{{user `box_basename`}}.{{.Provider}}.box",
      "type": "vagrant"
    }
  ],
```

5. Rename `scripts/Vagrant.sh` with the correct username, i.e, if username iss
   `armand`, then rename the file `scripts/armand.sh`

6. Update the `pubkey_url` in `scripts/Vagrant.sh`, with the URL to your own
   public key, and update all instances of `vagrant` in this file with the
   correct username, i.e `armand`

7. Replace all other instances of `vagrant` in any of the script files, in the
   `scripts` folder with the correct username, i.e `armand`

8. To ensure VMware artifact is not disconnected from network adapter, set
   `"vmx_remove_ethernet_interfaces": false` (or simply remove that line), in
   the `builders` section in the Packer template `.json` file

9. To disable the Packer defaults of building VMware virtual machines by
   launching a GUI, set `"headless": true` under the `builder` secion of the
   packer template. This is required on VMware workstation using, VMware Builder
   (from ISO), `vmware-iso` to avoid the error:

   ```bash
   Error: Cannot launch the UI because no display server is present in the current environment
   ```