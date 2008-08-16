<cffunction name="capitalize" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfif Len(arguments.text)>
		<cfreturn UCase(Left(arguments.text, 1)) & Mid(arguments.text, 2, Len(arguments.text)-1)>
	</cfif>
</cffunction>

<cffunction name="titleize" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfset var loc = {}>

	<cfset loc.result = "">
	<cfloop list="#arguments.text#" delimiters=" " index="loc.i">
		<cfset loc.result = ListAppend(loc.result, capitalize(loc.i), " ")>
	</cfloop>

	<cfreturn loc.result>
</cffunction>

<cffunction name="simpleFormat" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="yes">
	<cfset var loc = {}>

	<!--- Replace single newline characters with HTML break tags and double newline characters with HTML paragraph tags --->
	<cfset loc.output = trim(arguments.text)>
	<cfset loc.output = Replace(loc.output, "#chr(10)##chr(10)#", "</p><p>", "all")>
	<cfset loc.output = Replace(loc.output, "#chr(10)#", "<br />", "all")>
	<cfif loc.output IS NOT "">
		<cfset loc.output = "<p>" & loc.output & "</p>">
	</cfif>

	<cfreturn loc.output>
</cffunction>

<cffunction name="autoLink" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="yes">
	<cfargument name="link" type="any" required="no" default="all">
	<cfargument name="attributes" type="any" required="no" default="">
	<cfset var loc = {}>

	<cfset loc.urlRegex = "(?ix)([^(url=)|(href=)'""])(((https?)://([^:]+\:[^@]*@)?)([\d\w\-]+\.)?[\w\d\-\.]+\.(com|net|org|info|biz|tv|co\.uk|de|ro|it)(( / [\w\d\.\-@%\\\/:]* )+)?(\?[\w\d\?%,\.\/\##!@:=\+~_\-&amp;]*(?<![\.]))?)">
	<cfset loc.mailRegex = "(([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,}))">

	<cfif Len(arguments.attributes) IS NOT 0>
		<!--- Add a space to the beginning so it can be directly inserted in the HTML link element below --->
		<cfset arguments.attributes = " " & arguments.attributes>
	</cfif>

	<cfset loc.output = arguments.text>
	<cfif arguments.link IS NOT "urls">
		<!--- Auto link all email addresses --->
		<cfset loc.output = REReplaceNoCase(loc.output, loc.mailRegex, "<a href=""mailto:\1""#arguments.attributes#>\1</a>", "all")>
	</cfif>
	<cfif arguments.link IS NOT "emails">
		<!--- Auto link all URLs --->
		<cfset loc.output = loc.output.ReplaceAll(loc.urlRegex, "$1<a href=""$2""#arguments.attributes#>$2</a>")>
	</cfif>

	<cfreturn loc.output>
</cffunction>

<cffunction name="highlight" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="yes">
	<cfargument name="phrase" type="any" required="yes">
	<cfargument name="class" type="any" required="no" default="highlight">
	<cfreturn REReplaceNoCase(arguments.text, "(#arguments.phrase#)", "<span class=""#arguments.class#"">\1</span>", "all")>
</cffunction>

<cffunction name="stripTags" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfreturn REReplaceNoCase(arguments.text, "<[a-z].*?>(.*?)</[a-z]>", "\1" , "all")>
</cffunction>

<cffunction name="stripLinks" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfreturn REReplaceNoCase(arguments.text, "<a.*?>(.*?)</a>", "\1" , "all")>
</cffunction>

<cffunction name="excerpt" returntype="string" access="public" output="false">
	<cfargument name="text" type="string" required="true">
	<cfargument name="phrase" type="string" required="true">
	<cfargument name="radius" type="numeric" required="false" default="100">
	<cfargument name="excerptString" type="string" required="false" default="...">

	<!---
		EXAMPLES:
		<cfoutput>#excerpt(text="Wheels is a framework for ColdFusion", length=20)#</cfoutput>

		RELATED:
		 * [capitalize capitalize()] (function)
		 * [titleize titleize()] (function)
		 * [simpleFormat simpleFormat()] (function)
		 * [autoLink autoLink()] (function)
		 * [highlight highlight()] (function)
		 * [stripTags stripTags()] (function)
		 * [stripLinks stripLinks()] (function)
		 * [excerpt excerpt()] (function)
		 * [truncate truncate()] (function)
	--->

	<cfscript>
	var loc = {};
	loc.pos = FindNoCase(arguments.phrase, arguments.text, 1);
	if (loc.pos != 0)
	{
		loc.excerptStringStart = arguments.excerptString;
		loc.excerptStringEnd = arguments.excerptString;
		loc.start = loc.pos - arguments.radius;
		if (loc.start <= 0)
		{
			loc.start = 1;
			loc.excerptStringStart = "";
		}
		loc.count = Len(arguments.phrase) + (arguments.radius*2);
		if (loc.count > (Len(arguments.text)-loc.start))
			loc.excerptStringEnd = "";
		loc.returnValue = loc.excerptStringStart & Mid(arguments.text, loc.start, loc.count) & loc.excerptStringEnd;
	}
	else
	{
		loc.returnValue = "";
	}

	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="truncate" returntype="string" access="public" output="false" hint="View, Helper, Truncates a string to the specified length and replaces the last characters with the specified truncate string (defaults to '...').">
	<cfargument name="text" type="string" required="true" hint="Text to truncate.">
	<cfargument name="length" type="numeric" required="false" default="30" hint="Length of the truncated string.">
	<cfargument name="truncateString" type="string" required="false" default="..." hint="String to replace the last characters with.">

	<!---
		EXAMPLES:
		<cfoutput>#truncate(text="Wheels is a framework for ColdFusion", length=20)#</cfoutput>

		RELATED:
		 * [capitalize capitalize()] (function)
		 * [titleize titleize()] (function)
		 * [simpleFormat simpleFormat()] (function)
		 * [autoLink autoLink()] (function)
		 * [highlight highlight()] (function)
		 * [stripTags stripTags()] (function)
		 * [stripLinks stripLinks()] (function)
		 * [excerpt excerpt()] (function)
		 * [truncate truncate()] (function)
	--->

	<cfscript>
		var loc = {};
		if (Len(arguments.text) > arguments.length)
			loc.returnValue = Left(arguments.text, arguments.length-Len(arguments.truncateString)) & arguments.truncateString;
		else
			loc.returnValue = arguments.text;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>