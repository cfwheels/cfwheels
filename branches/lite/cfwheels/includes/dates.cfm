<!--- Helper functions that return dates or parts of dates --->

<cffunction name="getDate" returntype="date" hint="Returns an ODBC datetime for today">
	<cfargument name="date" type="string" required="true" hint="" />
	
	<cfreturn createODBCDate(arguments.date)>
	
</cffunction>

<cffunction name="today" returntype="any" hint="Returns an ODBC datetime for today">
	<cfargument name="date" type="string" required="false" default="" hint="" />
	
	<cfset var todaysDate = createODBCDate(now())>
	
	<cfif arguments.date IS NOT "">
		<cfif dateFormat(arguments.date,'m/d/yy') IS dateFormat(todaysDate, 'm/d/yy')>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	<cfelse>
		<cfreturn todaysDate>
	</cfif>
	
</cffunction>

<cffunction name="tomorrow" returntype="any" hint="Returns an ODBC datetime for tomorrow">
	<cfargument name="date" type="string" required="false" default="" hint="" />
	
	<cfset var tomorrowsDate = createODBCDate(dateAdd('d',1,now()))>
	
	<cfif arguments.date IS NOT "">
		<cfif dateFormat(arguments.date,'m/d/yy') IS dateFormat(tomorrowsDate,'m/d/yy')>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	<cfelse>
		<cfreturn tomorrowsDate>
	</cfif>
	
</cffunction>

<cffunction name="yesterday" returntype="any" hint="Returns an ODBC datetime for yesterday">
	<cfargument name="date" type="string" required="false" default="" hint="" />
	
	<cfset var yesterdaysDate = createODBCDate(dateAdd('d',-1,now()))>
	
	<cfif arguments.date IS NOT "">
		<cfif dateFormat(arguments.date,'m/d/yy') IS dateFormat(yesterdaysDate,'m/d/yy')>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	<cfelse>
		<cfreturn yesterdaysDate>
	</cfif>
	
</cffunction>

<cffunction name="nextWeek" returntype="date" hint="Returns an ODBC datetime for 1 week from today">
	
	<cfreturn createODBCDateTime(dateAdd('ww',1,now()))>
	
</cffunction>

<cffunction name="lastWeek" returntype="date" hint="Returns an ODBC datetime for 1 week ago">
	
	<cfreturn createODBCDateTime(dateAdd('ww',-1,now()))>
	
</cffunction>

<cffunction name="nextMonth" returntype="date" hint="Returns an ODBC datetime for 1 month from today">
	
	<cfreturn createODBCDateTime(dateAdd('m',1,now()))>
	
</cffunction>

<cffunction name="lastMonth" returntype="date" hint="Returns an ODBC datetime for 1 month ago">
	
	<cfreturn createODBCDateTime(dateAdd('m',-1,now()))>
	
</cffunction>

<cffunction name="nextYear" returntype="date" hint="Returns an ODBC datetime for 1 year from today">
	
	<cfreturn createODBCDateTime(dateAdd('yyyy',1,now()))>
	
</cffunction>

<cffunction name="lastYear" returntype="date" hint="Returns an ODBC datetime for 1 year go">
	
	<cfreturn createODBCDateTime(dateAdd('yyyy',-1,now()))>
	
</cffunction>

<cffunction name="nextWeekDay" returntype="date" hint="Returns an ODBC datetime for the next week day">
	
	<cfreturn createODBCDateTime(dateAdd('w',1,now()))>
	
</cffunction>

<cffunction name="lastWeekDay" returntype="date" hint="Returns an ODBC datetime for the previous week day">
	
	<cfreturn createODBCDateTime(dateAdd('w',-1,now()))>
	
</cffunction>

<cffunction name="daysAgo" returntype="date" hint="Returns an ODBC datetime for the given date minus the given number of days">
	<cfargument name="date" required="no" type="string" default="#now()#">
	<cfargument name="number" required="no" type="numeric" default="0">
	
	<cfreturn createODBCDateTime(dateAdd('d',-arguments.number,arguments.date))>
</cffunction>

<cffunction name="daysSince" returntype="date" hint="Returns an ODBC datetime for the given date plus the given number of days">
	<cfargument name="date" required="no" type="string" default="#now()#">
	<cfargument name="number" required="no" type="numeric" default="0">
	
	<cfreturn createODBCDateTime(dateAdd('d',arguments.number,arguments.date))>
</cffunction>

<cffunction name="weekDaysAgo" returntype="date" hint="Returns an ODBC datetime for the given date minus the given number of week days">
	<cfargument name="date" required="no" type="string" default="#now()#">
	<cfargument name="number" required="no" type="numeric" default="0">
	
	<cfreturn createODBCDateTime(dateAdd('w',-arguments.number,arguments.date))>
</cffunction>

