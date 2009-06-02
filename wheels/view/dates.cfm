<cffunction name="distanceOfTimeInWords" returntype="string" access="public" output="false" hint="Pass in two dates to this method and it will return a string describing the difference between them. If the difference between the two dates you pass in is 2 hours, 13 minutes and 10 seconds it will return 'about 2 hours' for example. This method is useful when you want to describe the time that has passed since a certain event (example: 'Comment added by Joe about 3 weeks ago') or the time left until a certain event (example: 'Next chat session starts in about 5 hours') instead of just writing out the date itself.">
	<cfargument name="fromTime" type="date" required="true" hint="Date to compare from">
	<cfargument name="toTime" type="date" required="true" hint="Date to compare to">
	<cfargument name="includeSeconds" type="boolean" required="false" default="#application.wheels.distanceOfTimeInWords.includeSeconds#" hint="Set to true for detailed description when the difference is less than one minute">
	<cfscript>
		var loc = {};
		loc.minuteDiff = DateDiff("n", arguments.fromTime, arguments.toTime);
		loc.secondDiff = DateDiff("s", arguments.fromTime, arguments.toTime);
		loc.hours = 0;
		loc.days = 0;
		loc.returnValue = "";

		if (loc.minuteDiff <= 1)
		{
			if (arguments.includeSeconds && loc.secondDiff < 60)
			{
				if (loc.secondDiff < 5)
					loc.returnValue = "less than 5 seconds";
				else if (loc.secondDiff < 10)
					loc.returnValue = "less than 10 seconds";
				else if (loc.secondDiff < 20)
					loc.returnValue = "less than 20 seconds";
				else if (loc.secondDiff < 40)
					loc.returnValue = "half a minute";
				else
					loc.returnValue = "less than a minute";
			}
			else
			{
				loc.returnValue = "1 minute";
			}
		}
		else if (loc.minuteDiff < 45)
		{
			loc.returnValue = loc.minuteDiff & " minutes";
		}
		else if (loc.minuteDiff < 90)
		{
			loc.returnValue = "about 1 hour";
		}
		else if (loc.minuteDiff < 1440)
		{
			loc.hours = Ceiling(loc.minuteDiff/60);
			loc.returnValue = "about " & loc.hours & " hours";
		}
		else if (loc.minuteDiff < 2880)
		{
			loc.returnValue = "1 day";
		}
		else if (loc.minuteDiff < 43200)
		{
			loc.days = Int(loc.minuteDiff/1440);
			loc.returnValue = loc.days & " days";
		}
		else if (loc.minuteDiff < 86400)
		{
			loc.returnValue = "about 1 month";
		}
		else if (loc.minuteDiff < 525600)
		{
			loc.months = Int(loc.minuteDiff/43200);
			loc.returnValue = loc.months & " months";
		}
		else if (loc.minuteDiff < 1051200)
		{
			loc.returnValue = "about 1 year";
		}
		else if (loc.minuteDiff > 1051200)
		{
			loc.years = Int(loc.minuteDiff/525600);
			loc.returnValue = "over " & loc.years & " years";
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="timeAgoInWords" returntype="string" access="public" output="false">
	<cfargument name="fromTime" type="date" required="true">
	<cfargument name="includeSeconds" type="boolean" required="false" default="#application.wheels.timeAgoInWords.includeSeconds#">
	<cfset arguments.toTime = Now()>
	<cfreturn distanceOfTimeInWords(argumentCollection=arguments)>
</cffunction>

<cffunction name="timeUntilInWords" returntype="string" access="public" output="false">
	<cfargument name="toTime" type="date" required="true">
	<cfargument name="includeSeconds" type="boolean" required="false" default="#application.wheels.timeUntilInWords.includeSeconds#">
	<cfset arguments.fromTime = Now()>
	<cfreturn distanceOfTimeInWords(argumentCollection=arguments)>
</cffunction>
