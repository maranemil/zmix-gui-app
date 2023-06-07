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

while getopts "i:h:d:t:s": option; do
  # shellcheck disable=SC2220
  case ${option} in
      i) FILE=${OPTARG} ;;
      h) HELP=1 && echo "Option -h übergeben" ;;
      d) DEL=${OPTARG} ;;
      t) TYPE=${OPTARG} ;;
      s) SIZE=${OPTARG} ;;
  esac
done

if [[ $HELP ]]; then
  echo "--------------------------------------------------"
  echo "HELP: "
  echo "usage: bash zmix_rubberband.sh -i load/in.mp3 -d yes -t 1"
  echo "usage: bash zmix_rubberband.sh -i load/in.mp3 -dy -t1"
  echo "usage: bash zmix_rubberband.sh -hy"
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

# check if arg d is set
if [ "$DEL" ]; then
  DEL="yes"
  echo "\DEL set to $DEL."
fi

# if arg i is not set
if [ -z "$FILE" ] || [ "$FILE" == "" ]; then
  echo "\FILE for input not specified. Exit."
  exit
fi

echo "------------------start---------------------------"

#if [ -z "$SIZE" ]
#then
#      echo "\$SIZE is empty"
#      SIZE=1.3
#      #
#else
#      echo "\$SIZE is NOT empty"
#fi


TEND=120
SIZE=1.5
echo "size specified is: " $SIZE

echo "Loaded File: " "$FILE"

if [ ! -f "$FILE" ]; then
  echo "File does not exist! Bye!"
  exit
fi

#echo "Delete existing files? " $DEL

