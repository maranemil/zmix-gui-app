#!/bin/bash

#############################################
#
#   Generate Random Sequences from same track
#
#############################################

# requirements
# sudo apt install rubberband-cli
# sudo apt install ffmpeg

#shopt -s nullglob dotglob

while getopts i:h:d:t:s: option; do
  # shellcheck disable=SC2220
  case "${option}" in
  i) FILE=${OPTARG} ;;
  h) HELP=${OPTARG} ;;
  d) DEL=${OPTARG} ;;
  t) TYPE=${OPTARG} ;;
  s) SIZE=${OPTARG} ;;
  esac
done

if [ "$HELP" ]; then
  echo "--------------------------------------------------"
  echo "HELP: "
  echo "usage: bash zmix_split.sh -i load/in.mp3 -dy -t * -s 0.6"
  echo ""
  echo "options:"
  echo "-h yes        - help"
  echo "-i file.mp3   - specify input file"
  echo "-d yes        - delete old generated temp files"
  echo "-t *          - chose setup for split:"
  echo "               * = default "
  echo "               1 = volume=3dB"
  echo "               2 = volume=3dB, equalizer=f=440:width_type=o:width=2:g=-5,areverse"
  echo "               3 = volume=3dB,equalizer=f=40:width_type=o:width=2:g=-7,areverse"
  echo "               4 = volume=3dB,equalizer=f=540:width_type=o:width=2:g=-9,areverse"
  echo "--------------------------------------------------"
  exit
fi

echo "------------------start---------------------------"



if [ -z "$SIZE" ]
then
      echo "\$SIZE is empty"
      SIZE=1
      #exit
else
      echo "\$SIZE is NOT empty"
fi
echo "size specified is: " $SIZE

echo "Loaded File: " "$FILE"

if [ ! -f "$FILE" ]; then
  echo "File does not exist! Bye!"
  exit
fi

# check if arg d is set
if [ "$DEL" ]; then
  DEL="yes"
  echo "\DEL set to $DEL."
fi

echo "Delete existing files? " $DEL
# exit;

#--------------------------------------------
# REMOVE OLD SPLIT FILES
#--------------------------------------------
if [ "$DEL" ]; then
  files=(/split/*)
  if [ ${#files[@]} -gt 0 ]; then
    for f in split/*.wav; do
      rm $f
      #echo "Removed file: $f"
    done
  fi
  files=(/output/*)
  if [ ${#files[@]} -gt 0 ]; then
    for f in output/*.wav; do
      rm $f
      #echo "Removed file: $f"
    done
  fi
fi

sleep 2s

#--------------------------------------------
# SPLIT WAV N FILES 1 SECOND LENGTH
#--------------------------------------------

case $TYPE in
1)
  echo "SETUP 1 > volume=3dB"
  ffmpeg -i "$FILE" -map 0 -f segment -segment_time "$SIZE" \
    -af "volume=3dB" -t 20 -y split/split_%03d.wav 2>/dev/null
  ;;
2)
  echo "SETUP 2 > volume=3dB, equalizer=f=440:width_type=o:width=2:g=-5,areverse"
  ffmpeg -i "$FILE" -map 0 -f segment -segment_time "$SIZE" \
    -af "volume=3dB, equalizer=f=440:width_type=o:width=2:g=-5,areverse" -t 20 -y split/split_%03d.wav 2>/dev/null
  ;;
3)
  echo "SETUP 3 > volume=3dB,equalizer=f=40:width_type=o:width=2:g=-7,areverse"
  ffmpeg -i "$FILE" -map 0 -f segment -segment_time "$SIZE" \
    -af "volume=3dB,equalizer=f=40:width_type=o:width=2:g=-7,areverse" -t 20 -y split/split_%03d.wav 2>/dev/null
  ;;
4)
  echo "SETUP 4 > volume=3dB,equalizer=f=540:width_type=o:width=2:g=-9,areverse"
  ffmpeg -i "$FILE" -map 0 -f segment -segment_time "$SIZE" -segment_time_delta 0.9 \
    -af "volume=3dB,equalizer=f=540:width_type=o:width=2:g=-9,areverse" -t 20 -y split/split_%03d.wav 2>/dev/null
  ;;
*)
  echo "SETUP default"
  ffmpeg -i "$FILE" -map 0 -f segment -segment_time "$SIZE" -c copy -y split/split_%03d.wav 2>/dev/null
  ;;
esac

sleep 2s

# shellcheck disable=SC2034
for i in 1 2 3 4 5 6 7; do
  #--------------------------------------------
  #CONCAT 4 WAVS - Rand(10+x)
  #--------------------------------------------
  # generate random number from 0 to 7
  RANDOM1=$(shuf -i0-7 -n1)
  RANDOM2=$(shuf -i0-7 -n1)
  RANDOM3=$(shuf -i0-7 -n1)
  RANDOM4=$(shuf -i0-7 -n1)
  RANDOM5=$(shuf -i0-7 -n1)
  RANDOM6=$(shuf -i0-7 -n1)
  # echo "$(date +%s)"
  # shellcheck disable=SC2086
  echo "Random Sequences: " $RANDOM1, $RANDOM2, $RANDOM3, $RANDOM4, $RANDOM5, $RANDOM6
  cmd="ffmpeg
  -i split/split_00$RANDOM1.wav
  -i split/split_00$RANDOM2.wav
  -i split/split_00$RANDOM3.wav
  -i split/split_00$RANDOM4.wav
  -i split/split_00$RANDOM5.wav
  -i split/split_00$RANDOM6.wav
  -filter_complex [0:0][1:0][2:0][3:0][4:0][5:0]concat=n=6:v=0:a=1[out]
  -map '[out]' output/zmix_$(date +%s).wav 2>/dev/null " # -report
  # shellcheck disable=SC2086
  eval $cmd
  sleep 2s
done

echo "------------------finish---------------------------"