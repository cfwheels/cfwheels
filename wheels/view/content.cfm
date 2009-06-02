<cffunction name="contentForLayout" returntype="string" access="public" output="false" hint="Used inside a layout file to output the HTML created in the view.">
	<cfreturn request.wheels.contentForLayout>
</cffunction>

<cffunction name="includePartial" returntype="string" access="public" output="false" hint="Includes a specified file. Similar to using `cfinclude` but with the ability to cache the result and using Wheels specific file look-up. By default Wheels will look for the file in the current controller's view folder. To include a file relative from the `views` folder you can start the path supplied to `name` with a forward slash.">
	<cfargument name="name" type="string" required="true" hint="The name of the file to be included (starting with an optional path and with the underscore and file extension excluded)">
	<cfargument name="cache" type="any" required="false" default="" hint="Number of minutes to cache the partial for">
	<cfargument name="$type" type="string" required="false" default="include">
	<cfreturn $includeOrRenderPartial(argumentCollection=arguments)>
</cffunction>