<cffunction name="distanceOfTimeInWords" returntype="any" access="public" output="false">
	<cfargument name="from_time" type="any" required="true">
	<cfargument name="to_time" type="any" required="true">
	<cfargument name="include_seconds" type="any" required="false" default="false">
	<cfset var local = structNew()>

	<cfset local.minute_diff = dateDiff("n", arguments.from_time, arguments.to_time)>
	<cfset local.second_diff = dateDiff("s", arguments.from_time, arguments.to_time)>
	<cfset local.hours = 0>
	<cfset local.days = 0>
	<cfset local.output = "">

	<cfif local.minute_diff LT 1>
		<cfif arguments.include_seconds>
			<cfif local.second_diff LTE 5>
				<cfset local.output = "less than 5 seconds">
			<cfelseif local.second_diff LTE 10>
				<cfset local.output = "less than 10 seconds">
			<cfelseif local.second_diff LTE 20>
				<cfset local.output = "less than 20 seconds">
			<cfelseif local.second_diff LTE 40>
				<cfset local.output = "half a minute">
			<cfelse>
				<cfset local.output = "less than a minute">
			</cfif>
		<cfelse>
			<cfset local.output = "less than a minute">
		</cfif>
	<cfelseif local.minute_diff LT 2>
		<cfset local.output = "1 minute">
	<cfelseif local.minute_diff LTE 45>
		<cfset local.output = local.minute_diff & " minutes">
	<cfelseif local.minute_diff LTE 90>
		<cfset local.output = "about 1 hour">
	<cfelseif local.minute_diff LTE 1440>
		<cfset local.hours = ceiling(local.minute_diff/60)>
		<cfset local.output = "about #local.hours# hours">
	<cfelseif local.minute_diff LTE 2880>
		<cfset local.output = "1 day">
	<cfelseif local.minute_diff LTE 43200>
		<cfset local.days = int(local.minute_diff/1440)>
		<cfset local.output = local.days & " days">
	<cfelseif local.minute_diff LTE 86400>
		<cfset local.output = "about 1 month">
	<cfelseif local.minute_diff LTE 525960>
		<cfset local.months = int(local.minute_diff/43200)>
		<cfset local.output = local.months & " months">
	<cfelseif local.minute_diff LTE 1051920>
		<cfset local.output = "about 1 year">
	<cfelse>
		<cfset local.years = int(local.minute_diff/525960)>
		<cfset local.output = "over " & local.years & " years">
	</cfif>

	<cfreturn local.output>
</cffunction>


<cffunction name="timeAgoInWords" returntype="any" access="public" output="false">
	<cfargument name="from_time" type="any" required="true">
	<cfargument name="include_seconds" type="any" required="false" default="false">

	<cfset arguments.to_time = now()>

	<cfreturn distanceOfTimeInWords(argumentCollection=arguments)>
</cffunction>


<cffunction name="timeUntilInWords" returntype="any" access="public" output="false">
	<cfargument name="to_time" type="any" required="true">
	<cfargument name="include_seconds" type="any" required="false" default="false">

	<cfset arguments.from_time = now()>

	<cfreturn distanceOfTimeInWords(argumentCollection=arguments)>
</cffunction>


<cffunction name="yearSelectTag" returntype="any" access="public" output="false">
	<cfargument name="start_year" type="any" required="false" default="#year(now())-5#">
	<cfargument name="end_year" type="any" required="false" default="#year(now())+5#">
	<cfset arguments.FL_loop_from = arguments.start_year>
	<cfset arguments.FL_loop_to = arguments.end_year>
	<cfset arguments.FL_type = "year">
	<cfset arguments.FL_step = 1>
	<cfset structDelete(arguments, "start_year")>
	<cfset structDelete(arguments, "end_year")>
	<cfreturn FL_yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments)>
</cffunction>


<cffunction name="monthSelectTag" returntype="any" access="public" output="false">
	<cfargument name="month_display" type="any" required="false" default="names">
	<cfset arguments.FL_loop_from = 1>
	<cfset arguments.FL_loop_to = 12>
	<cfset arguments.FL_type = "month">
	<cfset arguments.FL_step = 1>
	<cfif arguments.month_display IS "abbreviations">
		<cfset arguments.FL_option_names = "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec">
	<cfelseif month_display IS "names">
		<cfset arguments.FL_option_names = "January,February,March,April,May,June,July,August,September,October,November,December">
	</cfif>
	<cfset structDelete(arguments, "month_display")>
	<cfreturn FL_yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments)>
</cffunction>


