<!--- 
	Place functions that you want available to all controllers here.
	You can place code in the globalBeforeFilter and globalAfterFilter functions which will then be executed before/after every call to any controller's other filters and function.
--->

<cffunction name="globalBeforeFilter">
	<cfset var user = "">

	<cfif NOT isDefined("session.active_user") AND isDefined("cookie.screen_name")>
		<cfset user = model("user").findOne(where="screen_name = '#decrypt(cookie.screen_name, 'cryptic1234')#'")>
		<cfif user.recordfound>
			<cfset session.active_user = user>
		</cfif>
	</cfif>

</cffunction>

<cffunction name="globalAfterFilter">
</cffunction>

<cffunction name="restrictAccess">
	<cfif NOT structKeyExists(session, "active_user")>
		<cfset redirectTo(controller="account", action="login")>
	</cfif>
</cffunction>