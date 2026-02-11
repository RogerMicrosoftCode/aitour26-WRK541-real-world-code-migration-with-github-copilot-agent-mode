# Tests README

## Overview

This directory contains validation and smoke test scripts for the Weather API Workshop.

## Test Types

| Type | Tool | Location | Description |
|---|---|---|---|
| **Unit Tests (C#)** | MSTest | `src/csharp-app-complete/WeatherService.UnitTests/` | Tests `WeatherService` directly |
| **Integration Tests (C#)** | MSTest + WebApplicationFactory | `src/csharp-app-complete/WeatherService.UnitTests/Test1.cs` | HTTP tests via in-memory server |
| **Integration Tests (Python)** | pytest + requests | `src/python-app/webapp/test_main.py` | HTTP tests (requires running app) |
| **Smoke Tests** | bash + curl | `scripts/run-smoke-tests.sh` | Validates endpoints after deployment |
| **Local Validation** | bash | `scripts/run-local-validation.sh` | Build + lint + unit tests locally |

## Running Tests

### Local Validation (build + tests)

```bash
chmod +x scripts/run-local-validation.sh
./scripts/run-local-validation.sh
```

### Smoke Tests (after deployment)

```bash
# For local apps
export BASE_URL_PYTHON=http://localhost:8000
export BASE_URL_CSHARP=http://localhost:5000

# For Azure-deployed apps
export BASE_URL_PYTHON=https://app-demoaitourmxJJ-python.azurewebsites.net
export BASE_URL_CSHARP=https://app-demoaitourmxJJ-csharp.azurewebsites.net

chmod +x scripts/run-smoke-tests.sh
./scripts/run-smoke-tests.sh
```

## Future Test Improvements

1. **Python**: Migrate from `requests` to FastAPI `TestClient` for offline tests
2. **Python**: Add unit tests for data loading and edge cases
3. **C#**: Add load/performance tests with `k6` or `BenchmarkDotNet`
4. **Both**: Add contract tests ensuring Python and C# APIs return identical responses
5. **CI**: Run all tests on every PR
