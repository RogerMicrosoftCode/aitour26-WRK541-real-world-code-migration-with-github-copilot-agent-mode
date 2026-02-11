# 02 — Runtime & Dependencies

## Python App (`src/python-app/`)

### Runtime
- **Python 3.12** (definido en devcontainer)
- **Servidor ASGI**: Uvicorn (con hot-reload)
- **Framework**: FastAPI 0.103.2

### Dependencias (`src/python-app/requirements.txt`)

| Paquete | Versión | Propósito |
|---|---|---|
| `fastapi` | 0.103.2 | Framework web ASGI |
| `pydantic` | (latest) | Validación de modelos (transitividad FastAPI) |
| `uvicorn[standard]` | (latest) | Servidor ASGI |
| `httpx` | 0.25.0 | Cliente HTTP async (no usado en app, posible uso en tests) |
| `requests` | 2.32.4 | Cliente HTTP síncrono (usado en tests) |
| `pytest` | (latest) | Framework de testing |

### Cómo ejecutar localmente

```bash
cd src/python-app
python -m venv .venv
source .venv/bin/activate   # Linux/macOS
# .venv\Scripts\activate    # Windows
pip install -r requirements.txt
uvicorn webapp.main:app --reload --host 0.0.0.0 --port 8000
```

### Cómo ejecutar tests

```bash
# La app debe estar corriendo en puerto 8000
cd src/python-app
pytest webapp/test_main.py -v
```

> **Nota**: Los tests de Python son de integración real (HTTP) — requieren la app levantada.

---

## C# App (`src/csharp-app-complete/`)

### Runtime
- **.NET 8.0** (target del proyecto, aunque devcontainer instala .NET 10 SDK)
- **Framework**: ASP.NET Core Minimal APIs
- **Swagger**: Swashbuckle.AspNetCore 6.5.0

### Dependencias (`csharp-app.csproj`)

| Paquete NuGet | Versión | Propósito |
|---|---|---|
| `Swashbuckle.AspNetCore` | 6.5.0 | Swagger/OpenAPI UI |
| `Microsoft.AspNetCore.OpenApi` | 8.0.0 | OpenAPI metadata |

### Dependencias de Tests (`WeatherService.UnitTests.csproj`)

| Paquete NuGet | Versión | Propósito |
|---|---|---|
| `MSTest.TestAdapter` | 2.2.10 | Adaptador MSTest |
| `MSTest.TestFramework` | 2.2.10 | Framework MSTest |
| `Microsoft.NET.Test.Sdk` | 17.9.0 | SDK de pruebas .NET |
| `Microsoft.AspNetCore.Mvc.Testing` | 8.0.1 | `WebApplicationFactory` para integration tests |

### Cómo ejecutar localmente

```bash
cd src/csharp-app-complete
dotnet restore
dotnet run
# API disponible en http://localhost:5000 (o puerto dinámico)
```

### Cómo ejecutar tests

```bash
cd src/csharp-app-complete
dotnet test --verbosity normal
```

---

## Docs / Workshop (`docs/`)

### Runtime
- **MkDocs** con tema `mkdocs-material`
- Python 3.x para generar el sitio estático

### Dependencias (raíz `/requirements.txt`)

| Paquete | Propósito |
|---|---|
| `mkdocs-material` | Tema Material para MkDocs |
| `ruff` | Linter Python |
| `black` | Formateador Python |

---

## DevContainer (`.devcontainer/`)

- **Base**: `mcr.microsoft.com/vscode/devcontainers/python:1-3.12-bullseye`
- **Python 3.12** con virtualenv en `/home/vscode/venv`
- **.NET 10 SDK** (instalado via `dotnet-install.sh --channel 10.0`)
- **Extensiones VS Code**: Python, Pylance, C#, C# Dev Kit, GitHub Copilot

---

## Matriz de Compatibilidad

| Componente | Versión requerida | Notas |
|---|---|---|
| Python | 3.12 | Para ejecutar la app Python |
| .NET SDK | 8.0+ | Para compilar/ejecutar la app C# (target net8.0) |
| Node.js | No requerido | No hay frontend JS |
| Docker | Opcional | Solo para devcontainer |
