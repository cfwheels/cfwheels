<cffunction name="bytes" returntype="date" hint="Returns the number of bytes for the given number of bytes (returns the input)">
	<cfargument name="bytes" required="yes" type="numeric">
	
	<cfreturn arguments.bytes>
</cffunction>

<cffunction name="kilobytes" returntype="numeric" hint="Returns the number of kilobytes for the given number of bytes (3 zeros)">
	<cfargument name="bytes" required="yes" type="numeric">
	
	<cfreturn arguments.bytes * 2^10>
</cffunction>

<cffunction name="megabytes" returntype="numeric" hint="Returns the number of megabytes for the given number of bytes (6 zeros)">
	<cfargument name="bytes" required="yes" type="numeric">
	
	<cfreturn arguments.bytes * 2^20>
</cffunction>

<cffunction name="gigabytes" returntype="numeric" hint="Returns the number of gigabytes for the given number of bytes (9 zeros)">
	<cfargument name="bytes" required="yes" type="numeric">
	
	<cfreturn arguments.bytes * 2^30>
</cffunction>

<cffunction name="terabytes" returntype="numeric" hint="Returns the number of terabytes for the given number of bytes (12 zeros)">
	<cfargument name="bytes" required="yes" type="numeric">
	
	<cfreturn arguments.bytes * 2^40>
</cffunction>

<cffunction name="petabytes" returntype="numeric" hint="Returns the number of petabytes for the given number of bytes (15 zeros)">
	<cfargument name="bytes" required="yes" type="numeric">
	
	<cfreturn arguments.bytes * 2^50>
</cffunction>

<cffunction name="exabytes" returntype="numeric" hint="Returns the number of exabytes for the given number of bytes (18 zeros)">
	<cfargument name="bytes" required="yes" type="numeric">
	
	<cfreturn arguments.bytes * 2^60>
</cffunction>

<cffunction name="zettabytes" returntype="numeric" hint="Returns the number of zettabytes for the given number of bytes (21 zeros)">
	<cfargument name="bytes" required="yes" type="numeric">
	
	<cfreturn arguments.bytes * 2^70>
</cffunction>

<cffunction name="yottabytes" returntype="numeric" hint="Returns the number of yottabytes for the given number of bytes (24 zeros)">
	<cfargument name="bytes" required="yes" type="numeric">
	
	<cfreturn arguments.bytes * 2^80>
</cffunction>

<cffunction name="deca" returntype="numeric" hint="Returns the meters of deca of the same value (meters => decameters)">
	<cfargument name="meters" required="yes" type="numeric">
	
	<cfreturn arguments.meters * 10^1>
</cffunction>

<cffunction name="centi" returntype="numeric" hint="Returns the meters of centi of the same value (meters => centimeters)">
	<cfargument name="meters" required="yes" type="numeric">
	
	<cfreturn arguments.meters * 10^2>
</cffunction>

<cffunction name="milli" returntype="numeric" hint="Returns the meters of milli of the same value (meters => millimeters)">
	<cfargument name="meters" required="yes" type="numeric">
	
	<cfreturn arguments.meters * 10^3>
</cffunction>

<cffunction name="micro" returntype="numeric" hint="Returns the meters of micro of the same value (meters => micrometers)">
	<cfargument name="meters" required="yes" type="numeric">
	
	<cfreturn arguments.meters * 10^4>
</cffunction>

<cffunction name="nano" returntype="numeric" hint="Returns the meters of nano of the same value (meters => nanometers)">
	<cfargument name="meters" required="yes" type="numeric">
	
	<cfreturn arguments.meters * 10^5>
</cffunction>

<cffunction name="pico" returntype="numeric" hint="Returns the meters of pico of the same value (meters => picometers)">
	<cfargument name="meters" required="yes" type="numeric">
	
	<cfreturn arguments.meters * 10^6>
</cffunction>

