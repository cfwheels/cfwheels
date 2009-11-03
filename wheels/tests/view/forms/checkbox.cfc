<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.tests._assets.controllers.ControllerWithModel")>
	<cfset global.model = createobject("component", "wheelsMapping.tests._assets.models.ModelUsers")>
	<cfset global.args= {}>
	<cfset global.args.objectName = "ModelUsers1">
	
	<cffunction name="test_checked_when_property_value_equals_checkedValue">
		<cfset loc.args.property = "birthdaymonth">
		<cfset loc.args.checkedvalue = "11">
		<cfset halt(false, "loc.controller.checkBox(argumentcollection=loc.args)")>
		<cfset loc.e = '<input checked="checked" id="ModelUsers1-birthdaymonth" name="ModelUsers1[birthdaymonth]" type="checkbox" value="11" /><input name="ModelUsers1[birthdaymonth]($checkbox)" type="hidden" value="0" />'>
		<cfset loc.r = loc.controller.checkBox(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
		<cfset loc.args.checkedvalue = "12">
		<cfset halt(false, "loc.controller.checkBox(argumentcollection=loc.args)")>
		<cfset loc.e = '<input id="ModelUsers1-birthdaymonth" name="ModelUsers1[birthdaymonth]" type="checkbox" value="12" /><input name="ModelUsers1[birthdaymonth]($checkbox)" type="hidden" value="0" />'>
		<cfset loc.r = loc.controller.checkBox(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>
	
</cfcomponent>