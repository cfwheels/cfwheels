<cfcomponent extends="wheelsMapping.test">

	<!--- <cffunction name="test_contains_multiple_spaces_tabs_and_carriage_returns">
		<cfset loc.r = model("post").findAll(where="views

					 >=
					   5   		   AND
		  averagerating
		   >
		   				3")>
		<cfset assert('loc.r.recordcount eq 1')>
	</cffunction> --->
	
	<cffunction name="test_should_not_strip_extra_whitespace_from_values">
		<cfset loc.r = model("user").findAll(where="address = '123     Petruzzi St.'")>
		<cfset assert('loc.r.recordcount eq 0')>
		<cfset loc.r = model("user").findAll(where="address = '123 Petruzzi St.'")>
		<cfset assert('loc.r.recordcount eq 2')>
	</cffunction>

	<cffunction name="test_in_statment_should_not_error">
		<cfset loc.r = model("user").findAll(where="username IN('tonyp','perd','chrisp') AND (firstname = 'tony' OR firstname = 'per' OR firstname = 'chris') OR id IN(1,2,3)")>
		<cfset assert('loc.r.recordcount eq 3')>
	</cffunction>
	
	<cffunction name="test_in_statment_respect__parenthesis_commas_and_single_quotes">
		<cfset loc.r = model("user").findAll(where="username IN('tony''s','pe''(yo,yo)rd','chrisp')")>
		<cfset assert('loc.r.recordcount eq 1')>
	</cffunction>

</cfcomponent>