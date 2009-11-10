<!--- PUBLIC CONTROLLER REQUEST FUNCTIONS --->

<cffunction name="flash" returntype="any" access="public" output="false" hint="Gets the value of a specific key in the Flash (or the entire flash as a struct if no key is passed in)."
	examples=
	'
		<p><cfoutput>##flash("message")##</cfoutput></p>
	'
	categories="controller-request,flash" chapters="using-the-flash" functions="flashClear,flashDelete,flashIsEmpty,flashCount,flashKeyExists,flashInsert">
	<cfargument name="key" type="string" required="false" hint="The key to get the value for.">
	<cfscript>
		var returnValue = "";
		if (Structkeyexists(arguments, "key"))
		{
			if (flashKeyExists(arguments.key))
				returnValue = session.flash[arguments.key];
		}
		else
		{
			// we can just return session.flash since it is created at the beginning of the request
			// this way we always return what is expected - a struct
			returnValue = session.flash;
		}
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="flashClear" returntype="void" access="public" output="false" hint="Deletes everything from the Flash."
	examples=
	'
		<cfset flashClear()>
	'
	categories="controller-request,flash" chapters="using-the-flash" functions="flash,flashDelete,flashIsEmpty,flashCount,flashKeyExists,flashInsert">
	<cfscript>
		session.flash = {};
	</cfscript>
</cffunction>

<cffunction name="flashCount" returntype="numeric" access="public" output="false" hint="Checks how many keys exist in the Flash."
	examples=
	'
		<cfif flashCount() IS 2>
		  do something...
		</cfif>
	'
	categories="controller-request,flash" chapters="using-the-flash" functions="flash,flashClear,flashDelete,flashIsEmpty,flashKeyExists,flashInsert">
	<cfreturn StructCount(session.flash)>
</cffunction>

<cffunction name="flashDelete" returntype="boolean" access="public" output="false" hint="Deletes a specific key from the Flash."
	examples=
	'
		<cfset flashDelete(key="errorMessage")>
	'
	categories="controller-request,flash" chapters="using-the-flash" functions="flash,flashClear,flashIsEmpty,flashCount,flashKeyExists,flashInsert">
	<cfargument name="key" type="string" required="true" hint="The key to delete.">
	<cfreturn StructDelete(session.flash, arguments.key, true)>
</cffunction>

<cffunction name="flashInsert" returntype="void" access="public" output="false" hint="Inserts a new key/value to the Flash."
	examples=
	'
		<cfset flashInsert(msg="It Worked!")>
	'
	categories="controller-request,flash" chapters="using-the-flash" functions="flash,flashClear,flashDelete,flashIsEmpty,flashCount,flashKeyExists">
	<cfscript>
		session.flash[StructKeyList(arguments)] = arguments[1];
	</cfscript>
</cffunction>

<cffunction name="flashIsEmpty" returntype="boolean" access="public" output="false" hint="Checks if the Flash is empty."
	examples=
	'
		<cfif NOT flashIsEmpty()>
		  <cfabort>
		</cfif>
	'
	categories="controller-request,flash" chapters="using-the-flash" functions="flash,flashClear,flashDelete,flashCount,flashKeyExists,flashInsert">
	<cfreturn NOT flashCount()>
</cffunction>

<cffunction name="flashKeyExists" returntype="boolean" access="public" output="false" hint="Checks if a specific key exists in the Flash."
	examples=
	'
		<cfif flashKeyExists("error")>
		  do something...
		</cfif>
	'
	categories="controller-request,flash" chapters="using-the-flash" functions="flash,flashClear,flashDelete,flashIsEmpty,flashCount,flashInsert">
	<cfargument name="key" type="string" required="true" hint="The key to check if it exists.">
	<cfreturn StructKeyExists(session.flash, arguments.key)>
</cffunction>