# Agregar Tests en C#

!!! note "Objetivo de esta sección"
    Crear un proyecto de tests unitarios para la aplicación C# usando MSTest y **Plan Mode** de GitHub Copilot para una implementación más organizada.

---

## Paso 16: Crear el Proyecto de Tests

Vamos a usar una combinación de Agent Mode para el análisis y luego implementar los tests.

**1.** Abre GitHub Copilot Chat (`Ctrl+Alt+I`)

**2.** En modo **🤖 Agent**, copia y pega:

> **🤖 Prompt para Copilot (Agent Mode):**
> ```
> @workspace Create a comprehensive MSTest unit test project for the C# application in src/csharp-app/. 
>
> Please:
> 1. Create a new MSTest project in src/csharp-app/WeatherService.UnitTests/
> 2. Add a project reference to the main csharp-app project
> 3. Create test classes that cover:
>
>    a. WeatherServiceTests - test the service layer directly:
>       - Test that GetAllWeather returns all records
>       - Test that GetWeatherByCity returns correct records for a valid city
>       - Test that GetWeatherByCity returns empty for an invalid city
>       - Test that GetWeatherByCityAndMonth returns correct records
>       - Test that GetWeatherByCityAndMonth returns empty for invalid combinations
>       - Test case-insensitivity
>
>    b. Integration tests using WebApplicationFactory:
>       - Test GET /weather returns 200 and valid JSON
>       - Test GET /weather/London returns filtered results
>       - Test GET /weather/London/January returns specific results
>       - Test GET /weather/InvalidCity returns 200 with empty array
>
> 4. Run 'dotnet test' to verify all tests pass
> ```

**3.** Copilot creará la estructura de tests:

```
src/csharp-app/
└── WeatherService.UnitTests/
    ├── WeatherService.UnitTests.csproj  ← Proyecto de tests
    ├── WeatherServiceTests.cs           ← Tests del servicio
    └── IntegrationTests.cs              ← Tests de integración HTTP
```

---

## Paso 17: Verificar que los Tests Pasan

Ejecuta los tests:

```bash
cd src/csharp-app/WeatherService.UnitTests
dotnet test --verbosity normal
```

### Resultado esperado:

```
Passed!  - Failed:     0, Passed:    X, Skipped:     0, Total:    X
```

!!! warning "Si algún test falla"
    Usa este prompt:
    
    > **🤖 Prompt para Copilot (Agent Mode):**
    > ```
    > @workspace Some tests are failing in src/csharp-app/WeatherService.UnitTests/. Please run 'dotnet test --verbosity detailed' to see the failures and fix them.
    > ```

---

## Paso 18: Agregar Tests Adicionales con Mayor Cobertura

Para maximizar la cobertura, pide a Copilot que analice qué falta:

> **🤖 Prompt para Copilot (Ask Mode):**
> ```
> @workspace Look at the tests in src/csharp-app/WeatherService.UnitTests/ and the main application code. What edge cases and scenarios are NOT covered? Suggest specific test cases to add.
> ```

Luego implementa las sugerencias:

> **🤖 Prompt para Copilot (Agent Mode):**
> ```
> @workspace Add the following additional test cases to src/csharp-app/WeatherService.UnitTests/:
>
> 1. Test that weather.json is loaded correctly (correct number of records)
> 2. Test that the TemperatureDto model properties match expected types
> 3. Test that Swagger endpoint /swagger returns 200 OK
> 4. Test that unknown routes return 404
> 5. Test with special characters in city name
> 6. Test with empty string for city
>
> Run all tests after adding them.
> ```

---

## Resumen de Tests

| Categoría | Tests | Descripción |
|-----------|-------|-------------|
| **Servicio** | GetAllWeather | Retorna todos los registros |
| **Servicio** | GetByCity (válida) | Filtra correctamente |
| **Servicio** | GetByCity (inválida) | Retorna vacío |
| **Servicio** | GetByCityAndMonth | Filtra correctamente |
| **Servicio** | Case insensitive | Funciona con diferentes capitalizaciones |
| **Integración** | GET /weather | 200 OK + JSON válido |
| **Integración** | GET /weather/{city} | Datos filtrados |
| **Integración** | GET /weather/{city}/{month} | Datos específicos |
| **Edge cases** | Ciudad vacía | Manejo correcto |
| **Edge cases** | Caracteres especiales | Manejo correcto |

---

!!! tip "Logro desbloqueado 🏆"
    Has creado una suite de tests más completa que la que tenía la aplicación Python original. Los tests de Python solo cubrían integración HTTP, mientras que tus tests C# incluyen tanto tests unitarios del servicio como tests de integración.

---

**Siguiente:** [Resumen →](resumen.md)
