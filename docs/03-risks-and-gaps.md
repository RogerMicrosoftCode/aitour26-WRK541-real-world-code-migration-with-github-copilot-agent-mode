# 03 — Risks & Gaps

## 🔴 Seguridad

| Riesgo | Severidad | Detalle |
|---|---|---|
| Sin autenticación/autorización | Alta | Ambas APIs son completamente abiertas. No hay auth middleware, API keys, ni JWT. |
| Sin CORS configurado | Media | No se define `CORSMiddleware` (Python) ni `app.UseCors()` (C#). Si se consume desde un frontend, fallará. |
| Sin HTTPS forzado | Media | No se redirige HTTP→HTTPS. En Azure App Service esto se puede configurar a nivel de plataforma. |
| Sin manejo de secretos | Baja | No aplica actualmente (no hay secretos), pero no hay infraestructura para Key Vault en caso de crecer. |
| Sin rate limiting | Media | Endpoints expuestos sin throttling. Un abuso podría saturar el servicio. |
| Sin validación de input exhaustiva | Baja | Los parámetros de ruta (`country`, `city`, `month`) no se validan contra inyecciones, aunque al ser lookup en dict/Dictionary, el impacto es bajo. |

## 🟡 Performance

| Riesgo | Severidad | Detalle |
|---|---|---|
| Datos cargados en memoria | Baja | `weather.json` (~3KB) se carga al startup. Aceptable para este dataset. |
| Cold start potencial | Media | En Azure App Service Free/Basic tier con Always On deshabilitado, la primera petición podría tardar 5-15s. |
| Sin caché de respuestas | Baja | No se usan headers `Cache-Control`. Dado que los datos son estáticos, se beneficiaría de caché. |
| Uvicorn con `--reload` en producción | Media | El `Makefile` usa `--reload`, que no debe usarse en producción. Se necesita un comando separado para prod. |

## 🟡 Confiabilidad

| Riesgo | Severidad | Detalle |
|---|---|---|
| Sin health checks | Media | No existe endpoint `/health` o `/ready`. Azure App Service necesita un health probe. |
| Sin retries ni circuit breaker | Baja | No aplica (no hay llamadas a servicios externos), pero si se añaden, será necesario. |
| Sin timeouts configurados | Baja | FastAPI/Kestrel usan defaults. Aceptable para este caso simple. |
| Sin graceful shutdown | Baja | No se maneja `SIGTERM` explícitamente. Uvicorn y Kestrel lo manejan internamente. |
| KeyError sin catch (Python) | Alta | Si se pide un país/ciudad/mes inválido, Python lanza `KeyError` → HTTP 500. C# maneja esto con `TryGetValue` → 404. |

## 🟠 Deuda Técnica

| Riesgo | Severidad | Detalle |
|---|---|---|
| Tests Python requieren app corriendo | Alta | `test_main.py` usa `requests` contra app viva, no `TestClient` de FastAPI. Si la app no está levantada, los tests se saltan silenciosamente. |
| Sin lint/format en CI | Media | CI solo despliega docs. No corre `ruff`, `black`, `dotnet format` ni tests. |
| Versiones sin pin completo | Media | Python: `pydantic`, `uvicorn`, `pytest` sin versión fija. Puede romper reproducibilidad. |
| openapi.json vacío | Baja | `src/python-app/webapp/static/openapi.json` está vacío. Sin utilidad actual. |
| .NET target es net8.0 pero devcontainer instala .NET 10 | Baja | Inconsistencia menor. Funciona porque .NET 10 es backward-compatible. |
| Sin logging estructurado | Media | Ninguna de las dos apps configura logging explícito (Serilog, Application Insights SDK, etc.). |
| Sin Dockerfile de producción | Alta | Solo existe devcontainer Dockerfile. Para desplegar en contenedores se necesitan Dockerfiles específicos. |

## 🟢 Aspectos Positivos

- Código limpio y simple en ambas implementaciones
- Tests unitarios y de integración en C# bien estructurados (MSTest + WebApplicationFactory)
- Swagger/OpenAPI configurado en ambas apps
- DevContainer funcional para desarrollo inmediato
- Datos embebidos (no dependencia externa) simplifican el despliegue

## Recomendaciones Priorizadas

1. **Agregar endpoint `/health`** a ambas apps (para probes de Azure)
2. **Crear Dockerfiles de producción** para ambas apps
3. **Corregir `KeyError` en Python** — wrap con try/except → 404
4. **Usar `TestClient` de FastAPI** en tests Python (no depender de app corriendo)
5. **Agregar lint + tests al pipeline CI**
6. **Fijar todas las versiones** en `requirements.txt`
7. **Configurar CORS** si se planea consumir desde frontend
8. **Configurar Application Insights** para observabilidad en Azure
