# 07 — CI/CD

## Pipelines

El repositorio tiene los siguientes workflows de GitHub Actions:

| Workflow | Archivo | Trigger | Propósito |
|---|---|---|---|
| **MkDocs Deploy** | `.github/workflows/ci.yml` | push a `main` | Despliega docs a GitHub Pages (existente, no modificado) |
| **Build & Test** | `.github/workflows/build-test.yml` | push/PR a `main` (cambios en `src/` o `infra/`) | Lint Python, build/test C#, compilar Bicep |
| **Deploy to Azure** | `.github/workflows/deploy-azure.yml` | `workflow_dispatch` (manual) | Despliegue completo a Azure + smoke tests |
| **Add to Project** | `.github/workflows/add-to-project.yml` | issue opened | Añade issues al project board (existente, no modificado) |

---

## Build & Test (`build-test.yml`)

Ejecuta automáticamente en cada push/PR que toque `src/` o `infra/`:

```
┌─────────────────┐  ┌──────────────────┐  ┌─────────────────┐
│ python-validate  │  │ csharp-build-test│  │ bicep-validate   │
│                  │  │                  │  │                  │
│ • Syntax check   │  │ • dotnet restore │  │ • az bicep build │
│ • ruff lint      │  │ • dotnet build   │  │                  │
│                  │  │ • dotnet test    │  │                  │
└─────────────────┘  └──────────────────┘  └─────────────────┘
```

Los tres jobs corren en **paralelo**.

---

## Deploy to Azure (`deploy-azure.yml`)

Trigger manual (`workflow_dispatch`) con selección de environment.

```
┌──────────┐     ┌────────────────┐     ┌───────────────┐ ┌──────────────┐     ┌─────────────┐
│ Validate │────▶│ Deploy Infra   │────▶│ Deploy Python │ │ Deploy C#    │────▶│ Smoke Tests │
│          │     │ (Bicep)        │     │ (zip deploy)  │ │ (zip deploy) │     │             │
└──────────┘     └────────────────┘     └───────────────┘ └──────────────┘     └─────────────┘
                                         ▲ paralelo ▲
```

### Secretos Requeridos

Para que el workflow de deploy funcione, configura estos secretos en GitHub:

**Settings → Secrets and variables → Actions → Secrets:**

| Secret | Descripción | Cómo obtener |
|---|---|---|
| `AZURE_CLIENT_ID` | App registration client ID | `az ad sp create-for-rbac` |
| `AZURE_TENANT_ID` | Azure AD tenant ID | `az account show --query tenantId` |
| `AZURE_SUBSCRIPTION_ID` | Azure subscription ID | `az account show --query id` |

### Configuración de OIDC (recomendado sobre secretos de SP)

```bash
# 1. Crear App Registration
APP_ID=$(az ad app create --display-name "github-deploy-demoaitourmxJJ" --query appId -o tsv)

# 2. Crear Service Principal
az ad sp create --id $APP_ID

# 3. Asignar rol Contributor a la suscripción
az role assignment create \
  --role Contributor \
  --assignee $APP_ID \
  --scope /subscriptions/<SUBSCRIPTION_ID>

# 4. Crear federated credential para GitHub Actions
az ad app federated-credential create --id $APP_ID --parameters '{
  "name": "github-main",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:microsoft/aitour26-WRK541-real-world-code-migration-with-github-copilot-agent-mode:environment:dev",
  "audiences": ["api://AzureADTokenExchange"]
}'

# 5. Obtener valores para secrets
echo "AZURE_CLIENT_ID=$APP_ID"
echo "AZURE_TENANT_ID=$(az account show --query tenantId -o tsv)"
echo "AZURE_SUBSCRIPTION_ID=$(az account show --query id -o tsv)"
```

### Environments (GitHub)

Crea un environment llamado `dev` en **Settings → Environments**.
Opcionalmente, habilita "Required reviewers" para aprobación manual antes del deploy.

---

## Pipeline de Docs existente (`ci.yml`)

Este workflow **no fue modificado**. Despliega la documentación MkDocs a GitHub Pages en cada push a `main`.
