<cfcomponent output="false">

	<cffunction name="init">
		<cfset this.version = "0.8.3">
		<cfreturn this>
	</cffunction>

	<cffunction name="distanceOfTimeInWords" returntype="string" access="public" output="false" hint="Pass in two dates to this method and it will return a string describing the difference between them. If the difference between the two dates you pass in is 2 hours, 13 minutes and 10 seconds it will return 'about 2 hours' for example. This method is useful when you want to describe the time that has passed since a certain event (example: 'Comment added by Joe about 3 weeks ago') or the time left until a certain event (example: 'Next chat session starts in about 5 hours') instead of just writing out the date itself.">
		<cfargument name="fromTime" type="date" required="true" hint="Date to compare from">
		<cfargument name="toTime" type="date" required="true" hint="Date to compare to">
		<cfargument name="includeSeconds" type="boolean" required="false" default="false" hint="Set to true for detailed description when the difference is less than one minute">

		<cfset var loc = {}>
	
		<cfset loc.minuteDiff = dateDiff("n", arguments.fromTime, arguments.toTime)>
		<cfset loc.secondDiff = dateDiff("s", arguments.fromTime, arguments.toTime)>
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
			<cfset loc.hours = ceiling(loc.minuteDiff/60)>
			<cfset loc.output = "about #loc.hours# hours">
		<cfelseif loc.minuteDiff LTE 2880>
			<cfset loc.output = "1 day">
		<cfelseif loc.minuteDiff LTE 43200>
			<cfset loc.days = int(loc.minuteDiff/1440)>
			<cfset loc.output = loc.days & " days">
		<cfelseif loc.minuteDiff LTE 86400>
			<cfset loc.output = "about 1 month">
		<cfelseif loc.minuteDiff LTE 525960>
			<cfset loc.months = int(loc.minuteDiff/43200)>
			<cfset loc.output = loc.months & " months">
		<cfelseif loc.minuteDiff LTE 1051920>
			<cfset loc.output = "about 1 year">
		<cfelse>
			<cfset loc.years = int(loc.minuteDiff/525960)>
			<cfset loc.output = "over " & loc.years & " years">
		</cfif>
	
		<cfreturn loc.output>
	</cffunction>
	
	<cffunction name="timeAgoInWords" returntype="string" access="public" output="false">
		<cfargument name="fromTime" type="date" required="true">
		<cfargument name="includeSeconds" type="boolean" required="false" default="false">
	
		<cfset arguments.toTime = now()>
	
		<cfreturn distanceOfTimeInWords(argumentCollection=arguments)>
	</cffunction>
	
	<cffunction name="timeUntilInWords" returntype="string" access="public" output="false">
		<cfargument name="toTime" type="date" required="true">
		<cfargument name="includeSeconds" type="boolean" required="false" default="false">
	
		<cfset arguments.fromTime = now()>
	
		<cfreturn distanceOfTimeInWords(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="stylesheetLinkTag" returntype="any" access="public" output="false">
		<cfargument name="sources" type="any" required="false" default="application">
		<cfset var loc = {}>
		<cfset arguments.$namedArguments = "sources">
		<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>
	
		<cfset loc.result = "">
		<cfloop list="#arguments.sources#" index="loc.i">
			<cfset loc.href = "#application.wheels.webPath##application.wheels.stylesheetPath#/#trim(loc.i)#">
			<cfif loc.i Does Not Contain ".">
				<cfset loc.href = loc.href & ".css">
			</cfif>
			<cfset loc.result = loc.result & '<link rel="stylesheet" type="text/css" media="all" href="#loc.href#"#loc.attributes# />'>
		</cfloop>
	
		<cfreturn loc.result>
	</cffunction>
	
	<cffunction name="javascriptIncludeTag" returntype="any" access="public" output="false">
		<cfargument name="sources" type="any" required="false" default="application,protoculous">
		<cfset var loc = {}>
		<cfset arguments.$namedArguments = "sources">
		<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>
	
		<cfset loc.result = "">
		<cfloop list="#arguments.sources#" index="loc.i">
			<cfset loc.src = "#application.wheels.webPath##application.wheels.javascriptPath#/#trim(loc.i)#">
			<cfif loc.i Does Not Contain ".">
				<cfset loc.src = loc.src & ".js">
			</cfif>
			<cfset loc.result = loc.result & '<script type="text/javascript" src="#loc.src#"#loc.attributes#></script>'>
		</cfloop>
	
		<cfreturn loc.result>
	</cffunction>
	
	<cffunction name="imageTag" returntype="string" access="public" output="false">
		<cfargument name="source" type="string" required="true">
		<cfset var loc = {}>
		<cfif application.settings.environment IS NOT "production">
			<cfif Left(arguments.source, 7) IS NOT "http://" AND NOT FileExists(ExpandPath("#application.wheels.webPath##application.wheels.imagePath#/#arguments.source#"))>
				<cfset $throw(type="Wheels.ImageFileNotFound", message="Wheels could not find '#expandPath('#application.wheels.webPath##application.wheels.imagePath#/#arguments.source#')#' on the local file system.", extendedInfo="Pass in a correct relative path from '#expandPath('#application.wheels.webPath##application.wheels.imagePath#\')#' to an image.")>
			<cfelseif Left(arguments.source, 7) IS NOT "http://" AND arguments.source Does Not Contain ".jpg" AND arguments.source Does Not Contain ".gif" AND arguments.source Does Not Contain ".png">
				<cfset $throw(type="Wheels.ImageFormatNotSupported", message="Wheels can't read image files with that format.", extendedInfo="Use a GIF, JPG or PNG image instead.")>
			</cfif>
		</cfif>
	
		<cfset loc.category = "image">
		<cfset loc.key = $hashStruct(arguments)>
		<cfset loc.lockName = loc.category & loc.key>
		<!--- double-checked lock --->
		<cflock name="#loc.lockName#" type="readonly" timeout="30">
			<cfset loc.result = $getFromCache(loc.key, loc.category, "internal")>
		</cflock>
		<cfif IsBoolean(loc.result) AND NOT loc.result>
	   	<cflock name="#loc.lockName#" type="exclusive" timeout="30">
				<cfset loc.result = $getFromCache(loc.key, loc.category, "internal")>
				<cfif IsBoolean(loc.result) AND NOT loc.result>
					<cfset arguments.$namedArguments = "source">
					<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>
					<cfif Left(arguments.source, 7) IS "http://">
						<cfset loc.src = arguments.source>
					<cfelse>
						<cfset loc.src = "#application.wheels.webPath##application.wheels.imagePath#/#arguments.source#">
						<cfif NOT StructKeyExists(arguments, "width") OR NOT StructKeyExists(arguments, "height")>
							<cfimage action="info" source="#expandPath(loc.src)#" structname="loc.image">
							<cfif loc.image.width GT 0 AND loc.image.height GT 0>
								<cfset loc.attributes = loc.attributes & " width=""#loc.image.width#"" height=""#loc.image.height#""">
							</cfif>
						</cfif>
					</cfif>
					<cfif NOT StructKeyExists(arguments, "alt")>
						<cfset loc.attributes = loc.attributes & " alt=""#titleize(replaceList(spanExcluding(Reverse(spanExcluding(Reverse(loc.src), "/")), "."), "-,_", " , "))#""">
					</cfif>
					<cfset loc.result = "<img src=""#loc.src#""#loc.attributes# />">
					<cfif application.settings.cacheImages>
						<cfset $addToCache(loc.key, loc.result, 86400, loc.category, "internal")>
					</cfif>
				</cfif>
			</cflock>
		</cfif>
	
		<cfreturn loc.result>
	</cffunction>

</cfcomponent>