// ============================================================================
// main.bicep — Weather API Workshop Infrastructure
// Prefix: demoaitourmxJJ
// ============================================================================

targetScope = 'subscription'

// ── Parameters ──────────────────────────────────────────────────────────────

@description('Base name prefix for all resources')
param baseName string = 'demoaitourmxJJ'

@description('Azure region for all resources')
param location string = 'eastus2'

@description('App Service Plan SKU')
@allowed(['F1', 'B1', 'B2', 'S1', 'P1v3'])
param appServicePlanSku string = 'B1'

@description('Python runtime version for the Python App Service')
param pythonVersion string = '3.12'

@description('dotnet runtime version for the C# App Service')
param dotnetVersion string = '8.0'

// ── Derived Names ───────────────────────────────────────────────────────────

var resourceGroupName = 'rg-${baseName}'
var appServicePlanName = 'asp-${baseName}'
var pythonAppName = 'app-${baseName}-python'
var csharpAppName = 'app-${baseName}-csharp'
var logAnalyticsName = 'log-${baseName}'
var appInsightsName = 'appi-${baseName}'
// Key Vault names must be 3-24 chars, alphanumeric + hyphens
var keyVaultName = length('kv-${baseName}') > 24 ? substring('kv-${baseName}', 0, 24) : 'kv-${baseName}'

// ── Resource Group ──────────────────────────────────────────────────────────

resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: location
  tags: {
    project: 'weather-api-workshop'
    environment: 'dev'
    managedBy: 'bicep'
  }
}

// ── Module: Core Infrastructure ─────────────────────────────────────────────

module infra 'modules/infra.bicep' = {
  scope: rg
  name: 'infra-deployment'
  params: {
    location: location
    appServicePlanName: appServicePlanName
    appServicePlanSku: appServicePlanSku
    pythonAppName: pythonAppName
    csharpAppName: csharpAppName
    logAnalyticsName: logAnalyticsName
    appInsightsName: appInsightsName
    keyVaultName: keyVaultName
    pythonVersion: pythonVersion
    dotnetVersion: dotnetVersion
  }
}

// ── Outputs ─────────────────────────────────────────────────────────────────

output resourceGroupName string = rg.name
output pythonAppUrl string = infra.outputs.pythonAppUrl
output csharpAppUrl string = infra.outputs.csharpAppUrl
output appInsightsName string = appInsightsName
output keyVaultName string = keyVaultName
