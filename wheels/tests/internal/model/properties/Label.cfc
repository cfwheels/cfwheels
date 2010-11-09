<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset StructDelete(variables, "result")>
		<cfset variables.object = model("user").new()>
	</cffunction>

	<cffunction name="testRegularProperty">
		<cfset var loc = {}>
		<cfset loc.properties = {}>
		<cfset loc.properties.someProp = {}>
		<cfset loc.properties.someProp.label = "someRegLabel">
		<cfset result = variables.object.$label(property="someProp", properties=loc.properties)>
		<cfset assert("result IS 'someRegLabel'")>
	</cffunction>

	<cffunction name="testMappedProperty">
		<cfset var loc = {}>
		<cfset loc.mapping = {}>
		<cfset loc.mapping.someProp = {}>
		<cfset loc.mapping.someProp.label = "someMapLabel">
		<cfset result = variables.object.$label(property="someProp", mapping=loc.mapping)>
		<cfset assert("result IS 'someMapLabel'")>
	</cffunction>

	<cffunction name="testThrowError">
		<cfset result = raised("variables.object.$label(property='x')")>
		<cfset assert("result IS 'Wheels.LabelDoesNotExist'")>
	</cffunction>

</cfcomponent>