<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset loc.controller = $controller(name="dummy")/>
	</cffunction>

	<cffunction name="test_flashClear_valid">
		<cfset session.flash = {} />
		<cfset loc.controller.flashInsert(success="congrats!") />
		<cfset loc.controller.flashClear() />
		<cfset loc.flashKeyList = StructKeyList(loc.controller.flash()) />
		<cfset assert("loc.flashKeyList eq ''") />
	</cffunction>

</cfcomponent>
