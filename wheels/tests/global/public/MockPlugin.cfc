<cfcomponent output="false">

	<cffunction name="init">
		<cfreturn this>
	</cffunction>

	<cffunction name="mockFunction" returntype="Any">
		<cfreturn "I'm loaded!!!">
	</cffunction>

	<cffunction name="mockControllerFunction">
		<cfreturn "OVERRIDE:" & core.mockControllerFunction()>
	</cffunction>

</cfcomponent>