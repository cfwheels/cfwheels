<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset belongsTo("author")>
		<cfset hasMany("comments")>
		<cfset hasMany("classifications")>
		<cfset validatesUniquenessOf("title")>
		<cfset property(name="titleAlias", sql="title", select=false)>
		<cfset property(name="firstId", sql="MAX(posts.id)", select=false)>
	</cffunction>

	<cffunction name="afterFindCallback">
		<cfif StructIsEmpty(arguments)>
			<cfset this.title = "setTitle">
			<cfset this.views = this.views + 100>
			<cfset this.something = "hello world">
		<cfelse>
			<cfset arguments.title = "setTitle">
			<cfset arguments.views = arguments.views + 100>
			<cfset arguments.something = "hello world">
			<cfreturn arguments>
		</cfif>
	</cffunction>

</cfcomponent>
