<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset loc.controller = createobject("component", "wheelsMapping.tests._assets.controllers.ControllerWithModel")>
		<cfset loc.args= {}>
		<cfset loc.args.objectName = "user">
	</cffunction>

	<cffunction name="test_checked_when_property_value_equals_checkedValue">
		<cfset loc.args.property = "birthdaymonth">
		<cfset loc.args.checkedvalue = "11">
		<cfset loc.e = '<input checked="checked" id="user-birthdaymonth" name="user[birthdaymonth]" type="checkbox" value="11" /><input name="user[birthdaymonth]($checkbox)" type="hidden" value="0" />'>
		<cfset loc.r = loc.controller.checkBox(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
		<cfset loc.args.checkedvalue = "12">
		<cfset loc.e = '<input id="user-birthdaymonth" name="user[birthdaymonth]" type="checkbox" value="12" /><input name="user[birthdaymonth]($checkbox)" type="hidden" value="0" />'>
		<cfset loc.r = loc.controller.checkBox(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>