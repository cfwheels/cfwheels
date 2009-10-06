<cfcomponent extends="wheels.test">

	<cfset global.user = createobject("component", "wheels.model").$initModelClass("Users")>
 
 	<cffunction name="test_reload_valid">
		<cfset assert('1 eq 0')>
	</cffunction>

</cfcomponent>