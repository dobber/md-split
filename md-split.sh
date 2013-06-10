#!/bin/bash
# check for mdraid split brain situation
# by Ivan Dimitrov https://github.com/dobber/
# for Ancient Media 2013

MDSTAT="/proc/mdstat"

if [ ! -f $MDSTAT ] ; then
	exit
fi

for raid in `cat ${MDSTAT} | grep -E '^md' | awk '{print $1}' | sort` ; do
	# check blkid of all raid devices
	device="/dev/${raid}"
	ids=( "${ids[@]}" `blkid ${device} | cut -f 2 -d\"` )
done

# check for duplicate UUIDs
for dups in `echo ${ids[@]} | tr ' ' '\n' | sort | uniq --repeated` ; do
	raids=( `blkid | grep $dups | awk '{print $1}' | cut -f 1 -d:` )
	echo
	echo "Warning!!! Possible split-brain situation in md raid with UUID ${dups}, devices ${raids[@]}"
	echo
done
