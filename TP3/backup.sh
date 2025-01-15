#!/bin/bash

SOURCE_DIR="/srv/music"
DEST_DIR="/mnt/music_backup"

TIMESTAMP=$(date +"%y%m%d_%H%M%S")
ARCHIVE_NAME="music_${TIMESTAMP}.tar.gz"

tar -czf "${DEST_DIR}/${ARCHIVE_NAME}" -C "${SOURCE_DIR}" .

if [ $? -eq 0 ]; then
  echo "Backup successful: ${ARCHIVE_NAME}"
else
  echo "Backup failed"
fi