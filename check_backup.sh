#!/bin/bash

# Set email
EMAIL="youremail@gmail.com"

# Backup paths
INCREMENTAL_DIR="/mnt/backup_nfs/incremental/$(date +%F)"
FULL_BACKUP_FILE="/mnt/backup_nfs/full/$(date +%F)_full_backup.tar.gz.gpg"

# Check Incremental Backup
if [ ! -d "$INCREMENTAL_DIR" ]; then
	echo "Incremental backup missing for $(date +%F)" | mail -s "Backup Alert: Incremental Missing" "$EMAIL"
fi

# Check Full Backup (only on sunday)
DAY_OF_WEEK=$(date +%u) # 7 = Sunday
if [ "$DAY_OF_WEEK" -eq 7 ]; then
	if [ ! -f "$FULL_BACKUP_FILE" ]; then
		echo "Full backup missing for $(date +%F)" | mail -s "Backup Alert: Full Backup Missing" "$EMAIL"
	fi
fi
