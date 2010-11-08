<cfcomponent extends="wheelsMapping.Test">

	<cfset global.user = createobject("component", "wheelsMapping.Model").$initModelClass("Users")>
 
 	<cffunction name="test_reload_valid">
		<cfset fail()>
	</cffunction>

</cfcomponent>