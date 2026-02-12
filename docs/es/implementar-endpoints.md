# Implementar los Endpoints Restantes

!!! note "Objetivo de esta sección"
    Implementar los dos endpoints restantes uno a uno, validando cada uno antes de pasar al siguiente. Usaremos tanto **Agent Mode** como exploraremos el uso de **Edit Mode**.

---

## Paso 10: Implementar GET /weather/{city}

**1.** Abre GitHub Copilot Chat (`Ctrl+Alt+I`)

**2.** Asegúrate de estar en modo **🤖 Agent**

**3.** Copia y pega este prompt:

> **🤖 Prompt para Copilot (Agent Mode):**
> ```
> @workspace Add a new endpoint to src/csharp-app/Program.cs:
>
> GET /weather/{city}
>
> This endpoint should:
> 1. Accept a city name as a route parameter
> 2. Use the IWeatherService to get weather records filtered by city
> 3. Return the filtered results as JSON
> 4. The city name matching should be case-insensitive (unlike the Python version, let's improve this)
>
> Also update the WeatherService to add a method for filtering by city if it doesn't exist yet.
>
> After implementing, test it by running the app and calling:
> curl http://localhost:<port>/weather/London
> ```

**4.** Espera a que Copilot implemente el endpoint y verifique su funcionamiento.

### Verificación Manual

Con la app C# corriendo, prueba estos comandos:

```bash
# Ciudad válida
curl http://localhost:5000/weather/London

# Ciudad con diferente capitalización (debería funcionar)
curl http://localhost:5000/weather/london

# Ciudad inválida (debería retornar array vacío)
curl http://localhost:5000/weather/CiudadInexistente
```

!!! tip "Mejora sobre Python"
    Nota que estamos mejorando la app: la versión Python es case-sensitive, pero nuestra versión C# debería ser case-insensitive. ¡Es una mejora válida durante una migración!

---

## Paso 11: Implementar GET /weather/{city}/{month}

**1.** En el chat de Copilot (modo **🤖 Agent**), copia y pega:

> **🤖 Prompt para Copilot (Agent Mode):**
> ```
> @workspace Add the final endpoint to src/csharp-app/Program.cs:
>
> GET /weather/{city}/{month}
>
> This endpoint should:
> 1. Accept city and month as route parameters
> 2. Filter weather records by both city and month (case-insensitive)
> 3. Return the filtered results as JSON
> 4. Return an empty array if no matches found
>
> Update the WeatherService with a method for filtering by city and month.
>
> After implementing, test with:
> curl http://localhost:<port>/weather/London/January
> curl http://localhost:<port>/weather/london/january
> ```

**2.** Verifica el endpoint:

```bash
# Ciudad y mes válidos
curl http://localhost:5000/weather/London/January

# Diferentes capitalizaciones
curl http://localhost:5000/weather/london/january

# Ciudad o mes inválido
curl http://localhost:5000/weather/London/InvalidMonth
```

---

## Alternativa: Usar Edit Mode

Si prefieres más control sobre qué archivos se modifican, puedes usar **Edit Mode** para agregar endpoints de manera más quirúrgica:

**1.** Abre `src/csharp-app/Program.cs` en el editor

**2.** Cambia al modo **📋 Edit** en el chat de Copilot

**3.** Copia y pega:

> **🤖 Prompt para Copilot (Edit Mode):**
> ```
> Add the missing endpoint GET /weather/{city}/{month} to this file. It should filter by city and month using the IWeatherService, with case-insensitive matching. Return Results.Ok with the filtered list.
> ```

**4.** Copilot te mostrará los cambios propuestos. Revísalos y haz clic en **"Accept"** o **"Discard"**.

!!! note "Edit Mode vs Agent Mode"
    | Característica | Agent Mode | Edit Mode |
    |---------------|------------|-----------|
    | Múltiples archivos | ✅ Sí | ❌ Solo archivos seleccionados |
    | Ejecutar comandos | ✅ Sí | ❌ No |
    | Control preciso | ⚠️ Menor | ✅ Mayor |
    | Velocidad | ⚠️ Más lento | ✅ Más rápido |

---

## Paso 12: Verificar Todos los Endpoints

Ejecuta la app C# y prueba todos los endpoints:

```bash
cd src/csharp-app
dotnet run
```

En otra terminal:

```bash
echo "=== GET /weather ==="
curl -s http://localhost:5000/weather | head -c 200

echo ""
echo "=== GET /weather/London ==="
curl -s http://localhost:5000/weather/London | head -c 200

echo ""
echo "=== GET /weather/London/January ==="
curl -s http://localhost:5000/weather/London/January
```

### Verificar Swagger

Abre en tu navegador:
```
http://localhost:5000/swagger
```

Deberías ver los tres endpoints documentados con la opción de probarlos directamente.

---

## Verificación con Copilot

Si quieres que Copilot haga una revisión completa, usa este prompt:

> **🤖 Prompt para Copilot (Ask Mode):**
> ```
> @workspace Compare the Python API in src/python-app/webapp/main.py with the C# API in src/csharp-app/Program.cs.
>
> 1. Are all endpoints implemented?
> 2. Do they return the same data structure?
> 3. Are there any differences in behavior?
> 4. What improvements does the C# version have over Python?
> ```

---

## Resumen del Paso

| # | Acción | Estado |
|---|--------|--------|
| 10 | GET /weather/{city} implementado | ✅ |
| 11 | GET /weather/{city}/{month} implementado | ✅ |
| 12 | Todos los endpoints verificados | ✅ |

---

**Siguiente:** [Validar Correctitud →](validar-correctitud.md)
