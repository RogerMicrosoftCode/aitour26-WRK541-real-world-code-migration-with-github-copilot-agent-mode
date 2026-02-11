#!/usr/bin/env bash
# =============================================================================
# run-smoke-tests.sh — Smoke tests for deployed APIs (local or Azure)
# =============================================================================
set -euo pipefail

# ── Configuration ────────────────────────────────────────────────────────────

BASE_URL_PYTHON="${BASE_URL_PYTHON:-http://localhost:8000}"
BASE_URL_CSHARP="${BASE_URL_CSHARP:-http://localhost:5000}"
TIMEOUT=15  # seconds per request

PASS=0
FAIL=0
TOTAL=0

# ── Helpers ──────────────────────────────────────────────────────────────────

smoke_test() {
    local label=$1
    local url=$2
    local expected_status=$3
    local body_contains=${4:-""}

    ((TOTAL++))

    HTTP_CODE=$(curl -s -o /tmp/smoke_body.txt -w "%{http_code}" \
        --max-time "$TIMEOUT" \
        -L "$url" 2>/dev/null || echo "000")

    if [ "$HTTP_CODE" = "$expected_status" ]; then
        if [ -n "$body_contains" ]; then
            if grep -q "$body_contains" /tmp/smoke_body.txt 2>/dev/null; then
                echo "  ✅ $label → HTTP $HTTP_CODE (body contains '$body_contains')"
                ((PASS++))
            else
                echo "  ❌ $label → HTTP $HTTP_CODE (body missing '$body_contains')"
                ((FAIL++))
            fi
        else
            echo "  ✅ $label → HTTP $HTTP_CODE"
            ((PASS++))
        fi
    else
        echo "  ❌ $label → HTTP $HTTP_CODE (expected $expected_status)"
        ((FAIL++))
    fi
}

# ── Run Tests ────────────────────────────────────────────────────────────────

echo "========================================"
echo "  SMOKE TESTS"
echo "========================================"
echo "  Python API: $BASE_URL_PYTHON"
echo "  C# API:     $BASE_URL_CSHARP"
echo ""

# ── Python App Tests ─────────────────────────────────────────────────────────

echo "▶ Python App"
smoke_test "Python: Root → Swagger redirect" \
    "$BASE_URL_PYTHON/" "200"

smoke_test "Python: GET /countries" \
    "$BASE_URL_PYTHON/countries" "200" "England"

smoke_test "Python: GET /countries/England/London/January" \
    "$BASE_URL_PYTHON/countries/England/London/January" "200" "high"

smoke_test "Python: GET /countries/Spain/Seville/January" \
    "$BASE_URL_PYTHON/countries/Spain/Seville/January" "200" "low"

echo ""

# ── C# App Tests ─────────────────────────────────────────────────────────────

echo "▶ C# App"
smoke_test "C#: Root → Swagger redirect" \
    "$BASE_URL_CSHARP/" "200"

smoke_test "C#: GET /countries" \
    "$BASE_URL_CSHARP/countries" "200" "England"

smoke_test "C#: GET /countries/England/London/January" \
    "$BASE_URL_CSHARP/countries/England/London/January" "200" "high"

smoke_test "C#: GET /countries (7 countries)" \
    "$BASE_URL_CSHARP/countries" "200" "France"

smoke_test "C#: Invalid country returns 404" \
    "$BASE_URL_CSHARP/countries/Atlantis/Lost/January" "404"

# ── Summary ──────────────────────────────────────────────────────────────────

echo ""
echo "========================================"
echo "  SUMMARY"
echo "========================================"
echo "  Total:   $TOTAL"
echo "  Passed:  $PASS"
echo "  Failed:  $FAIL"
echo "========================================"

if [ "$FAIL" -gt 0 ]; then
    echo "  ❌ Some smoke tests failed."
    exit 1
else
    echo "  ✅ All smoke tests passed."
    exit 0
fi
