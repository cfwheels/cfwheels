<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
		<cfset loc.args = {}>
		<cfset loc.args.label = false>
	</cffunction>


	<cffunction name="test_multiple_labels">
		<cfset loc.args.name = "today">
		<cfset loc.args.startyear = "1973">
		<cfset loc.args.endyear = "1973">
		<cfset loc.args.selected = "09/14/1973">
		<cfset loc.args.label = "The Month:,The Day:,The Year:">
		<cfset loc.e = '<label for="today-month">The Month:<select id="today-month" name="today($month)"><option value="1">January</option><option value="2">February</option><option value="3">March</option><option value="4">April</option><option value="5">May</option><option value="6">June</option><option value="7">July</option><option value="8">August</option><option selected="selected" value="9">September</option><option value="10">October</option><option value="11">November</option><option value="12">December</option></select></label> <label for="today-day">The Day:<select id="today-day" name="today($day)"><option value="1">1</option><option value="2">2</option><option value="3">3</option><option value="4">4</option><option value="5">5</option><option value="6">6</option><option value="7">7</option><option value="8">8</option><option value="9">9</option><option value="10">10</option><option value="11">11</option><option value="12">12</option><option value="13">13</option><option selected="selected" value="14">14</option><option value="15">15</option><option value="16">16</option><option value="17">17</option><option value="18">18</option><option value="19">19</option><option value="20">20</option><option value="21">21</option><option value="22">22</option><option value="23">23</option><option value="24">24</option><option value="25">25</option><option value="26">26</option><option value="27">27</option><option value="28">28</option><option value="29">29</option><option value="30">30</option><option value="31">31</option></select></label> <label for="today-year">The Year:<select id="today-year" name="today($year)"><option selected="selected" value="1973">1973</option></select></label>'>
		<cfset loc.r = loc.controller.dateSelectTags(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_startyear_is_greater_than_endyear">
		<cfset loc.args.name = "today">
		<cfset loc.args.startyear = "2000">
		<cfset loc.args.endyear = "1990">
		<cfset loc.args.order="year">
		<cfset loc.e = '<select id="today-year" name="today($year)"><option value="2000">2000</option><option value="1999">1999</option><option value="1998">1998</option><option value="1997">1997</option><option value="1996">1996</option><option value="1995">1995</option><option value="1994">1994</option><option value="1993">1993</option><option value="1992">1992</option><option value="1991">1991</option><option value="1990">1990</option></select>'>
		<cfset loc.r = loc.controller.dateSelectTags(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_endyear_is_greater_than_startyear">
		<cfset loc.args.name = "today">
		<cfset loc.args.startyear = "1990">
		<cfset loc.args.endyear = "2000">
		<cfset loc.args.order="year">
		<cfset loc.e = '<select id="today-year" name="today($year)"><option value="1990">1990</option><option value="1991">1991</option><option value="1992">1992</option><option value="1993">1993</option><option value="1994">1994</option><option value="1995">1995</option><option value="1996">1996</option><option value="1997">1997</option><option value="1998">1998</option><option value="1999">1999</option><option value="2000">2000</option></select>'>
		<cfset loc.r = loc.controller.dateSelectTags(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>