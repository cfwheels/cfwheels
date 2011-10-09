<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset model("post").$registerCallback(type="afterFind", methods="afterFindCallback")>
	</cffunction>
	
	<cffunction name="teardown">
		<cfset model("post").$clearCallbacks(type="afterFind")>
	</cffunction>

	<cffunction name="test_property_named_method_should_not_clash_with_cfinvoke">
		<cfset loc.results = model("collisionTest").findAll(returnAs="objects")>
		<cfset assert("loc.results[1].method IS 'done'")>
	</cffunction>
	
	<cffunction name="test_setting_one_query_record">
		<cfset loc.posts = model("post").findAll(maxRows=1, order="id DESC")>
		<cfset assert("loc.posts.views[1] IS 102 AND loc.posts['title'][1] IS 'setTitle'")>
	</cffunction>

	<cffunction name="test_setting_one_query_record_with_skipped_callback">
		<cfset loc.posts = model("post").findAll(maxRows=1, order="id DESC")>
		<cfset assert("loc.posts.views[1] IS 102 AND loc.posts['title'][1] IS 'setTitle'")>
	</cffunction>

	<cffunction name="test_setting_multiple_query_records">
		<cfset loc.posts = model("post").findAll(order="id DESC")>
		<cfset assert("loc.posts.views[1] IS 102 AND loc.posts.views[2] IS 103 AND loc.posts['title'][1] IS 'setTitle'")>
	</cffunction>

	<cffunction name="test_setting_multiple_query_records_with_skipped_callback">
		<cfset loc.posts = model("post").findAll(order="id DESC", callbacks=false)>
		<cfset assert("loc.posts.views[1] IS '2' AND loc.posts.views[2] IS '3' AND loc.posts.title[1] IS 'Title for fifth test post'")>
	</cffunction>

	<cffunction name="test_setting_property_on_one_object">
		<cfset loc.post = model("post").findOne()>
		<cfset assert("loc.post.title IS 'setTitle'")>
	</cffunction>

	<cffunction name="test_setting_property_on_one_object_with_skipped_callback">
		<cfset loc.post = model("post").findOne(callbacks=false)>
		<cfset assert("loc.post.title IS 'Title for first test post'")>
	</cffunction>

	<cffunction name="test_setting_properties_on_multiple_objects">
		<cfset loc.posts = model("post").findAll(returnAs="objects")>
		<cfset assert("loc.posts[1].title IS 'setTitle' AND loc.posts[2].title IS 'setTitle'")>
	</cffunction>

	<cffunction name="test_setting_properties_on_multiple_objects_with_skipped_callback">
		<cfset loc.posts = model("post").findAll(returnAs="objects", callbacks=false)>
		<cfset assert("loc.posts[1].title IS 'Title for first test post' AND loc.posts[2].title IS 'Title for second test post'")>
	</cffunction>

	<cffunction name="test_creation_of_new_column_and_property">
		<cfset loc.posts = model("post").findAll(order="id DESC")>
		<cfset assert("loc.posts.something[1] eq 'hello world'")>
		<cfset loc.posts = model("post").findAll(returnAs="objects")>
		<cfset assert("loc.posts[1].something eq 'hello world'")>
	</cffunction>

</cfcomponent>