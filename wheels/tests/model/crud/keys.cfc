<cfcomponent extends="wheels.test">

	<cfset global.user = createobject("component", "wheels.model").$initModelClass("Users")>
 
 	<cffunction name="test_primaryKey_valid">
		<cfset fail()>
	</cffunction>
 
 	<cffunction name="test_key_valid">
		<cfset fail()>
	</cffunction>

</cfcomponent>