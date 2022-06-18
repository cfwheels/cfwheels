# CLI Commands

The command line tools extends the functionality of CommandBox with some commands specifically designed for CFWheels development. These tools allow you to adopt a more modern workflow and allow you to create and manipulate many CFWheels objects from the command line. By making these tools available in the command line, not only will you be able to speed up your development but you can also utilize these commands in Continous Integration (CI) and Continous Deployment (CD) work flows.

The commands are all listed below. We are working on documenting each command.

## `wheels info`

This command is the most basic of the commands and other than printing some pretty ASCII art it also displays the Current Working Directory, the CommandBox Module Root which can be handy when trying to diagnoise version discrepencies, and lastly the CFWheels version currently installed. The version is determined from a variaty of sources. First and foremost, if there is a `box.json` file in the `wheels/` directory the version is extracted from that `box.json`. Alternatively, if there is no `box.json` file in the `wheels/` directory, we look in `wheels/events/onapplicationstart.cfm` and extract a version number from that file. That is the version number that is displayed on the default congradulations screen by the way. If both of these fail to get us a version number we can use, we ask you to let us know what version of wheels you are using and give you the obtion of generating a `box.json` file. This is handy for bringing old legacy installations under CLI control.

```
 ,-----.,------.,--.   ,--.,--.                   ,--.            ,-----.,--.   ,--.
'  .--./|  .---'|  |   |  ||  ,---.  ,---.  ,---. |  | ,---.     '  .--./|  |   |  |
|  |    |  `--, |  |.'.|  ||  .-.  || .-. :| .-. :|  |(  .-'     |  |    |  |   |  |
'  '--'\|  |`   |   ,'.   ||  | |  |\   --.\   --.|  |.-'  `)    '  '--'\|  '--.|  |
 `-----'`--'    '--'   '--'`--' `--' `----' `----'`--'`----'      `-----'`-----'`--'
=================================== CFWheels CLI ===================================
Current Working Directory: /Users/peter/projects/ws/MyCFWheelsApp/
CommandBox Module Root: /Users/peter/projects/cfwheels-cli/
Current CFWheels Version in this directory: 2.3.0
====================================================================================
```

## `wheels init`

This will attempt to bootstrap an EXISTING wheels app to work with the CLI.

We'll assume the database/datasource exists and the other config options like reloadpassword is all set up. If there's no box.json, create it, and ask for the version number if we can't determine it. If there's no server.json, create it, and ask for cfengine preferences. We'll ignore other templating objects for now, as this will probably be in place too.

## `wheels reload`

This command will reload your CFWheels application. In order for this command to work, your local server needs to be started and running. This command basically issues a request to the running CFWheels application to reload as if you were doing it from your browsers address bar. You will be prompted for your reload password that will be passed to the reload endpoint.

| Parameter | Required | Default     | Description                                                   |
| --------- | -------- | ----------- | ------------------------------------------------------------- |
| mode      | false    | development | possible values development, testing, maintenance, production |

## `wheels test`

This command will call the Test Runner in a running server and return the results. The command can be run from within the directory of the running server or you can specify the server name to run against. Additionally you can specify the test suite to run, possible joices include the running application's test suite (app), the core framework test suite (core), or a particular plugin's test suite by passing in the plugin name.

```
wheels test [type] [servername] [reload] [debug]
```

| Parameter  | Required | Default | Description                                    |
| ---------- | -------- | ------- | ---------------------------------------------- |
| type       | false    | app     | Either Core, App, or the name of the plugin    |
| servername | false    |         | Servername to run the tests against            |
| reload     | false    | false   | Force Reload                                   |
| debug      | false    | false   | Output passing tests as well as failing ones   |
| format     | false    | json    | Force a specific return format for debug       |
| adapter    | false    |         | Attempt to override what dbadapter wheels uses |


## `wheels scaffold`

This command will completely scaffold a new object. Typically you would run this command to stub
out all the CRUD related files and then follow it up with a series of `wheels g property` commands
to add the individual fields to the object. This command will:
- Create a model file
- A Default CRUD Controller complete with create/edit/update/delete code
- View files for all those actions
- Associated test stubs
- DB migration file

This command can be run without the server running except the database migration portion because that requires
a running database. So if your server is already up and running you can run this command completely including the
database migraton portion. Afterwards make sure to run `wheels reload` to reload your application since we just made
model changes. If the server isn't running, you can run this command and stub out all the files, then start your server
with `server start` and finally migrade the database with `wheels db latest`.

 ```
 wheels scaffold [objectName]
 ```

| Parameter | Required | Default | Description                                                   |
| --------- | -------- | ------- | ------------------------------------------------------------- |
| Name      | true     |         | Name of the object to scaffold out                            |

## `wheels destroy`

## `wheels travis`

## `wheels generate`

The `wheels generate` command is what CommandBox calls a namespace and contains many sub commands beneeth it. It also has an alias of `wheels g` which allows you to shorten the commands you have to type. However, we have opted to show all the commands with their full names in the list below.

## `wheels generate app-wizard`

## `wheels generate app`

## `wheels generate route`

## `wheels generate controller`

## `wheels generate model`

## `wheels generate property`

## `wheels generate view`

## `wheels generate test`

## `wheels dbmigrate`

This is another namespace with sub commands within it. It also has an alias of `wheels db` which allows you to shorten the command you need to type.

## `wheels dbmigrate info`

## `wheels dbmigrate latest`

## `wheels dbmigrate up`

## `wheels dbmigrate down`

## `wheels dbmigrate exec`

## `wheels dbmigrate create`

This is another namespace with sub commands within it.

## `wheels dbmigrate create table`

## `wheels dbmigrate create column`

## `wheels dbmigrate create blank`

## `wheels dbmigrate remove`

This is another namespace with sub commands within it.

## `wheels dbmigrate remove table`

## `wheels plugins`

This is another namespace with sub commands within it.

## `wheels plugins list`
