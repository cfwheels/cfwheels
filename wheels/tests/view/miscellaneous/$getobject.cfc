<cfcomponent extends="wheelsMapping.Test">

	<cfinclude template="/wheelsMapping/view/miscellaneous.cfm">

	<cffunction name="test_getting_object_from_request_scope">
		<cfset request.obj = model("post").findOne()>
		<cfset loc.result = $getObject("request.obj")>
		<cfset assert("IsObject(loc.result)")>
	</cffunction>

	<cffunction name="test_getting_object_from_default_scope">
		<cfset obj = model("post").findOne()>
		<cfset loc.result = $getObject("obj")>
		<cfset assert("IsObject(loc.result)")>
	</cffunction>

	<cffunction name="test_getting_object_from_variables_scope">
		<cfset variables.obj = model("post").findOne()>
		<cfset loc.result = $getObject("variables.obj")>
		<cfset assert("IsObject(loc.result)")>
	</cffunction>

</cfcomponent>