<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="ControllerWithModel")>
		<cfset loc.args = {}>
		<cfset loc.args.objectName = "user">
		<cfset loc.args.label = false>
	</cffunction>

	<cffunction name="test_dateselect_parsing_and_passed_month">
		<cfset loc.args.property = "birthday">
		<cfset loc.args.order = "month">
		<cfset debug("loc.controller.dateSelect(argumentcollection=loc.args)", false)>
		<cfset loc.e = dateSelect_month_str(loc.args.property)>
		<cfset loc.r = loc.controller.dateSelect(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
		<cfset loc.args.property = "birthdaymonth">
		<cfset loc.e = dateSelect_month_str(loc.args.property)>
		<cfset loc.r = loc.controller.dateSelect(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="dateSelect_month_str">
		<cfargument name="property" type="string" required="true">
		<cfreturn '<select id="user-#arguments.property#-month" name="user[#arguments.property#]($month)"><option value="1">January</option><option value="2">February</option><option value="3">March</option><option value="4">April</option><option value="5">May</option><option value="6">June</option><option value="7">July</option><option value="8">August</option><option value="9">September</option><option value="10">October</option><option selected="selected" value="11">November</option><option value="12">December</option></select>'>
	</cffunction>

	<cffunction name="test_dateselect_parsing_and_passed_year">
		<cfset loc.args.property = "birthday">
		<cfset loc.args.order = "year">
		<cfset loc.args.startyear = "1973">
		<cfset loc.args.endyear = "1976">
		<cfset debug("loc.controller.dateSelect(argumentcollection=loc.args)", false)>
		<cfset loc.e = dateSelect_year_str(loc.args.property)>
		<cfset loc.r = loc.controller.dateSelect(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
		<cfset loc.args.property = "birthdayyear">
		<cfset loc.e = dateSelect_year_str(loc.args.property)>
		<cfset loc.r = loc.controller.dateSelect(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_dateselect_year_is_less_than_startyear">
		<cfset loc.args.property = "birthday">
		<cfset loc.args.order = "year">
		<cfset loc.args.startyear = "1976">
		<cfset loc.args.endyear = "1980">
		<cfset debug("loc.controller.dateSelect(argumentcollection=loc.args)", false)>
		<cfset loc.e = '<select id="user-birthday-year" name="user[birthday]($year)"><option selected="selected" value="1975">1975</option><option value="1976">1976</option><option value="1977">1977</option><option value="1978">1978</option><option value="1979">1979</option><option value="1980">1980</option></select>'>
		<cfset loc.r = loc.controller.dateSelect(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="dateSelect_year_str">
		<cfargument name="property" type="string" required="true">
		<cfreturn '<select id="user-#arguments.property#-year" name="user[#arguments.property#]($year)"><option value="1973">1973</option><option value="1974">1974</option><option selected="selected" value="1975">1975</option><option value="1976">1976</option></select>'>
	</cffunction>

</cfcomponent>