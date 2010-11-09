<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset StructDelete(variables, "result")>
		<cfset variables.object = model("user").new()>
	</cffunction>

	<cffunction name="testX">
		<cfset assert("1 IS 1")>
	</cffunction>

</cfcomponent>