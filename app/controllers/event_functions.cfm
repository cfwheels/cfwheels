<!--- Place code inside these functions if you want to execute something on application start, on request start or on request end  --->

<cffunction name="applicationStart">
</cffunction>

<cffunction name="requestStart">
	<cfset var user = "">

	<cfif NOT isDefined("session.active_user") AND isDefined("cookie.screen_name")>
		<cfset user = model("user").findOne(where="screen_name = '#decrypt(cookie.screen_name, 'cryptic1234')#'")>
		<cfif user.recordfound>
			<cfset session.active_user = user>
		</cfif>
	</cfif>

</cffunction>

<cffunction name="requestEnd">
</cffunction>