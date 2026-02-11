# 05 — Deployment to Azure

## Resumen

Patrón de despliegue: **Azure App Service (Linux)** con **Bicep IaC**.

| Componente | Servicio Azure | SKU |
|---|---|---|
| Python API | App Service (Linux, Python 3.12) | B1 |
| C# API | App Service (Linux, .NET 8.0) | B1 |
| Observabilidad | Application Insights + Log Analytics | PerGB2018 |
| Secretos | Key Vault | Standard |
| Infraestructura | Bicep (subscription-level) | — |

---

## Paso a paso

### 1. Prerrequisitos

```bash
# Verificar herramientas
az --version        # Azure CLI 2.50+
dotnet --info       # .NET 8.0+ SDK
python --version    # Python 3.12+
jq --version        # jq (para scripts)
zip --version       # zip (para empaquetar)
```

### 2. Configurar suscripción

```bash
# Opción A: Script interactivo
chmod +x scripts/az-login-and-set-sub.sh
./scripts/az-login-and-set-sub.sh

# Opción B: Manual
az login
az account set --subscription "<YOUR_SUBSCRIPTION_ID>"
```

### 3. Personalizar parámetros (opcional)

Editar `infra/params/dev.parameters.json`:

```json
{
  "parameters": {
    "baseName": { "value": "demoaitourmxJJ" },
    "location": { "value": "eastus2" },
    "appServicePlanSku": { "value": "B1" }
  }
}
```

### 4. Desplegar

```bash
chmod +x scripts/deploy-azure.sh
./scripts/deploy-azure.sh
```

Este script ejecuta:
1. `az deployment sub create` — despliega infraestructura Bicep
2. `az webapp deploy` — despliega Python app (zip)
3. `dotnet publish` + `az webapp deploy` — despliega C# app
4. Muestra las URLs finales

### 5. Verificar

```bash
chmod +x scripts/run-smoke-tests.sh

# Export para los smoke tests
export BASE_URL_PYTHON="https://app-demoaitourmxJJ-python.azurewebsites.net"
export BASE_URL_CSHARP="https://app-demoaitourmxJJ-csharp.azurewebsites.net"

./scripts/run-smoke-tests.sh
```

### 6. Destruir (cuando ya no se necesite)

```bash
chmod +x scripts/destroy-azure.sh
./scripts/destroy-azure.sh
```

---

## Seguridad: Gestión de Secretos

### Key Vault

El despliegue crea un Key Vault (`kv-demoaitourmxJJ`) con:
- RBAC authorization habilitado
- Soft-delete habilitado (7 días retención)
- TLS 1.2 mínimo

### Para añadir secretos:

```bash
# Asignar rol al usuario actual
az role assignment create \
  --role "Key Vault Secrets Officer" \
  --assignee $(az ad signed-in-user show --query id -o tsv) \
  --scope $(az keyvault show --name kv-demoaitourmxJJ --query id -o tsv)

# Agregar un secreto
az keyvault secret set \
  --vault-name kv-demoaitourmxJJ \
  --name "my-secret" \
  --value "my-secret-value"
```

### Para usar secretos en App Service:

```bash
# Habilitar identidad administrada
az webapp identity assign \
  --resource-group rg-demoaitourmxJJ \
  --name app-demoaitourmxJJ-python

# Asignar acceso al KV
az role assignment create \
  --role "Key Vault Secrets User" \
  --assignee <PRINCIPAL_ID> \
  --scope $(az keyvault show --name kv-demoaitourmxJJ --query id -o tsv)

# Referenciar secreto en app settings
az webapp config appsettings set \
  --resource-group rg-demoaitourmxJJ \
  --name app-demoaitourmxJJ-python \
  --settings "MY_SECRET=@Microsoft.KeyVault(SecretUri=https://kv-demoaitourmxJJ.vault.azure.net/secrets/my-secret)"
```

---

## Costos Estimados

| Recurso | SKU | Costo aprox./mes (USD) |
|---|---|---|
| App Service Plan B1 | 1x Linux | ~$13 |
| Application Insights | Pay-as-you-go (5GB free/month) | ~$0 (bajo uso) |
| Key Vault | Standard | ~$0.03/10k ops |
| Log Analytics | PerGB2018 (5GB free/month) | ~$0 (bajo uso) |
| **Total estimado** | | **~$13/mes** |

> Para reducir costos de workshop/demo, usar SKU `F1` (Free) en `appServicePlanSku`.
> Nota: F1 no soporta "Always On" ni custom domains.

---

## Troubleshooting

| Problema | Solución |
|---|---|
| `az deployment` falla con "name already taken" | Los nombres de App Service son globales. Cambia `baseName` en parámetros. |
| Python app muestra "Application Error" | Revisar logs: `az webapp log tail -g rg-demoaitourmxJJ -n app-demoaitourmxJJ-python` |
| C# app no inicia | Verificar runtime: `az webapp config show -g rg-demoaitourmxJJ -n app-demoaitourmxJJ-csharp --query linuxFxVersion` |
| Key Vault "Access Denied" | Verificar RBAC: `az role assignment list --scope /subscriptions/.../kv-demoaitourmxJJ` |
