<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cffunction name="test_maximum">
		<cfset loc.result = model("post").maximum(property="views")>
		<cfset assert("loc.result IS 5")>
	</cffunction>

	<cffunction name="test_maximum_with_where">
		<cfset loc.result = model("post").maximum(property="views", where="title LIKE 'Title%'")>
		<cfset assert("loc.result IS 5")>
	</cffunction>

	<cffunction name="test_maximum_with_non_matching_where">
		<cfset loc.result = model("post").maximum(property="views", where="id=0")>
		<cfset assert("loc.result IS ''")>
	</cffunction>

</cfcomponent>