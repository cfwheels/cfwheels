<cffunction name="$constructParams" returntype="string" access="private" output="false">
	<cfargument name="params" type="any" required="true">
	<cfscript>
		var loc = {};
		arguments.params = Replace(arguments.params, "&amp;", "&", "all"); // change to using ampersand so we can use it as a list delim below and so we don't "double replace" the ampersand below
		loc.delim = "?";
		if (application.settings.obfuscateUrls)
		{
			loc.returnValue = "";
			loc.iEnd = ListLen(arguments.params, "&");
			for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
			{
				loc.temp = listToArray(ListGetAt(arguments.params, loc.i, "&"), "=");
				loc.returnValue = loc.returnValue & loc.delim & loc.temp[1] & "=";
				loc.delim = "&";
				if (ArrayLen(loc.temp) IS 2)
					loc.returnValue = loc.returnValue & obfuscateParam(loc.temp[2]);
			}
		}
		else
		{
			loc.returnValue = loc.delim & arguments.params;
		}
		loc.returnValue = Replace(loc.returnValue, "&", "&amp;", "all"); // make sure we return XHMTL compliant code
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>