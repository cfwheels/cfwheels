<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = $controller(name="dummy")>
	</cffunction>

	<cffunction name="test_contentFor_and_yield_assigning_section">
		<cfset loc.a = ["head1", "head2", "head3"]>
		<cfloop array="#loc.a#" index="loc.i">
			<cfset loc.controller.contentFor("head", loc.i)>
		</cfloop>
		<cfset loc.e = ArrayToList(loc.a, chr(10))>
		<cfset loc.r = loc.controller.yield("head")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_contentFor_and_yield_default_section">
		<cfset loc.a = ["layout1", "layout2", "layout3"]>
		<cfloop array="#loc.a#" index="loc.i">
			<cfset loc.controller.contentFor("layout", loc.i)>
		</cfloop>
		<cfset loc.e = ArrayToList(loc.a, chr(10))>
		<cfset loc.r = loc.controller.yield()>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_yield_invalid_section_returns_blank">
		<cfset loc.r = loc.controller.yield("somethingstupid")>
		<cfset assert('loc.r eq ""')>
	</cffunction>

</cfcomponent>