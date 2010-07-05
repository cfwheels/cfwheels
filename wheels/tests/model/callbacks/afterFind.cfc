<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset model("post").$registerCallback(type="afterFind", methods="afterFindCallback")>
	</cffunction>
	
	<cffunction name="teardown">
		<cfset model("post").$clearCallbacks(type="afterFind")>
	</cffunction>

	<cffunction name="test_setting_one_query_record">
		<cfset loc.posts = model("post").findAll(maxRows=1, order="id DESC")>
		<cfset assert("loc.posts.views[1] IS 103 AND loc.posts['title'][1] IS 'setOnQueryRecord'")>
	</cffunction>

	<cffunction name="test_setting_one_query_record_with_skipped_callback">
		<cfset loc.posts = model("post").findAll(maxRows=1, order="id DESC")>
		<cfset assert("loc.posts.views[1] IS 103 AND loc.posts['title'][1] IS 'setOnQueryRecord'")>
	</cffunction>

	<cffunction name="test_setting_multiple_query_records">
		<cfset loc.posts = model("post").findAll(order="id DESC")>
		<cfset assert("loc.posts.views[1] IS 103 AND loc.posts.views[2] IS 100 AND loc.posts['title'][1] IS 'setOnQueryRecord'")>
	</cffunction>

	<cffunction name="test_setting_multiple_query_records_with_skipped_callback">
		<cfset loc.posts = model("post").findAll(order="id DESC", callbacks=false)>
		<cfset assert("loc.posts.views[1] IS '3' AND loc.posts.views[2] IS 0 AND loc.posts.title[1] IS 'Title for fourth test post'")>
	</cffunction>

	<cffunction name="test_setting_property_on_one_object">
		<cfset loc.post = model("post").findOne()>
		<cfset assert("loc.post.title IS 'setOnObject'")>
	</cffunction>

	<cffunction name="test_setting_property_on_one_object_with_skipped_callback">
		<cfset loc.post = model("post").findOne(callbacks=false)>
		<cfset assert("loc.post.title IS 'Title for first test post'")>
	</cffunction>

	<cffunction name="test_setting_properties_on_multiple_objects">
		<cfset loc.posts = model("post").findAll(returnAs="objects")>
		<cfset assert("loc.posts[1].title IS 'setOnObject' AND loc.posts[2].title IS 'setOnObject'")>
	</cffunction>

	<cffunction name="test_setting_properties_on_multiple_objects_with_skipped_callback">
		<cfset loc.posts = model("post").findAll(returnAs="objects", callbacks=false)>
		<cfset assert("loc.posts[1].title IS 'Title for first test post' AND loc.posts[2].title IS 'Title for second test post'")>
	</cffunction>

</cfcomponent>