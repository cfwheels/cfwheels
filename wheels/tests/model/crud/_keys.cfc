<cfcomponent extends="wheelsMapping.test">

	<cfset global.user = createobject("component", "wheelsMapping.model").$initModelClass("Users")>
 
 	<cffunction name="test_primaryKey_valid">
		<cfset fail()>
	</cffunction>
 
 	<cffunction name="test_key_valid">
		<cfset fail()>
	</cffunction>

</cfcomponent>