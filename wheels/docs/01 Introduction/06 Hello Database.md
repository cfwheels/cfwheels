# Hello Database

*A quick tutorial that demonstrates how quickly you can get database connectivity up and running with
Wheels.*

Wheels's built in model provides your application with some simple and powerful functionality for
interacting with databases. To get started, you make some simple configurations, call some functions
within your controllers, and that's it. Best yet, you will rarely ever need to write SQL code to get
those redundant CRUD tasks out of the way.

## Our Sample Application: User Management

We'll learn by building part of a sample user management application. This tutorial will teach you the
basics of interacting with Wheels's ORM.

## Setting up the Data Source

By default, Wheels will connect to a data source that has the same name as the folder containing your
Wheels application. So if your Wheels application is in a folder called
`C:\websites\mysite\blog\`, then it will connect to a data source named `blog`.

To change this default behavior, open the file at `config/settings.cfm`. In a fresh install of Wheels,
you'll see some commented-out lines of code that read as such:

	<!---
		If you leave these settings commented out, Wheels will set the data source name to the same name as the folder the application resides in.
		<cfset set(dataSourceName="")>
		<cfset set(dataSourceUserName="")>
		<cfset set(dataSourcePassword="")> 
	--->

Uncomment the lines that tell Wheels what it needs to know about the data source and provide the
appropriate values. This may include values for `dataSourceName`, `dataSourceUserName`, and
`dataSourcePassword`.

	<cfset set(dataSourceName="myblogapp")>
	<cfset set(dataSourceUserName="marty")>
	<cfset set(dataSourcePassword="mcfly")>

### Our Sample Data Structure

Wheels supports MySQL, SQL Server, PostgreSQL, Oracle, and H2. It doesn't matter which DBMS you use. We
will all be writing the same CFML code to interact with the database. Wheels does everything behind the
scenes that needs to be done to work with each DBMS.

That said, here's a quick look at a table that you'll need in your database:

<table>
	<thead>
		<tr>
			<th>Column Name</th>
			<th>Data Type</th>
			<th>Extra</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>id</td>
			<td>int</td>
			<td>auto increment, primary key</td>
		</tr>
		<tr>
			<td>name</td>
			<td>varchar(100)</td>
			<td></td>
		</tr>
		<tr>
			<td>email</td>
			<td>varchar(255)</td>
			<td></td>
		</tr>
		<tr>
			<td>password</td>
			<td>varchar(255)</td>
			<td></td>
		</tr>
	</tbody>
</table>

Note a couple things about this table:

 1. The table name is plural.
 2. The table has an auto-incrementing primary key named `id`.

These are database _conventions_ used by Wheels. This framework strongly encourages that everyone follow
convention over configuration. That way everyone is doing things mostly the same way, leading to less
maintenance and training headaches down the road.

Fortunately, there are ways of going outside of these conventions when you really need it. But let's
learn the conventional way first. Sometimes you need to learn the rules before you can know how to break
them, cowboy.

## Adding Users

First, let's create a simple form for adding a new user to the `users` table. To do this, we will use
Wheels's _form helper_ functions. Wheels includes a whole range of functions that simplifies all of the
tasks that you need to display forms and communicate errors to the user.

### Creating the Form

Now create a new file in `views/users` called `new.cfm`. This will contain the view code for our simple
form.

Next, add these lines of code to the new file:

	<cfoutput>
	
	<h1>Create a New User</h1>
	
	#startFormTag(action="create")#
	
		<p>#textField(objectName="user", property="name", label="Name")#</p>
		
    	<p>#textField(objectName="user", property="email", label="Email")#</p>
		
    	<p>#passwordField(objectName="user", property="password", label="Password")#</p>
		
    	<p>#submitTag()#</p>
		
	#endFormTag()#
	
	</cfoutput>

#### Form Helpers

What we've done here is use _form helpers_ to generate all of the form fields necessary for creating a
new user in our database. It may feel a little strange using functions to generate form elements, but it
will soon become clear why we're doing this. Trust us on this one... You'll love it!

To generate the form tag's `action` attribute, the [`startFormTag()`][3] function takes parameters similar to
the [`linkTo()`][4] function that we introduced in the [Hello World][1] tutorial. We can pass in `controller`,
`action`, `key`, and other route- and parameter-defined URLs just like we do with [`linkTo()`][4].

To end the form, we use the [`endFormTag()`][5] function. Easy peasy, lemon squeezy.

The [`textField()`][6] and [`passwordField()`][7] helpers are similar. As you probably guessed, they create
`<input>` elements with `type="text"` and `type="password"`, respectively. And the [`submitTag()`][8] function
creates an `<input type="submit" />` element.

One thing you'll notice is the [`textField()`][6] and [`passwordField()`][7] functions accept arguments called
`objectName` and `property`. As it turns out, this particular view code will throw an error because these
functions are expecting an object named `user`. Let's fix that.

### Supplying the Form with Data

We need to supply our view code with an object called `user`. Because the controller is responsible for
providing the views with data, we'll set it there.

Create a new ColdFusion component at `controllers/Users.cfc`. If you're using a case sensitive operating
system like UNIX or Linux, then it is important to name the CFC with a capital letter.

As it turns out, our controller needs to provide the view with a blank `user` object (whose instance
variable will also be called `user` in this case). In our `new` action, we will use the [`model()`][9]
function to generate a new instance of the `user` model.

To get a blank set of properties in the model, we'll also call the generated model's [`new()`][10] method.

	<cfcomponent extends="Controller">
	
		<cffunction name="new">
			<cfset user = model("user").new()>
		</cffunction>
	
	</cfcomponent>

Wheels will automatically know that we're talking about the `users` database table when we instantiate a
`user` model. The convention: database tables are plural and their corresponding Wheels models are
singular.

Why is our model name singular instead of plural? When we're talking about a single record in the `users`
database, we represent that with a model object. So the `users` table contains many `user` objects. It
just works better in conversation.

### The Generated Form

Now when we run the URL at `http://localhost/users/new`, we'll see the form with the fields that we
defined.

