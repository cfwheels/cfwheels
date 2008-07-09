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
