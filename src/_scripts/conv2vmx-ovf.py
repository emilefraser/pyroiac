#!/usr/bin/env python
#
# usage:
#        conv2vmx-ovf.py some-vm-name
#
# The file name will be automatically derived from the "some-vm-name"
#
# ref: http://www.cnblogs.com/eshizhan/p/3332020.html
#

import sys
import subprocess
import os
import glob

fn = sys.argv[1]
tarpath = '/home/web/ftp/pub/'
os.chdir(tarpath)

vbox_tarfn = fn + '.ova'
esx_tarfn = fn + '.esx.ova'

#
# Remove both of the Appliances
#
if (os.path.isfile(vbox_tarfn)):
    os.remove(vbox_tarfn)

if (os.path.isfile(esx_tarfn)):
    os.remove(esx_tarfn)

print('Exporting ...')
rc=subprocess.check_output(['VBoxManage', 'export' , fn, '--manifest', '--ovf10', '-o' + vbox_tarfn])
print('Exported ...\n' + rc)

print('Unpacking ...')
rc = subprocess.check_output(['tar', 'xvf', vbox_tarfn])
print('Unpacked ..\n' + rc)

print('Reconfiguring ...')
ofn = fn + '.ovf'
fp = open(ofn).read()
if hasattr(fp,'decode'): 
    fp = fp.decode('utf-8')
#
#
#
fp = fp.replace('<OperatingSystemSection ovf:id="80">', '<OperatingSystemSection ovf:id="101">')
fp = fp.replace('<vssd:VirtualSystemType>virtualbox-2.2', '<vssd:VirtualSystemType>vmx-8')
fp = fp.replace('<rasd:Caption>sataController', '<rasd:Caption>scsiController')
fp = fp.replace('<rasd:Description>SATA Controller', '<rasd:Description>SCSI Controller')
fp = fp.replace('<rasd:ElementName>sataController', '<rasd:ElementName>scsiController')
fp = fp.replace('<rasd:ResourceSubType>AHCI', '<rasd:ResourceSubType>lsilogic')
fp = fp.replace('<rasd:ResourceType>20', '<rasd:ResourceType>6')
end = fp.find('<rasd:Caption>sound')
start = fp.rfind('<Item>', 0, end)
fp = fp[:start] + '<Item ovf:required="false">' + fp[start+len('<Item>'):]
nfn = 'vmx_' + fn + '.ovf'
nfp = open(nfn, 'wb')
nfp.write(fp.encode('utf8'))
nfp.close()
os.remove(ofn)
os.rename(nfn, ofn)
print('Reconfigured...')
#
# Change sha1 in manifest
# SHA1 (cent64-7-db-prod.ovf)= a8a69373407a28add1394ebca74b56153b534ae3
#
omfn = fn + '.mf'
nmfn = 'esx_' + omfn
print('Changing manifest SHA')
sha = subprocess.check_output('sha1sum ' + ofn + ' | awk \'{ print $1 }\'', stderr=subprocess.STDOUT, shell=True)
with open(nmfn, 'w') as new_file:
    with open(omfn) as old_file:
        for line in old_file:
            if (line.find(ofn)>0):
                old_line = line
                line = 'SHA1 (' + ofn + ')= ' + sha
                print('old SHA=' + old_line + 'new SHA=' + line)
            new_file.write(line)
new_file.close()
old_file.close()
os.remove(omfn)
os.rename(nmfn, omfn)

print('Packing ... ' + esx_tarfn)
rc = subprocess.check_output(['tar', 'cvf', esx_tarfn, ofn])
rc = rc + subprocess.check_output('tar rvf ' + esx_tarfn + ' ' + omfn + ' ' + fn + '*.vmdk' + ' ; exit 0', stderr=subprocess.STDOUT, shell=True)

print('Finished ... removing files ... \n' + rc)
os.remove(omfn)
os.remove(ofn)
for f in glob.glob(fn + '*.vmdk'):
    os.remove(f)