The HTML generated by your application will look something like this:

	<h1>Create a New User</h1>
	
	<form action="/users/create" method="post">
		<p><label for="user-name">Name<input id="user-name" type="text" value="" name="user[name]" /></label></p>
		
		<p><label for="user-email">Email<input id="user-email" type="text" value="" name="user[email]" /></label></p>
		
		<p><label for="user-password">Password<input id="user-password" type="password" value="" name="user[password]" /></label></p>
		
		<p><input value="Save changes" type="submit" /></p>
	</form>

So far we have a fairly well-formed, accessible form, without writing a bunch of repetitive markup.

### Handling the Form Submission

Next, we'll code the `create` action in the controller to handle the form submission and save the new
user to the database.

A basic way of doing this is using the model object's [`create()`][11] method:

	<cffunction name="create">
		<cfset user = model("user").create(params.user)>
		<cfset redirectTo(
			action="index",
			success="User #user.name# created successfully."
		)>
	</cffunction>

Because we used the `objectName` argument in the fields of our form, we can access the data as a struct
in the `params` struct.

There are more things that we can do in the `create` action to handle validation, but let's keep it
simple in this tutorial.

## Listing Users

Notice that our `create` action above redirects the user to the `index` action using the [`redirectTo()`][12]
function. We'll use this action to list all `users` in the system with "Edit" links. We'll also provide
a link to the create form that we just coded.

First, let's get the data that the listing needs. Create an action named `index` in the `users`
controller like so:

	<cffunction name="index">
		<cfset users = model("user").findAll(order="name")>
	</cffunction>

This call to the model's [`findAll()`][13] method will return a query object of all `users` in the system. By
using the method's `order` argument, we're also telling the database to order the records by `name`.

In the view at `views/users/index.cfm`, it's as simple as looping through the query and outputting the
data.

	<cfoutput>
	
	<h1>Users</h1>
	
	#flashMessages("success")#
	
	<p>#linkTo(text="+ Add New User", action="new")#</p>
	
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
					<td>#users.name#</td>
					<td>#users.email#</td>
					<td>#linkTo(text="Edit", action="edit", key=users.id, title="Edit #users.name#")#</td>
					<td>#linkTo(text="Delete", action="delete", key=users.id, title="Delete #users.name#", confirm="Are you sure that you want to delete #users.name#?")#</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
	
	</cfoutput>

## Editing Users

We'll now show another cool aspect of form helpers by creating a screen for editing users.

### Coding the Edit Form

You probably noticed in the code listed above that we'll have an action for editing users called `edit`.
This action expects a `key` as well which is passed in the URL by default.

