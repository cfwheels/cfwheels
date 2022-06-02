# Wheels Internal Test Suites

## Directories

- `/src/docker/` - New Docker based standalone test suite (not for CI)
- `/src/docker/sqlserver` - SQL server specific config
- `/src/docker/test-ui` - VueJS Test Suite front end

### How to run

- Ensure docker is installed (beyond the scope of this document)
- Increase Docker's default allocated 2GB memory to about 4GB
- Ensure the following ports are free
	- `60005`
	- `62016`
	- `62018`
	- `3000`
- Navigate to the repo root
- Run `docker-compose up`

### On first run

If this is the first time you've run it, docker will download a lot of stuff, namely:
 - **Commandbox Docker image**, which in turn will get **Lucee5 / ACF2016 / ACF2018** (note, the Commandbox artifacts directory will be created/aliased to `/.Commandbox` for caching, so your images won't have to get them every time your image is rebuilt)
 - **MySQL**
 - **Postgres**
 - **MSSQL 2017**

Once all the images are downloaded (this may take some time), the databases will attempt to start. MySQL/Postgres are fairly simple, using the predefined images which allow for a database to be created directly from docker compose; MSSQL doesn't allow for this annoyingly, so we're actually spinning up a custom image based on the MS one, which allows us to script for the creation of a new database. NB there's a 60 second sleep command in this to ensure SQL Server is actually running before the scripts kick in.

Once the Databases are running, the Commandbox images will start. URL Rewriting is included by default. Note we're not using Commandbox's default, as we need Wheels-specific rewrites

### Datasources
Each database type is added as a datasource via `/src/docker/CFConfig.json` so there are actually 4 datasources *automatically* added to each instance - you don't need to setup `wheelstestdb`.

- `wheelstestdb` - Defaults to mySQL
- `wheelstestdb_mysql` MySQL
- `wheelstestdb_sqlserver` MSSQL
- `wheelstestdb_postgres` Postgres

There's a new `db={{database}}` URL var which switches which datasource is used: the vue UI just appends this string to the test runner.

### What runs on what port

Docker compose basically creates it's own internal network and exposes the various services on different ports. You shouldn't need to connect to the databases directly so those ports aren't exposed to prevent clashes with externally running services

- Lucee 5 on `60005`
- ACF2016 on `62016`
- ACF2018 on `62018`
- Vue Front End on `3000`

### How to actually run the tests

Use the Provided UI at `localhost:3000` for ease. This is just a glorified task runner which hits the respective endpoint for each server as required.

You can also access each CF Engine directly on it's respective port, i.e, to access ACF2016, you just go to `localhost:62016`

### Other useful commands

You can start specific services or rebuild specific services by name. If you just want to start ACF2016 or MSSQL, you can just do

`docker-compose up adobe2016` or `docker-compose up sqlserver`

Likewise if you need to rebuild any of the images, you can do it on an image by image basis if needed:

`docker-compose build testui` *etc*

Which can be quicker than rebuilding everything via `docker-compose build`

#### Known Issues
There's an issue with CORS tests currently, which means those tests are currently commented out

### Rebuilding

You can force a rebuild of the images via `docker-compose up --build` which is useful if you change configuration of any of the Dockerfiles etc. The two adobe engines still take ages to boot this way (just an fyi)
