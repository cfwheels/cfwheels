<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cffunction name="test_getting_parent">
		<cfset loc.obj = model("post").findOne(order="id")>
		<cfset loc.associationResult = loc.obj.author()>
		<cfset loc.finderResult = model("author").findByKey(loc.obj.authorId)>
		<cfset assert("loc.associationResult.key() IS loc.finderResult.key()")>
	</cffunction>

	<cffunction name="test_getting_parent_and_passing_through_arguments">
		<cfset loc.obj = model("post").findOne(order="id")>
		<cfset loc.associationResult = loc.obj.author(select="lastName", returnAs="query")>
		<cfset loc.finderResult = model("author").findByKey(key=loc.obj.authorId, select="lastName", returnAs="query")>
		<cfset assert("IsQuery(loc.associationResult) AND ListLen(loc.associationResult.columnList) IS 1 AND IsQuery(loc.finderResult) AND loc.associationResult.lastName IS loc.finderResult.lastName")>
	</cffunction>

	<cffunction name="test_checking_if_parent_exists">
		<cfset loc.obj = model("post").findOne(order="id")>
		<cfset loc.associationResult = loc.obj.hasAuthor()>
		<cfset loc.finderResult = model("author").exists(loc.obj.authorId)>
		<cfset assert("loc.associationResult IS loc.finderResult")>
	</cffunction>

</cfcomponent>