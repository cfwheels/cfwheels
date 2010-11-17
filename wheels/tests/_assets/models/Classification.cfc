<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset belongsTo("post")>
		<cfset belongsTo("tag")>
	</cffunction>

</cfcomponent>