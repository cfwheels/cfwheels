<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
	</cffunction>

	<cffunction name="test_overload_properties">
		<cfset loc.r = loc.controller.textAreaTag(name="TestingThisOut", rows=10, cols=20)>
		<cfset assert('loc.r contains "rows=""10"""')>
		<cfset assert('loc.r contains "cols=""20"""')>
	</cffunction>

</cfcomponent>