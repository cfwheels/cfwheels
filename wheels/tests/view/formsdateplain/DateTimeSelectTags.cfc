<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset pkg.controller = controller("dummy")>
		<cfset result = "">
		<cfset results = {}>
		<cfset loc.controller = controller(name="dummy")>
		<cfset loc.args = {}>
		<cfset loc.args.label = false>
	</cffunction>

	<cffunction name="testNoLabels">
		<cfset result = pkg.controller.dateTimeSelectTags(name="theName", label=false)>
		<cfset assert("result Does Not Contain 'label'")>
	</cffunction>

	<cffunction name="testSameLabels">
		<cfset var loc = {}>
		<cfset loc.str = pkg.controller.dateTimeSelectTags(name="theName", label="lblText")>
		<cfset loc.sub = "lblText">
		<cfset result = (Len(loc.str)-Len(Replace(loc.str,loc.sub,"","all")))/Len(loc.sub)>
		<cfset assert("result IS 6")>
	</cffunction>

	<cffunction name="testSplittingLabels">
		<cfset result = pkg.controller.dateTimeSelectTags(name="theName", label="labelMonth,labelDay,labelYear,labelHour,labelMinute,labelSecond")>
		<cfset assert("result Contains 'labelDay' AND result Contains 'labelSecond'")>
	</cffunction>

	<cffunction name="test_dateTimeSelectTags_blank_included_boolean">
		<cfset loc.args.name = "dateselector">
		<cfset loc.args.includeBlank = "true">
		<cfset loc.args.selected = "">
		<cfset loc.args.startyear = "2000">
		<cfset loc.args.endyear = "1990">
		<cfset loc.r = loc.controller.dateTimeSelectTags(argumentcollection=loc.args)>
		<cfset loc.e = '<option selected="selected" value=""></option>'>
		<cfset assert("loc.r contains loc.e")>
		<cfset loc.args.selected = "01/02/2000">
		<cfset loc.r = loc.controller.dateTimeSelectTags(argumentcollection=loc.args)>
		<cfset debug('loc.r', false)>
		<cfset loc.e1 = '<option selected="selected" value="1">January</option>'>
		<cfset loc.e2 = '<option selected="selected" value="2">2</option>'>
		<cfset loc.e3 = '<option selected="selected" value="2000">2000</option>'>
		<cfset assert("loc.r contains loc.e1 && loc.r contains loc.e2 && loc.r contains loc.e3")>
	</cffunction>

	<cffunction name="test_dateTimeSelectTags_blank_included_string">
		<cfset loc.args.name = "dateselector">
		<cfset loc.args.includeBlank = "--Month--">
		<cfset loc.args.selected = "">
		<cfset loc.args.startyear = "2000">
		<cfset loc.args.endyear = "1990">
		<cfset loc.r = loc.controller.dateTimeSelectTags(argumentcollection=loc.args)>
		<cfset loc.e = '<option selected="selected" value="">--Month--</option>'>
		<cfset assert("loc.r contains loc.e")>
		<cfset loc.args.selected = "01/02/2000">
		<cfset loc.r = loc.controller.dateTimeSelectTags(argumentcollection=loc.args)>
		<cfset debug('loc.r', false)>
		<cfset loc.e1 = '<option selected="selected" value="1">January</option>'>
		<cfset loc.e2 = '<option selected="selected" value="2">2</option>'>
		<cfset loc.e3 = '<option selected="selected" value="2000">2000</option>'>
		<cfset assert("loc.r contains loc.e1 && loc.r contains loc.e2 && loc.r contains loc.e3")>
	</cffunction>

	<cffunction name="test_dateTimeSelectTags_blank_not_included">
		<cfset loc.args.name = "dateselector">
		<cfset loc.args.includeBlank = "false">
		<cfset loc.args.selected = "">
		<cfset loc.args.startyear = "2000">
		<cfset loc.args.endyear = "1990">
		<cfset loc.r = loc.controller.dateTimeSelectTags(argumentcollection=loc.args)>
		<cfset loc.e = '<option selected="selected" value=""></option>'>
		<cfset assert("loc.r does not contain loc.e")>
		<cfset loc.args.selected = "01/02/2000">
		<cfset loc.r = loc.controller.dateTimeSelectTags(argumentcollection=loc.args)>
		<cfset debug('loc.r', false)>
		<cfset loc.e1 = '<option selected="selected" value="1">January</option>'>
		<cfset loc.e2 = '<option selected="selected" value="2">2</option>'>
		<cfset loc.e3 = '<option selected="selected" value="2000">2000</option>'>
		<cfset assert("loc.r contains loc.e1 && loc.r contains loc.e2 && loc.r contains loc.e3")>
	</cffunction>

</cfcomponent>