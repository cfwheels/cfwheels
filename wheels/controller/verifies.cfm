<!--- PUBLIC CONTROLLER INITIALIZATION FUNCTIONS --->

<cffunction name="verifies" returntype="void" access="public" output="false">
	<cfargument name="only" type="string" required="false" default="">
	<cfargument name="except" type="string" required="false" default="">
	<cfargument name="post" type="any" required="false" default="">
	<cfargument name="get" type="any" required="false" default="">
	<cfargument name="ajax" type="any" required="false" default="">
	<cfargument name="cookie" type="string" required="false" default="">
	<cfargument name="session" type="string" required="false" default="">
	<cfargument name="params" type="string" required="false" default="">
	<cfargument name="handler" type="string" required="false">
	<cfargument name="cookieTypes" type="string" required="false" default="">
	<cfargument name="sessionTypes" type="string" required="false" default="">
	<cfargument name="paramsTypes" type="string" required="false" default="">
	<cfscript>
		$args(name="verifies", args=arguments);
		ArrayAppend(variables.$class.verifications, Duplicate(arguments));
	</cfscript>
</cffunction>

<cffunction name="verificationChain" returntype="array" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.rv = variables.$class.verifications;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="setVerificationChain" returntype="void" access="public" output="false">
	<cfargument name="chain" type="array" required="true">
	<cfscript>
		var loc = {};

		// clear current verification chain and then re-add from the passed in chain
		variables.$class.verifications = [];
		loc.iEnd = ArrayLen(arguments.chain);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			verifies(argumentCollection=arguments.chain[loc.i]);
		}
	</cfscript>
</cffunction>

<!--- PRIVATE FUNCTIONS --->

<cffunction name="$runVerifications" returntype="void" access="public" output="false">
	<cfargument name="action" type="string" required="true">
	<cfargument name="params" type="struct" required="true">
	<cfargument name="cgiScope" type="struct" required="false" default="#request.cgi#">
	<cfargument name="sessionScope" type="struct" required="false" default="#StructNew()#">
	<cfargument name="cookieScope" type="struct" required="false" default="#cookie#">
	<cfscript>
		var loc = {};

		// only access the session scope when session management is enabled in the app
		if (StructIsEmpty(arguments.sessionScope) && get("sessionManagement"))
		{
			arguments.sessionScope = session;
		}

		loc.verifications = verificationChain();
		loc.$args = "only,except,post,get,ajax,cookie,session,params,cookieTypes,sessionTypes,paramsTypes,handler";
		loc.abort = false;
		loc.iEnd = ArrayLen(loc.verifications);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.element = loc.verifications[loc.i];
			if ((!Len(loc.element.only) && !Len(loc.element.except)) || (Len(loc.element.only) && ListFindNoCase(loc.element.only, arguments.action)) || (Len(loc.element.except) && !ListFindNoCase(loc.element.except, arguments.action)))
			{
				if (IsBoolean(loc.element.post) && ((loc.element.post && !isPost()) || (!loc.element.post && isPost())))
				{
					loc.abort = true;
				}
				if (IsBoolean(loc.element.get) && ((loc.element.get && !isGet()) || (!loc.element.get && isGet())))
				{
					loc.abort = true;
				}
				if (IsBoolean(loc.element.ajax) && ((loc.element.ajax && !isAjax()) || (!loc.element.ajax && isAjax())))
				{
					loc.abort = true;
				}
				if (!$checkVerificationsVars(arguments.params, loc.element.params, loc.element.paramsTypes))
				{
					loc.abort = true;
				}
				if (!$checkVerificationsVars(arguments.sessionScope, loc.element.session, loc.element.sessionTypes))
				{
					loc.abort = true;
				}
				if (!$checkVerificationsVars(arguments.cookieScope, loc.element.cookie, loc.element.cookieTypes))
				{
					loc.abort = true;
				}
			}
			if (loc.abort)
			{
				if (Len(loc.element.handler))
				{
					$invoke(method=loc.element.handler);
					redirectTo(back="true");
				}
				else
				{
					// check to see if we should perform a redirect or abort completly
					loc.redirectArgs = {};
					for(loc.key in loc.element)
					{
						if (!ListFindNoCase(loc.$args, loc.key) && StructKeyExists(loc.element, loc.key))
						{
							loc.redirectArgs[loc.key] = loc.element[loc.key];
						}
					}
					if (!StructIsEmpty(loc.redirectArgs))
					{
						redirectTo(argumentCollection=loc.redirectArgs);
					}
					else
					{
						variables.$instance.abort = true;
					}
				}
				// an abort was issued, no need to process further in the chain
				break;
			}
		}
	</cfscript>
</cffunction>

<cffunction name="$checkVerificationsVars" returntype="boolean" access="public" output="false">
	<cfargument name="scope" type="struct" required="true">
	<cfargument name="vars" type="string" required="true">
	<cfargument name="types" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = true;
		loc.iEnd = ListLen(arguments.vars);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(arguments.vars, loc.i);
			if (!StructKeyExists(arguments.scope, loc.item))
			{
				loc.rv = false;
				break;
			}
			if (Len(arguments.types))
			{
				loc.value = arguments.scope[loc.item];
				loc.typeCheck = ListGetAt(arguments.types, loc.i);

				// by default string aren't allowed to be blank
				loc.typeAllowedBlank = false;
				if (loc.typeCheck == "blank")
				{
					loc.typeAllowedBlank = true;
					loc.typeCheck = "string";
				}

				if (!IsValid(loc.typeCheck, loc.value) || (loc.typeCheck == "string" && !loc.typeAllowedBlank && !Len(Trim(loc.value))))
				{
					loc.rv = false;
					break;
				}
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>