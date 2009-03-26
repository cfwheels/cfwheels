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
        
		if (application.wheels.sendEmailOnError)
			$mail(to=application.wheels.errorEmailAddress, from=application.wheels.errorEmailAddress, subject="Error", type="html", body=$includeAndReturnOutput(template="wheels/events/onerror/cfmlerror.cfm", exception=arguments.exception));

		if (application.wheels.showErrorInformation)
		{
			if (StructKeyExists(arguments.exception.cause, "rootCause") && Left(arguments.exception.cause.rootCause.type, 6) == "Wheels")
			{
				loc.returnValue = $includeAndReturnOutput(template="wheels/styles/header.cfm");
				loc.returnValue = loc.returnValue & $includeAndReturnOutput(template="wheels/events/onerror/wheelserror.cfm", wheelsError=arguments.exception.cause.rootCause);
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