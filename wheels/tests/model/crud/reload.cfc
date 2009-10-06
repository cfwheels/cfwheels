<cfcomponent extends="wheels.test">

	<cfset global.user = createobject("component", "wheels.model").$initModelClass("Users")>
 
 	<cffunction name="test_reload_valid">
		<cfset fail()>
	</cffunction>

</cfcomponent>