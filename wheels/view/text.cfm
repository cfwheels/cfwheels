<cffunction name="autoLink" returntype="string" access="public" output="false" hint="Turns all URLs and email addresses into hyperlinks."
	examples=
	'
		##autoLink("Download Wheels from http://cfwheels.org/download")##
		-> Download Wheels from <a href="http://cfwheels.org/download">http://cfwheels.org/download</a>

		##autoLink("Email us at info@cfwheels.org")##
		-> Email us at <a href="mailto:info@cfwheels.org">info@cfwheels.org</a>
	'
	categories="view-helper,text" functions="excerpt,highlight,simpleFormat,titleize,truncate">
	<cfargument name="text" type="string" required="true" hint="The text to create links in.">
	<cfargument name="link" type="string" required="false" hint="Whether to link URLs, email addresses or both. Possible values are: `all` (default), `URLs` and `emailAddresses`.">
	<cfargument name="relative" type="boolean" required="false" hint="Should we autolink relative urls">
	<cfscript>
		var loc = {};
		$args(name="autoLink", args=arguments);
		if (arguments.link != "emailAddresses")
		{
			if(arguments.relative)
			{
				arguments.regex = "(?:(?:<a\s[^>]+>)?(?:https?://|www\.|\/)[^\s\b]+)";
			}
			else
			{
				arguments.regex = "(?:(?:<a\s[^>]+>)?(?:https?://|www\.)[^\s\b<]+)";
			}
			arguments.text = $autoLinkLoop(argumentCollection=arguments);
		}
		if (arguments.link != "URLs")
		{
			arguments.regex = "(?:(?:<a\s[^>]+>)?(?:[-a-z0-9\.]+)@(?:(?:[-a-z0-9]+\.)+[a-z]{2,}))";
			arguments.protocol = "mailto:";
			arguments.text = $autoLinkLoop(argumentCollection=arguments);
		}
	</cfscript>
	<cfreturn arguments.text>
</cffunction>

<cffunction name="$autoLinkLoop" access="public" returntype="string" output="false">
	<cfargument name="text" type="string" required="true">
	<cfargument name="regex" type="string" required="true">
	<cfargument name="protocol" type="string" required="false" default="">
	<cfscript>
	var loc = {};
	loc.PunctuationRegEx = "([^\w\/-]+)$";
	loc.startPosition = 1;
	loc.match = ReFindNoCase(arguments.regex, arguments.text, loc.startPosition, true);
	while(loc.match.pos[1] gt 0)
	{
		loc.startPosition = loc.match.pos[1] + loc.match.len[1];
		loc.str = Mid(arguments.text, loc.match.pos[1], loc.match.len[1]);
		if (!FindOneOf("<>""'", ReplaceList(loc.str, "&lt;,&gt;,&quot;,&apos;", "<,>,"",'")))
		{
			arguments.text = RemoveChars(arguments.text, loc.match.pos[1], loc.match.len[1]);
			// remove any sort of trailing puncuation
			loc.punctuation = ArrayToList(ReMatchNoCase(loc.PunctuationRegEx, loc.str));
			loc.str = REReplaceNoCase(loc.str, loc.PunctuationRegEx, "", "all");
			// make sure that links beginning with `www.` have a protocol
			if(Left(loc.str, 4) eq "www." && !len(arguments.protocol))
			{
				arguments.protocol = "http://";
			}
			arguments.href = arguments.protocol & loc.str;
			loc.element = $element("a", arguments, loc.str, "text,regex,link,protocol,relative") & loc.punctuation;
			arguments.text = Insert(loc.element, arguments.text, loc.match.pos[1]-1);
			loc.startPosition = loc.match.pos[1] + len(loc.element);
		}
		loc.startPosition++;
		loc.match = ReFindNoCase(arguments.regex, arguments.text, loc.startPosition, true);
	}
	</cfscript>
	<cfreturn arguments.text>
</cffunction>

