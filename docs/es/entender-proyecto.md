# Entender el Proyecto Python

!!! note "Objetivo de esta sección"
    Explorar la aplicación Python existente, entender su estructura, ejecutarla localmente y familiarizarnos con sus endpoints antes de comenzar la migración.

---

## Paso 1: Explorar la Estructura del Proyecto

Abre el panel del explorador de archivos en VS Code y navega a `src/python-app/`.

```
src/python-app/
├── webapp/
│   ├── main.py          ← Archivo principal de la aplicación FastAPI
│   ├── weather.json     ← Datos climáticos en formato JSON
│   ├── test_main.py     ← Tests de la aplicación
│   └── static/
│       └── openapi.json ← Especificación OpenAPI/Swagger
├── requirements.txt     ← Dependencias de Python
├── Makefile             ← Comandos de automatización
└── README.md            ← Documentación del proyecto
```

### 📄 Archivos Clave

**`main.py`** — Contiene toda la lógica de la aplicación:
- Carga datos desde `weather.json`
- Define tres endpoints REST
- Incluye filtrado por ciudad y mes

**`weather.json`** — Archivo de datos estáticos con registros climáticos por ciudad y mes

**`test_main.py`** — Tests de integración que validan los endpoints HTTP

---

## Paso 2: Ejecutar la Aplicación Python

Abre una terminal en VS Code y ejecuta:

```bash
cd src/python-app
pip install -r requirements.txt
cd webapp
python -m uvicorn main:app --reload --port 8000
```

!!! tip "Resultado esperado"
    Deberías ver algo como:
    ```
    INFO:     Uvicorn running on http://127.0.0.1:8000
    INFO:     Started reloader process
    ```

---

## Paso 3: Probar los Endpoints

Con la aplicación corriendo, abre otra terminal (o usa tu navegador) para probar:

### Endpoint 1: Obtener todos los registros

```bash
curl http://localhost:8000/weather
```

### Endpoint 2: Filtrar por ciudad

```bash
curl http://localhost:8000/weather/London
```

### Endpoint 3: Filtrar por ciudad y mes

```bash
curl http://localhost:8000/weather/London/January
```

### Documentación Swagger/OpenAPI

Abre en tu navegador:

```
http://localhost:8000/docs
```

!!! note "Observa"
    - Los datos provienen de un archivo JSON estático (no de una base de datos)
    - Los nombres de ciudades y meses son **case-sensitive** en la implementación actual
    - La API devuelve arreglos JSON en todos los endpoints
    - Swagger UI está habilitado por defecto en FastAPI

---

## Paso 4: Usa GitHub Copilot para Entender el Código

Ahora vamos a usar **Ask Mode** de GitHub Copilot para entender mejor la aplicación.

**1.** Abre `src/python-app/webapp/main.py` en el editor

**2.** Abre GitHub Copilot Chat (`Ctrl+Alt+I`)

**3.** Asegúrate de estar en modo **💬 Ask**

**4.** Copia y pega el siguiente prompt:

> **🤖 Prompt para Copilot (Ask Mode):**
> ```
> @workspace Analyze the Python application in src/python-app/webapp/main.py. Explain:
> 1. What framework is being used and its version
> 2. All HTTP endpoints, their routes, methods, and what they return
> 3. How the weather data is loaded and structured
> 4. Any design patterns or architectural decisions being used
> 5. What the test coverage looks like in test_main.py
> ```

**5.** Lee la respuesta de Copilot con atención. Estos son los puntos clave que debes comprender:

| Aspecto | Detalle |
|---------|---------|
| Framework | FastAPI (Python) |
| Servidor | Uvicorn |
| Datos | Archivo JSON estático cargado al inicio |
| Endpoints | 3 rutas GET para datos climáticos |
| Tests | Tests de integración HTTP con pytest |
| Docs | OpenAPI/Swagger automático |

---

## Paso 5: Detener la Aplicación Python

Cuando termines de explorar, vuelve a la terminal donde está corriendo la app y presiona `Ctrl+C` para detenerla.

---

!!! warning "Antes de continuar"
    Asegúrate de que entiendes:
    - ✅ Los tres endpoints y qué retorna cada uno
    - ✅ La estructura del archivo `weather.json`
    - ✅ Que los tests actuales son de integración HTTP (requieren la app corriendo)
    - ✅ Que FastAPI genera documentación Swagger automáticamente

---

**Siguiente:** [Analizar el Proyecto →](analizar-proyecto.md)
