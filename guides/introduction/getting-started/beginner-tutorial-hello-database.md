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
**Download source code**

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

These are database [conventions](https://guides.cfwheels.org/cfwheels-guides/working-with-cfwheels/conventions) used by CFWheels. This framework strongly encourages that everyone follow _convention over configuration_. That way everyone is doing things mostly the same way, leading to less maintenance and training headaches down the road.

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

* _Name_ is referenced in your code to tell CFWheels where to point forms and links.
* _Method_ is the HTTP verb that CFWheels listens for to match up the request.
* _URL Path_ is the URL that CFWheels listens for to match up the request.

{% hint style="info" %}
**Don't forget to reload**

You will need to reload your application after adding new routes!
{% endhint %}

### Creating Users

First, let's create a simple form for adding a new user to the `users` table. To do this, we will use CFWheels's _form helper_ functions. CFWheels includes a whole range of functions that simplifies all of the tasks that you need to display forms and communicate errors to the user.

#### Creating the Form

Now create a new file in `views/users` called `new.cfm`. This will contain the view code for our simple form.

Next, add these lines of code to the new file:

{% code title="views/users/new.cfm" %}
```markup
<cfoutput>

<h1>New User</h1>

#startFormTag(route="users")#
    <div>
        #textField(objectName="user", property="name", label="Name")#
    </div>

    <div>
        #textField(objectName="user", property="email", label="Email")#
    </div>

    <div>
        #passwordField(
            objectName="user",
            property="password",
            label="Password"
        )#
    </div>

    <div>#submitTag()#</div>
#endFormTag()#

</cfoutput>
```
{% endcode %}

#### Form Helpers

What we've done here is use form helpers to generate all of the form fields necessary for creating a new user in our database. It may feel a little strange using functions to generate form elements, but it will soon become clear why we're doing this. Trust us on this one… you'll love it!

To generate the form tag's `action` attribute, the [startFormTag()](https://api.cfwheels.org/controller.startformtag.html) function takes parameters similar to the [linkTo()](https://api.cfwheels.org/controller.linkto.html)function that we introduced in the Beginner Tutorial: Hello World tutorial. We can pass in `controller, action, key`, and other route- and parameter-defined URLs just like we do with [linkTo()](https://api.cfwheels.org/controller.linkto.html).

To end the form, we use the [endFormTag()](https://api.cfwheels.org/controller.endformtag.html) function. Easy enough.

The [textField()](https://api.cfwheels.org/controller.textfield.html) and [passwordField()](https://api.cfwheels.org/controller.passwordfield.html) helpers are similar. As you probably guessed, they create `<input>` elements with `type="text"` and `type="password"`, respectively. And the [submitTag()](https://api.cfwheels.org/controller.submittag.html) function creates an `<input type="submit" />` element.

One thing you'll notice is the [textField()](https://api.cfwheels.org/controller.textfield.html) and [passwordField()](https://api.cfwheels.org/controller.startformtag.html) functions accept arguments called `objectName` and `property`. As it turns out, this particular view code will throw an error because these functions are expecting an object named `user`. Let's fix that.

#### Supplying the Form with Data

All of the form helper calls in our view specify an `objectName` argument with a reference to a variable named `user`. That means that we need to supply our view code with an object called `user`. Because the controller is responsible for providing the views with data, we'll set it there.

Create a new ColdFusion component at `controllers/Users.cfc`.

As it turns out, our controller needs to provide the view with a blank `user` object (whose instance variable will also be called `user` in this case). In our new action, we will use the [model()](https://api.cfwheels.org/controller.model.html) function to generate a new instance of the user model.

To get a blank set of properties in the model, we'll also call the generated model's [new()](https://api.cfwheels.org/model.new.html) method.

{% code title="controllers/Users.cfc" %}
```javascript
component extends="Controller" {
    function config(){}

    function new() {
        user = model("user").new();
    }
}
```
{% endcode %}

CFWheels will automatically know that we're talking about the `users` database table when we instantiate a `user`model. The convention: database tables are plural and their corresponding CFWheels models are singular.

Why is our model name singular instead of plural? When we're talking about a single record in the `users` database, we represent that with an individual model object. So the `users` table contains many `user` objects. It just works better in conversation.

#### The Generated Form

Now when we run the URL at `http://localhost/users/new`, we'll see the form with the fields that we defined.

The HTML generated by your application will look something like this:

{% code title="/users/new" %}
```markup
<h1>New User</h1>

<form action="/users" method="post">
    <div>
        <label for="user-name">
            Name
            <input id="user-name" type="text" value="" name="user&#x5b;name&#x5d;">
        </label>
    </div>

    <div>
        <label for="user-email">
            Email
            <input id="user-email" type="text" value="" name="user&#x5b;email&#x5d;">
        </label>
    </div>

    <div>
        <label for="user-password">
            Password
            <input id="user-password" type="password" value="" name="user&#x5b;password&#x5d;">
        </label>
    </div>

    <div><input value="Save&#x20;changes" type="submit"></div>
</form>
```
{% endcode %}

So far we have a fairly well-formed, accessible form, without writing a bunch of repetitive markup.

#### Handling the Form Submission

Next, we'll code the `create` action in the controller to handle the form submission and save the new user to the database.

A basic way of doing this is using the model object's [create()](https://api.cfwheels.org/model.create.html) method:

{% code title="controllers/Users.cfc" %}
```javascript
function create() {
    user = model("user").create(params.user);

    redirectTo(
        route="users",
        success="User created successfully."
    );
}
```
{% endcode %}

Because we used the `objectName` argument in the fields of our form, we can access the user data as a struct in the `params` struct.

There are more things that we can do in the `create` action to handle validation, but let's keep it simple in this tutorial.

### Listing Users

Notice that our `create` action above redirects the user to the `users` index route using the [redirectTo()](https://api.cfwheels.org/controller.redirectto.html) function. We'll use this action to list all users in the system with "Edit" links. We'll also provide a link to the "New User" form that we just coded.

First, let's get the data that the listing needs. Create an action named `index` in the `users` controller like so:

{% code title="controllers/Users.cfc" %}
```javascript
function index() {
    users = model("user").findAll(order="name");
}
```
{% endcode %}

This call to the model's [findAll()](https://api.cfwheels.org/model.findall.html) method will return a query object of all users in the system. By using the method's `order` argument, we're also telling the database to order the records by `name`.

In the view at `views/users/index.cfm`, it's as simple as looping through the query and outputting the data

{% code title="views/users/index.cfm" %}
```html
<cfoutput>

<h1>Users</h1>

<p>#linkTo(text="New User", route="newUser")#</p>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Email</th>
            <th colspan="2"></th>
        </tr>
    </thead>
    <tbody>
        <cfloop query="users">
            <tr>
                <td>
                    #EncodeForHtml(users.name)#
                </td>
                <td>
                    #EncodeForHtml(users.email)#
                </td>
                <td>
                    #linkTo(
                        text="Edit",
                        route="editUser",
                        key=users.id,
                        title="Edit #users.name#"
                    )#
                </td>
                <td>
                    #buttonTo(
                        text="Delete",
                        route="user",
                        key=users.id,
                        method="delete",
                        title="Delete #users.name#"
                    )#
                </td>
            </tr>
        </cfloop>
    </tbody>
</table>

</cfoutput>
```
{% endcode %}

{% hint style="info" %}
**When to use `EncodeForHtml`**

You'll see references to `EncodeForHtml` in some of our examples that output data. This helps escape HTML code in data that attackers could use to embed inject harmful JavaScript. (This is commonly referred to as an "XSS attack," short for "Cross-site Scripting attack.")

A rule of thumb: you do not need to use `EncodeForHtml` when passing values into CFWheels helpers like `linkTo`, `buttonTo`, `startFormTag`, `textField`, etc. However, you need to escape data that is displayed directly onto the page without a CFWheels helper.
{% endhint %}

### Editing Users

We'll now show another cool aspect of form helpers by creating a screen for editing users.

#### Coding the Edit Form

You probably noticed in the code listed above that we'll have an action for editing a single `users` record. We used the linkTo() form helper function to add an "Edit" button to the form. This action expects a `key` as well.

Because in the linkTo() form helper function we specified the parameter `key`, Wheels adds this parameter into the URL when generating the route.

Wheels will automatically add the provided 'key' from the URL to the params struct in the controllers edit() function.

Given the provided `key`, we'll have the action load the appropriate `user` object to pass on to the view:

{% code title="controllers/Users.cfc" %}
```javascript
function edit() {
    user = model("user").findByKey(params.key);
}
```
{% endcode %}

The view at `views/user/edit.cfm` looks almost exactly the same as the view for creating a user:

{% code title="views/users/edit.cfm" %}
```html
<cfoutput>

<h1>Edit User #EncodeForHtml(user.name)#</h1>

#startFormTag(route="user", key=user.key(), method="patch")#
    <div>
        #textField(objectName="user", property="name", label="Name")#
    </div>

    <div>
        #textField(objectName="user", property="email", label="Email")#
    </div>

    <div>
        #passwordField(
            objectName="user",
            property="password",
            label="Password"
        )#
    </div>

    <div>#submitTag()#</div>
#endFormTag()#

</cfoutput>
```
{% endcode %}

But an interesting thing happens. Because the form fields are bound to the `user` object via the form helpers' `objectName` arguments, the form will automatically provide default values based on the object's properties.

With the `user` model populated, we'll end up seeing code similar to this:

{% code title="views/users/edit.cfm" %}
```html
<h1>Edit User Homer Simpson</h1>

<form action="/users/1" method="post">
    <input type="hidden" name="_method" value="patch">

    <div>
        <input type="hidden" name="user&#x5b;id&#x5d;" value="15">
    </div>

    <div>
        <label for="user-name">
            Name
            <input
                id="user-name"
                type="text"
                value="Homer Simpson"
                name="user&#x5b;name&#x5d;">
        </label>
    </div>

    <div>
        <label for="user-email">
            Email
            <input
                id="user-email"
                type="text"
                value="homerj@nuclearpower.com"
                name="user&#x5b;email&#x5d;">
        </label>
    </div>

    <div>
        <label for="user-password">
            Password
            <input
                id="user-password"
                type="password"
                value="donuts.mmm"
                name="user&#x5b;password&#x5d;">
        </label>
    </div>

    <div><input value="Save&#x20;changes" type="submit"></div>
</form>
```
{% endcode %}

Pretty cool, huh?

#### Opportunities for Refactoring

There's a lot of repetition in the `new` and `edit` forms. You'd imagine that we could factor out most of this code into a single view file. To keep this tutorial from becoming a book, we'll just continue on knowing that this could be better.

#### Handing the Edit Form Submission

Now we'll create the `update` action. This will be similar to the `create` action, except it will be updating the user object:

{% code title="controllers/Users.cfc" %}
```javascript
function update() {
    user = model("user").findByKey(params.key);
    user.update(params.user);

    redirectTo(
        route="editUser",
        key=user.id,
        success="User updated successfully."
    );
}
```
{% endcode %}

To update the `user`, simply call its [update()](https://api.cfwheels.org/model.update.html) method with the `user` struct passed from the form via `params`. It's that simple.

After the update, we'll add a success message [using the Flash](https://guides.cfwheels.org/cfwheels-guides/handling-requests-with-controllers/using-the-flash) and send the end user back to the edit form in case they want to make more changes.

### Deleting Users

Notice in our listing above that we have a `delete` action. Here's what it would look like:

{% code title="controllers/Users.cfc" %}
```javascript
function delete() {
    user = model("user").findByKey(params.key);
    user.delete();

    redirectTo(
        route="users",
        success="User deleted successfully."
    );
}
```
{% endcode %}

We simply load the user using the model's [findByKey()](https://api.cfwheels.org/model.findbykey.html) method and then call the object's [delete()](https://api.cfwheels.org/model.delete.html) method. That's all there is to it.

### Database Says Hello

We've shown you quite a few of the basics in getting a simple user database up and running. We hope that this has whet your appetite to see some of the power packed into the CFWheels framework. There's plenty more.

Be sure to read on to some of the related chapters listed below to learn more about working with CFWheels's ORM.
