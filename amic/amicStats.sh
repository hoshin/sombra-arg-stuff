#!/bin/bash -e

if [ "$1" == "" ]; then 
	echo "you need to specify a CSV file to parse"
	echo "./amicStats.sh <path/to/your/csv>"
	exit 1
fi

sed 1d $1 > ./trimmedCSV

echo "Base stats on %age variations in file"
uniqueValuesInFile=`cut -d, -f 2 ./trimmedCSV | sort | uniq | tr '\n' ' '`

echo "Unique values found: $uniqueValuesInFile"

for valueToLookup in $uniqueValuesInFile; do
	
	currentLookup=`egrep -- "\+$valueToLookup" ./trimmedCSV | wc -l`;
	echo "Occurences of '$valueToLookup' in file: $currentLookup";
done

./amicBinary.sh
