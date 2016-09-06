#!/bin/bash -e

function echoAndOutput {
    echo $1
	echo "$2"
	echo "$2" > "binaryfiedResults/$3"&
    echo ""
}

function updateBinStrings {
    binary="${binary}$1"
    sortedBinary="$1${sortedBinary}"
    reverseBinary="${reverseBinary}$2"
    sortedReverse="$2${sortedReverse}"
}

function generateBinary {
	binary=''
	sortedBinary=''
	reverseBinary=''
	sortedReverse=''

    primaryValues=$1
    secondaryValues=$2

	while IFS='' read -r line || [[ -n "$line" ]]; do
		currentLinePctage=`echo $line | cut -d, -f 2`

		if [[ " ${primaryValues[@]} " =~ "$currentLinePctage" ]]; then
            updateBinStrings 0 1 $binary $sortedBinary $reverseBinary $reverseSorted
		elif [[ " ${secondaryValues[@]} " =~ "$currentLinePctage" ]]; then
            updateBinStrings 1 0 $binary $sortedBinary $reverseBinary $reverseSorted
		else
            updateBinStrings '-' '-' $binary $sortedBinary $reverseBinary $reverseSorted
		fi
	done < "./trimmedCSV"

    echoAndOutput "Writing binary-fied output" $binary 'binary'
	echoAndOutput "Writing binary-fied, sorted" $sortedBinary 'sortedBinary'
	echoAndOutput "Writing reverse binary" $reverseBinary 'reverseBinary'
	echoAndOutput "Writing reverse binary, sorted" $sortedReverse 'reverseSorted'
}

function straight {
    generateBinary "+0.0038%" "+0.0076%"
}

function smooth {
	generateBinary "+0.0038% +0.0037%" "+0.0076% +0.0075%"
}

function smoother {
	generateBinary "+0.0038% +0.0037% +0.0039%" "+0.0076% +0.0075% +0.0077%"
}

read -p "Run the binary conversion?[y/n] " answer

case $answer in
   [yY]* )  mkdir -p binaryfiedResults
            echo "Straight up conversion, no smoothing"
	   		straight
	   		echo "Smoothing (closest outliers included)"
	   		smooth
	   		echo "Even smoother (second closest outliers included)"
			smoother
	   		break;;
	* )     echo "Ok. Exiting then"; exit ;;
esac


