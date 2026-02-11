# 06 — Validation Checklist

## Pre-Deployment

| # | Check | Command / Action | Status |
|---|---|---|---|
| 1 | Azure CLI installed | `az --version` → 2.50+ | ☐ |
| 2 | .NET SDK installed | `dotnet --info` → 8.0+ | ☐ |
| 3 | Python installed | `python --version` → 3.12+ | ☐ |
| 4 | Azure subscription configured | `az account show` | ☐ |
| 5 | C# build passes | `dotnet build src/csharp-app-complete/csharp-app.sln` | ☐ |
| 6 | C# tests pass | `dotnet test src/csharp-app-complete/csharp-app.sln` | ☐ |
| 7 | Bicep compiles | `az bicep build --file infra/main.bicep` | ☐ |
| 8 | Parameters reviewed | `infra/params/dev.parameters.json` — no secrets | ☐ |

## Deployment

| # | Check | Command / Action | Status |
|---|---|---|---|
| 9 | Infrastructure deployed | `./scripts/deploy-azure.sh` completed without errors | ☐ |
| 10 | Resource group exists | `az group show -n rg-demoaitourmxJJ` | ☐ |
| 11 | Python App Service running | `az webapp show -g rg-demoaitourmxJJ -n app-demoaitourmxJJ-python --query state` → "Running" | ☐ |
| 12 | C# App Service running | `az webapp show -g rg-demoaitourmxJJ -n app-demoaitourmxJJ-csharp --query state` → "Running" | ☐ |
| 13 | Application Insights created | `az monitor app-insights component show -g rg-demoaitourmxJJ -a appi-demoaitourmxJJ` | ☐ |
| 14 | Key Vault created | `az keyvault show -n kv-demoaitourmxJJ` | ☐ |

## Post-Deployment: Endpoints

| # | Check | Expected | Status |
|---|---|---|---|
| 15 | Python: root redirects | `curl -L https://app-demoaitourmxJJ-python.azurewebsites.net/` → Swagger HTML | ☐ |
| 16 | Python: GET /countries | HTTP 200, body contains `["England",...]` | ☐ |
| 17 | Python: GET /countries/England/London/January | HTTP 200, body contains `{"high":45,"low":36}` | ☐ |
| 18 | C#: root redirects | `curl -L https://app-demoaitourmxJJ-csharp.azurewebsites.net/` → Swagger HTML | ☐ |
| 19 | C#: GET /countries | HTTP 200, body contains `["England",...]` | ☐ |
| 20 | C#: GET /countries/England/London/January | HTTP 200, body contains `{"high":45,"low":36}` | ☐ |
| 21 | C#: Invalid route returns 404 | `curl -s -o /dev/null -w "%{http_code}" .../countries/X/Y/Z` → 404 | ☐ |

## Post-Deployment: Observability

| # | Check | How to verify | Status |
|---|---|---|---|
| 22 | Logs visible in App Service | `az webapp log tail -g rg-demoaitourmxJJ -n app-demoaitourmxJJ-python` | ☐ |
| 23 | App Insights receives telemetry | Azure Portal → Application Insights → Live Metrics | ☐ |

## Security

| # | Check | How to verify | Status |
|---|---|---|---|
| 24 | HTTPS enforced | `curl http://...` redirects to `https://...` | ☐ |
| 25 | FTPS disabled | `az webapp config show ... --query ftpsState` → "Disabled" | ☐ |
| 26 | TLS 1.2 minimum | `az webapp config show ... --query minTlsVersion` → "1.2" | ☐ |
| 27 | No secrets in code/config | Grep repo for passwords/keys → none found | ☐ |
| 28 | Key Vault RBAC enabled | `az keyvault show ... --query properties.enableRbacAuthorization` → true | ☐ |

## Rollback & Re-deploy

| # | Check | Command | Status |
|---|---|---|---|
| 29 | Re-deploy works | Run `./scripts/deploy-azure.sh` again → idempotent success | ☐ |
| 30 | Destroy works | `./scripts/destroy-azure.sh` → RG deleted | ☐ |
| 31 | Re-create works | `./scripts/deploy-azure.sh` after destroy → fresh environment | ☐ |

---

## Automated Validation

Run all checks with a single command:

```bash
# Smoke tests (endpoints)
export BASE_URL_PYTHON="https://app-demoaitourmxJJ-python.azurewebsites.net"
export BASE_URL_CSHARP="https://app-demoaitourmxJJ-csharp.azurewebsites.net"
./scripts/run-smoke-tests.sh

# Local validation (build + tests)
./scripts/run-local-validation.sh
```
