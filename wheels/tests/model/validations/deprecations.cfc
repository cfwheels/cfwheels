<cfcomponent extends="wheelsMapping.Test">

 	<cffunction name="setup">
		<cfset StructDelete(application.wheels.models, "users", false)>
        <cfset loc.user = model("users").new()>
		<cfset ArrayClear(request.wheels.deprecation)>
	</cffunction>
	
	<!--- validatesPresenceOf --->
	<cffunction name="test_validatesPresenceOf_valid">
		<cfset loc.user.firstname = "tony">
		<cfset loc.user.validatesPresenceOf(property="firstname", if="StructKeyExists(this, 'something')")>
		<cfset assert('!ArrayIsEmpty(request.wheels.deprecation)')>
	</cffunction>

</cfcomponent>