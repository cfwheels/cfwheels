<!--- PUBLIC VIEW HELPER FUNCTIONS --->

<cffunction name="stripLinks" returntype="string" access="public" output="false">
	<cfargument name="html" type="string" required="true">
	<cfscript>
		local.rv = REReplaceNoCase(arguments.html, "<a.*?>(.*?)</a>", "\1" , "all");
	</cfscript>
	<cfreturn local.rv>
</cffunction>

<cffunction name="stripTags" returntype="string" access="public" output="false">
	<cfargument name="html" type="string" required="true">
	<cfscript>
		local.rv = REReplaceNoCase(arguments.html, "<\ *[a-z].*?>", "", "all");
		local.rv = REReplaceNoCase(local.rv, "<\ */\ *[a-z].*?>", "", "all");
	</cfscript>
	<cfreturn local.rv>
</cffunction>
