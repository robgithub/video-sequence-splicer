#!/bin/bash

# WARNING! this script is trying to be generic, but not very well, bottom line, not likely to work for any other case that mine :(
# get file glob
TARGET=$1
if [ -z "$TARGET" ]; then
  echo "ERROR: Missing file glob"
  exit
fi
# read into array
FILELIST=$(find $(dirname "$TARGET") -maxdepth 1 -name $(basename "$TARGET") -printf "%p\n" | sort)
FCOUNT=$(find $(dirname "$TARGET") -maxdepth 1 -name $(basename "$TARGET") -printf "%p\n" | wc -l)
# report count
echo "$FCOUNT files to process"

# get time span in seconds
TSECONDS=$2
if [ -z "$TSECONDS" ]; then
  echo "ERROR: Missing number of seconds to splice"
  exit
fi
echo splice in $TSECONDS second chunks
# for each file name in the array calculate the time start and time end values
from=0
to=$TSECONDS
singlefile=$(echo $FILELIST | cut -d ' ' -f 1)
echo "single file  to read length from $singlefile"
# this is not going to work for anyone else :(
MAXS=$(mplayer -vo null -ao null -frames 0 -identify "$singlefile" 2>/dev/null | egrep ID_LENGTH | egrep -o "[0-9]+" | head -n 1)
echo "video lengh to work with $MAXS"
# execute ffmpeg to splice out that chunk




# generate $splicename and build indexes





for file in ${FILELIST[@]}; do
  if [ $from -gt $to ]; then
    buto=$to
    to=$MAXS
    echo extra splicing $file $from $to
    ffmpeg -i "$file" -ss 00:00:03 -to 00:00:08 -async 1 -strict -2 "$splicename"
    to=$buto
    from=0
  fi
  echo splicing $file $from $to
  from=$to
  to=$(($to + $TSECONDS))
  if [ $to -gt $MAXS ]; then
     to=$(($to - $MAXS))
  fi
  if [ $from -eq $MAXS ]; then
     from=0
  fi
done

# create ffmpeg sequence file 
# create new video

