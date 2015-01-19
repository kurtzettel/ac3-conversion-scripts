#! /bin/bash


basedir=/media/drive2/videos/Movies/

find $basedir -type f -name "*.m4v" | while read file; do
  echo "Found file ${file}"
  ffmpegoutput=`ffmpeg -i "${file}" -n 2>&1`
  #echo $ffmpegoutput
  if echo "${ffmpegoutput}" | grep aac
  then
    echo "Is AAC"
  else
    echo "Is Not AAC"
    if echo "$ffmpegoutput" | grep ac3
    then
       echo "This is an AC3 File.\n\n"
       set -e
       command="ffmpeg -i \"${file}\" -n -vcodec copy -acodec aac -b:a 160k -strict -2 \"${file}.new.m4v\""
       echo "Command:\n${command}"
       ffmpeg -i "${file}" -nostdin -n -vcodec copy -acodec aac -b:a 160k -strict -2 "${file}.new.m4v"
       set +e
       mv "${file}.new.m4v" "${file}"
       #exit
    fi
  fi
done

