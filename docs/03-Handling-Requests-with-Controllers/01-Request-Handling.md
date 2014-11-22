# Request Handling

###### How Wheels handles an incoming request.

Wheels is quite simple when it comes to figuring out how incoming requests map to code in your application. Let's look at a URL for an e-commerce website and dissect it a little.

But before we do that, a quick introduction to URLs in Wheels is in order.

## A Wheels URL

URLs in Wheels generally look something like this:

```html
http://localhost/index.cfm/shop/products
```

It's also possible that the URLs will look like this in your application:

```html
http://localhost/index.cfm?controller=shop&action=products
```

This happens when your web server does not support the `cgi.path_info` variable.

Regardless of your specific setup, Wheels will try to figure out how to handle the URLs. If Wheels fails to do this properly (i.e. you *know* that your web server supports `cgi.path_info`, but Wheels insists on creating the URLs with the query string format), you can override it by setting `URLRewriting` in `config/settings.cfm` to either `On, Partial`, or `Off`. The line of code should look something like this:

```cfml
<cfset set(URLRewriting="Partial")>
```

"Partial URL Rewriting" is what we call that first URL up there with the `/index.cfm/` format.

In the example URLs used above, `shop` is the name of the controller to call, and `products` is the name of the action to call on that controller.

###Model-View-Controller Explained

Unless you're familiar with the Model-View-Controller pattern, you're probably wondering what controllers and actions are.

Put very simply, a *controller* takes an incoming request and, based on the parameters in the URL, decides what (if any) data to get from the model (which in most cases means your database), and decides which view (which in most cases means a CFML file producing HTML output) to display to the user.

An *action* is an entire process of executing code in the controller, including a view file and rendering the result to the browser. As you will see in the example below, an action usually maps directly to one specific function with the same name in the controller file.

###Creating URLs

Mapping an incoming URL to code is only one side of the equation. You will also need a way to create these URLs. This is done through a variety of different functions like [linkTo()][1] (for creating links), [startFormTag()][2] (for creating forms), and [redirectTo()][3] (for redirecting users), to name a few.

