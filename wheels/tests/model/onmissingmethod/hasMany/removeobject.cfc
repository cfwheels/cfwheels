<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.authorModel = model("author")>
	</cffunction>
 
 	<cffunction name="test_removeObject_valid">
		<cfset loc.author = loc.authorModel.findOne(where="firstName = 'Per'")>
		<cfset loc.post = loc.author.findOnePost(order="id")>
		<cftransaction action="begin">
			<cfset loc.updated = loc.author.removePost(loc.post) />
			<cfset loc.post.reload() />
			<cfset assert('loc.updated eq true')>
			<cfset assert('loc.post.authorid eq ""')>
			<cftransaction action="rollback" />
		</cftransaction>
	</cffunction>

</cfcomponent>