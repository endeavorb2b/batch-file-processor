#!/bin/bash
export Y='\033[0;33m'
export G='\033[0;32m'
export R='\033[0;31m'
export N='\033[0m'
domain="waterworld.com"

# Total number of lines in file
filelines=$(wc -l < /data/$1)
# Number of chunks in the array
split=200
# Loop counter
counter=0
# Figures out skip based on lines and split
loopSize=$(($filelines / $split + 1))

# +1 because arrays start a 0 and sed starts at 1
start=2
end=($split + 1)
chunkList=[]

while [  $counter -lt $loopSize ]; do
  let counter++
  echo -e "$Y Loop[$counter/$loopSize] Loop Size[$split] $N"
  sedEnd="${end}p"
  
  echo $start $sedEnd 
  
  # Chunk into array
  chunkList="$(sed -n $start,$sedEnd < /data/$1)"
  

  data=''
  for line in ${chunkList[@]}; do
    originalMediaPath=$(awk -F "|" '{print $2}' <<< $line)
    originalNewFilename=$(awk -F "|" '{print $3}' <<< $line)
    #formate json
    data+="\"url\":\"https://img.$domain/$originalMediaPath/$originalNewFilename\","
  
  done
  
  # remove trailing comma
  data="{$(echo $data | sed '$ s/,$//g')}"
  
  curl 'https://api.imgix.com/v2/image/purger' \
    -u "$IMGIX_API:" \
    -H 'Content-Type: application/json' \
    -d "$data"
  

  start=$(($end + 1))
  end=$(($end + $split))
  
done