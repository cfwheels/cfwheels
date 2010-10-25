<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
	</cffunction>

	<cffunction name="test_with_struct">
		<cfset loc.args.objectname = {firstname="tony",lastname="petruzzi"}>
		<cfset loc.args.property = "lastname">

		<cfset loc.e = loc.controller.$tagid(argumentcollection=loc.args)>
		<cfset loc.r = "lastname">
		<cfset assert("loc.e eq loc.r")>

		<cfset loc.e = loc.controller.$tagname(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_with_string">
		<cfset loc.args.objectname = "wheelsMapping.Test.view.miscellaneous">
		<cfset loc.args.property = "lastname">

		<cfset loc.e = loc.controller.$tagid(argumentcollection=loc.args)>
		<cfset loc.r = "miscellaneous-lastname">
		<cfset assert("loc.e eq loc.r")>

		<cfset loc.e = loc.controller.$tagname(argumentcollection=loc.args)>
		<cfset loc.r = "miscellaneous[lastname]">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_with_array">
		<cfset loc.args.objectname = [1,2,3,4]>
		<cfset loc.args.property = "lastname">

		<cfset loc.e = loc.controller.$tagid(argumentcollection=loc.args)>
		<cfset loc.r = "lastname">
		<cfset assert("loc.e eq loc.r")>

		<cfset loc.e = loc.controller.$tagname(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>