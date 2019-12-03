#!/usr/bin/env bash

mkdir /tmp/import_files
cp /import/*.mrc /tmp/import_files
cp /import/*.marcxml /tmp/import_files
cp /import/*.xml /tmp/import_files

echo "Importing sample data..."
/usr/local/vufind/local/import/import.sh /tmp/import_files/
echo "Done."