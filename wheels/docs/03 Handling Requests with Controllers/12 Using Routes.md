# Using Routes

*The convention for URLs in Wheels works for most situations and helps to promote an easy-to-maintain 
code base. With routes, you have the flexibility to break this convention when needed.*

## The Convention for URLs

To write clear MVC applications with ColdFusion on Wheels, we recommend sticking to conventions as much 
as possible. As you may already know, the convention for URLs is as follows:

	http://www.domain.com/news/story/5

With this convention, the URL above tells Wheels to invoke the `story` action in the `news` controller. 
It also passes a parameter to the action called `key`, with a value of `5`.

## Creating Your Own Routes

But let's say that you wanted a simpler URL for your site's user profiles. What if you wanted to have a 
`profile` action in a controller called `user` with this URL?

	http://www.domain.com/user/johndoe

Fear not, this is possible in Wheels.

### Adding a New Route

Routes are configured in the `config/routes.cfm` file. This is where we'll add our new user profile 
route.

Routes are added to Wheels using the `addRoute()` function. Here is how we would set up our new route 
using this function:

	<cfset addRoute(name="userProfile", pattern="user/[username]", controller="user", action="profile")>

This call to `addRoute()` instructs Wheels to create a route named `userProfile` that passes a 
`username` parameter to the `profile` action in the `user` controller. This route will be invoked by any 
URL that starts with a top level folder of `user`. In most cases, a pattern in a route should begin with 
a unique top level folder.

As you can see, any new parameters that you want to introduce to a new route should be surrounded by 
square brackets `[]`.

With this, you can create URL patterns with any level of complexity that you wish.

#### Using `controller` and `action` Within Your Route

As you saw above we specifically told Wheels which controller and action that the `userProfile` route 
should call. Instead of doing this, you also have the option of making them dynamic by including them in 
the pattern instead. (This is actually how Wheels sets up the default routes internally.)

Consider this line of code:

	<cfset addRoute(name="adminUser", pattern="admin/user/[action]", controller="adminUser")>

With this pattern, a URL that begins with `admin/user/` will always call the `adminUser` controller but 
what action to call on that controller is determined dynamically by the URL.

So now this route pattern will, for example, match for these URLs:

<table>
	<thead>
		<tr>
			<th>URL</th>
			<th>Controller</th>
			<th>Action</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>`http://www.domain.com/admin/user/edit`</td>
			<td>`adminUser`</td>
			<td>`edit`</td>
		</tr>
		<tr>
			<td>`http://www.domain.com/admin/user/add`</td>
			<td>`adminUser`</td>
			<td>`add`</td>
		</tr>
		<tr>
			<td>`http://www.domain.com/admin/user/delete`</td>
			<td>`adminUser`</td>
			<td>`delete`</td>
		</tr>
	</tbody>
</table>

Although probably less useful, the same concept can be applied to the controller variable as well.

### Linking to Your New Route

Now if you wanted to create a link to that user profile action we discussed earlier in the chapter, you 
would use Wheels's `linkTo()` function like so:

	#linkTo(route="userProfile", username="johndoe")#

As you can see, `linkTo()` accepts a `route` argument, which changes the function's expectations on 
which other arguments are passed. Because our `userProfile` route expects a `username` parameter, we 
would need to pass that.

You can read more about creating links in the chapter called [Linking Pages][1]

## Order of Precedence

With the potential of your application requiring many custom routes, you may wonder which order that 
Wheels considers these new routes. The answer is that Wheels gives precedence to the first listed custom 
route in your `config/routes.cfm` file.

Wheels will look through each custom route in order to see if there is a match. If not, it defaults to 
the default route mentioned at the beginning of this chapter under "The Convention for URLs".

### Example of Precedence

Let's pretend that our `config/routes.cfm` file looks like this:

	<cfset addRoute(name="newsAdmin", pattern="admin/news/[action]"), controller="newsAdmin">
	<cfset addRoute(name="searchAdmin", pattern="admin/search/[action]", controller="searchAdmin")>
	<cfset addRoute(name="adminRoot", pattern="admin/[action]", controller="admin")>

Wheels would make sure that the URL didn't begin with `admin/news` or `admin/search` before calling the 
third route listed, `adminRoot`.

If the URL didn't begin with `admin` at all, Wheels would use its internal default route, matching the 
usual pattern of `[controller]/[action]/[key]`.

## Making a Catch-All Route

Sometimes you need a catch-all route in Wheels to support highly dynamic websites (like a content 
management system, for example), where all requests that are not matched by an existing route get passed 
to a controller/action that can deal with it.

Let's say you want to have both `http://localhost/welcome-to-the-site` and 
`http://localhost/terms-of-use` handled by the same controller and action. Here's what you can do to 
achieve this:

First, add a new route to `config/routes.cfm` that catches all pages like this:

	<cfset addRoute(name="catchAll", pattern="[title]", controller="page", action="index")>

Now when you type in `http://localhost/welcome-to-the-site` this route will be triggered, and the 
`index` action will be called on the `page` controller with `params.title` set to `welcome-to-the-site`.

The problem with this is that this will break any of your normal controllers though, so you'll have to 
add them specifically *before* this route. (Remember the order of precedence explained above.)

You'll end up with a `config/routes.cfm` file looking something like this:

	<cfset addRoute(name="main", pattern="main/[action]", controller="main")>
	<cfset addRoute(name="admin", pattern="admin/[action]", controller="admin")>
	<cfset addRoute(name="catchAll", pattern="[title]", controller="page", action="index")>
	<cfset addRoute(name="home", pattern="", controller="main", action="index")>

`main` and `admin` are your normal controllers. By adding them to the top of the routes file Wheels 
looks for them first.

[1]: ../05%20Displaying%20Views%20to%20Users/03%20Linking%20Pages.md