<cffunction name="excerpt" returntype="string" access="public" output="false" hint="Extracts an excerpt from text that matches the first instance of a given phrase."
	examples=
	'
		##excerpt(text="ColdFusion Wheels is a Rails-like MVC framework for Adobe ColdFusion and Railo", phrase="framework", radius=5)##
		-> ... MVC framework for ...
	'
	categories="view-helper,text" functions="autoLink,highlight,simpleFormat,titleize,truncate">
	<cfargument name="text" type="string" required="true" hint="The text to extract an excerpt from.">
	<cfargument name="phrase" type="string" required="true" hint="The phrase to extract.">
	<cfargument name="radius" type="numeric" required="false" hint="Number of characters to extract surrounding the phrase.">
	<cfargument name="excerptString" type="string" required="false" hint="String to replace first and/or last characters with.">
	<cfargument name="stripTags" type="boolean" required="false" hint="Should we remove all html tags before extracting the except">
	<cfargument name="wholeWords" type="boolean" required="false" hint="when extracting the excerpt, span to to grab whole words.">
	<cfscript>
	var loc = {};
	$args(name="excerpt", args=arguments);
	// by default we return a blank string
	loc.returnValue = "";
	// strip all html tags from text
	if (arguments.stripTags)
	{
		// have to append "this" since we have a method
		// with the same name
		arguments.text = this.stripTags(arguments.text);
	}
	// see if phrase exists in text
	loc.pos = FindNoCase(arguments.phrase, arguments.text, 1);
	// no need to go further if phrase isn't found
	if (loc.pos eq 0)
	{
		return loc.returnValue;
	}

	loc.textLen = Len(arguments.text);
	loc.phraseLen = Len(arguments.phrase);
	loc.startPos = loc.pos - arguments.radius;
	loc.truncateStart = arguments.excerptString;

	if (loc.startPos <= 1)
	{
		loc.startPos = 1;
		loc.truncateStart = "";
	}

	loc.endPos = loc.pos + loc.phraseLen + arguments.radius;
	loc.truncateEnd = arguments.excerptString;

	if (loc.endPos > loc.textLen)
	{
		// need to compensate for the fact that
		// loc.startPos is at least 1
		loc.endPos = loc.textLen + 1;
		loc.truncateEnd = "";
	}

	if (arguments.wholeWords)
	{
		if (loc.startPos > 1)
		{
			loc._startPos = len(arguments.text) - loc.startPos;
			loc.pad = loc._startPos - refind("[[:space:]]", reverse(arguments.text), loc._startPos);
			loc.startPos = loc.startPos - loc.pad;

			// when endPos gte textLen, need to subtract one to get
			// the correct startPos
			if (loc.endPos >= loc.textLen)
			{
				loc.startPos = loc.startPos - 1;
			}
		}

		if (loc.endPos < loc.textLen)
		{
			loc.endPos = refind("[[:space:]]", arguments.text, loc.endPos);
		}
	}

	loc.returnValue = loc.truncateStart & Mid(arguments.text, loc.startPos, (loc.endPos - loc.startPos)) & loc.truncateEnd;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="highlight" returntype="string" access="public" output="false" hint="Highlights the phrase(s) everywhere in the text if found by wrapping it in a `span` tag."
	examples=
	'
		##highlight(text="You searched for: Wheels", phrases="Wheels")##
		-> You searched for: <span class="highlight">Wheels</span>
	'
	categories="view-helper,text" functions="autoLink,excerpt,simpleFormat,titleize,truncate">
	<cfargument name="text" type="string" required="true" hint="Text to search.">
	<cfargument name="phrases" type="string" required="true" hint="List of phrases to highlight.">
	<cfargument name="delimiter" type="string" required="false" hint="Delimiter to use in `phrases` argument.">
	<cfargument name="tag" type="string" required="false" hint="HTML tag to use to wrap the highlighted phrase(s).">
	<cfargument name="class" type="string" required="false" hint="Class to use in the tags wrapping highlighted phrase(s).">
	<cfscript>
		var loc = {};
		$args(name="highlight", args=arguments);
		if (!Len(arguments.text) || !Len(arguments.phrases))
		{
			loc.returnValue = arguments.text;
		}
		else
		{
			loc.origText = arguments.text;
			loc.iEnd = ListLen(arguments.phrases, arguments.delimiter);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i=loc.i+1)
			{
				loc.newText = "";
				loc.phrase = Trim(ListGetAt(arguments.phrases, loc.i, arguments.delimiter));
				loc.pos = 1;
				while (FindNoCase(loc.phrase, loc.origText, loc.pos))
				{
					loc.foundAt = FindNoCase(loc.phrase, loc.origText, loc.pos);
					loc.prevText = Mid(loc.origText, loc.pos, loc.foundAt-loc.pos);
					loc.newText = loc.newText & loc.prevText;
					if (Find("<", loc.origText, loc.foundAt) < Find(">", loc.origText, loc.foundAt) || !Find(">", loc.origText, loc.foundAt))
						loc.newText = loc.newText & "<" & arguments.tag & " class=""" & arguments.class & """>" & Mid(loc.origText, loc.foundAt, Len(loc.phrase)) & "</" & arguments.tag & ">";
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

<cffunction name="simpleFormat" returntype="string" access="public" output="false" hint="Replaces single newline characters with HTML break tags and double newline characters with HTML paragraph tags (properly closed to comply with XHTML standards)."
	examples=
	'
		<!--- How most of your calls will look --->
		##simpleFormat(post.comments)##

		<!--- Demonstrates what output looks like with specific data --->
		<cfsavecontent variable="comment">
			I love this post!

			Here''s why:
			* Short
			* Succinct
			* Awesome
		</cfsavecontent>
		##simpleFormat(comment)##
		-> <p>I love this post!</p>
		   <p>
		       Here''s why:<br />
			   * Short<br />
			   * Succinct<br />
			   * Awesome
		   </p>
	'
	categories="view-helper,text" functions="autoLink,excerpt,highlight,titleize,truncate">
	<cfargument name="text" type="string" required="true" hint="The text to format.">
	<cfargument name="wrap" type="boolean" required="false" hint="Set to `true` to wrap the result in a paragraph.">
	<cfargument name="escapeHtml" type="boolean" required="false" hint="Whether or not to escape HTML characters before applying the line break formatting.">
	<cfscript>
		$args(name="simpleFormat", args=arguments);

		// If we're escaping HTML along with applying the line break formatting
		if(arguments.escapeHtml)
		{
			arguments.text = $htmlFormat(arguments.text);
		}

		arguments.text = Trim(arguments.text);

		arguments.text = Replace(arguments.text, "#Chr(13)#", "", "all");
		arguments.text = Replace(arguments.text, "#Chr(10)##Chr(10)#", "</p><p>", "all");
		arguments.text = Replace(arguments.text, "#Chr(10)#", "<br />", "all");

		// add back in our returns so we can strip the tags and re-apply them without issue
		// this is good to be edited the textarea text in it's original format (line returns)
		arguments.text = Replace(arguments.text, "</p><p>", "</p>#Chr(10)##Chr(10)#<p>", "all");
		arguments.text = Replace(arguments.text, "<br />", "<br />#Chr(10)#", "all");

		if (arguments.wrap)
			arguments.text = "<p>" & arguments.text & "</p>";
	</cfscript>
	<cfreturn arguments.text>
</cffunction>

<cffunction name="titleize" returntype="string" access="public" output="false" hint="Capitalizes all words in the text to create a nicer looking title."
	examples=
	'
		##titleize("Wheels is a framework for ColdFusion")##
		-> Wheels Is A Framework For ColdFusion
	'
	categories="view-helper,text" functions="autoLink,excerpt,highlight,simpleFormat,truncate">
	<cfargument name="word" type="string" required="true" hint="The text to turn into a title.">
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

<cffunction name="truncate" returntype="string" access="public" output="false" hint="Truncates text to the specified length and replaces the last characters with the specified truncate string (which defaults to ""..."")."
	examples=
	'
		##truncate(text="Wheels is a framework for ColdFusion", length=20)##
		-> Wheels is a frame...

		##truncate(text="Wheels is a framework for ColdFusion", truncateString=" (more)")##
		-> Wheels is a framework f (more)
	'
	categories="view-helper,text" functions="autoLink,excerpt,highlight,simpleFormat,titleize">
	<cfargument name="text" type="string" required="true" hint="The text to truncate.">
	<cfargument name="length" type="numeric" required="false" hint="Length to truncate the text to.">
	<cfargument name="truncateString" type="string" required="false" hint="String to replace the last characters with.">
	<cfscript>
		$args(name="truncate", args=arguments);
		if (Len(arguments.text) gt arguments.length)
		{
			arguments.text = Left(arguments.text, arguments.length-Len(arguments.truncateString)) & arguments.truncateString;
		}
	</cfscript>
	<cfreturn arguments.text>
</cffunction>

<cffunction name="wordTruncate" returntype="string" access="public" output="false" hint="Truncates text to the specified length of words and replaces the remaining characters with the specified truncate string (which defaults to ""..."")."
	examples=
	'
		##wordTruncate(text="Wheels is a framework for ColdFusion", length=4)##
		-> Wheels is a framework...

		##truncate(text="Wheels is a framework for ColdFusion", truncateString=" (more)")##
		-> Wheels is a framework for (more)
	'
	categories="view-helper,text" functions="autoLink,excerpt,highlight,simpleFormat,titleize">
	<cfargument name="text" type="string" required="true" hint="The text to truncate.">
	<cfargument name="length" type="numeric" required="false" hint="Number of words to truncate the text to.">
	<cfargument name="truncateString" type="string" required="false" hint="String to replace the last characters with.">
	<cfscript>
		var loc = {};
		$args(name="wordTruncate", args=arguments);
		loc.wordArray = ListToArray(arguments.text, " ", false);
		loc.wordLen = ArrayLen(loc.wordArray);

		if (loc.wordLen gt arguments.length)
		{
			arguments.text = "";
			for (loc.i = 1; loc.i lte arguments.length; loc.i++)
			{
				arguments.text = ListAppend(arguments.text, loc.wordArray[loc.i], " ");
			}
			arguments.text = arguments.text & arguments.truncateString;
		}
	</cfscript>
	<cfreturn arguments.text>
</cffunction>