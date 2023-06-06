#!/bin/bash

#############################################
#
#   Generate Random Sequences from same track
#
#############################################

while getopts i:h:d:t: option; do
  # shellcheck disable=SC2220
  # shellcheck disable=SC2213
  case "${option}" in
  i) FILE=${OPTARG} ;;
  h) HELP=${OPTARG} ;;
  d) DEL=${OPTARG} ;;
  esac
done

if [ "$HELP" == "yes" ]; then
  echo "--------------------------------------------------"
  echo "HELP: "
  echo "usage: bash zmix_shuffle.sh -i load/in.mp3 -d yes -t * "
  echo ""
  echo "options:"
  echo "-h yes        - help"
  echo "-i file.mp3   - specify input file"
  echo "-d yes        - delete old generated temp files"
  echo "--------------------------------------------------"
  exit
fi

echo "------------------start---------------------------"

echo "Loaded File: " $FILE

if [ ! -f $FILE ]; then
  echo "File does not exist! Bye!"
  exit
fi

# check if arg d is set
if [ "$DEL" ]; then
  DEL="yes"
  echo "\DEL set to $DEL."
fi

echo "Delete existing files? " $DEL

#--------------------------------------------
# REMOVE OLD SPLIT FILES
#--------------------------------------------

if [ "$DEL" ]; then
  files=(/split/*)
  if [ ${#files[@]} -gt 0 ]; then
    for f in split/*.wav; do
      rm "$f"
      #echo "Removed file: $f"
    done
  fi
  files=(/output/*)
  if [ ${#files[@]} -gt 0 ]; then
    for f in output/*.wav; do
      rm "$f"
      #echo "Removed file: $f"
    done
  fi
fi

sleep 2s


#--------------------------------------------
# SPLIT WAV N FILES 1 SECOND LENGTH
#--------------------------------------------

echo "Spliting file in segments ... " 

ffmpeg -i "$FILE" -map 0 -f segment -segment_time 0.3 -c copy -y split/split_%03d.wav -t 9 2>/dev/null

#--------------------------------------------
# SHUFFLE
#--------------------------------------------

echo "generating shuffle files ... "

# shellcheck disable=SC2034
for i in 1 2 3 4 5 6 7; do

    RANDOM1=$(shuf -i0-7 -n1)
    RANDOM2=$(shuf -i0-7 -n1)
    RANDOM3=$(shuf -i0-7 -n1)
    RANDOM4=$(shuf -i0-7 -n1)
    RANDOM5=$(shuf -i0-7 -n1)
    RANDOM6=$(shuf -i0-7 -n1)

    cmd="ffmpeg
    -i $FILE
    -i $FILE
    -i $FILE
    -i $FILE
    -i $FILE
    -i $FILE
    -filter_complex \"[0:0]atrim=$RANDOM1:duration=0.5[out1];[1:0]atrim=$RANDOM2:duration=0.5[out2];[2:0]atrim=$RANDOM3:duration=0.5[out3];[3:0]atrim=$RANDOM4:duration=0.5[out4];[4:0]atrim=$RANDOM5:duration=1[out5];
    [5:0]atrim=$RANDOM6:duration=0.5[out6];[out1][out2][out3][out4][out5][out6]concat=n=6:v=0:a=1[a]\" -map [a] output/zmix_$(date +%s).wav 2>/dev/null"

    eval $cmd
  sleep 2s
done

echo "------------------finish---------------------------"
