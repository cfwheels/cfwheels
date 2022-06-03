FROM mcr.microsoft.com/azure-sql-edge:latest

LABEL maintainer "CFWheels Core Team"

# Set environment variables, not to have to write them with docker run command
ENV MSSQL_SA_PASSWORD "x!bsT8t60yo0cTVTPq"
ENV ACCEPT_EULA "Y"
ENV MSSQL_PID "Developer"

# Expose port 1433 in case accesing from other container
EXPOSE 1433
