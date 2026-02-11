#!/usr/bin/env bash
# =============================================================================
# deploy-azure.sh — Deploy infrastructure + applications to Azure
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INFRA_DIR="$REPO_ROOT/infra"
PARAMS_FILE="$INFRA_DIR/params/dev.parameters.json"

# ── Read parameters ──────────────────────────────────────────────────────────

BASE_NAME=$(jq -r '.parameters.baseName.value' "$PARAMS_FILE")
LOCATION=$(jq -r '.parameters.location.value' "$PARAMS_FILE")
RG_NAME="rg-${BASE_NAME}"
PYTHON_APP="app-${BASE_NAME}-python"
CSHARP_APP="app-${BASE_NAME}-csharp"

echo "=== Deploying Weather API Workshop to Azure ==="
echo "  Base Name:      $BASE_NAME"
echo "  Location:       $LOCATION"
echo "  Resource Group: $RG_NAME"
echo "  Python App:     $PYTHON_APP"
echo "  C# App:         $CSHARP_APP"
echo ""

# ── Step 1: Deploy Bicep (subscription-level) ────────────────────────────────

echo "▶ Step 1/4: Deploying Bicep infrastructure..."
az deployment sub create \
    --location "$LOCATION" \
    --template-file "$INFRA_DIR/main.bicep" \
    --parameters "$PARAMS_FILE" \
    --name "deploy-${BASE_NAME}-$(date +%Y%m%d%H%M%S)" \
    --output table

echo "✅ Infrastructure deployed."
echo ""

# ── Step 2: Deploy Python App ────────────────────────────────────────────────

echo "▶ Step 2/4: Deploying Python app..."
PYTHON_APP_DIR="$REPO_ROOT/src/python-app"

# Create a zip package for deployment
PYTHON_DEPLOY_DIR=$(mktemp -d)
cp -r "$PYTHON_APP_DIR/webapp" "$PYTHON_DEPLOY_DIR/"
cp "$PYTHON_APP_DIR/requirements.txt" "$PYTHON_DEPLOY_DIR/"

# Create startup command configuration
pushd "$PYTHON_DEPLOY_DIR" > /dev/null
zip -r "$PYTHON_DEPLOY_DIR/deploy.zip" . -x "*.pyc" "__pycache__/*" ".venv/*" "*.egg-info/*"
popd > /dev/null

az webapp deploy \
    --resource-group "$RG_NAME" \
    --name "$PYTHON_APP" \
    --src-path "$PYTHON_DEPLOY_DIR/deploy.zip" \
    --type zip

rm -rf "$PYTHON_DEPLOY_DIR"
echo "✅ Python app deployed."
echo ""

# ── Step 3: Deploy C# App ────────────────────────────────────────────────────

echo "▶ Step 3/4: Deploying C# app..."
CSHARP_APP_DIR="$REPO_ROOT/src/csharp-app-complete"
CSHARP_PUBLISH_DIR=$(mktemp -d)

dotnet publish "$CSHARP_APP_DIR/csharp-app.csproj" \
    --configuration Release \
    --output "$CSHARP_PUBLISH_DIR" \
    --no-self-contained

pushd "$CSHARP_PUBLISH_DIR" > /dev/null
zip -r "$CSHARP_PUBLISH_DIR/deploy.zip" .
popd > /dev/null

az webapp deploy \
    --resource-group "$RG_NAME" \
    --name "$CSHARP_APP" \
    --src-path "$CSHARP_PUBLISH_DIR/deploy.zip" \
    --type zip

rm -rf "$CSHARP_PUBLISH_DIR"
echo "✅ C# app deployed."
echo ""

# ── Step 4: Output URLs ─────────────────────────────────────────────────────

echo "▶ Step 4/4: Retrieving endpoints..."
PYTHON_URL="https://${PYTHON_APP}.azurewebsites.net"
CSHARP_URL="https://${CSHARP_APP}.azurewebsites.net"

echo ""
echo "============================================"
echo "  DEPLOYMENT COMPLETE"
echo "============================================"
echo "  Python API:  $PYTHON_URL"
echo "  C# API:      $CSHARP_URL"
echo ""
echo "  Python Swagger: $PYTHON_URL/docs"
echo "  C# Swagger:     $CSHARP_URL/swagger"
echo ""
echo "  Resource Group: $RG_NAME"
echo "============================================"
echo ""
echo "Run smoke tests: ./scripts/run-smoke-tests.sh"
