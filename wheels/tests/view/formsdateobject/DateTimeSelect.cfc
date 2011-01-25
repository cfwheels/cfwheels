<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="ControllerWithModel")>
		<cfset loc.args= {}>
		<cfset loc.args.objectName = "user">
		<cfset loc.args.label = false>
		
		<cfset loc.selected = {}>
		<cfset loc.selected.month = '<option selected="selected" value="11">November</option>'>
		<cfset loc.selected.day = '<option selected="selected" value="1">1</option>'>
		<cfset loc.selected.year = '<option selected="selected" value="1975">1975</option>'>
	</cffunction>

	<cffunction name="testSplittingLabels">
		<cfset result = loc.controller.dateTimeSelect(objectName="user", property="birthday", label="labelMonth,labelDay,labelYear,labelHour,labelMinute,labelSecond")>
		<cfset assert("result Contains 'labelDay' AND result Contains 'labelSecond'")>
	</cffunction>

	<cffunction name="test_datetimeselect">
		<cfset loc.args.property = "birthday">
		<cfset loc.r = loc.controller.dateTimeSelect(argumentcollection=loc.args)>
		<cfset assert("loc.r contains loc.selected.month")>
		<cfset assert("loc.r contains loc.selected.day")>
		<cfset assert("loc.r contains loc.selected.year")>
	</cffunction>

	<cffunction name="test_datetimeselect_not_combined">
		<cfset loc.args.property = "birthday">
		<cfset loc.args.combine = "false">
		<cfset loc.r = loc.controller.dateTimeSelect(argumentcollection=loc.args)>
		<cfset assert("loc.r contains loc.selected.month")>
		<cfset assert("loc.r contains loc.selected.day")>
		<cfset assert("loc.r contains loc.selected.year")>
	</cffunction>

</cfcomponent>