Internally, all of these functions use the same code to create the URL, namely the [URLFor()][4] function. The [URLFor()][4]  function accepts a controller and an action argument, which are what you will use most of the time. It has a lot of other arguments and does some neat stuff (like defaulting to the current controller when you don't specifically pass one in). So check out the documentation for the [URLFor()][4] function for all the details.

By the way, by using URL rewriting in Apache or IIS, you can completely get rid of the `index.cfm` part of the URL so that `http://localhost/index.cfm/shop/products` becomes `http://localhost/shop/products`. You can read more about this in the [URL Rewriting][5] chapter.

For the remainder of this chapter, we'll type out the URLs in this shorter and prettier way.

##A Wheels Page

Let's look a little closer at what happens when Wheels receives this example incoming request.

First, it will create an instance of the `shop` controller (`controllers/Shop.cfc`) and call the function inside it named `products`.

Let's show how the code for the `products` function could look to make it more clear what goes on:

```cfml
<cfcomponent extends="Controller">

    <cffunction name="products">
        <cfset renderPage(controller="shop", action="products")>
    </cffunction>

</cfcomponent>
```

The only thing this does is specify the view page to render using the [renderPage()][6] function.

The [renderPage()][6] function is available to you because the `shop` controller extends the main Wheels `Controller` component. Don't forget to include that `extends` attribute in your `<cfcomponent>` tags as you build your controllers!

So, how does [renderPage()][6] work? Well, it accepts the arguments `controller` and `action` (among others), and, based on these, it will try to include a view file. In our case, the view file is stored at `views/shop/products.cfm`.

You can read the chapter about [Rendering Content][7] for more information about the [renderPage()][6] function.

It's important to note that the [renderPage()][6] function does not cause any controller actions or functions to be executed. It just specifies what view files to get content from. Keep this in mind going forward because it's a common assumption that it does. (Especially when you want to include the view page for another action, it's easy to jump to the incorrect conclusion that the code for that action would also get executed.)

##Wheels Conventions

Because Wheels favors convention over configuration, we can remove a lot of the code in the example above, and it will still work because Wheels will just guess what your intention is. Let's have a quick look at exactly what code can be removed and why.

The first thing Wheels assumes is that if you call [renderPage()][6] without arguments, you want to include the view page for the **current** controller and action.

Therefore, the code above can be changed to:

```cfml
<cfcomponent extends="Controller">

    <cffunction name="products">
        <cfset renderPage()>
    </cffunction>

</cfcomponent>
```

… and it will still work just fine.

Does Wheels assume anything else? Sure it does. You can actually remove the entire [renderPage()][6] call because Wheels will assume that you always want to call a view page when the processing in the controller is done. Wheels will call it for you behind the scenes.

That leaves you with this code:

```cfml
<cfcomponent extends="Controller">

  <cffunction name="products">
  </cffunction>

</cfcomponent>
```

That looks rather silly, a `products` function with no code whatsoever. What do you think will happen if you just remove that entire function, leaving you with this code?

```cfml
<cfcomponent extends="Controller">
</cfcomponent>
```

…If you guessed that Wheels will just assume you don't need any code for the `products` action and just want the view rendered directly, then you are correct.

In fact, if you have a completely blank controller like the one above, you can delete it from the file system altogether!

This is quite useful when you're just adding simple pages to a website and you don't need the controller and model to be involved at all. For example, you can create a file named `about.cfm` in the `views/home` folder and access it at `http://localhost/home/about` without having to create a specific controller and/or action for it.

This also highlights the fact that Wheels is a very easy framework to get started in because you can basically program just as you normally would by creating simple pages like this and then gradually "Wheelsifying" your code as you learn the framework.

###The `params` Struct

Besides making sure the correct code is executed, Wheels also does something else to simplify request handling for you. It combines the `url` and `form` scopes into one. This is something that most CFML frameworks do as well. In Wheels, it is done in the `params` struct.

The `params` struct is available to you in the controller and view files but not in the model files. (It's considered a best practice to not mix your request handling with your business logic.) Besides the `form` and `url` scope variables, the `params` struct also contains the current controller and action name for easy reference.

If the same variable exists in both the `url` and `form` scopes, the value in the form scope will take precedence.

To make this concept easier to grasp, imagine a login form on your website that submits to `http://localhost/account/login?sendTo=dashboard` with the variables `username` and `password` present in the form. Your `params` struct would look like this:

<table>
	<thead>
		<tr>
			<th>Name</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
	<tr>
		<td><code>params.controller<code></td>
		<td><code>account</code></td></tr>
	<tr>
		<td><code>params.action<code></td>
		<td><code>login</code></td></tr>
	<tr>
		<td><code>params.sendTo<code></td>
		<td><code>dashboard</code></td></tr>
	<tr>
		<td><code>params.username<code></td>
		<td><code>joe</code></td></tr>
	<tr>
		<td><code>params.password<code></td>
		<td><code>1234</code></td></tr>
	</tbody>
</table>

Now instead of accessing the variables as `url.sendTo`, `form.username`, etc., you can just use the `params` struct for all of them instead.

This concept becomes even more useful once we start getting into creating forms specifically meant for accessing object properties. But let's save the details of all that for the [Form Helpers and Showing Errors][8] chapter.

###Routing

For more advanced URL-to-code mappings, you can use a concept called *routing*. It allows for you to fully customize every URL in your application. You can read more about this in the chapter called [Using Routes][9].

[1]: http://cfwheels.org/docs/1-3/function/linkto
[2]: http://cfwheels.org/docs/1-3/function/startformtag
[3]: http://cfwheels.org/docs/1-3/function/redirectto
[4]: http://cfwheels.org/docs/1-3/function/urlfor
[5]: 11-URL-Rewriting.md
[6]: http://cfwheels.org/docs/1-3/function/renderpage
[7]: 02-Rendering-Content.md
[8]: ../05-Displaying-Views-to-Users/05-Form-Helpers-and-Showing-Errors.md
[9]: 12-Using-Routes.md