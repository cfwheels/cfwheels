<cfcomponent extends="wheels.Test">

	<cffunction name="test_findAllKeys">
		<cfset loc.p = model("post").findAll(select="id")>
		<cfset loc.posts = model("post").findAllKeys()>
		<cfset loc.keys = ValueList(loc.p.id)>
		<cfset assert('loc.posts eq loc.keys')>
		<cfset loc.p = model("post").findAll(select="id")>
		<cfset loc.posts = model("post").findAllKeys(quoted=true)>
		<cfset loc.keys = QuotedValueList(loc.p.id)>
	</cffunction>

</cfcomponent>