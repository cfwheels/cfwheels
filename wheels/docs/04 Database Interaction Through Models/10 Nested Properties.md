# Nested Properties

*Save data in associated model objects through the parent.*

When you're starting out as a Wheels developer, you are probably amazed at the simplicity of a model's 
CRUD methods. But then it all gets quite a bit more complex when you need to update records in multiple 
database tables in a single transaction.

_Nested properties_ in Wheels makes this scenario dead simple. With a configuration using the 
`nestedProperties()` function in your model's `init()` method, you can save changes to that model and 
its associated models in a single call with `save()`, `create()`, or `update()`.

## One-to-One Relationships with Nested Properties

Consider a `user` model that has one `profile`:

	<!--- models/User.cfc --->
	<cfcomponent extends="Model">
	
		<cffunction name="init">
			<cfset hasOne("profile")>
			<cfset nestedProperties(associations="profile")>
		</cffunction>
	
	</cfcomponent>

By adding the call to `nestedProperties()` in the model, you can create both the `user` object and the 
`profile` object in a single call to `create()`.

### Setting up Data for the `user` Form in the Controller

First, in our controller, let's set the data needed for our form:

	<!--- In controllers/User.cfc --->
	<cffunction name="new">
		<cfset var newProfile = model("profile").new()>
		<cfset user = model("user").new(profile=newProfile)>
	</cffunction>

Because our form will also expect an object called `profile` nested within the `user` object, we must 
create a new instance of it and set it as a property in the call to `user.new()`.

Also, because we don't intend on using the particular `newProfile` object set in the first line of the 
action, we can `var` scope it to clearly mark our intentions for its use.

If this were an `edit` action calling an existing object, our call would need to look similar to this:

	<!--- In controllers/User.cfc --->
	<cffunction name="edit">
		<cfset user = model("user").findByKey(key=params.key, include="profile")>
	</cffunction>

Because the form will also expect data set in the `profile` property, you must include that association 
in the finder call with the `include` argument.

### Building a Form for Posting Nested Properties

For this example, our form at `views/users/new.cfm` will end up looking like this:

	#startFormTag(action="create")#
	
		<!--- Data for user model --->
		#textField(label="First Name", objectName="user", property="firstName")#
		#textField(label="Last Name", objectName="user", property="lastName")#
		
		<!--- Data for associated profile model --->
		#textField(label="Twitter Handle", objectName="user", association="profile", property="twitterHandle")#
		#textArea(label="Biography", objectName="user", association="profile", property="bio")#
		
		<div>#submitTag(value="Create")#</div>
	
	#endFormTag()#

Of note are the calls to form helpers for the `profile` model, which contain an extra argument for 
`association`. This argument is available for all object-based form helpers. By using the `association` 
argument, Wheels will name the form field in such a way that the properties for the `profile` will be 
nested within an object in the `user` model.

Take a minute to read that last statement again. OK, let's move on to the action that handles the form 
submission.

### Saving the Object and Its Nested Properties

You may be surprised to find out that our standard `create` action does not change at all from what 
you're used to.

	<!--- In controllers/Users.cfc --->
	<cffunction name="create">
		<cfset user = model("user").new(params.user)>
		<cfif user.save()>
			<cfset flashInsert(success="The user was created successfully.")>
			<cfset redirectTo(controller=params.controller)>
		<cfelse>
			<cfset renderView(action="new")>
		</cfif>
	</cffunction>

When calling `user.save()` in the example above, Wheels takes care of the following:

  * Saves the data passed into the `user` model.
  * Sets a property on `user` called `profile` with the profile data stored in an object.
  * Saves the data passed into that `profile` model.
  * Wraps all calls in a transaction in case validations on any of the objects fail or something wrong 
  happens with the database.

For the edit scenario, this is what our `update` action would look like (which is very similar to 
`create`):

	<!--- In controllers/Users.cfc --->
	<cffunction name="update">
		<cfset user = model("user").findByKey(params.user.id)>
		<cfif user.update(params.user)>
			<cfset flashInsert(success="The user was updated successfully.")>
			<cfset redirectTo(action="edit")>
		<cfelse>
			<cfset renderView(action="edit")>
		</cfif>
	</cffunction>

## One-to-Many Relationships with Nested Properties

Nested properties work with one-to-many associations as well, except now the nested properties will 
contain an array of objects instead of a single one.

In the `user` model, let's add an association called `addresses` and also enable it as nested properties.

	<!--- models/User.cfc --->
	<cfcomponent extends="Model">
	
		<cffunction name="init">
			<cfset hasOne("profile")>
			<cfset hasMany("addresses")>
			<cfset nestedProperties(associations="profile,addresses", allowDelete=true)>
		</cffunction>
	
	</cfcomponent>

