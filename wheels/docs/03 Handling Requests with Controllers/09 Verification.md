# Verification

*Verify the existence and type of variables before allowing for a given controller action to run.*

Verification, through the `verifies()` function, is just a special type of filter that runs before 
actions. With verifications defined in your controller, you can eliminate the need for wrapping your 
entire actions in `<cfif>` blocks checking for the existence and types of variables. You also can limit 
your actions' scopes to specific request types like `post`, `get`, and AJAX requests.

## Using `verifies()` to Enforce Request Types

Let's say that you want to make sure that all requests coming to a page that handles form submissions 
are `post` requests. While you can do this with a filter and the `isPost()` function, it is more 
convenient and DRY to do it with the `verifies()` function.

All that you need to do is add this line to your controller's `init()` function:

	<!--- In the controller --->
	<cffunction name="init">
		<cfset verifies(only="create,update", post=true)>
	</cffunction>

The code above will ensure that all requests coming to the `create` and `update` actions are from form 
submissions. All other requests will be aborted.

There are also boolean arguments for `get` and `ajax` request types.

## Defining a Handler for Failed Verifications

You can also specify different behavior for when the verification fails in a special handler function 
registered with the `handler` argument.

In this example, we register the `incorrectRequestType()` function as the handler:

	<!--- In the controller --->
	<cffunction name="init">
		<cfset verifies(only="create,update", post=true, handler="incorrectRequestType")>
	</cffunction>
	
	<cffunction name="incorrectRequestType">
		<cfset redirectTo(action="accessDenied")>
	</cffunction>

Note that you have to either do a `redirectTo` call or abort the request completely after you've done 
what you wanted to do inside your handler function. If you don't do anything at all and just let the 
function exit on its own, Wheels will redirect the user back to the page they came from. In other words, 
you cannot render any content from inside this function but you can let another function handle that 
part by redirecting to it.

## Enforcing the Existence and Type of Variables

A very convenient and common use of `verifies()` is when you want to make sure that a variables exists 
and is of a certain type; otherwise, you would like for your controller to redirect the user to a 
different page.

Step back in time for a moment and remember how you used to code websites before Wheels. (Yes I know 
those were dark days, but stay with me.)

On your `edit.cfm` page, what you probably did was write some code at the top of that looked like this:

	<cfif !StructKeyExists(form, "userId") OR !IsValid("guid", form.userId)>
		<cflocation url="index.cfm" addToken="false">
	</cfif>

With this snippet of code, you could ensure that any request to the `edit.cfm` had to have the `userId` 
in the `form` scope and that `userId` had to be of type `guid`. If these conditions weren't met, the 
request was redirected to the `index.cfm` page. This was a very tedious but necessary task.

Now let's see how using the `verifies()` function within Wheels improves this:

	<!--- In the controller --->
	<cffunction name="init">
		<cfset verifies(only="edit", post=true, params="userId", paramsTypes="guid", action="index", error="Invalid user ID.")>
	</cffunction>

With that one line of code, Wheels will perform the following checks when a request is made to the 
controller's `edit` action:

  * Make sure that the request is a `post` request.
  * Make sure that the `userId` variables exists in the `params` struct.
  * Make sure that the `params.userId` is of type `guid`.
  * If any of those checks fail, redirect the request to the `index` action and place an error key in the Flash containing the message "Invalid user ID."

All that functionality in only one line of code!

What if you wanted do this for two or more variables? The `params` and `paramsTypes` each accept a list 
so you can include as many variables to check against as you want.

The only thing you need to make sure of is that the number of variables in the `params` list matches the 
number types to check against in the `paramsTypes` list. This also goes for the `session`/`sessionTypes` 
and `cookie`/`cookieTypes` arguments, which check for existence and type in the `session` and `cookie` 
scopes, respectively. 

You can read more in the API documentation for the `verifies()` function.

## Controller Verification vs. Model Object Validation

`verifies()` exists solely to validate _controller_ and _environment level_ variables and is not a 
substitute for [Object Validation][1] in your model.

A basic example of this is to validate params passed through to your controller from routes. Suppose we 
have the following route in our application:

	<cfset addRoute(name="usersAddressesSave", pattern="admin/users/[userid]/addresses/save", controller="userAddresses", action="save")>

In this example, we will want to verify that the `userId` and `address` struct are both present in the 
`params` struct and also that `userId` is of a certain type:

	<cfset verifies(only="save", post=true, params="userId,address", paramsTypes="integer,struct")>

However, verifies should not be used to make sure that values within the `address` struct themselves are 
valid (such as making sure that `address.zipCode` is correct). Because the `address` struct will be 
passed in to the model, the validation will be performed there.

[1]: ../04%20Database%20Interaction%20Through%20Models/11%20Object%20Validation.md