<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.tests._assets.controllers.ControllerWithModel")>
	<cfset global.model = createobject("component", "wheelsMapping.tests._assets.models.ModelUsers")>
	<cfset global.args= {}>
	<cfset global.args.objectName = "ModelUsers1">
	
	<cffunction name="test_checked_when_property_value_equals_checkedValue">
		<cfset loc.args.property = "birthdaymonth">
		<cfset loc.args.checkedvalue = "11">
		<cfset halt(false, "loc.controller.checkBox(argumentcollection=loc.args)")>
		<cfset loc.e = '<input type="checkbox" value="11" id="ModelUsers1-birthdaymonth" name="ModelUsers1[birthdaymonth]" checked="checked" /><input value="0" type="hidden" name="ModelUsers1[birthdaymonth]($checkbox)" />'>
		<cfset loc.r = loc.controller.checkBox(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
		<cfset loc.args.checkedvalue = "12">
		<cfset halt(false, "loc.controller.checkBox(argumentcollection=loc.args)")>
		<cfset loc.e = '<input type="checkbox" value="12" id="ModelUsers1-birthdaymonth" name="ModelUsers1[birthdaymonth]" /><input value="0" type="hidden" name="ModelUsers1[birthdaymonth]($checkbox)" />'>
		<cfset loc.r = loc.controller.checkBox(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>
	
</cfcomponent>