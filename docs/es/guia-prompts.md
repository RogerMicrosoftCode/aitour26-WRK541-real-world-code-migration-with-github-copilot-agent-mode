# 📋 Guía Completa de Prompts

!!! tip "Copia y pega"
    Esta página contiene **TODOS los prompts** que necesitas para completar el workshop. Están organizados por sección y paso. Solo copia, pega en el chat de GitHub Copilot y sigue las instrucciones.

---

## Convenciones

| Símbolo | Significado |
|---------|-------------|
| 💬 | Usar en **Ask Mode** |
| 🤖 | Usar en **Agent Mode** |
| 📋 | Usar en **Edit Mode** |
| ⌨️ | Comando de terminal (no es prompt de Copilot) |

---

## Sección 1: Entender el Proyecto

### Prompt 1.1 — Analizar la app Python (💬 Ask Mode)

```
@workspace Analyze the Python application in src/python-app/webapp/main.py. Explain:
1. What framework is being used and its version
2. All HTTP endpoints, their routes, methods, and what they return
3. How the weather data is loaded and structured
4. Any design patterns or architectural decisions being used
5. What the test coverage looks like in test_main.py
```

### Comando 1.2 — Ejecutar la app Python (⌨️ Terminal)

```bash
cd src/python-app
pip install -r requirements.txt
cd webapp
python -m uvicorn main:app --reload --port 8000
```

### Comando 1.3 — Probar endpoints (⌨️ Terminal)

```bash
curl http://localhost:8000/weather
curl http://localhost:8000/weather/London
curl http://localhost:8000/weather/London/January
```

---

## Sección 2: Analizar y Estrategizar

### Prompt 2.1 — Estrategia de migración (💬 Ask Mode)

```
@workspace I need to migrate the Python FastAPI application in src/python-app/ to a C# .NET Minimal API application. 

Please analyze the current Python app and create a detailed migration strategy that includes:
1. What C# project structure I should create (folders, files, namespaces)
2. How to map FastAPI concepts to .NET Minimal API equivalents
3. How to handle the weather.json data loading in C#
4. What NuGet packages I'll need
5. How the routing differs between FastAPI and .NET Minimal APIs
6. A suggested order for implementing the endpoints
7. How to set up Swagger/OpenAPI in the C# project
```

### Prompt 2.2 — Identificar gaps en tests (🤖 Agent Mode)

```
@workspace Analyze the test file in src/python-app/webapp/test_main.py and the main application in src/python-app/webapp/main.py.

1. List all test cases that currently exist
2. Identify which endpoints and scenarios are NOT covered by tests
3. Suggest additional test cases that should exist for complete coverage
4. Note any edge cases that are missing (empty results, invalid cities, case sensitivity, etc.)
```

---

## Sección 3: Crear Scaffolding C#

### Prompt 3.1 — Crear archivo de instrucciones (🤖 Agent Mode)

```
Create a file called MIGRATION_INSTRUCTIONS.md in the root of the repository with the following content:

# Migration Instructions: Python FastAPI to C# .NET Minimal API

## Source Application
- Location: src/python-app/webapp/main.py
- Framework: FastAPI (Python)
- Data source: src/python-app/webapp/weather.json

## Target Application  
- Location: src/csharp-app/ (NEW - to be created)
- Framework: .NET 8 Minimal APIs (C#)
- Must maintain exact API compatibility with the Python version

## Requirements
1. Create a new C# .NET Minimal API project in src/csharp-app/
2. Copy weather.json from the Python app
3. Create a TemperatureDto model class matching the JSON structure
4. Create a WeatherService with an interface (IWeatherService)
5. Implement all three endpoints:
   - GET /weather - returns all weather records
   - GET /weather/{city} - filter by city name
   - GET /weather/{city}/{month} - filter by city and month
6. Add Swagger/OpenAPI documentation
7. Ensure JSON responses match the Python API exactly

## Technical Guidelines
- Use record types for DTOs where appropriate
- Use dependency injection for the weather service
- Load weather.json at startup
- Use System.Text.Json for serialization
- Target .NET 8 or later
```

### Prompt 3.2 — Crear scaffolding del proyecto (🤖 Agent Mode)

```
@workspace Following the instructions in MIGRATION_INSTRUCTIONS.md, create the C# .NET Minimal API project scaffolding in src/csharp-app/.

Please:
1. Create a new .NET Minimal API project (dotnet new webapi -minimal) in src/csharp-app/
2. Copy weather.json from src/python-app/webapp/weather.json to src/csharp-app/
3. Create the Models/TemperatureDto.cs file with a record that matches the weather.json structure
4. Create the Services/IWeatherService.cs interface
5. Create the Services/WeatherService.cs implementation that loads weather.json
6. Set up the basic Program.cs with dependency injection and Swagger

DO NOT implement the endpoints yet - we'll do that in the next step.
```

