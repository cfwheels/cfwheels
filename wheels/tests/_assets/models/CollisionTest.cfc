<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset afterFind("afterFindCallback")>
	</cffunction>

	<cffunction name="afterFindCallback">
		<cfset arguments.method = "done">
		<cfreturn arguments>
	</cffunction>

</cfcomponent>