# addRoute()

## Description
Adds a new route to your application.

## Function Syntax
	addRoute( pattern, [ name, controller, action ] )


## Parameters
<table>
	<thead>
		<tr>
			<th>Parameter</th>
			<th>Type</th>
			<th>Required</th>
			<th>Default</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		
		<tr>
			<td>name</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Name for the route. This is referenced as the `name` argument in functions based on @URLFor like @linkTo, @startFormTag, etc.</td>
		</tr>
		
		<tr>
			<td>pattern</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>The URL pattern that the route will match.</td>
		</tr>
		
		<tr>
			<td>controller</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Controller to call when route matches (unless the controller name exists in the pattern).</td>
		</tr>
		
		<tr>
			<td>action</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Action to call when route matches (unless the action name exists in the pattern).</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Example 1: Adds a route which will invoke the `profile` action on the `user` controller with `params.userName` set when the URL matches the `pattern` argument --->
		<cfset addRoute(name="userProfile", pattern="user/[username]", controller="user", action="profile")>

		<!--- Example 2: Category/product URLs. Note the order of precedence is such that the more specific route should be defined first so Wheels will fall back to the less-specific version if it's not found --->
		<cfset addRoute(name="product", pattern="products/[categorySlug]/[productSlug]", controller="products", action="product")>
		<cfset addRoute(name="productCategory", pattern="products/[categorySlug]", controller="products", action="category")>
		<cfset addRoute(name="products", pattern="products", controller="products", action="index")>

		<!--- Example 3: Change the `home` route. This should be listed last because it is least specific --->
		<cfset addRoute(name="home", pattern="", controller="main", action="index")>
