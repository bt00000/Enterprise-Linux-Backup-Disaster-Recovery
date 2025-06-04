#!/bin/bash

# Today's date
TODAY=$(date +%F)

# Backup destination
BACKUP_DEST="/mnt/backup_nfs/full"

# Temporary tar file
TMP_TAR="/tmp/full_backup_$TODAY.tar.gz"

# Final encrypted backup
ENCRYPTED_BACKUP="$BACKUP_DEST/${TODAY}_full_backup.tar.gz.gpg"

# Directories to backup
SOURCE_DIRS=("/home" "/etc")

# Create backup destination directory if it doesn't exist
mkdir -p "$BACKUP_DEST"

# Create tar.gz archive
tar -czvf "$TMP_TAR" "${SOURCE_DIRS[@]}"

# Tell GPG to use your user keyring
export GNUPGHOME=/home/brenn/.gnupg

# Encrypt the archive using GPG
gpg --batch --yes --recipient backup_key --output "$ENCRYPTED_BACKUP" --encrypt "$TMP_TAR"

# Remove unencrypted tar file
rm "$TMP_TAR"

echo "Full encrypted backup completed successfully on $TODAY"
