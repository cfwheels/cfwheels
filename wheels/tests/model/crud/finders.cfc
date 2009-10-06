<cfcomponent extends="wheelsMapping.test">

	<cfset global.user = createobject("component", "wheelsMapping.model").$initModelClass("Users")>

	<cffunction name="test_select_distinct_addresses">
		<cfset loc.q = loc.user.findAll(select="address", distinct="true", order="address")>
		<cfset assert('loc.q.recordcount eq 4')>
		<cfset loc.e = "123 Petruzzi St.|456 Peters Dr.|789 Djurner Ave.|987 Riera Blvd.">
		<cfset loc.r = valuelist(loc.q.address, "|")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
<!---
	TODO: uncomment once james' patch for group by is integrated
	<cffunction name="test_select_users_groupby_address">
		<cfset loc.q = loc.user.findAll(select="address", group="address", order="address", result="loc.result")>
		<cfset assert('loc.q.recordcount eq 4')>
		<cfset loc.e = "123 Petruzzi St.|456 Peters Dr.|789 Djurner Ave.|987 Riera Blvd.">
		<cfset loc.r = valuelist(loc.q.address, "|")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
 --->
 
 	<cffunction name="test_findByKey_valid">
		<cfset fail()>
	</cffunction>
 
 	<cffunction name="test_findOne_valid">
		<cfset fail()>
	</cffunction>
 
 	<cffunction name="test_findAll_valid">
		<cfset fail()>
	</cffunction>
	
	<cffunction name="test_findOneByXXX_valid">
		<cfset fail()>
	</cffunction>
	
	<cffunction name="test_findAllByXXX_valid">
		<cfset fail()>
	</cffunction>
	
	<cffunction name="test_exists_valid">
		<cfset fail()>
	</cffunction>

</cfcomponent>