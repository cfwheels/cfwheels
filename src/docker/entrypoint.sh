echo Running entrypoint.sh
#start SQL Server, start the script to create the DB and import the data, start the app
/usr/work/import-data.sh & /opt/mssql/bin/sqlservr