---
description: >-
  A quick tutorial that demonstrates how quickly you can get database
  connectivity up and running with CFWheels.
---

# Beginner Tutorial: Hello Database

CFWheels's built in model provides your application with some simple and powerful functionality for interacting with databases. To get started, you will make some simple configurations, call some functions within your controllers, and that's it. Best yet, you will rarely ever need to write SQL code to get those redundant CRUD tasks out of the way.

### Our Sample Application: User Management

We'll learn by building part of a sample user management application. This tutorial will teach you the basics of setting up a resource that interacts with the CFWheels ORM.

{% hint style="info" %}
#### Download source code

You can download all the source code for this sample application from [https://github.com/dhgassoc/Cfwheels-Beginner-Tutorial-Hello-Database](https://github.com/dhgassoc/Cfwheels-Beginner-Tutorial-Hello-Database)
{% endhint %}

### Setting up the Data Source

By default, CFWheels will connect to a data source that has the same name as the folder containing your application. So if your application is in a folder called `C:\websites\mysite\blog\`, then it will connect to a data source named `blog`.

To change this default behavior, open the file at `config/settings.cfm`. In a fresh install of CFWheels, you'll see some commented-out lines of code that read as such:

{% code title="config/settings.cfm" %}
```html
<cfscript>
    // Use this file to configure your application.
    // You can also use the environment specific files (e.g. /config/production/settings.cfm) to override settings set here.
    // Don't forget to issue a reload request (e.g. reload=true) after making changes.
    // See http://docs.cfwheels.org/docs/configuration-and-defaults for more info.
    // If you leave the settings below commented out, CFWheels will set the data source name to the same name as the folder the application resides in.
    // set(dataSourceName="");
    // set(dataSourceUserName="");
    // set(dataSourcePassword="");
</cfscript>
```
{% endcode %}

Uncomment the lines that tell CFWheels what it needs to know about the data source and provide the appropriate values. This may include values for `dataSourceName`, `dataSourceUserName`, and `dataSourcePassword`.

{% code title="config/settings.cfm" %}
```warpscript
set(dataSourceName="back2thefuture");
// set(dataSourceUserName="marty");
// set(dataSourcePassword="mcfly");
```
{% endcode %}

### Our Sample Data Structure

CFWheels supports MySQL, SQL Server, PostgreSQL, and H2. It doesn't matter which DBMS you use for this tutorial; we will all be writing the same CFML code to interact with the database. CFWheels does everything behind the scenes that needs to be done to work with each DBMS.

That said, here's a quick look at a table that you'll need in your database, named `users`:

| Column Name | Data Type    | Extra          |
| ----------- | ------------ | -------------- |
| id          | int          | auto increment |
| name        | varchar(100) |                |
| email       | varchar(255) |                |
| password    | varchar(15)  |                |

Note a couple things about this `users` table:

1. The table name is plural.
2. The table has an auto-incrementing primary key named `id`.

These are database [conventions](https://guides.cfwheels.org/docs/conventions) used by CFWheels. This framework strongly encourages that everyone follow _convention over configuration_. That way everyone is doing things mostly the same way, leading to less maintenance and training headaches down the road.

Fortunately, there are ways of going outside of these conventions when you really need it. But let's learn the conventional way first. Sometimes you need to learn the rules before you can know how to break them.

### Creating Routes for the users Resource

Next, open the file at `config/routes.cfm`. You will see contents similar to this:

{% code title="config/routes.cfm" %}
```javascript
mapper()
    .wildcard()
    .root(to="wheels##wheels", method="get")
.end();
```
{% endcode %}

We are going to create a section of our application for listing, creating, updating, and deleting user records. In CFWheels routing, this requires a plural resource, which we'll name `users`.

Because a `users` resource is more specific than the "generic" routes provided by CFWheels, we'll list it first in the chain of mapper method calls:

{% code title="config/routes.cfm" %}
```javascript
mapper()
    .resources("users")
    .wildcard()
    .root(to="wheels##wheels", method="get")
.end();
```
{% endcode %}

This will create URL endpoints for creating, reading, updating, and deleting user records:

| Name     | Method | URL Path          | Description                                      |
| -------- | ------ | ----------------- | ------------------------------------------------ |
| users    | GET    | /users            | Lists users                                      |
| newUsers | GET    | /users/new        | Display a form for creating a user record        |
| users    | POST   | /users            | Form posts a new user record to be created       |
| editUser | GET    | /users/\[id]/edit | Displays a form for editing a user record        |
| user     | PATCH  | /users/\[id]      | Form posts an existing user record to be updated |
| user     | DELETE | /users/\[id]      | Deletes a user record                            |

