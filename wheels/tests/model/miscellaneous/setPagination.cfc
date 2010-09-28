<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.user = model("user")>
	</cffunction>

	<cffunction name="test_only_totalRecords">
		<cfset loc.user.setPagination(100)>
		<cfset assert_pagination(handle="query", totalRecords=100)>
	</cffunction>
	
	<cffunction name="test_all_arguments">
		<cfset loc.user.setPagination(1000, 4, 50, "pageTest")>
		<cfset assert_pagination(handle="pageTest", totalRecords=1000, currentPage=4, perPage=50)>
	</cffunction>
	
	<cffunction name="test_totalRecords_less_than_zero">
		<cfset loc.user.setPagination(-5, 4, 50, "pageTest")>
		<cfset assert_pagination(handle="pageTest", totalRecords=0, currentPage=1, perPage=50)>
	</cffunction>
	
	<cffunction name="test_currentPage_less_than_one">
		<cfset loc.user.setPagination(1000, -4, 50, "pageTest")>
		<cfset assert_pagination(handle="pageTest", totalRecords=1000, currentPage=1, perPage=50)>
	</cffunction>
	
	<cffunction name="test_numeric_arguments_must_be_integers">
		<cfset loc.user.setPagination(1000.9998, 5.876, 50.847, "pageTest")>
		<cfset assert_pagination(handle="pageTest", totalRecords=1000, currentPage=5, perPage=50)>
	</cffunction>

	<cffunction name="assert_pagination">
		<cfargument name="handle" type="string" required="true">
		<cfset loc.args = arguments>
		<cfset assert('StructKeyExists(request.wheels, loc.args.handle)')>
		<cfset loc.p = request.wheels[loc.args.handle]>
		<cfset StructDelete(loc.args, "handle", false)>
		<cfloop collection="#loc.args#" item="loc.i">
			<cfset assert('loc.p[loc.i] eq loc.args[loc.i]')>
		</cfloop>
	</cffunction>

</cfcomponent>