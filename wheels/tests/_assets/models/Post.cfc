<cfcomponent extends="wheelsMapping.Model">

	<cffunction name="init">
		<cfset belongsTo("author")>
		<cfset hasMany("comments")>
	</cffunction>

	<cffunction name="afterFindCallback">
		<cfif StructIsEmpty(arguments)>
			<cfset this.title = "setOnObject">
			<cfset this.views = 100>
		<cfelse>
			<cfset arguments.title = "setOnQueryRecord">
			<cfset arguments.views = arguments.views + 100>
			<cfreturn arguments>
		</cfif>
	</cffunction>
	
</cfcomponent>