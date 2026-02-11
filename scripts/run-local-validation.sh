#!/usr/bin/env bash
# =============================================================================
# run-local-validation.sh — Build, lint, and test both apps locally
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

PASS=0
FAIL=0
SKIP=0

report() {
    local status=$1 label=$2
    if [ "$status" = "PASS" ]; then
        echo "  ✅ $label"
        ((PASS++))
    elif [ "$status" = "FAIL" ]; then
        echo "  ❌ $label"
        ((FAIL++))
    else
        echo "  ⏭️  $label (skipped)"
        ((SKIP++))
    fi
}

echo "========================================"
echo "  LOCAL VALIDATION"
echo "========================================"
echo ""

# ── 1. Python: Check syntax ─────────────────────────────────────────────────

echo "▶ 1. Python: Syntax check"
if command -v python3 &> /dev/null || command -v python &> /dev/null; then
    PY_CMD=$(command -v python3 || command -v python)
    if $PY_CMD -m py_compile "$REPO_ROOT/src/python-app/webapp/main.py" 2>/dev/null; then
        report "PASS" "Python syntax check (main.py)"
    else
        report "FAIL" "Python syntax check (main.py)"
    fi
else
    report "SKIP" "Python syntax check (python not found)"
fi

# ── 2. Python: Lint (ruff) ──────────────────────────────────────────────────

echo "▶ 2. Python: Lint"
if command -v ruff &> /dev/null; then
    if ruff check "$REPO_ROOT/src/python-app/webapp/main.py" --quiet 2>/dev/null; then
        report "PASS" "Python lint (ruff)"
    else
        report "FAIL" "Python lint (ruff)"
    fi
else
    report "SKIP" "Python lint (ruff not installed)"
fi

# ── 3. C#: Restore ──────────────────────────────────────────────────────────

echo "▶ 3. C#: Restore packages"
if command -v dotnet &> /dev/null; then
    if dotnet restore "$REPO_ROOT/src/csharp-app-complete/csharp-app.sln" --verbosity quiet 2>/dev/null; then
        report "PASS" "C# restore"
    else
        report "FAIL" "C# restore"
    fi
else
    report "SKIP" "C# restore (dotnet not found)"
fi

# ── 4. C#: Build ────────────────────────────────────────────────────────────

echo "▶ 4. C#: Build"
if command -v dotnet &> /dev/null; then
    if dotnet build "$REPO_ROOT/src/csharp-app-complete/csharp-app.sln" --configuration Release --verbosity quiet --no-restore 2>/dev/null; then
        report "PASS" "C# build (Release)"
    else
        report "FAIL" "C# build (Release)"
    fi
else
    report "SKIP" "C# build (dotnet not found)"
fi

# ── 5. C#: Unit Tests ───────────────────────────────────────────────────────

echo "▶ 5. C#: Unit tests"
if command -v dotnet &> /dev/null; then
    if dotnet test "$REPO_ROOT/src/csharp-app-complete/csharp-app.sln" --configuration Release --verbosity quiet --no-build 2>/dev/null; then
        report "PASS" "C# unit + integration tests"
    else
        report "FAIL" "C# unit + integration tests"
    fi
else
    report "SKIP" "C# tests (dotnet not found)"
fi

# ── 6. Bicep: Validate ──────────────────────────────────────────────────────

echo "▶ 6. Bicep: Validate template"
if command -v az &> /dev/null; then
    if az bicep build --file "$REPO_ROOT/infra/main.bicep" --stdout > /dev/null 2>&1; then
        report "PASS" "Bicep compilation"
    else
        report "FAIL" "Bicep compilation"
    fi
else
    report "SKIP" "Bicep validation (az CLI not found)"
fi

# ── Summary ──────────────────────────────────────────────────────────────────

echo ""
echo "========================================"
echo "  SUMMARY"
echo "========================================"
echo "  Passed:  $PASS"
echo "  Failed:  $FAIL"
echo "  Skipped: $SKIP"
echo "========================================"

if [ "$FAIL" -gt 0 ]; then
    echo "  ❌ Some validations failed."
    exit 1
else
    echo "  ✅ All validations passed."
    exit 0
fi
