<cfscript>
	/**
	*   PUBLIC VIEW HELPER FUNCTIONS
	*/
	public string function stripLinks(required string html) {
		return REReplaceNoCase(arguments.html, "<a.*?>(.*?)</a>", "\1" , "all");
	}

	public string function stripTags(required string html) {  
		local.rv = REReplaceNoCase(arguments.html, "<\ *[a-z].*?>", "", "all");
		local.rv = REReplaceNoCase(local.rv, "<\ */\ *[a-z].*?>", "", "all");
		return local.rv;
	}
</cfscript>
