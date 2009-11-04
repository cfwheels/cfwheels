<cffunction name="contentForLayout" returntype="string" access="public" output="false" hint="Used inside a layout file to output the HTML created in the view."
	examples=
	'
		<!--- views/layout.cfm --->
		<html>
		<head>
		    <title>My Site</title>
		</head>
		<body>

		<cfoutput>
		##contentForLayout()##
		</cfoutput>

		</body>
		</html>
	'
	categories="view-helper" chapters="using-layouts">
	<cfreturn request.wheels.contentForLayout>
</cffunction>

<cffunction name="includePartial" returntype="string" access="public" output="false" hint="Includes the specified file in the view. Similar to using `cfinclude` but with the ability to cache the result and using Wheels specific file look-up. By default, Wheels will look for the file in the current controller's view folder. To include a file relative from the `views` folder, you can start the path supplied to `name` with a forward slash."
	examples=
	'
		<cfoutput>##includePartial("login")##</cfoutput>
		-> If we''re in the "admin" controller, Wheels will include the file "views/admin/_login.cfm".

		<cfoutput>##includePartial(partial="misc/doc", cache=30)##</cfoutput>
		-> If we''re in the "admin" controller, Wheels will include the file "views/admin/misc/_doc.cfm" and cache it for 30 minutes.

		<cfoutput>##includePartial(partial="/shared/button")##</cfoutput>
		-> Wheels will include the file "views/shared/_button.cfm".
	'
	categories="view-helper" chapters="pages,partials" functions="renderPartial">
	<cfargument name="partial" type="any" required="true" hint="See documentation for @renderPartial.">
	<cfargument name="group" type="string" required="false" default="" hint="field to group the query by. A new query will be passed into the partial template for you to iterate over.">
	<cfargument name="cache" type="any" required="false" default="" hint="See documentation for @renderPartial.">
	<cfargument name="layout" type="string" required="false" default="#application.wheels.functions.includePartial.layout#" hint="See documentation for @renderPartial.">
	<cfargument name="spacer" type="string" required="false" default="" hint="HTML or string to place between partials when called using a query.">
	<cfreturn $includeOrRenderPartial(argumentCollection=$dollarify(arguments, "partial,group,cache,layout,spacer"))>
</cffunction>