<cfcomponent extends="wheelsMapping.test">

	<cfset global.user = createobject("component", "wheelsMapping.model").$initModelClass("Users")>
 
 	<cffunction name="test_reload_valid">
		<cfset fail()>
	</cffunction>

</cfcomponent>