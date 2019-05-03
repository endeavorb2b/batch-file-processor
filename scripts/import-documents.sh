#!/bin/bash

# Usage:    ./getdocuments.sh fileName
# Example:  ./getdocuments.sh nfn.1.csv

#mediaPath="files/base/scomm/nfn/document/2015/03"
document=$1

originalSource=$(awk -F "|" '{print $1}' <<< $document)
mediaPath=$(awk -F "|" '{print $2}' <<< $document)
localfilename=$(awk -F "|" '{print $3}' <<< $document)


if [ $(aws s3 ls "s3://media.cygnus.com/$mediaPath/$localfilename" | wc -l) -ge 1 ]; then
  echo -e "$G Already processed $localfilename, skipping! $N"
  echo "Already downloaded, skipping:  $localfilename" >> "logs/skip/$FILE"
  exit 0;
fi

# Download the document
wget --quiet -O $localfilename "$originalSource" --timeout=5

if [ -s "$localfilename" ]; then
  echo -e "$G Successfully downloaded $localfilename. $N"
  echo "Successfully downloaded $originalSource -- $localfilename" >> "logs/success/$FILE"

  # Move the document to the folder
  remotePath="s3://media.cygnus.com/$mediaPath/$localfilename"
  # echo "> aws s3 cp $localfilename $remotePath"
  aws s3 cp --quiet $localfilename $remotePath

else
  echo -e "$R Unable to download $localfilename! $N"
  echo $document >> "logs/error/$FILE"
fi

#cleanup
rm -f $localfilename