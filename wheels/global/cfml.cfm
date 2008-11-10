<cffunction name="$include" returntype="string" access="public" output="false">
	<cfargument name="$path" type="string" required="true">
	<cfset var returnValue = "">
	<cfsavecontent variable="returnValue">
		<cfinclude template="#LCase(arguments.$path)#">
	</cfsavecontent>
	<cfreturn Trim(returnValue)>
</cffunction>

<cffunction name="$directory" returntype="any" access="public" output="false">
	<cfset var loc = StructNew()>
	<cfset arguments.name = "loc.returnValue">
	<cfdirectory attributeCollection="#arguments#">
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$file" returntype="any" access="public" output="false">
	<cfset var loc = StructNew()>
	<cfset arguments.variable = "loc.returnValue">
	<cffile attributeCollection="#arguments#">
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$throw" returntype="void" access="public" output="false">
	<cfthrow attributeCollection="#arguments#">
</cffunction>

<cffunction name="$invoke" returntype="any" access="public" output="false">
	<cfset var loc = StructNew()>
	<cfset arguments.returnVariable = "loc.returnValue">
	<cfinvoke attributeCollection="#arguments#">
	<cfif StructKeyExists(loc, "returnValue")>
		<cfreturn loc.returnValue>
	</cfif>
</cffunction>

<cffunction name="$location" returntype="void" access="public" output="false">
	<cflocation attributeCollection="#arguments#">
</cffunction>

<cffunction name="$dbinfo" returntype="any" access="public" output="false">
	<cfset var loc = StructNew()>
	<cfset arguments.name = "loc.returnValue">
	<!--- we have to use this cfif here to get around a bug with railo --->
	<cfif StructKeyExists(arguments, "table")>
		<cfdbinfo datasource="#arguments.datasource#" name="#arguments.name#" type="#arguments.type#" username="#arguments.username#" password="#arguments.password#" table="#arguments.table#">
	<cfelse>
		<cfdbinfo datasource="#arguments.datasource#" name="#arguments.name#" type="#arguments.type#" username="#arguments.username#" password="#arguments.password#">
	</cfif>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$dump" returntype="void" access="public" output="true">
	<cfargument name="var" type="any" required="true">
	<cfargument name="abort" type="boolean" required="false" default="true">
	<cfdump var="#arguments.var#">
	<cfif arguments.abort>
		<cfabort>
	</cfif>
</cffunction>
