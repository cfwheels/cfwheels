<cfcomponent extends="wheels.test">

	<cffunction name="_setup">
		<cfset global = {}>
		<cfset global.controller = createobject("component", "wheels.tests.ControllerWithModel")>
		<cfset global.model = createobject("component", "wheels.tests.ModelUsers")>
		<cfset global.args= {}>
		<cfset global.args.objectName = "ModelUsers1">
	</cffunction>

	<cffunction name="setup">
		<cfset loc = {}>
		<cfset loc.a = duplicate(global.args)>
	</cffunction>
	
	<cffunction name="test_checked_when_property_value_equals_checkedValue">
		<cfset loc.a.property = "birthdaymonth">
		<cfset loc.a.checkedvalue = "11">
		<cfset halt(false, "global.controller.checkBox(argumentcollection=loc.a)")>
		<cfset loc.e = '<input type="checkbox" value="11" id="ModelUsers1-birthdaymonth" name="ModelUsers1[birthdaymonth]" checked="checked" /><input value="0" type="hidden" name="ModelUsers1[birthdaymonth]($checkbox)" />'>
		<cfset loc.r = global.controller.checkBox(argumentcollection=loc.a)>
		<cfset assert("loc.e eq loc.r")>
		<cfset loc.a.checkedvalue = "12">
		<cfset halt(false, "global.controller.checkBox(argumentcollection=loc.a)")>
		<cfset loc.e = '<input type="checkbox" value="12" id="ModelUsers1-birthdaymonth" name="ModelUsers1[birthdaymonth]" /><input value="0" type="hidden" name="ModelUsers1[birthdaymonth]($checkbox)" />'>
		<cfset loc.r = global.controller.checkBox(argumentcollection=loc.a)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>
	
</cfcomponent>