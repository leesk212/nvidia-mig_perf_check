#!/bin/bash
i=1

echo "logging" > ./result_of_mig_disabled.txt


while :
do
	echo "================================"

	if [ ${i} == "1" ] ; then size=1; fi
	if [ ${i} == "2" ] ; then size=1250; fi
	if [ ${i} == "3" ] ; then size=2500; fi
	if [ ${i} == "4" ] ; then size=3750; fi
	if [ ${i} == "5" ] ; then size=5000; fi
	if [ ${i} == "6" ] ; then size=6250; fi
	if [ ${i} == "7" ] ; then size=7500; fi
	if [ ${i} == "8" ] ; then size=8750; fi
        if [ ${i} == "9" ] ; then size=10000; fi
        if [ ${i} == "10" ] ; then size=11250; fi
        if [ ${i} == "11" ] ; then size=12500; fi
        if [ ${i} == "12" ] ; then size=13750; fi
        if [ ${i} == "13" ] ; then size=15000; fi
        if [ ${i} == "14" ] ; then size=16250; fi
        if [ ${i} == "15" ] ; then size=17500; fi
        if [ ${i} == "16" ] ; then size=18750; fi
        if [ ${i} == "17" ] ; then size=20000; fi
        if [ ${i} == "18" ] ; then break; fi
		
	
	disable=2

	size=$(($size * $disable))
	
	echo "logging" > ./mig_disabled/mig_disabled_${size}.txt

	for number in {1..10} 
       		do
			echo $size
			StartTime=$(date +%s.%3N)
			./mig_disabled.sh $size
			EndTime=$(date +%s.%3N)
			diff=$( echo "$EndTime - $StartTime" | bc -l )		

			echo " Latency: $diff s"
			echo "$diff" >> ./mig_disabled/mig_disabled_${size}.txt

		done
		
	python3 avg.py mig_disabled_${size}.txt >> ./result_of_mig_disabled.txt

	((i+=1))
done
