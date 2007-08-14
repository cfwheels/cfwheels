<!--- Place functions that you want available to all controllers here. --->

<cffunction name="onApplicationStart">
</cffunction>

<cffunction name="onRequestStart">
	<cfset var local = structNew()>

	<!--- Get active user from database from cookie if it does not exist in session already --->
	<cfif NOT isDefined("session.user_id") AND isDefined("cookie.screen_name")>
		<cfset local.user = model("user").findOne(where="screen_name = '#decrypt(cookie.screen_name, 'cryptic1234')#'")>
		<cfif local.user.recordfound>
			<cfset session.user_id = local.user.id>
		</cfif>
	</cfif>

	<!--- Get favorites if user's session is active --->
	<cfif isDefined("session.user_id")>
		<cfif NOT isDefined("session.favorite_users") OR NOT isDefined("session.favorite_recordings") OR NOT isDefined("session.favorite_artists") OR NOT isDefined("session.favorite_songs")>
			<cfloop list="recording,user,song,artist" index="local.i">
				<cfquery name="local.favorite_query" datasource="ss_userlevel">
				SELECT favorite_#local.i#_id AS the_id
				FROM favorite_#local.i#s
				WHERE user_id = #session.user_id# AND deleted_at IS NULL
				</cfquery>
				<cfif local.favorite_query.recordcount GT 0>
					<cfset "session.favorite_#local.i#s" = valueList(local.favorite_query.the_id)>
				<cfelse>
					<cfset "session.favorite_#local.i#s" = "">
				</cfif>
			</cfloop>
		</cfif>
	</cfif>
	<cfset decryptParamsId()>
</cffunction>

<cffunction name="onRequestEnd">
</cffunction>

<cffunction name="restrictAccess">
	<cfif NOT structKeyExists(session, "user_id")>
		<cfset request.flash.notice = "Please take a moment to create an account or login first...">
		<cfset redirectTo(controller="account", action="entrance", params="backlink=#cgi.script_name#?#cgi.query_string#")>
	</cfif>
</cffunction>

<cffunction name="doEncrypt" access="public" output="true">
<cfargument name="idToEncrypt" required="yes" type="Any"><cfset key = "I65DT4ULCHM="><cfreturn encrypt(idToEncrypt, key,"DES","HEX")>
</cffunction>

<cffunction name="doDecrypt" access="public" output="true"><cfargument name="idToDecrypt" required="yes" type="Any">
	<cfset key = "I65DT4ULCHM=">
	<cftry>
		<cfreturn decrypt(idToDecrypt, key,"DES","HEX")>
	<cfcatch>
		<cfreturn idToDecrypt>
	</cfcatch>
	</cftry>
</cffunction>

<cffunction name="decryptParamsId">
	<cfset key = "I65DT4ULCHM=">
	<cfif IsDefined("request.params.id")>
		<cftry>
			<cfset request.params.id=decrypt(request.params.id, key,"DES","HEX")>
		<cfcatch>
		</cfcatch>
		</cftry>
	</cfif>
</cffunction>