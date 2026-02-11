// ============================================================================
// modules/infra.bicep — Core infrastructure resources
// ============================================================================

@description('Azure region')
param location string

@description('App Service Plan name')
param appServicePlanName string

@description('App Service Plan SKU')
param appServicePlanSku string

@description('Python App Service name')
param pythonAppName string

@description('C# App Service name')
param csharpAppName string

@description('Log Analytics Workspace name')
param logAnalyticsName string

@description('Application Insights name')
param appInsightsName string

@description('Key Vault name')
param keyVaultName string

@description('Python runtime version')
param pythonVersion string

@description('dotnet runtime version')
param dotnetVersion string

// ── Log Analytics Workspace ─────────────────────────────────────────────────

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalyticsName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
  tags: {
    project: 'weather-api-workshop'
  }
}

// ── Application Insights ────────────────────────────────────────────────────

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalytics.id
  }
  tags: {
    project: 'weather-api-workshop'
  }
}

// ── Key Vault ───────────────────────────────────────────────────────────────

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
  }
  tags: {
    project: 'weather-api-workshop'
  }
}

// ── App Service Plan (Linux) ────────────────────────────────────────────────

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: appServicePlanName
  location: location
  kind: 'linux'
  sku: {
    name: appServicePlanSku
  }
  properties: {
    reserved: true // Required for Linux
  }
  tags: {
    project: 'weather-api-workshop'
  }
}

// ── App Service: Python ─────────────────────────────────────────────────────

resource pythonApp 'Microsoft.Web/sites@2023-12-01' = {
  name: pythonAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'PYTHON|${pythonVersion}'
      appCommandLine: 'uvicorn webapp.main:app --host 0.0.0.0 --port 8000'
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
      appSettings: [
        {
          name: 'SCM_DO_BUILD_DURING_DEPLOYMENT'
          value: 'true'
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsights.properties.ConnectionString
        }
        {
          name: 'WEBSITES_PORT'
          value: '8000'
        }
      ]
    }
  }
  tags: {
    project: 'weather-api-workshop'
    runtime: 'python'
  }
}

// ── App Service: C# ─────────────────────────────────────────────────────────

resource csharpApp 'Microsoft.Web/sites@2023-12-01' = {
  name: csharpAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|${dotnetVersion}'
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
      appSettings: [
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsights.properties.ConnectionString
        }
      ]
    }
  }
  tags: {
    project: 'weather-api-workshop'
    runtime: 'dotnet'
  }
}

// ── Outputs ─────────────────────────────────────────────────────────────────

output pythonAppUrl string = 'https://${pythonApp.properties.defaultHostName}'
output csharpAppUrl string = 'https://${csharpApp.properties.defaultHostName}'
output appInsightsConnectionString string = appInsights.properties.ConnectionString
output keyVaultUri string = keyVault.properties.vaultUri
