# Crear el Scaffolding del Proyecto C#

!!! note "Objetivo de esta sección"
    Usar **Agent Mode** de GitHub Copilot para crear la estructura base del proyecto C# .NET Minimal API, incluyendo un archivo de instrucciones que guíe a Copilot durante toda la migración.

---

## Paso 6: Crear el Archivo de Instrucciones para Copilot

Antes de generar código, vamos a crear un archivo de instrucciones que le diga a Copilot exactamente qué queremos lograr. Este archivo funciona como un "brief" para el agente.

**1.** Abre GitHub Copilot Chat (`Ctrl+Alt+I`)

**2.** Asegúrate de estar en modo **🤖 Agent**

**3.** Copia y pega este prompt:

> **🤖 Prompt para Copilot (Agent Mode):**
> ```
> Create a file called MIGRATION_INSTRUCTIONS.md in the root of the repository with the following content:
>
> # Migration Instructions: Python FastAPI to C# .NET Minimal API
>
> ## Source Application
> - Location: src/python-app/webapp/main.py
> - Framework: FastAPI (Python)
> - Data source: src/python-app/webapp/weather.json
>
> ## Target Application  
> - Location: src/csharp-app/ (NEW - to be created)
> - Framework: .NET 8 Minimal APIs (C#)
> - Must maintain exact API compatibility with the Python version
>
> ## Requirements
> 1. Create a new C# .NET Minimal API project in src/csharp-app/
> 2. Copy weather.json from the Python app
> 3. Create a TemperatureDto model class matching the JSON structure
> 4. Create a WeatherService with an interface (IWeatherService)
> 5. Implement all three endpoints:
>    - GET /weather - returns all weather records
>    - GET /weather/{city} - filter by city name
>    - GET /weather/{city}/{month} - filter by city and month
> 6. Add Swagger/OpenAPI documentation
> 7. Ensure JSON responses match the Python API exactly
>
> ## Technical Guidelines
> - Use record types for DTOs where appropriate
> - Use dependency injection for the weather service
> - Load weather.json at startup
> - Use System.Text.Json for serialization
> - Target .NET 8 or later
> ```

**4.** Espera a que Copilot cree el archivo. Verifica en el explorador de archivos que existe `MIGRATION_INSTRUCTIONS.md` en la raíz del repositorio.

!!! tip "¿Por qué un archivo de instrucciones?"
    Este archivo actúa como contexto persistente para Copilot. Cuando uses `@workspace` en prompts posteriores, Copilot podrá leer estas instrucciones y mantener coherencia a lo largo de la migración.

---

## Paso 7: Crear el Scaffolding del Proyecto C#

Ahora viene lo emocionante: vamos a pedirle a Copilot que cree toda la estructura del proyecto.

**1.** En el chat de Copilot (modo **🤖 Agent**), copia y pega:

> **🤖 Prompt para Copilot (Agent Mode):**
> ```
> @workspace Following the instructions in MIGRATION_INSTRUCTIONS.md, create the C# .NET Minimal API project scaffolding in src/csharp-app/.
>
> Please:
> 1. Create a new .NET Minimal API project (dotnet new webapi -minimal) in src/csharp-app/
> 2. Copy weather.json from src/python-app/webapp/weather.json to src/csharp-app/
> 3. Create the Models/TemperatureDto.cs file with a record that matches the weather.json structure
> 4. Create the Services/IWeatherService.cs interface
> 5. Create the Services/WeatherService.cs implementation that loads weather.json
> 6. Set up the basic Program.cs with dependency injection and Swagger
>
> DO NOT implement the endpoints yet - we'll do that in the next step.
> ```

**2.** Copilot ejecutará varios pasos automáticamente:
   - Creará el proyecto con `dotnet new`
   - Agregará archivos y carpetas
   - Configurará el proyecto

**3.** Revisa cada archivo que Copilot cree. Los archivos esperados son:

```
src/csharp-app/
├── csharp-app.csproj     ← Archivo de proyecto
├── Program.cs            ← Punto de entrada (sin endpoints aún)
├── weather.json          ← Datos copiados del proyecto Python
├── Models/
│   └── TemperatureDto.cs ← Modelo de datos
└── Services/
    ├── IWeatherService.cs    ← Interfaz
    └── WeatherService.cs     ← Implementación
```

---

## Paso 8: Verificar la Compilación

Antes de continuar, verifiquemos que el scaffolding compila correctamente.

**1.** Abre una terminal y ejecuta:

```bash
cd src/csharp-app
dotnet build
```

**2.** El resultado debería ser:

```
Build succeeded.
    0 Warning(s)
    0 Error(s)
```

!!! warning "Si la compilación falla"
    No te preocupes. Usa este prompt en Agent Mode:
    
    > **🤖 Prompt para Copilot (Agent Mode):**
    > ```
    > @workspace The C# project in src/csharp-app/ has build errors. Please analyze the errors and fix them. Run 'dotnet build' in the terminal to identify the issues.
    > ```

---

## Paso 9: Implementar el Primer Endpoint

Vamos a implementar el primer endpoint para verificar que todo funciona end-to-end.

**1.** En el chat de Copilot (modo **🤖 Agent**), copia y pega:

> **🤖 Prompt para Copilot (Agent Mode):**
> ```
> @workspace Now let's implement the first endpoint in the C# project at src/csharp-app/Program.cs.
>
> Add the GET /weather endpoint that returns all weather records from the WeatherService.
> 
> The endpoint should:
> 1. Map to the route "/weather"
> 2. Return the complete list of weather records as JSON
> 3. Use the injected IWeatherService
> 4. Return 200 OK with the data
>
> After adding the endpoint, run the application with 'dotnet run' and test it with 'curl http://localhost:<port>/weather' to verify it works.
> ```

**2.** Copilot agregará el endpoint a `Program.cs` y posiblemente ejecute la aplicación para probarla.

**3.** Verifica manualmente. Abre otra terminal y ejecuta:

```bash
curl http://localhost:5000/weather
```

(El puerto puede variar — revisa la salida de `dotnet run`)

!!! tip "Comparar con Python"
    Si quieres verificar que las respuestas son idénticas, puedes correr ambas apps simultáneamente (Python en puerto 8000, C# en puerto 5000) y comparar:
    ```bash
    # Terminal 1: Python (ya debería estar detenida)
    cd src/python-app/webapp && python -m uvicorn main:app --port 8000
    
    # Terminal 2: C#
    cd src/csharp-app && dotnet run
    
    # Terminal 3: Comparar
    diff <(curl -s http://localhost:8000/weather) <(curl -s http://localhost:5000/weather)
    ```

---

## Resumen del Paso

| # | Acción | Estado |
|---|--------|--------|
| 6 | Crear archivo de instrucciones | ✅ |
| 7 | Crear scaffolding del proyecto C# | ✅ |
| 8 | Verificar compilación | ✅ |
| 9 | Implementar primer endpoint (GET /weather) | ✅ |

---

**Siguiente:** [Implementar los Endpoints Restantes →](implementar-endpoints.md)
