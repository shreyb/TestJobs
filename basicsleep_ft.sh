#!/bin/sh

if [ $# -gt 0 ] 
then	
	time=$1
else
	time=5
fi

echo "Going to sleep for $time seconds"

sleep $time 

echo "Woke up!"

echo "Now testing file transfer"



touch /tmp/a

source /grid/fermiapp/products/common/etc/setups.sh
setup ifdhc

ls /pnfs/dune/scratch/users/sbhat/a > /dev/null $2>$1

if [ $? == 0 ]
then
	echo "REMOVING A"
	rm -f /pnfs/dune/scratch/users/sbhat/a
fi

ifdh cp -D /tmp/a /pnfs/dune/scratch/users/sbhat/

echo "The return status of the last command was $?"
