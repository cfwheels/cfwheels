#!/bin/bash

# Start SQL Server in the background
/opt/mssql/bin/sqlservr &

# Wait for SQL Server to start
# The loop below is checking every 2 seconds if SQL Server is ready to accept connections
while ! /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "x!bsT8t60yo0cTVTPq" -Q "SELECT 1" > /dev/null 2>&1; do
    echo "Waiting for SQL Server to start..."
    sleep 2
done

echo "SQL Server started."

# Create the database
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "x!bsT8t60yo0cTVTPq" -Q "CREATE DATABASE wheelstestdb"

echo "Database 'wheelstestdb' created."

# Keep the container running
wait
