<cfcomponent output="false">

	<cffunction name="init">
		<cfset this.version = "0.9">
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
		<cfargument name="sources" type="any" required="false" default="application">
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

	<cffunction name="mailTo" returntype="string" access="public" output="false" hint="Creates a mailto link tag to the specified email address, which is also used as the name of the link unless name is specified.">
		<cfargument name="emailAddress" type="string" required="true" hint="The email address to link to">
		<cfargument name="name" type="string" required="false" default="" hint="A string to use as the link text ('Joe' or 'Support Department' for example)">
		<cfargument name="encode" type="boolean" required="false" default="false" hint="Pass true here to encode the email address, making it harder for bots to harvest it">
	
		<!---
			#mailTo("support@mysite.com")#
	
			#mailTo(emailAddress="support@mysite.com", name="Website Support", encode=true)#
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
				for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
				{
					loc.encoded = loc.encoded & "%" & Right("0" & FormatBaseN(Asc(Mid(loc.js,loc.i,1)),16),2);
				}
				loc.returnValue = "<script type=""text/javascript"">eval(unescape('#loc.encoded#'))</script>";
			}
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>

	<cffunction name="autoLink" returntype="string" access="public" output="false" hint="Turns all URLs and e-mail addresses into clickable links.">
		<cfargument name="text" type="string" required="true" hint="The text to create links in">
		<cfargument name="link" type="string" required="false" default="all" hint="Whether to link URLs, email addresses or both. Possible values are: 'all' (default), 'URLs' and 'emailAddresses'">
	
		<!---
			#autoLink("Download Wheels from http://www.cfwheels.com/download")#
			-> Download Wheels from <a href="http://www.cfwheels.com/download">http://www.cfwheels.com/download</a>
	
			#autoLink("Email us at info@cfwheels.com")#
			-> Email us at <a href="mailto:info@cfwheels.com">info@cfwheels.com</a>
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
	
	<cffunction name="cycle" returntype="string" access="public" output="false" hint="Cycles through list values every time it is called.">
		<cfargument name="values" type="string" required="true" hint="List of values to cycle through">
		<cfargument name="name" type="string" required="false" default="default" hint="Name to give the cycle, useful when you use multiple cycles on a page">
	
		<!---
			<tr class="#cycle("even,odd")#">...</tr>
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
	
	<cffunction name="excerpt" returntype="string" access="public" output="false" hint="Extracts an excerpt from text that matches the first instance of phrase.">
		<cfargument name="text" type="string" required="true" hint="The text to extract an excerpt from">
		<cfargument name="phrase" type="string" required="true" hint="The phrase to extract">
		<cfargument name="radius" type="numeric" required="false" default="100" hint="Number of characters to extract surronding the phrase">
		<cfargument name="excerptString" type="string" required="false" default="..." hint="String to replace first and/or last characters with">
	
		<!---
			#excerpt(text="Wheels is a framework for ColdFusion", phrase="framework", radius=5)#
			-> ...is a framework for ...
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
	
	<cffunction name="highlight" returntype="string" access="public" output="false" hint="Highlights the phrase(s) everywhere in the text if found by wrapping it in a span tag.">
		<cfargument name="text" type="string" required="true">
		<cfargument name="phrases" type="string" required="true">
		<cfargument name="class" type="string" required="false" default="highlight">
	
		<!---
			#highlight(text="You searched for: Wheels", phrases="Wheels")#
			-> You searched for: <span class="highlight">Wheels</span>
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
				for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
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
	
	<cffunction name="resetCycle" returntype="void" access="public" output="false" hint="Resets a cycle so that it starts from the first list value the next time it is called.">
		<cfargument name="name" type="string" required="true" hint="The name of the cycle to reset">
	
		<!---
			<cfset resetCycle("tableRows")>
		--->
	
		<cfscript>
			var loc = {};
			if (StructKeyExists(request.wheels, "cycle") AND StructKeyExists(request.wheels.cycle, arguments.name))
				StructDelete(request.wheels.cycle, arguments.name);
		</cfscript>
	</cffunction>
	
	<cffunction name="simpleFormat" returntype="string" access="public" output="false" hint="Replaces single newline characters with HTML break tags and double newline characters with HTML paragraph tags (properly closed to comply with XHTML standards).">
		<cfargument name="text" type="string" required="true" hint="The text to format">
	
		<!---
			#simpleFormat(params.content)#
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
	
	<cffunction name="stripLinks" returntype="string" access="public" output="false" hint="Removes all links from the html (leaving just the link text).">
		<cfargument name="html" type="string" required="true" hint="The html to remove links from">
	
		<!---
			#stripLinks("Wheels is a framework for <a href='http://www.adobe.com'>ColdFusion</a>")#
			-> Wheels is a framework for ColdFusion
		--->
	
		<cfreturn REReplaceNoCase(arguments.html, "<a.*?>(.*?)</a>", "\1" , "all")>
	</cffunction>
	
	<cffunction name="stripTags" returntype="string" access="public" output="false" hint="Removes all tags from the html.">
		<cfargument name="html" type="string" required="true" hint="The html to remove links from">
	
		<!---
			#stripTags("Wheels is a <b>framework</b> for <a href='http://www.adobe.com'>ColdFusion</a>")#
			-> Wheels is a framework for ColdFusion
		--->

		<cfset var returnValue = arguments.html>
		<cfset returnValue = REReplaceNoCase(returnValue,"<\ *[a-z].*?>", "", "all")>
		<cfset returnValue = REReplaceNoCase(returnValue,"<\ */\ *[a-z].*?>", "", "all")>
		<cfreturn returnValue>
	</cffunction>
	
	<cffunction name="titleize" returntype="string" access="public" output="false" hint="Capitalizes all words in the text to create a nicer looking title.">
		<cfargument name="word" type="string" required="true" hint="The text to turn into a title">
	
		<!---
			#titleize("Wheels is a framework for ColdFusion")#
			-> Wheels Is A Framework For ColdFusion
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
	
	<cffunction name="truncate" returntype="string" access="public" output="false" hint="Truncates text to the specified length and replaces the last characters with the specified truncate string (defaults to '...').">
		<cfargument name="text" type="string" required="true" hint="The text to truncate">
		<cfargument name="length" type="numeric" required="false" default="30" hint="Length to truncate the text to">
		<cfargument name="truncateString" type="string" required="false" default="..." hint="String to replace the last characters with">
	
		<!---
			#truncate(text="Wheels is a framework for ColdFusion", length=20)#
			-> Wheels is a frame...
	
			#truncate(text="Wheels is a framework for ColdFusion", truncateString=" (more)")#
			-> Wheels is a fra... (continued)
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
	
	<cffunction name="fileFieldTag" returntype="any" access="public" output="false">
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
				<input type="file" name="#arguments.name#" id="#arguments.name#" value="#HTMLEditFormat($formValue(argumentCollection=arguments))#"#loc.attributes# />
				#$formAfterElement(argumentCollection=arguments)#
			</cfoutput>
		</cfsavecontent>
	
		<cfreturn $trimHTML(loc.output)>
	</cffunction>
	
	<cffunction name="selectTag" returntype="any" access="public" output="false">
		<cfargument name="name" type="any" required="true">
		<cfargument name="value" type="any" required="false" default="">
		<cfargument name="options" type="any" required="true">
		<cfargument name="includeBlank" type="any" required="false" default="false">
		<cfargument name="multiple" type="any" required="false" default="false">
		<cfargument name="valueField" type="any" required="false" default="id">
		<cfargument name="textField" type="any" required="false" default="name">
		<cfargument name="label" type="any" required="false" default="">
		<cfargument name="wrapLabel" type="any" required="false" default="true">
		<cfargument name="prepend" type="any" required="false" default="">
		<cfargument name="append" type="any" required="false" default="">
		<cfargument name="prependToLabel" type="any" required="false" default="">
		<cfargument name="appendToLabel" type="any" required="false" default="">
		<cfset var loc = {}>
		<cfset arguments.$namedArguments = "name,value,options,includeBlank,multiple,valueField,textField,label,wrapLabel,prepend,append,prependToLabel,appendToLabel">
		<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>
	
		<cfsavecontent variable="loc.output">
			<cfoutput>
				#$formBeforeElement(argumentCollection=arguments)#
				<select name="#arguments.name#" id="#arguments.name#"<cfif arguments.multiple> multiple</cfif>#loc.attributes#>
				<cfif NOT IsBoolean(arguments.includeBlank) OR arguments.includeBlank>
					<cfif NOT IsBoolean(arguments.includeBlank)>
						<cfset loc.text = arguments.includeBlank>
					<cfelse>
						<cfset loc.text = "">
					</cfif>
					<option value="">#loc.text#</option>
				</cfif>
				#$optionsForSelect(argumentCollection=arguments)#
				</select>
				#$formAfterElement(argumentCollection=arguments)#
			</cfoutput>
		</cfsavecontent>
	
		<cfreturn $trimHTML(loc.output)>
	</cffunction>

	<cffunction name="dateTimeSelectTag" returntype="any" access="public" output="false" hint="Returns HTML select tags for choosing year, month, day, hour, minute and second">
		<cfargument name="dateOrder" type="any" required="false" default="month,day,year" hint="Use to change the order of or exclude date select tags">
		<cfargument name="timeOrder" type="any" required="false" default="hour,minute,second" hint="Use to change the order of or exclude time select tags ">
		<cfargument name="dateSeparator" type="any" required="false" default=" " hint="Use to change the character that is displayed between the date select tags ">
		<cfargument name="timeSeparator" type="any" required="false" default=":" hint="Use to change the character that is displayed between the time select tags ">
		<cfargument name="separator" type="any" required="false" default=" - " hint="Use to change the character that is displayed between the first and second set of select tags ">
		<!---
			DETAILS:
			You can pass in a different order to change the order in which the select tags appear on the page.
			You can also exclude one select tag completely by specifying an order with only one or two items.
			You can also change the separator character that goes between the select tags and the character that goes between the entire set of select tags (after the first three date select tags but before the last three time select tags).
			EXAMPLES:
			#dateTimeSelectTag(dateOrder="year,month,day", monthDisplay="abbreviations")#
		--->
		<cfset arguments.$functionName = "dateTimeSelectTag">
		<cfreturn $dateTimeSelect(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="dateSelectTag" returntype="any" access="public" output="false" hint="Returns HTML select tags for choosing year, month and day">
		<cfargument name="order" type="any" required="false" default="month,day,year" hint="Use to change the order of or exclude select tags">
		<cfargument name="separator" type="any" required="false" default=" " hint="Use to change the character that is displayed between the select tags">
		<!---
			DETAILS:
			You can pass in a different order to change the order in which the select tags appear on the page.
			You can also exclude one select tag completely by specifying an order with only one or two items.
			You can also change the separator character that goes between the select tags.
			EXAMPLES:
			#dateSelectTag(order="year,month,day")#
		--->
		<cfreturn $dateSelectTag(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="timeSelectTag" returntype="any" access="public" output="false" hint="Returns HTML select tags for choosing hour, minute and second">
		<cfargument name="order" type="any" required="false" default="hour,minute,second" hint="Use to change the order of or exclude select tags">
		<cfargument name="separator" type="any" required="false" default=":" hint="Use to change the character that is displayed between the select tags">
		<!---
			DETAILS:
			You can pass in a different order to change the order in which the select tags appear on the page.
			You can also exclude one select tag completely by specifying an order with only one or two items.
			You can also change the separator character that goes between the select tags.
			EXAMPLES:
			#timeSelectTag(order="hour,minute", separator=" - ")#
		--->
		<cfreturn $timeSelectTag(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="yearSelectTag" returntype="any" access="public" output="false" hint="Returns a HTML select tag with years as options">
		<cfargument name="startYear" type="any" required="false" default="#year(now())-5#" hint="First year in select list">
		<cfargument name="endYear" type="any" required="false" default="#year(now())+5#" hint="Last year in select list">
		<!---
			DETAILS:
			By default the option tags will include 11 years, 5 on each side of the current year.
			You can change this by passing in startYear and endYear.
			EXAMPLES:
			#yearSelectTag()#
			#yearSelectTag(startYear=1900, endYear=year(now()))#
		--->
		<cfreturn $yearSelectTag(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="monthSelectTag" returntype="any" access="public" output="false" hint="Returns a HTML select tag with months as options">
		<cfargument name="monthDisplay" type="any" required="false" default="names" hint="pass in 'names', 'numbers' or 'abbreviations' to control display">
		<!---
			DETAILS:
			You can use the monthDisplay argument to control the display of the option tags.
			By default the full month names will be used but you can change to show abbreviations or just month numbers.
			EXAMPLES:
			#monthSelectTag()#
			#monthSelectTag(monthDisplay="abbreviations")#
		--->
		<cfreturn $monthSelectTag(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="daySelectTag" returntype="any" access="public" output="false" hint="Returns a HTML select tag with days as options">
		<!---
			DETAILS:
			This method returns days 1-31.
			EXAMPLES:
			#daySelectTag()#
		--->
		<cfreturn $daySelectTag(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="hourSelectTag" returntype="any" access="public" output="false" hint="Returns a HTML select tag with days as options">
		<!---
			DETAILS:
			This method returns hours from 0-23.
			EXAMPLES:
			#hourSelectTag()#
		--->
		<cfreturn $hourSelectTag(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="minuteSelectTag" returntype="any" access="public" output="false" hint="Returns a HTML select tag with minutes as options">
		<cfargument name="minuteStep" type="any" required="false" default="1">
		<!---
			DETAILS:
			This method returns minutes from 0 to 59.
			If you don't want every minute between 0 and 59 included in the drop-down you can limit it by using the minuteStep argument.
			If you for example pass in minuteStep=15 you will get 00,15,30 and 45 as options.
			EXAMPLES:
			#minuteSelectTag()#
			#minuteSelectTag(minuteStep=10)#
		--->
		<cfreturn $minuteSelectTag(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="secondSelectTag" returntype="any" access="public" output="false" hint="Returns a HTML select tag with seconds as options">
		<!---
			DETAILS:
			This method returns seconds from 0 to 59.
			EXAMPLES:
			#secondSelectTag()#
		--->
		<cfreturn $secondSelectTag(argumentCollection=arguments)>
	</cffunction>

</cfcomponent>