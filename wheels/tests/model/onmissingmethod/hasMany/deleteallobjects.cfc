<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.authorModel = model("author")>
	</cffunction>
 
 	<cffunction name="test_deleteAllObjects_valid">
		<cfset loc.author = loc.authorModel.findOne(where="firstName = 'Per'")>
		<cftransaction action="begin">
			<cfset loc.updated = loc.author.deleteAllPosts() />
			<cfset loc.posts = loc.author.posts() />
			<cfset assert('IsNumeric(loc.updated) and loc.updated eq 3')>
			<cfset assert('IsQuery(loc.posts) eq true and not loc.posts.Recordcount')>
			<cftransaction action="rollback" />
		</cftransaction>
	</cffunction>

</cfcomponent>