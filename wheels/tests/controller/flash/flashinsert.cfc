<cfcomponent extends="wheelsMapping.test">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>

	<cffunction name="setup">
		<cfset controller.flashClear()>
	</cffunction>

	<cffunction name="test_flashInsert_valid">
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset assert("controller.flash('success') IS 'Congrats!'")>
	</cffunction>

	<cffunction name="test_flashInsert_mulitple">
		<cfset controller.flashInsert(success="Hooray!!!", error="WTF!")>
		<cfset assert("controller.flash('success') IS 'Hooray!!!'")>
		<cfset assert("controller.flash('error') IS 'WTF!'")>
	</cffunction>

</cfcomponent>
