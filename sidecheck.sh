#!/bin/bash

#Author				Alexander Wickström
#Owner				
#Created			2015-10-09
#Purpose			Mount specific usbdisk distinquished from serialnumber	
#					thats retained when boot. Only that device should be
#					able to mount.
#Version			0.1
#Known problems  	Only mounts ever other time. Some thing in row 45-55


# if partitions register as sdb or sdc then write variable $b to $comparekey
differense=$(udevadm info --name=/dev/sdb1 --attribute-walk 2> /dev/null )
if [[ differense -eq "0" ]]
	then
	b="sdb1"
	else
	b="sdc1"
fi

#key: tmp file for serialnumber
key=/tmp/serialkey
#serial: fetcehs serialnumber from usbdisk and saves result in $key
serial=$(udevadm info --name=/dev/$b --attribute-walk | grep serial | sed -n '1p' | cut -c21-36 > $key)
#comparekey: fetches serialnumber from usbdisk 
comparekey=$(udevadm info --name=/dev/$b --attribute-walk | grep serial | sed -n '1p' | cut -c21-36 )
catkey=$(cat $key)

# when passed start save serial of usb to tmp file.
if [[ $1 -eq "start" ]]
	then
	echo $serial
	exit 0
	else
		#if saved serial att boot is eq to present serial on usb then mount drive else echo "wrong usbdrive"
		if [[ $comparekey -eq $catkey ]]
			then
			#checks if path is mounted, if mounted it returns exit 0 
			mounted=$(grep /home/student/provdator < /proc/mounts)
			a=$(echo $?)
			else
			exit 2
		fi
fi
# if return value of mounted is 1 then mnt drive if 0 then first unmount drive.
if [[ $a -eq "1" ]]
	then
	#mount <drive> <path>
	mntdrive=$(mount /dev/$b /home/student/provdator)
	exit 0
	else
	#unmount the selected path
	umount=$(umount /home/student/provdator)
	echo $mntdrive
	exit 0
fi

for $? in $mntdrive
	do
		if [[ $? -eq "1" ]]
			then
			continue
			else
			break
		fi
done