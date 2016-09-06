#!/bin/bash -e

RED='\033[0;31m'
NC='\033[0m' # No Color

function generateStrictBinary {
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

    echoAndOutput "Writing binary-fied output" $binary 'binary' $3
	echoAndOutput "Writing binary-fied, sorted" $sortedBinary 'sortedBinary' $3
	echoAndOutput "Writing reverse binary" $reverseBinary 'reverseBinary' $3
	echoAndOutput "Writing reverse binary, sorted" $sortedReverse 'reverseSorted' $3
}

function binaryShowOutliers {
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
            updateBinStrings "${RED}<$currentLinePctage>${NC}" "${RED}<$currentLinePctage>${NC}" $binary $sortedBinary $reverseBinary $reverseSorted
		fi
	done < "./trimmedCSV"

    echoAndOutput "Writing binary-fied output" $binary 'binaryWithOutliers' $3
	echoAndOutput "Writing binary-fied, sorted" $sortedBinary 'sortedBinaryWithOutliers' $3
	echoAndOutput "Writing reverse binary" $reverseBinary 'reverseBinaryWithOutliers' $3
	echoAndOutput "Writing reverse binary, sorted" $sortedReverse 'reverseSortedWithOutliers' $3
}

function runBin {
    read -p "Run the binary conversion?[son] (strict bin, bin w/ printed outliers, do nothing) " answer

    case $answer in
       [s]* )   mkdir -p binaryfiedResults
                echo "Straight up conversion, no smoothing"
                generateStrictBinary "+0.0038%" "+0.0076%" 'straight'
                echo "Smoothing (closest outliers included)"
                generateStrictBinary "+0.0038% +0.0037%" "+0.0076% +0.0075%" 'smooth'
                echo "Even smoother (second closest outliers included)"
                generateStrictBinary "+0.0038% +0.0037% +0.0039%" "+0.0076% +0.0075% +0.0077%" 'smoother'
                break;;
       [o]* )   mkdir -p binaryfiedResults
                echo "Straight up conversion, no smoothing, outliers visible"
                binaryShowOutliers "+0.0038%" "+0.0076%" 'straightOutliers'
                echo "Smoothing (closest outliers included), outliers visible"
                echo "Even smoother (second closest outliers included), outliers visible"
                binaryShowOutliers "+0.0038% +0.0037%" "+0.0076% +0.0075%" 'smoothOutliers'
                binaryShowOutliers "+0.0038% +0.0037% +0.0039%" "+0.0076% +0.0075% +0.0077%" 'smootherOutliers'
                break;;
        * )     echo "Ok. Exiting then"; exit ;;
    esac
}


