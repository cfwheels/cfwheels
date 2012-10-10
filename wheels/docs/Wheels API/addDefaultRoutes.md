# addDefaultRoutes()

## Description
Adds the default Wheels routes (for example, `[controller]/[action]/[key]`, etc.) to your application. Only use this method if you have set `loadDefaultRoutes` to `false` and want to control exactly where in the route order you want to place the default routes.

## Function Syntax
	addDefaultRoutes(  )



## Examples
	
		<!--- Adds the default routes to your application (done in `config/routes.cfm`) --->
		<cfset addDefaultRoutes()>
