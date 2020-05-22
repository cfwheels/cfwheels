FROM mcr.microsoft.com/mssql/server:2017-latest

LABEL maintainer "CFWheels Core Team"

ENV SA_PASSWORD "x!bsT8t60yo0cTVTPq"
ENV ACCEPT_EULA "Y"

# Create work directory
RUN mkdir -p /usr/work
WORKDIR /usr/work

# Copy all scripts into working directory
COPY ./src/docker/entrypoint.sh /usr/work/
COPY ./src/docker/import-data.sh /usr/work/
COPY ./src/docker/setup.sql /usr/work/

# Grant permissions for the import-data script to be executable
RUN chmod +x /usr/work/import-data.sh
EXPOSE 1433
CMD /bin/bash ./entrypoint.sh
