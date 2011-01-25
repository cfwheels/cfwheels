<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_table_not_found">
		<cfset loc.e = raised("model('table_not_found')")>
		<cfset debug("loc.e", false)>
		<cfset loc.r = "Wheels.TableNotFound">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_no_primary_key">
		<cfset loc.e = raised("model('noPrimaryKey')")>
		<cfset debug("loc.e", false)>
		<cfset loc.r = "Wheels.NoPrimaryKey">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_bykey_methods_should_raise_error_with_key_argument">
		<cfset post = model("post")>
		<cfset loc.e = raised('post.deleteByKey(key="1,2")')>
		<cfset loc.r = "Wheels.InvalidArgumentValue">
		<cfset assert("loc.e eq loc.r")>
		<cfset loc.e = raised('post.findByKey(key="1,2")')>
		<cfset loc.r = "Wheels.InvalidArgumentValue">
		<cfset assert("loc.e eq loc.r")>
		<cfset loc.e = raised('post.updateByKey(key="1,2", title="testing")')>
		<cfset loc.r = "Wheels.InvalidArgumentValue">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>