<cffunction name="daySelectTag" returntype="any" access="public" output="false">
	<cfset arguments.FL_loop_from = 1>
	<cfset arguments.FL_loop_to = 31>
	<cfset arguments.FL_type = "day">
	<cfset arguments.FL_step = 1>
	<cfreturn FL_yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments)>
</cffunction>


<cffunction name="hourSelectTag" returntype="any" access="public" output="false">
	<cfset arguments.FL_loop_from = 0>
	<cfset arguments.FL_loop_to = 23>
	<cfset arguments.FL_type = "hour">
	<cfset arguments.FL_step = 1>
	<cfreturn FL_yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments)>
</cffunction>


<cffunction name="minuteSelectTag" returntype="any" access="public" output="false">
	<cfargument name="minute_step" type="any" required="false" default="1">
	<cfset arguments.FL_loop_from = 0>
	<cfset arguments.FL_loop_to = 59>
	<cfset arguments.FL_type = "minute">
	<cfset arguments.FL_step = arguments.minute_step>
	<cfset structDelete(arguments, "minute_step")>
	<cfreturn FL_yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments)>
</cffunction>

<cffunction name="secondSelectTag" returntype="any" access="public" output="false">
	<cfset arguments.FL_loop_from = 0>
	<cfset arguments.FL_loop_to = 59>
	<cfset arguments.FL_type = "second">
	<cfset arguments.FL_step = 1>
	<cfreturn FL_yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments)>
</cffunction>


<cffunction name="FL_yearMonthHourMinuteSecondSelectTag" returntype="any" access="private" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="include_blank" type="any" required="false" default="false">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrap_label" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prepend_to_label" type="any" required="false" default="">
	<cfargument name="append_to_label" type="any" required="false" default="">
	<cfargument name="FL_type" type="any" required="true" default="">
	<cfargument name="FL_loop_from" type="any" required="true" default="">
	<cfargument name="FL_loop_to" type="any" required="true" default="">
	<cfargument name="FL_id" type="any" required="false" default="#arguments.name#">
	<cfargument name="FL_option_names" type="any" required="false" default="">
	<cfargument name="FL_step" type="any" required="false" default="">
	<cfset var local = structNew()>
	<cfset arguments.FL_named_arguments = "name,value,include_blank,label,wrap_label,prepend,append,prepend_to_label,append_to_label,FL_type,FL_loop_from,FL_loop_to,FL_id,FL_option_names,FL_step">
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>

	<cfif arguments.value IS "" AND NOT arguments.include_blank>
		<cfset arguments.value = evaluate("#arguments.FL_type#(now())")>
	</cfif>

	<cfset local.html = "">
	<cfset local.html = local.html & FL_formBeforeElement(argumentCollection=arguments)>
	<cfset local.html = local.html & "<select name=""#arguments.name#"" id=""#arguments.FL_id#""#local.attributes#>">
	<cfif NOT isBoolean(arguments.include_blank) OR arguments.include_blank>
		<cfif NOT isBoolean(arguments.include_blank)>
			<cfset local.text = arguments.include_blank>
		<cfelse>
			<cfset local.text = "">
		</cfif>
		<cfset local.html = local.html & "<option value="""">#local.text#</option>">
	</cfif>
	<cfloop from="#arguments.FL_loop_from#" to="#arguments.FL_loop_to#" index="local.i" step="#arguments.FL_step#">
		<cfif arguments.value IS local.i>
			<cfset local.selected = " selected=""selected""">
		<cfelse>
			<cfset local.selected = "">
		</cfif>
		<cfif arguments.FL_option_names IS NOT "">
			<cfset local.option_name = listGetAt(arguments.FL_option_names, local.i)>
		<cfelse>
			<cfset local.option_name = local.i>
		</cfif>
		<cfif arguments.FL_type IS "minute" OR arguments.FL_type IS "second">
			<cfset local.option_name = numberFormat(local.option_name, "09")>
		</cfif>
		<cfset local.html = local.html & "<option value=""#local.i#""#local.selected#>#local.option_name#</option>">
	</cfloop>
	<cfset local.html = local.html & "</select>">
	<cfset local.html = local.html & FL_formAfterElement(argumentCollection=arguments)>

	<cfreturn local.html>
</cffunction>


<cffunction name="dateTimeSelect" returntype="any" access="public" output="false">
	<cfset arguments.FL_function_name = "dateTimeSelect">
	<cfreturn FL_dateTimeSelect(argumentCollection=arguments)>
</cffunction>


