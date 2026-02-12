# Analizar el Proyecto con GitHub Copilot

!!! note "Objetivo de esta sección"
    Usar GitHub Copilot en **Ask Mode** para estrategizar la migración, y luego en **Agent Mode** para identificar gaps en los tests de la aplicación Python.

---

## Paso 4: Crear una Estrategia de Migración (Ask Mode)

Vamos a usar Copilot para diseñar nuestra estrategia de migración antes de escribir código.

**1.** Abre GitHub Copilot Chat (`Ctrl+Alt+I`)

**2.** Asegúrate de estar en modo **💬 Ask**

**3.** Copia y pega este prompt:

> **🤖 Prompt para Copilot (Ask Mode):**
> ```
> @workspace I need to migrate the Python FastAPI application in src/python-app/ to a C# .NET Minimal API application. 
>
> Please analyze the current Python app and create a detailed migration strategy that includes:
> 1. What C# project structure I should create (folders, files, namespaces)
> 2. How to map FastAPI concepts to .NET Minimal API equivalents
> 3. How to handle the weather.json data loading in C#
> 4. What NuGet packages I'll need
> 5. How the routing differs between FastAPI and .NET Minimal APIs
> 6. A suggested order for implementing the endpoints
> 7. How to set up Swagger/OpenAPI in the C# project
> ```

**4.** Lee la respuesta de Copilot. Copilot analizará toda la estructura del workspace y te proporcionará un plan detallado.

!!! tip "Lo que deberías aprender de esta respuesta"
    - La equivalencia entre `fastapi.FastAPI()` y `WebApplication.CreateBuilder()`
    - Que C# necesita modelos tipados (clases/records) para deserializar JSON
    - Que .NET Minimal APIs usa `app.MapGet()` en lugar de decoradores `@app.get()`
    - Paquetes como `Swashbuckle.AspNetCore` para Swagger

---

## Paso 5: Identificar Tests Faltantes (Agent Mode)

Ahora cambiamos a **Agent Mode** para que Copilot analice los tests existentes y encuentre gaps.

**1.** En el chat de Copilot, cambia al modo **🤖 Agent**

**2.** Copia y pega este prompt:

> **🤖 Prompt para Copilot (Agent Mode):**
> ```
> @workspace Analyze the test file in src/python-app/webapp/test_main.py and the main application in src/python-app/webapp/main.py.
>
> 1. List all test cases that currently exist
> 2. Identify which endpoints and scenarios are NOT covered by tests
> 3. Suggest additional test cases that should exist for complete coverage
> 4. Note any edge cases that are missing (empty results, invalid cities, case sensitivity, etc.)
> ```

**3.** Revisa la respuesta. Copilot debería identificar varios gaps como:

| Tipo de Test | Estado |
|--------------|--------|
| GET /weather (todos los datos) | ✅ Cubierto |
| GET /weather/{city} válida | ✅ Cubierto |
| GET /weather/{city} inválida | ⚠️ Posiblemente no cubierto |
| GET /weather/{city}/{month} válido | ✅ Cubierto |
| GET /weather/{city}/{month} inválido | ⚠️ Posiblemente no cubierto |
| Casos edge (mayúsculas/minúsculas) | ❌ No cubierto |
| Verificación de estructura JSON | ⚠️ Parcial |

!!! warning "Importante"
    No necesitas arreglar los tests de Python ahora. Esta información nos servirá para asegurarnos de que la versión C# tenga **mejor cobertura de tests** que la original.

---

## Resumen de lo Aprendido

Hasta aquí deberías tener claro:

- ✅ La estructura completa de la app Python
- ✅ Los tres endpoints y sus respuestas
- ✅ Una estrategia de migración a C#
- ✅ Los gaps en la cobertura de tests actual
- ✅ Cómo usar Ask Mode vs Agent Mode

---

**Siguiente:** [Crear Scaffolding C# →](crear-scaffolding-csharp.md)
