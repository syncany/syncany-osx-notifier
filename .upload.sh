#!/bin/bash

set -e

SCRIPTDIR="$( cd "$( dirname "$0" )" && pwd )"
UPLOADDIR="$SCRIPTDIR/build/upload"

if [ -n "$TRAVIS_PULL_REQUEST" -a "$TRAVIS_PULL_REQUEST" != "false" ]; then
	echo "NOTE: Skipping upload. This job is a PULL REQUEST."
	exit 0
fi

source "$SCRIPTDIR/core/gradle/upload/upload-functions"

# Gather files
mkdir -p $UPLOADDIR

echo ""
echo "Preparing files for upload ..."
echo "------------------------------------"
mv syncany-osx-notifier_*.app.zip $UPLOADDIR

PWD=`pwd`
cd $UPLOADDIR
shasum -a 256 * 2>/dev/null 
cd "$PWD"

# List files to upload
release=$(git log -n 1 --pretty=%d HEAD | grep master || true)
snapshot=$([ -z "$release" ] && echo "true" || echo "false") # Invert 'release'

echo ""
echo "Uploading"
echo "---------"

file_appzip=$(ls $UPLOADDIR/syncany-osx-notifier_*.app.zip)

echo "Uploading OSXNOTIFIER: $(basename $file_appzip) ..."
upload_file "$file_appzip" "app/osxnotifier" "snapshot=$snapshot"

# Delete UPLOADDIR
rm -rf "$UPLOADDIR"
