<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
	</cffunction>

	<cffunction name="test_not_checked">
		<cfset loc.e = loc.controller.checkBoxTag(name="subscribe", value="1", label="Subscribe to our newsletter", checked=false)>
		<cfset loc.r = '<label for="subscribe-1">Subscribe to our newsletter<input id="subscribe-1" name="subscribe" type="checkbox" value="1" /></label>'>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_checked">
		<cfset loc.e = loc.controller.checkBoxTag(name="subscribe", value="1", label="Subscribe to our newsletter", checked=true)>
		<cfset loc.r = '<label for="subscribe-1">Subscribe to our newsletter<input checked="checked" id="subscribe-1" name="subscribe" type="checkbox" value="1" /></label>'>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_value_blank_and_not_checked">
		<cfset loc.e = loc.controller.checkBoxTag(name="gender", value="", checked=false)>
		<cfset loc.r = '<input id="gender" name="gender" type="checkbox" value="" />'>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

</cfcomponent>