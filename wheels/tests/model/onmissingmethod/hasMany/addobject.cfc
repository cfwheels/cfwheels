<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.authorModel = model("author")>
	</cffunction>
 
 	<cffunction name="test_addObject_valid">
		<cfset loc.author = loc.authorModel.findOne(where="firstName = 'James'")>
		<cfset loc.post = model("post").findOne()>
		<cftransaction action="begin">
			<cfset loc.updated = loc.author.addPost(loc.post) />
			<cfset assert('loc.updated eq true')>
			<cfset assert('loc.post.authorid eq loc.author.id')>
			<cftransaction action="rollback" />
		</cftransaction>
	</cffunction>

</cfcomponent>