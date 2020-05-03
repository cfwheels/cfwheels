echo Running entrypoint.sh
sleep 60s
#start SQL Server, start the script to create the DB and import the data, start the app
/usr/work/import-data.sh & /opt/mssql/bin/sqlservr