### Comando 3.3 — Verificar compilación (⌨️ Terminal)

```bash
cd src/csharp-app
dotnet build
```

### Prompt 3.4 — Primer endpoint: GET /weather (🤖 Agent Mode)

```
@workspace Now let's implement the first endpoint in the C# project at src/csharp-app/Program.cs.

Add the GET /weather endpoint that returns all weather records from the WeatherService.

The endpoint should:
1. Map to the route "/weather"
2. Return the complete list of weather records as JSON
3. Use the injected IWeatherService
4. Return 200 OK with the data

After adding the endpoint, run the application with 'dotnet run' and test it with 'curl http://localhost:<port>/weather' to verify it works.
```

---

## Sección 4: Implementar Endpoints

### Prompt 4.1 — GET /weather/{city} (🤖 Agent Mode)

```
@workspace Add a new endpoint to src/csharp-app/Program.cs:

GET /weather/{city}

This endpoint should:
1. Accept a city name as a route parameter
2. Use the IWeatherService to get weather records filtered by city
3. Return the filtered results as JSON
4. The city name matching should be case-insensitive (unlike the Python version, let's improve this)

Also update the WeatherService to add a method for filtering by city if it doesn't exist yet.

After implementing, test it by running the app and calling:
curl http://localhost:<port>/weather/London
```

### Prompt 4.2 — GET /weather/{city}/{month} (🤖 Agent Mode)

```
@workspace Add the final endpoint to src/csharp-app/Program.cs:

GET /weather/{city}/{month}

This endpoint should:
1. Accept city and month as route parameters
2. Filter weather records by both city and month (case-insensitive)
3. Return the filtered results as JSON
4. Return an empty array if no matches found

Update the WeatherService with a method for filtering by city and month.

After implementing, test with:
curl http://localhost:<port>/weather/London/January
curl http://localhost:<port>/weather/london/january
```

### Prompt 4.3 — Endpoint con Edit Mode (📋 Edit Mode)

*(Alternativa al prompt 4.2 — abre Program.cs primero)*

```
Add the missing endpoint GET /weather/{city}/{month} to this file. It should filter by city and month using the IWeatherService, with case-insensitive matching. Return Results.Ok with the filtered list.
```

---

## Sección 5: Validar

### Prompt 5.1 — Code review (💬 Ask Mode)

```
@workspace Do a comprehensive code review of the C# application in src/csharp-app/. Check for:

1. Code quality and C# best practices
2. Proper use of dependency injection
3. Error handling - what happens with invalid routes or malformed requests?
4. JSON serialization - are property names matching the Python API exactly?
5. Is weather.json being loaded correctly and only once?
6. Are there any memory leaks or performance issues?
7. Is Swagger/OpenAPI configured correctly?

Provide specific suggestions for improvements.
```

### Prompt 5.2 — Comparar APIs (💬 Ask Mode)

```
@workspace Compare the Python API in src/python-app/webapp/main.py with the C# API in src/csharp-app/Program.cs.

1. Are all endpoints implemented?
2. Do they return the same data structure?
3. Are there any differences in behavior?
4. What improvements does the C# version have over Python?
```

### Comando 5.3 — Comparación side-by-side (⌨️ Terminal)

```bash
# Terminal 1: Python
cd src/python-app/webapp && python -m uvicorn main:app --reload --port 8000

# Terminal 2: C#
cd src/csharp-app && dotnet run --urls http://localhost:5000

# Terminal 3: Comparar
diff <(curl -s http://localhost:8000/weather | python -m json.tool) \
     <(curl -s http://localhost:5000/weather | python -m json.tool)
```

### Prompt 5.4 — Endpoints adicionales (🤖 Agent Mode) *(Opcional)*

```
@workspace Add these additional useful endpoints to the C# app in src/csharp-app/Program.cs:

1. GET /weather/cities - returns a list of all unique city names
2. GET /weather/months - returns a list of all unique month names
3. Add proper HTTP response codes: 404 when city or city/month combination returns empty results

Update the WeatherService and interface accordingly.
```

---

## Sección 6: Tests C#

### Prompt 6.1 — Crear proyecto de tests (🤖 Agent Mode)

