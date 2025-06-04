#!/bin/bash

# S3 bucket name
BUCKET_NAME="brenn-backups-2025"

# Backup folder
BACKUP_FOLDER="/mnt/backup_nfs/full/"

# Todays date
TODAY=$(date +%F)

# File to upload
BACKUP_FILE="${BACKUP_FOLDER}${TODAY}_full_backup.tar.gz.gpg"

# Upload to S3
aws s3 cp "$BACKUP_FILE" s3://$BUCKET_NAME/ --storage-class STANDARD_IA

echo "Upload of $BACKUP_FILE to S3 bucket BUCKET_NAME completed."
