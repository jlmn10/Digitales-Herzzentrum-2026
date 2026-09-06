#!/bin/bash

set -e

PROJECT_ID=$(gcloud config get-value project 2>/dev/null)

echo "=========================================="
echo " Backup - Digitales Herzzentrum"
echo "=========================================="

echo "Projekt: $PROJECT_ID"
echo ""

echo "[1/3] Terraform State sichern..."

terraform state pull > terraform-state-backup.json

echo "Terraform State gespeichert."
echo ""

echo "[2/3] Cloud SQL Backups prüfen..."

gcloud sql backups list \
  --instance=herzzentrum-db \
  --limit=5

echo ""

echo "[3/3] Backup-Konfiguration prüfen..."

gcloud sql instances describe herzzentrum-db \
  --format="yaml(settings.backupConfiguration)"

echo ""
echo "=========================================="
echo " Backup-Prüfung abgeschlossen"
echo "=========================================="
