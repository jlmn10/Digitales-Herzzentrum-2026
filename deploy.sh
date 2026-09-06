#!/bin/bash

set -e

echo "=========================================="
echo " Disaster Recovery - Digitales Herzzentrum"
echo "=========================================="

START_TIME=$(date +%s)

PROJECT_ID=$(gcloud config get-value project 2>/dev/null)

if [ -z "$PROJECT_ID" ] || [ "$PROJECT_ID" = "(unset)" ]; then
    echo "FEHLER: Kein GCP-Projekt ausgewählt."
    echo "Bitte zuerst ausführen:"
    echo "gcloud config set project DEIN-PROJEKT-ID"
    exit 1
fi

echo ""
echo "GCP-Projekt: $PROJECT_ID"
echo "Region:      europe-west3"
echo "Zone:        europe-west3-a"
echo ""

echo "[1/3] Terraform initialisieren..."
terraform init -input=false

echo "[2/3] Terraform validieren..."
terraform validate

echo "[3/3] Infrastruktur bereitstellen..."
terraform apply \
    -auto-approve \
    -input=false \
    -var="project_id=$PROJECT_ID"

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo ""
echo "=========================================="
echo " Disaster Recovery abgeschlossen"
echo "=========================================="
echo "Projekt: $PROJECT_ID"
echo "Dauer: ${DURATION} Sekunden"
echo "Dauer: $((DURATION / 60)) Minuten $((DURATION % 60)) Sekunden"
echo ""

if [ "$DURATION" -le 300 ]; then
    echo "ERGEBNIS: Innerhalb des 5-Minuten-Limits."
else
    echo "ERGEBNIS: Über dem 5-Minuten-Limit."
fi

echo ""
echo "Terraform Outputs:"
terraform output
