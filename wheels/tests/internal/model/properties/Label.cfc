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
		<cfset result = variables.object.$label(property="someProp", mapping=loc.mapping)>
		<cfset assert("result IS 'Some Prop'")>
	</cffunction>
	
	<cffunction name="testMappedPropertyWithCustomLabel">
		<cfset var loc = {}>
		<cfset loc.mapping = {}>
		<cfset loc.mapping.someProp = {}>
		<cfset loc.mapping.someProp.label = "someMapLabel">
		<cfset result = variables.object.$label(property="someProp", mapping=loc.mapping)>
		<cfset assert("result IS 'someMapLabel'")>
	</cffunction>

	<cffunction name="test_public_accessible_method_propertyLabel">
		<cfset var loc = {}>
		<cfset loc.properties = {}>
		<cfset loc.properties.someProp = {}>
		<cfset loc.properties.someProp.label = "someRegLabel">
		<cfset result = variables.object.propertyLabel(property="someProp", properties=loc.properties)>
		<cfset assert("result IS 'someRegLabel'")>
	</cffunction>

</cfcomponent>