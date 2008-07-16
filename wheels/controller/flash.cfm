<cffunction name="flashClear" returntype="void" access="public" output="false" hint="Controller, Request, Delete everything from the Flash.">

	<!---
		HISTORY:
		-

		USAGE:
		-

		EXAMPLES:
		<cfset flashClear()>

		RELATED:
		 * UsingtheFlash (chapter)
		 * [flashClear flashClear()] (function)
		 * [flashDelete flashDelete()] (function)
		 * [flashIsEmpty flashIsEmpty()] (function)
		 * [flashCount flashCount()] (function)
		 * [flashKeyExists flashKeyExists()] (function)
		 * [flashInsert flashInsert()] (function)
		 * [flash flash()] (function)
	--->

	<cfset session.flash = {}>
</cffunction>

<cffunction name="flashDelete" returntype="void" access="public" output="false" hint="Controller, Request, Delete a specific key from the Flash.">
	<cfargument name="key" type="string" required="true" hint="The key to delete">

	<!---
		HISTORY:
		-

		USAGE:
		-

		EXAMPLES:
		<cfset flashDelete(key="errorMessage")>

		RELATED:
		 * UsingtheFlash (chapter)
		 * [flashClear flashClear()] (function)
		 * [flashDelete flashDelete()] (function)
		 * [flashIsEmpty flashIsEmpty()] (function)
		 * [flashCount flashCount()] (function)
		 * [flashKeyExists flashKeyExists()] (function)
		 * [flashInsert flashInsert()] (function)
		 * [flash flash()] (function)
	--->

	<cfset StructDelete(session.flash, arguments.key)>
</cffunction>

<cffunction name="flashIsEmpty" returntype="boolean" access="public" output="false" hint="Controller, Request, Check if the Flash is empty.">

	<!---
		HISTORY:
		-

		USAGE:
		-

		EXAMPLES:
		<cfif NOT flashIsEmpty()>
			<cfabort>
		</cfif>

		RELATED:
		 * UsingtheFlash (chapter)
		 * [flashClear flashClear()] (function)
		 * [flashDelete flashDelete()] (function)
		 * [flashIsEmpty flashIsEmpty()] (function)
		 * [flashCount flashCount()] (function)
		 * [flashKeyExists flashKeyExists()] (function)
		 * [flashInsert flashInsert()] (function)
		 * [flash flash()] (function)
	--->

	<cfif flashCount() IS 0>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="flashCount" returntype="numeric" access="public" output="false" hint="Controller, Request, Check how many keys exist in the Flash.">

	<!---
		HISTORY:
		-

		USAGE:
		-

		EXAMPLES:
		<cfif NOT flashIsEmpty()>
			<cfabort>
		</cfif>

		RELATED:
		 * UsingtheFlash (chapter)
		 * [flashClear flashClear()] (function)
		 * [flashDelete flashDelete()] (function)
		 * [flashIsEmpty flashIsEmpty()] (function)
		 * [flashCount flashCount()] (function)
		 * [flashKeyExists flashKeyExists()] (function)
		 * [flashInsert flashInsert()] (function)
		 * [flash flash()] (function)
	--->

	<cfreturn StructCount(session.flash)>
</cffunction>

<cffunction name="flashKeyExists" returntype="boolean" access="public" output="false" hint="Controller, Request, Check if a specific key exists in the Flash.">
	<cfargument name="key" type="string" required="true" hint="The key to check if it exists">

	<!---
		HISTORY:
		-

		USAGE:
		-

		EXAMPLES:
		<cfif flashKeyExists("error")>
			do something...
		</cfif>

		RELATED:
		 * UsingtheFlash (chapter)
		 * [flashClear flashClear()] (function)
		 * [flashDelete flashDelete()] (function)
		 * [flashIsEmpty flashIsEmpty()] (function)
		 * [flashCount flashCount()] (function)
		 * [flashKeyExists flashKeyExists()] (function)
		 * [flashInsert flashInsert()] (function)
		 * [flash flash()] (function)
	--->

	<cfif StructKeyExists(session.flash, arguments.key)>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="flashInsert" returntype="void" access="public" output="false" hint="Controller, Request, Insert a new key/value to the Flash.">

	<!---
		HISTORY:
		-

		USAGE:
		Use a named argument to set a key/value in the Flash.

		EXAMPLES:
		<cfset flashInsert(msg="It Worked!")>

		RELATED:
		 * UsingtheFlash (chapter)
		 * [flashClear flashClear()] (function)
		 * [flashDelete flashDelete()] (function)
		 * [flashIsEmpty flashIsEmpty()] (function)
		 * [flashCount flashCount()] (function)
		 * [flashKeyExists flashKeyExists()] (function)
		 * [flashInsert flashInsert()] (function)
		 * [flash flash()] (function)
	--->

	<cfset session.flash[StructKeyList(arguments)] = arguments[1]>
</cffunction>

<cffunction name="flash" returntype="string" access="public" output="false" hint="Controller, Request, Get the value of a specific key in the Flash.">
	<cfargument name="key" type="string" required="true" hint="The key to get the value for">

	<!---
		HISTORY:
		-

		USAGE:
		-

		EXAMPLES:
		<p><cfoutput>#flash("message")#</cfoutput></p>

		RELATED:
		 * UsingtheFlash (chapter)
		 * [flashClear flashClear()] (function)
		 * [flashDelete flashDelete()] (function)
		 * [flashIsEmpty flashIsEmpty()] (function)
		 * [flashCount flashCount()] (function)
		 * [flashKeyExists flashKeyExists()] (function)
		 * [flashInsert flashInsert()] (function)
		 * [flash flash()] (function)
	--->

	<cfif flashKeyExists(arguments.key)>
		<cfreturn session.flash[arguments.key]>
	<cfelse>
		<cfreturn "">
	</cfif>
</cffunction>