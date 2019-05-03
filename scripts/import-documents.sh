#!/bin/bash

# Usage:    ./run.sh import-documents.sh fileName
# Example:  ./run.sh import-documents.sh nfn.1.csv


document=$1
# originalSource="https://waterworld.com/content/leftcolumn/whitepaper/Chlor-Alkali_White%20Paper.pdf"
originalSource=$(awk -F "|" '{print $1}' <<< $document)
# mediaPath="files/base/scomm/nfn/document/2015/03"
mediaPath=$(awk -F "|" '{print $2}' <<< $document)
# localfilename="photometric_colorimetricanalyze_v0021.pd"
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