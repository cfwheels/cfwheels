<cffunction name="verifies" returntype="void" access="public" output="false" hint="Tells Wheels to verify that some specific criterias are met before running an action."
	examples=
	'
		<!--- Tell Wheels to verify that the `handleForm` action is always a post request when executed --->
		<cfset verifies(only="handleForm", post=true)>
	'
	categories="controller-initialization" chapters="filters-and-verification" functions="filters">
	<cfargument name="only" type="string" required="false" default="" hint="Pass in a list of action names (or one action name) to tell Wheels that the verifications should only be run on these actions.">
	<cfargument name="except" type="string" required="false" default="" hint="Pass in a list of action names (or one action name) to tell Wheels that the filter function(s) should be run on all actions except the specified ones.">
	<cfargument name="post" type="any" required="false" default="" hint="Set to true to verify that this is a post request.">
	<cfargument name="get" type="any" required="false" default="" hint="Set to true to verify that this is a get request.">
	<cfargument name="ajax" type="any" required="false" default="" hint="Set to true to verify that this is an AJAX request.">
	<cfargument name="cookie" type="string" required="false" default="" hint="Verify that the passed in variable name exists in the cookie.">
	<cfargument name="session" type="string" required="false" default="" hint="Verify that the passed in variable name exists in the session.">
	<cfargument name="params" type="string" required="false" default="" hint="Verify that the passed in variable name exists in the params.">
	<cfargument name="handler" type="string" required="false" hint="Pass in the name of a function that should handle failed verifications (default is to just abort the request when a verification fails).">
	<cfscript>
		$args(name="verifies", args=arguments);
		ArrayAppend(variables.$class.verifications, Duplicate(arguments));
	</cfscript>
</cffunction>

<cffunction name="verificationChain" returntype="array" access="public" output="false" hint="Returns an array of all the verifications set on this controller in the order in which they will be executed.">
	<cfreturn variables.$class.verifications>
</cffunction>

<cffunction name="setVerificationChain" returntype="void" access="public" output="false" hint="Use this function if you need a more low level way of setting the entire verification chain for a controller.">
	<cfargument name="chain" type="array" required="true" hint="The entire verification chain that you want to use for this controller.">
	<cfset variables.$class.verifications = arguments.chain>
</cffunction>

<cffunction name="$runVerifications" returntype="void" access="public" output="false">
	<cfargument name="action" type="string" required="true">
	<cfargument name="params" type="struct" required="true">
	<cfargument name="cgiScope" type="struct" required="false" default="#request.cgi#">
	<cfargument name="sessionScope" type="struct" required="false" default="#session#">
	<cfargument name="cookieScope" type="struct" required="false" default="#cookie#">
	<cfscript>
		var loc = {};
		loc.verifications = verificationChain();
		loc.abort = false;
		loc.iEnd = ArrayLen(loc.verifications);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.verification = loc.verifications[loc.i];
			if ((!Len(loc.verification.only) && !Len(loc.verification.except)) || (Len(loc.verification.only) && ListFindNoCase(loc.verification.only, arguments.action)) || (Len(loc.verification.except) && !ListFindNoCase(loc.verification.except, arguments.action)))
			{
				if (IsBoolean(loc.verification.post) && ((loc.verification.post && !isPost()) || (!loc.verification.post && isPost())))
					loc.abort = true;
				if (IsBoolean(loc.verification.get) && ((loc.verification.get && !isGet()) || (!loc.verification.get && isGet())))
					loc.abort = true;
				if (IsBoolean(loc.verification.ajax) && ((loc.verification.ajax && !isAjax()) || (!loc.verification.ajax && isAjax())))
					loc.abort = true;
				loc.jEnd = ListLen(loc.verification.params);
				for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
				{
					if (!StructKeyExists(arguments.params, ListGetAt(loc.verification.params, loc.j)))
						loc.abort = true;
				}
				loc.jEnd = ListLen(loc.verification.session);
				for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
				{
					if (!StructKeyExists(arguments.sessionScope, ListGetAt(loc.verification.session, loc.j)))
						loc.abort = true;
				}
				loc.jEnd = ListLen(loc.verification.cookie);
				for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
				{
					if (!StructKeyExists(arguments.cookieScope, ListGetAt(loc.verification.cookie, loc.j)))
						loc.abort = true;
				}
			}
			if (loc.abort)
			{
				if (Len(loc.verification.handler))
				{
					$invoke(method=loc.verification.handler);
					$location(url=arguments.cgiScope.http_referer, addToken=false);
				}
				else
				{
					$abort();
				}
			}
		}
	</cfscript>
</cffunction>