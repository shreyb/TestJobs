#!/bin/sh


# This test job tests a simple read from the Rapid Code Distribution service.  If we specify that our tarball is called "TestDir.tar", then in the job, we expect to find the tarball
# untarred at ${CONDOR_DIR_INPUT}/TestDir/

# We will then try to copy a combined file back to scratch dCache --- Note that we're assuming this is a Nova job, unless otherwise specified

# Submit this job with an incantation like:
# jobsub_submit -G nova --resource-provides=usage_model=DEDICATED,OFFSITE --expected-lifetime='short' --tar_file_name=dropbox:///path/to/TestDir.tar --use-cvmfs-dropbox file:///path/to/cvmfs_untar.sh
# 

function usage {
	EXITCODE=$1
	if [-z ${EXITCODE+x} ];
	then
		EXITCODE=0
	fi
	
	echo "Usage FILL THIS IN"
	echo "-e <experiment>        Which experiment's scratch area to write test file to"
	echo "--testdir <dir>  	     What name of RCDS dir we should be looking for"
	echo "--secondtestdir <dir>  In case of multiple tarfiles, name of second dir"
	echo "-h|--help              Print this message and exit"
	exit $EXITCODE
}


function cat_contents {
	DIR=$1
	for f in `ls -1 $DIR`;
	do 
		echo $f
		cat ${DIR}/${f}
		echo ""
	done
}

# Begin main
while (( "$#" )); do
	case "$1" in 
		-e)
			shift
			EXPERIMENT=$1
			shift
			;;
		--testdir)
			shift
			TESTDIR=$1
			shift
			;;
		--secondtestdir)
			shift
			SECONDTESTDIR=$1
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


# Defaults
# Assume nova if no expt given
if [[ -z ${EXPERIMENT+x} ]];
then
	EXPERIMENT=nova
fi

if [[ -z ${TESTDIR+x} ]];
then
	TESTDIR=TestDir
fi


SCRATCHDIR="/pnfs/${EXPERIMENT}/scratch/users/sbhat"


. /cvmfs/fermilab.opensciencegrid.org/products/common/etc/setups.sh
setup ifdhc

set -e 

echo "Testing Rapid Code Distribution"
TARDIR=${CONDOR_DIR_INPUT}/${TESTDIR}


###TODO TAKE THIS OUT AFTER DEBUGGING
echo "ls -Rl ${CONDOR_DIR_INPUT}"
ls -Rl ${CONDOR_DIR_INPUT}
echo "ls start dir"
ls -Rl
echo "INPUT_TAR_FILE"
echo $INPUT_TAR_FILE 
ls $INPUT_TAR_FILE
# echo "ls -l ${CONDOR_DIR_INPUT}/${TESTDIR}"
# ls -l ${CONDOR_DIR_INPUT}/${TESTDIR}/
# echo "ls -Rl ${CONDOR_DIR_INPUT}/${TESTDIR}"
# ls -Rl ${CONDOR_DIR_INPUT}/${TESTDIR}/
# echo ""
########

ls $TARDIR
echo ""

cat_contents ${TARDIR}


if [[ -n ${SECONDTESTDIR+x} ]];
then
	echo "Second Test Dir"
	SECONDTARDIR=${CONDOR_DIR_INPUT}/${SECONDTESTDIR}
	ls $SECONDTARDIR
	echo ""
	cat_contents ${SECONDTARDIR}
fi


echo "Creating a new file to copy out"
DATE=`date +%s`
FILENAME="combined_file_${DATE}"
cat ${TARDIR}/a ${TARDIR}/b ${TARDIR}/c > ${_CONDOR_JOB_IWD}/${FILENAME} 

DESTPATH=${SCRATCHDIR}/${FILENAME}
echo "Copying file out to $DESTPATH"
ifdh cp ${_CONDOR_JOB_IWD}/${FILENAME} $DESTPATH
echo "Copy Successful.  Going to sleep."


sleep 300
