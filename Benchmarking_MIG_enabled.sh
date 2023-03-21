#!/bin/bash
i=1

echo "logging" > mig_enabled.txt

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
        if [ ${i} == "12" ] ; then size=15000; fi
        if [ ${i} == "13" ] ; then size=16250; fi
        if [ ${i} == "14" ] ; then size=17500; fi
        if [ ${i} == "15" ] ; then size=18750; fi
        if [ ${i} == "16" ] ; then size=20000; fi
        if [ ${i} == "17" ] ; then break; fi
		
	echo $size
	time ./mig_enabled.sh $size > mig_enabled.txt

	((i+=1))
done
