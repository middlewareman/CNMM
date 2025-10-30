#!/usr/bin/env bash

: "${SA_PASSWORD:?SA_PASSWORD is required}"

# Start patiently polling import script in the background
./import-data.sh &

# Start SQL Server in the foreground
ACCEPT_EULA=Y /opt/mssql/bin/sqlservr