```
@workspace Create a comprehensive MSTest unit test project for the C# application in src/csharp-app/. 

Please:
1. Create a new MSTest project in src/csharp-app/WeatherService.UnitTests/
2. Add a project reference to the main csharp-app project
3. Create test classes that cover:

   a. WeatherServiceTests - test the service layer directly:
      - Test that GetAllWeather returns all records
      - Test that GetWeatherByCity returns correct records for a valid city
      - Test that GetWeatherByCity returns empty for an invalid city
      - Test that GetWeatherByCityAndMonth returns correct records
      - Test that GetWeatherByCityAndMonth returns empty for invalid combinations
      - Test case-insensitivity

   b. Integration tests using WebApplicationFactory:
      - Test GET /weather returns 200 and valid JSON
      - Test GET /weather/London returns filtered results
      - Test GET /weather/London/January returns specific results
      - Test GET /weather/InvalidCity returns 200 with empty array

4. Run 'dotnet test' to verify all tests pass
```

### Comando 6.2 — Ejecutar tests (⌨️ Terminal)

```bash
cd src/csharp-app/WeatherService.UnitTests
dotnet test --verbosity normal
```

### Prompt 6.3 — Análisis de cobertura (💬 Ask Mode)

```
@workspace Look at the tests in src/csharp-app/WeatherService.UnitTests/ and the main application code. What edge cases and scenarios are NOT covered? Suggest specific test cases to add.
```

### Prompt 6.4 — Tests adicionales (🤖 Agent Mode)

```
@workspace Add the following additional test cases to src/csharp-app/WeatherService.UnitTests/:

1. Test that weather.json is loaded correctly (correct number of records)
2. Test that the TemperatureDto model properties match expected types
3. Test that Swagger endpoint /swagger returns 200 OK
4. Test that unknown routes return 404
5. Test with special characters in city name
6. Test with empty string for city

Run all tests after adding them.
```

---

## Sección Bonus: Retos Avanzados

### Prompt B.1 — Contenedores Docker (🤖 Agent Mode)

```
@workspace Create Docker containers for both applications in this project:

1. Create a Dockerfile for the Python app (src/python-app/)
   - Use python:3.12-slim as base image
   - Install requirements.txt dependencies
   - Expose port 8000
   - Run with uvicorn

2. Create a Dockerfile for the C# app (src/csharp-app/)
   - Use multi-stage build (sdk for build, aspnet for runtime)
   - Target .NET 8
   - Expose port 8080

3. Create a docker-compose.yml in the root that runs both services:
   - python-api on port 8000
   - csharp-api on port 5000
   - Both should have health checks

4. Create a .dockerignore file
```

### Prompt B.2 — Entity Framework Core (🤖 Agent Mode)

```
@workspace I want to migrate the C# app in src/csharp-app/ from loading data from weather.json to using Entity Framework Core with SQLite.

Please:
1. Add the required NuGet packages (Microsoft.EntityFrameworkCore.Sqlite, Microsoft.EntityFrameworkCore.Design)
2. Create a WeatherDbContext class
3. Modify the TemperatureDto model to work as an EF entity (add Id property)
4. Create a data seeding method that loads the initial data from weather.json into the database
5. Update the WeatherService to query from the database instead of the JSON file
6. Update Program.cs to configure EF Core with SQLite
7. Create and run the initial migration
8. Test that all endpoints still return the same data

Use "Data Source=weather.db" as the connection string.
```

### Prompt B.3 — Deploy a Azure (🤖 Agent Mode)

```
@workspace Help me deploy the C# application in src/csharp-app/ to Azure App Service. 

Please:
1. Create an Azure App Service deployment script using Azure CLI
2. Use the Free tier (F1) for the App Service Plan
3. Configure it for .NET 8 on Linux
4. Include commands to:
   - Create a resource group
   - Create an App Service Plan
   - Create a Web App
   - Deploy the published application
5. Add environment variables for the app configuration

Generate a script I can run step by step.
```

---

## 🛠️ Prompts de Solución de Problemas

### Si la compilación falla

```
@workspace The C# project in src/csharp-app/ has build errors. Please analyze the errors and fix them. Run 'dotnet build' in the terminal to identify the issues.
```

### Si la API no responde igual que Python

```
@workspace The C# API response for GET /weather differs from the Python API. Please compare both responses and adjust the C# serialization settings to match exactly.
```

### Si los tests fallan

```
@workspace Some tests are failing in src/csharp-app/WeatherService.UnitTests/. Please run 'dotnet test --verbosity detailed' to see the failures and fix them.
```

### Si necesitas resetear el proyecto C#

```
@workspace Delete the src/csharp-app/ directory and recreate it from scratch following MIGRATION_INSTRUCTIONS.md. Start fresh with a clean .NET Minimal API project.
```

---

**Volver a:** [Índice →](index.md)
