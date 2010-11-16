<cfcomponent extends="wheelsMapping.Model">

	<cffunction name="stupid_method">
		<cfargument name="a" type="numeric" required="true">
		<cfargument name="b" type="numeric" required="true">
		<cfreturn arguments.a + arguments.b>
	</cffunction>

</cfcomponent>