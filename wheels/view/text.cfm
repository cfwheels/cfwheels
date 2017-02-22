<cfscript>

/**
 * Turns all URLs and email addresses into clickable links.
 * http://docs.cfwheels.org/docs/autolink
 * Tests are in wheels/tests/view/text/autolink.cfc.
 */
public string function autoLink(required string text, string link, boolean relative=true) {
	$args(name="autoLink", args=arguments);
	local.rv = arguments.text;

	// Create anchor elements with an href attribute for all URLs found in the text.
	if (arguments.link != "emailAddresses") {
		if (arguments.relative) {
			arguments.regex = "(?:(?:<a\s[^>]+)?(?:https?://|www\.|\/)[^\s\b]+)";
		} else {
			arguments.regex = "(?:(?:<a\s[^>]+)?(?:https?://|www\.)[^\s\b]+)";
		}
		local.rv = $autoLinkLoop(text=local.rv, argumentCollection=arguments);
	}

	// Create anchor elements with a mailto attribute for all email addresses found in the text.
	if (arguments.link != "urls") {
		arguments.regex = "(?:(?:<a\s[^>]+)?(?:[^@\s]+)@(?:(?:[-a-z0-9]+\.)+[a-z]{2,}))";
		arguments.protocol = "mailto:";
		local.rv = $autoLinkLoop(text=local.rv, argumentCollection=arguments);
	}

	return local.rv;
}

/**
 * Extracts an excerpt from text that matches the first instance of a given phrase.
 * http://docs.cfwheels.org/docs/excerpt
 * Tests are in wheels/tests/view/text/excerpt.cfc.
 */
public string function excerpt(required string text, required string phrase, numeric radius, string excerptString) {
	$args(name="excerpt", args=arguments);
	local.pos = FindNoCase(arguments.phrase, arguments.text, 1);

	// Return an empty value if the text wasn't found at all.
	if (!local.pos) {
		return "";
	}

	if ((local.pos - arguments.radius) <= 1) {
		local.startPos = 1;
		local.truncateStart = "";
	} else {
		local.startPos = local.pos - arguments.radius;
		local.truncateStart = arguments.excerptString;
	}

	if ((local.pos + Len(arguments.phrase) + arguments.radius) > Len(arguments.text)) {
		local.endPos = Len(arguments.text);
		local.truncateEnd = "";
	} else {
		local.endPos = local.pos + arguments.radius;
		local.truncateEnd = arguments.excerptString;
	}
	local.len = (local.endPos + Len(arguments.phrase)) - local.startPos;
	local.mid = Mid(arguments.text, local.startPos, local.len);
	local.rv = local.truncateStart & local.mid & local.truncateEnd;
	return local.rv;
}

/**
 * Highlights the phrase(s) everywhere in the text if found by wrapping it in a span tag.
 * http://docs.cfwheels.org/docs/highlight
 * Tests are in wheels/tests/view/text/highlight.cfc.
 */
