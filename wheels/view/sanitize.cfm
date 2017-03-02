<cfscript>

/**
* Removes all links from an HTML string, leaving just the link text.
*
* ```
* <!--- Outputs "<strong>Wheels</strong> is a framework for ColdFusion." --->
*  #stripLinks("<strong>Wheels</strong> is a framework for <a href=""http://www.adobe.com/products/coldfusion"">ColdFusion</a>.")#
*
* ```
* @doc.section View Helpers
* @doc.category Sanitization Functions
* @doc.tests wheels/tests/view/sanitize/striplinks.cfc
* @html string true The HTML to remove links from.
*
*/
public string function stripLinks(required string html) {
	return REReplaceNoCase(arguments.html, "<a.*?>(.*?)</a>", "\1" , "all");
}

/**
* Removes all HTML tags from a string.
*
* ```
* <!--- Outputs "CFWheels is a framework for ColdFusion." --->
* #stripTags("<strong>Wheels</strong> is a framework for <a href=""http://www.adobe.com/products/coldfusion"">ColdFusion</a>.")#
* ```
* @doc.section View Helpers
* @doc.category Sanitization Functions
* @doc.tests wheels/tests/view/sanitize/striptags.cfc
* @html string true The HTML to remove tag markup from.
*
*/
public string function stripTags(required string html) {
	local.rv = REReplaceNoCase(arguments.html, "<\ *[a-z].*?>", "", "all");
	local.rv = REReplaceNoCase(local.rv, "<\ */\ *[a-z].*?>", "", "all");
	return local.rv;
}

</cfscript>
