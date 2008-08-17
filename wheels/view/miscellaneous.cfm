<cffunction name="includePartial" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="cache" type="any" required="false" default="">
	<cfargument name="$type" type="any" required="false" default="include">
	<cfreturn $includeOrRenderPartial(argumentCollection=arguments)>
</cffunction>