# 01 — Repo Overview

## Propósito del Repositorio

Workshop de **Microsoft AI Tour 2026** — sesión **WRK541: Real World Code Migration with GitHub Copilot Agent Mode**.  
Objetivo: enseñar a migrar una API HTTP de **Python (FastAPI)** a **C# (.NET Minimal APIs)** usando GitHub Copilot.

---

## Mapa de Módulos

| Carpeta / Archivo | Qué hace | Ejecución local |
|---|---|---|
| `src/python-app/` | API de clima original (Python/FastAPI). Sirve datos estáticos de JSON. | `cd src/python-app && uvicorn webapp.main:app --reload` |
| `src/python-app/webapp/main.py` | Punto de entrada de la API Python. Define endpoints `/`, `/countries`, `/countries/{country}/{city}/{month}`. | — |
| `src/python-app/webapp/weather.json` | Dataset estático de temperaturas para 7 países. | — |
| `src/python-app/webapp/test_main.py` | Tests de integración con `pytest` + `requests`. Requiere app corriendo. | `pytest src/python-app/webapp/test_main.py` |
| `src/csharp-app-complete/` | API migrada a C# (.NET 8 Minimal APIs). Es la solución "completada" del workshop. | `cd src/csharp-app-complete && dotnet run` |
| `src/csharp-app-complete/Program.cs` | Entry point de la API .NET. Mismos endpoints que Python + Swagger. | — |
| `src/csharp-app-complete/Services/` | `IWeatherService` + `WeatherService`: carga y consulta de datos JSON. | — |
| `src/csharp-app-complete/Models/` | `TemperatureDto`: DTO con `High` y `Low`. | — |
| `src/csharp-app-complete/WeatherService.UnitTests/` | Tests MSTest: unit tests + integration tests con `WebApplicationFactory`. | `cd src/csharp-app-complete && dotnet test` |
| `docs/` | Documentación MkDocs para el workshop (desplegada con GitHub Pages). | `mkdocs serve --config-file docs/mkdocs.yml` |
| `.devcontainer/` | Configuración de Dev Container: Python 3.12 + .NET 10 SDK. | `devcontainer up` |
| `.github/workflows/ci.yml` | Pipeline CI: despliega docs MkDocs a GitHub Pages. | — |
| `.github/workflows/add-to-project.yml` | Añade issues a un GitHub Project Board. | — |

---

## Endpoints de la API (Python y C# comparten la misma interfaz)

| Método | Path | Descripción |
|---|---|---|
| GET | `/` | Redirige a Swagger/OpenAPI docs |
| GET | `/countries` | Lista de países disponibles |
| GET | `/countries/{country}/{city}/{month}` | Temperatura alta/baja del mes |

---

## Estructura del Repositorio

```
.
├── .devcontainer/          # Dev Container (Python 3.12 + .NET 10)
├── .github/workflows/      # CI para MkDocs GH Pages + project board
├── docs/                   # Documentación del workshop (MkDocs)
├── img/                    # Imágenes del README
├── session-delivery-resources/  # Recursos para presentadores
├── src/
│   ├── python-app/         # API original (Python/FastAPI)
│   │   ├── webapp/
│   │   │   ├── main.py         # App FastAPI
│   │   │   ├── test_main.py    # Tests pytest
│   │   │   ├── weather.json    # Datos estáticos
│   │   │   └── static/         # openapi.json (vacío)
│   │   ├── Makefile
│   │   └── requirements.txt
│   └── csharp-app-complete/ # API migrada (C#/.NET 8)
│       ├── Program.cs          # Entry point Minimal API
│       ├── ProgramEntry.cs     # Parcial para test factory
│       ├── Services/           # WeatherService + interface
│       ├── Models/             # TemperatureDto
│       ├── WeatherService.UnitTests/  # MSTest tests
│       ├── weather.json
│       ├── csharp-app.csproj
│       └── csharp-app.sln
├── README.MD
├── PREREQUISITES.md
├── mkdocs.yml
└── requirements.txt        # Deps de docs (mkdocs-material, ruff, black)
```

---

## Componentes detectados

| Componente | Detectado | Detalle |
|---|---|---|
| Frontend | ❌ No | Solo Swagger UI auto-generado |
| Backend/API | ✅ Sí | Python FastAPI + C# .NET Minimal APIs |
| IA/Agentes/LangChain | ❌ No | Repositorio no contiene componentes de IA |
| Base de datos | ❌ No | Datos estáticos en JSON embebido |
| Storage externo | ❌ No | Sin Blob/S3/etc |
| Observabilidad | ❌ No | Sin logging/tracing/metrics configurados |
| Configuración/Secretos | ⚠️ Mínima | Sin `.env`, sin Key Vault, sin variables de entorno de negocio |
| Contenedores | ⚠️ Solo devcontainer | No hay Dockerfiles para producción |
