#!/bin/bash
# Script télécharger des vidéos YouTube
# redz 16/12/2024

if ! command -v yt-dlp &> /dev/null
then
    echo "yt-dlp n'est pas installé."
    exit 1
fi

if [ -z "$1" ];
then
    echo "Usage: $0 <URL>"
    exit 1
fi

URL=$1
DOWNLOAD_DIR="/opt/yt/downloads"
LOG_DIR="/var/log/yt"
LOG_FILE="$LOG_DIR/download.log"

if [ ! -d "$DOWNLOAD_DIR" ];
then
    echo "Le dossier de téléchargement $DOWNLOAD_DIR n'existe pas."
    exit 1
fi

if [ ! -d "$LOG_DIR" ];
then
    echo "Le dossier de log $LOG_DIR n'existe pas."
    exit 1
fi

VIDEO_NAME=$(yt-dlp --get-filename -o "%(title)s" "$URL" 2> /dev/null)

VIDEO_DIR="$DOWNLOAD_DIR/$VIDEO_NAME"
mkdir -p "$VIDEO_DIR"

yt-dlp -o "$VIDEO_DIR/$VIDEO_NAME.%(ext)s" "$URL" > /dev/null 2>&1
yt-dlp --write-description -o "$VIDEO_DIR/description" "$URL" > /dev/null 2>&1

DATE=$(date +"%y/%m/%d %H:%M:%S")
echo "[$DATE] Video $URL was downloaded. File path : $VIDEO_DIR/$VIDEO_NAME.mp4" >> "$LOG_FILE"

echo "Video $URL was downloaded."
echo "File path : $VIDEO_DIR/$VIDEO_NAME.mp4"