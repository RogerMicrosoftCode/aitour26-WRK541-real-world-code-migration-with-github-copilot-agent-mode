# Retos Bonus

!!! note "Estos retos son opcionales"
    Si completaste el workshop principal y te queda tiempo, ¡intenta estos retos avanzados! Cada uno te enseñará nuevas habilidades con GitHub Copilot.

---

## 🐳 Reto 1: Contenedores con Docker

**Dificultad:** ⭐⭐ Intermedio  
**Tiempo estimado:** 15-20 minutos

### Objetivo
Crear Dockerfiles para ambas aplicaciones (Python y C#) y un `docker-compose.yml` que las ejecute juntas.

### Paso a Paso

**1.** Abre GitHub Copilot Chat en modo **🤖 Agent**

**2.** Copia y pega:

> **🤖 Prompt para Copilot (Agent Mode):**
> ```
> @workspace Create Docker containers for both applications in this project:
>
> 1. Create a Dockerfile for the Python app (src/python-app/)
>    - Use python:3.12-slim as base image
>    - Install requirements.txt dependencies
>    - Expose port 8000
>    - Run with uvicorn
>
> 2. Create a Dockerfile for the C# app (src/csharp-app/)
>    - Use multi-stage build (sdk for build, aspnet for runtime)
>    - Target .NET 8
>    - Expose port 8080
>
> 3. Create a docker-compose.yml in the root that runs both services:
>    - python-api on port 8000
>    - csharp-api on port 5000
>    - Both should have health checks
>
> 4. Create a .dockerignore file
> ```

**3.** Verifica construyendo las imágenes:

```bash
docker compose build
docker compose up -d
```

**4.** Prueba ambas APIs:

```bash
curl http://localhost:8000/weather
curl http://localhost:5000/weather
```

---

## 🗄️ Reto 2: Base de Datos con Entity Framework Core

**Dificultad:** ⭐⭐⭐ Avanzado  
**Tiempo estimado:** 25-30 minutos

### Objetivo
Reemplazar el archivo `weather.json` estático con una base de datos SQLite usando Entity Framework Core.

### Paso a Paso

**1.** Abre GitHub Copilot Chat en modo **🤖 Agent**

**2.** Copia y pega:

> **🤖 Prompt para Copilot (Agent Mode):**
> ```
> @workspace I want to migrate the C# app in src/csharp-app/ from loading data from weather.json to using Entity Framework Core with SQLite.
>
> Please:
> 1. Add the required NuGet packages (Microsoft.EntityFrameworkCore.Sqlite, Microsoft.EntityFrameworkCore.Design)
> 2. Create a WeatherDbContext class
> 3. Modify the TemperatureDto model to work as an EF entity (add Id property)
> 4. Create a data seeding method that loads the initial data from weather.json into the database
> 5. Update the WeatherService to query from the database instead of the JSON file
> 6. Update Program.cs to configure EF Core with SQLite
> 7. Create and run the initial migration
> 8. Test that all endpoints still return the same data
>
> Use "Data Source=weather.db" as the connection string.
> ```

**3.** Ejecuta las migraciones:

```bash
cd src/csharp-app
dotnet ef migrations add InitialCreate
dotnet ef database update
```

**4.** Verifica que la API funciona igual que antes:

```bash
dotnet run
curl http://localhost:5000/weather
```

---

## ☁️ Reto 3: Desplegar a Azure

**Dificultad:** ⭐⭐ Intermedio  
**Tiempo estimado:** 20-25 minutos

### Objetivo
Desplegar la aplicación C# a Azure App Service.

### Paso a Paso

**1.** Abre GitHub Copilot Chat en modo **🤖 Agent**

**2.** Copia y pega:

> **🤖 Prompt para Copilot (Agent Mode):**
> ```
> @workspace Help me deploy the C# application in src/csharp-app/ to Azure App Service. 
>
> Please:
> 1. Create an Azure App Service deployment script using Azure CLI
> 2. Use the Free tier (F1) for the App Service Plan
> 3. Configure it for .NET 8 on Linux
> 4. Include commands to:
>    - Create a resource group
>    - Create an App Service Plan
>    - Create a Web App
>    - Deploy the published application
> 5. Add environment variables for the app configuration
>
> Generate a script I can run step by step.
> ```

**3.** Sigue los pasos generados por Copilot

!!! warning "Costo de Azure"
    El tier F1 (Free) no tiene costo, pero verifica tu suscripción. Los recursos se pueden eliminar al finalizar con:
    ```bash
    az group delete --name <tu-resource-group> --yes
    ```

---

## 🏆 Tabla de Logros

| Reto | Habilidad Practicada | Completado |
|------|---------------------|------------|
| 🐳 Docker | Contenedores, Docker Compose | ☐ |
| 🗄️ EF Core | ORM, Migraciones, SQLite | ☐ |
| ☁️ Azure | Cloud deployment, Azure CLI | ☐ |

---

**Volver a:** [Resumen →](resumen.md) | [Índice →](index.md)
