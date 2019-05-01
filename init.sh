#!/bin/bash
export Y='\033[0;33m'
export G='\033[0;32m'
export R='\033[0;31m'
export N='\033[0m'

# Total number of lines in file
filelines=$(wc -l < /data/files/$FILE)
# Number of chunks in the array
split=$SPLIT
# Loop counter
counter=0
# Figures out skip based on lines and split
loopSize=$(($filelines / $split + 1))

# +1 because arrays start a 0 and sed starts at 1
start=1
end=($SPLIT + 1)
chunkList=[]

while [  $counter -lt $loopSize ]; do
  let counter++
  echo -e "$Y Loop[$counter/$loopSize] Loop Size[$split] $N"
  sedEnd="${end}p"
  
  # Chunk into array
  chunkList="$(sed -n $start,$sedEnd < /data/files/$FILE)"

  # Run in Parallel
  parallel /data/scripts/$SCRIPT {} ::: ${chunkList[@]}

  start=$(($end + 1))
  end=$(($end + $split))
  
done