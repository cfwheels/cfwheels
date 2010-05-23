<cfcomponent extends="wheelsMapping.test">

	<cffunction name="test_contains_multiple_spaces_tabs_and_carriage_returns">
		<cfset loc.r = model("post").findAll(where="views

					 >=
					   5   		   AND
		  averagerating
		   >
		   				3")>
		<cfset assert('loc.r.recordcount eq 1')>
	</cffunction>

	<cffunction name="test_in_statment_should_not_error">
		<cfset loc.r = model("post").findAll(where="views IN(5,3)")>
		<cfset assert('loc.r.recordcount eq 3')>
	</cffunction>

</cfcomponent>