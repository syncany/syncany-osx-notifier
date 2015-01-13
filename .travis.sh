#!/bin/bash

version=`jq -r .version package.json`
snapshot=`jq -r .snapshot package.json`
date=`date +"%y%m%d%H%M%S"`

echo "Writing build.info"
echo "version: $version\nsnapshot: $snapshot\nbuilddate: $date" > build.info
zip syncany-osx-notifier.app.zip build.info > /dev/null 2>&1

if [ $snapshot == true ];then
  echo "Building snapshot release"
  mv syncany-osx-notifier.app.zip syncany-osx-notifier-_$version+SNAPSHOT.$date.app.zip
else
  echo "Building release"
  mv syncany-osx-notifier.app.zip syncany-osx-notifier_$version.app.zip
fi
