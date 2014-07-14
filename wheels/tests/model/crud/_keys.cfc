<cfcomponent extends="wheelsMapping.Test">

	<cfset global.user = createobject("component", "wheelsMapping.Model").$initModelClass("Users")>
 
 	<cffunction name="test_primaryKey_valid">
		<cfset fail()>
	</cffunction>
 
 	<cffunction name="test_key_valid">
		<cfset fail()>
	</cffunction>

</cfcomponent>