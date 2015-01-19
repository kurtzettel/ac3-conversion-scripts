#! /bin/bash


basedir=/Volumes/BLUESG/Videos

h264Count=0
mpeg4Count=0
unknownVideoCount=0
accCount=0
ac3Count=0
unknownAudioCount=0

#Find any AVIs.
find $basedir -type f -name "*.avi" | while read file; do
  echo "Found file ${file}"
  filename=$(basename "$file")
  extension="${filename##*.}"
  filename="${file%.*}"
  echo "Extension:${extension}, FileName:${filename}"
  ffmpegoutput=`ffmpeg -i "${file}" -n 2>&1`
  if echo "${ffmpegoutput}" | grep aac
  then
    echo "Is AAC"
    accCount=$((accCount+1));
  else
    if echo "$ffmpegoutput" | grep ac3
    then
       ac3Count=$((ac3Count+1));
       echo "Found $ac3Count AC3";
    else
       echo "Unknown Audio Codec";
       echo "$ffmpegoutput" | grep Audio
       unknownAudioCount=$((unknownAudioCount+1));
    fi
  fi
  if echo "${ffmpegoutput}" | grep h264
  then
    echo "Is H.264 Video"
    h264Count=$((h264Count+1));
  else
    if echo "$ffmpegoutput" | grep mpeg4
    then
       mpeg4Count=$((mpeg4Count+1));

       set -e
       command="ffmpeg -i \"${file}\" -nostdin -n -c:v libx264 -preset medium -crf 23 -c:a copy \"${filename}.mkv\""
       echo "Command:\n${command}"
       ffmpeg -i "${file}" -nostdin -n -c:v libx264 -preset medium -crf 23 -c:a copy "${filename}".mkv
       rm "${file}"
       set +e
    else
       echo "Unknown Video Codec";
       echo "$ffmpegoutput" | grep Video
       unknownCount=$((unknownCount+1));
    fi
  fi
  echo "Found $accCount files with ACC and $ac3Count with AC3 and $unknownAudioCount with an unexpected codec.";
  echo "Found $h264Count files with H.264 and $mpeg4Count with MPEG4 and $unknownVideoCount with an unexpected codec.";
done

