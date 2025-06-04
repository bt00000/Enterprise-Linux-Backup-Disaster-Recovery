#!/bin/bash

# Directories
INCREMENTAL_DIR="/mnt/backup_nfs/incremental"
FULL_DIR="/mnt/backup_nfs/full"

# Delete incremental backups older than 7 days
find "$INCREMENTAL_DIR" -mindepth 1 -maxdepth 1 -type d -mtime +7 -exec rm -rf {} \;

# Delete full backups older than 28 days (4 weeks)
find "$FULL_DIR" -type f -name "*.tar.gz.gpg" -mtime +28 -exec rm =f {} \;

echo "Cleanup completed on $(date)"
