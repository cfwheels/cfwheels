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

## `wheels scaffold`

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
