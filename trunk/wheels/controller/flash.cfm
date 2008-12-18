<cffunction name="flashClear" returntype="void" access="public" output="false" hint="Controller, Request, Deletes everything from the Flash.">
	<!---
		EXAMPLES:
		<cfset flashClear()>

		RELATED:
		 * UsingtheFlash (chapter)
		 * [flashDelete flashDelete()] (function)
		 * [flashIsEmpty flashIsEmpty()] (function)
		 * [flashCount flashCount()] (function)
		 * [flashKeyExists flashKeyExists()] (function)
		 * [flashInsert flashInsert()] (function)
		 * [flash flash()] (function)
	--->
	<cfscript>
		session.flash = {};
	</cfscript>
</cffunction>

<cffunction name="flashDelete" returntype="boolean" access="public" output="false" hint="Controller, Request, Deletes a specific key from the Flash.">
	<cfargument name="key" type="string" required="true" hint="The key to delete">
	<!---
		EXAMPLES:
		<cfset flashDelete(key="errorMessage")>

		RELATED:
		 * UsingtheFlash (chapter)
		 * [flashClear flashClear()] (function)
		 * [flashIsEmpty flashIsEmpty()] (function)
		 * [flashCount flashCount()] (function)
		 * [flashKeyExists flashKeyExists()] (function)
		 * [flashInsert flashInsert()] (function)
		 * [flash flash()] (function)
	--->
	<cfreturn StructDelete(session.flash, arguments.key, true)>
</cffunction>

<cffunction name="flashIsEmpty" returntype="boolean" access="public" output="false" hint="Controller, Request, Checks if the Flash is empty.">
	<!---
		EXAMPLES:
		<cfif flashIsEmpty()>
		  do something...
		</cfif>

		RELATED:
		 * UsingtheFlash (chapter)
		 * [flashClear flashClear()] (function)
		 * [flashDelete flashDelete()] (function)
		 * [flashCount flashCount()] (function)
		 * [flashKeyExists flashKeyExists()] (function)
		 * [flashInsert flashInsert()] (function)
		 * [flash flash()] (function)
	--->
	<cfreturn NOT flashCount()>
</cffunction>

<cffunction name="flashCount" returntype="numeric" access="public" output="false" hint="Controller, Request, Checks how many keys exist in the Flash.">
	<!---
		EXAMPLES:
		<cfif flashCount() IS 2>
		  do something...
		</cfif>

		RELATED:
		 * UsingtheFlash (chapter)
		 * [flashClear flashClear()] (function)
		 * [flashDelete flashDelete()] (function)
		 * [flashIsEmpty flashIsEmpty()] (function)
		 * [flashKeyExists flashKeyExists()] (function)
		 * [flashInsert flashInsert()] (function)
		 * [flash flash()] (function)
	--->
	<cfreturn StructCount(session.flash)>
</cffunction>

<cffunction name="flashKeyExists" returntype="boolean" access="public" output="false" hint="Controller, Request, Checks if a specific key exists in the Flash.">
	<cfargument name="key" type="string" required="true" hint="The key to check if it exists">
	<!---
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
		 * [flashInsert flashInsert()] (function)
		 * [flash flash()] (function)
	--->
	<cfreturn StructKeyExists(session.flash, arguments.key)>
</cffunction>

<cffunction name="flashInsert" returntype="void" access="public" output="false" hint="Controller, Request, Inserts a new key/value to the Flash.">
	<!---
		EXAMPLES:
		<cfset flashInsert(msg="It Worked!")>

		RELATED:
		 * UsingtheFlash (chapter)
		 * [flashClear flashClear()] (function)
		 * [flashDelete flashDelete()] (function)
		 * [flashIsEmpty flashIsEmpty()] (function)
		 * [flashCount flashCount()] (function)
		 * [flashKeyExists flashKeyExists()] (function)
		 * [flash flash()] (function)
	--->
	<cfscript>
		session.flash[StructKeyList(arguments)] = arguments[1];
	</cfscript>
</cffunction>

<cffunction name="flash" returntype="any" access="public" output="false" hint="Controller, Request, Gets the value of a specific key in the Flash (or the entire flash as a struct if no key is passed in).">
	<cfargument name="key" type="string" required="false" default="" hint="The key to get the value for">
	<!---
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
	--->
	<cfscript>
		var loc = {};
		loc.returnValue = false;
		if (Len(arguments.key))
		{
			if (flashKeyExists(arguments.key))
				loc.returnValue = session.flash[arguments.key];
		}
		else
		{
			if (!flashIsEmpty())
				loc.returnValue = session.flash;
		}
	</cfscript>
	<cfreturn returnValue>
</cffunction>