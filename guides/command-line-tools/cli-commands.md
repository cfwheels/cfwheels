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

```
wheels reload [mode]
```

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

This command will completely scaffold a new object. Typically you would run this command to stub out all the CRUD related files and then follow it up with a series of `wheels g property` commands to add the individual fields to the object. This command will:

* Create a model file
* A Default CRUD Controller complete with create/edit/update/delete code
* View files for all those actions
* Associated test stubs
* DB migration file

This command can be run without the server running except the database migration portion because that requires a running database. So if your server is already up and running you can run this command completely including the database migraton portion. Afterwards make sure to run `wheels reload` to reload your application since we just made model changes. If the server isn't running, you can run this command and stub out all the files, then start your server with `server start` and finally migrade the database with `wheels db latest`.

```
wheels scaffold [objectName]
```

| Parameter | Required | Default | Description                        |
| --------- | -------- | ------- | ---------------------------------- |
| Name      | true     |         | Name of the object to scaffold out |

## `wheels destroy`

This command will destroy a given object. This is highly destructive, given the name, so proceed with caution. If you created an object using the `wheels scaffold [objectName]` command, this command is the inverse of that command and will remove all elements created by that command.

This command will destroy the following elements:

* the models definition file
* the controllers definition file
* the view sub folder and all it's contents
* the model test file
* the controller test file
* the views test file
* resouce route configuration

```
wheels destroy [objectName]
```

| Parameter | Required | Default | Description                   |
| --------- | -------- | ------- | ----------------------------- |
| Name      | true     |         | Name of the object to destroy |

## `wheels generate`

The `wheels generate` command is what CommandBox calls a namespace and contains many sub commands beneeth it. It's main purpose is to isolate those sub commands so there is no name collisions. It also has an alias of `wheels g` which allows you to shorten the commands you have to type. However, we have opted to show all the commands with their full names in the list below.

## `wheels generate app-wizard`

Creates a new CFWheels application using our wizard to gather all the necessary information. This is the recommended route to start a new application.

This command will ask for:

* An Application Name (a new directoery will be created with this name)
* Template to use
* A reload Password
* A datasource name
* What local cfengine you want to run
* If using Lucee, do you want to setup a local h2 dev database
* Do you want to initialize the app as a ForgBox module

```
wheels new
wheels g app-wizard
wheels generate app-wizard
```

All these three commands areequivelent and will call the same wizard. The wizard in turn gathers all the required data and passes it all off to the `wheels generate app` command to do all the heavy lifting.

Let's take a look at the wizard pages after issuing the `wheels new` command:

![wheels new - step 1](<../.gitbook/assets/Screen Shot 2022-06-18 at 12.30.34 PM.png>)

You can accept the name offered or change it to whatever name you like. We try to clean up the name and take out special characters and spaces if we need to.

![wheels new - step 2](<../.gitbook/assets/Screen Shot 2022-06-18 at 12.31.01 PM.png>)

You can select a template to use. If you are reading this before CFWheels 2.4 is released you may want to select the Bleeding Edge Base Template.

![wheels new - step 3](<../.gitbook/assets/Screen Shot 2022-06-18 at 12.32.14 PM.png>)

