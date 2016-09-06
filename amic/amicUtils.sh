#!/bin/bash

function updateBinStrings {
    binary="${binary}$1"
    sortedBinary="$1${sortedBinary}"
    reverseBinary="${reverseBinary}$2"
    sortedReverse="$2${sortedReverse}"
}

function echoAndOutput {
    echo -e $1
	echo -e "$2" | tee 1 "binaryfiedResults/$3"
    echo -e ""
}