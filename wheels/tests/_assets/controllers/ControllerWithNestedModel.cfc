<cfcomponent extends="wheelsMapping.controller">

	<cfset author = model("author").findOne(where="lastname = 'Djurner'", include="profile", order="id")>
	<cfset author.posts = author.posts(include="comments", returnAs="objects", order="id")>

</cfcomponent>