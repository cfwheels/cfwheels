<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset table("tags")>
		<cfset afterCreate("createWelcomePost")>
	</cffunction>

	<cffunction name="createWelcomePost">
		<cfset var objPost = model("Post").create(authorId=1, title="Welcome", body="This is my first post", views=0)>
		<cfif IsObject(objPost)>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>

</cfcomponent>