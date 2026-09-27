#!/usr/bin/env sh
set -eu

health_url="${1:-http://localhost:9966/petclinic/actuator/health}"
attempt=1

while [ "$attempt" -le 60 ]; do
  if curl --fail --silent --show-error "$health_url" >/dev/null 2>&1; then
    echo "PetClinic is ready: $health_url"
    exit 0
  fi
  attempt=$((attempt + 1))
  sleep 2
done

echo "PetClinic did not become ready within 120 seconds: $health_url" >&2
exit 1
