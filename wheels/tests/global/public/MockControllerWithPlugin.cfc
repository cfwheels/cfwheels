<cfcomponent extends="wheels.controller">

	<cfset includePlugin("mockPlugin")>

	<cffunction name="init">
		<cfreturn this>
	</cffunction>

	<cffunction name="mockControllerFunction">
		<cfreturn "ORIGINAL">
	</cffunction>

</cfcomponent>