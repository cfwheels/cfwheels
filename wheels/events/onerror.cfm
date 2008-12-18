<cffunction name="onError" returntype="void" access="public" output="true">
	<cfargument name="exception" type="any" required="true">
	<cfargument name="eventname" type="any" required="true">
	<cfscript>
		$simpleLock(execute="runOnError", executeArgs=arguments, scope="application", type="readOnly");
	</cfscript>
</cffunction>

<cffunction name="runOnError" returntype="void" access="public" output="true">
	<cfargument name="exception" type="any" required="true">
	<cfargument name="eventname" type="any" required="true">
	<cfscript>
		var loc = {};
		if (application.settings.sendEmailOnError)
			$mail(to=application.settings.errorEmailAddress, from=application.settings.errorEmailAddress, subject="Error", type="html", body=$includeAndReturnOutput(template="wheels/events/onerror/cfmlerror.cfm"));
		if (application.settings.showErrorInformation)
		{
			if (!StructKeyExists(arguments.exception, "cause"))
				arguments.exception.cause = arguments.exception;
			if (Left(arguments.exception.cause.type, 6) == "Wheels")
			{
				$includeAndOutput(template="wheels/styles/header.cfm");
				$includeAndOutput(template="wheels/events/onerror/wheelserror.cfm");
				$includeAndOutput(template="wheels/styles/footer.cfm");
			}
			else
			{
				$throw(object=arguments.exception);
			}
		}
		else
		{
			$header(statusCode=500, statusText="Internal Server Error");
			$includeAndOutput(template="#application.wheels.eventPath#/onerror.cfm");
		}
	</cfscript>
</cffunction>