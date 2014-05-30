<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_base_adapter">
		<cfset loc.e = raised("model('table_not_found')")>
		<cfset debug("loc.e", false)>
		<cfset loc.r = "Wheels.ModelBaseAdapter">
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

	<cffunction name="test_value_cannot_be_determined_in_where_clause">
		<cfset loc.e = raised('model("user").count(where="username = tony")')>
		<cfset loc.r = "Wheels.QueryParamValue">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>