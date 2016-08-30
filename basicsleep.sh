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
