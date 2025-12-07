#!/bin/bash
set -e

HOST=${1:-http://localhost:3000}
HEALTH_URL="$HOST/health"

echo "Checking $HEALTH_URL ..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" $HEALTH_URL || echo "000")

if [ "$HTTP_CODE" == "200" ]; then
  echo "SMOKE PASSED ($HTTP_CODE)"
  curl -s $HEALTH_URL
  exit 0
else
  echo "SMOKE FAILED (HTTP $HTTP_CODE)"
  exit 1
fi
