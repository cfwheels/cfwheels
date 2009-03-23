<cfcomponent output="false">

	<cffunction name="init" access="public" returntype="Any" output="false">
		<cfargument name="datasource" type="string" required="true">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfset variables.instance.connection = arguments>
		<cfreturn this>
	</cffunction>

</cfcomponent>