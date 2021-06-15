#!/bin/sh

if [[ $# -ne 1 ]] 
then 
	echo "Need to provide an experiment whose pnfs area we're copying a test file from"
	exit 1
fi

EXP=$1

. /cvmfs/fermilab.opensciencegrid.org/products/common/etc/setups.sh
setup ifdhc

set -e

ifdh cp -D /pnfs/${EXP}/scratch/users/sbhat/a ${_CONDOR_JOB_IWD}

cat ${_CONDOR_JOB_IWD}/a

ls -hl

voms-proxy-info -all

echo "hostname --fqdn"
hostname --fqdn

echo "Are we in a container?"
echo "Redhat release: `cat /etc/redhat-release`"
echo "uname -a: `uname -a`"

echo "Do we have strace?"
which strace

echo "Give me the environment"
env

echo "Writing file out"
FILENAME="b_`date +%s`"
echo "Writing file out" > ${_CONDOR_JOB_IWD}/${FILENAME}
ifdh cp ${_CONDOR_JOB_IWD}/${FILENAME} /pnfs/${EXP}/scratch/users/sbhat/${FILENAME}

echo "now sleeping"

sleep 300 

exit 0 
