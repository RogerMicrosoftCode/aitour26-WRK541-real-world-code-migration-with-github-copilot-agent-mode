# Infrastructure as Code (Bicep)

## Overview

This folder contains the Bicep templates to deploy the Weather API workshop applications to Azure.

## Resources Created

| Resource | Name | Purpose |
|---|---|---|
| Resource Group | `rg-demoaitourmxJJ` | Logical container |
| App Service Plan | `asp-demoaitourmxJJ` | Linux B1 shared plan |
| App Service (Python) | `app-demoaitourmxJJ-python` | Python FastAPI app |
| App Service (C#) | `app-demoaitourmxJJ-csharp` | C# .NET Minimal API app |
| Log Analytics Workspace | `log-demoaitourmxJJ` | Centralized logs |
| Application Insights | `appi-demoaitourmxJJ` | APM & telemetry |
| Key Vault | `kv-demoaitourmxJJ` | Secrets management |

## Prerequisites

- Azure CLI v2.50+ (`az --version`)
- Azure subscription with Contributor access
- Bicep CLI (bundled with Azure CLI)

## Quick Start

```bash
# 1. Login and set subscription
../scripts/az-login-and-set-sub.sh

# 2. Deploy infrastructure + apps
../scripts/deploy-azure.sh

# 3. Verify
../scripts/run-smoke-tests.sh

# 4. (Optional) Tear down
../scripts/destroy-azure.sh
```

## Parameters

Edit `params/dev.parameters.json` to customize:

| Parameter | Default | Description |
|---|---|---|
| `baseName` | `demoaitourmxJJ` | Prefix for all resource names |
| `location` | `eastus2` | Azure region |
| `appServicePlanSku` | `B1` | App Service Plan SKU |
| `pythonVersion` | `3.12` | Python runtime version |
| `dotnetVersion` | `8.0` | .NET runtime version |

## Changing the Region

Set a different `location` in `params/dev.parameters.json` or pass it as a parameter:

```bash
az deployment sub create \
  --location westus2 \
  --template-file main.bicep \
  --parameters params/dev.parameters.json \
  --parameters location=westus2
```

## Naming Convention

All resources follow: `{type-abbreviation}-{baseName}[-{suffix}]`

| Abbreviation | Resource Type |
|---|---|
| `rg-` | Resource Group |
| `asp-` | App Service Plan |
| `app-` | App Service |
| `log-` | Log Analytics Workspace |
| `appi-` | Application Insights |
| `kv-` | Key Vault |
