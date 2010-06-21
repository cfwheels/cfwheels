<!--- PUBLIC CONTROLLER REQUEST FUNCTIONS --->

<cffunction name="flash" returntype="any" access="public" output="false" hint="Gets the value of a specific key in the Flash (or the entire flash as a struct if no key is passed in)."
	examples=
	'
		<p><cfoutput>##flash("message")##</cfoutput></p>
	'
	categories="controller-request,flash" chapters="using-the-flash" functions="flashClear,flashDelete,flashIsEmpty,flashCount,flashKeyExists,flashInsert">
	<cfargument name="key" type="string" required="false" hint="The key to get the value for.">
	<cfargument name="$flash" type="struct" required="false" default="#$readFlash()#">
	<cfscript>
		if (StructKeyExists(arguments, "key"))
		{
			if (flashKeyExists(key=arguments.key, $flash=arguments.$flash))
				return StructFind(arguments.$flash, arguments.key);
			else
				return "";
		}
		else
		{
			// we can just return the flash since it is created at the beginning of the request
			// this way we always return what is expected - a struct
			return arguments.$flash;
		}
	</cfscript>
</cffunction>

<cffunction name="flashClear" returntype="void" access="public" output="false" hint="Deletes everything from the Flash."
	examples=
	'
		<cfset flashClear()>
	'
	categories="controller-request,flash" chapters="using-the-flash" functions="flash,flashDelete,flashIsEmpty,flashCount,flashKeyExists,flashInsert">
	<cfargument name="$sessionScope" type="struct" required="false">
	<cfargument name="$flashStorage" type="string" required="false" default="#get('flashStorage')#">
	<cfscript>
		if (arguments.$flashStorage == "session" && StructKeyExists(arguments, "$sessionScope"))
		{
			// special handling for when we need to clear the session stored flash from a coldfusion event
			// we cannot access the session scope directly then and we have to pass it through instead
			StructClear(arguments.$sessionScope.flash);
		}
		else
		{
			$writeFlash(StructNew());
		}
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
	<cfargument name="$flash" type="struct" required="false" default="#$readFlash()#">
	<cfreturn StructCount(arguments.$flash)>
</cffunction>

<cffunction name="flashDelete" returntype="boolean" access="public" output="false" hint="Deletes a specific key from the Flash."
	examples=
	'
		<cfset flashDelete(key="errorMessage")>
	'
	categories="controller-request,flash" chapters="using-the-flash" functions="flash,flashClear,flashIsEmpty,flashCount,flashKeyExists,flashInsert">
	<cfargument name="key" type="string" required="true" hint="The key to delete.">
	<cfargument name="$flash" type="struct" required="false" default="#$readFlash()#">
	<cfscript>
		var returnValue = "";
		returnValue = StructDelete(arguments.$flash, arguments.key, true);
		$writeFlash(arguments.$flash);
		return returnValue;
	</cfscript>
</cffunction>

<cffunction name="flashInsert" returntype="void" access="public" output="false" hint="Inserts a new key/value to the Flash."
	examples=
	'
		<cfset flashInsert(msg="It Worked!")>
	'
	categories="controller-request,flash" chapters="using-the-flash" functions="flash,flashClear,flashDelete,flashIsEmpty,flashCount,flashKeyExists">
	<cfargument name="$flash" type="struct" required="false" default="#$readFlash()#">
	<cfscript>
		StructInsert(arguments.$flash, ListLast(ListSort(StructKeyList(arguments), "textnocase")), arguments[2], true);
		$writeFlash(arguments.$flash);
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
	<cfreturn !flashCount()>
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
	<cfargument name="$flash" type="struct" required="false" default="#$readFlash()#">
	<cfreturn StructKeyExists(arguments.$flash, arguments.key)>
</cffunction>

<cffunction name="$readFlash" returntype="struct" access="public" output="false">
	<cfargument name="flashStorage" type="string" required="false" default="#get('flashStorage')#">
	<cfscript>
		if (arguments.flashStorage == "session" && StructKeyExists(session, "flash"))
			return Duplicate(session.flash);
		else if (arguments.flashStorage == "cookie" && StructKeyExists(cookie, "flash"))
			return DeSerializeJSON(cookie.flash);
		return StructNew();
	</cfscript>
</cffunction>

<cffunction name="$writeFlash" returntype="void" access="public" output="false">
	<cfargument name="flash" type="struct" required="true">
	<cfargument name="flashStorage" type="string" required="false" default="#get('flashStorage')#">
	<cfscript>
		if (arguments.flashStorage == "session")
			session.flash = arguments.flash;
		else if (arguments.flashStorage == "cookie")
			cookie.flash = SerializeJSON(arguments.flash);
	</cfscript>
</cffunction>