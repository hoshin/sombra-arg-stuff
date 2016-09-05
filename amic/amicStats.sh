#!/bin/bash -e

if [ "$1" == "" ]; then 
	echo "you need to specify a CSV file to parse"
	echo "./amicStats.sh <path/to/your/csv>"
	exit 1
fi

#VALUES='0.0038 0.0076 0.0075 0.0037 0.0039'

sed 1d $1 > ./trimmedCSV

#%age => 2, TS => 7
echo "%age variations stats in file"
uniqueValuesInFile=`cut -d, -f 2 ./trimmedCSV | sort | uniq | tr '\n' ' '`

echo "Unique values found: $uniqueValuesInFile"

for valueToLookup in $uniqueValuesInFile; do
	
	currentLookup=`egrep -- "\+$valueToLookup" ./trimmedCSV | wc -l`;
	echo "Occurences of '$valueToLookup' in file: $currentLookup";
done


function straight {
	binary=''
	sortedBinary=''
	reverseBinary=''
	sortedReverse=''


	while IFS='' read -r line || [[ -n "$line" ]]; do
		currentLinePctage=`echo $line | cut -d, -f 2`

		if [ "$currentLinePctage" == "+0.0038%" ]; then
			binary="${binary}0"
			sortedBinary="0${sortedBinary}"
			reverseBinary="${reverseBinary}1"
			sortedReverse="1${sortedReverse}"
		elif [ "$currentLinePctage" == "+0.0076%" ]; then	
			binary="${binary}1"
			sortedBinary="1${sortedBinary}"
			reverseBinary="${reverseBinary}0"
			sortedReverse="0${sortedReverse}"
		else 
			binary="${binary}-"
			sortedBinary="-${sortedBinary}"
			reverseBinary="${reverseBinary}-"
			sortedReverse="-${sortedReverse}"
		fi
	done < "./trimmedCSV"

	echo "Writing binary-fied output"
	echo "$binary"
	echo "$binary" > binaryfiedResults/binary&

	echo ""

	echo "Writing binary-fied, sorted"
	echo "$sortedBinary"
	echo "$sortedBinary" > binaryfiedResults/sortedBinary&

	echo ""

	echo "Writing reverse binary"
	echo "$reverseBinary"
	echo "$reverseBinary" > binaryfiedResults/reverseBinary&

	echo ""

	echo "Writing reverse binary, sorted"
	echo "$sortedReverse"
	echo "$sortedReverse" > binaryfiedResults/reverseSorted&
}

function smooth {
	
	binary=''
	sortedBinary=''
	reverseBinary=''
	sortedReverse=''

	while IFS='' read -r line || [[ -n "$line" ]]; do
		currentLinePctage=`echo $line | cut -d, -f 2`

		if [ "$currentLinePctage" == "+0.0038%" ] || [ "$currentLinePctage" == "+0.0037%" ] ; then
			binary="${binary}0"
			sortedBinary="0${sortedBinary}"
			reverseBinary="${reverseBinary}1"
			sortedReverse="1${sortedReverse}"
		elif [ "$currentLinePctage" == "+0.0076%" ] || [ "$currentLinePctage" == "+0.0075%" ]; then	
			binary="${binary}1"
			sortedBinary="1${sortedBinary}"
			reverseBinary="${reverseBinary}0"
			sortedReverse="0${sortedReverse}"
		else 
			binary="${binary}-"
			sortedBinary="-${sortedBinary}"
			reverseBinary="${reverseBinary}-"
			sortedReverse="-${sortedReverse}"
		fi
	done < "./trimmedCSV"

	echo "Writing binary-fied output"
	echo "$binary"
	echo "$binary" > binaryfiedResults/binary_smooth&

	echo ""

	echo "Writing binary-fied, sorted"
	echo "$sortedBinary"
	echo "$sortedBinary" > binaryfiedResults/sortedBinary_smooth&

	echo ""

	echo "Writing reverse binary"
	echo "$reverseBinary"
	echo "$reverseBinary" > binaryfiedResults/reverseBinary_smooth&

	echo ""

	echo "Writing reverse binary, sorted"
	echo "$sortedReverse"
	echo "$sortedReverse" > binaryfiedResults/reverseSorted_smooth&
}

function smoother {
	binary=''
	sortedBinary=''
	reverseBinary=''
	sortedReverse=''

	while IFS='' read -r line || [[ -n "$line" ]]; do
		currentLinePctage=`echo $line | cut -d, -f 2`
	
		if [ "$currentLinePctage" == "+0.0038%" ] || [ "$currentLinePctage" == "+0.0037%" ] || [ "$currentLinePctage" == "+0.0039%" ] ; then
			binary="${binary}0"
			sortedBinary="0${sortedBinary}"
			reverseBinary="${reverseBinary}1"
			sortedReverse="1${sortedReverse}"
		elif [ "$currentLinePctage" == "+0.0076%" ] || [ "$currentLinePctage" == "+0.0075%" ] || [ "$currentLinePctage" == "+0.0077%" ]; then	
			binary="${binary}1"
			sortedBinary="1${sortedBinary}"
			reverseBinary="${reverseBinary}0"
			sortedReverse="0${sortedReverse}"
		else 
			binary="${binary}-"
			sortedBinary="-${sortedBinary}"
			reverseBinary="${reverseBinary}-"
			sortedReverse="-${sortedReverse}"
		fi
	done < "./trimmedCSV"

	echo "Writing binary-fied output"
	echo "$binary"
	echo "$binary" > binaryfiedResults/binary_smoother&

	echo ""

	echo "Writing binary-fied, sorted"
	echo "$sortedBinary"
	echo "$sortedBinary" > binaryfiedResults/sortedBinary_smoother&

	echo ""

	echo "Writing reverse binary"
	echo "$reverseBinary"
	echo "$reverseBinary" > binaryfiedResults/reverseBinary_smoother&

	echo ""

	echo "Writing reverse binary, sorted"
	echo "$sortedReverse"
	echo "$sortedReverse" > binaryfiedResults/reverseSorted_smoother&
}

straight
smooth
smoother

mkdir -p binaryfiedResults
