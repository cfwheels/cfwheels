<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset model("post").$registerCallback(type="afterFind", methods="afterFindCallback")>
	</cffunction>
	
	<cffunction name="teardown">
		<cfset model("post").$clearCallbacks(type="afterFind")>
	</cffunction>

	<cffunction name="test_setting_property_on_one_object">
		<cfset loc.post = model("post").findOne()>
		<cfset assert("loc.post.title IS 'setTitle'")>
	</cffunction>

	<cffunction name="test_setting_properties_on_multiple_objects">
		<cfset loc.postsOrg = model("post").findAll(returnAs="objects", callbacks="false", orderby="views DESC")>
		<cfset loc.views1 = loc.postsOrg[1].views + 100>
		<cfset loc.views2 = loc.postsOrg[2].views + 100>
		<cfset loc.posts = model("post").findAll(returnAs="objects", orderby="views DESC")>
		<cfset assert("loc.posts[1].title IS 'setTitle'")>
		<cfset assert("loc.posts[2].title IS 'setTitle'")>
		<cfset assert("loc.posts[1].views EQ loc.views1")>
		<cfset assert("loc.posts[2].views EQ loc.views2")>
	</cffunction>

	<cffunction name="test_creation_of_new_column_and_property">
		<cfset loc.posts = model("post").findAll(order="id DESC")>
		<cfset assert("loc.posts.something[1] eq 'hello world'")>
		<cfset loc.posts = model("post").findAll(returnAs="objects")>
		<cfset assert("loc.posts[1].something eq 'hello world'")>
	</cffunction>

</cfcomponent>