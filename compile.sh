#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <main lua file> >output.lua"
  exit 1
fi

FILE=$1
DIR=`dirname $FILE`

for inc in `grep '\-\-include' $FILE |awk '{print $2}'`; do
  echo '-- ' $inc
  cat $DIR/$inc
  echo '--'
  echo ''
done

cat $FILE |sed '/--include.*$/d'
