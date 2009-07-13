<cffunction name="excerpt" returntype="string" access="public" output="false" hint="Extracts an excerpt from text that matches the first instance of phrase.">
	<cfargument name="text" type="string" required="true" hint="The text to extract an excerpt from">
	<cfargument name="phrase" type="string" required="true" hint="The phrase to extract">
	<cfargument name="radius" type="numeric" required="false" default="100" hint="Number of characters to extract surronding the phrase">
	<cfargument name="excerptString" type="string" required="false" default="..." hint="String to replace first and/or last characters with">
	<cfscript>
	var loc = {};
	loc.pos = FindNoCase(arguments.phrase, arguments.text, 1);
	if (loc.pos != 0)
	{
		if ((loc.pos-arguments.radius) <= 1)
		{
			loc.startPos = 1;
			loc.truncateStart = "";
		}
		else
		{
			loc.startPos = loc.pos - arguments.radius;
			loc.truncateStart = arguments.excerptString;
		}
		if ((loc.pos+Len(arguments.phrase)+arguments.radius) > Len(arguments.text))
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
			for (loc.i=1; loc.i <= loc.iEnd; loc.i=loc.i+1)
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

<cffunction name="simpleFormat" returntype="string" access="public" output="false" hint="Replaces single newline characters with HTML break tags and double newline characters with HTML paragraph tags (properly closed to comply with XHTML standards).">
	<cfargument name="text" type="string" required="true" hint="The text to format">
	<cfargument name="wrap" type="boolean" required="false" default="true" hint="Set to true to wrap the result in a paragraph">
	<cfscript>
		var loc = {};
		loc.returnValue = Trim(arguments.text);
		loc.returnValue = Replace(loc.returnValue, "#Chr(13)##Chr(10)#", Chr(10), "all");
		loc.returnValue = Replace(loc.returnValue, "#Chr(10)##Chr(10)#", "</p><p>", "all");
		loc.returnValue = Replace(loc.returnValue, "#Chr(10)#", "<br />", "all");
		if (arguments.wrap)
			loc.returnValue = "<p>" & loc.returnValue & "</p>";
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="stripLinks" returntype="string" access="public" output="false" hint="Removes all links from the html (leaving just the link text).">
	<cfargument name="html" type="string" required="true" hint="The html to remove links from">
	<cfreturn REReplaceNoCase(arguments.html, "<a.*?>(.*?)</a>", "\1" , "all")>
</cffunction>

<cffunction name="stripTags" returntype="string" access="public" output="false" hint="Removes all tags from the html.">
	<cfargument name="html" type="string" required="true" hint="The html to remove links from">
	<cfset var returnValue = "">
	<cfset returnValue = REReplaceNoCase(arguments.html, "<\ *[a-z].*?>", "", "all")>
	<cfset returnValue = REReplaceNoCase(returnValue, "<\ */\ *[a-z].*?>", "", "all")>
	<cfreturn returnValue>
</cffunction>

<cffunction name="titleize" returntype="string" access="public" output="false" hint="Capitalizes all words in the text to create a nicer looking title.">
	<cfargument name="word" type="string" required="true" hint="The text to turn into a title">
	<cfscript>
		var loc = {};
		loc.returnValue = "";
		loc.iEnd = ListLen(arguments.word, " ");
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
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
	<cfscript>
		var loc = {};
		if (Len(arguments.text) > arguments.length)
			loc.returnValue = Left(arguments.text, arguments.length-Len(arguments.truncateString)) & arguments.truncateString;
		else
			loc.returnValue = arguments.text;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>