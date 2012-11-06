# Hello World

*This is the obligatory Hello World tutorial.*

In this tutorial, we'll be writing a simple application to make sure we have Wheels installed properly
and that everything is working as it should. Along the way, you'll get to know some basics about how
applications built on top of Wheels work.

## Testing Your Install

Let's make sure we're all on the same page. I'm going to assume that you've already
[downloaded the latest version of Wheels][1] and have it installed on your system. If you haven't done
that, stop and read the [Installation][2] chapter and get everything setup. It's okay, this web page
will wait for you.

Okay, so you have Wheels installed and can see the Wheels "Congratulations!" page as shown in
_Figure 1_ below. That wasn't that hard now, was it?

<img src="../assets/images/hello-world/wheels-1.0-congratulations-screen.jpg?raw=true" alt="If everything's set up properly, you should see a &quot;Welcome to Wheels&quot; screen on your new Wheels site." />

**Figure 1: Wheels congratulations screen.**

## Hello World: Your First Wheels App

Okay, let's get to some example code. We know that you've been dying to get your hands on some code!

To continue with programming tutorial tradition, we'll create the ubiquitous _Hello World!_
application. But to keep things interesting, let's add a little Wheels magic along the way.

### Setting up the Controller

Let's create a controller from scratch to illustrate how easy it is to set up a controller and plug it
into the Wheels framework.

First, create a file called `Say.cfc` in the controllers directory and add the code below to the file.

	<cfcomponent extends="Controller">
	</cfcomponent>

Congratulations, you just created your first Wheels controller! What does this controller do, you might
ask? Well, to be honest, not much. It has no functions defined so it doesn't add any new functionality
to our Wheels application. But because it extends the base `Controller` component, it inherits quite a
bit of powerful functionality and is now tied into our Wheels application.

So what happens if we try to call our new controller right now? Lets take a look! Open your browser and
point your browser to the new controller. Do this by simply entering `http://localhost/index.cfm/say`
in your browser of choice. You may need to enter a different URL, depending on how your web server is
configured. In my case I will be using the host name `cfwheels.1.0` so my URL will look like:

	http://cfwheels.1.0/index.cfm/say

