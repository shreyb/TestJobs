#!/bin/sh

# Get IFDH stuff set up (Thanks M. Mengel)
. /cvmfs/fermilab.opensciencegrid.org/products/common/etc/setups.sh
setup htgettoken

echo "============"
echo "Environment:"
echo "============"
env

echo "============"
echo "Token:"
echo "============"
httokendecode

echo "now sleeping"

sleep 300 

exit 0 
