<cffunction name="contentForLayout" returntype="string" access="public" output="false" hint="Used inside a layout file to output the HTML created in the view.">
	<cfreturn request.wheels.contentForLayout>
</cffunction>

<cffunction name="includePartial" returntype="string" access="public" output="false" hint="Includes a specified file. Similar to using `cfinclude` but with the ability to cache the result and using Wheels specific file look-up. By default Wheels will look for the file in the current controller's view folder. To include a file relative from the `views` folder you can start the path supplied to `name` with a forward slash.">
	<cfargument name="partial" type="any" required="true" hint="See documentation for `renderPartial`">
	<cfargument name="group" type="string" required="false" default="" hint="field to group the query by. A new query will be passed into the partial template for you to iterate over">
	<cfargument name="cache" type="any" required="false" default="" hint="See documentation for `renderPartial`">
	<cfargument name="layout" type="string" required="false" default="#application.wheels.functions.includePartial.layout#" hint="See documentation for `renderPartial`">
	<cfargument name="spacer" type="string" required="false" default="" hint="HTML or string to place between partials when called using a query">
	<cfif StructKeyExists(arguments, "name")>
		<cfset $deprecated("The `name` argument will be deprecated in a future version of Wheels, please use the `partial` argument instead")>
		<cfset arguments.partial = arguments.name>
		<cfset StructDelete(arguments, "name")>
	</cfif>
	<cfreturn $includeOrRenderPartial(argumentCollection=$dollarify(arguments, "partial,group,cache,layout,spacer"))>
</cffunction>
