# Introducción al Workshop

## La Historia de Zava ☕

Bienvenido/a a **Zava**, una startup ficticia que ha construido un exitoso **servicio de API climática** usando **Python con FastAPI**. El servicio es sencillo pero robusto: proporciona datos climáticos estacionales a través de endpoints REST bien definidos.

Sin embargo, el equipo de desarrollo de Zava ha tomado una decisión estratégica: **migrar su API de Python a C# con .NET Minimal APIs**. Las razones incluyen:

- 🏢 El equipo principal tiene más experiencia en C#/.NET
- ⚡ Necesitan mejor rendimiento para la siguiente fase de crecimiento
- 🔒 Quieren aprovechar las características de tipo fuerte de C#
- 📦 El ecosistema .NET ofrece mejores herramientas empresariales

**Tu misión**: Usar **GitHub Copilot** en sus diferentes modos para realizar esta migración de manera eficiente, manteniendo la compatibilidad total de la API.

---

## ¿Qué es GitHub Copilot?

GitHub Copilot es un asistente de programación impulsado por IA que te ayuda a escribir código más rápido. En este workshop usaremos **tres modos clave**:

### 💬 Ask Mode (Modo Preguntar)
- **Propósito**: Hacer preguntas sobre tu código, obtener explicaciones y estrategia
- **Cuándo usarlo**: Cuando necesitas entender algo antes de actuar
- **Ejemplo**: "¿Qué hace este endpoint de Python? ¿Cómo lo traduciría a C#?"

### 🤖 Agent Mode (Modo Agente)
- **Propósito**: Ejecutar tareas complejas que requieren múltiples pasos
- **Cuándo usarlo**: Cuando necesitas que Copilot cree archivos, ejecute comandos y modifique código
- **Ejemplo**: "Crea el scaffolding de un proyecto C# .NET Minimal API con los mismos endpoints que la app Python"

### 📋 Edit Mode (Modo Editar)
- **Propósito**: Ediciones enfocadas en archivos específicos
- **Cuándo usarlo**: Cuando necesitas modificar código existente de manera precisa
- **Ejemplo**: Agregar un endpoint específico a un archivo existente

---

## Arquitectura: De Python a C#

### Aplicación Python (Origen)

```
src/python-app/
├── webapp/
│   ├── main.py          ← Aplicación FastAPI principal
│   ├── weather.json     ← Datos climáticos (fuente de datos)
│   ├── test_main.py     ← Tests con pytest
│   └── static/
│       └── openapi.json ← Especificación OpenAPI
```

**Endpoints de la API Python:**

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/weather` | Lista todos los registros climáticos |
| GET | `/weather/{city}` | Filtra por ciudad específica |
| GET | `/weather/{city}/{month}` | Filtra por ciudad y mes |

### Aplicación C# (Destino)

```
src/csharp-app/           ← ESTA CARPETA LA CREARÁS TÚ
├── Program.cs            ← Aplicación .NET Minimal API
├── weather.json          ← Mismos datos climáticos
├── Models/
│   └── TemperatureDto.cs ← Modelos de datos tipados
└── Services/
    ├── IWeatherService.cs    ← Interfaz del servicio
    └── WeatherService.cs     ← Implementación del servicio
```

---

## ¿Qué Vamos a Hacer?

```
┌─────────────────┐        ┌─────────────────┐
│   Python App    │        │    C# App       │
│   (FastAPI)     │  ───▶  │  (.NET 8)       │
│                 │        │                 │
│  ✓ 3 endpoints  │  GitHub │  ✓ 3 endpoints  │
│  ✓ weather.json │ Copilot │  ✓ weather.json │
│  ✓ Tests pytest │        │  ✓ Tests MSTest │
│  ✓ OpenAPI docs │        │  ✓ Swagger docs │
└─────────────────┘        └─────────────────┘
```

### Paso a paso:
1. **Explorar** la app Python existente y entender su estructura
2. **Analizar** la estrategia de migración con GitHub Copilot (Ask Mode)
3. **Crear** el scaffolding del proyecto C# (Agent Mode)
4. **Implementar** cada endpoint uno por uno, validando cada uno
5. **Verificar** que la nueva app C# es funcionalmente equivalente
6. **Agregar** tests unitarios nativos en C# (Plan Mode)

---

!!! tip "Consejo Importante"
    No necesitas ser experto/a en C# ni en Python. GitHub Copilot te guiará en cada paso. Solo necesitas seguir los prompts que te proporcionamos.

---

**Siguiente:** [Abrir el Repositorio →](abrir-repositorio.md)
