<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.authorModel = model("author")>
		<cfset loc.userModel = model("user")>
	</cffunction>
 
 	<cffunction name="test_objects_returns_query">
		<cfset loc.author = loc.authorModel.findOne(where="firstName = 'Per'")>
		<cfset loc.posts = loc.author.posts() />
		<cfset $assert('IsQuery(loc.posts) eq true')>
		<cfset $assert('loc.posts.Recordcount')>
	</cffunction>
 
 	<cffunction name="test_objects_valid_with_combi_key">
		<cfset loc.user = loc.userModel.findByKey(key=1)>
		<cfset loc.combiKeys = loc.user.combiKeys() />
		<cfset $assert('IsQuery(loc.combiKeys) eq true')>
		<cfset $assert('loc.combiKeys.Recordcount')>
	</cffunction>

 	<cffunction name="test_objects_returns_empty_query">
		<cfset loc.author = loc.authorModel.findOne(where="firstName = 'James'")>
		<cfset loc.posts = loc.author.posts() />
		<cfset $assert('IsQuery(loc.posts) eq true')>
		<cfset $assert('not loc.posts.Recordcount')>
	</cffunction>

 	<cffunction name="test_pagination_with_blank_where">
		<cfset loc.author = loc.authorModel.findOne(where="firstName = 'Per'")>
		<cfset loc.posts = loc.author.posts(where="", page=1, perPage=2)>
		<cfset $assert('loc.posts.Recordcount IS 2')>
	</cffunction>

</cfcomponent>