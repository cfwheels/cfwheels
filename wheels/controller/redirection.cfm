<!--- PUBLIC CONTROLLER REQUEST FUNCTIONS --->

<cffunction name="redirectTo" returntype="void" access="public" output="false" hint="Redirects the browser to the supplied `controller`/`action`/`key`, `route` or back to the referring page. Internally It uses the @URLFor function to build the link and the `cflocation` tag to perform the redirect."
	examples=
	'
		<!--- Redirect to an action after successfully saving a user --->
		<cfif user.save()>
		  <cfset redirectTo(action="saveSuccessful")>
		</cfif>

		<!--- Redirect to a specific page on a secure server --->
		<cfset redirectTo(controller="checkout", action="start", params="type=express", protocol="https")>

		<!--- Redirect to a route specified in `config/routes.cfm` and pass in the screen name that the route takes --->
		<cfset redirectTo(route="profile", screenName="Joe")>

		<!--- Redirect back to the page the user came from --->
		<cfset redirectTo(back=true)>
	'
	categories="controller-request,miscellaneous" chapters="redirecting-users,using-routes" functions="">
	<cfargument name="back" type="boolean" required="false" default="false" hint="Set to `true` to redirect back to the referring page.">
	<cfargument name="addToken" type="boolean" required="false" hint="See documentation for `cflocation`.">
	<cfargument name="statusCode" type="numeric" required="false" hint="See documentation for `cflocation`.">
	<cfargument name="route" type="string" required="false" default="" hint="See documentation for @URLFor.">
	<cfargument name="controller" type="string" required="false" default="" hint="See documentation for @URLFor.">
	<cfargument name="action" type="string" required="false" default="" hint="See documentation for @URLFor.">
	<cfargument name="key" type="any" required="false" default="" hint="See documentation for @URLFor.">
	<cfargument name="params" type="string" required="false" default="" hint="See documentation for @URLFor.">
	<cfargument name="anchor" type="string" required="false" default="" hint="See documentation for @URLFor.">
	<cfargument name="onlyPath" type="boolean" required="false" hint="See documentation for @URLFor.">
	<cfargument name="host" type="string" required="false" hint="See documentation for @URLFor.">
	<cfargument name="protocol" type="string" required="false" hint="See documentation for @URLFor.">
	<cfargument name="port" type="numeric" required="false" hint="See documentation for @URLFor.">
	<cfargument name="delay" type="boolean" required="false" hint="Set to `true` to delay the redirection until after the rest of your action code have executed.">
	<cfscript>
		var loc = {};
		$insertDefaults(name="redirectTo", input=arguments);

		// set flash if passed in
		loc.functionInfo = GetMetaData(variables.redirectTo);
		if (StructCount(arguments) > ArrayLen(loc.functionInfo.parameters))
		{
			// since more than the arguments listed in the function declaration was passed in it's possible that one of them is intended for the flash

			// create a list of all the argument names that should not be set to the flash
			// this includes arguments to the function itself or ones meant for a route
			loc.nonFlashArgumentNames = "";
			if (Len(arguments.route))
				loc.nonFlashArgumentNames = ListAppend(loc.nonFlashArgumentNames, $findRoute(argumentCollection=arguments).variables);
			loc.iEnd = ArrayLen(loc.functionInfo.parameters);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				loc.nonFlashArgumentNames = ListAppend(loc.nonFlashArgumentNames, loc.functionInfo.parameters[loc.i].name);

			// loop through arguments and when the first flash argument is found we set it
			loc.argumentNames = StructKeyList(arguments);
			loc.iEnd = ListLen(loc.argumentNames);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.item = ListGetAt(loc.argumentNames, loc.i);
				if (!ListFindNoCase(loc.nonFlashArgumentNames, loc.item))
				{
					loc.flashArguments = {};
					loc.flashArguments[REReplaceNoCase(loc.item, "^flash(.)", "\l\1")] = arguments[loc.item];
					flashInsert(argumentCollection=loc.flashArguments);
				}
			}
		}

		// set the url that will be used in the cflocation tag
		if (arguments.back)
		{
			if (!Len(request.cgi.http_referer))
				$throw(type="Wheels.RedirectBackError", message="Can't redirect back to the referring URL because it is blank.", extendedInfo="Catch this error in your code to handle it gracefully.");
			else if (request.cgi.http_referer Does Not Contain request.cgi.server_name)
				$throw(type="Wheels.RedirectBackError", message="Can't redirect back to the referring URL because it is not on the same domain.", extendedInfo="Catch this error in your code to handle it gracefully.");
			else
				loc.url = request.cgi.http_referer;
		}
		else
		{
			loc.url = URLFor(argumentCollection=arguments);
		}
		
		// schedule or perform the redirect right away
		if (arguments.delay)
		{
			if (StructKeyExists(variables.wheels, "$redirect"))
			{
				// throw an error if the developer has already scheduled a redirect previously in this request
				$throw(type="Wheels.RedirectToAlreadyCalled", message="`redirectTo()` was already called.");		
			}
			else
			{
				// schedule a redirect that will happen after the action code has been completed
				variables.wheels.$redirect = {url=loc.url, addToken=arguments.addToken, statusCode=arguments.statusCode};			
			}
		}
		else
		{
			// do the redirect now using cflocation
			$location(url=loc.url, addToken=arguments.addToken, statusCode=arguments.statusCode);
		}
	</cfscript>
</cffunction>
