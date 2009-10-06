<cfcomponent extends="wheels.test">

	<cfset global.user = createobject("component", "wheels.model").$initModelClass("Users")>
 
 	<cffunction name="test_primaryKey_valid">
		<cfset assert('1 eq 0')>
	</cffunction>
 
 	<cffunction name="test_key_valid">
		<cfset assert('1 eq 0')>
	</cffunction>

</cfcomponent>