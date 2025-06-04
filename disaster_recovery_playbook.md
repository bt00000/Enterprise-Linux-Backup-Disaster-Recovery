# Disaster Recovery Playbook

## Overview
This playbook guides you through recovering the Enterprise-Grade Linux Backup and Disaster Recovery System in case of a primary server failure, ransomware attack, or complete system loss.

Components:
- **Primary Server**: Ubuntu 22.04 LTS
- **Backup Storage Server**: RAID 1 Array (NFS Shared)
- **Cloud Backup**: AWS S3 Bucket with Object Lock and Versioning
- **Encryption**: GPG AES256 for full backups
- **Monitoring**: Email alerts on backup failures
- **Automation**: Cron jobs for backup and cleanup

---

## 1. Recover Primary Server from NFS Backup

1. **Boot into Rescue Mode** (e.g., Ubuntu Live CD).
2. **Install NFS Client**:
   ```bash
   sudo apt update
   sudo apt install nfs-common -y
   ```
3. **Mount NFS Backup Storage**:
   ```bash
   sudo mkdir /mnt/backup_nfs
   sudo mount 192.168.x.x:/backup_storage /mnt/backup_nfs
   ```
4. **Restore from Incremental Backup** (Choose the most recent date):
   ```bash
   sudo rsync -av /mnt/backup_nfs/incremental/YYYY-MM-DD/ /mnt/target_restore_location/
   ```
5. **Restore from Full Backup (Optional)**:
   - Decrypt the backup:
     ```bash
     gpg --output restored_full_backup.tar.gz --decrypt /mnt/backup_nfs/full/YYYY-MM-DD_full_backup.tar.gz.gpg
     ```
   - Extract:
     ```bash
     sudo tar -xzvf restored_full_backup.tar.gz -C /mnt/target_restore_location/
     ```

---

## 2. Recover from AWS S3 (If NFS Backup Unavailable)

1. **Boot into Rescue Mode**.
2. **Install AWS CLI**:
   ```bash
   sudo apt update
   sudo apt install unzip curl -y
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   unzip awscliv2.zip
   sudo ./aws/install
   ```
3. **Configure AWS CLI**:
   ```bash
   aws configure
   ```
   Provide:
   - AWS Access Key ID
   - AWS Secret Access Key
   - Default region (e.g., us-west-1)

4. **List Available Backups**:
   ```bash
   aws s3 ls s3://your-s3-bucket-name/
   ```

5. **Download the Latest Full Backup**:
   ```bash
   aws s3 cp s3://your-s3-bucket-name/YYYY-MM-DD_full_backup.tar.gz.gpg .
   ```

6. **Decrypt and Extract**:
   - Decrypt:
     ```bash
     gpg --output restored_full_backup.tar.gz --decrypt YYYY-MM-DD_full_backup.tar.gz.gpg
     ```
   - Extract:
     ```bash
     sudo tar -xzvf restored_full_backup.tar.gz -C /mnt/target_restore_location/
     ```

---

## 3. GPG Key Recovery

- Ensure you have a secure offline backup of your **GPG Private Key**.
- To restore the GPG Key:
  ```bash
  gpg --import private.key
  ```
- Verify key presence:
  ```bash
  gpg --list-keys
  ```

---

## 4. Test Commands

- **Test NFS Export Visibility**:
  ```bash
  showmount -e 192.168.x.x
  ```
- **Test AWS S3 Access**:
  ```bash
  aws s3 ls
  ```

- **Test Decryption**:
  ```bash
  gpg --decrypt --list-only YYYY-MM-DD_full_backup.tar.gz.gpg
  ```

---

## 5. Key Notes

- **RAID 1** on the Backup Server provides local disk redundancy.
- **NFS Automount** with `_netdev, nofail, x-systemd.automount` options prevents boot failures if NFS server is unreachable.
- **AWS S3 Bucket** is configured with:
  - Object Lock (Governance Mode)
  - Versioning
- **GPG Encryption** ensures that even if S3 is compromised, backups remain secure.
- **Backup Monitoring** alerts via email if daily incremental or weekly full backups are missing.
- **Backup Retention Policy**:
  - Incremental backups: keep last 7 days.
  - Full backups: keep last 4 weeks.
  - S3 Lifecycle Policy (optional): delete backups older than 90 days.

---

# Disaster Recovery Completed

**Goal**: Fully recover the system using local NFS backups or AWS S3 backups, ensuring minimum downtime and maximum data integrity.

---
