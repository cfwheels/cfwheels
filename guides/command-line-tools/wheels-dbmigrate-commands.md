# wheels dbmigrate - commands

These are the commands in the `wheels dbmigrate` namespace. They allow you to manipulate the
database structure and script the changes. This makes is easy to share your changes with
coworkers, check them into source control, or apply them automatically when you deploy your
code to production.

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
