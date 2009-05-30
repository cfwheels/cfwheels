<cfcomponent extends="wheels.model">
	<cffunction name="init">
		<cfset table("users")>
		<cfset datasource(datasource="invalid_will_throw_error")>
	</cffunction>
</cfcomponent>