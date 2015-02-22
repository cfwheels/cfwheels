<!--- PUBLIC CONTROLLER INITIALIZATION FUNCTIONS --->

<cffunction name="verifies" returntype="void" access="public" output="false" hint="Instructs CFWheels to verify that some specific criterias are met before running an action. Note that all undeclared arguments will be passed to `redirectTo()` call if a handler is not specified."
	examples=
	'
		// Tell Wheels to verify that the `handleForm` action is always a `POST` request when executed
		verifies(only="handleForm", post=true);

		// Make sure that the edit action is a `GET` request, that `userId` exists in the `params` struct, and that it''s an integer
		verifies(only="edit", get=true, params="userId", paramsTypes="integer");

		// Just like above, only this time we want to invoke a custom function in our controller to handle the request when it is invalid
		verifies(only="edit", get=true, params="userId", paramsTypes="integer", handler="myCustomFunction");

		// Just like above, only this time instead of specifying a handler, we want to `redirect` the visitor to the index action of the controller and show an error in The Flash when the request is invalid
		verifies(only="edit", get=true, params="userId", paramsTypes="integer", action="index", error="Invalid userId");
	'
	categories="controller-initialization,verification" chapters="filters-and-verification" functions="verificationChain,setVerificationChain">
	<cfargument name="only" type="string" required="false" default="" hint="List of action names to limit this verification to.">
	<cfargument name="except" type="string" required="false" default="" hint="List of action names to exclude this verification from.">
	<cfargument name="post" type="any" required="false" default="" hint="Set to `true` to verify that this is a `POST` request.">
	<cfargument name="get" type="any" required="false" default="" hint="Set to `true` to verify that this is a `GET` request.">
	<cfargument name="ajax" type="any" required="false" default="" hint="Set to `true` to verify that this is an AJAX request.">
	<cfargument name="cookie" type="string" required="false" default="" hint="Verify that the passed in variable name exists in the `cookie` scope.">
	<cfargument name="session" type="string" required="false" default="" hint="Verify that the passed in variable name exists in the `session` scope.">
	<cfargument name="params" type="string" required="false" default="" hint="Verify that the passed in variable name exists in the `params` struct.">
	<cfargument name="handler" type="string" required="false" hint="Pass in the name of a function that should handle failed verifications. The default is to just abort the request when a verification fails.">
	<cfargument name="cookieTypes" type="string" required="false" default="" hint="List of types to check each listed `cookie` value against (will be passed through to your CFML engine's `IsValid` function).">
	<cfargument name="sessionTypes" type="string" required="false" default="" hint="List of types to check each list `session` value against (will be passed through to your CFML engine's `IsValid` function).">
	<cfargument name="paramsTypes" type="string" required="false" default="" hint="List of types to check each `params` value against (will be passed through to your CFML engine's `IsValid` function).">
	<cfscript>
		$args(name="verifies", args=arguments);
		ArrayAppend(variables.$class.verifications, Duplicate(arguments));
	</cfscript>
</cffunction>

<!--- PUBLIC CONTROLLER REQUEST FUNCTIONS --->

<cffunction name="verificationChain" returntype="array" access="public" output="false" hint="Returns an array of all the verifications set on this controller in the order in which they will be executed."
	examples=
	'
		// Get verification chain, remove the first item, and set it back
		myVerificationChain = verificationChain();
		ArrayDeleteAt(myVerificationChain, 1);
		setVerificationChain(myVerificationChain);
	'
	categories="controller-initialization,verification" chapters="filters-and-verification" functions="verifies,setVerificationChain">
	<cfscript>
		var loc = {};
		loc.rv = variables.$class.verifications;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="setVerificationChain" returntype="void" access="public" output="false" hint="Use this function if you need a more low level way of setting the entire verification chain for a controller."
	examples=
	'
		// Set verification chain directly in an array
		setVerificationChain([
			{only="handleForm", post=true},
			{only="edit", get=true, params="userId", paramsTypes="integer"},
			{only="edit", get=true, params="userId", paramsTypes="integer", handler="index", error="Invalid userId"}
		]);
	'
	categories="controller-initialization,verification" chapters="filters-and-verification" functions="verifies,verificationChain">
	<cfargument name="chain" type="array" required="true" hint="An array of structs, each of which represent an `argumentCollection` that get passed to the `verifies` function. This should represent the entire verification chain that you want to use for this controller.">
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