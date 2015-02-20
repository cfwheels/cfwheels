<!--- PUBLIC CONTROLLER REQUEST FUNCTIONS --->

<cffunction name="flash" returntype="any" access="public" output="false" hint="Returns the value of a specific key in the Flash (or the entire Flash as a struct if no key is passed in)."
	examples=
	'
		<!--- Display "message" item in flash --->
		<cfoutput>
			<cfif flashKeyExists("message")>
				<p class="message">
					##flash("message")##
				</p>
			</cfif>
		</cfoutput>

		<!--- Display all flash items --->
		<cfoutput>
			<cfset allFlash = flash()>
			<cfloop list="##StructKeyList(allFlash)##" index="flashItem">
				<p class="##flashItem##">
					##flash(flashItem)##
				</p>
			</cfloop>
		</cfoutput>
	'
	categories="controller-request,flash" chapters="using-the-flash" functions="flashClear,flashCount,flashDelete,flashInsert,flashIsEmpty,flashKeep,flashKeyExists,flashMessages">
	<cfargument name="key" type="string" required="false" hint="The key to get the value for.">
	<cfscript>
		var loc = {};
		var $flsh = $readFlash();
		if (StructKeyExists(arguments, "key"))
		{
			if (flashKeyExists(key=arguments.key))
			{
				$flsh = $flsh[arguments.key];
			}
			else
			{
				$flsh = "";
			}
		}
		
		// we can just return the flash since it is created at the beginning of the request
		// this way we always return what is expected - a struct
		loc.rv = $flsh;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="flashClear" returntype="void" access="public" output="false" hint="Deletes everything from the Flash."
	examples=
	'
		<cfset flashClear()>
	'
	categories="controller-request,flash" chapters="using-the-flash" functions="flash,flashCount,flashDelete,flashInsert,flashIsEmpty,flashKeep,flashKeyExists,flashMessages">
	<cfscript>
		$writeFlash();
	</cfscript>
</cffunction>

<cffunction name="flashCount" returntype="numeric" access="public" output="false" hint="Returns how many keys exist in the Flash."
	examples=
	'
		<cfif flashCount() gt 0>
			do something...
		</cfif>
	'
	categories="controller-request,flash" chapters="using-the-flash" functions="flash,flashClear,flashDelete,flashInsert,flashIsEmpty,flashKeep,flashKeyExists,flashMessages">
	<cfscript>
		var loc = {};
		loc.flash = $readFlash();
		loc.rv = StructCount(loc.flash);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="flashDelete" returntype="boolean" access="public" output="false" hint="Deletes a specific key from the Flash."
	examples=
	'
		<cfset flashDelete(key="errorMessage")>
	'
	categories="controller-request,flash" chapters="using-the-flash" functions="flash,flashClear,flashCount,flashInsert,flashIsEmpty,flashKeep,flashKeyExists,flashMessages">
	<cfargument name="key" type="string" required="true" hint="The key to delete.">
	<cfscript>
		var loc = {};
		loc.flash = $readFlash();
		loc.rv = StructDelete(loc.flash, arguments.key, true);
		$writeFlash(loc.flash);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="flashInsert" returntype="void" access="public" output="false" hint="Inserts a new key/value into the Flash."
	examples=
	'
		<cfset flashInsert(msg="It Worked!")>
	'
	categories="controller-request,flash" chapters="using-the-flash" functions="flash,flashClear,flashCount,flashDelete,flashIsEmpty,flashKeep,flashKeyExists,flashMessages">
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

<cffunction name="flashIsEmpty" returntype="boolean" access="public" output="false" hint="Returns whether or not the Flash is empty."
	examples=
	'
		<cfif not flashIsEmpty()>
			<div id="messages">
				<cfset allFlash = flash()>
				<cfloop list="##StructKeyList(allFlash)##" index="flashItem">
					<p class="##flashItem##">
						##flash(flashItem)##
					</p>
				</cfloop>
			</div>
		</cfif>
	'
	categories="controller-request,flash" chapters="using-the-flash" functions="flash,flashClear,flashCount,flashDelete,flashInsert,flashKeep,flashKeyExists,flashMessages">
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

<cffunction name="flashKeep" returntype="void" access="public" output="false" hint="Make the entire Flash or specific key in it stick around for one more request."
	examples=
	'
		<!--- Keep the entire Flash for the next request --->
		<cfset flashKeep()>

		<!--- Keep the "error" key in the Flash for the next request --->
		<cfset flashKeep("error")>

		<!--- Keep both the "error" and "success" keys in the Flash for the next request --->
		<cfset flashKeep("error,success")>
	'
	categories="controller-request,flash" chapters="using-the-flash" functions="flash,flashClear,flashCount,flashDelete,flashInsert,flashIsEmpty,flashKeyExists,flashMessages">
	<cfargument name="key" type="string" required="false" default="" hint="A key or list of keys to flag for keeping. This argument is also aliased as `keys`.">
	<cfscript>
		$args(args=arguments, name="flashKeep", combine="key/keys");
		request.wheels.flashKeep = arguments.key;
	</cfscript>
</cffunction>

<cffunction name="flashKeyExists" returntype="boolean" access="public" output="false" hint="Checks if a specific key exists in the Flash."
	examples=
	'
		<cfif flashKeyExists("error")>
			<cfoutput>
				<p>##flash("error")##</p>
			</cfoutput>
		</cfif>
	'
	categories="controller-request,flash" chapters="using-the-flash" functions="flash,flashClear,flashCount,flashDelete,flashInsert,flashIsEmpty,flashKeep,flashMessages">
	<cfargument name="key" type="string" required="true" hint="The key to check if it exists.">
	<cfscript>
		var loc = {};
		loc.flash = $readFlash();
		loc.rv = StructKeyExists(loc.flash, arguments.key);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$readFlash" returntype="struct" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.rv = {};
		if (!StructKeyExists(arguments, "$locked"))
		{
			loc.rv = $simpleLock(name="flashLock#application.applicationName#", type="readonly", execute="$readFlash", executeArgs=arguments);
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

<cffunction name="$writeFlash" returntype="void" access="public" output="false">
	<cfargument name="flash" type="struct" required="false" default="#StructNew()#">
	<cfscript>
		if (!StructKeyExists(arguments, "$locked"))
		{
			return $simpleLock(name="flashLock#application.applicationName#", type="exclusive", execute="$writeFlash", executeArgs=arguments);
		}
		if ($getFlashStorage() == "cookie")
		{
			cookie.flash = SerializeJSON(arguments.flash);
		}
		else
		{
			session.flash = arguments.flash;
		}
	</cfscript>
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