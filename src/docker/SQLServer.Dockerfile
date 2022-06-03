FROM mcr.microsoft.com/azure-sql-edge:latest

LABEL maintainer "CFWheels Core Team"

# Create work directory
RUN mkdir -p /usr/work
WORKDIR /usr/work

# Copy all scripts into working directory
COPY ./src/docker/sqlserver/entrypoint.sh /usr/work/
COPY ./src/docker/sqlserver/import-data.sh /usr/work/
COPY ./src/docker/sqlserver/setup.sql /usr/work/

USER root

# Grant permissions for the import-data script to be executable
RUN chmod +x /usr/work/entrypoint.sh
RUN chmod +x /usr/work/import-data.sh

# Set environment variables, not to have to write them with docker run command
ENV MSSQL_SA_PASSWORD "x!bsT8t60yo0cTVTPq"
ENV ACCEPT_EULA "Y"
ENV MSSQL_PID "Developer"

# Expose port 1433 in case accesing from other container
EXPOSE 1433

# Run Microsoft SQl Server and initialization script (at the same time)
#CMD /bin/bash ./entrypoint.sh
