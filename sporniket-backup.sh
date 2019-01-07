#!/bin/bash
#
# Create a compressed archive (*.tar.gz) of a list of specified files and folders
#
# Require tar and gzip.
#
# $1 : path of the folder storing the backups


FOLDER_CONFIG="$HOME/.sporny-backup"
FOLDER_TARGET="$1"

FILE_TARGET="$FOLDER_TARGET/sporny-backup--$(date +%Y%m%d-%H%M%S)"
FILE_FILESPECS="$FOLDER_CONFIG/files"
FILE_FOLDERSPECS="$FOLDER_CONFIG/folders"

MARKER_OK="\033[01;32mOK   \033[00m --"
MARKER_INFO="\033[01;34mINFO \033[00m --"
MARKER_ERROR="\033[01;31mERROR\033[00m --"

# Sanity checks : configuration folder
if [[ ! -d "$FOLDER_CONFIG" ]]; then
  echo -e "$MARKER_ERROR The config folder is not a folder : $FOLDER_CONFIG"
  exit 1
fi

if [[ ! -e "$FILE_FILESPECS" ]]; then
  touch $FILE_FILESPECS
fi
echo -e "$MARKER_INFO Will read $FILE_FILESPECS"


if [[ ! -e "$FILE_FOLDERSPECS" ]]; then
  touch $FILE_FOLDERSPECS
fi
echo -e "$MARKER_INFO Will read $FILE_FOLDERSPECS"

# Sanity checks : target storage folder
if [[ ! -d "$FOLDER_TARGET" ]]; then
  echo -e "$MARKER_ERROR The folder to store backups is not a folder : $FOLDER_TARGET"
  exit 1
fi

# OK, proceed
cd $HOME

FILE_UNARC="$FILE_TARGET.tar"
FILE_ARC="$FILE_UNARC.gz"

echo -e "$MARKER_INFO adding individual files..."
for fich in $(cat $FILE_FILESPECS); do
  #statements
  tar -rvf $FILE_UNARC $fich
done

echo -e "$MARKER_INFO adding whole folders..."
for fich in $(cat $FILE_FOLDERSPECS); do
  #statements
  echo -e "$MARKER_INFO adding $fich..."
  tar -rvf $FILE_UNARC $fich
done

echo -e "$MARKER_INFO compressing $FILE_UNARC to $FILE_ARC..."
gzip $FILE_UNARC

echo -e "$MARKER_OK done."
