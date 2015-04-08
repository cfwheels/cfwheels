<!--- PUBLIC VIEW HELPER FUNCTIONS --->

<cffunction name="autoLink" returntype="string" access="public" output="false">
	<cfargument name="text" type="string" required="true">
	<cfargument name="link" type="string" required="false">
	<cfargument name="relative" type="boolean" required="false" default="true">
	<cfscript>
		var loc = {};
		$args(name="autoLink", args=arguments);
		if (arguments.link != "emailAddresses")
		{
			if(arguments.relative)
			{
				arguments.regex = "(?:(?:<a\s[^>]+)?(?:https?://|www\.|\/)[^\s\b]+)";
			}
			else
			{
				arguments.regex = "(?:(?:<a\s[^>]+)?(?:https?://|www\.)[^\s\b]+)";
			}
			arguments.text = $autoLinkLoop(argumentCollection=arguments);
		}
		if (arguments.link != "URLs")
		{
			arguments.regex = "(?:(?:<a\s[^>]+)?(?:[^@\s]+)@(?:(?:[-a-z0-9]+\.)+[a-z]{2,}))";
			arguments.protocol = "mailto:";
			arguments.text = $autoLinkLoop(argumentCollection=arguments);
		}
	</cfscript>
	<cfreturn arguments.text>
</cffunction>

