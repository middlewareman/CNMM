#!/usr/bin/env bash
set -euo pipefail

sqlcmd() {
  # -N enables encryption (ODBC 18 has Encrypt=Yes by default, but we keep it explicit)
  # -C trusts the server certificate (only acceptable in dev)
  /opt/mssql-tools18/bin/sqlcmd -U sa -P "$SA_PASSWORD" -S localhost -N -C "$@"
}

pingDb() {
  sqlcmd -Q "SELECT 1" >/dev/null 2>&1
}

waitForDb() {
  for i in {1..30}; do
    echo "Pinging database ${i}..."
    if pingDb; then
      echo "Database reachable"
      return 0
    fi
    sleep 1
  done
  echo "Failed connecting" >&2
  return 1
}

waitForDb # Failure will terminate script here

if ! sqlcmd -d master -i setup.sql; then
  echo "setup.sql failed" >&2
  exit 1
fi

echo "Import finished successfully"