<cffunction name="weekDaysSince" returntype="date" hint="Returns an ODBC datetime for the given date plus the given number of week days">
	<cfargument name="date" required="no" type="string" default="#now()#">
	<cfargument name="number" required="no" type="numeric" default="0">
	
	<cfreturn createODBCDateTime(dateAdd('w',arguments.number,arguments.date))>
</cffunction>

<cffunction name="weeksAgo" returntype="date" hint="Returns an ODBC datetime for the given date minus the given number of weeks">
	<cfargument name="date" required="no" type="string" default="#now()#">
	<cfargument name="number" required="no" type="numeric" default="0">
	
	<cfreturn createODBCDateTime(dateAdd('ww',-arguments.number,arguments.date))>
</cffunction>

<cffunction name="weeksSince" returntype="date" hint="Returns an ODBC datetime for the given date plus the given number of weeks">
	<cfargument name="date" required="no" type="string" default="#now()#">
	<cfargument name="number" required="no" type="numeric" default="0">
	
	<cfreturn createODBCDateTime(dateAdd('ww',arguments.number,arguments.date))>
</cffunction>

<cffunction name="monthsAgo" returntype="date" hint="Returns an ODBC datetime for the given date minus the given number of months">
	<cfargument name="date" required="no" type="string" default="#now()#">
	<cfargument name="number" required="no" type="numeric" default="0">
	
	<cfreturn createODBCDateTime(dateAdd('m',-arguments.number,arguments.date))>
</cffunction>

<cffunction name="monthsSince" returntype="date" hint="Returns an ODBC datetime for the given date plus the given number of months">
	<cfargument name="date" required="no" type="string" default="#now()#">
	<cfargument name="number" required="no" type="numeric" default="0">
	
	<cfreturn createODBCDateTime(dateAdd('m',arguments.number,arguments.date))>
</cffunction>

<cffunction name="yearsAgo" returntype="date" hint="Returns an ODBC datetime for the given date minus the given number of years">
	<cfargument name="date" required="no" type="string" default="#now()#">
	<cfargument name="number" required="no" type="numeric" default="0">
	
	<cfreturn createODBCDateTime(dateAdd('yyyy',-arguments.number,arguments.date))>
</cffunction>

<cffunction name="yearsSince" returntype="date" hint="Returns an ODBC datetime for the given date plus the given number of years">
	<cfargument name="date" required="no" type="string" default="#now()#">
	<cfargument name="number" required="no" type="numeric" default="0">
	
	<cfreturn createODBCDateTime(dateAdd('yyyy',arguments.number,arguments.date))>
</cffunction>

<cffunction name="distanceOfTimeInWords" returntype="string" access="public" output="false" hint="[DOCS] Reports the approximate distance in time between two dates">
	<cfargument name="fromTime" type="date" required="yes" hint="The start date/time">
	<cfargument name="toTime" type="date" required="yes" hint="The end date/time">
	<cfargument name="includeSeconds" type="boolean" required="no" default="false" hint="When set to true will give more detailed wording when difference is less than 1 minute">
	
	<cfset var minuteDiff = dateDiff("n", fromTime, toTime)>
	<cfset var secondDiff = dateDiff("s", fromTime, toTime)>
	<cfset var hours = 0>
	<cfset var days = 0>
	<cfset var output = "">

	<cfif minuteDiff LT 1>
		<cfif arguments.includeSeconds>
			<cfif secondDiff LTE 5>
				<cfset output = "less than 5 seconds">
			<cfelseif secondDiff LTE 10>
				<cfset output = "less than 10 seconds">
			<cfelseif secondDiff LTE 20>
				<cfset output = "less than 20 seconds">
			<cfelseif secondDiff LTE 40>
				<cfset output = "half a minute">
			<cfelse>
				<cfset output = "less than a minute">
			</cfif>
		<cfelse>
			<cfset output = "less than a minute">
		</cfif>	
	<cfelseif minuteDiff LT 2>
		<cfset output = "1 minute">
	<cfelseif minuteDiff LTE 45>
		<cfset output = minuteDiff & " minutes">
	<cfelseif minuteDiff LTE 90>
		<cfset output = "about 1 hour">
	<cfelseif minuteDiff LTE 1440>
		<cfset hours = ceiling(minuteDiff/60)>
		<cfset output = "about #hours# hours">
	<cfelseif minuteDiff LTE 2880>
		<cfset output = "1 day">
	<cfelse>
		<cfset days = int(minuteDiff/60/24)>
		<cfset output = days & " days">
	</cfif>

	<cfreturn output>
</cffunction>

<cffunction name="timeAgoInWords" returntype="string" access="public" output="false" hint="[DOCS] Reports the approximate distance in time between the supplied date and the current date">
	<cfargument name="fromTime" type="date" required="yes" hint="The start date/time">
	<cfargument name="includeSeconds" type="boolean" required="no" default="false" hint="When set to true will give more detailed wording when difference is less than 1 minute">
	
	<cfset arguments.toTime = now()>
	
	<cfreturn distanceOfTimeInWords(argumentCollection=arguments)>
</cffunction>