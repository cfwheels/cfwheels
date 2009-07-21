<cfcomponent extends="wheels.test">

	<cffunction name="_setup">
		<cfset global = {}>
		<cfset global.controller = createobject("component", "wheels.Controller")>
		<cfset global.f = global.controller.distanceOfTimeInWords>
		<cfset global.args = {}>
		<cfset global.args.fromTime = now()>
		<cfset global.args.includeSeconds = true>
	</cffunction>

	<cffunction name="setup">
		<cfset loc = {}>
		<cfset loc.a = duplicate(global.args)>
	</cffunction>

	<cffunction name="test_with_seconds_below_5_seconds">
		<cfset loc.c = 5 - 1>
		<cfset loc.a.toTime = dateadd('s', loc.c, loc.a.fromTime)>
		<cfinvoke method="global.f" argumentcollection="#loc.a#" returnvariable="loc.e">
		<cfset loc.r = "less than 5 seconds">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_with_seconds_below_10_seconds">
		<cfset loc.c = 10 - 1>
		<cfset loc.a.toTime = dateadd('s', loc.c, loc.a.fromTime)>
		<cfset halt(false, "global.controller.distanceOfTimeInWords(argumentcollection=loc.a)")>
		<cfinvoke method="global.f" argumentcollection="#loc.a#" returnvariable="loc.e">
		<cfset loc.r = "less than 10 seconds">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_with_seconds_below_20_seconds">
		<cfset loc.c = 20 - 1>
		<cfset loc.a.toTime = dateadd('s', loc.c, loc.a.fromTime)>
		<cfinvoke method="global.f" argumentcollection="#loc.a#" returnvariable="loc.e">
		<cfset loc.r = "less than 20 seconds">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_with_seconds_below_40_seconds">
		<cfset loc.c = 40 - 1>
		<cfset loc.a.toTime = dateadd('s', loc.c, loc.a.fromTime)>
		<cfinvoke method="global.f" argumentcollection="#loc.a#" returnvariable="loc.e">
		<cfset loc.r = "half a minute">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_with_seconds_below_60_seconds">
		<cfset loc.c = 60 - 1>
		<cfset loc.a.toTime = dateadd('s', loc.c, loc.a.fromTime)>
		<cfinvoke method="global.f" argumentcollection="#loc.a#" returnvariable="loc.e">
		<cfset loc.r = "less than a minute">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_with_seconds_above_60_seconds">
		<cfset loc.c = 60 + 50>
		<cfset loc.a.toTime = dateadd('s', loc.c, loc.a.fromTime)>
		<cfinvoke method="global.f" argumentcollection="#loc.a#" returnvariable="loc.e">
		<cfset loc.r = "1 minute">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_without_seconds_above_60_seconds">
		<cfset loc.a.includeSeconds = false>
		<cfset loc.c = 60 + 50>
		<cfset loc.a.toTime = dateadd('s', loc.c, loc.a.fromTime)>
		<cfinvoke method="global.f" argumentcollection="#loc.a#" returnvariable="loc.e">
		<cfset loc.r = "1 minute">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_without_seconds_below_45_minutes">
		<cfset loc.a.includeSeconds = false>
		<cfset loc.c = 45 - 1>
		<cfset loc.a.toTime = dateadd('n', loc.c, loc.a.fromTime)>
		<cfinvoke method="global.f" argumentcollection="#loc.a#" returnvariable="loc.e">
		<cfset loc.r = "#loc.c# minutes">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_without_seconds_below_90_minutes">
		<cfset loc.a.includeSeconds = false>
		<cfset loc.c = 90 - 1>
		<cfset loc.a.toTime = dateadd('n', loc.c, loc.a.fromTime)>
		<cfinvoke method="global.f" argumentcollection="#loc.a#" returnvariable="loc.e">
		<cfset loc.r = "about 1 hour">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_without_seconds_below_1440_minutes">
		<cfset loc.a.includeSeconds = false>
		<cfset loc.c = 1440 - 1>
		<cfset loc.a.toTime = dateadd('n', loc.c, loc.a.fromTime)>
		<cfset loc.c = Ceiling(loc.c/60)>
		<cfinvoke method="global.f" argumentcollection="#loc.a#" returnvariable="loc.e">
		<cfset loc.r = "about #loc.c# hours">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_without_seconds_below_2880_minutes">
		<cfset loc.a.includeSeconds = false>
		<cfset loc.c = 2880 - 1>
		<cfset loc.a.toTime = dateadd('n', loc.c, loc.a.fromTime)>
		<cfinvoke method="global.f" argumentcollection="#loc.a#" returnvariable="loc.e">
		<cfset loc.r = "1 day">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_without_seconds_below_43200_minutes">
		<cfset loc.a.includeSeconds = false>
		<cfset loc.c = 43200 - 1>
		<cfset loc.a.toTime = dateadd('n', loc.c, loc.a.fromTime)>
		<cfset loc.c = Int(loc.c/1440)>
		<cfinvoke method="global.f" argumentcollection="#loc.a#" returnvariable="loc.e">
		<cfset loc.r = "#loc.c# days">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_without_seconds_below_86400_minutes">
		<cfset loc.a.includeSeconds = false>
		<cfset loc.c = 86400 - 1>
		<cfset loc.a.toTime = dateadd('n', loc.c, loc.a.fromTime)>
		<cfinvoke method="global.f" argumentcollection="#loc.a#" returnvariable="loc.e">
		<cfset loc.r = "about 1 month">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_without_seconds_below_525600_minutes">
		<cfset loc.a.includeSeconds = false>
		<cfset loc.c = 525600 - 1>
		<cfset loc.a.toTime = dateadd('n', loc.c, loc.a.fromTime)>
		<cfset loc.c = Int(loc.c/43200)>
		<cfinvoke method="global.f" argumentcollection="#loc.a#" returnvariable="loc.e">
		<cfset loc.r = "#loc.c# months">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_without_seconds_below_1051200_minutes">
		<cfset loc.a.includeSeconds = false>
		<cfset loc.c = 1051200 - 1>
		<cfset loc.a.toTime = dateadd('n', loc.c, loc.a.fromTime)>
		<cfinvoke method="global.f" argumentcollection="#loc.a#" returnvariable="loc.e">
		<cfset loc.r = "about 1 year">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_without_seconds_above_1051200_minutes">
		<cfset loc.a.includeSeconds = false>
		<cfset loc.c = 1051200>
		<cfset loc.c = (loc.c * 3) + 786>
		<cfset loc.a.toTime = dateadd('n', loc.c, loc.a.fromTime)>
		<cfset loc.c = Int(loc.c/525600)>
		<cfinvoke method="global.f" argumentcollection="#loc.a#" returnvariable="loc.e">
		<cfset loc.r = "over #loc.c# years">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>