#!/bin/bash

folder="./exp_nanjing_hengxiang"
if [ -d "$folder" ]; then
  cd "$folder"
  gfortran main_hengxiang_serial.f90 -o a.out &&
  pwd
  if [ -f "a.out" ]; then
    log="output_file$i.txt"
    ./a.out &
    echo "Started a.out in $folder"
  else
    echo "a.out not found in $folder"
  fi
  cd ..
else
  echo "$folder not found"
fi
