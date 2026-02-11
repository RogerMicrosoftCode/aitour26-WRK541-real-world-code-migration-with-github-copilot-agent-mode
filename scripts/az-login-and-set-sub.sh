#!/usr/bin/env bash
# =============================================================================
# az-login-and-set-sub.sh — Login to Azure & set active subscription
# =============================================================================
set -euo pipefail

echo "=== Azure Login & Subscription Setup ==="

# Check Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "ERROR: Azure CLI (az) is not installed."
    echo "Install: https://learn.microsoft.com/cli/azure/install-azure-cli"
    exit 1
fi

# Login (interactive browser flow)
echo "Logging in to Azure..."
az login

# List subscriptions
echo ""
echo "Available subscriptions:"
az account list --output table --query "[].{Name:name, SubscriptionId:id, State:state}"

# If AZURE_SUBSCRIPTION_ID is set, use it; otherwise prompt
if [ -n "${AZURE_SUBSCRIPTION_ID:-}" ]; then
    echo ""
    echo "Using subscription from AZURE_SUBSCRIPTION_ID: $AZURE_SUBSCRIPTION_ID"
    az account set --subscription "$AZURE_SUBSCRIPTION_ID"
else
    echo ""
    read -rp "Enter the Subscription ID to use: " SUB_ID
    az account set --subscription "$SUB_ID"
    export AZURE_SUBSCRIPTION_ID="$SUB_ID"
fi

echo ""
echo "Active subscription:"
az account show --output table --query "{Name:name, SubscriptionId:id, TenantId:tenantId}"
echo ""
echo "✅ Login and subscription configured successfully."
