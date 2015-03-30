<!--- PUBLIC CONTROLLER REQUEST FUNCTIONS --->

<cffunction name="flash" returntype="any" access="public" output="false">
	<cfargument name="key" type="string" required="false">
	<cfscript>
		var loc = {};
		loc.flash = $readFlash();
		if (StructKeyExists(arguments, "key"))
		{
			if (flashKeyExists(key=arguments.key))
			{
				loc.flash = loc.flash[arguments.key];
			}
			else
			{
				loc.flash = "";
			}
		}

		// we can just return the flash since it is created at the beginning of the request
		// this way we always return what is expected - a struct
		loc.rv = loc.flash;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="flashClear" returntype="void" access="public" output="false">
	<cfscript>
		$writeFlash();
	</cfscript>
</cffunction>

<cffunction name="flashCount" returntype="numeric" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.flash = $readFlash();
		loc.rv = StructCount(loc.flash);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="flashDelete" returntype="boolean" access="public" output="false">
	<cfargument name="key" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.flash = $readFlash();
		loc.rv = StructDelete(loc.flash, arguments.key, true);
		$writeFlash(loc.flash);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="flashInsert" returntype="void" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.flash = $readFlash();
		for (loc.key in arguments)
		{
			StructInsert(loc.flash, loc.key, arguments[loc.key], true);
		}
		$writeFlash(loc.flash);
	</cfscript>
</cffunction>

<cffunction name="flashIsEmpty" returntype="boolean" access="public" output="false">
	<cfscript>
		var loc = {};
		if (flashCount())
		{
			loc.rv = false;
		}
		else
		{
			loc.rv = true;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="flashKeep" returntype="void" access="public" output="false">
	<cfargument name="key" type="string" required="false" default="">
	<cfscript>
		$args(args=arguments, name="flashKeep", combine="key/keys");
		request.wheels.flashKeep = arguments.key;
	</cfscript>
</cffunction>

<cffunction name="flashKeyExists" returntype="boolean" access="public" output="false">
	<cfargument name="key" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.flash = $readFlash();
		loc.rv = StructKeyExists(loc.flash, arguments.key);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<!--- PRIVATE FUNCTIONS --->

<cffunction name="$readFlash" returntype="struct" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.rv = {};
		if (!StructKeyExists(arguments, "$locked"))
		{
			loc.lockName = "flashLock" & application.applicationName;
			loc.rv = $simpleLock(name=loc.lockName, type="readonly", execute="$readFlash", executeArgs=arguments);
		}
		else if ($getFlashStorage() == "cookie" && StructKeyExists(cookie, "flash"))
		{
			loc.rv = DeSerializeJSON(cookie.flash);
		}
		else if ($getFlashStorage() == "session" && StructKeyExists(session, "flash"))
		{
			loc.rv = Duplicate(session.flash);
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$writeFlash" returntype="any" access="public" output="false">
	<cfargument name="flash" type="struct" required="false" default="#StructNew()#">
	<cfscript>
		if (!StructKeyExists(arguments, "$locked"))
		{
			// the return is needed here because otherwise we get an abstracthttpconnection error in jetty (when running tests)
			loc.lockName = "flashLock" & application.applicationName;
			loc.rv = $simpleLock(name=loc.lockName, type="exclusive", execute="$writeFlash", executeArgs=arguments);
		}
		else
		{
			if ($getFlashStorage() == "cookie")
			{
				cookie.flash = SerializeJSON(arguments.flash);
			}
			else
			{
				session.flash = arguments.flash;
			}
		}
	</cfscript>
	<cfif StructKeyExists(loc, "rv")>
		<cfreturn loc.rv>
	</cfif>
</cffunction>

<cffunction name="$flashClear" returntype="void" access="public" output="false">
	<cfscript>
		var loc = {};

		// only save the old flash if they want to keep anything
		if (StructKeyExists(request.wheels, "flashKeep"))
		{
			loc.flash = $readFlash();
		}

		// clear the current flash
		flashClear();

		// see if they wanted to keep anything
		if (StructKeyExists(loc, "flash"))
		{
			// delete any keys they don't want to keep
			if (Len(request.wheels.flashKeep))
			{
				for (loc.key in loc.flash)
				{
					if (!ListFindNoCase(request.wheels.flashKeep, loc.key))
					{
						StructDelete(loc.flash, loc.key);
					}
				}
			}

			// write to the flash
			$writeFlash(loc.flash);
		}
	</cfscript>
</cffunction>

<cffunction name="$setFlashStorage" returntype="void" access="public" output="false">
	<cfargument name="storage" type="string" required="true">
	<cfscript>
		variables.$class.flashStorage = arguments.storage;
	</cfscript>
</cffunction>

<cffunction name="$getFlashStorage" returntype="string" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.rv = variables.$class.flashStorage;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>