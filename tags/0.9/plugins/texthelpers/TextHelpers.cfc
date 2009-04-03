<cfcomponent output="false">

	<cffunction name="init">
		<cfset this.version = "0.9">
		<cfreturn this>
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

</cfcomponent>