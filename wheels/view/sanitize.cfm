<cfscript>

/**
 * View helper function.
 * Removes all links from an HTML string, leaving just the link text.
 * Docs: http://docs.cfwheels.org/docs/striplinks
 * Tests: wheels/tests/view/sanitize/striplinks.cfc
 */
public string function stripLinks(required string html) {
	return REReplaceNoCase(arguments.html, "<a.*?>(.*?)</a>", "\1" , "all");
}

/**
 * View helper function.
 * Removes all HTML tags from a string.
 * Docs: http://docs.cfwheels.org/docs/striptags
 * Tests: wheels/tests/view/sanitize/striptags.cfc
 */
public string function stripTags(required string html) {
	local.rv = REReplaceNoCase(arguments.html, "<\ *[a-z].*?>", "", "all");
	local.rv = REReplaceNoCase(local.rv, "<\ */\ *[a-z].*?>", "", "all");
	return local.rv;
}

</cfscript>
