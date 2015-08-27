<!--- PUBLIC VIEW HELPER FUNCTIONS --->

<cffunction name="distanceOfTimeInWords" returntype="string" access="public" output="false">
	<cfargument name="fromTime" type="date" required="true">
	<cfargument name="toTime" type="date" required="true">
	<cfargument name="includeSeconds" type="boolean" required="false">
	<cfscript>
		var loc = {};
		$args(name="distanceOfTimeInWords", args=arguments);
		loc.minuteDiff = DateDiff("n", arguments.fromTime, arguments.toTime);
		loc.secondDiff = DateDiff("s", arguments.fromTime, arguments.toTime);
		loc.hours = 0;
		loc.days = 0;
		loc.rv = "";
		if (loc.minuteDiff <= 1)
		{
			if (loc.secondDiff < 60)
			{
				loc.rv = "less than a minute";
			}
			else
			{
				loc.rv = "1 minute";
			}
			if (arguments.includeSeconds)
			{
				if (loc.secondDiff < 5)
				{
					loc.rv = "less than 5 seconds";
				}
				else if (loc.secondDiff < 10)
				{
					loc.rv = "less than 10 seconds";
				}
				else if (loc.secondDiff < 20)
				{
					loc.rv = "less than 20 seconds";
				}
				else if (loc.secondDiff < 40)
				{
					loc.rv = "half a minute";
				}
			}
		}
		else if (loc.minuteDiff < 45)
		{
			loc.rv = loc.minuteDiff & " minutes";
		}
		else if (loc.minuteDiff < 90)
		{
			loc.rv = "about 1 hour";
		}
		else if (loc.minuteDiff < 1440)
		{
			loc.hours = Ceiling(loc.minuteDiff/60);
			loc.rv = "about " & loc.hours & " hours";
		}
		else if (loc.minuteDiff < 2880)
		{
			loc.rv = "1 day";
		}
		else if (loc.minuteDiff < 43200)
		{
			loc.days = Int(loc.minuteDiff/1440);
			loc.rv = loc.days & " days";
		}
		else if (loc.minuteDiff < 86400)
		{
			loc.rv = "about 1 month";
		}
		else if (loc.minuteDiff < 525600)
		{
			loc.months = Int(loc.minuteDiff/43200);
			loc.rv = loc.months & " months";
		}
		else if (loc.minuteDiff < 657000)
		{
			loc.rv = "about 1 year";
		}
		else if (loc.minuteDiff < 919800)
		{
			loc.rv = "over 1 year";
		}
		else if (loc.minuteDiff < 1051200)
		{
			loc.rv = "almost 2 years";
		}
		else if (loc.minuteDiff >= 1051200)
		{
			loc.years = Int(loc.minuteDiff/525600);
			loc.rv = "over " & loc.years & " years";
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="timeAgoInWords" returntype="string" access="public" output="false">
	<cfargument name="fromTime" type="date" required="true">
	<cfargument name="includeSeconds" type="boolean" required="false">
	<cfargument name="toTime" type="date" required="false" default="#Now()#">
	<cfset $args(name="timeAgoInWords", args=arguments)>
	<cfreturn distanceOfTimeInWords(argumentCollection=arguments)>
</cffunction>

<cffunction name="timeUntilInWords" returntype="string" access="public" output="false">
	<cfargument name="toTime" type="date" required="true">
	<cfargument name="includeSeconds" type="boolean" required="false">
	<cfargument name="fromTime" type="date" required="false" default="#Now()#">
	<cfset $args(name="timeUntilInWords", args=arguments)>
	<cfreturn distanceOfTimeInWords(argumentCollection=arguments)>
</cffunction>