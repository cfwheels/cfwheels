<cffunction name="$tag" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="attributes" type="struct" required="true">
	<cfargument name="close" type="boolean" required="false" default="false">
	<cfargument name="skip" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		loc.returnValue = "<" & arguments.name;
		for (loc.key in arguments.attributes)
		{
			if (!ListFindNoCase(arguments.skip, loc.key))
				loc.returnValue = loc.returnValue & " " & LCase(loc.key) & "=""" & arguments.attributes[loc.key] & """";	
		}
		if (arguments.close)
			loc.returnValue = loc.returnValue & " />";
		else
			loc.returnValue = loc.returnValue & ">";		
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>