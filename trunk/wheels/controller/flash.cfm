<cffunction name="flashClear" returntype="any" access="public" output="false">
	<cflock scope="session" type="exclusive" timeout="30">
		<cfset session.flash = structNew()>
	</cflock>
</cffunction>

<cffunction name="flashDelete" returntype="any" access="public" output="false">
	<cfargument name="key" type="any" required="true">
	<cflock scope="session" type="exclusive" timeout="30">
		<cfset structDelete(session.flash, arguments.key)>
	</cflock>
</cffunction>

<cffunction name="flashIsEmpty" returntype="any" access="public" output="false">
	<cfif flashCount() IS 0>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="flashCount" returntype="any" access="public" output="false">
	<cfset var result = "">
	<cflock scope="session" type="readonly" timeout="30">
		<cfset result = structCount(session.flash)>
	</cflock>
	<cfreturn result>
</cffunction>

<cffunction name="flashKeyExists" returntype="any" access="public" output="false">
	<cfargument name="key" type="any" required="true">
	<cfset var result = "">
	<cflock scope="session" type="readonly" timeout="30">
		<cfif structKeyExists(session.flash, arguments.key)>
			<cfset result = true>
		<cfelse>
			<cfset result = false>
		</cfif>
	</cflock>
	<cfreturn result>
</cffunction>

<cffunction name="flashInsert" returntype="any" access="public" output="false">
	<cflock scope="session" type="exclusive" timeout="30">
		<cfset session.flash[structKeyList(arguments)] = arguments[1]>
	</cflock>
</cffunction>

<cffunction name="flash" returntype="any" access="public" output="false">
	<cfset var result = "">
	<cflock scope="session" type="readonly" timeout="30">
		<cfif structKeyExists(session.flash, arguments[1])>
			<cfset result = session.flash[arguments[1]]>
		</cfif>
	</cflock>
	<cfreturn result>
</cffunction>