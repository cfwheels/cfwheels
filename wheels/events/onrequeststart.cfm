<cfscript>

public void function onRequestStart(required targetPage) {
	local.lockName = "reloadLock" & application.applicationName;

	// Abort if called from incorrect file.
	$abortInvalidRequest();

	// Fix for shared application name issue 359.
	if (!StructKeyExists(application, "wheels") || !StructKeyExists(application.wheels, "eventPath")) {
		$simpleLock(name=local.lockName, execute="onApplicationStart", type="exclusive", timeout=180);
	}

	// Need to setup the wheels struct up here since it's used to store debugging info below if this is a reload request.
	$initializeRequestScope();

	// Reload application by calling onApplicationStart if requested.
	if (StructKeyExists(url, "reload") && (!StructKeyExists(application, "wheels") || !StructKeyExists(application.wheels, "reloadPassword") || !Len(application.wheels.reloadPassword) || (StructKeyExists(url, "password") && url.password == application.wheels.reloadPassword))) {
		$debugPoint("total,reload");
		$simpleLock(name=local.lockName, execute="onApplicationStart", type="exclusive", timeout=180);
	}

	// Run the rest of the request start code.
	$simpleLock(name=local.lockName, execute="$runOnRequestStart", executeArgs=arguments, type="readOnly", timeout=180);

}

public void function $runOnRequestStart(required targetPage) {

	// If the first debug point has not already been set in a reload request we set it here.
	if (application.wheels.showDebugInformation) {
		if (StructKeyExists(request.wheels, "execution")) {
			$debugPoint("reload");
		} else {
			$debugPoint("total");
		}
		$debugPoint("requestStart");
	}

	// Copy over the cgi variables we need to the request scope unless it's already been done on application start.
	if (!StructKeyExists(request, "cgi")) {
		request.cgi = $cgiScope();
	}

	// Copy HTTP headers.
	if (!StructKeyExists(request, "$wheelsHeader")) {
		request.$wheelsHeaders = GetHttpRequestData().headers;
	}

	// Reload the plugins on each request if cachePlugins is set to false.
	if (!application.wheels.cachePlugins) {
		$loadPlugins();
	}

	// Inject methods from plugins directly to Application.cfc.
	if (!StructIsEmpty(application.wheels.mixins)) {
		$include(template="wheels/plugins/injection.cfm");
	}

	if (application.wheels.environment == "maintenance") {
		if (StructKeyExists(url, "except")) {
			application.wheels.ipExceptions = url.except;
		}
		local.makeException = false;
		if (Len(application.wheels.ipExceptions)) {
			if (REFindNoCase("[a-z]", application.wheels.ipExceptions)) {
				if (ListFindNoCase(application.wheels.ipExceptions, cgi.http_user_agent)) {
					local.makeException = true;
				}
			} else {
				local.ipAddress = cgi.remote_addr;
				if (StructKeyExists(cgi, "http_x_forwarded_for") && Len(cgi.http_x_forwarded_for)) {
					local.ipAddress = cgi.http_x_forwarded_for;
				}
				if (ListFind(application.wheels.ipExceptions, local.ipAddress)) {
					local.makeException = true;
				}
			}
		}
		if (!local.makeException) {
			$header(statusCode=503, statustext="Service Unavailable");
			$includeAndOutput(template="#application.wheels.eventPath#/onmaintenance.cfm");
			$abort();
		}
	}
	if (Right(arguments.targetPage, 4) == ".cfc") {
		StructDelete(this, "onRequest");
		StructDelete(variables, "onRequest");
	}
	if (!application.wheels.cacheModelInitialization) {
		local.lockName = "modelLock" & application.applicationName;
		$simpleLock(name=local.lockName, execute="$clearModelInitializationCache", type="exclusive");
	}
	if (!application.wheels.cacheControllerInitialization) {
		local.lockName = "controllerLock" & application.applicationName;
		$simpleLock(name=local.lockName, execute="$clearControllerInitializationCache", type="exclusive");
	}
	if (!application.wheels.cacheRoutes) {
		$loadRoutes();
	}
	if (!application.wheels.cacheDatabaseSchema) {
		$clearCache("sql");
	}
	$include(template="#application.wheels.eventPath#/onrequeststart.cfm");
	if (application.wheels.showDebugInformation) {
		$debugPoint("requestStart");
	}
}

</cfscript>
