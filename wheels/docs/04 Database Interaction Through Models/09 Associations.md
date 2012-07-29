# Associations

<p class="introduction">Through some simple configuration, Wheels allows you to unlock some powerful 
functionality to use your database tables' relationships in your code.</p>

_Associations_ in Wheels allow you to define the relationships between your database tables. After 
configuring these relationships, doing pesky table joins becomes a trivial task. And like all other ORM 
functions in Wheels, this is done without writing a single line of SQL.

## 3 Types of Associations

In order to set up associations, you only need to remember 3 simple methods. Considering that the human 
brain only reliably remembers up to 7 items, we've left you with a lot of extra space. You're welcome. :)

The association methods should always be called in the `init()` method of a model that relates to 
another model within your application.

### The `belongsTo` Association

If your database table contains a field that is a foreign key to another table, then this is where to 
use the `belongsTo()` function.

If we had a `comments` table that contains a foreign key to the `posts` table called `postid`, then we 
would have this `init()` method within our `comment` model:

	<cfcomponent extends="Model">
	
		<cffunction name="init">
			<cfset belongsTo("post")>
		</cffunction>
	
	</cfcomponent>

### The `hasOne` and `hasMany` Associations

On the other side of the relationship are the "has" functions. As you may have astutely guessed, these 
functions should be used according to the nature of the model relationship.

At this time, you need to be a little eccentric and talk to yourself. Your association should make sense 
in plain English language.

### An example of `hasMany`

So let's consider the `post` / `comment` relationship mentioned above for `belongsTo()`. If we were to 
talk to ourselves, we would say, "A post _has many_ comments." And that's how you should construct your 
`post` model:

	<cfcomponent extends="Model">
	
		<cffunction name="init">
			<cfset hasMany("comments")>
		</cffunction>
	
	</cfcomponent>

You may be a little concerned because our model is called `comment` and not `comments`. No need to 
worry: Wheels understands the need for the plural in conjunction with the `hasMany()` method.

And don't worry about those pesky words in the English language that aren't pluralized by just adding an 
"s" to the end. Wheels is smart enough to know that words like "deer" and "children" are the plurals of 
"deer" and "child," respectively.

### An Example of `hasOne`

The `hasOne()` association is not used as often as the `hasMany()` association, but it has its use 
cases. The most common use case is when you have a large table that you have broken down into two or 
more smaller tables (a.k.a. denormalization) for performance reasons or otherwise.

Let's consider an association between `user` and `profile`. A lot of websites allow you to enter 
required info such as name and email but also allow you to add optional information such as age, salary, 
and so on. These can of course be stored in the same table. But given the fact that so much information 
is optional, it would make sense to have the required info in a `users` table and the optional info in a 
`profiles` table. This gives us a `hasOne()` relationship between these two models: 
"A user _has one_ profile."

In this case, our `profile` model would look like this:

	<cfcomponent extends="Model">
	
		<cffunction name="init">
			<cfset belongsTo("user")>
		</cffunction>
	
	</cfcomponent>

And our `user` model would look like this:

	<cfcomponent extends="Model">
	
		<cffunction name="init">
			<cfset hasOne("profile")>
		</cffunction>
	
	</cfcomponent>

As you can see, you do not pluralize "profile" in this case because there is only one profile.

By the way, as you can see above, the association goes both ways, i.e. a `user` `hasOne()` `profile` 
and a `profile` `belongsTo()` a `user`. Generally speaking, all associations should be set up this way. 
This will give you the fullest API to work with in terms of the methods and arguments that Wheels makes 
available for you.

However, this is not a definite requirement. Wheels associations are completely independent of one 
another, so it's perfectly OK to setup a `hasMany()` association without specifying the related 
`belongsTo()` association.

## Dependencies

A dependency is when an associated model relies on the existence of its parent. In example above, a 
`profile` is dependent on a `user`. When you delete the `user`, you would usually want to delete the 
`profile` as well.