#--------------------------------------------
# REMOVE OLD SPLIT FILES
#--------------------------------------------
if [ "$DEL" ]; then
  files=(/split/*)
  if [ ${#files[@]} -gt 0 ]; then
    for f in split/*.wav; do
      rm -f "$f"
      #echo "Removed file: $f"
    done
  fi
  files=(/output/*)
  if [ ${#files[@]} -gt 0 ]; then
    for f in output/*.wav; do
      rm -f "$f"
      #echo "Removed file: $f"
    done
  fi
  files=(/rubberband/*)
  if [ ${#files[@]} -gt 0 ]; then
    for f in rubberband/*.wav; do
      rm -f "$f"
      #echo "Removed file: $f"
    done
  fi
fi

sleep 2s

#--------------------------------------------
# SPLIT WAV N FILES 1 SECOND LENGTH
#--------------------------------------------

echo "Spliting file in segments ... " 

case $TYPE in
1)
  echo "SETUP 1 > volume=3dB"
  ffmpeg -i "$FILE" -map 0 -f segment -segment_time "$SIZE" -af "volume=3dB" -t $TEND -y split/split_%03d.wav 2>/dev/null
  ;;
2)
  echo "SETUP 2 > volume=3dB, equalizer=f=440:width_type=o:width=2:g=-5,areverse"
  ffmpeg -i "$FILE" -map 0 -f segment -segment_time "$SIZE" \
    -af "volume=3dB, equalizer=f=440:width_type=o:width=2:g=-5,areverse" -t $TEND -y split/split_%03d.wav 2>/dev/null
  ;;
3)
  echo "SETUP 3 > volume=3dB,equalizer=f=40:width_type=o:width=2:g=-7,areverse"
  ffmpeg -i "$FILE" -map 0 -f segment -segment_time "$SIZE" \
    -af "volume=3dB,equalizer=f=40:width_type=o:width=2:g=-7,areverse" -t $TEND -y split/split_%03d.wav 2>/dev/null
  ;;
4)
  echo "SETUP 4 > volume=3dB,equalizer=f=540:width_type=o:width=2:g=-9,areverse"
  ffmpeg -i "$FILE" -map 0 -f segment -segment_time "$SIZE" -segment_time_delta 0.9 \
    -af "volume=3dB,equalizer=f=540:width_type=o:width=2:g=-9,areverse" -t $TEND -y split/split_%03d.wav 2>/dev/null
  ;;
*)
  echo "SETUP default"
  ffmpeg -i "$FILE" -map 0 -f segment -segment_time "$SIZE" -acodec pcm_s16le -y split/split_%03d.wav -t $TEND 2>/dev/null
  ;;
esac

sleep 4s


echo "generating rubberband files ... "
# https://manpages.debian.org/unstable/rubberband-cli/rubberband.1.en.html
# -t, --time  -t $(shuf -i0-2 -n1)
# -p, --pitch
# -T, --tempo  -T $(shuf -i0-2 -n1)
# -c, --crisp N

if [ ${#files[@]} -gt 0 ]; then
  for f in split/*.wav; do
    echo "$f"
    #cmdrb="rubberband -c $(shuf -i0-5 -n1)  -t $(shuf -i0-3 -n1)  -T $(shuf -i0-1 -n1)   -p $(shuf -i0-8 -n1) $f rubberband/$(basename $f) 2>/dev/null"
    #cmdrb="rubberband -c $(shuf -i0-3 -n1)  -t $(shuf -i0-5 -n1)  -T $(shuf -i0-2 -n1)   -p $(shuf -i0-14 -n1) $f rubberband/$(basename $f) 2>/dev/null"
    # shellcheck disable=SC2016
    #cmdrb='rubberband -c $(shuf -i0-3 -n1)  -t $(shuf -i0-1 -n1)  -T $(shuf -i0-2 -n1) -p $(shuf -i0-6 -n1) $f rubberband/$(basename $f) '
    cmdrb='rubberband -c $(shuf -i1-5 -n1)  -t $(shuf -i0-1 -n1) -p $(shuf -i0-8 -n1) $f rubberband/$(basename $f) '
    eval "$cmdrb"
  done
fi


echo "existing rubberband  ... "
#exit;

sleep 2s

# rename files
num=0; for i in rubberband/*.wav; do mv "$i" "rubberband/split_$(printf '%03d' $num).wav"; ((num++)); done


echo "generating outputmix files ... "

# shellcheck disable=SC2209
# shellcheck disable=SC2012
FILESMAX=$(ls rubberband/ | wc -l)
MAXFILES=$(("$FILESMAX"-1))
echo "$MAXFILES"
#exit

# shellcheck disable=SC2034
for i in {1..16}; do

  #--------------------------------------------
  #CONCAT 4 WAVS - Rand(10+x)
  #--------------------------------------------

  # generate random number from 0 to N
  # shellcheck disable=SC2046
  RANDOM1=$(printf %03d $(shuf -i0-$MAXFILES -n1))
  # shellcheck disable=SC2046
  RANDOM2=$(printf %03d $(shuf -i0-$MAXFILES -n1))
  # shellcheck disable=SC2046
  RANDOM3=$(printf %03d $(shuf -i0-$MAXFILES -n1))
  # shellcheck disable=SC2046
  RANDOM4=$(printf %03d $(shuf -i0-$MAXFILES -n1))
  # shellcheck disable=SC2046
  RANDOM5=$(printf %03d $(shuf -i0-$MAXFILES -n1))
  # shellcheck disable=SC2046
  RANDOM6=$(printf %03d $(shuf -i0-$MAXFILES -n1))
  # echo "$(date +%s)"
  # shellcheck disable=SC2086
  echo "Random Sequences: " $RANDOM1, $RANDOM2, $RANDOM3, $RANDOM4, $RANDOM5, $RANDOM6
  cmd="ffmpeg
  -i rubberband/split_$RANDOM1.wav
  -i rubberband/split_$RANDOM2.wav
  -i rubberband/split_$RANDOM3.wav
  -i rubberband/split_$RANDOM4.wav
  -i rubberband/split_$RANDOM5.wav
  -i rubberband/split_$RANDOM6.wav
  -filter_complex [0:0][1:0][2:0][3:0][4:0][5:0]concat=n=6:v=0:a=1[out]
  -map '[out]' output/zmix_$(date +%s).wav  " # -report 2>/dev/null
  # shellcheck disable=SC2086
  eval $cmd
  sleep 5s
done

echo "------------------finish---------------------------"
