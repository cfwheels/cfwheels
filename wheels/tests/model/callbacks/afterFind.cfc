<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cffunction name="test_setting_one_query_record">
		<cfset model("post").$registerCallback(type="afterFind", methods="afterFindCallback")>
		<cfset loc.posts = model("post").findAll(maxRows=1, order="id DESC")>
		<cfset model("post").$clearCallbacks(type="afterFind")>
		<cfset assert("loc.posts['views'][1] IS 103 AND loc.posts['title'][1] IS 'setOnQueryRecord'")>
	</cffunction>

	<cffunction name="test_setting_multiple_query_records">
		<cfset model("post").$registerCallback(type="afterFind", methods="afterFindCallback")>
		<cfset loc.posts = model("post").findAll(order="id DESC")>
		<cfset model("post").$clearCallbacks(type="afterFind")>
		<cfset assert("loc.posts['views'][1] IS 103 AND loc.posts['views'][2] IS 100 AND loc.posts['title'][1] IS 'setOnQueryRecord'")>
	</cffunction>

	<cffunction name="test_setting_property_on_one_object">
		<cfset model("post").$registerCallback(type="afterFind", methods="afterFindCallback")>
		<cfset loc.post = model("post").findOne()>
		<cfset model("post").$clearCallbacks(type="afterFind")>
		<cfset assert("loc.post.title IS 'setOnObject'")>
	</cffunction>

	<cffunction name="test_setting_properties_on_multiple_objects">
		<cfset model("post").$registerCallback(type="afterFind", methods="afterFindCallback")>
		<cfset loc.posts = model("post").findAll(returnAs="objects")>
		<cfset model("post").$clearCallbacks(type="afterFind")>
		<cfset assert("loc.posts[1].title IS 'setOnObject' AND loc.posts[2].title IS 'setOnObject'")>
	</cffunction>

</cfcomponent>