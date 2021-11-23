#!/bin/bash

# Test script to untar $INPUT_TAR_FILE and list its contents
# To be used with --tar_file_name directives


function usage {
	EXITCODE=$1
	if [-z ${EXITCODE+x} ];
	then
		EXITCODE=0
	fi
	
	echo "Usage FILL THIS IN"
	echo "-e <experiment>        	      Which experiment's scratch area to write test file to"
	echo "--testtar <tarball_name>        What name of tarball we should be looking for"
	echo "--secondtesttar <tarball_name>  In case of multiple tarfiles, name of second dir"
	echo "-h|--help              	      Print this message and exit"
	exit $EXITCODE
}

# Begin main
echo "Starting run now"

# Parse args
while (( "$#" )); do
	case "$1" in 
		-e)
			shift
			EXPERIMENT=$1
			shift
			;;
		--testtar)
			shift
			TESTTAR=$1
			shift
			;;
		-h|--help)
			usage
			;;
		*)
			echo "Error: unsupported flag $1" >&2
			usage 1
			;;
	esac
done


# Checks

# echo "${INPUT_TAR_FILE?INPUT_TAR_FILE not set}"

# Defaults
# Assume nova if no expt given
if [[ -z ${EXPERIMENT+x} ]];
then
	EXPERIMENT=nova
fi


SCRATCHDIR="/pnfs/${EXPERIMENT}/scratch/users/sbhat"


. /cvmfs/fermilab.opensciencegrid.org/products/common/etc/setups.sh
setup ifdhc

set -e 

# Read file 

echo "The dropbox file should live in \$CONDOR_DIR_INPUT"
if [[ -n ${CONDOR_DIR_INPUT+x} ]];
then
	echo "Show contents of \$CONDOR_DIR_INPUT and any subdirectories:"
	ls -Rl ${CONDOR_DIR_INPUT}
	echo ""
	echo "Show contents of any files in \$CONDOR_DIR_INPUT"
	for FILE in `ls -1 ${CONDOR_DIR_INPUT}`
	do
		cat $FILE
	done
	echo ""
fi


echo "Creating a new file to copy out"
DATE=`date +%s`
FILENAME="outfile_${DATE}"
ls -Rl ${_CONDOR_JOB_IWD} > ${_CONDOR_JOB_IWD}/${FILENAME} 

DESTPATH=${SCRATCHDIR}/${FILENAME}
echo "Copying file out to $DESTPATH"
ifdh cp ${_CONDOR_JOB_IWD}/${FILENAME} $DESTPATH
echo "Copy Successful.  Going to sleep."

sleep 300

exit 0
