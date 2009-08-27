<cffunction name="onError" returntype="void" access="public" output="true">
	<cfargument name="exception" type="any" required="true">
	<cfargument name="eventName" type="any" required="true">
	<cfscript>
		var returnValue = "";
		returnValue = $simpleLock(execute="$runOnError", executeArgs=arguments, name="wheelsReloadLock", type="readOnly");
	</cfscript>
	<cfoutput>
		#returnValue#
	</cfoutput>
</cffunction>

<cffunction name="$runOnError" returntype="string" access="public" output="false">
	<cfargument name="exception" type="any" required="true">
	<cfargument name="eventName" type="any" required="true">
	<cfscript>
		var loc = {};

		if (StructKeyExists(application, "wheels") && StructKeyExists(application.wheels, "initialized"))
		{
			if (application.wheels.sendEmailOnError)
			{
				loc.mailArgs = {};
				loc.mailArgs.from = application.wheels.errorEmailAddress;
				loc.mailArgs.to = application.wheels.errorEmailAddress;
				loc.mailArgs.subject = "Error";
				loc.mailArgs.type = "html";
				loc.mailArgs.body = [$includeAndReturnOutput($template="wheels/events/onerror/cfmlerror.cfm", exception=arguments.exception)];
				loc.mailArgs = $insertDefaults(name="sendEmail", input=loc.mailArgs);
				$mail(argumentCollection=loc.mailArgs);
			}
	
			if (application.wheels.showErrorInformation)
			{
				if (StructKeyExists(arguments.exception, "rootCause") && Left(arguments.exception.rootCause.type, 6) == "Wheels")
					loc.wheelsError = arguments.exception.rootCause;
				else if (StructKeyExists(arguments.exception, "cause") && StructKeyExists(arguments.exception.cause, "rootCause") && Left(arguments.exception.cause.rootCause.type, 6) == "Wheels") 
					loc.wheelsError = arguments.exception.cause.rootCause;
				if (StructKeyExists(loc, "wheelsError"))
				{
					loc.returnValue = $includeAndReturnOutput($template="wheels/styles/header.cfm");
					loc.returnValue = loc.returnValue & $includeAndReturnOutput($template="wheels/events/onerror/wheelserror.cfm", wheelsError=loc.wheelsError);
					loc.returnValue = loc.returnValue & $includeAndReturnOutput($template="wheels/styles/footer.cfm");
				}
				else
				{
					$throw(object=arguments.exception);
				}
			}
			else
			{
				$header(statusCode=500, statusText="Internal Server Error");
				loc.returnValue = $includeAndReturnOutput($template="#application.wheels.eventPath#/onerror.cfm", exception=arguments.exception, eventName=arguments.eventName);
			}
		}
		else
		{
			$throw(object=arguments.exception);
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>