<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

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

</cfcomponent>