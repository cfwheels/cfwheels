<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_getting_parent">
		<cfset loc.obj = model("post").findOne(order="id")>
		<cfset loc.dynamicResult = loc.obj.author()>
		<cfset loc.coreResult = model("author").findByKey(loc.obj.authorId)>
		<cfset assert("loc.dynamicResult.key() IS loc.coreResult.key()")>
		<cfset loc.dynamicResult = loc.obj.author(select="lastName", returnAs="query")>
		<cfset loc.coreResult = model("author").findByKey(key=loc.obj.authorId, select="lastName", returnAs="query")>
		<cfset assert("IsQuery(loc.dynamicResult) AND ListLen(loc.dynamicResult.columnList) IS 1 AND IsQuery(loc.coreResult) AND ListLen(loc.coreResult.columnList) IS 1 AND loc.dynamicResult.lastName IS loc.coreResult.lastName")>
	</cffunction>

	<cffunction name="test_checking_if_parent_exists">
		<cfset loc.obj = model("post").findOne(order="id")>
		<cfset loc.dynamicResult = loc.obj.hasAuthor()>
		<cfset loc.coreResult = model("author").exists(loc.obj.authorId)>
		<cfset assert("loc.dynamicResult IS loc.coreResult")>
	</cffunction>

	<cffunction name="test_getting_parent_on_new_object">
		<cfset loc.authorByFind = model("author").findOne(order="id")>
		<cfset loc.newPost = model("post").new(authorId=loc.authorByFind.id)>
		<cfset loc.authorByAssociation = loc.newPost.author()>
		<cfset assert("loc.authorByFind.key() IS loc.authorByAssociation.key()")>
	</cffunction>

	<cffunction name="test_checking_if_parent_exists_on_new_object">
		<cfset loc.authorByFind = model("author").findOne(order="id")>
		<cfset loc.newPost = model("post").new(authorId=loc.authorByFind.id)>
		<cfset loc.authorExistsByAssociation = loc.newPost.hasAuthor()>
		<cfset assert("loc.authorExistsByAssociation IS true")>
	</cffunction>
	
	<cffunction name="test_getting_parent_on_combined_key_model">
		<cfset loc.combikey = model("combikey").findOne()>
		<cfset loc.user = loc.combikey.user()>
		<cfset assert("IsObject(loc.user)")>
	</cffunction>

	<cffunction name="test_getting_parent_with_join_key">
		<cfset loc.obj = model("author").findOne(order="id", include="user")>
		<cfset assert('loc.obj.firstName eq loc.obj.user.firstName')>
	</cffunction>

</cfcomponent>