#!/bin/bash

# Test script to untar $INPUT_TAR_FILE and list its contents



echo "Starting run now"


# Checks

echo "Checking that \$INPUT_TAR_FILE is set"
echo "${INPUT_TAR_FILE?INPUT_TAR_FILE not set}"

#if [[ -z $INPUT_TAR_FILE ]];
#then
#	echo "\$INPUT_TAR_FILE is not set.  Exiting."
#	exit 1
#else 
#	echo "\$INPUT_TAR_FILE is set to $INPUT_TAR_FILE"
#fi


# Show tar contents
ls -Rl ${_CONDOR_JOB_IWD}
ls

sleep 600

exit 0
