<cfcomponent extends="wheels.controller">
<!--- 

	test controller for 

 --->

	<cffunction name="should_deprecate">
		<cfreturn $deprecated("_deprecated_", false)>		
	</cffunction>

</cfcomponent>