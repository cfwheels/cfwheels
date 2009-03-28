<cfcomponent output="false">

	<cffunction name="init">
		<cfset this.version = "0.9.1">
		<cfreturn this>
	</cffunction>

	<cffunction name="findByKey" returntype="any" access="public" output="false">
		<cfargument name="key" type="any" required="true">
		<cfargument name="select" type="string" required="false" default="">
		<cfargument name="cache" type="any" required="false" default="">
		<cfargument name="reload" type="boolean" required="false" default="false">
		<cfargument name="parameterize" type="any" required="false" default="true">
		<cfargument name="$create" type="boolean" required="false" default="true">
		<cfargument name="$softDeleteCheck" type="boolean" required="false" default="true">
		<cfscript>
			var returnValue = "";
			returnValue = core.findByKey(arguments.key, arguments.select, arguments.cache, arguments.reload, arguments.parameterize, arguments.$create, arguments.$softDeleteCheck);
			if (not(IsObject(returnValue)))
				$throw(type="Wheels.RecordNotFound", message="The requested record could not be found in the database.", extendedInfo="Make sure that the record exists in the database or catch this error in your code.");
		</cfscript>
		<cfreturn returnValue>
	</cffunction>
</cfcomponent>