<cffunction name="dateTimeSelectTag" returntype="any" access="public" output="false">
	<cfset arguments.FL_function_name = "dateTimeSelectTag">
	<cfreturn FL_dateTimeSelect(argumentCollection=arguments)>
</cffunction>


<cffunction name="dateSelect" returntype="any" access="public" output="false">
	<cfargument name="order" type="any" required="false" default="month,day,year">
	<cfargument name="separator" type="any" required="false" default=" ">
	<cfset arguments.FL_function_name = "dateSelect">
	<cfreturn FL_dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>


<cffunction name="dateSelectTag" returntype="any" access="public" output="false">
	<cfargument name="order" type="any" required="false" default="month,day,year">
	<cfargument name="separator" type="any" required="false" default=" ">
	<cfset arguments.FL_function_name = "dateSelectTag">
	<cfreturn FL_dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>


<cffunction name="timeSelect" returntype="any" access="public" output="false">
	<cfargument name="order" type="any" required="false" default="hour,minute,second">
	<cfargument name="separator" type="any" required="false" default=":">
	<cfset arguments.FL_function_name = "timeSelect">
	<cfreturn FL_dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>


<cffunction name="timeSelectTag" returntype="any" access="public" output="false">
	<cfargument name="order" type="any" required="false" default="hour,minute,second">
	<cfargument name="separator" type="any" required="false" default=":">
	<cfset arguments.FL_function_name = "timeSelectTag">
	<cfreturn FL_dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>


<cffunction name="FL_dateTimeSelect" returntype="any" access="public" output="false">
	<cfargument name="date_order" type="any" required="false" default="month,day,year">
	<cfargument name="time_order" type="any" required="false" default="hour,minute,second">
	<cfargument name="date_separator" type="any" required="false" default=" ">
	<cfargument name="time_separator" type="any" required="false" default=":">
	<cfargument name="separator" type="any" required="false" default=" - ">
	<cfargument name="FL_function_name" type="any" required="true">
	<cfset var local = structNew()>

	<cfset local.html = "">
	<cfset local.separator = arguments.separator>

	<cfset arguments.order = arguments.date_order>
	<cfset arguments.separator = arguments.date_separator>
	<cfif arguments.FL_function_name IS "dateTimeSelect">
		<cfset local.html = local.html & dateSelect(argumentCollection=arguments)>
	<cfelseif  arguments.FL_function_name IS "dateTimeSelectTag">
		<cfset local.html = local.html & dateSelectTag(argumentCollection=arguments)>
	</cfif>
	<cfset local.html = local.html & local.separator>
	<cfset arguments.order = arguments.time_order>
	<cfset arguments.separator = arguments.time_separator>
	<cfif arguments.FL_function_name IS "dateTimeSelect">
		<cfset local.html = local.html & timeSelect(argumentCollection=arguments)>
	<cfelseif  arguments.FL_function_name IS "dateTimeSelectTag">
		<cfset local.html = local.html & timeSelectTag(argumentCollection=arguments)>
	</cfif>

	<cfreturn local.html>
</cffunction>


<cffunction name="FL_dateOrTimeSelect" returntype="any" access="private" output="false">
	<cfargument name="name" type="any" required="false" default="">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="object_name" type="any" required="false" default="">
	<cfargument name="field" type="any" required="false" default="">
	<cfargument name="FL_function_name" type="any" required="true">
	<cfset var local = structNew()>

	<cfif len(arguments.object_name) IS NOT 0>
		<cfset local.name = "#listLast(arguments.object_name,".")#[#arguments.field#]">
		<cfset arguments.FL_id = "#listLast(arguments.object_name,".")#_#arguments.field#">
		<cfset local.value = FL_formValue(argumentCollection=arguments)>
	<cfelse>
		<cfset local.name = arguments.name>
		<cfset arguments.FL_id = arguments.name>
		<cfset local.value = arguments.value>
	</cfif>

	<cfset local.html = "">
	<cfset local.first_done = false>
	<cfloop list="#arguments.order#" index="local.i">
		<cfset arguments.name = local.name & "(FL_" & local.i & ")">
		<cfif local.value IS NOT "">
			<cfset arguments.value = evaluate("#local.i#(local.value)")>
		<cfelse>
			<cfset arguments.value = "">
		</cfif>
		<cfif local.first_done>
			<cfset local.html = local.html & arguments.separator>
		</cfif>
		<cfset local.html = local.html & evaluate("#local.i#SelectTag(argumentCollection=arguments)")>
		<cfset local.first_done = true>
	</cfloop>

	<cfreturn local.html>
</cffunction>