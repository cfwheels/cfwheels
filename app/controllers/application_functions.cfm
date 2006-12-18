<!--- 
	Place functions that you want available to all controllers here.
	You can place code in the globalBeforeFilter and globalAfterFilter functions which will then be executed before/after every call to any controller's other filters and function.
--->

<cffunction name="onApplicationStart">
</cffunction>

<cffunction name="onRequestStart">
	<cfset var local = structNew()>

	<!--- Get active user from database from cookie if it does not exist in session already --->
	<cfif NOT isDefined("session.active_user") AND isDefined("cookie.screen_name")>
		<cfset local.user = model("user").findOne(where="screen_name = '#decrypt(cookie.screen_name, 'cryptic1234')#'")>
		<cfif local.user.recordfound>
			<cfset session.active_user = local.user>
		</cfif>
	</cfif>

	<!--- Get favorites if user's session is active --->
	<cfif isDefined("session.active_user")>
		<cfif NOT isDefined("session.favorite_users") OR NOT isDefined("session.favorite_recordings") OR NOT isDefined("session.favorite_artists") OR NOT isDefined("session.favorite_songs")>
			<cfloop list="recording,user,song,artist" index="local.i">
				<cfquery name="local.favorite_query" datasource="#application.database.source#">
				SELECT favorite_#local.i#_id AS the_id
				FROM favorite_#local.i#s
				WHERE user_id = #session.active_user.id#
				</cfquery>
				<cfif local.favorite_query.recordcount GT 0>
					<cfset "session.favorite_#local.i#s" = valueList(local.favorite_query.the_id)>
				<cfelse>
					<cfset "session.favorite_#local.i#s" = "">
				</cfif>
			</cfloop>
		</cfif>
	</cfif>

</cffunction>

<cffunction name="onRequestEnd">
</cffunction>

<cffunction name="restrictAccess">
	<cfif NOT structKeyExists(session, "active_user")>
		<cfset redirectTo(controller="account", action="login")>
	</cfif>
</cffunction>