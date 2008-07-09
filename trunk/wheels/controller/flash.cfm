<cffunction name="flashClear" returntype="void" access="public" output="false">
	<cflock scope="session" type="exclusive" timeout="30">
		<cfset session.flash = structNew()>
	</cflock>
</cffunction>

<cffunction name="flashDelete" returntype="void" access="public" output="false">
	<cfargument name="key" type="string" required="true">
	<cflock scope="session" type="exclusive" timeout="30">
		<cfset structDelete(session.flash, arguments.key)>
	</cflock>
</cffunction>

<cffunction name="flashIsEmpty" returntype="boolean" access="public" output="false">
	<cfif flashCount() IS 0>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="flashCount" returntype="numeric" access="public" output="false">
	<cfset var result = 0>
	<cflock scope="session" type="readonly" timeout="30">
		<cfset result = StructCount(session.flash)>
	</cflock>
	<cfreturn result>
</cffunction>

<cffunction name="flashKeyExists" returntype="boolean" access="public" output="false">
	<cfargument name="key" type="string" required="true">
	<cfset var result = false>
	<cflock scope="session" type="readonly" timeout="30">
		<cfif structKeyExists(session.flash, arguments.key)>
			<cfset result = true>
		</cfif>
	</cflock>
	<cfreturn result>
</cffunction>

<cffunction name="flashInsert" returntype="void" access="public" output="false">
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