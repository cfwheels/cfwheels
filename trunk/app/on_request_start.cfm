<!--- Write code here that you want executed at the start of each request (please note that at this point the framework has not been loaded so you can't use any of it's functions --->

<!--- Get active user from database from cookie if it does not exist in session already --->
<cfif NOT isDefined("session.active_user") AND isDefined("cookie.screen_name")>
	<cfset reqstart.user = model("user").findOne(where="screen_name = '#decrypt(cookie.screen_name, 'cryptic1234')#'")>
	<cfif reqstart.user.recordfound>
		<cfset session.active_user = reqstart.user>
	</cfif>
</cfif>

<!--- Get favorites if user's session is active --->
<!--- <cfif isDefined("session.active_user")>
	<cfif NOT isDefined("session.favorite_users") OR NOT isDefined("session.favorite_recordings") OR NOT isDefined("session.favorite_artists") OR NOT isDefined("session.favorite_songs")>
		<cfloop list="#recording,user,song,artist#" index="i">
			<cfquery name="favorite_query" datasource="#application.database.name#">
			SELECT favorite_#i#_id AS the_id
			FROM favorite_#i#s
			WHERE user_id = #active_user.id#
			</cfquery>
			<cfif favorite_query.recordcount GT 0>
				<cfset "session.favorite_#i#s" = valueList(favorite_query.the_id)>
			<cfelse>
				<cfset "session.favorite_#i#s" = "">
			</cfif>
		</cfloop>
	</cfif>
</cfif> --->