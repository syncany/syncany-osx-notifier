#!/bin/bash

SCRIPTDIR="$( cd "$( dirname "$0" )" && pwd )"
BUILDDIR="$SCRIPTDIR/build"
UPLOADDIR="$BUILDDIR/upload"

if [ -n "$TRAVIS_PULL_REQUEST" -a "$TRAVIS_PULL_REQUEST" != "false" ]; then
	echo "NOTE: Skipping FTP upload. This job is a PULL REQUEST."
	exit 0
fi

if [ "$SYNCANY_FTP_HOST" == "" -o "$SYNCANY_FTP_USER" == "" -o "$SYNCANY_FTP_PASS" == "" ]; then
	echo "ERROR: SYNCANY_FTP_* environment variables not set."
	exit 1
fi

mkdir -p $UPLOADDIR

# Gather deb/tar-gz/zip
echo ""
echo "Preparing files for upload ..."
echo "------------------------------------"
mv syncany-osx-notifier_*.app.zip $UPLOADDIR

PWD=`pwd`
cd $UPLOADDIR
shasum -a 256 * 2>/dev/null 
cd "$PWD"

# Copy to FTP 
echo ""
echo "Uploading files to Syncany FTP ..."
echo "------------------------------------"

FTPOK=/tmp/syncany.ftpok
touch $FTPOK

lftp -c "open ftp://$SYNCANY_FTP_HOST
user $SYNCANY_FTP_USER $SYNCANY_FTP_PASS
mirror --reverse --exclude javadoc/ --exclude reports/ --delete --parallel=3 --verbose $UPLOADDIR /
put $FTPOK -o /syncany.ftpok
bye
"

# Delete UPLOADDIR
rm -rf "$UPLOADDIR"
