echo Running import-data.sh

#wait for the SQL Server to come up
sleep 60s

#run the setup script to create the DB and the schema in the DB
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P x!bsT8t60yo0cTVTPq -d master -i setup.sql
