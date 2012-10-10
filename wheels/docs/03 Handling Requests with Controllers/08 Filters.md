# Filters

*Stop repeating yourself with the use of before and after filters.*

If you find the need to run a piece of code before or after several controller actions, then you can use 
_filters_ to accomplish this without needing to explicitly call the code inside each action in question.

This is similar to using the `OnRequestStart` / `OnRequestEnd` functions in CFML's `Application.cfc` 
file, with the difference being that filters tie in better with your Wheels controller setup.

## An Example: Authenticating Users

One common thing you might find yourself doing is authenticating users before allowing them to see your 
content. Let's use this scenario to show how to use filters properly. 

You might start out with something like this:

	<cfcomponent extends="Controller">
	
		<cffunction name="secretStuff">
			<cfif NOT StructKeyExists(session, "userId")>
				<cfabort>
			</cfif>
		</cffunction>
		
		<cffunction name="evenMoreSecretStuff">
			<cfif NOT StructKeyExists(session, "userId")>
				<cfabort>
			</cfif>
		</cffunction>
		
	</cfcomponent>

Sure, that works. But you're already starting to repeat yourself in the code. What if the logic of your 
application grows bigger? It could end up looking like this:

	<cfcomponent extends="Controller">
	
		<cffunction name="secretStuff">
			<cfif cgi.remote_addr Does Not Contain "212.55">
				<cfset flashInsert(alert="Sorry, we're not open in that area.")>
				<cfset redirectTo(action="sorry")>
			<cfelseif NOT StructKeyExists(session, "userId")>
				<cfset flashInsert(alert="Please login first.")>
				<cfset redirectTo(action="login")>
			</cfif>
		</cffunction>
		
		<cffunction name="evenMoreSecretStuff">
			<cfif cgi.remote_addr Does Not Contain "212.55">
				<cfset flashInsert(msg="Sorry, we're not open in that area.")>
				<cfset redirectTo(action="sorry")>
			<cfelseif NOT StructKeyExists(session, "userId")>
				<cfset flashInsert(msg="Please login first.")>
				<cfset redirectTo(action="login")>
			</cfif>
		</cffunction>
		
	</cfcomponent>

Ouch! You're now setting yourself up for a maintenance nightmare when you need to update that IP range, 
the messages given to the user, etc. One day, you are bound to miss updating it in one of the places.

As the smart coder that you are, you re-factor this to another method so your code ends up like this:

	<cfcomponent extends="Controller">
	
		<cffunction name="secretStuff">
			<cfset restrictAccess()>
		</cffunction>
		
		<cffunction name="evenMoreSecretStuff">
			<cfset restrictAccess()>
		</cffunction>
		
		<cffunction name="restrictAccess">
			<cfif cgi.remote_addr Does Not Contain "212.55">
				<cfset flashInsert(msg="Sorry, we're not open in that area.")>
				<cfset redirectTo(action="sorry")>
			<cfelseif NOT StructKeyExists(session, "userId")>
				<cfset flashInsert(msg="Please login first!")>
				<cfset redirectTo(action="login")>
			</cfif>
		</cffunction>
		
	</cfcomponent>

Much better! But Wheels can take this process of avoiding repetition one step further. By placing a 
`filters()` call in the `init()` method of the controller, you can tell Wheels what function to run 
before any desired action(s).

	<cfcomponent extends="Controller">
	
		<cffunction name="init">
			<cfset filters("restrictAccess")>
		</cffunction>
		
		<cffunction name="secretStuff">
		</cffunction>
		
		<cffunction name="evenMoreSecretStuff">
		</cffunction>
		
		<cffunction name="restrictAccess">
			<cfif cgi.remote_addr Does Not Contain "212.55">
				<cfset flashInsert(msg="Sorry, we're not open in that area.")>
				<cfset redirectTo(action="sorry")>
			<cfelseif NOT StructKeyExists(session, "userId")>
				<cfset flashInsert(msg="Please login first!")>
				<cfset redirectTo(action="login")>
			</cfif>
		</cffunction>
		
	</cfcomponent>

Besides the advantage of not having to call `restrictAccess()` twice, you have also gained two other 
things:

  * The developer coding `secretStuff()` and `evenMoreSecretStuff()` can now focus on the main tasks of those two actions without having to worry about repetitive logic like authentication.
  * The `init()` method is now starting to act like an overview for the entire controller.

