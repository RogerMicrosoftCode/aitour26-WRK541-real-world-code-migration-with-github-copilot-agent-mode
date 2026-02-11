# 04 — Architecture

## Arquitectura Actual (As-Is)

El repositorio contiene **dos implementaciones equivalentes** de una API REST de clima:

1. **Python App** — la implementación original
2. **C# App** — la migración completada (resultado del workshop)

Ambas sirven la misma interfaz HTTP, leen el mismo dataset JSON estático y exponen documentación Swagger/OpenAPI.

---

## Diagrama de Arquitectura

> Ver [diagrams/architecture.mmd](diagrams/architecture.mmd) para el diagrama Mermaid completo.

```mermaid
graph TB
    subgraph "Cliente"
        Browser["🌐 Browser / HTTP Client"]
    end

    subgraph "Python App (src/python-app)"
        PY_ENTRY["Uvicorn ASGI Server<br/>Port 8000"]
        PY_FASTAPI["FastAPI App<br/>main.py"]
        PY_DATA["weather.json<br/>(embedded)"]
        PY_SWAGGER["Swagger UI<br/>/docs"]
        PY_ENTRY --> PY_FASTAPI
        PY_FASTAPI --> PY_DATA
        PY_FASTAPI --> PY_SWAGGER
    end

    subgraph "C# App (src/csharp-app-complete)"
        CS_ENTRY["Kestrel HTTP Server<br/>Port 5000"]
        CS_MINIMAL["Minimal APIs<br/>Program.cs"]
        CS_SVC["WeatherService<br/>(Singleton DI)"]
        CS_DATA["weather.json<br/>(embedded)"]
        CS_SWAGGER["Swagger UI<br/>/swagger"]
        CS_ENTRY --> CS_MINIMAL
        CS_MINIMAL --> CS_SVC
        CS_SVC --> CS_DATA
        CS_MINIMAL --> CS_SWAGGER
    end

    subgraph "Tests"
        PY_TESTS["pytest<br/>test_main.py<br/>(HTTP integration)"]
        CS_UNIT["MSTest Unit Tests<br/>WeatherServiceTests.cs"]
        CS_INTEG["MSTest Integration Tests<br/>Test1.cs<br/>(WebApplicationFactory)"]
    end

    subgraph "DevOps"
        GHA["GitHub Actions CI<br/>(MkDocs deploy only)"]
        DEVC["DevContainer<br/>Python 3.12 + .NET 10"]
    end

    subgraph "Docs"
        MKDOCS["MkDocs Material<br/>Workshop documentation"]
        GHPAGES["GitHub Pages"]
    end

    Browser -->|"GET /countries"| PY_ENTRY
    Browser -->|"GET /countries"| CS_ENTRY

    PY_TESTS -->|"HTTP requests"| PY_ENTRY
    CS_UNIT -->|"Direct call"| CS_SVC
    CS_INTEG -->|"In-memory server"| CS_MINIMAL

    GHA -->|"mkdocs gh-deploy"| GHPAGES
    MKDOCS -->|"build"| GHPAGES
```

---

## Flujos Principales

### Flujo 1: Consulta de países

```
Cliente → GET /countries → FastAPI/MinimalAPI → Lee keys de weather.json → Retorna ["England", "France", ...]
```

### Flujo 2: Consulta de temperatura

```
Cliente → GET /countries/Spain/Seville/January
  → FastAPI: data["Spain"]["Seville"]["January"] → {"high": 60, "low": 42}
  → MinimalAPI: WeatherService.TryGetMonthlyAverage("Spain","Seville","January") → TemperatureDto{High=60,Low=42}
```

### Flujo 3: Documentación (Swagger)

```
Cliente → GET / → Redirect 301/302 → /docs (Python) o /swagger (C#) → Swagger UI
```

---

## Patrón Arquitectónico

- **Monolito simple** (single-process API)
- **Sin base de datos** — datos embebidos en JSON
- **Sin servicios externos** — autónomo
- **Stateless** — no hay sesiones ni estado compartido
- **DI (solo C#)** — `WeatherService` registrado como Singleton

---

## Arquitectura Propuesta en Azure (To-Be)

```
                    ┌─────────────────────────────┐
                    │     Azure Resource Group     │
                    │   rg-demoaitourmxJJ          │
                    ├─────────────────────────────┤
                    │                             │
    ┌───────────────┼───────────────┐             │
    │ App Service Plan              │             │
    │ asp-demoaitourmxJJ (Linux/B1) │             │
    │   ┌─────────────────────┐     │    ┌────────┴───────┐
    │   │ App Service (Python)│     │    │ Key Vault      │
    │   │ app-..-python       │     │    │ kv-demoaitr..  │
    │   └─────────────────────┘     │    └────────────────┘
    │   ┌─────────────────────┐     │    ┌────────────────┐
    │   │ App Service (C#)    │     │    │ App Insights   │
    │   │ app-..-csharp       │     │    │ appi-demoai..  │
    │   └─────────────────────┘     │    └────────┬───────┘
    └───────────────────────────────┘             │
                                        ┌────────┴───────┐
                                        │ Log Analytics  │
                                        │ log-demoai..   │
                                        └────────────────┘
```

- **2 App Services** en un plan compartido Linux B1
- **Application Insights** para observabilidad
- **Key Vault** para secretos futuros
- **No se requiere** Container Registry, AKS ni Functions (apps simples, sin contenedores)
