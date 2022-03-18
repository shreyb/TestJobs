#!/bin/sh

if [[ $# -ne 1 ]] 
then 
	echo "Need to provide an experiment whose pnfs area we're copying a test file from"
	exit 1
fi

EXP=$1

# Get IFDH stuff set up (Thanks M. Mengel)
. /cvmfs/fermilab.opensciencegrid.org/products/common/etc/setups.sh
setup htgettoken
setup ifdhc v2_6_0 -q python36, ifdhc_config v2_6_0
export IFDH_TOKEN_ENABLE=1
export IFDH_PROXY_ENABLE=0

echo "============"
echo "Environment:"
echo "============"
env

echo "============"
echo "Token:"
echo "============"
httokendecode


# Now try to copy files in/out
echo "============"
echo "ifdh ls"
echo "============"
ifdh ls --force=https /pnfs/${EXP}/scratch/users/sbhat

echo "======================"
echo "ifdh cp (transfer in)"
echo "======================"
ifdh cp -D /pnfs/${EXP}/scratch/users/sbhat/a ${_CONDOR_JOB_IWD}

echo "======================"
echo "Transferred file:"
echo "======================"
cat ${_CONDOR_JOB_IWD}/a

echo "======================"
echo "ifdh cp (transfer out)"
echo "======================"
FILENAME="b_`date +%s`"
echo "Writing file out" > ${_CONDOR_JOB_IWD}/${FILENAME}
ifdh cp ${_CONDOR_JOB_IWD}/${FILENAME} /pnfs/${EXP}/scratch/users/sbhat/${FILENAME}

echo "now sleeping"

sleep 300 

exit 0 
