<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
		<cfset loc.f = "distanceOfTimeInWords">
		<cfset loc.args = {}>
		<cfset loc.args.fromTime = now()>
		<cfset loc.args.includeSeconds = true>
	</cffunction>

	<cffunction name="test_with_seconds_below_5_seconds">
		<cfset loc.c = 5 - 1>
		<cfset loc.args.toTime = dateadd('s', loc.c, loc.args.fromTime)>
		<cfinvoke component="#loc.controller#" method="#loc.f#" argumentcollection="#loc.args#" returnvariable="loc.e">
		<cfset loc.r = "less than 5 seconds">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_with_seconds_below_10_seconds">
		<cfset loc.c = 10 - 1>
		<cfset loc.args.toTime = dateadd('s', loc.c, loc.args.fromTime)>
		<cfset debug("loc.controller.distanceOfTimeInWords(argumentcollection=loc.args)", false)>
		<cfinvoke component="#loc.controller#" method="#loc.f#" argumentcollection="#loc.args#" returnvariable="loc.e">
		<cfset loc.r = "less than 10 seconds">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_with_seconds_below_20_seconds">
		<cfset loc.c = 20 - 1>
		<cfset loc.args.toTime = dateadd('s', loc.c, loc.args.fromTime)>
		<cfinvoke component="#loc.controller#" method="#loc.f#" argumentcollection="#loc.args#" returnvariable="loc.e">
		<cfset loc.r = "less than 20 seconds">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_with_seconds_below_40_seconds">
		<cfset loc.c = 40 - 1>
		<cfset loc.args.toTime = dateadd('s', loc.c, loc.args.fromTime)>
		<cfinvoke component="#loc.controller#" method="#loc.f#" argumentcollection="#loc.args#" returnvariable="loc.e">
		<cfset loc.r = "half a minute">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_with_seconds_below_60_seconds">
		<cfset loc.c = 60 - 1>
		<cfset loc.args.toTime = dateadd('s', loc.c, loc.args.fromTime)>
		<cfinvoke component="#loc.controller#" method="#loc.f#" argumentcollection="#loc.args#" returnvariable="loc.e">
		<cfset loc.r = "less than a minute">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_with_seconds_above_60_seconds">
		<cfset loc.c = 60 + 50>
		<cfset loc.args.toTime = dateadd('s', loc.c, loc.args.fromTime)>
		<cfinvoke component="#loc.controller#" method="#loc.f#" argumentcollection="#loc.args#" returnvariable="loc.e">
		<cfset loc.r = "1 minute">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_without_seconds_below_60_seconds">
		<cfset loc.args.includeSeconds = false>
		<cfset loc.c = 60 - 1>
		<cfset loc.args.toTime = dateadd('s', loc.c, loc.args.fromTime)>
		<cfinvoke component="#loc.controller#" method="#loc.f#" argumentcollection="#loc.args#" returnvariable="loc.e">
		<cfset loc.r = "less than a minute">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_without_seconds_above_60_seconds">
		<cfset loc.args.includeSeconds = false>
		<cfset loc.c = 60 + 50>
		<cfset loc.args.toTime = dateadd('s', loc.c, loc.args.fromTime)>
		<cfinvoke component="#loc.controller#" method="#loc.f#" argumentcollection="#loc.args#" returnvariable="loc.e">
		<cfset loc.r = "1 minute">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_without_seconds_below_45_minutes">
		<cfset loc.args.includeSeconds = false>
		<cfset loc.c = 45 - 1>
		<cfset loc.args.toTime = dateadd('n', loc.c, loc.args.fromTime)>
		<cfinvoke component="#loc.controller#" method="#loc.f#" argumentcollection="#loc.args#" returnvariable="loc.e">
		<cfset loc.r = "#loc.c# minutes">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_without_seconds_below_90_minutes">
		<cfset loc.args.includeSeconds = false>
		<cfset loc.c = 90 - 1>
		<cfset loc.args.toTime = dateadd('n', loc.c, loc.args.fromTime)>
		<cfinvoke component="#loc.controller#" method="#loc.f#" argumentcollection="#loc.args#" returnvariable="loc.e">
		<cfset loc.r = "about 1 hour">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_without_seconds_below_1440_minutes">
		<cfset loc.args.includeSeconds = false>
		<cfset loc.c = 1440 - 1>
		<cfset loc.args.toTime = dateadd('n', loc.c, loc.args.fromTime)>
		<cfset loc.c = Ceiling(loc.c/60)>
		<cfinvoke component="#loc.controller#" method="#loc.f#" argumentcollection="#loc.args#" returnvariable="loc.e">
		<cfset loc.r = "about #loc.c# hours">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_without_seconds_below_2880_minutes">
		<cfset loc.args.includeSeconds = false>
		<cfset loc.c = 2880 - 1>
		<cfset loc.args.toTime = dateadd('n', loc.c, loc.args.fromTime)>
		<cfinvoke component="#loc.controller#" method="#loc.f#" argumentcollection="#loc.args#" returnvariable="loc.e">
		<cfset loc.r = "1 day">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_without_seconds_below_43200_minutes">
		<cfset loc.args.includeSeconds = false>
		<cfset loc.c = 43200 - 1>
		<cfset loc.args.toTime = dateadd('n', loc.c, loc.args.fromTime)>
		<cfset loc.c = Int(loc.c/1440)>
		<cfinvoke component="#loc.controller#" method="#loc.f#" argumentcollection="#loc.args#" returnvariable="loc.e">
		<cfset loc.r = "#loc.c# days">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_without_seconds_below_86400_minutes">
		<cfset loc.args.includeSeconds = false>
		<cfset loc.c = 86400 - 1>
		<cfset loc.args.toTime = dateadd('n', loc.c, loc.args.fromTime)>
		<cfinvoke component="#loc.controller#" method="#loc.f#" argumentcollection="#loc.args#" returnvariable="loc.e">
		<cfset loc.r = "about 1 month">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_without_seconds_below_525600_minutes">
		<cfset loc.args.includeSeconds = false>
		<cfset loc.c = 525600 - 1>
		<cfset loc.args.toTime = dateadd('n', loc.c, loc.args.fromTime)>
		<cfset loc.c = Int(loc.c/43200)>
		<cfinvoke component="#loc.controller#" method="#loc.f#" argumentcollection="#loc.args#" returnvariable="loc.e">
		<cfset loc.r = "#loc.c# months">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_without_seconds_below_657000_minutes">
		<cfset loc.args.includeSeconds = false>
		<cfset loc.c = 657000 - 1>
		<cfset loc.args.toTime = dateadd('n', loc.c, loc.args.fromTime)>
		<cfinvoke component="#loc.controller#" method="#loc.f#" argumentcollection="#loc.args#" returnvariable="loc.e">
		<cfset loc.r = "about 1 year">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_without_seconds_below_919800_minutes">
		<cfset loc.args.includeSeconds = false>
		<cfset loc.c = 919800 - 1>
		<cfset loc.args.toTime = dateadd('n', loc.c, loc.args.fromTime)>
		<cfinvoke component="#loc.controller#" method="#loc.f#" argumentcollection="#loc.args#" returnvariable="loc.e">
		<cfset loc.r = "over 1 year">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_without_seconds_below_1051200_minutes">
		<cfset loc.args.includeSeconds = false>
		<cfset loc.c = 1051200 - 1>
		<cfset loc.args.toTime = dateadd('n', loc.c, loc.args.fromTime)>
		<cfinvoke component="#loc.controller#" method="#loc.f#" argumentcollection="#loc.args#" returnvariable="loc.e">
		<cfset loc.r = "almost 2 years">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_without_seconds_above_1051200_minutes">
		<cfset loc.args.includeSeconds = false>
		<cfset loc.c = 1051200>
		<cfset loc.c = (loc.c * 3) + 786>
		<cfset loc.args.toTime = dateadd('n', loc.c, loc.args.fromTime)>
		<cfset loc.c = Int(loc.c/525600)>
		<cfinvoke component="#loc.controller#" method="#loc.f#" argumentcollection="#loc.args#" returnvariable="loc.e">
		<cfset loc.r = "over #loc.c# years">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>