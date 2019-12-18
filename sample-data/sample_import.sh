#!/usr/bin/env bash

mkdir /tmp/import_files
cp /import/bibliographic/*.mrc /tmp/import_files/bibliographic
cp /import/bibliographic/*.marcxml /tmp/import_files/bibliographic
cp /import/bibliographic/*.xml /tmp/import_files/bibliographic

echo "Importing bibliographic sample data..."
/usr/local/vufind/local/import/import.sh /tmp/import_files/bibliographic
echo "Done."

cp /import/authority/*.mrc /tmp/import_files/authority
cp /import/authority/*.marcxml /tmp/import_files/authority
cp /import/authority/*.xml /tmp/import_files/authority

echo "Importing authority sample data..."
/usr/local/vufind/local/import/import-auth.sh /tmp/import_files/authority
echo "Done."