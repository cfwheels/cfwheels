<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
		<cfset loc.content = "<b>This ""is"" a test string & it should format properly</b>">
	</cffunction>

	<cffunction name="test_should_escape_html_entities">
		<cfset loc.e = loc.controller.h(loc.content)>
		<cfset loc.r = "&lt;b&gt;This &quot;is&quot; a test string &amp; it should format properly&lt;/b&gt;">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>