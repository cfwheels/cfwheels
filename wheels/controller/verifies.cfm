<cfscript>
	/**
	*  PUBLIC CONTROLLER INITIALIZATION FUNCTIONS
	*/
	public void function verifies(
		string only="",
		string except="",
		any post="",
		any get="",
		any ajax="",
		string cookie="",
		string session="",
		string params="",
		string handler,
		string cookieTypes="",
		string sessionTypes="",
		string paramsTypes=""
	) { 
		$args(name="verifies", args=arguments);
		ArrayAppend(variables.$class.verifications, Duplicate(arguments));
	}

	public array function verificationChain() { 
		var loc = {};
		loc.rv = variables.$class.verifications;
		return loc.rv;
	}

	public void function setVerificationChain(required array chain) { 
		var loc = {};

		// clear current verification chain and then re-add from the passed in chain
		variables.$class.verifications = [];
		loc.iEnd = ArrayLen(arguments.chain);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			verifies(argumentCollection=arguments.chain[loc.i]);
		}
	}

	/**
	*  PRIVATE FUNCTIONS
	*/ 
	public void function $runVerifications(
		required string action,
		required struct params,
		struct cgiScope=request.cgi,
		struct sessionScope={},
		struct cookieScope=cookie
	) {
		var loc = {};

		// only access the session scope when session management is enabled in the app
		// default to the wheels setting but get it on a per request basis if possible (from application.cfc)
		loc.sessionManagement = get("sessionManagement");
		try
		{
			loc.sessionManagement = application.getApplicationSettings().sessionManagement;
		}
		catch (any e) {}

		if (StructIsEmpty(arguments.sessionScope) && loc.sessionManagement)
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
	}
 
	public boolean function $checkVerificationsVars(
		required struct scope,
		required string vars,
		required string types
	) {
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
		return loc.rv;
	}
</cfscript>   