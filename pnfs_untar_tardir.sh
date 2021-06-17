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
		--secondtesttar)
			shift
			SECONDTESTTAR=$1
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

if [[ -z ${TESTTAR+x} ]];
then
	TESTTAR=TestDir
fi


SCRATCHDIR="/pnfs/${EXPERIMENT}/scratch/users/sbhat"


. /cvmfs/fermilab.opensciencegrid.org/products/common/etc/setups.sh
setup ifdhc

set -e 

# Show tar contents
echo "If you used --tar_file_name to submit, the tarball will be unwound here:"
ls -Rl ${_CONDOR_JOB_IWD}
ls
echo ""
echo "Peek inside the tarball"
if [[ -n ${INPUT_TAR_FILE+x} ]]; 
then
	tar -tvf ${INPUT_TAR_FILE}
fi
echo ""


echo "If you used -f, the tarfiles live in \$CONDOR_DIR_INPUT, but not unwound:"
if [[ -n ${CONDOR_DIR_INPUT+x} ]];
then
	ls -Rl ${CONDOR_DIR_INPUT}
	TARFILE=${CONDOR_DIR_INPUT}/${TESTTAR}

	if [[ -f $TARFILE ]];
	then

		echo ""
		echo "Peek inside the tarball"
		tar -tvf $TARFILE
		echo ""
	fi

	if [[ -n ${SECONDTESTTAR+x} ]];
	then
		echo "Peek inside second test tarball"
		SECONDTARFILE=${CONDOR_DIR_INPUT}/${SECONDTESTTAR}
		tar -tvf $SECONDTARFILE
		echo ""
	fi
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
