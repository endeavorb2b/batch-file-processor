#!/bin/bash

account="ebm"
group="ww"

months=(
    "01"
    "02"
    "03"
    "04"
    "05"
    "06"
    "07"
    "08"
    "09"
    "10"
    "11"
    "12"
  )

   years=(
#     "2000"
#     "2001"
#     "2002"
#     "2003"
#     "2004"
#     "2005"
#     "2006"
#     "2007"
#     "2008"
#     "2009"
#     "2010"
#     "2011"
#     "2012"
    "2013"
    "2014"
    "2015"
    "2016"
    "2017"
    "2018"
    "2019"
  )
  
  #aws s3 ls s3://media.cygnus.com/files/base/$account/$group/image/

for year in "${years[@]}"; do
    echo $year

    for month in "${months[@]}"; do
        echo $month

        aws s3 rm --recursive  s3://media.cygnus.com/files/base/$account/$group/image/$year/$month/1280w
        aws s3 rm --recursive  s3://media.cygnus.com/files/base/$account/$group/image/$year/$month/160w
        aws s3 rm --recursive  s3://media.cygnus.com/files/base/$account/$group/image/$year/$month/320w
        aws s3 rm --recursive  s3://media.cygnus.com/files/base/$account/$group/image/$year/$month/640w
        aws s3 rm --recursive  s3://media.cygnus.com/files/base/$account/$group/image/$year/$month/960w
    done

done