You can set what you want to use as your reload password or accept the default. Please make sure to change this before you go into produciton. Ideally this should be kept out of your source repository by using somethign like the (CFWheels DotEnvSettings Plugin)\[[https://www.forgebox.io/view/cfwheels-dotenvsettings](https://www.forgebox.io/view/cfwheels-dotenvsettings)].

![wheels new - step 4](<../.gitbook/assets/Screen Shot 2022-06-18 at 12.32.43 PM.png>)

The datasource is somethign you'll have to take care of unless you opt to use the H2 Embedded database in a Lucee server. Here you can define the datasource name if you would like to use something different than the application name.

![wheels new - step 5](<../.gitbook/assets/Screen Shot 2022-06-18 at 12.33.18 PM.png>)

In this step you can choose what CF Engine and version to launch. Lucee has an embedded SQL compliant database server called H2. So if you use one of the Lucee options you can specify to use the H2 database as well. Notice the last item allows you to specify the module slug or URI to a CF Engine not on the list.

![wheels new - step 6](<../.gitbook/assets/Screen Shot 2022-06-18 at 12.34.17 PM.png>)

On this step you are asked if you'd like to use the H2 Database, in which case we can set everything up for you, or if you would prefer to use another database engine and will take care of setting up the database yourself.

![wheels new - step 7](<../.gitbook/assets/Screen Shot 2022-06-18 at 12.34.44 PM.png>)

On this last step, you are asked if you want us to include a box.json file so you can eventually submit this to ForgeBox.io for sharing witht he world.

![wheels new - step 8](<../.gitbook/assets/Screen Shot 2022-06-18 at 12.35.09 PM.png>)

This is the confirmation screen that shows all the choices you've made and gives you one last chance to bail out. If you choose to continue, the choices you've made will be sent over to the `wheels g app` command to do the actual app creation.

![wheels new - final screen](<../.gitbook/assets/Screen Shot 2022-06-18 at 12.35.40 PM.png>)

If you opted to continue you'll see a bunch of things scroll across your screen as the various items are downloaded and configured. Eventually you will see this status screen letting you know that everything was installed properly.&#x20;

## `wheels generate app`

Create a blank CFWheels app from one of our app templates or a template using a valid Endpoint ID which can come from ForgeBox, HTTP/S, git, github, etc.

By default an app named MyCFWheelsApp will be created in a sub directoryt call MyCFWheelsApp.

The most basic call...
```
wheels generate app
```

This can be shortened to...
```
wheels g app
```

Here are the basic templates that are available for you that come from ForgeBox
- CFWheels Base Template - Stable (default)
- CFWheels Base Template - Bleeding Edge
- CFWheels Template - HelloWorld
- CFWheels Template - HelloDynamic
- CFWheels Template - HelloPages
- CFWheels Example App
- CFWheels - TodoMVC - HTMX - Demp App

```
wheels create app template=base
```
The template parameter can also be any valid Endpoint ID, which includes a Git repo or HTTP URL pointing to a package. So you can use this to publish your own templates to use to start new projects.

```
wheels create app template=http://site.com/myCustomAppTemplate.zip
```

| Parameter      | Required | Default        | Description                                           |
| -------------- | -------- | -------------- | ----------------------------------------------------- |
| name           | false    | MyCFWheelsApp  | The name of the app you want to create                |
| template       | false    | base template  | The name of the app template to use                   |
| directory      | false    | mycfwheelsapp/ | The directory to create the app in                    |
| reloadPassword | false    | ChangeMe       | The reload passwrod to set for the app                |
| datasourceName | false    | MyCFWheelsApp  | The datasource name to set for the app                |
| cfmlEngine     | false    | Lucee          | The CFML engine to use for the app                    |
| setupH2        | false    | false          | Setup the H2 database for development                 |
| init           | false    | false          | "init" the directory as a package if it isn't already |
| force          | false    | false          | Force installation into an none empty directory       |

## `wheels generate route`

Adds a default resources Route to the routes table. All the normal CRUD routes are automatically added.

```
wheels generate route [objectname]
```

| Parameter  | Required | Default | Description                                         |
| ---------- | -------- | ------- | --------------------------------------------------- |
| objectname | true     |         | The name of the resource to add to the routes table |

## `wheels generate controller`

I generate a controller in the `controllers/` directory. You can either pass in a list of actions to stub out or the standard CRUD methods will be generated.

Create a user controller with full CRUD methods
```
wheels generate controller user
```

Create a user object with just "index" and "customaction" methods
```
wheels generate controller user index,customaction
```

| Parameter  | Required | Default | Description                                                        |
| ---------- | -------- | ------- | ------------------------------------------------------------------ |
| name       | true     |         | Name of the controller to create without the .cfc                  |
| actionList | false    |         | optional list of actions, comma delimited                          |
| directory  | false    |         | if for some reason you don't have your controllers in controllers/ |

## `wheels generate model`

This command generates a model in the `models/` folder and creates the associated DB Table using migrations.

Create "users" table and "User.cfc" in models:
```
wheels generate model user
```

Create just "User.cfc" in models:
```
wheels generate model user false
```

| Parameter  | Required | Default | Description                                                                    |
| ---------- | -------- | ------- | ------------------------------------------------------------------------------ |
| name       | true     |         | Name of the model to create without the .cfc: assumes singluar                 |
| db         | false    |         | Boolean attribute specifying if the database table should be generated as well |

## `wheels generate property`

This command generates a dbmigration file to add a property to an object and scaffold into _form.cfm and show.cfm if they exist (i.e, wheels generate property table columnName columnType).

Create the a string/textField property called firstname on the User model:
```
wheels generate property user firstname
```

Create a boolean/Checkbox property called isActive on the User model with a default of 0:
```
wheels generate property user isActive boolean
```

Create a boolean/Checkbox property called hasActivated on the User model with a default of 1 (i.e, true):
```
wheels generate property user isActive boolean 1
```

 Create a datetime/datetimepicker property called lastloggedin on the User model:
 ```
 wheels generate property user lastloggedin datetime
 ```

 All columnType options:
 biginteger,binary,boolean,date,datetime,decimal,float,integer,string,limit,text,time,timestamp,uuid

| Parameter  | Required | Default | Description                                                           |
| ---------- | -------- | ------- |---------------------------------------------------------------------- |
| name       | true     |         | Table Name                                                            |
| columnName | false    |         | Name of Column                                                        |
| columnType | false    |         | Type of Column on of biginteger, binary, boolean, date, datetime, decimal, float,integer, string, limit, text, time, timestamp, uuid    |
| default    | false    |         | Default Value for column                                              |
| null       | false    |         | Whether to allow null values |
| limit      | false    |         | character or integer size limit for column |
| precision  | false    |         | ision value for decimal columns, i.e. number of digits the column can hold |
| scale      | false    |         | scale value for decimal columns, i.e. number of digits that can be placed to the right of the decimal point (must be less than or equal to precision) |

## `wheels generate view`

This command generates a view file in the `views/` direcotry when specifying the object name and the action. If a directory for the object does not exist a subdirectory will be created in the `views/` directory and the action NAME.cfm file place into it.

 Create a default file called show.cfm without a template
 ```
 wheels generate view user show
 ```

 Create a default file called show.cfm using the default CRUD template
 ```
 wheels generate view user show crud/show
 ```

| Parameter  | Required | Default | Description                                                           |
| ---------- | -------- | ------- |---------------------------------------------------------------------- |
| objectname | true     |         | View path folder, i.e user                                            |
| name       | true     |         | Name of the file to create, i.e, edit                                 |
| template   | false    |         | template (used in Scaffolding) - options crud/_form,crud/edit,crud/index,crud/new,crud/show |

## `wheels generate test`

This command generates a test stub in `/test/TYPE/NAME.cfc`.

```
wheels generate test model user
```

```
wheels generate test controller users
```

```
wheels generate test view users edit
```

| Parameter | Required | Default | Description |
| ---------- | -------- | ------- | ----------- |
| type | true | | Type of test to generate. Options are model, controller, and view |
| objectname | true | | View path folder or name of object, i.e user |
| name | true | | Name of the action/view |

## `wheels dbmigrate`

This is another namespace with sub commands within it. It also has an alias of `wheels db` which allows you to shorten the command you need to type.

## `wheels dbmigrate info`

This command doesn't take any inputs but simply tries to communiate with the running server and gather information
about your migrations and displays them in a table.

```
wheels dbmigrate info
```

```
❯ wheels db info
/Users/peter/projects/ws/MyApp/wheels/
/Users/peter/projects/ws/MyApp/
Sending: http://127.0.0.1:65429/rewrite.cfm?controller=wheels&action=wheels&view=cli&command=info
Call to bridge was successful.
+----------+------------------------------------------------------------------------+
|          | 20220618145308_cli_create_table_users                                  |
| migrated | 20220618145214_cli_create_table_cars                                   |
| migrated | 20220618142954_cli_remove_table_posts                                  |
+----------+------------------------------------------------------------------------+
+-----------------------------------------+-----------------------------------------+
| Datasource:                       MyApp | Total Migrations:                     3 |
| Database Type:                       H2 | Available Migrations:                 1 |
+-----------------------------------------+-----------------------------------------+
```

From the information presented in the two tables you can see how many migration files are in your
appliation and of those how many have allready been applied and available to be applied. You are
also presented with the datasouce name and database type information.

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