Given the provided `key`, we'll have the action load the appropriate `user` object to pass on to the
view:

	<cffunction name="edit">
		<cfset user = model("user").findByKey(params.key)>
	</cffunction>

The view at `views/user/edit.cfm` looks almost exactly the same as the view for creating a user:

	<cfoutput>
	
	<h1>Edit User #user.name#</h1>
	
	<cfif flashKeyExists("success")>
		<p class="success">#flash("success")#</p>
	</cfif>
	
	#startFormTag(action="update")#
		<p>#hiddenField(objectName="user", property="id")#</p>
		
		<p>#textField(objectName="user", property="name", label="Name")#</p>
		
		<p>#textField(objectName="user", property="email", label="Email")#</p>
		
		<p>#passwordField(objectName="user", property="password", label="Password")#</p>
		
		<p>#submitTag()#</p>
	#endFormTag()#
	
	</cfoutput>

But an interesting thing happens. Because the form fields are bound to the `user` object via the form
helpers' `objectName` arguments, the form will automatically provide default values based on the object's
properties.

With the `user` model populated, we'll end up seeing code similar to this:

	<h1>Edit User Homer Simpson</h1>
	
	<form action="/users/update" method="post">
		<p><input type="hidden" name="user[id]" value="15" /></p>
		
    	<p><label for="user-name">Name<input id="user-name" type="text" value="Homer Simpson" name="user[name]" /></label></p>
		
		<p><label for="user-email">Email<input id="user-email" type="text" value="homerj@nuclearpower.com" name="user[email]" /></label></p>
		
		<p><label for="user-password">Password<input id="user-password" type="password" value="donuts.mmm" name="user[password]" /></label></p>
		
		<p><input value="Save changes" type="submit" /></p>
	</form>

Pretty cool, huh?

### Opportunities for Refactoring

There's a lot of repetition in the `add` and `edit` forms. You'd imagine that we could factor out most of
this code into a single view file. To keep this tutorial from becoming a book, we'll just continue on
knowing that this could be better.

### Handing the Edit Form Submission

Now we'll create the `update` action. This will be similar to the `create` action, except it will be
updating the `user` object:

	<cffunction name="update">
		<cfset user = model("user").findByKey(params.user.id)>
		<cfset user.update(params.user)>
		<cfset redirectTo(
			action="edit",
			key=user.id,
			success="User #user.name# updated successfully."
		)>
	</cffunction>

To update the user, simply call its [`update()`][14] method with the `user` struct passed from the form via
`params`. It's that simple.

After the update, we'll add a success message [Using the Flash][2] and send the end user back to the
edit form in case they want to make more changes.

## Deleting Users

Notice in our listing above that we have a `delete` action. Our [`linkTo()`][4] call has an argument named
`confirm`, which will include some simple JavaScript to pop up a box asking the end user to confirm
the deletion before running the `delete` action.

Here's what our `delete` action would look like:

	<cffunction name="delete">
		<cfset user = model("user").findByKey(params.key)>
		<cfset user.delete()>
		<cfset redirectTo(
			action="index",
			success="#user.name# was successfully deleted."
		)>
	</cffunction>

We simply load the user using the model's [`findByKey()`][15] method and then call the object's [`delete()`][16]
method. That's all there is to it.

## Database Says Hello

We've shown you quite a few of the basics in getting a simple user database up and running. We hope
that this has whet your appetite to see some of the power packed into the ColdFusion on Wheels
framework. There's plenty more.

[1]: 05%20Hello%20World.md
[2]: ../03%20Handling%20Requests%20with%20Controllers/07%20Using%20the%20Flash.md
[3]: ../Wheels%20API/startForm.md
[4]: ../Wheels%20API/linkTo.md
[5]: ../Wheels%20API/endFormTag.md
[6]: ../Wheels%20API/textField.md
[7]: ../Wheels%20API/passwordField.md
[8]: ../Wheels%20API/submitTag.md
[9]: ../Wheels%20API/model.md
[10]: ../Wheels%20API/new.md
[11]: ../Wheels%20API/create.md
[12]: ../Wheels%20API/redirectTo.md
[13]: ../Wheels%20API/findAll.md
[14]: ../Wheels%20API/update.md
[15]: ../Wheels%20API/findByKey.md
[16]: ../Wheels%20API/delete.md