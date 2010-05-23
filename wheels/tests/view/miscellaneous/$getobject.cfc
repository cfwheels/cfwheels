<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/view/miscellaneous.cfm">

	<cffunction name="test_getting_object_from_session_scope">
		<cfset session.obj = model("post").findOne()>
		<cfset loc.result = $getObject("session.obj")>
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