Wheels makes this easy for you. When setting up your association, simply add the argument `dependent` 
with one of the following values, and Wheels will automatically deal with the dependency.

	<!--- Instantiates the `profile` model and calls its `delete` method --->
	<cfset hasOne(name="profile", dependent="delete")>
	
	<!--- Quickly deletes the `profile` without instantiating it --->
	<cfset hasOne(name="profile", dependent="deleteAll")> 
	
	<!--- Sets the `userId` of the `profile` to `NULL` --->
	<cfset hasOne(name="profile", dependent="nullify")>

You can create dependencies on `hasOne()` and `hasMany()` associations, but not `belongsTo()`.

## Database Table Setup

Like everything else in Wheels, we strongly recommend a default naming convention for foreign key 
columns in your database tables.

In this case, the convention is to use the singular name of the related table with `id` appended to the 
end. So to link up our table to the `employees` table, the foreign key column should be named `employeeid`.

### Breaking the Convention

Wheels offers a way to configure your models to break this naming convention, however. This is done by 
using the `foreignKey` argument in your models' `belongsTo()` calls.

Let's pretend that you have a relationship between `author` and `post`, but you didn't use the naming 
convention and instead called the column `post_id`. (You just can't seem to let go of the underscores, 
can you?)

Your `post`'s `init()` method would then need to look like this:

	<cfcomponent extends="Model">
	
		<cffunction name="init">
			<cfset belongsTo(name="author", foreignKey="post_id")>
		</cffunction>
	
	</cfcomponent>

You can keep your underscores if it's your preference or if it's required of your application.

## Leveraging Model Associations in Your Application

Now that we have our associations set up, let's use them to get some data into our applications.

There are a couple ways to join data via associations, which we'll go over now.

### Using the `include` Argument in `findAll`

To join data from related tables in our `findAll()` calls, we simply need to use the `include` argument. 
Let's say that we wanted to include data about the `author` in our `findAll()` call for `post`s.

Here's what that call would look like:

	<cfset posts = model("post").findAll(include="author")>

It's that simple. Wheels will then join the `authors` table automatically so that you can use that data 
along with the data from `posts`.

Note that if you switch the above statement around like this:

	<cfset authors = model("author").findAll(include="posts")>

Then you would need to specify "post" in its plural form, "posts." If you're thinking about when to use 
the singular form and when to use the plural form, just use the one that seems most natural.

If you look at the two examples above, you'll see that in example #1, you're asking for all posts 
including each post's *author* (hence the singular "author"). In example #2, you're asking for all 
authors and all of the *posts* written by each author (hence the plural "posts").

You're not limited to specifying just one association in the `include` argument. You can for example 
return data for authors, posts, and bios in one call like this:

	<cfset authorsPostsAndComments = model("author").findAll(include="posts,bio")>

To include several tables, simply delimit the names of the models with a comma. All models should 
contain related associations, or else you'll get a mountain of repeated data back.

### Joining Tables Through a Chain of Associations

When you need to include tables more than one step away in a chain of joins, you will need to start 
using parenthesis. Look at the following example:

	<cfset commentsPostsAndAuthors = model("comment").findAll(include="post(author)")>

The use of parentheses above tells Wheels to look for an association named `author` on the `post` model 
instead of on the `comment` model. (Looking at the `comment` model is the default behavior when not 
using parenthesis.)

### Handling Column Naming Collisions

There is a minor caveat to this approach. If you have a column in both associated tables with the same 
name, Wheels will pick just one to represent that column.

In order to include both columns, you can override this behavior with the `select` argument in the 
finder functions.

For example, if we had a column named `name` in both your `posts` and `authors` tables, then you could 
use the `select` argument like so:

	<cfset post = model("post").findAll(select="posts.name, authors.id, authors.post_id, authors.name AS authorname", include="author")>

