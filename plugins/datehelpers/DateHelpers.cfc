<cfcomponent output="false">

	<cffunction name="init">
		<cfset this.version = "0.9.1">
		<cfreturn this>
	</cffunction>

	<cffunction name="distanceOfTimeInWords" returntype="string" access="public" output="false" hint="Pass in two dates to this method and it will return a string describing the difference between them. If the difference between the two dates you pass in is 2 hours, 13 minutes and 10 seconds it will return 'about 2 hours' for example. This method is useful when you want to describe the time that has passed since a certain event (example: 'Comment added by Joe about 3 weeks ago') or the time left until a certain event (example: 'Next chat session starts in about 5 hours') instead of just writing out the date itself.">
		<cfargument name="fromTime" type="date" required="true" hint="Date to compare from">
		<cfargument name="toTime" type="date" required="true" hint="Date to compare to">
		<cfargument name="includeSeconds" type="boolean" required="false" default="false" hint="Set to true for detailed description when the difference is less than one minute">

		<cfset var loc = {}>
	
		<cfset loc.minuteDiff = DateDiff("n", arguments.fromTime, arguments.toTime)>
		<cfset loc.secondDiff = DateDiff("s", arguments.fromTime, arguments.toTime)>
		<cfset loc.hours = 0>
		<cfset loc.days = 0>
		<cfset loc.output = "">
	
		<cfif loc.minuteDiff LT 1>
			<cfif arguments.includeSeconds>
				<cfif loc.secondDiff LTE 5>
					<cfset loc.output = "less than 5 seconds">
				<cfelseif loc.secondDiff LTE 10>
					<cfset loc.output = "less than 10 seconds">
				<cfelseif loc.secondDiff LTE 20>
					<cfset loc.output = "less than 20 seconds">
				<cfelseif loc.secondDiff LTE 40>
					<cfset loc.output = "half a minute">
				<cfelse>
					<cfset loc.output = "less than a minute">
				</cfif>
			<cfelse>
				<cfset loc.output = "less than a minute">
			</cfif>
		<cfelseif loc.minuteDiff LT 2>
			<cfset loc.output = "1 minute">
		<cfelseif loc.minuteDiff LTE 45>
			<cfset loc.output = loc.minuteDiff & " minutes">
		<cfelseif loc.minuteDiff LTE 90>
			<cfset loc.output = "about 1 hour">
		<cfelseif loc.minuteDiff LTE 1440>
			<cfset loc.hours = Ceiling(loc.minuteDiff/60)>
			<cfset loc.output = "about #loc.hours# hours">
		<cfelseif loc.minuteDiff LTE 2880>
			<cfset loc.output = "1 day">
		<cfelseif loc.minuteDiff LTE 43200>
			<cfset loc.days = Int(loc.minuteDiff/1440)>
			<cfset loc.output = loc.days & " days">
		<cfelseif loc.minuteDiff LTE 86400>
			<cfset loc.output = "about 1 month">
		<cfelseif loc.minuteDiff LTE 525960>
			<cfset loc.months = Int(loc.minuteDiff/43200)>
			<cfset loc.output = loc.months & " months">
		<cfelseif loc.minuteDiff LTE 1051920>
			<cfset loc.output = "about 1 year">
		<cfelse>
			<cfset loc.years = Int(loc.minuteDiff/525960)>
			<cfset loc.output = "over " & loc.years & " years">
		</cfif>
	
		<cfreturn loc.output>
	</cffunction>

	<cffunction name="timeAgoInWords" returntype="string" access="public" output="false">
		<cfargument name="fromTime" type="date" required="true">
		<cfargument name="includeSeconds" type="boolean" required="false" default="false">
		<cfset arguments.toTime = Now()>
		<cfreturn distanceOfTimeInWords(argumentCollection=arguments)>
	</cffunction>
	
	<cffunction name="timeUntilInWords" returntype="string" access="public" output="false">
		<cfargument name="toTime" type="date" required="true">
		<cfargument name="includeSeconds" type="boolean" required="false" default="false">
		<cfset arguments.fromTime = Now()>
		<cfreturn distanceOfTimeInWords(argumentCollection=arguments)>
	</cffunction>

</cfcomponent>