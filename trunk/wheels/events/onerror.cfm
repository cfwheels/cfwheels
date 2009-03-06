<cffunction name="onError" returntype="void" access="public" output="true">
	<cfargument name="exception" type="any" required="true">
	<cfargument name="eventname" type="any" required="true">
	<cfscript>
		var returnValue = "";
		returnValue = $simpleLock(execute="$runOnError", executeArgs=arguments, scope="application", type="readOnly");
	</cfscript>
	#returnValue#
</cffunction>

<cffunction name="$runOnError" returntype="string" access="public" output="false">
	<cfargument name="exception" type="any" required="true">
	<cfargument name="eventname" type="any" required="true">
	<cfscript>
		var loc = {};
		
		// make railo cfml and adobe cfml behave the same way
		if (!StructKeyExists(arguments.exception, "cause"))
			arguments.exception.cause = arguments.exception; 
        
		if (application.settings.sendEmailOnError)
			$mail(to=application.settings.errorEmailAddress, from=application.settings.errorEmailAddress, subject="Error", type="html", body=$includeAndReturnOutput(template="wheels/events/onerror/cfmlerror.cfm", exception=arguments.exception));

		if (application.settings.showErrorInformation)
		{
			if (StructKeyExists(arguments.exception.cause, "rootCause") && Left(arguments.exception.cause.rootCause.type, 6) == "Wheels")
			{
				loc.wheelsError = arguments.exception.cause.rootCause;
			}
			else if (IsDefined("arguments.exception.cause.rootCause.resolvedName") && IsDefined("arguments.exception.cause.rootCause.element") && arguments.exception.cause.rootCause.resolvedName == "application" && Left(arguments.exception.cause.rootCause.element, 8) == "settings")
			{
				loc.element = arguments.exception.cause.rootCause.element;
				loc.element = ReplaceNoCase(loc.element, "settings.", "");
				loc.functionName = LCase(ListFirst(loc.element, "."));
				loc.argumentName = LCase(ListLast(loc.element, "."));
				loc.wheelsError.type = "Wheels.RequiredArgumentMissing";
				loc.wheelsError.message = "The '#loc.argumentName#' argument to the '#loc.functionName#' function is required but was not passed in.";
				loc.wheelsError.extendedInfo = "Either pass in the '#loc.argumentName#' argument directly to the '#loc.functionName#' function or set a global default for it in 'config/defaults/#loc.functionName#.cfm'.";
				loc.wheelsError.tagContext = arguments.exception.cause.rootCause.tagContext;
			}
			if (StructKeyExists(loc, "wheelsError"))
			{
				loc.returnValue = $includeAndReturnOutput(template="wheels/styles/header.cfm");
				loc.returnValue = loc.returnValue & $includeAndReturnOutput(template="wheels/events/onerror/wheelserror.cfm", wheelsError=loc.wheelsError);
				loc.returnValue = loc.returnValue & $includeAndReturnOutput(template="wheels/styles/footer.cfm");
			}
			else
			{
				$throw(object=arguments.exception);
			}
		}
		else
		{
			$header(statusCode=500, statusText="Internal Server Error");
			loc.returnValue = $includeAndReturnOutput(template="#application.wheels.eventPath#/onerror.cfm");
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>