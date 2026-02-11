#!/usr/bin/env bash
# =============================================================================
# destroy-azure.sh — Delete all Azure resources for the workshop
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PARAMS_FILE="$REPO_ROOT/infra/params/dev.parameters.json"

BASE_NAME=$(jq -r '.parameters.baseName.value' "$PARAMS_FILE")
RG_NAME="rg-${BASE_NAME}"

echo "=== Destroying Azure Resources ==="
echo "  Resource Group: $RG_NAME"
echo ""
echo "⚠️  WARNING: This will permanently delete ALL resources in $RG_NAME."
read -rp "Type 'yes' to confirm: " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "Aborted."
    exit 0
fi

echo ""
echo "Deleting resource group $RG_NAME..."
az group delete --name "$RG_NAME" --yes --no-wait

echo ""
echo "✅ Resource group deletion initiated (runs in background)."
echo "   Check status: az group show --name $RG_NAME --query properties.provisioningState"
