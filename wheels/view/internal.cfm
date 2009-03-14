<cffunction name="$tag" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="attributes" type="struct" required="false" default="#StructNew()#">
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

<cffunction name="$element" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="attributes" type="struct" required="false" default="#StructNew()#">
	<cfargument name="content" type="string" required="false" default="">
	<cfargument name="skip" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		loc.returnValue = $tag(argumentCollection=arguments);
		loc.returnValue = loc.returnValue & arguments.content;
		loc.returnValue = loc.returnValue & "</" & arguments.name & ">";
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$tagId" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="string" required="true">
	<cfargument name="property" type="string" required="true">
	<cfreturn ListLast(arguments.objectName, ".") & "-" & arguments.property>
</cffunction>

<cffunction name="$tagName" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="string" required="true">
	<cfargument name="property" type="string" required="true">
	<cfreturn ListLast(arguments.objectName, ".") & "[" & arguments.property & "]">
</cffunction>

<cffunction name="$objectFromString" returntype="any" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfscript>
		if (!IsObject(arguments.objectName))
			arguments.objectName = Evaluate(arguments.objectName);
	</cfscript>
	<cfreturn arguments.objectName>
</cffunction>
