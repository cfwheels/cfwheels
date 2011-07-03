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
	
	<cffunction name="test_splitting_lable_classes">
		<cfset loc.labelClass = "month,day,year">
		<cfset loc.r = loc.controller.dateTimeSelect(objectName="user", property="birthday", label="labelMonth,labelDay,labelYear", labelClass="#loc.labelClass#")>
		<cfloop list="#loc.labelClass#" index="loc.i">
			<cfset loc.e = 'label class="#loc.i#"'>
			<cfset assert('loc.r Contains loc.e')>
		</cfloop>
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
	
	<cffunction name="test_ampm_select_coming_is_displayed_twice">
		<cfset loc.r = loc.controller.dateTimeSelect(objectName='user', property='birthday', dateOrder='month,day,year', monthDisplay='abbreviations', twelveHour='true', label='')>
		<cfset loc.a = ReMatchNoCase("user\[birthday\]\(\$ampm\)", loc.r)>
		<cfset assert('ArrayLen(loc.a) eq 1')>
	</cffunction>

</cfcomponent>