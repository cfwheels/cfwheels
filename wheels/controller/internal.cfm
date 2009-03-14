<cffunction name="$constructParams" returntype="string" access="public" output="false">
	<cfargument name="params" type="any" required="true">
	<cfscript>
		var loc = {};
		arguments.params = Replace(arguments.params, "&amp;", "&", "all"); // change to using ampersand so we can use it as a list delim below and so we don't "double replace" the ampersand below
		// when rewriting is off we will already have "?controller=" etc in the url so we have to continue with an ampersand
		if (application.wheels.URLRewriting == "Off")
			loc.delim = "&";
		else
			loc.delim = "?";		
		loc.returnValue = "";
		loc.iEnd = ListLen(arguments.params, "&");
		for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
		{
			loc.temp = listToArray(ListGetAt(arguments.params, loc.i, "&"), "=");
			loc.returnValue = loc.returnValue & loc.delim & loc.temp[1] & "=";
			loc.delim = "&";
			if (ArrayLen(loc.temp) IS 2)
			{
				if (application.wheels.obfuscateUrls)
					loc.returnValue = loc.returnValue & obfuscateParam(URLEncodedFormat(loc.temp[2]));
				else
					loc.returnValue = loc.returnValue & URLEncodedFormat(loc.temp[2]);
			}
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>