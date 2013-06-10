md-split
========

A simple script that check if mdraid has a split-brain situation. 
Best to add it to your /etc/profile and show you information on login.

Why
========
In extremely rare situations you can have a split-brain with your raid devices. You can reproduce it by
issuing the following situation.

	mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdc1 /dev/sdd1
	mkfs.xfs /dev/md0
	mount /dev/md0 /mnt/
	cp -a /usr/local/* /mnt/
	umount /mnt/
	mdadm --stop /dev/md0
	mdadm --assemble /dev/md0 /dev/sdc1
	mdadm --run /dev/md0
	mdadm --assemble /dev/md1 /dev/sdd1
	mount /dev/md0 /mnt/
	rm -r /mnt/*

Now you have a split-brain situation because /dev/md0 and /dev/md1 have the same UUID, but different data on it.

	blkid /dev/md0
	blkid /dev/md1
	mdadm --detail /dev/md0
	mdadm --detail /dev/md1

It is possible that the next time you reboot your server, an automated "mdadm --assemble --scan" and /etc/fstab 
that uses UUIDs to mount the wrong drive in your directory.

Example
========
![Split brain reportin on login](http://f.cl.ly/items/0Z3A1w3q2r0k0p2q1V37/Screen%20Shot%202013-06-10%20at%204.18.48%20PM.png)

Install
========
Copy the script in your /usr/local/bin/ directory
Add it to /etc/profile

	git clone https://github.com/dobber/md-split.git
	cd md-split
	cp -a md-split.sh /usr/local/bin/
	echo "/usr/local/bin/md-split.sh" >> /etc/profile

Nagios check
========
comming soon
