#!/bin/bash

TODAY=$(date +%F)

# Backup Destination
BACKUP_DEST="/mnt/backup_nfs/incremental/$TODAY"

# Directories to backup
SOURCE_DIRS=("/home" "/etc" "/var/www")

# Create backup directory
mkdir -p "$BACKUP_DEST"

# Loop through /home, /etc, /var/www, back up each one
# Rsync options:
# -a: archive mode (preserver permissions, symlinks, etc..)
# -h: human-readable numbers
# -v: verbose
# --delete: delete files in destination not in source (but BE CAREFUL)

for SRC in "${SOURCE_DIRS[@]}"; do
	rsync -ahv --delete "$SRC" "$BACKUP_DEST"
done

echo "Backup completed successfully on $TODAY"
