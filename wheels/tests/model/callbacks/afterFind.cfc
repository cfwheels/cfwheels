<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cffunction name="test_setting_one_query_record">
		<cfset model("post").$registerCallback(type="afterFind", methods="afterFindCallback")>
		<cfset loc.posts = model("post").findAll(maxRows=1, order="id DESC", reload=true)>
		<cfset model("post").$clearCallbacks(type="afterFind")>
		<cfset assert("loc.posts.views[1] IS 103 AND loc.posts['title'][1] IS 'setOnQueryRecord'")>
	</cffunction>

	<cffunction name="test_setting_one_query_record_with_skipped_callback">
		<cfset model("post").$registerCallback(type="afterFind", methods="afterFindCallback")>
		<cfset loc.posts = model("post").findAll(maxRows=1, order="id DESC", reload=true)>
		<cfset model("post").$clearCallbacks(type="afterFind")>
		<cfset assert("loc.posts.views[1] IS 103 AND loc.posts['title'][1] IS 'setOnQueryRecord'")>
	</cffunction>

	<cffunction name="test_setting_multiple_query_records">
		<cfset model("post").$registerCallback(type="afterFind", methods="afterFindCallback")>
		<cfset loc.posts = model("post").findAll(order="id DESC", reload=true)>
		<cfset model("post").$clearCallbacks(type="afterFind")>
		<cfset assert("loc.posts.views[1] IS 103 AND loc.posts.views[2] IS 100 AND loc.posts['title'][1] IS 'setOnQueryRecord'")>
	</cffunction>

	<cffunction name="test_setting_multiple_query_records_with_skipped_callback">
		<cfset model("post").$registerCallback(type="afterFind", methods="afterFindCallback")>
		<cfset loc.posts = model("post").findAll(order="id DESC", callbacks=false, reload=true)>
		<cfset model("post").$clearCallbacks(type="afterFind")>
		<cfset assert("loc.posts.views[1] IS '3' AND loc.posts.views[2] IS 0 AND loc.posts.title[1] IS 'Title for fourth test post'")>
	</cffunction>

	<cffunction name="test_setting_property_on_one_object">
		<cfset model("post").$registerCallback(type="afterFind", methods="afterFindCallback")>
		<cfset loc.post = model("post").findOne(reload=true)>
		<cfset model("post").$clearCallbacks(type="afterFind")>
		<cfset assert("loc.post.title IS 'setOnObject'")>
	</cffunction>

	<cffunction name="test_setting_property_on_one_object_with_skipped_callback">
		<cfset model("post").$registerCallback(type="afterFind", methods="afterFindCallback")>
		<cfset loc.post = model("post").findOne(callbacks=false, reload=true)>
		<cfset model("post").$clearCallbacks(type="afterFind")>
		<cfset assert("loc.post.title IS 'Title for first test post'")>
	</cffunction>

	<cffunction name="test_setting_properties_on_multiple_objects">
		<cfset model("post").$registerCallback(type="afterFind", methods="afterFindCallback")>
		<cfset loc.posts = model("post").findAll(returnAs="objects", reload=true)>
		<cfset model("post").$clearCallbacks(type="afterFind")>
		<cfset assert("loc.posts[1].title IS 'setOnObject' AND loc.posts[2].title IS 'setOnObject'")>
	</cffunction>

	<cffunction name="test_setting_properties_on_multiple_objects_with_skipped_callback">
		<cfset model("post").$registerCallback(type="afterFind", methods="afterFindCallback")>
		<cfset loc.posts = model("post").findAll(returnAs="objects", callbacks=false, reload=true)>
		<cfset model("post").$clearCallbacks(type="afterFind")>
		<cfset assert("loc.posts[1].title IS 'Title for first test post' AND loc.posts[2].title IS 'Title for second test post'")>
	</cffunction>

</cfcomponent>