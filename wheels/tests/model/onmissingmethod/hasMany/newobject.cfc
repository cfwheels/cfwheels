<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.authorModel = model("author")>
	</cffunction>
 
 	<cffunction name="test_newObject_valid">
		<cfset loc.author = loc.authorModel.findOne(where="firstName = 'James'")>
		<cfset loc.post = loc.author.newPost() />
		<cfset assert('IsObject(loc.post) eq true')>
		<cfset assert('loc.post.authorid eq loc.author.id')>
	</cffunction>

</cfcomponent>