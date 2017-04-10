<cfscript>

public void function onError(required exception, required eventName) {

	// In case the error was caused by a timeout we have to add extra time for error handling.
	// We have to check if onErrorRequestTimeout exists since errors can be triggered before the application.wheels struct has been created.
	local.requestTimeout = 70;
	if (StructKeyExists(application, "wheels") && StructKeyExists(application.wheels, "onErrorRequestTimeout")) {
		local.requestTimeout = application.wheels.onErrorRequestTimeout;
	}
	setting requestTimeout = local.requestTimeout;

	$initializeRequestScope();
	local.lockName = "reloadLock" & application.applicationName;
	local.rv = $simpleLock(name=local.lockName, execute="$runOnError", executeArgs=arguments, type="readOnly", timeout=180);
	writeOutput(local.rv);
}

public string function $runOnError(required exception, required eventName) {
	if (StructKeyExists(application, "wheels") && StructKeyExists(application.wheels, "initialized")) {
		if (application.wheels.sendEmailOnError) {
			local.args = {};
			$args(name="sendEmail", args=local.args);
			local.args.from = application.wheels.errorEmailAddress;
			if (Len(application.wheels.errorEmailFromAddress)) {
				local.args.from = application.wheels.errorEmailFromAddress;
			}
			local.args.to = application.wheels.errorEmailAddress;
			if (Len(application.wheels.errorEmailToAddress)) {
				local.args.to = application.wheels.errorEmailToAddress;
			}
			if (Len(local.args.from) && Len(local.args.to)) {
				if (StructKeyExists(application.wheels, "errorEmailServer") && Len(application.wheels.errorEmailServer)) {
					local.args.server = application.wheels.errorEmailServer;
				}
				local.args.subject = application.wheels.errorEmailSubject;
				local.rootCause = "";
				if (StructKeyExists(arguments.exception, "rootCause") && StructKeyExists(arguments.exception.rootCause, "message")) {
					local.rootCause = arguments.exception.rootCause.message;
				}
				if (application.wheels.includeErrorInEmailSubject && Len(local.rootCause)) {
					local.args.subject &= ": " & local.rootCause;
				}
				local.args.type = "html";
				local.args.tagContent = $includeAndReturnOutput(
					$template="wheels/events/onerror/cfmlerror.cfm",
					exception=arguments.exception
				);
				StructDelete(local.args, "layouts", false);
				StructDelete(local.args, "detectMultiPart", false);
				try {
					$mail(argumentCollection=local.args);
				} catch (any e) {}
			}
		}
		if (application.wheels.showErrorInformation) {
			if (StructKeyExists(arguments.exception, "rootCause") && Left(arguments.exception.rootCause.type, 6) == "Wheels") {
				local.wheelsError = arguments.exception.rootCause;
			} else if (StructKeyExists(arguments.exception, "cause") && StructKeyExists(arguments.exception.cause, "rootCause") && Left(arguments.exception.cause.rootCause.type, 6) == "Wheels") {
				local.wheelsError = arguments.exception.cause.rootCause;
			}
			if (StructKeyExists(local, "wheelsError")) {
				local.rv = $includeAndReturnOutput($template="wheels/styles/header.cfm");
				local.rv &= $includeAndReturnOutput(
					$template="wheels/events/onerror/wheelserror.cfm",
					wheelsError=local.wheelsError
				);
				local.rv &= $includeAndReturnOutput($template="wheels/styles/footer.cfm");
			} else {
				Throw(object=arguments.exception);
			}
		} else {
			$header(statusCode=500, statusText="Internal Server Error");
			local.rv = $includeAndReturnOutput(
				$template="#application.wheels.eventPath#/onerror.cfm",
				eventName=arguments.eventName,
				exception=arguments.exception
			);
		}
	} else {
		Throw(object=arguments.exception);
	}
	return local.rv;
}

</cfscript>
