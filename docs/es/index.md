# WRK541 - Migración de Código Real con GitHub Copilot Agent Mode

![Microsoft AI Tour Banner](../en/media/aitour-banner.png)

### Realiza una migración desafiante a un lenguaje completamente diferente

- **¿Para quién es esto?**: Cualquier tecnólogo que busque aplicar técnicas de programación asistida por IA con GitHub Copilot para realizar tareas complejas como migrar o traducir de un lenguaje de programación a otro.
- **¿Qué aprenderás?**: Usarás técnicas avanzadas de GitHub Copilot que son especialmente útiles al traducir proyectos entre diferentes lenguajes de programación, así como los diferentes modos que GitHub Copilot ofrece.
- **¿Qué construirás?**: Una API HTTP para consultar datos de clima estacional, usando C# con .NET Minimal APIs, con compatibilidad total respecto a la API HTTP original escrita en Python.

## Objetivos de Aprendizaje

En este taller aprenderás a:

- Conocer las diferencias entre cada uno de los modos de GitHub Copilot, cuándo usar cada uno, mejores prácticas y herramientas para sacar el máximo provecho.
- Comprender las diferencias entre Python y C# para desarrollo web.
- Aprender las diferencias clave en sintaxis, bibliotecas y frameworks al transicionar de FastAPI (Python) a ASP.NET Core Minimal APIs (C#).
- Implementar serialización y deserialización JSON en C#.
- Desarrollar y validar endpoints de manera incremental en C#.
- Integrar documentación Swagger/OpenAPI.

## 📣 Prerrequisitos

Solo necesitas una cuenta de GitHub. Todos los recursos, dependencias y datos son parte del repositorio. Asegúrate de tener tu licencia de GitHub Copilot (paga, trial o versión gratuita).

### ✅ Checklist Rápido

- [ ] **Cuenta de GitHub** creada y funcional
- [ ] **GitHub Copilot** habilitado (suscripción, trial o versión gratuita)
- [ ] **Entorno elegido**:
  - ☁️ **GitHub Codespaces** (recomendado — cero configuración)
  - 💻 **Local** (requiere Python 3.12, .NET 10 SDK, VS Code — ver [Recursos](recursos.md))

---

## 🗺️ Mapa del Laboratorio

```
┌─────────────────────────────────────────────────────────────────┐
│                    FLUJO DEL WORKSHOP                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  PASO 1          PASO 2           PASO 3          PASO 4       │
│  ┌──────────┐   ┌──────────┐   ┌───────────┐   ┌──────────┐   │
│  │ Preparar │──▶│ Explorar │──▶│ Crear     │──▶│ Migrar   │   │
│  │ Entorno  │   │ Python   │   │ Scaffolding│  │ Endpoints│   │
│  │          │   │ App      │   │ C#        │   │          │   │
│  └──────────┘   └──────────┘   └───────────┘   └──────────┘   │
│       │              │              │               │          │
│       ▼              ▼              ▼               ▼          │
│  Codespaces     Entender       Instrucciones    Uno a uno     │
│  o Local        endpoints      Copilot          + validar     │
│                 + tests        + Agent Mode     con tests     │
│                                                                │
│  PASO 5          PASO 6           BONUS                        │
│  ┌──────────┐   ┌──────────┐   ┌───────────┐                  │
│  │ Validar  │──▶│ Tests    │──▶│ Retos     │                  │
│  │ Todo     │   │ C# con   │   │ Avanzados │                  │
│  │          │   │ MSTest   │   │           │                  │
│  └──────────┘   └──────────┘   └───────────┘                  │
│       │              │              │                           │
│       ▼              ▼              ▼                           │
│  Revisar con    Plan Mode      Docker,                         │
│  Copilot        + ejecución    DB, Azure                       │
│                                                                │
└─────────────────────────────────────────────────────────────────┘
```

---

## Secuencia de Páginas

| # | Sección | Página | Descripción |
|---|---------|--------|-------------|
| 0 | Inicio | [Navegación del Workshop](navegacion-workshop.md) | Cómo navegar la documentación |
| 1 | Inicio | [Introducción](introduccion-workshop.md) | Contexto, historia de Zava, modos de Copilot |
| 2 | Inicio | [Abrir el Repositorio](abrir-repositorio.md) | Codespaces o local |
| 3 | Explorar | [Entender el Proyecto](entender-proyecto.md) | Explorar Python app, endpoints, tests |
| 4 | Estrategia | [Analizar el Proyecto](analizar-proyecto.md) | Estrategizar con Copilot, tests faltantes |
| 5 | Migración | [Crear Scaffolding C#](crear-scaffolding-csharp.md) | Instrucciones Copilot + scaffolding |
| 6 | Migración | [Implementar Endpoints](implementar-endpoints.md) | Endpoint por endpoint + validación |
| 7 | Validación | [Validar Correctitud](validar-correctitud.md) | Revisión completa + endpoints adicionales |
| 8 | Tests | [Agregar Tests C#](agregar-tests-csharp.md) | Tests nativos MSTest |
| 9 | Cierre | [Resumen](resumen.md) | Logros y próximos pasos |
| 10 | Bonus | [Retos Avanzados](retos-bonus.md) | Docker, DB, Azure |

Comencemos haciendo clic en **"Navegación del Workshop"** →
