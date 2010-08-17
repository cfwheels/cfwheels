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
	categories="controller-request,flash" chapters="using-the-flash" functions="flash,flashCount,flashDelete,flashInsert,flashIsEmpty,flashKeep,flashKeyExists,flashMessages">
	<cfargument name="$flashStorage" type="string" required="false" default="#get('flashStorage')#">
	<cfset $writeFlash(StructNew())>
</cffunction>

<cffunction name="flashCount" returntype="numeric" access="public" output="false" hint="Returns how many keys exist in the Flash."
	examples=
	'
		<cfif flashCount() gt 0>
			do something...
		</cfif>
	'
	categories="controller-request,flash" chapters="using-the-flash" functions="flash,flashClear,flashDelete,flashInsert,flashIsEmpty,flashKeep,flashKeyExists,flashMessages">
	<cfargument name="$flash" type="struct" required="false" default="#$readFlash()#">
	<cfreturn StructCount(arguments.$flash)>
</cffunction>

<cffunction name="flashDelete" returntype="boolean" access="public" output="false" hint="Deletes a specific key from the Flash."
	examples=
	'
		<cfset flashDelete(key="errorMessage")>
	'
	categories="controller-request,flash" chapters="using-the-flash" functions="flash,flashClear,flashCount,flashInsert,flashIsEmpty,flashKeep,flashKeyExists,flashMessages">
	<cfargument name="key" type="string" required="true" hint="The key to delete.">
	<cfargument name="$flash" type="struct" required="false" default="#$readFlash()#">
	<cfscript>
		var returnValue = "";
		returnValue = StructDelete(arguments.$flash, arguments.key, true);
		$writeFlash(arguments.$flash);
		return returnValue;
	</cfscript>
</cffunction>

<cffunction name="flashInsert" returntype="void" access="public" output="false" hint="Inserts a new key/value into the Flash."
	examples=
	'
		<cfset flashInsert(msg="It Worked!")>
	'
	categories="controller-request,flash" chapters="using-the-flash" functions="flash,flashClear,flashCount,flashDelete,flashIsEmpty,flashKeep,flashKeyExists,flashMessages">
	<cfargument name="$flash" type="struct" required="false" default="#$readFlash()#">
	<cfscript>
		StructInsert(arguments.$flash, ListLast(ListSort(StructKeyList(arguments), "textnocase")), arguments[2], true);
		$writeFlash(arguments.$flash);
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
	<cfreturn !flashCount()>
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
	<cfargument name="$flash" type="struct" required="false" default="#$readFlash()#">
	<cfreturn StructKeyExists(arguments.$flash, arguments.key)>
</cffunction>

<cffunction name="flashMessages" returntype="string" access="public" output="false" hint="Displays a marked-up listing of messages that exists in the Flash."
	examples=
	'
		<!--- In the controller action --->
		<cfset flashInsert(success="Your post was successfully submitted.")>
		<cfset flashInsert(alert="Don''t forget to tweet about this post!")>
		<cfset flashInsert(error="This is an error message.")>
		
		<!--- In the layout or view --->
		<cfoutput>
			##flashMessages()##
		</cfoutput>
		<!---
			Generates this (sorted alphabetically):
			<div class="flash-messages">
				<p class="alert-message">
					Don''t forget to tweet about this post!
				</p>
				<p class="error-message">
					This is an error message.
				</p>
				<p class="success-message">
					Your post was successfully submitted.
				</p>
			</div>
		--->
		
		<!--- Only show the "success" key in the view --->
		<cfoutput>
			##flashMessages(key="success")##
		</cfoutput>
		<!---
			Generates this:
			<div class="flash-message">
				<p class="success-message">
					Your post was successfully submitted.
				</p>
			</div>
		--->
		
		<!--- Show only the "success" and "alert" keys in the view, in that order --->
		<cfoutput>
			##flashMessages(keys="success,alert")##
		</cfoutput>
		<!---
			Generates this (sorted alphabetically):
			<div class="flash-messages">
				<p class="success-message">
					Your post was successfully submitted.
				</p>
				<p class="alert-message">
					Don''t forget to tweet about this post!
				</p>
			</div>
		--->
	'
	categories="controller-request,flash" chapters="using-the-flash" functions="flash,flashClear,flashCount,flashDelete,flashInsert,flashIsEmpty,flashKeep,flashKeyExists">
	<cfargument name="keys" type="string" required="false" hint="The key (or list of keys) to show the value for. You can also use the `key` argument instead for better readability when accessing a single key.">
	<cfargument name="class" type="string" required="false" hint="HTML `class` to set on the `div` element that contains the messages.">
	<cfargument name="includeEmptyContainer" type="boolean" required="false" hint="Includes the DIV container even if the flash is empty.">
	<cfargument name="$flash" type="struct" required="false" default="#$readFlash()#">
	<cfscript>
		// Initialization
		var loc = {};
		$args(name="flashMessages", args=arguments);
		$combineArguments(args=arguments, combine="keys,key", required=false);
		
		// If no keys are requested, populate with everything stored in the Flash and sort them
		if(!StructKeyExists(arguments, "keys"))
		{
			loc.flashKeys = StructKeyList(arguments.$flash);
			loc.flashKeys = ListSort(loc.flashKeys, "textnocase");
		}
		// Otherwise, generate list based on what was passed as `arguments.keys`
		else {
			loc.flashKeys = arguments.keys;
		}
		
		// Generate markup for each Flash item in the list
		loc.listItems = "";
		loc.iEnd = ListLen(loc.flashKeys);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(loc.flashKeys, loc.i);
			loc.attributes = {class=loc.item & "-message"};
			if (!StructKeyExists(arguments, "key") || arguments.key == loc.item)
			{
				loc.content = flash(loc.item);
				if (IsSimpleValue(loc.content))
					loc.listItems = loc.listItems & $element(name="p", content=loc.content, attributes=loc.attributes);
			}
		}
        
		if (Len(loc.listItems) || arguments.includeEmptyContainer)
			return $element(name="div", skip="key,keys,includeEmptyContainer", content=loc.listItems, attributes=arguments);
		else
			return "";
	</cfscript>
</cffunction>

<cffunction name="$readFlash" returntype="struct" access="public" output="false">
	<cfargument name="flashStorage" type="string" required="false" default="#get('flashStorage')#">
	<cfscript>
		if (!StructKeyExists(arguments, "$locked"))
			return $simpleLock(name="flashLock", type="readonly", execute="$readFlash", executeArgs=arguments);		
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
		if (!StructKeyExists(arguments, "$locked"))
			return $simpleLock(name="flashLock", type="exclusive", execute="$writeFlash", executeArgs=arguments);		
		if (arguments.flashStorage == "session")
			session.flash = arguments.flash;
		else if (arguments.flashStorage == "cookie")
			cookie.flash = SerializeJSON(arguments.flash);
	</cfscript>
</cffunction>

<cffunction name="$flashClear" returntype="void" access="public" output="false">
	<cfargument name="$flash" type="struct" required="false" default="#$readFlash()#">
	<cfscript>
		flashClear();
		loc.oldFlash = arguments.$flash;
		for (loc.key in loc.oldFlash)
		{
			if (StructKeyExists(request.wheels, "flashKeep") && (!Len(request.wheels.flashKeep) || StructKeyExists(request.wheels.flashKeep, loc.key)))
			{
				loc.args = {};
				loc.args[loc.key] = loc.oldFlash[loc.key];
				flashInsert(argumentCollection=loc.args);				
			}
		}
	</cfscript>
</cffunction>