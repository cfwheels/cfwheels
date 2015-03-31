<cffunction name="onError" returntype="void" access="public" output="true">
	<cfargument name="exception" type="any" required="true">
	<cfargument name="eventName" type="any" required="true">
	<cfscript>
		var loc = {};

		// in case the error was caused by a timeout we have to add extra time for error handling.
		// we have to check if onErrorRequestTimeout exists since errors can be triggered before the application.wheels struct has been created.
		loc.requestTimeout = 70;
		if (StructKeyExists(application, "wheels") && StructKeyExists(application.wheels, "onErrorRequestTimeout"))
		{
			loc.requestTimeout = application.wheels.onErrorRequestTimeout;
		}
		$setting(requestTimeout=loc.requestTimeout);

		loc.lockName = "reloadLock" & application.applicationName;
		loc.rv = $simpleLock(name=loc.lockName, execute="$runOnError", executeArgs=arguments, type="readOnly", timeout=180);
	</cfscript>
	<cfoutput>
		#loc.rv#
	</cfoutput>
</cffunction>

<cffunction name="$runOnError" returntype="string" access="public" output="false">
	<cfargument name="exception" type="any" required="true">
	<cfargument name="eventName" type="any" required="true">
	<cfscript>
		var loc = {};
		if (StructKeyExists(application, "wheels") && StructKeyExists(application.wheels, "initialized"))
		{
			if (application.wheels.sendEmailOnError && Len(application.wheels.errorEmailAddress))
			{
				loc.mailArgs = {};
				$args(name="sendEmail", args=loc.mailArgs);
				if (StructKeyExists(application.wheels, "errorEmailServer") && Len(application.wheels.errorEmailServer))
				{
					loc.mailArgs.server = application.wheels.errorEmailServer;
				}
				loc.mailArgs.from = application.wheels.errorEmailAddress;
				loc.mailArgs.to = application.wheels.errorEmailAddress;
				loc.mailArgs.subject = application.wheels.errorEmailSubject;
				loc.mailArgs.type = "html";
				loc.mailArgs.tagContent = $includeAndReturnOutput($template="wheels/events/onerror/cfmlerror.cfm", exception=arguments.exception);
				StructDelete(loc.mailArgs, "layouts", false);
				StructDelete(loc.mailArgs, "detectMultiPart", false);
				try
				{
					$mail(argumentCollection=loc.mailArgs);
				}
				catch (any e) {}
			}
			if (application.wheels.showErrorInformation)
			{
				if (StructKeyExists(arguments.exception, "rootCause") && Left(arguments.exception.rootCause.type, 6) == "Wheels")
				{
					loc.wheelsError = arguments.exception.rootCause;
				}
				else if (StructKeyExists(arguments.exception, "cause") && StructKeyExists(arguments.exception.cause, "rootCause") && Left(arguments.exception.cause.rootCause.type, 6) == "Wheels")
				{
					loc.wheelsError = arguments.exception.cause.rootCause;
				}
				if (StructKeyExists(loc, "wheelsError"))
				{
					loc.rv = $includeAndReturnOutput($template="wheels/styles/header.cfm");
					loc.rv &= $includeAndReturnOutput($template="wheels/events/onerror/wheelserror.cfm", wheelsError=loc.wheelsError);
					loc.rv &= $includeAndReturnOutput($template="wheels/styles/footer.cfm");
				}
				else
				{
					$throw(object=arguments.exception);
				}
			}
			else
			{
				$header(statusCode=500, statusText="Internal Server Error");
				loc.rv = $includeAndReturnOutput($template="#application.wheels.eventPath#/onerror.cfm", exception=arguments.exception, eventName=arguments.eventName);
			}
		}
		else
		{
			$throw(object=arguments.exception);
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>