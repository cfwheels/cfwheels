# Linking Pages

*Wheels does some magic to help you link to other actions within your app. Read on to learn why you'll 
rarely use an `<a>` tag for linking to application actions ever again.*

## `linkTo`, the Function for Linking to Other Pages

Wheels's built-in `linkTo()` function does all of the heavy lifting involved with linking the different 
pages of your application together. You'll generally be using `linkTo()` within your view code.

As you'll soon realize, the `linkTo()` function accepts a whole bunch of arguments. We won't go over all 
of them here so don't forget to have a look at the documentation for `linkTo()` for the complete details.

Let's go right to an example...

### Basic Example

If we wanted to link to the page that is the `authors` action in the `blog` controller, this is the code 
that we would write:

	#linkTo(text="List All Authors", controller="blog", action="authors")#

The above code would generate this markup:

	<a href="/blog/authors">List of Authors</a>

### Extreme Example

If we were to use all of the parameters except for `route` (more on that later), our code may look 
something like this:

	#linkTo(text="Wheels Rocks!", controller="wheels", action="rocks", key=55, params="rocks=yes&referral=cfwheels.com", anchor="rockin", host="www.securesite.com", protocol="https", onlyPath=false, confirm="Are you sure that Wheels rocks?")#

Which would generate this HTML:

	<a href="https://www.securesite.com/wheels/rocks/55?rocks=yes&amp;referral=cfwheels.com#rockin" onclick="return confirm('Are you sure that Wheels rocks?')">Wheels Rocks!</a>

## Using `linkTo` with Routes

Routes makes creating custom URLs outside of the wheels `controller/action/key` convention pretty darn 
easy. Refer to the [Using Routes][1] chapter for information about how to setup your routes.

Let's say that you have this route set up in your `config/routes.cfm` file:

	<cfset addRoute(name="profile", pattern="user/[username]", controller="account", action="profile")>

You can then pass the route name as the `route` argument of `linkTo()`. With this, you can also pass the 
`username` parameter that the `profile` route requires like so (pretend that we have instantiated a 
`user` object that has the fields `firstName`, `lastName`, and `username`).

	#linkTo(text="#user.firstName# #user.lastName#", route="profile", username=user.username)#

## Images as Links

If you'd like to use an image as a link to another page, simply pass the output of `imageTag()` to the 
`text` argument of `linkTo()`:

	#linkTo(text="imageTag(source="authors.jpg"), controller="blog", action="authors")#

## Adding Additional Attributes Like `class`, `rel`, and `id`

Like many of the other Wheels view helpers, any additional arguments that you pass to `linkTo()` will be 
added to the generated `<a>` tag as attributes.

For example, if you'd like to add a `class` attribute value of `button` to your link, here's what the 
call to `linkTo()` would look like:

	#linkTo(text="Add to Cart", controller="cart", action="add", class="button")#

The same goes for any other argument that you pass, including but not limited to `id`, `rel`, `onclick`,
etc.

## What If I Don't Have URL Rewriting Enabled?

Wheels will handle linking to pages without URL rewriting for you automatically. Let's pretend that you 
still have Wheels installed in your site root, but you do not have URL rewriting on. How you write your 
`linkTo()` call will not change:

	#linkTo(text="This link still works", controller="company", action="contact", key=3)#

But Wheels will still correctly build the link markup:

	<a href="/index.cfm/company/contact/3">This link still works</a>

### Linking in a Subfolder Deployment of Wheels

The same would be true if you had Wheels installed in a subfolder, thus perhaps eliminating your ability 
to use [URL Rewriting][2] (depending on what web server you have). The same `linkTo()` code above may 
generate this HTML if you had Wheels installed in a subfolder called `foo`:

	<a href="/foo/index.cfm?controller=company&amp;action=contact&amp;key=3">This link still works</a>

## Use the `linkTo()` Function for Portability

An `<a>` tag is easy enough, isn't it? Why would we need to use a function to do this mundane task? It 
turns out that there are some advantages. Here's the deal.

Wheels gives you a good amount of structure for your applications. With this, instead of thinking of 
URLs in the "old way," we think in terms of what route, controller, and/or action we're sending the user 
to next.

What's more, Wheels is smart enough to build URLs for you. And it'll do this for you based on your 
situation with URL rewriting. Are you using URL rewriting in your app? Great. Wheels will build your 
URLs accordingly. Not fortunate enough to have URL rewriting capabilities in your development or 
production environments? That's fine too because Wheels will handle that automatically. Are you using 
Wheels in a subfolder on your site? Wheels handles that for you too.

If you see the pattern, this gives your application a good deal of portability. For example, you could 
later enable URL rewriting or move your application to a different subfolder. As long as you're using 
`linkTo()` to build your links, you won't need to change anything extra to your code in order to 
accommodate this change.

Oh, and another reason is that it's just plain cool too. ;)

[1]: ../03%20Handling%20Requests%20with%20Controllers/12%20Using%20Routes.md
[2]: ../03%20Handling%20Requests%20with%20Controllers/11%20URL%20Rewriting.md