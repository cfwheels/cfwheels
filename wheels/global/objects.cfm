<cffunction name="$createObjectFromRoot" returntype="any" access="public" output="false">
	<cfargument name="path" type="string" required="true">
	<cfargument name="fileName" type="string" required="true">
	<cfargument name="method" type="string" required="true">
	<cfscript>
		var returnValue = "";
		var loc = {};
		loc.returnVariable = "returnValue";
		loc.method = arguments.method;
		loc.component = ListChangeDelims(arguments.path, ".", "/") & "." & ListChangeDelims(arguments.fileName, ".", "/");
		loc.argumentCollection = arguments;
	</cfscript>
	<cfinclude template="../../root.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction name="$inspect">
	<cfreturn variables>
</cffunction>
