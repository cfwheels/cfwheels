# Object Callbacks

*Learn how to write code that runs every time a given object is created, updated, or deleted.*

Callbacks in Wheels allow you to have code executed before and/or after certain operations on an object. 
This requires some further explanation, so let's go straight to an example of a real-world application: 
the e-commerce checkout.

## A Real-World Example of Using Callbacks

Let's look at a possible scenario for what happens when a visitor to your imaginary e-commerce website 
submits their credit card details to finalize an order:

  * You create a new `order` object using the `new()` method based on the incoming form parameters.
  * You call the `save()` method on the `order` object, which will cause Wheels to first validate the 
  object and then store it in the database if it passes validation.
  * The next day, you call the `update()` method on the object because the user decided to change the 
  shipping method for the order.
  * Another day passes, and you call the `delete()` method on the object because the visitor called in 
  to cancel the order.

Let's say you want to have the following things executed somewhere in the code:

  * Stripping out dashes from the credit card number to make it as easy as possible for the user to make 
  a purchase.
  * Calculating shipping cost based on the country the package will be sent to.

It's tempting to put this code right in the controller, isn't it? But if you think ahead a little, 
you'll realize that you might build an administrative interface for orders and maybe an express checkout 
as well at some point in the future. You don't want to duplicate all your logic in all these places, do 
you?

Object callbacks to the rescue! By using object callbacks to implement this sort of logic in your model, 
you keep it out of your controllers and ensure your code stays _DRY_ (Don't Repeat Yourself).

Part of the `Order.cfc` model file:

	<cfcomponent extends="Model">
	
		<cffunction name="init">
			<cfset beforeValidationOnCreate("fixCreditCard")>
			<cfset afterValidation("calculateShippingCost")>
		</cffunction>  
		
		<cffunction name="fixCreditCard">
			Code for stripping out dashes in credit card numbers goes here...
		</cffunction>
		
		<cffunction name="calculateShippingCost">
			Code for calculating shipping cost goes here...
		</cffunction>
	
	</cfcomponent>

The above code registers 2 methods to be run at specific points in the life cycle of all objects in your 
application. 

## Registering and Controlling Callbacks

The following 17 functions can be used to register callbacks.

  * `afterNew()` or `afterFind()`
  * `afterInitialization()`
  * `beforeValidation()`
  * `beforeValidationOnCreate()` or `beforeValidationOnUpdate()`
  * `afterValidation()`
  * `afterValidationOnCreate()` or `afterValidationOnUpdate()`
  * `beforeSave()`
  * `beforeCreate()` or `beforeUpdate()`
  * `afterCreate()` or `afterUpdate()`
  * `afterSave()`
  * `beforeDelete()`
  * `afterDelete()`

### Callback Life Cycle

As you can see above, there are a few places (5, to be exact) where one callback or the other will be 
executed, but not both.

The very first possible callback that can take place in an object's life cycle is either `afterNew()` or 
`afterFind()`. The `afterNew()` callback methods are triggered when you create the object yourself for 
the very first time, for example, when using the `new()` method. `afterFind()` is triggered when the 
object is created as a result of fetching a record from the database, for example, when using 
`findByKey()`. (There is some special behavior for this callback type that we'll explain in detail later 
on in this chapter.)

The remaining callbacks get executed depending on whether or not we're running a "create", "update", or 
"delete" operation.

### Breaking a Callback Chain

If you want to completely break the callback chain for an object, you can do so by returning `false` 
from your callback method. (Otherwise, always return `true` or nothing at all.) As an example of 
breaking the callback chain, let's say you have called the `save()` method on a new object and the 
method you've registered with the `beforeCreate()` callback returns `false`. As a result, because the 
method you've registered with the `beforeCreate()` callback will exit the callback chain early by 
returning `false`, no record will be inserted in the database.

### Order of Callbacks

Sometimes you need to run more than one method at a specific point in the object's life cycle. You can 
do this by passing in a list of method names like this:

	<cfset beforeSave("checkSomething,checkSomethingElse")>

When an object is saved in your application, these two callbacks will be executed in the order that you 
registered them. The `checkSomething` method will be executed first, and unless it returns `false`, the 
`checkSomethingElse` method will be executed directly afterwards.

## Special Case #1: `findAll()` and the `afterFind()` Callback

When you read about the `afterFind()` callback above, you may have thought that it must surely only work 
for `findOne()`/`findByKey()` calls but not for `findAll()` because those calls return query result sets 
by default, not objects.

Believe it or not, but callbacks are even triggered on `findAll()`! You do need to write your callback 
code differently to cater to `findAll()` because there will be no `this` scope in the query object. 
Instead of modifying properties in the `this` scope like you normally would, the properties are passed 
in to the callback method via the `arguments` struct.

Does that sound complicated? This example should clear it up a little. Let's show some code to display 
how you can handle setting a `fullName` property on a hypothetical `artist` model:

*Note:* Because all `afterFind()` callbacks run when fetching records from the database, it's a good 
idea to check to make sure that the columns used in the method's logic exist before performing any 
operations. You mostly encounter this issue when using the `select` argument on a finder to limit the 
number of column returned. But no worries! You can use `StructKeyExists()` and perform a simple check to 
make sure that the columns exists in the `arguments` scope.

	<cfcomponent extends="Model" output="false">
	
		<cffunction name="init">
			<cfset afterFind("setFullName")>
		</cffunction>
		
		<cffunction name="setFullName">
			<cfset arguments.fullName = "">
			<cfif StructKeyExists(arguments, "firstName") && StructKeyExists(arguments, "lastName")>
				<cfset arguments.fullName = Trim(arguments.firstName & " " & arguments.lastName)>
			</cfif>
			<cfreturn arguments>
		</cffunction>
	
	</cfcomponent>

In our example model, an artist's name can consist of both a first name and a last name ("John Mayer") 
or just the band / last name ("Abba"). The `setFullName` method handles the logic to concatenate the 
names.

Always remember to return the `arguments` struct, otherwise Wheels won't be able to tell that you 
actually wanted to make any changes to the query.

## Special Case #2: Callbacks and the `updateAll()` and `deleteAll()` Methods

Please note that if you use the `updateAll()` or the `deleteAll()` methods in Wheels, they will not 
instantiate objects by default, and thus any callbacks will be skipped. This is good for performance 
reasons because if you update 1,000 records at once, you probably don't want to run the callbacks on 
each object. Especially not if they involve database calls.

However, if you want to execute all callbacks in those methods as well, all you have to do is pass in 
`instantiate=true` to the `updateAll()`/`deleteAll()` methods.