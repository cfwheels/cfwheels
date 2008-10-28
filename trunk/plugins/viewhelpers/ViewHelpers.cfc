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

	<cffunction name="mailTo" returntype="string" access="public" output="false" hint="View, Helper, Creates a mailto link tag to the specified email address, which is also used as the name of the link unless name is specified.">
		<cfargument name="emailAddress" type="string" required="true" hint="The email address to link to.">
		<cfargument name="name" type="string" required="false" default="" hint="A string to use as the link text ('Joe' or 'Support Department' for example)">
		<cfargument name="encode" type="boolean" required="false" default="false" hint="Pass true here to encode the email address, making it harder for bots to harvest it.">
	
		<!---
			EXAMPLES:
			#mailTo("support@mysite.com")#
	
			#mailTo(emailAddress="support@mysite.com", name="Website Support", encode=true)#
	
			RELATED:
			 * [linkTo linkTo()] (function)
		--->
	
		<cfscript>
			var loc = {};
			arguments.href = "mailto:#arguments.emailAddress#";
			if (Len(arguments.name))
				loc.text = arguments.name;
			else
				loc.text = arguments.emailAddress;
			arguments.$namedArguments = "emailAddress,name,encode";
			loc.attributes = $getAttributes(argumentCollection=arguments);
			loc.returnValue = "<a" & loc.attributes & ">" & loc.text & "</a>";
			if (arguments.encode)
			{
				loc.js = "document.write('#Trim(loc.returnValue)#');";
				loc.encoded = "";
				loc.iEnd = Len(loc.js);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.encoded = loc.encoded & "%" & Right("0" & FormatBaseN(Asc(Mid(loc.js,loc.i,1)),16),2);
				}
				loc.returnValue = "<script type=""text/javascript"" language=""javascript"">eval(unescape('#loc.encoded#'))</script>";
			}
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>

	<cffunction name="autoLink" returntype="string" access="public" output="false" hint="View, Helper, Turns all URLs and e-mail addresses into clickable links.">
		<cfargument name="text" type="string" required="true" hint="The text to create links in.">
		<cfargument name="link" type="string" required="false" default="all" hint="Whether to link URLs, email addresses or both. Possible values are: 'all' (default), 'URLs' and 'emailAddresses'.">
	
		<!---
			EXAMPLES:
			#autoLink("Download Wheels from http://www.cfwheels.com/download")#
			-> Download Wheels from <a href="http://www.cfwheels.com/download">http://www.cfwheels.com/download</a>
	
			#autoLink("Email us at info@cfwheels.com")#
			-> Email us at <a href="mailto:info@cfwheels.com">info@cfwheels.com</a>
	
			RELATED:
			 * [MiscellaneousHelpers Miscellaneous Helpers] (chapter)
			 * [capitalize capitalize()] (function)
			 * [cycle cycle()] (function)
			 * [excerpt excerpt()] (function)
			 * [highlight highlight()] (function)
			 * [pluralize pluralize()] (function)
			 * [resetCycle resetCycle()] (function)
			 * [simpleFormat simpleFormat()] (function)
			 * [singularize singularize()] (function)
			 * [stripLinks stripLinks()] (function)
			 * [stripTags stripTags()] (function)
			 * [titleize titleize()] (function)
			 * [truncate truncate()] (function)
		--->
	
		<cfscript>
			var loc = {};
			loc.urlRegex = "(?ix)([^(url=)|(href=)'""])(((https?)://([^:]+\:[^@]*@)?)([\d\w\-]+\.)?[\w\d\-\.]+\.(com|net|org|info|biz|tv|co\.uk|de|ro|it)(( / [\w\d\.\-@%\\\/:]* )+)?(\?[\w\d\?%,\.\/\##!@:=\+~_\-&amp;]*(?<![\.]))?)";
			loc.mailRegex = "(([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,}))";
			loc.returnValue = arguments.text;
			if (arguments.link IS NOT "emailAddresses")
				loc.returnValue = loc.returnValue.ReplaceAll(loc.urlRegex, "$1<a href=""$2"">$2</a>");
			if (arguments.link IS NOT "URLs")
				loc.returnValue = REReplaceNoCase(loc.returnValue, loc.mailRegex, "<a href=""mailto:\1"">\1</a>", "all");
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>
	
	<cffunction name="cycle" returntype="string" access="public" output="false" hint="View, Helper, Cycles through list values every time it is called.">
		<cfargument name="values" type="string" required="true" hint="List of values to cycle through.">
		<cfargument name="name" type="string" required="false" default="default" hint="Name to give the cycle, useful when you use multiple cycles on a page.">
	
		<!---
			EXAMPLES:
			<tr class="#cycle("even,odd")#">...</tr>
	
			RELATED:
			 * [MiscellaneousHelpers Miscellaneous Helpers] (chapter)
			 * [autoLink autoLink()] (function)
			 * [capitalize capitalize()] (function)
			 * [excerpt excerpt()] (function)
			 * [highlight highlight()] (function)
			 * [pluralize pluralize()] (function)
			 * [resetCycle resetCycle()] (function)
			 * [simpleFormat simpleFormat()] (function)
			 * [singularize singularize()] (function)
			 * [stripLinks stripLinks()] (function)
			 * [stripTags stripTags()] (function)
			 * [titleize titleize()] (function)
			 * [truncate truncate()] (function)
		--->
	
		<cfscript>
			var loc = {};
			if (!StructKeyExists(request.wheels, "cycle"))
				request.wheels.cycle = {};
			if (!StructKeyExists(request.wheels.cycle, arguments.name))
			{
				request.wheels.cycle[arguments.name] = ListGetAt(arguments.values, 1);
			}
			else
			{
				loc.foundAt = ListFindNoCase(arguments.values, request.wheels.cycle[arguments.name]);
				if (loc.foundAt IS ListLen(arguments.values))
					loc.foundAt = 0;
				request.wheels.cycle[arguments.name] = ListGetAt(arguments.values, loc.foundAt + 1);
			}
		</cfscript>
		<cfreturn request.wheels.cycle[arguments.name]>
	</cffunction>
	
	<cffunction name="excerpt" returntype="string" access="public" output="false" hint="View, Helper, Extracts an excerpt from text that matches the first instance of phrase.">
		<cfargument name="text" type="string" required="true" hint="The text to extract an excerpt from.">
		<cfargument name="phrase" type="string" required="true" hint="The phrase to extract.">
		<cfargument name="radius" type="numeric" required="false" default="100" hint="Number of characters to extract surronding the phrase.">
		<cfargument name="excerptString" type="string" required="false" default="..." hint="String to replace first and/or last characters with.">
	
		<!---
			EXAMPLES:
			#excerpt(text="Wheels is a framework for ColdFusion", phrase="framework", radius=5)#
			-> ...is a framework for ...
	
			RELATED:
			 * [MiscellaneousHelpers Miscellaneous Helpers] (chapter)
			 * [autoLink autoLink()] (function)
			 * [capitalize capitalize()] (function)
			 * [cycle cycle()] (function)
			 * [highlight highlight()] (function)
			 * [pluralize pluralize()] (function)
			 * [resetCycle resetCycle()] (function)
			 * [simpleFormat simpleFormat()] (function)
			 * [singularize singularize()] (function)
			 * [stripLinks stripLinks()] (function)
			 * [stripTags stripTags()] (function)
			 * [titleize titleize()] (function)
			 * [truncate truncate()] (function)
		--->
	
		<cfscript>
		var loc = {};
		loc.pos = FindNoCase(arguments.phrase, arguments.text, 1);
		if (loc.pos != 0)
		{
			if ((loc.pos-arguments.radius) LT 1)
			{
				loc.startPos = 1;
				loc.truncateStart = "";
			}
			else
			{
				loc.startPos = loc.pos - arguments.radius;
				loc.truncateStart = arguments.excerptString;
			}
			if ((loc.pos+Len(arguments.phrase)+arguments.radius) GT Len(arguments.text))
			{
				loc.endPos = Len(arguments.text);
				loc.truncateEnd = "";
			}
			else
			{
				loc.endPos = loc.pos + arguments.radius;
				loc.truncateEnd = arguments.excerptString;
			}
			loc.returnValue = loc.truncateStart & Mid(arguments.text, loc.startPos, ((loc.endPos+Len(arguments.phrase))-(loc.startPos))) & loc.truncateEnd;
		}
		else
		{
			loc.returnValue = "";
		}
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>
	
	<cffunction name="highlight" returntype="string" access="public" output="false" hint="View, Helper, Highlights the phrase(s) everywhere in the text if found by wrapping it in a span tag.">
		<cfargument name="text" type="string" required="true">
		<cfargument name="phrases" type="string" required="true">
		<cfargument name="class" type="string" required="false" default="highlight">
	
		<!---
			EXAMPLES:
			#highlight(text="You searched for: Wheels", phrases="Wheels")#
			-> You searched for: <span class="highlight">Wheels</span>
	
			RELATED:
			 * [MiscellaneousHelpers Miscellaneous Helpers] (chapter)
			 * [autoLink autoLink()] (function)
			 * [capitalize capitalize()] (function)
			 * [cycle cycle()] (function)
			 * [excerpt excerpt()] (function)
			 * [pluralize pluralize()] (function)
			 * [resetCycle resetCycle()] (function)
			 * [simpleFormat simpleFormat()] (function)
			 * [singularize singularize()] (function)
			 * [stripLinks stripLinks()] (function)
			 * [stripTags stripTags()] (function)
			 * [titleize titleize()] (function)
			 * [truncate truncate()] (function)
		--->
	
		<cfscript>
			var loc = {};
			if (!Len(arguments.text) || !Len(arguments.phrases))
			{
				loc.returnValue = arguments.text;
			}
			else
			{
				loc.origText = arguments.text;
				loc.iEnd = ListLen(arguments.phrases);
				for (loc.i=1; loc.i LTE loc.iEnd; loc.i++)
				{
					loc.newText = "";
					loc.phrase = Trim(ListGetAt(arguments.phrases, loc.i));
					loc.pos = 1;
					while (FindNoCase(loc.phrase, loc.origText, loc.pos))
					{
						loc.foundAt = FindNoCase(loc.phrase, loc.origText, loc.pos);
						loc.prevText = Mid(loc.origText, loc.pos, loc.foundAt-loc.pos);
						loc.newText = loc.newText & loc.prevText;
						if (Find("<", loc.origText, loc.foundAt) < Find(">", loc.origText, loc.foundAt) || !Find(">", loc.origText, loc.foundAt))
							loc.newText = loc.newText & "<span class=""" & arguments.class & """>" & Mid(loc.origText, loc.foundAt, Len(loc.phrase)) & "</span>";
						else
							loc.newText = loc.newText & Mid(loc.origText, loc.foundAt, Len(loc.phrase));
						loc.pos = loc.foundAt + Len(loc.phrase);
					}
					loc.newText = loc.newText & Mid(loc.origText, loc.pos, Len(loc.origText) - loc.pos + 1);
					loc.origText = loc.newText;
				}
				loc.returnValue = loc.newText;
			}
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>
	
	<cffunction name="resetCycle" returntype="void" access="public" output="false" hint="View, Helper, Resets a cycle so that it starts from the first list value the next time it is called.">
		<cfargument name="name" type="string" required="true" hint="The name of the cycle to reset.">
	
		<!---
			EXAMPLES:
			<cfset resetCycle("tableRows")>
	
			RELATED:
			 * [MiscellaneousHelpers Miscellaneous Helpers] (chapter)
			 * [autoLink autoLink()] (function)
			 * [capitalize capitalize()] (function)
			 * [cycle cycle()] (function)
			 * [excerpt excerpt()] (function)
			 * [highlight highlight()] (function)
			 * [pluralize pluralize()] (function)
			 * [simpleFormat simpleFormat()] (function)
			 * [singularize singularize()] (function)
			 * [stripLinks stripLinks()] (function)
			 * [stripTags stripTags()] (function)
			 * [titleize titleize()] (function)
			 * [truncate truncate()] (function)
		--->
	
		<cfscript>
			var loc = {};
			if (StructKeyExists(request.wheels, "cycle") AND StructKeyExists(request.wheels.cycle, arguments.name))
				StructDelete(request.wheels.cycle, arguments.name);
		</cfscript>
	</cffunction>
	
	<cffunction name="simpleFormat" returntype="string" access="public" output="false" hint="View, Helper, Replaces single newline characters with HTML break tags and double newline characters with HTML paragraph tags (properly closed to comply with XHTML standards).">
		<cfargument name="text" type="string" required="true" hint="The text to format.">
	
		<!---
			EXAMPLES:
			#simpleFormat(params.content)#
	
			RELATED:
			 * [MiscellaneousHelpers Miscellaneous Helpers] (chapter)
			 * [autoLink autoLink()] (function)
			 * [capitalize capitalize()] (function)
			 * [cycle cycle()] (function)
			 * [excerpt excerpt()] (function)
			 * [highlight highlight()] (function)
			 * [pluralize pluralize()] (function)
			 * [resetCycle resetCycle()] (function)
			 * [singularize singularize()] (function)
			 * [stripLinks stripLinks()] (function)
			 * [stripTags stripTags()] (function)
			 * [titleize titleize()] (function)
			 * [truncate truncate()] (function)
		--->
	
		<cfscript>
			var loc = {};
			loc.returnValue = Trim(arguments.text);
			loc.returnValue = Replace(loc.returnValue, "#Chr(10)##Chr(10)#", "</p><p>", "all");
			loc.returnValue = Replace(loc.returnValue, "#Chr(10)#", "<br />", "all");
			if (loc.returnValue != "")
				loc.returnValue = "<p>" & loc.returnValue & "</p>";
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>
	
	<cffunction name="stripLinks" returntype="string" access="public" output="false" hint="View, Helper, Removes all links from the html (leaving just the link text).">
		<cfargument name="html" type="string" required="true" hint="The html to remove links from.">
	
		<!---
			EXAMPLES:
			#stripLinks("Wheels is a framework for <a href='http://www.adobe.com'>ColdFusion</a>")#
			-> Wheels is a framework for ColdFusion
	
			RELATED:
			 * [MiscellaneousHelpers Miscellaneous Helpers] (chapter)
			 * [autoLink autoLink()] (function)
			 * [capitalize capitalize()] (function)
			 * [cycle cycle()] (function)
			 * [excerpt excerpt()] (function)
			 * [highlight highlight()] (function)
			 * [pluralize pluralize()] (function)
			 * [resetCycle resetCycle()] (function)
			 * [simpleFormat simpleFormat()] (function)
			 * [singularize singularize()] (function)
			 * [stripTags stripTags()] (function)
			 * [titleize titleize()] (function)
			 * [truncate truncate()] (function)
		--->
	
		<cfreturn REReplaceNoCase(arguments.html, "<a.*?>(.*?)</a>", "\1" , "all")>
	</cffunction>
	
	<cffunction name="stripTags" returntype="string" access="public" output="false" hint="View, Helper, Removes all tags from the html.">
		<cfargument name="html" type="string" required="true" hint="The html to remove links from.">
	
		<!---
			EXAMPLES:
			#stripTags("Wheels is a <b>framework</b> for <a href='http://www.adobe.com'>ColdFusion</a>")#
			-> Wheels is a framework for ColdFusion
	
			RELATED:
			 * [MiscellaneousHelpers Miscellaneous Helpers] (chapter)
			 * [autoLink autoLink()] (function)
			 * [capitalize capitalize()] (function)
			 * [cycle cycle()] (function)
			 * [excerpt excerpt()] (function)
			 * [highlight highlight()] (function)
			 * [pluralize pluralize()] (function)
			 * [resetCycle resetCycle()] (function)
			 * [simpleFormat simpleFormat()] (function)
			 * [singularize singularize()] (function)
			 * [stripLinks stripLinks()] (function)
			 * [titleize titleize()] (function)
			 * [truncate truncate()] (function)
		--->
	
		<cfreturn REReplaceNoCase(arguments.html, "<[a-z].*?>(.*?)</[a-z]>", "\1" , "all")>
	</cffunction>
	
	<cffunction name="titleize" returntype="string" access="public" output="false" hint="View, Helper, Capitalizes all words in the text to create a nicer looking title.">
		<cfargument name="word" type="string" required="true" hint="The text to turn into a title.">
	
		<!---
			EXAMPLES:
			#titleize("Wheels is a framework for ColdFusion")#
			-> Wheels Is A Framework For ColdFusion
	
			RELATED:
			 * [MiscellaneousHelpers Miscellaneous Helpers] (chapter)
			 * [autoLink autoLink()] (function)
			 * [capitalize capitalize()] (function)
			 * [cycle cycle()] (function)
			 * [excerpt excerpt()] (function)
			 * [highlight highlight()] (function)
			 * [pluralize pluralize()] (function)
			 * [resetCycle resetCycle()] (function)
			 * [simpleFormat simpleFormat()] (function)
			 * [singularize singularize()] (function)
			 * [stripLinks stripLinks()] (function)
			 * [stripTags stripTags()] (function)
			 * [truncate truncate()] (function)
		--->
	
		<cfscript>
			var loc = {};
			loc.returnValue = "";
			loc.iEnd = ListLen(arguments.word, " ");
			for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
			{
				loc.returnValue = ListAppend(loc.returnValue, capitalize(ListGetAt(arguments.word, loc.i, " ")), " ");
			}
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>
	
	<cffunction name="truncate" returntype="string" access="public" output="false" hint="View, Helper, Truncates text to the specified length and replaces the last characters with the specified truncate string (defaults to '...').">
		<cfargument name="text" type="string" required="true" hint="The text to truncate.">
		<cfargument name="length" type="numeric" required="false" default="30" hint="Length to truncate the text to.">
		<cfargument name="truncateString" type="string" required="false" default="..." hint="String to replace the last characters with.">
	
		<!---
			EXAMPLES:
			#truncate(text="Wheels is a framework for ColdFusion", length=20)#
			-> Wheels is a frame...
	
			#truncate(text="Wheels is a framework for ColdFusion", truncateString=" (more)")#
			-> Wheels is a fra... (continued)
	
			RELATED:
			 * [MiscellaneousHelpers Miscellaneous Helpers] (chapter)
			 * [autoLink autoLink()] (function)
			 * [capitalize capitalize()] (function)
			 * [cycle cycle()] (function)
			 * [excerpt excerpt()] (function)
			 * [highlight highlight()] (function)
			 * [pluralize pluralize()] (function)
			 * [resetCycle resetCycle()] (function)
			 * [simpleFormat simpleFormat()] (function)
			 * [singularize singularize()] (function)
			 * [stripLinks stripLinks()] (function)
			 * [stripTags stripTags()] (function)
			 * [titleize titleize()] (function)
		--->
	
		<cfscript>
			var loc = {};
			if (Len(arguments.text) GT arguments.length)
				loc.returnValue = Left(arguments.text, arguments.length-Len(arguments.truncateString)) & arguments.truncateString;
			else
				loc.returnValue = arguments.text;
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>
	
	<cffunction name="formRemoteTag" returntype="any" access="public" output="false">
		<cfargument name="link" type="any" required="false" default="">
		<cfargument name="method" type="any" required="false" default="post">
		<cfargument name="spamProtection" type="any" required="false" default="false">
		<cfargument name="update" type="any" required="false" default="">
		<cfargument name="insertion" type="any" required="false" default="">
		<cfargument name="serialize" type="any" required="false" default="false">
		<cfargument name="onLoading" type="any" required="false" default="">
		<cfargument name="onComplete" type="any" required="false" default="">
		<cfargument name="onSuccess" type="any" required="false" default="">
		<cfargument name="onFailure" type="any" required="false" default="">
		<!--- Accepts URLFor arguments --->
		<cfset var loc = {}>
		<cfset arguments.$namedArguments = "link,method,spamProtection,update,insertion,serialize,onLoading,onComplete,onSuccess,onFailure,controller,action,key,anchor,onlyPath,host,protocol,params">
		<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>
	
		<cfif Len(arguments.link) IS NOT 0>
			<cfset loc.url = arguments.link>
		<cfelse>
			<cfset loc.url = URLFor(argumentCollection=arguments)>
		</cfif>
	
		<cfset loc.ajaxCall = "new Ajax.">
	
		<!--- Figure out the parameters for the Ajax call --->
		<cfif Len(arguments.update) IS NOT 0>
			<cfset loc.ajaxCall = loc.ajaxCall & "Updater('#arguments.update#',">
		<cfelse>
			<cfset loc.ajaxCall = loc.ajaxCall & "Request(">
		</cfif>
	
		<cfset loc.ajaxCall = loc.ajaxCall & "'#loc.url#', { asynchronous:true">
	
		<cfif Len(arguments.insertion) IS NOT 0>
			<cfset loc.ajaxCall = loc.ajaxCall & ",insertion:Insertion.#arguments.insertion#">
		</cfif>
	
		<cfif arguments.serialize>
			<cfset loc.ajaxCall = loc.ajaxCall & ",parameters:Form.serialize(this)">
		</cfif>
	
		<cfif Len(arguments.onLoading) IS NOT 0>
			<cfset loc.ajaxCall = loc.ajaxCall & ",onLoading:#arguments.onLoading#">
		</cfif>
	
		<cfif Len(arguments.onComplete) IS NOT 0>
			<cfset loc.ajaxCall = loc.ajaxCall & ",onComplete:#arguments.onComplete#">
		</cfif>
	
		<cfif Len(arguments.onSuccess) IS NOT 0>
			<cfset loc.ajaxCall = loc.ajaxCall & ",onSuccess:#arguments.onSuccess#">
		</cfif>
	
		<cfif Len(arguments.onFailure) IS NOT 0>
			<cfset loc.ajaxCall = loc.ajaxCall & ",onFailure:#arguments.onFailure#">
		</cfif>
	
		<cfset loc.ajaxCall = loc.ajaxCall & "});">
	
		<cfif arguments.spamProtection>
			<cfset loc.url = "">
		</cfif>
	
		<cfsavecontent variable="loc.output">
			<cfoutput>
				<form action="#loc.url#" method="#arguments.method#" onsubmit="#loc.ajaxCall# return false;"#loc.attributes#>
			</cfoutput>
		</cfsavecontent>
	
		<cfreturn $trimHTML(loc.output)>
	</cffunction>

	<cffunction name="textFieldTag" returntype="any" access="public" output="false">
		<cfargument name="name" type="any" required="true">
		<cfargument name="value" type="any" required="false" default="">
		<cfargument name="label" type="any" required="false" default="">
		<cfargument name="wrapLabel" type="any" required="false" default="true">
		<cfargument name="prepend" type="any" required="false" default="">
		<cfargument name="append" type="any" required="false" default="">
		<cfargument name="prependToLabel" type="any" required="false" default="">
		<cfargument name="appendToLabel" type="any" required="false" default="">
		<cfset var loc = {}>
		<cfset arguments.$namedArguments = "name,value,label,wrapLabel,prepend,append,prependToLabel,appendToLabel">
		<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>
	
		<cfsavecontent variable="loc.output">
			<cfoutput>
				#$formBeforeElement(argumentCollection=arguments)#
				<input name="#arguments.name#" id="#arguments.name#" type="text" value="#HTMLEditFormat($formValue(argumentCollection=arguments))#"#loc.attributes# />
				#$formAfterElement(argumentCollection=arguments)#
			</cfoutput>
		</cfsavecontent>
	
		<cfreturn $trimHTML(loc.output)>
	</cffunction>
	
	<cffunction name="radioButtonTag" returntype="any" access="public" output="false">
		<cfargument name="name" type="any" required="true">
		<cfargument name="value" type="any" required="false" default="">
		<cfargument name="checked" type="any" required="false" default="false">
		<cfargument name="label" type="any" required="false" default="">
		<cfargument name="wrapLabel" type="any" required="false" default="true">
		<cfargument name="prepend" type="any" required="false" default="">
		<cfargument name="append" type="any" required="false" default="">
		<cfargument name="prependToLabel" type="any" required="false" default="">
		<cfargument name="appendToLabel" type="any" required="false" default="">
		<cfset var loc = {}>
		<cfset arguments.$namedArguments = "name,value,checked,label,wrapLabel,prepend,append,prependToLabel,appendToLabel">
		<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>
	
		<cfset loc.name = arguments.name>
		<cfset loc.id = arguments.name & "-" & LCase(Replace(ReReplaceNoCase(arguments.value, "[^a-z0-9 ]", "", "all"), " ", "-", "all"))>
		<cfset arguments.name = loc.id>
	
		<cfsavecontent variable="loc.output">
			<cfoutput>
				#$formBeforeElement(argumentCollection=arguments)#
				<input name="#loc.name#" id="#loc.id#" type="radio" value="#$formValue(argumentCollection=arguments)#"<cfif arguments.checked> checked="checked"</cfif>#loc.attributes# />
				#$formAfterElement(argumentCollection=arguments)#
			</cfoutput>
		</cfsavecontent>
	
		<cfreturn $trimHTML(loc.output)>
	</cffunction>
	
	<cffunction name="checkBoxTag" returntype="any" access="public" output="false">
		<cfargument name="name" type="any" required="true">
		<cfargument name="value" type="any" required="false" default="1">
		<cfargument name="checked" type="any" required="false" default="false">
		<cfargument name="label" type="any" required="false" default="">
		<cfargument name="wrapLabel" type="any" required="false" default="true">
		<cfargument name="prepend" type="any" required="false" default="">
		<cfargument name="append" type="any" required="false" default="">
		<cfargument name="prependToLabel" type="any" required="false" default="">
		<cfargument name="appendToLabel" type="any" required="false" default="">
		<cfset var loc = {}>
		<cfset arguments.$namedArguments = "name,value,checked,label,wrapLabel,prepend,append,prependToLabel,appendToLabel">
		<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>
	
		<cfsavecontent variable="loc.output">
			<cfoutput>
				#$formBeforeElement(argumentCollection=arguments)#
				<input name="#arguments.name#" id="#arguments.name#" type="checkbox" value="#arguments.value#"<cfif arguments.checked> checked="checked"</cfif>#loc.attributes# />
				#$formAfterElement(argumentCollection=arguments)#
			</cfoutput>
		</cfsavecontent>
	
		<cfreturn $trimHTML(loc.output)>
	</cffunction>
	
	<cffunction name="passwordFieldTag" returntype="any" access="public" output="false">
		<cfargument name="name" type="any" required="true">
		<cfargument name="value" type="any" required="false" default="">
		<cfargument name="label" type="any" required="false" default="">
		<cfargument name="wrapLabel" type="any" required="false" default="true">
		<cfargument name="prepend" type="any" required="false" default="">
		<cfargument name="append" type="any" required="false" default="">
		<cfargument name="prependToLabel" type="any" required="false" default="">
		<cfargument name="appendToLabel" type="any" required="false" default="">
		<cfset var loc = {}>
		<cfset arguments.$namedArguments = "name,value,label,wrapLabel,prepend,append,prependToLabel,appendToLabel">
		<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>
	
		<cfsavecontent variable="loc.output">
			<cfoutput>
				#$formBeforeElement(argumentCollection=arguments)#
				<input name="#arguments.name#" id="#arguments.name#" type="password" value="#HTMLEditFormat($formValue(argumentCollection=arguments))#"#loc.attributes# />
				#$formAfterElement(argumentCollection=arguments)#
			</cfoutput>
		</cfsavecontent>
	
		<cfreturn $trimHTML(loc.output)>
	</cffunction>
	
	<cffunction name="hiddenFieldTag" returntype="any" access="public" output="false">
		<cfargument name="name" type="any" required="true">
		<cfargument name="value" type="any" required="false" default="">
		<cfset var loc = {}>
		<cfset arguments.$namedArguments = "name,value">
		<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>
	
		<cfset loc.value = $formValue(argumentCollection=arguments)>
		<cfif application.settings.obfuscateURLs AND StructKeyExists(request.wheels, "currentFormMethod") AND request.wheels.currentFormMethod IS "get">
			<cfset loc.value = obfuscateParam(loc.value)>
		</cfif>
	
		<cfsavecontent variable="loc.output">
			<cfoutput>
				<input name="#arguments.name#" id="#arguments.name#" type="hidden" value="#HTMLEditFormat(loc.value)#"#loc.attributes# />
			</cfoutput>
		</cfsavecontent>
	
		<cfreturn $trimHTML(loc.output)>
	</cffunction>
	
	<cffunction name="textAreaTag" returntype="any" access="public" output="false">
		<cfargument name="name" type="any" required="true">
		<cfargument name="value" type="any" required="false" default="">
		<cfargument name="label" type="any" required="false" default="">
		<cfargument name="wrapLabel" type="any" required="false" default="true">
		<cfargument name="prepend" type="any" required="false" default="">
		<cfargument name="append" type="any" required="false" default="">
		<cfargument name="prependToLabel" type="any" required="false" default="">
		<cfargument name="appendToLabel" type="any" required="false" default="">
		<cfset var loc = {}>
		<cfset arguments.$namedArguments = "name,value,label,wrapLabel,prepend,append,prependToLabel,appendToLabel">
		<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>
	
		<cfset loc.output = "">
		<cfset loc.output = loc.output & $formBeforeElement(argumentCollection=arguments)>
		<cfset loc.output = loc.output & "<textarea name=""#arguments.name#"" id=""#arguments.name#""#loc.attributes#>">
		<cfset loc.output = loc.output & $formValue(argumentCollection=arguments)>
		<cfset loc.output = loc.output & "</textarea>">
		<cfset loc.output = loc.output & $formAfterElement(argumentCollection=arguments)>
	
		<cfreturn loc.output>
	</cffunction>
	
</cfcomponent>