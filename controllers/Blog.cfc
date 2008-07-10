<cfcomponent extends="Controller">

	<cffunction name="index">
	</cffunction>

	<cffunction name="listAuthors">
		<cfparam name="params.page" default="1">
		<cfset authors = model("Author").findAll(order="lastName", page=params.page, perPage=3)>
	</cffunction>

	<cffunction name="newAuthor">
		<cfset author = model("Author").new()>
	</cffunction>

	<cffunction name="createAuthor">
		<cfset author = model("Author").new(params.author)>
		<cfif author.save()>
			<cfset flashInsert(message="Done!")>
			<cfset redirectTo(action="newAuthor")>
		<cfelse>
			<cfset renderPage(action="newAuthor")>
		</cfif>
	</cffunction>

	<cffunction name="deleteAuthor">
		<cfif model("Author").deleteById("#params.firstName#,#params.lastName#")>
			<cfset flashInsert(message="Author deleted!")>
		<cfelse>
			<cfset flashInsert(message="Delete operation failed!")>
		</cfif>
		<cfset redirectTo(back=true)>
	</cffunction>

</cfcomponent>