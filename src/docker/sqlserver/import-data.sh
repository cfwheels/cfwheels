#!/bin/sh

echo Running import-data.sh

# echo Sleep now
#wait for the SQL Server to come up
# sleep 15s

# echo Wake up
#run the setup script to create the DB and the schema in the DB

PW="x!bsT8t60yo0cTVTPq"
# /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${PW} -d master -i /usr/work/setup.sql
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${PW} -d master -Q "DROP DATABASE IF EXISTS wheelstestdb"
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${PW} -d master -Q "CREATE DATABASE wheelstestdb"
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${PW} -d master -Q "USE wheelstestdb"