In this example, we have added the `addresses` association to the call to `nestedProperties()`.

### Setting up Data for the `user` Form in the Controller

Setting up data for the form is similar to the one-to-one scenario, but this time the form will expect 
an array of objects for the nested properties instead of a single object.

In this example, we'll just put one new `address` in the array.

	<!--- In controllers/Users.cfc --->
	<cffunction name="new">
		<cfset var newAddresses = [ model("address").new() ]>
		<cfset user = model("user").new(addresses=newAddresses)>
	</cffunction>

In the edit scenario, we just need to remember to call the `include` argument to include the array of 
addresses saved for the particular `user`:

	<!--- In controllers/Users.cfc --->
	<cffunction name="edit">
		<cfset user = model("user").findByKey(key=params.key, include="addresses")>
	</cffunction>

### Building the Form for the One-to-Many Association

This time, we'll add a section for addresses on our form:

	#startFormTag(action="create")#
	
		<!--- Data for `user` model --->
		<fieldset>
			<legend>User</legend>
			
			#textField(label="First Name", objectName="user", property="firstName")#
			#textField(label="Last Name", objectName="user", property="lastName")#
		</fieldset>
		
		<!--- Data for `address` models --->
		<fieldset>
			<legend>Addresses</legend>
			
			<div id="addresses">
				#includePartial(user.addresses)#
			</div>
		</fieldset>
		
		<div>#submitTag(value="Create")#</div>
		
	#endFormTag()#

In this case, you'll see that the form for `addresses` is broken into a partial. (See the chapter on 
[Partials][1] for more details.) Let's take a look at that partial.

#### The `_address` Partial

Here is the code for the partial at `views/users/_address.cfm`. Wheels will loop through each `address` 
in your nested properties and display this piece of code for each one.

	<div class="address">
		#textField(label="Street", objectName="user", association="addresses", position=arguments.current, property="address1")#
		#textField(label="City", objectName="user", association="addresses", position=arguments.current, property="city")#
		#textField(label="State", objectName="user", association="addresses", position=arguments.current, property="state")#
		#textField(label="Zip", objectName="user", association="addresses", position=arguments.current, property="zip")#
	</div>

Because there can be multiple addresses on the form, the form helpers require an additional argument for 
`position`. Without having a unique position identifier for each `address`, Wheels would have no way of 
understanding which `state` field matches with which particular `address`, for example.

Here, we're passing a value of `arguments.current` for `position`. This value is set automatically by 
Wheels for each iteration through the loop of `addresses`.

### Auto-saving a Collection of Child Objects

Even with a complex form with a number of child objects, Wheels will save all of the data through its 
parent's `save()`, `update()`, or `create()` methods.

Basically, your typical code to save the `user` and its `addresses` is exactly the same as the code 
demonstrated in the _Saving the Object and Its Nested Properties_ section earlier in this chapter.

Writing the action to save the data is clearly the easiest part of this process!

## Transactions are Included by Default

As mentioned earlier, Wheels will automatically wrap your database operations for nested properties in a 
transaction. That way if something goes wrong with any of the operations, the transaction will rollback, 
and you won't end up with incomplete saves.

See the chapter on [Transactions][2] for more details.

## Many-to-Many Relationships with Nested Properties

We all enter the scenario where we have "join tables" where we need to associate models in a 
many-to-many fashion. Wheels makes this pairing of entities simple with some form helpers.

Consider the many-to-many associations related to `customer`s, `publication`s, and `subscription`s, 
straight from the [Associations][3] chapter.

	<!--- models/Customer.cfc --->
	<cfcomponent extends="Model">
	
		<cffunction name="init">
			<cfset hasMany(name="subscriptions", shortcut="publications")>
		</cffunction>
	
	</cfcomponent>

	<!--- models/Publication.cfc --->
	<cfcomponent extends="Model">
	
		<cffunction name="init">
			<cfset hasMany("subscriptions")>
		</cffunction>
	
	</cfcomponent>

	<!--- models/Subscription.cfc --->
	<cfcomponent extends="Model">
	
		<cffunction name="init">
			<cfset belongsTo("customer")>
			<cfset belongsTo("publication")>
		</cffunction>
	
	</cfcomponent>

When it's time to save `customer`s' subscriptions in the `subscriptions` join table, one approach is to 
loop through data submitted by `checkBoxTag()`s from your form, populate `subscription` model objects 
with the data, and call `save()`. This approach is valid, but it is quite cumbersome. Fortunately, there 
is a simpler way.

### Setting up the Nested Properties in the Model

Here is how we would set up the nested properties in the `customer` model for this example:

	<!--- models/Customer.cfc --->
	<cfcomponent extends="Model">
	
		<cffunction name="init">
			<!--- Associations --->
			<cfset hasMany(name="subscriptions", shortcut="publications")>
			<!--- Nested properties --->
			<cfset nestedProperties(associations="subscriptions", allowDelete=true)>
		</cffunction>
	
	</cfcomponent>

