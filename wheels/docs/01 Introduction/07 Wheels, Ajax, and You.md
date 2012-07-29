# Wheels, AJAX, and You

*Using Wheels to develop web applications with AJAX features is a breeze. You have several options and
tools at your disposal, which we'll cover in this chapter.*

Wheels was designed to be as lightweight as possible, so this keeps your options fairly open for
developing AJAX features into your application. We will cover two different approaches in this chapter:

 1. "Do it yourself" method with a fresh out-of-the box install of Wheels.
 2. "Let Wheels do it for me" method.

While there are several flavors of JavaScript libraries out there with AJAX support, we will be using the [jQuery framework][1] in this tutorial. Let's assume that you are fairly familiar with the basics of
jQuery and know how to set it up.

For this tutorial, let's create the simplest example of them all: a link that will render a message back
to the user without refreshing the page.

## Approach #1: "Do It Yourself"

In this example, we'll wire up some simple JavaScript code that calls a Wheels action asynchronously. All
of this will be done with basic jQuery code and built-in Wheels functionality.

First, let's create a link to a controller's action in a view file, like so:

	<cfoutput>
	
	<!--- View code --->
	<h1></h1>
	<p></p>
	
	#linkTo(text="Alert me!", controller="say", action="hello", id="alert-button")#
	
	</cfoutput>

That piece of code by itself will work just like you expect it to. When you click the link, you will
load the `hello` action inside the `say` controller.

But let's make it into an asynchronous request. Add this JavaScript (either on the page inside `script`
tags or in a separate `.js` file included via [`javaScriptIncludeTag()`][3]):

	(function($){$(document).ready(function(){
		// Listen to the "click" event of the "alert-button" link and make an AJAX request
		$("#alert-button").click(function(e) {
			$.ajax({ 
				type: "POST", 
				url: $(this).attr("href") + '?format=json', // References "/say/hello?format=json"
				dataType: "json", 
				success: function(response) {
					$("h1").html(response.message);
					$("p").html(response.time);
				} 
			});
			e.preventDefault(); // keeps the normal request from firing
		});
	});})(jQuery);

With that code, we are listening to the `click` event of the hyperlink, which will make an asynchronous request to the `hello` action in the `say` controller. Additionally, the JavaScript call is passing a URL parameter called `format` set to `json`.

Note that the `success` block inserts keys from the `response` into the empty `h1` and `p` blocks in the calling view. (You may have been wondering about those when you saw the first example. Mystery solved.)

The last thing that we need to do is implement the `say/hello` action. Note that the request expects a `dataType` of `JSON`. By default, Wheels controllers only generate HTML responses, but there is an easy
way to generate JSON instead using Wheels's [`provides()`][4] and [`renderWith()`][5] functions:

	<!--- Controller code --->
	<cffunction name="init">
		<cfset provides("html,json")>
	</cffunction>
	
	<cffunction name="hello">
		<!--- Prepare the message for the user --->
		<cfset greeting = {}>
		<cfset greeting["message"] = "Hi there">
		<cfset greeting["time"] = Now()>
		
		<!--- Respond to all requests with `renderWith` --->
		<cfset renderWith(greeting)>
	</cffunction>

In this controller's `init()` method, we use the [`provides()`][4] function to indicate that we want all
actions in the controller to be able to respond with the data in HTML or JSON formats. Note that the
client calling the action can request the type by passing a URL parameter named `format` or by sending
the format in the request header.

The call to [`renderWith()`][5] in the `hello` action takes care of the translation to the requested format.
Our JavaScript is requesting JSON, so Wheels will format the `greeting` struct as JSON automatically and
send it back to the client. If the client requested HTML or the default of none, Wheels will process and
serve the view template at `views/say/hello.cfm`. For more information about [`provides()`][4] and
[`renderWith()`][5], reference the chapter on [Responding with Multiple Formats][2].

Lastly, notice the lines where we're setting `greeting["message"]` and `greeting["time"]`. Due to the case-insensitive nature of ColdFusion, we recommend setting variables to be consumed by JavaScript using bracket notation like that. If you do not use that notation (i.e., `greetings.message` and
`greetings.time` instead), your JavaScript will need to reference those keys from the JSON as `MESSAGE`
and `TIME` (all caps). Unless you like turning caps lock on and off, you can see how that would get
annoying after some time.

Assuming you already included jQuery in your application and you followed the code examples above, you
now have a simple AJAX-powered web application built on Wheels. After clicking that `Alert me!` link,
your `say` controller will respond back to you the serialized message via AJAX. jQuery will parse the
JSON object and populate the `h1` and `p` with the appropriate data.

## Approach #2: Let Wheels Do It for You

This is where things get a lot simpler, Wheels implements a set of Unobtrusive JavaScript methods to facilitate all that work created in the first approach. Let's take a look at how to develop the same functionality as before, but with a lot less code.
	
First, to enable AJAX functionality in your application, you need to include the special JavaScript file located at `wheels/vendor/ajax-adapters/wheels.jquery.js`. Once we have done this, we are ready to start creating our AJAX-powered applications.

Let's add a tiny bit of code to that [`linkTo()`][6] call from the first example:

	<cfoutput>
	
	<!--- View code --->
	<h1></h1>
	<p></p>
	
	#linkTo(text="Alert me!", controller="say", action="hello", remote=true)#
	
	</cfoutput>

Adding the `remote=true` argument is all your need to do right now in this file. Let’s skip to the `Say` controller now:

	<!--- Controller code --->
	<cffunction name="init">
		<cfset provides("html,json,js")>
	</cffunction>
	
	<cffunction name="hello">
		<!--- Prepare the message for the user --->
		<cfset greeting = {}>
		<cfset greeting["message"] = "Hi there">
		<cfset greeting["time"] = Now()>
		
		<!--- Respond to all requests with `renderWith` --->
		<cfset renderWith(greeting)>
	</cffunction>

As you can see, the `hello` action remained exactly the same. The only addition to this file was a new
format in the `init()` function called `js`, which tells the controller to provide JavaScript back to
the view instead of HTML.

Because we added a new format for the controller to provide, we need to make a new view file with the
format `[action].[format].cfm` (in our example, `hello.js.cfm`). Let's create the file at `views/say/hello.js.cfm` and add this code:

	<!--- Remote view code --->
	<cfoutput>
	
	$("h1").html("#greeting.message#");
	$("p").html("#greeting.time#");
	
	</cfoutput>

That's it. With that minimal knowledge of JavaScript, we were able to setup an AJAX-powered Wheels application.

## AJAX in Wheels Explained

Do note that Wheels is smart enough to fallback to HTML if JavaScript is disabled on the user's device,
thanks to its UJS (unobtrusive JavaScript) implementation.

Remember that either of the 2 examples work just fine. You have several ways to accomplish the same goal. Choose the one that fits your style and needs.

[1]: http://jquery.com/
[2]: Responding%20with%20Multiple%20Formats.md
[3]: ../Wheels%20API/javaScriptIncludeTag.md
[4]: ../Wheels%20API/provides.md
[5]: ../Wheels%20API/renderWith.md
[6]: ../Wheels%20API/linkTo.md
