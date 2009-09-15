<cfcomponent extends="wheels.test">

	<cfset global.controller = createobject("component", "wheels.tests.ControllerWithModel")>
	<cfset global.model = createobject("component", "wheels.tests.ModelUsers")>
	<cfset global.args= {}>
	<cfset global.args.objectName = "ModelUsers1">

	<cffunction name="test_dateselect_parsing_and_passed_month">
		<cfset loc.args.property = "birthday">
		<cfset loc.args.order = "month">
		<cfset halt(false, "loc.controller.dateSelect(argumentcollection=loc.args)")>
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
		<cfreturn '<select name="ModelUsers1[#arguments.property#]($month)" id="ModelUsers1-#arguments.property#-month"><option value="1">January</option><option value="2">February</option><option value="3">March</option><option value="4">April</option><option value="5">May</option><option value="6">June</option><option value="7">July</option><option value="8">August</option><option value="9">September</option><option value="10">October</option><option value="11" selected="selected">November</option><option value="12">December</option></select>'>
	</cffunction>

	<cffunction name="test_dateselect_parsing_and_passed_year">
		<cfset loc.args.property = "birthday">
		<cfset loc.args.order = "year">
		<cfset loc.args.startyear = "1973">
		<cfset loc.args.endyear = "1976">
		<cfset halt(false, "loc.controller.dateSelect(argumentcollection=loc.args)")>
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
		<cfset halt(false, "loc.controller.dateSelect(argumentcollection=loc.args)")>
		<cfset loc.e = '<select name="ModelUsers1[birthday]($year)" id="ModelUsers1-birthday-year"><option value="1975" selected="selected">1975</option><option value="1976">1976</option><option value="1977">1977</option><option value="1978">1978</option><option value="1979">1979</option><option value="1980">1980</option></select>'>
		<cfset loc.r = loc.controller.dateSelect(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="dateSelect_year_str">
		<cfargument name="property" type="string" required="true">
		<cfreturn '<select name="ModelUsers1[#arguments.property#]($year)" id="ModelUsers1-#arguments.property#-year"><option value="1973">1973</option><option value="1974">1974</option><option value="1975" selected="selected">1975</option><option value="1976">1976</option></select>'>
	</cffunction>

	<cffunction name="test_dataSelectTag_can_have_multiple_labels">
		<cfset loc.args.name = "today">
		<cfset loc.args.startyear = "1973">
		<cfset loc.args.endyear = "1973">
		<cfset loc.args.label = "The Month:,The Day:,The Year:">
		<cfset loc.e = '<label for="today-month">The Month:<select name="today($month)" id="today-month"><option value="1">January</option><option value="2">February</option><option value="3">March</option><option value="4">April</option><option value="5">May</option><option value="6">June</option><option value="7">July</option><option value="8">August</option><option value="9" selected="selected">September</option><option value="10">October</option><option value="11">November</option><option value="12">December</option></select></label> <label for="today-day">The Day:<select name="today($day)" id="today-day"><option value="1">1</option><option value="2">2</option><option value="3">3</option><option value="4">4</option><option value="5">5</option><option value="6">6</option><option value="7">7</option><option value="8">8</option><option value="9">9</option><option value="10">10</option><option value="11">11</option><option value="12">12</option><option value="13">13</option><option value="14" selected="selected">14</option><option value="15">15</option><option value="16">16</option><option value="17">17</option><option value="18">18</option><option value="19">19</option><option value="20">20</option><option value="21">21</option><option value="22">22</option><option value="23">23</option><option value="24">24</option><option value="25">25</option><option value="26">26</option><option value="27">27</option><option value="28">28</option><option value="29">29</option><option value="30">30</option><option value="31">31</option></select></label> <label for="today-year">The Year:<select name="today($year)" id="today-year"><option value="1973">1973</option></select></label>'>
		<cfset loc.r = loc.controller.dateSelectTags(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>