#!/bin/bash

# https://github.com/$BINTRAY_OWNER/greenbox/blob/apps_modular/upload_app.sh


BINTRAY_API_KEY=${BINTRAY_API_KEY:-`cat bintray_api_key`}

BINTRAY_OWNER=hernad
BINTRAY_REPOS=harbour
BINTRAY_PACKAGE=$1
BINTRAY_PACKAGE_VER=$2

pacman --noconfirm -S curl zip unzip
pacman --noconfirm -S --needed mingw-w64-$MINGW_ARCH-postgresql mingw-w64-$MINGW_ARCH-icu mingw-w64-$MINGW_ARCH-curl mingw-w64-$MINGW_ARCH-openssl
mkdir artifacts
echo "test" > artifacts/test.txt

FILE=${BINTRAY_PACKAGE}_${$BINTRAY_PACKAGE_VER}.zip

cd artifacts && zip -r -v $FILE .

ls -lh $FILE

echo uploading $FILE to bintray ...

curl -s -T $FILE \
      -u $BINTRAY_OWNER:$BINTRAY_API_KEY \
      --header "X-Bintray-Override: 1" \
     https://api.bintray.com/content/$BINTRAY_OWNER/$BINTRAY_REPOS/$BINTRAY_PACKAGE/$BINTRAY_PACKAGE_VER/$FILE

curl -s -u $BINTRAY_OWNER:$BINTRAY_API_KEY \
   -X POST https://api.bintray.com/content/$BINTRAY_OWNER/$BINTRAY_REPOS/$BINTRAY_PACKAGE/$BINTRAY_PACKAGE_VER/publish
