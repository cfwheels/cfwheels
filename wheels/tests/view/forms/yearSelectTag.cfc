<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.tests._assets.controllers.ControllerWithModel")>
	<cfset global.args= {}>
	<cfset global.args.objectName = "user">
	<cfset global.args.property = "birthday">
	<cfset global.args.includeblank = false>
	<cfset global.args.order = "year">
	<cfset global.controller.changeBirthday = changeBirthday>
	
	<cffunction name="test_startyear_lt_endyear_value_lt_startyear">
		<cfset loc.args.startyear = "1980">
		<cfset loc.args.endyear = "1990">
		<cfset loc.r = loc.controller.dateSelect(argumentCollection=loc.args)>
		<cfset halt(false, 'loc.r')>
		<cfset loc.e = '<select id="user-birthday-year" name="user[birthday]($year)"><option selected="selected" value="1975">1975</option><option value="1976">1976</option><option value="1977">1977</option><option value="1978">1978</option><option value="1979">1979</option><option value="1980">1980</option><option value="1981">1981</option><option value="1982">1982</option><option value="1983">1983</option><option value="1984">1984</option><option value="1985">1985</option><option value="1986">1986</option><option value="1987">1987</option><option value="1988">1988</option><option value="1989">1989</option><option value="1990">1990</option></select>'>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_startyear_lt_endyear_value_gt_startyear">
		<cfset loc.controller.changeBirthday("1995")>
		<cfset loc.args.startyear = "1980">
		<cfset loc.args.endyear = "1990">
		<cfset loc.r = loc.controller.dateSelect(argumentCollection=loc.args)>
		<cfset halt(false, 'loc.r')>
		<cfset loc.e = '<select id="user-birthday-year" name="user[birthday]($year)"><option value="1980">1980</option><option value="1981">1981</option><option value="1982">1982</option><option value="1983">1983</option><option value="1984">1984</option><option value="1985">1985</option><option value="1986">1986</option><option value="1987">1987</option><option value="1988">1988</option><option value="1989">1989</option><option value="1990">1990</option></select>'>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_startyear_gt_endyear_value_lt_endyear">
		<cfset loc.args.startyear = "1990">
		<cfset loc.args.endyear = "1980">
		<cfset loc.r = loc.controller.dateSelect(argumentCollection=loc.args)>
		<cfset halt(false, 'loc.r')>
		<cfset loc.e = '<select id="user-birthday-year" name="user[birthday]($year)"><option value="1990">1990</option><option value="1989">1989</option><option value="1988">1988</option><option value="1987">1987</option><option value="1986">1986</option><option value="1985">1985</option><option value="1984">1984</option><option value="1983">1983</option><option value="1982">1982</option><option value="1981">1981</option><option value="1980">1980</option><option value="1979">1979</option><option value="1978">1978</option><option value="1977">1977</option><option value="1976">1976</option><option selected="selected" value="1975">1975</option></select>'>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_startyear_gt_endyear_value_gt_endyear">
		<cfset loc.controller.changeBirthday("1995")>
		<cfset loc.args.startyear = "1990">
		<cfset loc.args.endyear = "1980">
		<cfset loc.r = loc.controller.dateSelect(argumentCollection=loc.args)>
		<cfset halt(false, 'loc.r')>
		<cfset loc.e = '<select id="user-birthday-year" name="user[birthday]($year)"><option value="1990">1990</option><option value="1989">1989</option><option value="1988">1988</option><option value="1987">1987</option><option value="1986">1986</option><option value="1985">1985</option><option value="1984">1984</option><option value="1983">1983</option><option value="1982">1982</option><option value="1981">1981</option><option value="1980">1980</option></select>'>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>


	<cffunction name="changeBirthday">
		<cfargument name="value" type="any" required="true">
		<cfset user.birthday = arguments.value>
	</cffunction>

</cfcomponent>