#!/bin/bash -e

if [ "$1" == "" ]; then 
	echo "you need to specify a CSV file to parse"
	echo "./amicStats.sh <path/to/your/csv>"
	exit 1
fi

#VALUES='0.0038 0.0076 0.0075 0.0037 0.0039'

echo "%age variations stats in file"
uniqueValuesInFile=`cut -d, -f 2 "$1" | sort | uniq | tr '\n' ' '`

echo "Unique values found: $uniqueValuesInFile"

for valueToLookup in $uniqueValuesInFile; do
	echo "Occurences of '$valueToLookup' in file: `egrep -- "$valueToLookup" $1 | wc -l`"
done

echo "Binary string output (using 0.00038/7% as 1s and 0.00076/5% as 0s)"
output=`cut -d, -f 3 "$1" | sed 's/\n//g'`
printf -v order '%s' $output
echo $order

#echo "Reverse binary string output"
#reverseOutput=`cut -d, -f 4 "$1" | sed 's/\n//g'`
#printf -v reverse '%s' $reverseOutput
#echo $reverse
