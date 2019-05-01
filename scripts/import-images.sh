#!/bin/bash

# Usage:    ./getimages.sh fileName
# Example:  ./getimages.sh nfn.1.csv

#mediaPath="files/base/scomm/nfn/image/2015/03"
image=$1

originalSourcePath=$(awk -F "|" '{print $1}' <<< $image)
originalMediaPath=$(awk -F "|" '{print $2}' <<< $image)
originalNewFilename=$(awk -F "|" '{print $3}' <<< $image)

sourcePath=$(awk -F "|" '{print $1}' <<< $image)
mediaPath=$(awk -F "|" '{print $2}' <<< $image)
newFilename=$(awk -F "|" '{print $3}' <<< $image)
newFilename=$(echo $newFilename | tr -d '\r')

imagepath=(${sourcePath//\// })
arr_last=$((${#imagepath[@]}-1))
localfilename=${imagepath[$arr_last]}

localfileArr=(${localfilename//./ })
arr_last=$((${#localfileArr[@]}-1))
oldExtension=${localfileArr[$arr_last]}

newArr=(${newFilename//./ })
arr_last=$((${#newArr[@]}-1))
newExtension=${newArr[$arr_last]}

unset newArr[$arr_last]
convertedName=$(IFS=. ; echo "${newArr[*]}")

localfilename="$convertedName.$oldExtension"

if [ $(aws s3 ls "s3://media.cygnus.com/$mediaPath/original/$localfilename" | wc -l) -ge 1 ]; then
  echo -e "$G Already processed $localfilename, skipping! $N"
  echo "Already downloaded, skipping:  $localfilename" #>> logs/skip
    exit 0;
fi


# Download the image
wget -O $localfilename "$sourcePath" --timeout=5

if [ -s "$localfilename" ]; then
  echo -e "$G Successfully downloaded $localfilename. $N"
  echo "Successfully downloaded $sourcePath -- $localfilename" >> logs/success

  # Move the image to the original folder
  remotePath="s3://media.cygnus.com/$mediaPath/original/$convertedName.$oldExtension"
  echo "Uploading original:"
  # echo "> aws s3 cp $localfilename $remotePath"
  aws s3 cp $localfilename $remotePath

  # Convert the original
  newPath="$(pwd)/converted/$convertedName.$newExtension"
  echo "Converting to PNG and resampling to 1920w:"
  # echo "> convert $localfilename -gravity center  -thumbnail 1920 PNG32:$newPath"
  /usr/local/bin/convert $localfilename -gravity center  -resize "1920x>" PNG32:$newPath

  # Upload the converted
  remotePath="s3://media.cygnus.com/$mediaPath/$convertedName.$newExtension"
  echo "Storing converted image:"
  # echo "> aws s3 cp $newPath $remotePath"
  aws s3 cp $newPath $remotePath
  rm -f $newPath
else
  echo -e "$R Unable to download $localfilename! $N"
  echo $image >> logs/error
fi

#cleanup
rm -f $localfilename