You would need to hard-code all column names that you need in that case, which does remove some of the 
simplicity. There are always trade-offs!

### Using Dynamic Shortcut Methods

A cool feature of Wheels is the ability to use _dynamic shortcut_ methods to work with the models you 
have set up associations for. By dynamic, we mean that the name of the method depends on what name you 
have given the association when you set it up. By shortcut, we mean that the method usually delegates 
the actual processing to another Wheels method but gives you, the developer, an easier way to achieve 
the task (and makes your code more readable in the process). 

As usual, this will make more sense when put into the context of an example. So let's do that right now.

#### Example: Dynamic Shortcut Methods for Posts and Comments

Let's say that you tell Wheels through a `hasMany()` call that a `post` _has many_ `comments`. What 
happens then is that Wheels will enrich the `post` model by adding a bunch of useful methods related to 
this association.

If you wanted to get all comments that have been submitted for a post, you can now call 
`post.comments()`. In the background, Wheels will delegate this to a `findAll()` call with the `where` 
argument set to `postid=#post.id#`.

#### Listing of Dynamic Shortcut Methods

Here are all the methods that are added for the three possible association types.

##### Methods Added by `hasMany`

Given that you have told Wheels that a `post` _has many_ `comments` through a `hasMany()` call, here are 
the methods that will be made available to you on the `post` model.

