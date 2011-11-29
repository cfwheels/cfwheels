<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.authorModel = model("author")>
	</cffunction>
 
 	<cffunction name="test_deleteObject_valid">
		<cfset loc.author = loc.authorModel.findOne(where="firstName = 'Per'")>
		<cfset loc.post = loc.author.findOnePost(order="id")>
		<cftransaction action="begin">
			<cfset loc.updated = loc.author.deletePost(loc.post) />
			<cfset loc.post = model("post").findByKey(key=loc.post.id) />
			<cfset assert('loc.updated eq true')>
			<cfset assert('not IsObject(loc.post) and loc.post eq false')>
			<cftransaction action="rollback" />
		</cftransaction>
	</cffunction>

</cfcomponent>