<cffunction name="femto" returntype="numeric" hint="Returns the meters of femto of the same value (meters => femtometers)">
	<cfargument name="meters" required="yes" type="numeric">
	
	<cfreturn arguments.meters * 10^7>
</cffunction>

<cffunction name="kilo" returntype="numeric" hint="Returns the meters of kilo of the same value (meters => kilometers)">
	<cfargument name="meters" required="yes" type="numeric">
	
	<cfreturn arguments.meters * 10^-3>
</cffunction>

<cffunction name="mega" returntype="numeric" hint="Returns the meters of mega of the same value (meters => megameters)">
	<cfargument name="meters" required="yes" type="numeric">
	
	<cfreturn arguments.meters * 10^-6>
</cffunction>

<cffunction name="giga" returntype="numeric" hint="Returns the meters of giga of the same value (meters => gigameters)">
	<cfargument name="meters" required="yes" type="numeric">
	
	<cfreturn arguments.meters * 10^-9>
</cffunction>

<cffunction name="seconds" returntype="numeric" hint="Returns the number of seconds in the passed number of seconds">
	<cfargument name="seconds" required="yes" type="numeric">
	
	<cfreturn arguments.seconds>
</cffunction>

<cffunction name="minutes" returntype="numeric" hint="Returns the number of minutes in the passed number of seconds">
	<cfargument name="seconds" required="yes" type="numeric">
	
	<cfreturn seconds(arguments.seconds) * 60>
</cffunction>

<cffunction name="hours" returntype="numeric" hint="Returns the number of hours in the passed number of seconds">
	<cfargument name="seconds" required="yes" type="numeric">
	
	<cfreturn minutes(arguments.number) * 60>
</cffunction>

<cffunction name="days" returntype="numeric" hint="Returns the number of days in the passed number of seconds">
	<cfargument name="seconds" required="yes" type="numeric">
	
	<cfreturn hours(arguments.number) * 24>
</cffunction>

<cffunction name="weeks" returntype="numeric" hint="Returns the number of weeks in the passed number of seconds">
	<cfargument name="seconds" required="yes" type="numeric">
	
	<cfreturn days(arguments.number) * 7>
</cffunction>

<cffunction name="fortnights" returntype="numeric" hint="Returns the number of fortnights (2 weeks) in the passed number of seconds">
	<cfargument name="seconds" required="yes" type="numeric">
	
	<cfreturn weeks(arguments.number) * 2>
</cffunction>

<cffunction name="months" returntype="numeric" hint="Returns the number of months in the passed number of seconds">
	<cfargument name="seconds" required="yes" type="numeric">
	
	<cfreturn weeks(arguments.number) * 4>
</cffunction>

<cffunction name="years" returntype="numeric" hint="Returns the number of years in the passed number of seconds">
	<cfargument name="seconds" required="yes" type="numeric">
	
	<cfreturn months(arguments.number) * 12>
</cffunction>

<cffunction name="ordinalize" access="public" output="false" returntype="string" hint="Ordinalizes a given number (1st, 2nd, 3rd)">
	<cfargument name="number" type="numeric" required="yes">
	
	<cfset var moddedNumber = arguments.number MOD 100>
	<cfset var ordinalized = "">
	
	<cfif moddedNumber GTE 11 AND moddedNumber LTE 13>
		<cfset ordinalized = arguments.number & "th">
	<cfelse>
		<cfset moddedNumber = arguments.number MOD 10>
		<cfswitch expression="#moddedNumber#">
			<cfcase value="1">
				<cfset ordinalized = arguments.number & "st">
			</cfcase>
			<cfcase value="2">
				<cfset ordinalized = arguments.number & "nd">
			</cfcase>
			<cfcase value="3">
				<cfset ordinalized = arguments.number & "rd">
			</cfcase>
			<cfdefaultcase>
				<cfset ordinalized = arguments.number & "th">
			</cfdefaultcase>
		</cfswitch>
	</cfif>
	
	<cfreturn ordinalized>
</cffunction>