### Setting up Data for the `customer` Form in the Controller

Let's define the data needed in an `edit` action in the controller at `controllers/Customers.cfc`.

	<!--- In `controllers/Customers.cfc` --->
	<cffunction name="edit">
		<cfset customer = model("customer").findByKey(key=params.key, include="subscriptions")>
		<cfset publications = model("publication").findAll(order="title")>
	</cffunction>

For the view, we need to pull the `customer` with its associated `subscriptions` included with the 
`include` argument. We also need all of the `publication`s in the system for the user to choose from.

### Building the Many-to-Many Form

We can now build a series of check boxes that will allow the end user choose which `publications` to 
assign to the `customer`.

The view template at `views/customers/edit.cfm` is where the magic happens. In this view, we will have a 
form for editing the `customer` and check boxes for selecting the `customer`'s `subscription`s.

	<cfparam name="customer">
	<cfparam name="publications" type="query">
	
	<cfoutput>
	
	#startFormTag(action="update")#
		<fieldset>
			<legend>Customer</legend>
			
			#textField(label="First Name", objectName="customer", property="firstName")#
			#textField(label="Last Name", objectName="customer", property="lastName")#
		</fieldset>
		
		<fieldset>
			<legend>Subscriptions</legend>
			
			<cfloop query="publications">
				#hasManyCheckBox(label=publications.title, objectName="customer", association="subscriptions", keys="#customer.key()#,#publications.id#")#
			</cfloop>
		</fieldset>
		
		<div>
			#hiddenField(objectName="customer", value="id")#
			#submitTag()#
		</div>
	#endFormTag()#
	
	</cfoutput>

The main point of interest in this example is the `<fieldset>` for Subscriptions, which loops through 
the query of `publications` and uses the `hasManyCheckBox()` form helper. This helper is similar to 
`checkBox()` and `checkBoxTag()`, but it is specifically designed for building form data related by 
associations. (Note that `checkBox()` is primarily designed for columns in your table that store a 
single `true`/`false` value, so that is the big difference.)

Notice that the `objectName` argument passed to `hasManyCheckBox()` is the parent `customer` object and 
the `associations` argument contains the name of the related association. Wheels will build a form 
variable named in a way that the `customer` object is automatically bound to the `subscriptions` 
association.

The `keys` argument accepts the foreign keys that should be associated together in the `subscriptions` 
join table. Note that these keys should be listed in the order that they appear in the database table. 
In this example, the `subscriptions` table in the database contains a composite primary key with columns 
called `customerid` and `publicationid`, in that order. These two fields must be set as a composite primary 
key in the database for this to work.

## How the Form Submission Works

Handling the form submission is the most powerful part of the process, but like all other nested 
properties scenarios, it involves no extra effort on your part.

You'll notice that this example `update` action is fairly standard for a Wheels application:

	<cffunction name="update">
		<!--- Load customer object --->
		<cfset customer = model("customer").findByKey(params.customer.id)>
		<!--- If update is successful, generate success message and redirect back to edit screen --->
		<cfif customer.update(params.customer)>
			<cfset flashInsert(success="#customer.firstName# #customer.lastName# record updated successfully.")>
			<cfset redirectTo(action="edit", key=customer.id)>
		<!--- If update fails, show form with errors --->
		<cfelse>
			<cfset renderView(action="edit")>
		</cfif>
	</cffunction>

In fact, there is nothing special about this. But with the nested properties defined in the model, 
Wheels handles quite a bit when you save the parent `customer` object:

  * Wheels will update the `customers` table with any changes submitted in the Customers `<fieldset>`.
  * Wheels will add and remove records in the `subscriptions` table depending on which check boxes are 
  selected by the user in the Subscriptions `<fieldset>`.
  * All of these database queries will be wrapped in a [Transactions][2]. If any of the above updates 
  don't pass validation or if the database queries fail, the transaction will roll back.

## TODO: Get Deletion Description Back in Where It Makes Sense
## Deleting a Child Object

By passing `allowDelete=true` to the `nestedProperties()` call in the model, you can also delete the 
`user`'s related `profile` by setting a property called `_delete` on it:

	<cfset user.profile._delete = true>
	<cfset user.save()>
	
	<!--- Would output "0" --->
	<cfoutput>
		#user.profile(returnAs="query").RecordCount#
	</cfoutput>

The `allowDelete` argument is optional and defaults to `false`, so you must "opt in" to this capability 
when setting up your nested properties.

[1]: ../05%20Displaying%20Views%20to%20Users/02%20Partials.md
[2]: 14%20Transactions.md
[3]: 09%20Associations.md