public string function highlight(
	required string text,
	required string phrases,
	string delimiter,
	string tag,
	string class
) {
	$args(name="highlight", args=arguments);

	// Return the passed in text as is if it's blank or the passed in phrase is blank.
	if (!Len(arguments.text) || !Len(arguments.phrases)) {
		return arguments.text;
	}

	local.originalText = arguments.text;
	local.iEnd = ListLen(arguments.phrases, arguments.delimiter);
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		local.newText = "";
		local.phrase = Trim(ListGetAt(arguments.phrases, local.i, arguments.delimiter));
		local.pos = 1;
		while (FindNoCase(local.phrase, local.originalText, local.pos)) {
			local.foundAt = FindNoCase(local.phrase, local.originalText, local.pos);
			local.previousText = Mid(local.originalText, local.pos, local.foundAt - local.pos);
			local.newText &= local.previousText;
			local.mid = Mid(local.originalText, local.foundAt, Len(local.phrase));
			local.startBracket = Find("<", local.originalText, local.foundAt);
			local.endBracket = Find(">", local.originalText, local.foundAt);
			if (local.startBracket < local.endBracket || !local.endBracket) {
				local.newText &= "<" & arguments.tag & " class=""" & arguments.class & """>";
				local.newText &= local.mid;
				local.newText &= "</" & arguments.tag & ">";
			} else {
				local.newText &= local.mid;
			}
			local.pos = local.foundAt + Len(local.phrase);
		}
		local.newText &= Mid(local.originalText, local.pos, Len(local.originalText) - local.pos + 1);
		local.originalText = local.newText;
	}
	local.rv = local.newText;
	return local.rv;
}

public string function simpleFormat(required string text, boolean wrap) {
	$args(name="simpleFormat", args=arguments);
	local.rv = Trim(arguments.text);
	local.rv = Replace(local.rv, "#Chr(13)#", "", "all");
	local.rv = Replace(local.rv, "#Chr(10)##Chr(10)#", "</p><p>", "all");
	local.rv = Replace(local.rv, "#Chr(10)#", "<br />", "all");

	// add back in our returns so we can strip the tags and re-apply them without issue
	// this is good to be edited the textarea text in it's original format (line returns)
	local.rv = Replace(local.rv, "</p><p>", "</p>#Chr(10)##Chr(10)#<p>", "all");
	local.rv = Replace(local.rv, "<br />", "<br />#Chr(10)#", "all");

	if (arguments.wrap)
	{
		local.rv = "<p>" & local.rv & "</p>";
	}
	return local.rv;
}

	public string function titleize(required string word) {
		local.rv = "";
		local.iEnd = ListLen(arguments.word, " ");
		for (local.i=1; local.i <= local.iEnd; local.i++)
		{
			local.rv = ListAppend(local.rv, capitalize(ListGetAt(arguments.word, local.i, " ")), " ");
		}
		return local.rv;
	}

	public string function truncate(
		required string text,
		numeric length,
		string truncateString
	) {
		$args(name="truncate", args=arguments);
		if (Len(arguments.text) > arguments.length)
		{
			local.rv = Left(arguments.text, arguments.length-Len(arguments.truncateString)) & arguments.truncateString;
		}
		else
		{
			local.rv = arguments.text;
		}
		return local.rv;
	}
	public string function wordTruncate(
		required string text,
		numeric length,
		string truncateString
	) {
		$args(name="wordTruncate", args=arguments);
		local.rv = "";
		local.wordArray = ListToArray(arguments.text, " ", false);
		local.wordLen = ArrayLen(local.wordArray);
		if (local.wordLen > arguments.length)
		{
			for (local.i=1; local.i <= arguments.length; local.i++)
			{
				local.rv = ListAppend(local.rv, local.wordArray[local.i], " ");
			}
			local.rv &= arguments.truncateString;
		}
		else
		{
			local.rv = arguments.text;
		}
		return local.rv;
	}

	/*
	* PRIVATE FUNCTIONS
	*/

	public string function $autoLinkLoop(
		required string text,
		required string regex,
		string protocol=""
	) {
		local.punctuationRegEx = "([^\w\/-]+)$";
		local.startPosition = 1;
		local.match = ReFindNoCase(arguments.regex, arguments.text, local.startPosition, true);
		while (local.match.pos[1] > 0)
		{
			local.startPosition = local.match.pos[1] + local.match.len[1];
			local.str = Mid(arguments.text, local.match.pos[1], local.match.len[1]);
			if (Left(local.str, 2) != "<a")
			{
				arguments.text = RemoveChars(arguments.text, local.match.pos[1], local.match.len[1]);
				local.punctuation = ArrayToList(ReMatchNoCase(local.punctuationRegEx, local.str));
				local.str = REReplaceNoCase(local.str, local.punctuationRegEx, "", "all");

				// make sure that links beginning with "www." have a protocol
				if (Left(local.str, 4) == "www." && !Len(arguments.protocol))
				{
					arguments.protocol = "http://";
				}

				arguments.href = arguments.protocol & local.str;
				local.element = $element("a", arguments, local.str, "text,regex,link,protocol,relative") & local.punctuation;
				arguments.text = Insert(local.element, arguments.text, local.match.pos[1]-1);
				local.startPosition = local.match.pos[1] + Len(local.element);
			}
			local.startPosition++;
			local.match = ReFindNoCase(arguments.regex, arguments.text, local.startPosition, true);
		}
		return arguments.text;
	}
</cfscript>