<cffunction name="excerpt" returntype="string" access="public" output="false">
	<cfargument name="text" type="string" required="true">
	<cfargument name="phrase" type="string" required="true">
	<cfargument name="radius" type="numeric" required="false">
	<cfargument name="excerptString" type="string" required="false">
	<cfscript>
	var loc = {};
	$args(name="excerpt", args=arguments);
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
		loc.rv = loc.truncateStart & Mid(arguments.text, loc.startPos, ((loc.endPos+Len(arguments.phrase))-(loc.startPos))) & loc.truncateEnd;
	}
	else
	{
		loc.rv = "";
	}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="highlight" returntype="string" access="public" output="false">
	<cfargument name="text" type="string" required="true">
	<cfargument name="phrases" type="string" required="true">
	<cfargument name="delimiter" type="string" required="false">
	<cfargument name="tag" type="string" required="false">
	<cfargument name="class" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="highlight", args=arguments);
		if (!Len(arguments.text) || !Len(arguments.phrases))
		{
			loc.rv = arguments.text;
		}
		else
		{
			loc.origText = arguments.text;
			loc.iEnd = ListLen(arguments.phrases, arguments.delimiter);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.newText = "";
				loc.phrase = Trim(ListGetAt(arguments.phrases, loc.i, arguments.delimiter));
				loc.pos = 1;
				while (FindNoCase(loc.phrase, loc.origText, loc.pos))
				{
					loc.foundAt = FindNoCase(loc.phrase, loc.origText, loc.pos);
					loc.prevText = Mid(loc.origText, loc.pos, loc.foundAt-loc.pos);
					loc.newText &= loc.prevText;
					if (Find("<", loc.origText, loc.foundAt) < Find(">", loc.origText, loc.foundAt) || !Find(">", loc.origText, loc.foundAt))
					{
						loc.newText &= "<" & arguments.tag & " class=""" & arguments.class & """>" & Mid(loc.origText, loc.foundAt, Len(loc.phrase)) & "</" & arguments.tag & ">";
					}
					else
					{
						loc.newText &= Mid(loc.origText, loc.foundAt, Len(loc.phrase));
					}
					loc.pos = loc.foundAt + Len(loc.phrase);
				}
				loc.newText &= Mid(loc.origText, loc.pos, Len(loc.origText) - loc.pos + 1);
				loc.origText = loc.newText;
			}
			loc.rv = loc.newText;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="simpleFormat" returntype="string" access="public" output="false">
	<cfargument name="text" type="string" required="true">
	<cfargument name="wrap" type="boolean" required="false">
	<cfscript>
		var loc = {};
		$args(name="simpleFormat", args=arguments);
		loc.rv = Trim(arguments.text);
		loc.rv = Replace(loc.rv, "#Chr(13)#", "", "all");
		loc.rv = Replace(loc.rv, "#Chr(10)##Chr(10)#", "</p><p>", "all");
		loc.rv = Replace(loc.rv, "#Chr(10)#", "<br />", "all");

		// add back in our returns so we can strip the tags and re-apply them without issue
		// this is good to be edited the textarea text in it's original format (line returns)
		loc.rv = Replace(loc.rv, "</p><p>", "</p>#Chr(10)##Chr(10)#<p>", "all");
		loc.rv = Replace(loc.rv, "<br />", "<br />#Chr(10)#", "all");

		if (arguments.wrap)
		{
			loc.rv = "<p>" & loc.rv & "</p>";
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="titleize" returntype="string" access="public" output="false">
	<cfargument name="word" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = "";
		loc.iEnd = ListLen(arguments.word, " ");
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.rv = ListAppend(loc.rv, capitalize(ListGetAt(arguments.word, loc.i, " ")), " ");
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="truncate" returntype="string" access="public" output="false">
	<cfargument name="text" type="string" required="true">
	<cfargument name="length" type="numeric" required="false">
	<cfargument name="truncateString" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="truncate", args=arguments);
		if (Len(arguments.text) > arguments.length)
		{
			loc.rv = Left(arguments.text, arguments.length-Len(arguments.truncateString)) & arguments.truncateString;
		}
		else
		{
			loc.rv = arguments.text;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="wordTruncate" returntype="string" access="public" output="false">
	<cfargument name="text" type="string" required="true">
	<cfargument name="length" type="numeric" required="false">
	<cfargument name="truncateString" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="wordTruncate", args=arguments);
		loc.rv = "";
		loc.wordArray = ListToArray(arguments.text, " ", false);
		loc.wordLen = ArrayLen(loc.wordArray);
		if (loc.wordLen > arguments.length)
		{
			for (loc.i=1; loc.i <= arguments.length; loc.i++)
			{
				loc.rv = ListAppend(loc.rv, loc.wordArray[loc.i], " ");
			}
			loc.rv &= arguments.truncateString;
		}
		else
		{
			loc.rv = arguments.text;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<!--- PRIVATE FUNCTIONS --->

<cffunction name="$autoLinkLoop" access="public" returntype="string" output="false">
	<cfargument name="text" type="string" required="true">
	<cfargument name="regex" type="string" required="true">
	<cfargument name="protocol" type="string" required="false" default="">
	<cfscript>
	var loc = {};
	loc.punctuationRegEx = "([^\w\/-]+)$";
	loc.startPosition = 1;
	loc.match = ReFindNoCase(arguments.regex, arguments.text, loc.startPosition, true);
	while (loc.match.pos[1] > 0)
	{
		loc.startPosition = loc.match.pos[1] + loc.match.len[1];
		loc.str = Mid(arguments.text, loc.match.pos[1], loc.match.len[1]);
		if (Left(loc.str, 2) != "<a")
		{
			arguments.text = RemoveChars(arguments.text, loc.match.pos[1], loc.match.len[1]);
			loc.punctuation = ArrayToList(ReMatchNoCase(loc.punctuationRegEx, loc.str));
			loc.str = REReplaceNoCase(loc.str, loc.punctuationRegEx, "", "all");

			// make sure that links beginning with "www." have a protocol
			if (Left(loc.str, 4) == "www." && !Len(arguments.protocol))
			{
				arguments.protocol = "http://";
			}

			arguments.href = arguments.protocol & loc.str;
			loc.element = $element("a", arguments, loc.str, "text,regex,link,protocol,relative") & loc.punctuation;
			arguments.text = Insert(loc.element, arguments.text, loc.match.pos[1]-1);
			loc.startPosition = loc.match.pos[1] + Len(loc.element);
		}
		loc.startPosition++;
		loc.match = ReFindNoCase(arguments.regex, arguments.text, loc.startPosition, true);
	}
	</cfscript>
	<cfreturn arguments.text>
</cffunction>