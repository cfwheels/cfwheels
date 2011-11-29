<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.authorModel = model("author")>
	</cffunction>
 
 	<cffunction name="test_createObject_valid">
		<cfset loc.author = loc.authorModel.findOne(where="firstName = 'James'")>
		<cftransaction action="begin">
			<cfset loc.post = loc.author.createPost(title="Title for first test post", body="Text for first test post", views=0) />
			<cfset assert('IsObject(loc.post) eq true')>
			<cfset assert('loc.post.authorid eq loc.author.id')>
			<cftransaction action="rollback" />
		</cftransaction>
	</cffunction>

</cfcomponent>