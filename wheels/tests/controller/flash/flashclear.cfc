<cfcomponent extends="wheels.test">

	<cfset global.controller = createobject("component", "wheels.controller") />
	
	<cffunction name="test_flashClear_valid">
		<cfset session.flash = {} />
		<cfset loc.controller.flashInsert(success="congrats!") />
		<cfset loc.controller.flashClear() />
		<cfset loc.flashKeyList = StructKeyList(loc.controller.flash()) />
		<cfset assert("loc.flashKeyList eq ''") />
	</cffunction>
	
</cfcomponent>
