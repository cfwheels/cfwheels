<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.params = {controller="dummy", action="dummy"}>
		<cfset loc.controller = controller("dummy", loc.params)>
	</cffunction>

	<cffunction name="test_contentFor_and_includeContent_assigning_section">
		<cfset loc.a = ["head1", "head2", "head3"]>
		<cfloop array="#loc.a#" index="loc.i">
			<cfset loc.controller.contentFor(head=loc.i)>
		</cfloop>
		<cfset loc.e = ArrayToList(loc.a, chr(10))>
		<cfset loc.r = loc.controller.includeContent("head")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_contentFor_and_includeContent_default_section">
		<cfset loc.a = ["layout1", "layout2", "layout3"]>
		<cfloop array="#loc.a#" index="loc.i">
			<cfset loc.controller.contentFor(body=loc.i)>
		</cfloop>
		<cfset loc.e = ArrayToList(loc.a, chr(10))>
		<cfset loc.r = loc.controller.includeContent()>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_includeContent_invalid_section_returns_blank">
		<cfset loc.r = loc.controller.includeContent("somethingstupid")>
		<cfset assert('loc.r eq ""')>
	</cffunction>
	
	<cffunction name="test_includeContent_returns_default">
		<cfset loc.r = loc.controller.includeContent("somethingstupid", "my default value")>
		<cfset assert('loc.r eq "my default value"')>
	</cffunction>

</cfcomponent>