If you did everything right, you will get the Wheels error shown below in _Figure 2_. (Ironic that
getting an error is doing something right, huh? Don't get used to it, buddy!)

<img src="../assets/images/hello-world/wheels-1.0-no-view-error-screen.jpg?raw=true" alt="You should get a ColdFusion error saying, &quot;There is no action named 'index'&quot;" />

**Figure 2: Wheels error after setting up your blank say controller.**

The error says "Could not find the view page for the 'index' action in the 'say' controller." Where did
"index" come from? The URL we typed in only specified a controller name but no action. When an action is
not specified in the URL, Wheels assumes that we want the _default action_. Out of the box, the default
action in Wheels is set to `index`. So in our example, Wheels tried to find the `index` action within
the say controller, and it threw an error because it couldn't find its view page.

### Setting up an Action

But let's jump ahead. Now that we have the controller created, let's add an action to it called `hello`.
Change your say controller so it looks like the code block below:

	<cfcomponent extends="Controller">
	
		<cffunction name="hello">
		</cffunction>
	
	</cfcomponent>

As you can see, we created an empty function named `hello`.

Now let's call our new action in the browser and see what we get. To call the `hello` action we simply add
`/hello` to the end of the previous URL that we used to call our say controller:

	http://cfwheels.1.0/say/hello

Once again, we get a Wheels error. Although we have created the controller and added the `hello` action to
it, we haven't created the _view_.

By default, when an action is called, Wheels will look for a view file with the same name as the action.
It then hands off the processing to the view to display the user interface. In our case, Wheels tried to
find a view file for our `say/hello` action and couldn't find one.

Let's remedy the situation and create a view file. View files are simple CFML pages that handle the output
of our application. In most cases, views will return HTML code to the brower. By default, the view files
will have the same name as our controller actions and will be grouped into a directory under the `views`
directory. This new directory will have the same name as our controller.

Find the `views` directory in the root of your Wheels installation. There will be a few directories and
files in there already. For now, we need to create a new directory in the `views` directory called `say`.
This is the same name as the controller that we created above.

Now inside the `say` directory, create a file called `hello.cfm`. In the `hello.cfm` file, add the
following line of code:

	<h1>Hello World!</h1>

Save your `hello.cfm` file, and let's call our `say/hello` action once again. You have your first working
Wheels page if your browser looks like _Figure 3_ below.

<img src="../assets/images/hello-world/wheels-1.0-hello-world-screen.jpg?raw=true" alt="The correctly working application will show a Header 1 with the word &quot;Hello!&quot;" />

**Figure 3: Your first working Wheels action.**

You have just created your first functional Wheels page, albeit it is a very simple one. Pat yourself on
the back, go grab a snack, and when you're ready, let's go on and extend the functionality of our
_Hello World!_ application a little more.

Oh, and by the way, if you think this was a lot of work just for creating one page then you should know
that you can actually delete the entire `Say.cfc` file and this will still work. (As long as the
`views/say/hello.cfm` file is still there, Wheels will find it and display it for you regardless of
whether you have a corresponding controller file or not.)

## Adding Dynamic Content to Your View

We will add some simple dynamic content to our `hello` action and add a second action to the application.
We'll then use some Wheels code to tie the 2 actions together. Let's get get to it!

### The Dynamic Content

The first thing we are going to do is to add some dynamic content to our `say/hello` action. Modify your
say controller so it looks like the code block below:

	<cfcomponent extends="Controller">
		
		<cffunction name="hello">
			<cfset time = Now()>
		</cffunction>
	
	</cfcomponent>

All we are doing here is creating a variable called `time` and setting its value to the current server
time using the basic ColdFusion `Now()` function. When we do this, the variable becomes immediately
available to our view code.

Why not just set up this value directly in the view? If you think about it, maybe the logic behind the
value of `time` may eventually change. What if eventually we want to display its value based on the
user's time zone? What if later we decide to pull it from a web service instead? Remember, the
controller is supposed to coordinate all of the data and business logic, not the view.

### Displaying the Dynamic Content

Next, we will modify our `say/hello.cfm` view file so that it looks like the code block below. When we
do this, the value will be displayed in the browser.

	<h1>Hello World!</h1>
	<p>Current time: <cfoutput>#time#</cfoutput></p>

Now call your `say/hello` action again in your browser. Your browser should look like _Figure 4_
below.

<img src="../assets/images/hello-world/wheels-1.0-hello-world-dynamic-screen.jpg?raw=true" alt="Your application will now display the &quot;Hello&quot; message with the current date and time." />

**Figure 4: Hello World with the current date and time.**

This simple example showed that any dynamic content created in a controller action is available to the
corresponding view file. In our application, we created a `time` variable in the `say/hello`
controller action and display that variable in our `say/hello.cfm` view file.

### Adding a Second Action: Goodbye

Now we will expand the functionality of our application once again by adding a second action to our
`say` controller. If you feel adventurous, go ahead and add a `goodbye` action to the `say` controller
on your own, then create a `goodbye.cfm` view file that displays a "Goodbye" message to the user. If
you're not feeling that adventurous, we'll quickly go step by step.

First, modify the the `say` controller file so that it looks like the code block below.

	<cfcomponent extends="Controller">
	
		<cffunction name="hello">
			<cfset time = Now()>
		</cffunction>
		
		<cffunction name="goodbye">
		</cffunction>
	
	</cfcomponent>

Now go to the `views/say` directory and create a `goodbye.cfm` page.

Add the following code to the `goodbye.cfm` page and save it.

	<h1>Goodbye World!</h1>

If we did everything right, we should be able to call the new say/goodbye action using the following
URL:

	http://cfwheels.1.0/index.cfm/say/goodbye

Your browser should look like _Figure 5_ below:

<img src="../assets/images/hello-world/wheels-1.0-goodbye-world-screen.jpg?raw=true" alt="Your browser should display a Header 1 with the text &quot;Goodbye&quot;" />

**Figure 5: Your new `goodbye` action.**

### Linking to Other Actions

Now let's link our two actions together. We will do this by adding a link to the bottom of each page
so that it calls the other page.

#### Linking Hello to Goodbye

Open the `say/hello.cfm` view file. We are going to add a line of code to the end of this file so our
`say/hello.cfm` view file looks like the code block below:

	<h1>Hello World!</h1>
	<p>Current time: <cfoutput>#time#</cfoutput></p>
	<p>Time to say <cfoutput>#linkTo(text="goodbye", action="goodbye")#?</cfoutput></p>

The [`linkTo()`][3] function is a built-in Wheels function. In this case, we are passing 2 named
parameters to it. The first parameter, `text`, is the text that will be displayed in the hyperlink.
The second parameter, `action`, defines the action to point the link to. By using this built-in
function, your application's main URL may change, and even controllers and actions may get shifted
around, but you won't suffer from the dreaded dead link. Wheels will always create a valid link for
you as long as you configure it correctly when you make infrastructure changes to your application.

Once you have added the additional line of code to the end of the `say/hello.cfm` view file, save your
file and call the `say/hello` action from your browser. Your browser should look like _Figure 6_ below.

<img src="../assets/images/hello-world/wheels-1.0-hello-world-linked-screen.jpg?raw=true" alt="Your application should now display a goodbye link." />

**Figure 6: Your `say/hello` action with a link to the `goodbye` action.**

You can see that Wheels created a link for us and added an appropriate URL for the `say/goodbye`
action to the link.

#### Linking Goodbye to Hello

Let's complete our little app and add a corresponding link to the bottom of our `say/goodbye.cfm`
view page.

Open your `say/goodbye.cfm` view page and modify it so it looks like the code block below.

	<h1>Goodbye World!</h1>
	<p>Time to say <cfoutput>#linkTo(text="hello", action="hello")#?</cfoutput></p>

If you now call the `say/goodbye` action in your browser, your browser should look like _Figure 7_
below.

<img src="../assets/images/hello-world/wheels-1.0-goodbye-world-linked-screen.jpg?raw=true" alt="Your Goodbye page should now have a link to the Hello page." />

**Figure 7: Your `say/goodbye` action with a link to the `hello` action.**

## Much More to Learn

You now know enough to be dangerous with Wheels. Look out! But there are many more powerful features
to cover so browse over to some of the other chapters. We think you will enjoy it.

[1]: http://cfwheels.org/download
[2]: 03%20Installation.md
[3]: ../Wheels%20API/linkTo.md
