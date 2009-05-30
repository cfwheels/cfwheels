<cfcomponent extends="wheels.controller">

	<cfset includePlugin("mockPlugin")>

	<cffunction name="mockControllerFunction">
		<cfreturn true>
	</cffunction>

</cfcomponent>