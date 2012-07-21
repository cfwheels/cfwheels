# Reading Records

*Returning records from your database tables as objects or queries.*

Reading records from your database typically involves using one of the 3 finder methods available in 
Wheels: `findByKey()`, `findOne()`, and `findAll()`.

The first 2 of these, (`findByKey()` and `findOne()`), return an object to you, while the last one 
(`findAll()`) returns the result from a `cfquery` tag.

## Fetching a Row by Primary Key Value

Let's start by looking at the simplest of the finder methods, `findByKey()`. This method takes one 
argument: the primary key (or several keys if you're using composite keys) of the record you want to get.

If the record exists, it is returned to you as an object. If not, Wheels will return the boolean value 
`false`.

In the following example, we assume that the `params.key` variable has been created from the URL (for 
example an URL such as `http://localhost/blog/viewauthor/7`).

In your controller:

	<cfset author = model("author").findByKey(params.key)>
	<cfif NOT IsObject(author)>  
		<cfset flashInsert(message="Author #params.key# was not found")>
		<cfset redirectTo(back=true)>
	</cfif>

In your view:

	<cfoutput>Hello, #author.firstName# #author.lastName#!</cfoutput>

## Fetching a Row by a Value Other Than the Primary Key

Often, you'll find yourself wanting to get a record (or many) based on a criteria other than just the 
primary key value though.

As an example, let's say that you want to get the last order made by a customer. You can achieve this by 
using the `findOne()` method like so:

	<cfset anOrder = model("order").findOne(order="datePurchased DESC")>

In this case, `findOne()` will force the `maxRows` argument of the `cfquery` tag to `1`. Because you're 
specifically asking to get one record from the database, Wheels will return this as an object.

## Fetching Multiple Rows

You can use `findAll()` when you are asking to get one or more records from the database. Wheels will 
return this as a `cfquery` result (which could be empty if nothing was found based on your criteria).


## Arguments for `findOne()` and `findAll()`

Besides the difference in the default return type, `findOne()` and `findAll()` accept the same 
arguments. Let's have a closer look at these arguments.

### `select` Argument

This maps to the `SELECT` clause of the SQL statement.

Wheels is pretty smart when it comes to figuring out what to select from the database table(s). For 
example, if nothing is passed in to the `select` argument, Wheels will assume that you want all columns 
returned and create a `SELECT` clause looking something like this:

	artists.id,artists.name

As you can see, Wheels knows that the `artist` model is mapped to the `artists` table and will prepend 
the table name to the column names accordingly.

If you have mapped columns to a different property name in your application, Wheels will take this into 
account as well. The end result then could look like this:

	artists.id,artists.fname AS firstName

If you select from more than one table (see the `include` argument below) and there are ambiguous column 
names, Wheels will sort this out for you by prepending the model name to the column name.

Let's say you have a column called `name` in both the `artists` and `albums` tables. The `SELECT` clause 
will be created like this:

	artists.name,albums.name AS albumName

If you use the `include` argument a lot, you will love this feature as it saves a lot of typing.

If you don't want to return all properties, you can override this behavior by passing in a list of the 
properties you want returned.

If you want to take full control over the `SELECT` clause, you can do so by specifying the table names 
(i.e. `author.firstName`) in the `select` argument or by using alias names (i.e. `firstname AS 
firstName`). If Wheels comes across the use of any of these techniques, it will assume you know what 
you're doing and pass on the `select` argument straight to the `SELECT` clause with no changes.

A tip is to turn on debugging when you're learning Wheels so you can get a good understanding of how 
Wheels creates the SQL statements.

### `where` Argument

This maps to the `WHERE` clause of the SQL statement. Wheels will also convert all your input to 
`cfqueryparam` tags for you automatically.

There are some limitations to what you can use in the `where` argument, but the following SQL will work: 
`=`, `!=`, `<>`, `<`, `<=`, `>`, `>=`, `LIKE`, `NOT LIKE`, `IN`, `NOT IN`, `IS NULL`, `IS NOT NULL`, 
`AND`, and `OR`. (Note that it's a requirement to write SQL keywords in upper case.) In addition to 
this, you can use parentheses to group conditional SQL statements together.

It's worth mentioning that although wheels does not support the `BETWEEN` operator, you can get around 
this by using `>=` and `<=`.

Example:

	<cfset items = model("item").findAll(where="price >= 100 AND price <= 500")>

The same goes for `NOT BETWEEN`.

	<cfset items = model("item").findAll(where="price < 100 OR price > 500")>

### `order` Argument

This maps to the `ORDER` clause of the SQL statement. If you don't specify an order at all, none will be 
used (makes sense, eh?). So in those cases, the database engine will decide in what order to return the 
records. Note that it's a requirement to write the SQL keywords `ASC` and `DESC` in upper case.

There is one exception to this. If you paginate the records (by passing in the `page` argument) without 
specifying the order, Wheels will order the results by the primary key column. This is because 
pagination relies on having unique records to order by.

### `include` Argument

This is a powerful feature that you can use if you have set up associations in your models.

If, for example, you have specified that one `author` has many `articles`, then you can return all 
authors and articles in the same call by doing this:

	<cfset bobsArticles = model("author").findAll(where="firstName='Bob'", include="articles")>

### `group` Argument

This maps to the `GROUP BY` clause of the SQL statement and can be used to group the result into one or 
more columns.

Let's suppose we want to query an order items table and get the number of times each items was ordered 
and the average price the item sold for:

	<cfset orderitems = model("orderitems").findAll(
		select="itemid, title, COUNT(*) as counter, AVG(price) as priceAverage",
		group="itemid, title"
	)>

### `maxRows` Argument

This limits the number of records to return. Please note that if you call `findAll()` with `maxRows=1`, 
you will still get a `cfquery` result back and not an object. (We recommend using `findOne()` in this 
case if you want for an object to be returned.)

### `page` and `perPage` Arguments

Set these if you want to get paginated data back.

So if you wanted records 11-20, for example, you write this code:

	<cfset bobsArticles = model("author").findAll(
		where="firstName='Bob'",
		include="articles",
		page=2,
		perPage=10
	)>

### `cache` Argument

This is the number of minutes to cache the query for. This is eventually passed on to the `cachedwithin` 
attribute of the `cfquery` tag.

### `returnAs` Argument

In the beginning of this chapter, we said that you either get a query or an object back depending on the 
method that you call. But you can actually specify the return type so that you get either an object, a 
query, or an array of objects back.

To do this, you use the `returnAs` argument. If you want an array of objects back from a `findAll()` 
call, for example, you can do this:

	<cfset users = model("user").findAll(returnAs="objects")>

On `findOne()` and `findByKey()`, you can set this argument to either `object` or `query`. On the 
`findAll()` method, you can set it to `objects` (note the plural) or `query`.

We recommend sticking to this convention as much as possible because of the CFML engines' slow 
`CreateObject()` function. Be careful when setting `returnAs` to `objects`. You won't want to create a 
lot of objects in your array and slow down your application unless you absolutely need to.