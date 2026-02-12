# Abrir el Repositorio

Tienes dos opciones para trabajar en este workshop. Elige la que prefieras:

---

## ☁️ Opción A: GitHub Codespaces (Recomendado)

!!! tip "Recomendación"
    GitHub Codespaces es la forma más rápida de empezar. No necesitas instalar nada en tu máquina local.

### Pasos:

**1.** Abre el repositorio en GitHub:

```
https://github.com/microsoft/aitour26-WRK541-real-world-code-migration-with-github-copilot-agent-mode
```

**2.** Haz clic en el botón verde **"Code"**

**3.** Selecciona la pestaña **"Codespaces"**

**4.** Haz clic en **"Create codespace on main"**

![Crear Codespace](../en/media/create-codespace.png)

**5.** Espera a que el Codespace se configure completamente (puede tardar 1-2 minutos)

**6.** Una vez listo, verás VS Code en tu navegador con todo el proyecto cargado

!!! note "Nota"
    El devcontainer incluye automáticamente:
    - Python 3.12
    - .NET SDK
    - GitHub Copilot
    - Todas las extensiones necesarias

---

## 💻 Opción B: Entorno Local

### Prerrequisitos

Antes de continuar, asegúrate de tener instalado:

| Herramienta | Versión | Cómo verificar |
|-------------|---------|-----------------|
| Python | 3.12+ | `python --version` |
| .NET SDK | 10.0+ | `dotnet --version` |
| VS Code | Última | `code --version` |
| Git | Última | `git --version` |

### Extensiones de VS Code Requeridas

| Extensión | ID |
|-----------|----|
| GitHub Copilot | `GitHub.copilot` |
| GitHub Copilot Chat | `GitHub.copilot-chat` |
| Python | `ms-python.python` |
| C# Dev Kit | `ms-dotnettools.csdevkit` |

### Pasos:

**1.** Clona el repositorio:

```bash
git clone https://github.com/microsoft/aitour26-WRK541-real-world-code-migration-with-github-copilot-agent-mode.git
```

**2.** Abre la carpeta en VS Code:

```bash
cd aitour26-WRK541-real-world-code-migration-with-github-copilot-agent-mode
code .
```

**3.** Instala las extensiones listadas arriba si no las tienes

**4.** Verifica que GitHub Copilot está activo (ícono en la barra inferior de VS Code)

---

## ✅ Verificación del Entorno

Independientemente de la opción que elegiste, verifica que todo funciona:

**1.** Abre una terminal en VS Code (`Ctrl + `` ` o `Terminal > New Terminal`)

**2.** Ejecuta estos comandos:

```bash
# Verificar Python
python --version

# Verificar .NET
dotnet --version

# Verificar que existe la app Python
ls src/python-app/webapp/main.py
```

**3.** Abre **GitHub Copilot Chat** (`Ctrl+Alt+I` o haciendo clic en el ícono de chat)

**4.** Verifica que puedes seleccionar los modos **Ask**, **Agent** y **Edit** en el menú desplegable del chat

!!! warning "Si algo falla"
    - Verifica que tu sesión de GitHub está activa
    - Asegúrate de tener una licencia de Copilot válida
    - Si usas Codespaces, intenta recargar la ventana (`Ctrl+Shift+P` → "Reload Window")

---

**Siguiente:** [Entender el Proyecto →](entender-proyecto.md)
