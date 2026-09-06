#!/bin/bash

set -e

echo "=========================================="
echo " Disaster Recovery - Digitales Herzzentrum"
echo "=========================================="

START_TIME=$(date +%s)

PROJECT_ID=$(gcloud config get-value project 2>/dev/null)
STATE_BUCKET="${PROJECT_ID}-tfstate"

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

# 1. APIs aktivieren
echo "[1/6] Benötigte APIs aktivieren..."

gcloud services enable \
    cloudresourcemanager.googleapis.com \
    serviceusage.googleapis.com \
    compute.googleapis.com \
    sqladmin.googleapis.com \
    servicenetworking.googleapis.com \
    iam.googleapis.com \
    logging.googleapis.com \
    monitoring.googleapis.com \
    iap.googleapis.com \
    storage.googleapis.com \
    --project="$PROJECT_ID"

# 2. Terraform State Bucket erstellen
echo "[2/6] Terraform State vorbereiten..."

if ! gcloud storage buckets describe "gs://$STATE_BUCKET" >/dev/null 2>&1; then
    gcloud storage buckets create "gs://$STATE_BUCKET" \
        --project="$PROJECT_ID" \
        --location=europe-west3 \
        --uniform-bucket-level-access

    gcloud storage buckets update "gs://$STATE_BUCKET" \
        --versioning
fi

# 3. Default VPC entfernen
echo "[3/6] Default VPC prüfen..."

if gcloud compute networks describe default \
    --project="$PROJECT_ID" >/dev/null 2>&1; then

    echo "Default VPC gefunden. Firewall-Regeln werden entfernt."

    DEFAULT_RULES=$(gcloud compute firewall-rules list \
        --project="$PROJECT_ID" \
        --filter="network:default" \
        --format="value(name)")

    if [ -n "$DEFAULT_RULES" ]; then
        gcloud compute firewall-rules delete $DEFAULT_RULES \
            --project="$PROJECT_ID" \
            --quiet
    fi

    echo "Default VPC wird entfernt."

    gcloud compute networks delete default \
        --project="$PROJECT_ID" \
        --quiet
else
    echo "Kein Default VPC vorhanden."
fi

# 4. Terraform initialisieren
echo "[4/6] Terraform initialisieren..."

terraform init \
    -reconfigure \
    -input=false \
    -backend-config="bucket=$STATE_BUCKET" \
    -backend-config="prefix=terraform/state"

# 5. Terraform validieren
echo "[5/6] Terraform validieren..."

terraform validate

# 6. Infrastruktur bereitstellen
echo "[6/6] Infrastruktur bereitstellen..."

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
