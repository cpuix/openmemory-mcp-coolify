#!/bin/bash
BACKUP_DIR="backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
echo "💾 Backup başlatılıyor: $BACKUP_DIR"
cp -r data/ "$BACKUP_DIR/"
cp .env "$BACKUP_DIR/"
echo "✅ Backup tamamlandı: $BACKUP_DIR"
