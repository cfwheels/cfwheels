<!--- PUBLIC VIEW HELPER FUNCTIONS --->

<cffunction name="stripLinks" returntype="string" access="public" output="false">
	<cfargument name="html" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = REReplaceNoCase(arguments.html, "<a.*?>(.*?)</a>", "\1" , "all");
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="stripTags" returntype="string" access="public" output="false">
	<cfargument name="html" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = REReplaceNoCase(arguments.html, "<\ *[a-z].*?>", "", "all");
		loc.rv = REReplaceNoCase(loc.rv, "<\ */\ *[a-z].*?>", "", "all");
	</cfscript>
	<cfreturn loc.rv>
</cffunction>