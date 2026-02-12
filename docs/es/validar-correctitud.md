# Validar Correctitud

!!! note "Objetivo de esta sección"
    Realizar una validación completa de la aplicación C# migrada, comparándola con la versión Python original para asegurar equivalencia funcional.

---

## Paso 13: Revisión de Código con Copilot

Antes de declarar la migración como exitosa, vamos a hacer una revisión completa.

**1.** Abre GitHub Copilot Chat (`Ctrl+Alt+I`)

**2.** En modo **💬 Ask**, copia y pega:

> **🤖 Prompt para Copilot (Ask Mode):**
> ```
> @workspace Do a comprehensive code review of the C# application in src/csharp-app/. Check for:
>
> 1. Code quality and C# best practices
> 2. Proper use of dependency injection
> 3. Error handling - what happens with invalid routes or malformed requests?
> 4. JSON serialization - are property names matching the Python API exactly?
> 5. Is weather.json being loaded correctly and only once?
> 6. Are there any memory leaks or performance issues?
> 7. Is Swagger/OpenAPI configured correctly?
>
> Provide specific suggestions for improvements.
> ```

**3.** Revisa las sugerencias de Copilot y toma nota de las que quieras implementar.

---

## Paso 14: Comparación Side-by-Side

Ejecuta ambas aplicaciones simultáneamente para comparar las respuestas.

### Iniciar ambas apps:

**Terminal 1 — Python:**
```bash
cd src/python-app/webapp
python -m uvicorn main:app --reload --port 8000
```

**Terminal 2 — C#:**
```bash
cd src/csharp-app
dotnet run --urls http://localhost:5000
```

### Comparar respuestas:

**Terminal 3:**

```bash
echo "=== Comparando GET /weather ==="
diff <(curl -s http://localhost:8000/weather | python -m json.tool) \
     <(curl -s http://localhost:5000/weather | python -m json.tool)

echo ""
echo "=== Comparando GET /weather/London ==="
diff <(curl -s http://localhost:8000/weather/London | python -m json.tool) \
     <(curl -s http://localhost:5000/weather/London | python -m json.tool)

echo ""
echo "=== Comparando GET /weather/London/January ==="
diff <(curl -s http://localhost:8000/weather/London/January | python -m json.tool) \
     <(curl -s http://localhost:5000/weather/London/January | python -m json.tool)
```

!!! tip "Si ves diferencias"
    Las diferencias comunes incluyen:
    - **Orden de propiedades JSON**: C# puede serializar en orden diferente — esto es aceptable
    - **Capitalización de propiedades**: Asegúrate de que usen la misma capitalización
    - **Formato de números**: Decimales pueden representarse diferente
    
    Si ves diferencias en los datos, usa Agent Mode para corregirlas:
    
    > **🤖 Prompt para Copilot (Agent Mode):**
    > ```
    > @workspace The C# API response for GET /weather differs from the Python API. The Python API returns [paste Python response snippet]. Please adjust the C# serialization to match exactly.
    > ```

---

## Paso 15: Agregar Endpoints Adicionales (Opcional)

Si tienes tiempo, puedes mejorar la API C# con endpoints adicionales que no existían en Python.

> **🤖 Prompt para Copilot (Agent Mode):**
> ```
> @workspace Add these additional useful endpoints to the C# app in src/csharp-app/Program.cs:
>
> 1. GET /weather/cities - returns a list of all unique city names
> 2. GET /weather/months - returns a list of all unique month names
> 3. Add proper HTTP response codes: 404 when city or city/month combination returns empty results
>
> Update the WeatherService and interface accordingly.
> ```

---

## Checklist de Validación

| # | Verificación | Resultado |
|---|-------------|-----------|
| 1 | `dotnet build` sin errores | ☐ |
| 2 | GET /weather retorna todos los datos | ☐ |
| 3 | GET /weather/{city} filtra correctamente | ☐ |
| 4 | GET /weather/{city}/{month} filtra correctamente | ☐ |
| 5 | Swagger UI funciona (/swagger) | ☐ |
| 6 | JSON de respuesta coincide con Python | ☐ |
| 7 | Case-insensitive funciona | ☐ |
| 8 | Ciudades inválidas retornan array vacío o 404 | ☐ |

---

**Siguiente:** [Agregar Tests C# →](agregar-tests-csharp.md)
