<cfcomponent extends="wheelsMapping.test">

	<cfset loadModels("post")>

	<cffunction name="test_average_all_with_integer">
		<cfset loc.result = loc.post.average(property="views")>
		<cfset assert("loc.result IS 3.25")>
	</cffunction>

	<cffunction name="test_average_all_with_float">
		<cfset loc.result = loc.post.average(property="averageRating")>
		<cfset assert("loc.result IS 3.4")>
	</cffunction>
	
</cfcomponent>