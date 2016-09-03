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
	
	currentLookup=`egrep -- "$valueToLookup" ./trimmedCSV | wc -l`;
	echo "Occurences of '$valueToLookup' in file: $currentLookup";
done


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

echo "Binary-fied output"
echo "$binary"

echo ""
echo "Binary-fied, sorted"
echo "$sortedBinary"

echo ""

echo "Reverse binary"
echo "$reverseBinary"

echo ""
echo "Reverse binary, sorted"
echo "$sortedReverse"
