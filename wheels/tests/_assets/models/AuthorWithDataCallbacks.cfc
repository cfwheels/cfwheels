<cfcomponent extends="wheelsMapping.Model">

	<cffunction name="init">
		<cfset table("Authors")>
		<cfset hasMany("posts")>
		<cfset hasOne("profile")>
		<cfset afterCreate("createWelcomePost")>
	</cffunction>

	<cffunction name="createWelcomePost">
		<cfset var objPost = model("Post").create(authorId=this.id, title="Welcome", body="This is my first post", views=0)>
		<cfif IsObject(objPost)>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>

</cfcomponent>