#!/bin/bash
startYear=2010
endYear=2016
requiredWords="iot,security"
optionalWords="home automation,smart home,defense,attack"
currDir=$(pwd)

if [ $# -lt 1 ];then
  echo "Usage resultFile [startYear endYear [requiredWords optionalWords]]"
  exit 1
fi

if [ $# -ge 1 ];then
  resultFile=$1
  if [ $# -ge 3 ];then
	startYear=$2
	endYear=$3
  fi
  if [ $# -ge 5 ];then
	requiredWords=$4
	optionalWords=$5
  fi
fi

currentYear=$endYear
#afterYear=$(($currentYear - 1))
#beforeYear=$(($currentYear + 1))
echo "start query with startYear $startYear and endYear $endYear and requiredWords $requiredWords and optionalWords $optionalWords and resultFile $resultFile"
if [ -e $resultFile ];then
  echo "$resultFile exists, remove it"
  rm $resultFile
fi
while [ $currentYear -ge $startYear ];
do
  if [ $currentYear -eq $endYear ];then
	outputF="--csv-header"
  else
	outputF="--csv"
  fi
  $currDir/scholar.py -A "$requiredWords" -s "$optionalWords" -c 100 $outputF --before=$currentYear  --after=$currentYear --no-patents >>$resultFile
  if [ $? -ne 0 ];then
	echo "query error happened"
	exit 1
  fi
  ((currentYear--))
  ((beforeYear--))
  ((afterYear--))
done
