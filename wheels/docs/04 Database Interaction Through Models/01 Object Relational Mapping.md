# Object Relational Mapping

*An overview of Object Relational Mapping (ORM) and how is it used in Wheels. Learn how ORM simplifies 
your database interaction code.*

Mapping objects in your application to records in your database tables is a key concept in Wheels. Let's 
take a look at exactly how this mapping is performed.

## Class and Object Methods

Unlike most other languages, there is no notion of class level (a.k.a. "static") methods in ColdFusion. 
This means that even if you call a method that does not need to use any instance data, you still have to 
create an object first.

In Wheels, we create an object like this.

	<cfset model("author")>

The built-in Wheels `model()` function will return a reference to an `author` object in the 
`application` scope (unless it's the first time you call this function, in which case it will also 
create and store it in the `application` scope).

Once you have the `author` object, you can start calling class methods on it, like `findByKey()`, for 
example. `findByKey()` returns an instance of the object with data from the database record defined by 
the key value that you pass.

Obviously, `author` is just an example here, and you'll use the names of the `.cfc` files you have 
created in the `models` folder.

	<cfset authorClass = model("author")>
	<cfset authorObject = authorClass.findByKey(1)>

For readability, this is usually combined into the following:

	<cfset authorObject = model("author").findByKey(1)>

Now `authorObject` is an instance of the `author` class, and you can call object level methods on it, 
like `update()` and `save()`.

	<cfset authorObject.update(firstName="Joe")>

In this case, the above code updates the `firstName` field of the `author` record with a primary key 
value of `1` to `Joe`.

## Primary Keys

Traditionally in Wheels a primary key is usually named `id`, it increments automatically and it's of the 
`integer` data type. However, Wheels is very flexible in this area. You can setup your primary keys in 
practically any way you want to. You can use _natural keys_ (`varchar`, for example), _composite keys_ 
(having multiple columns as primary keys), and you can name the key(s) whatever you want.

You can also choose whether the database creates the key for you (using auto-incrementation, for 
example) or create them yourself directly in your code.

What's best, Wheels will introspect the database to see what choices you have made and act accordingly.

## Tables and Classes

Wheels comes with a custom built _ORM_. ORM stands for "Object-Relational Mapping" and means that tables 
in your relational database map to classes in your application. The records in your tables map to 
objects of your classes, and the columns in these tables map to properties on the objects.

To create a class in your application that maps to a table in your database, all you need to do is 
create a new class file in your `models` folder and make it extend the `Model.cfc` file.

	<cfcomponent extends="Model">
	</cfcomponent>

If you don't intend to create any custom methods in your class you can actually skip this step and just 
call methods without having a file created, it will work just as well. As your application grows, you'll 
probably want to have your own methods though so remember the `models` folder, that's where they'll go.  

Once you have created the file (or deliberately chosen not to for now) you will have a bunch of methods 
available for you to use that handles reading and writing to the `authors` table. (For the purpose of 
showing some examples, we will assume you have created a file named `Author.cfc`, which will then be 
mapped to the `authors` table in the database).

For example, you can write the following code to get the author with the primary key of `1`, change his 
first name, and save the record back to the database.

	<cfset auth = model("author").findByKey(1)>
	<cfset auth.firstName = "Joe">
	<cfset auth.save()>

This code makes use of the class method `findByKey()`, updates the object property in memory, and then 
saves it back to the database using the object method `save()`. We'll get back to all these methods and 
more later.

### Table and CFC Naming

By default, a table name should be the plural version of the class name so if you have an `Author.cfc` 
class the table name should be `authors`.

To change this behavior you can use the `table()` method. This method call should be placed in the 
`init` method of your class file.

So, for example, if you wanted for your `author` model to map to a table in your database named 
`tbl_authors`, you would add the following code to the `init` method:

	<cfcomponent extends="Model">
		<cffunction name="init">
			<cfset table("tbl_authors")>
		</cffunction>
	</cfcomponent>

## Columns and Properties

Objects in Wheels have properties that correspond to the columns in the table that it maps to. The first 
time (or every time if you're in `design` mode) you call a method on a model, Wheels will reflect on the schema inside the database for the table the class maps to and extract all the column information.

To keep things as simple as possible, there are no _getters_ or _setters_ in Wheels. Instead, all the 
properties are made available in the `this` scope.

If you want to map a specific property to a column with a different name, you can override the Wheels 
mapping by using the `property()` method like this:

	<cfcomponent extends="Model">
		<cffunction name="init">
			<cfset property(name="firstName", column="tbl_auth_f_name")>
		</cffunction>
	</cfcomponent>