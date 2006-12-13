<!--- Place the functions that you want available to every controller in your application here --->

<cffunction name="restrictAccess">
	<cfif NOT structKeyExists(session, "active_user")>
		<cfset redirectTo(controller="account", action="login")>
	</cfif>
</cffunction>
