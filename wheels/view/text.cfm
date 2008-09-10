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

<cffunction name="highlight" returntype="string" access="public" output="false" hint="View, Helper, Highlights the phrase(s) everywhere in the text if found by wrapping it in a strong tag (by default).">
	<cfargument name="text" type="string" required="true">
	<cfargument name="phrases" type="string" required="true">
	<cfargument name="highlighter" type="string" required="false" default="<strong class=""highlight"">\1</strong>">

	<!---
		EXAMPLES:
		#highlight(text="You searched for: Wheels", phrases="Wheels")#
		-> You searched for: <strong class="highlight">Wheels</strong>

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
		loc.returnValue = arguments.text;
		loc.iEnd = ListLen(arguments.phrases);
		for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
		{
			loc.returnValue = REReplaceNoCase(loc.returnValue, "(#ListGetAt(arguments.phrases, loc.i)#)", arguments.highlighter, "all");
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