Replace `XXX` below with the name of the associated model (i.e. `comments` in the case of the example 
that we're using here).

<table>
	<thead>
		<tr>
			<th>Method</th>
			<th>Example</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>`XXX()`</td>
			<td>`post.comments()`</td>
			<td>Returns all comments where the foreign key matches the post's primary key value. Similar to calling `model("comment").findAll(where="postid=#post.id#")`</td>
		</tr>
		<tr>
			<td>`addXXX()`</td>
			<td>`post.addComment(comment)`</td>
			<td>Adds a comment to the post association by setting its foreign key to the post's primary key value. Similar to calling `model("comment").updateByKey(key=comment.id, postid=post.id)`.</td>
		</tr>
		<tr>
			<td>`removeXXX()`</td>
			<td>`post.removeComment(comment)`</td>
			<td>Removes a comment from the post association by setting its foreign key value to `NULL`. Similar to calling `model("comment").updateByKey(key=comment.id, postid="")`.</td>
		</tr>
		<tr>
			<td>`deleteXXX()`</td>
			<td>`post.deleteComment(comment)`</td>
			<td>Deletes the associated comment from the database table. Similar to calling `model("comment").deleteByKey(key=comment.id)`.</td>
		</tr>
		<tr>
			<td>`removeAllXXX()`</td>
			<td>`post.removeAllComments()`</td>
			<td>Removes all comments from the post association by setting their foreign key values to `NULL`. Similar to calling `model("comment").updateAll(postid="", where="postid=#post.id#")`.</td>
		</tr>
		<tr>
			<td>`deleteAllXXX()`</td>
			<td>`post.deleteAllComments()`</td>
			<td>Deletes the associated comments from the database table. Similar to calling `model("comment").deleteAll(where="postid=#post.id#")`.</td>
		</tr>
		<tr>
			<td>`XXXCount()`</td>
			<td>`post.commentCount()`</td>
			<td>Returns the number of associated comments. Similar to calling `model("comment").count(where="postid=#post.id#")`.</td>
		</tr>
		<tr>
			<td>`newXXX()`</td>
			<td>`post.newComment()`</td>
			<td>Creates a new comment object. Similar to calling `model("comment").new(postid=post.id)`.</td>
		</tr>
		<tr>
			<td>`createXXX()`</td>
			<td>`post.createComment()`</td>
			<td>Creates a new comment object and saves it to the database. Similar to calling `model("comment").create(postid=post.id)`.</td>
		</tr>
		<tr>
			<td>`hasXXX()`</td>
			<td>`post.hasComments()`</td>
			<td>Returns `true` if the post has any comments associated with it. Similar to calling `model("comment").exists(where="postid=#post.id#")`.</td>
		</tr>
		<tr>
			<td>`findOneXXX()`</td>
			<td>`post.findOneComment()`</td>
			<td>Returns one of the associated comments. Similar to calling `model("comment").findOne(where="postid=#post.id#")`.</td>
		</tr>
	</tbody>
</table>

##### Methods Added by `hasOne`

The `hasOne()` association adds a few methods as well. Most of them are very similar to the ones added
 by `hasMany()`.

Given that you have told Wheels that an `author` has one `profile` through a `hasOne()` call, here are 
the methods that will be made available to you on the `author` model.

<table>
	<thead>
		<tr>
			<th>Method</th>
			<th>Example</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>`XXX()`</td>
			<td>`author.profile()`
			<td>Returns the profile where the foreign key matches the author's primary key value. Similar to calling `model("profile").findOne(where="authorId=#author.id#")`.</td>
		</tr>
		<tr>
			<td>`setXXX()`</td>
			<td>`author.setProfile(profile)`</td>
			<td>`Sets the profile to be associated with the author by setting its foreign key to the author's primary key value. You can pass in either a `profile` object or the primary key value of a `profile` object to this method. Similar to calling `model("profile").updateByKey(key=profile.id, authorId=author.id)`.
		</tr>
		<tr>
			<td>`removeXXX()`</td>
			<td>`author.removeProfile()`</td>
			<td>Removes the profile from the author association by setting its foreign key to `NULL`. Similar to calling `model("profile").updateOne(where="authorId=#author.id#", authorId="")`.</td>
		</tr>
		<tr>
			<td>`deleteXXX()`</td>
			<td>`author.deleteProfile()`</td>
			<td>Deletes the associated profile from the database table. Similar to calling `model("profile").deleteOne(where="authorId=#author.id#")`.</td>
		</tr>
		<tr>
			<td>`newXXX()`</td>
			<td>`author.newProfile()`</td>
			<td>Creates a new profile object. Similar to calling `model("profile").new(authorId=author.id)`.</td>
		</tr>
		<tr>
			<td>`createXXX()`</td>
			<td>`author.createProfile()`</td>
			<td>Creates a new profile object and saves it to the database. Similar to calling `model("profile").create(authorId=author.id)`.</td>
		</tr>
		<tr>
			<td>`hasXXX()`</td>
			<td>`author.hasProfile()`</td>
			<td>Returns `true` if the author has an associated profile. Similar to calling `model("profile").exists(where="authorId=#author.id#")`.</td>
		</tr>
	</tbody>
</table>

##### Methods Added by `belongsTo`

The `belongsTo()` association adds a couple of methods to your model as well.

Given that you have told Wheels that a `comment` belongs to a `post` through a `belongsTo()` call, here 
are the methods that will be made available to you on the `comment` model.

<table>
	<thead>
		<tr>
			<th>Method</th>
			<th>Example</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>`XXX()`</td>
			<td>`comment.post()`</td>
			<td>Returns the post where the primary key matches the comment's foreign key value. Similar to calling `model("post").findByKey(comment.postId)`.</td>
		</tr>
		<tr>
			<td>`hasXXX()`</td>
			<td>`comment.hasPost()`<td>
			<td>Returns `true` if the comment has a post associated with it. Similar to calling `model("post").exists(comment.postId)`.</td>
		</tr>
	</tbody>
</table>

One general rule for all of the methods above is that you can always supply any argument that is 
accepted by the method that the processing is delegated to. This means that you can, for example, call 
`post.comments(order="createdAt DESC")`, and the `order` argument will be passed along to `findAll()`.

Another rule is that whenever a method accepts an object as its first argument, you also have the option 
of supplying the primary key value instead. This means that `author.setProfile(profile)` will perform 
the same task as `author.setProfile(1)`. (Of course, we're assuming that the `profile` object in this 
example has a primary key value of `1`.)

#### Performance of Dynamic Association Finders

You may be concerned that using a dynamic finder adds yet another database call to your application.

If it makes you feel any better, all calls in your Wheels request that generate the same SQL queries 
will be cached for that request. No need to worry about the performance implications of making multiple 
calls to the same `author.posts()` call in the scenario above, for example.

#### Passing Arguments to Dynamic Shortcut Methods

You can also pass arguments to dynamic shortcut methods where applicable. For example, with the `XXX()` 
method, perhaps we'd want to limit a post's comment listing to just ones created today. We can pass a 
`where` argument similar to what is passed to the `findAll()` function that powers `XXX()` behind the 
scenes.

	<cfset today = DateFormat(Now(), "yyyy-mm-dd")>
	<cfset comments = post.comments(where="createdAt >= '#today# 00:00:00'")>

## Many-to-Many Relationships

We can use the same 3 association functions to set up many-to-many table relationships in our models. It 
follows the same logic as the descriptions mentioned earlier in this chapter, so let's jump right into 
an example.

Let's say that we wanted to set up a relationship between `customers` and `publications`. A customer can 
be subscribed to many publications, and publications can be subscribed to by many customers. In our 
database, this relationship is linked together by a third table called `subscriptions` (sometimes 
called a _bridge entity_ by ERD snobs).

### Setting up the Models

Here are the representative models:

	<!--- Customer.cfc --->
	<cfcomponent extends="Model">
	
		<cffunction name="init">
			<cfset hasMany("subscriptions")>
		</cffunction>
	
	</cfcomponent>

	<!--- Publication.cfc --->
	<cfcomponent extends="Model">
	
		<cffunction name="init">
			<cfset hasMany("subscriptions")>
		</cffunction>
	
	</cfcomponent>

	<!--- Subscription.cfc --->
	<cfcomponent extends="Model">
	
		<cffunction name="init">
			<cfset belongsTo("customer")>
			<cfset belongsTo("publication")>
		</cffunction>
	
	</cfcomponent>

This assumes that there are foreign key columns in `subscriptions` called `customerid` and `publicationid`.

### Using Finders with a Many-to-Many Relationship

At this point, it's still fairly easy to get data from the many-to-many association that we have set up 
above.

We can `include` the related tables from the `subscription` bridge entity to get the same effect:

	<cfset data = model("subscription").findAll(include="customer,publication")>

### Creating a Shortcut for a Many-to-Many Relationship

With the `shortcut` argument to `hasMany()`, you can have Wheels create a dynamic method that lets you 
bypass the join model and instead reference the model on the other end of the many-to-many relationship 
directly.

For our example above, you can alter the `hasMany()` call on the `customer` model to look like this 
instead:

	<cfset hasMany(name="subscriptions", shortcut="publications")>

Now you can get a customer's publications directly by using code like this:

	<cfset cust = model("customer").findByKey(params.key)>
	<cfset pubs = cust.publications()>

This functionality relies on having set up all the appropriate `hasMany()` and `belongsTo()` 
associations in all 3 models (like we have in our example in this chapter).

It also relies on the association names being consistent, but if you have customized your association 
names, you can specify exactly which associations the shortcut method should use with the `through` 
argument.

The `through` argument accepts a list of 2 association names. The first argument is the name of the 
`belongsTo()` association (set in the `subscription` model in this case), and the second argument is the 
`hasMany()` association going back the other way (set in the `publication` model).

Sound complicated? That's another reason to stick to the conventions whenever possible: it keeps things 
simple.

## Are You Still with Us?

As you just read, Wheels offers a ton of functionality to make your life easier in working with 
relational databases. Be sure to give some of these techniques a try in your next Wheels application, 
and you'll be amazed at how little code that you'll need to write to interact with your database.