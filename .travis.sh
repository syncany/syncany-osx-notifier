#!/bin/bash

version=$(jq -r .version package.json)
release=$(git log -n 1 --pretty=%d HEAD | grep master)
snapshot=$([ -z "$release" ] && echo "true" || echo "false")
revision=$(git rev-parse --short HEAD)
date=$(date)
timestamp=$(date +%s)

echo "Build information"
echo "---------------------"
echo -e "Version: $version\nSnapshot: $snapshot\nCompile Date: $date\nRevision: $revision" > build.info
cat build.info
echo "---------------------"
echo ""

zip syncany-osx-notifier.app.zip build.info > /dev/null 2>&1

if [ -z "$release" ]; then
	filename=syncany-osx-notifier_$version+SNAPSHOT.$timestamp.$revision.app.zip

	echo "Renaming to SNAPSHOT release: $filename ..."
	mv syncany-osx-notifier.app.zip $filename
else
	filename=syncany-osx-notifier_$version.app.zip

	echo "Renaming to RELEASE: $filename ..."
	mv syncany-osx-notifier.app.zip $filename
fi
