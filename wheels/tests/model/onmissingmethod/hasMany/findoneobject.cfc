<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.authorModel = model("author")>
	</cffunction>
 
 	<cffunction name="test_findOneObject_valid">
		<cfset loc.author = loc.authorModel.findOne(where="firstName = 'Per'")>
		<cfset loc.post = loc.author.findOnePost(order="id")>
		<cfset assert('IsObject(loc.post) eq true')>
	</cffunction>

</cfcomponent>