All of these advantages will become much more obvious as your applications grow. This was just a simple 
example to put filters into context.

## Sharing Filters Between Controllers

So far, we've only been dealing with one controller. Unless you're building a very simple website, 
you'll end up with a lot more.

The question then becomes, "Where do I place the `restrictAccess()` function so I can call it from any 
one of my controllers?" The answer is that because all controllers extend `Controller.cfc`, you should 
probably put it there. The `init()` method itself with the call to `filters()` should remain inside your 
individual controllers though.

If you actually want to set the same filters to be run for all controllers, you can go ahead and move 
it to the `Controller.cfc` file's `init()` method as well. Keep in mind that if you want to run the 
`init()` method in the individual controller *and* in `Controller.cfc`, you will need to call 
`super.init()` from the `init()` method of your individual controller.

## 2 Types of Filters

You specify if you want to run the filter function `before` or `after` the controller action with the 
`type` argument to the `filters()` function. It defaults to running it `before` the action.

The previous example with authentication showed a "before filter" in action. The other type of filter 
you can run is an "after filter." As you can tell from the name, an after filter executes code after the 
action has been completed.

This can be used to make some last minute modifications to the HTML before it is sent to the browser 
(think translation, compression, etc.), for example.

If you want to get a copy of the content that will be rendered to the browser from an after filter, you 
can use the `response()` function. To set your changes to the response afterward, use the 
`setResponse()` function.

As an example, let's say that you want to translate the content to Gibberish before sending it to your 
visitor. You can do something like this:

	<cffunction name="init">
		<cfset filters(through="translate", type="after")>
	</cffunction>
	
	<cffunction name="translate">
		<cfset setResponse(gibberify(response()))>
	</cffunction>

## Including and Excluding Actions From Executing Filters

By default, filters apply to all actions in a controller. If that's not what you want, you can tell 
Wheels to only run the filter on the actions you specify with the `only` argument. Or you can tell it to 
run the filter on all actions except the ones you specify with the `except` argument.

Here are some examples showing how to setup filtering in your controllers. Remember, these calls go 
inside the `init()` function of your controller file.

	<cfset filters(through="isLoggedIn,checkIPAddress", except="home,login")>
	<cfset filters(through="translateText", only="termsOfUse", type="after")>

## Passing Arguments to Filter Functions

Sometimes it's useful to be able to pass through arguments to the filters. For one, it can help you 
reduce the amount of functions you need to write. Here's the easy way to pass through an argument:

	<cfset filters(through="authorize", byIP=true)>

Now the `byIP` argument will be available in the `authorize` function.

To help you avoid any clashing of argument names, Wheels also supports passing in the arguments in a 
struct as well:

	<!--- The `through` argument would clash here if it weren't stored within a struct --->
	<cfset args.byIP = true>
	<cfset args.through = true>
	<cfset filters(through="authorize", authorizeArguments=args)>

### Evaluating Filter Arguments at Runtime

Because your controller's `init()` method only runs once per application start, the passing of arguments 
can also be written as expressions to be evaluated at runtime. This is helpful if you need for the value 
to be dynamic from request to request.

For example, this code would only evaluate the value for `request.region` on the very first request, and 
Wheels will store that particular value in memory for all subsequent requests:

	<!--- This is probably not what you intended --->
	<cfset filters(through="authorize", byIP=true, region=request.region)>

To avoid this "hard-coding" of values from request to request, you can instead pass an expression. (The 
double pound signs are necessary to escape dynamic values within the string. We only want to store a 
string representation of the expression to be evaluated.)

	<!--- This is probably more along the lines of what you intended --->
	<cfset filters(through="authorize", byIP=true, region="##request.region##")>

Now instead of evaluating `request.region` inside the `init()` function, it will be done on each 
individual request.

## Low Level Access

If you need to access your filters on a lower level, you can do so by using the `filterChain()` and 
`setFilterChain()` functions. Typically, you'll want to call `filterChain()` to return an array of all 
the filters set on the current controller, make your desired changes, and save it back using the 
`setFilterChain()` function.

Here is an example in our controller's `init()` method where we remove a certain restriction if the 
username is `perdjurner`:

	<cfset var myFilterChain = filterChain()>
	<cfif loggedInUser.username is "perdjurner">
		<cfset StructDelete(myFilterChain, "restrictAccess")>
	</cfif>
	<cfset setFilterChain(myFilterChain)>