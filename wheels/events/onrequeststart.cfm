<cfscript>
public void function onRequestStart(required targetPage) {
	local.lockName = "reloadLock" & application.applicationName;

	// Abort if called from incorrect file.
	$abortInvalidRequest();

	// Fix for shared application name issue 359.
	if (!StructKeyExists(application, "wheels") || !StructKeyExists(application.wheels, "eventPath")) {
		this.onApplicationStart();
	}

	// Need to setup the wheels struct up here since it's used to store debugging info below if this is a reload request.
	$initializeRequestScope();

	// Reload application by calling onApplicationStart if requested.
	if (
		StructKeyExists(url, "reload") && (
			!StructKeyExists(application, "wheels") || !StructKeyExists(application.wheels, "reloadPassword") || !Len(
				application.wheels.reloadPassword
			) || (StructKeyExists(url, "password") && url.password == application.wheels.reloadPassword)
		)
	) {
		$debugPoint("total,reload");
		if (StructKeyExists(url, "lock") && !url.lock) {
			this.onApplicationStart();
		} else {
			$simpleLock(
				name = local.lockName,
				execute = "onApplicationStart",
				type = "exclusive",
				timeout = 180
			);
		}
	}

	// Run the rest of the request start code.
	$simpleLock(
		name = local.lockName,
		execute = "$runOnRequestStart",
		executeArgs = arguments,
		type = "readOnly",
		timeout = 180
	);
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
		request.$wheelsHeaders = GetHTTPRequestData().headers;
	}

	// Reload the plugins on each request if cachePlugins is set to false.
	if (!application.wheels.cachePlugins) {
		$loadPlugins();
	}

	// Inject methods from plugins directly to Application.cfc.
	if (!StructIsEmpty(application.wheels.mixins)) {
		$include(template = "wheels/plugins/standalone/injection.cfm");
	}

	if (application.wheels.environment == "maintenance") {
		if (StructKeyExists(url, "except")) {
			application.wheels.ipExceptions = url.except;
		}
		local.makeException = false;
		if (Len(application.wheels.ipExceptions)) {
			if (ReFindNoCase("[a-z]", application.wheels.ipExceptions)) {
				if (ListFindNoCase(application.wheels.ipExceptions, cgi.http_user_agent)) {
					local.makeException = true;
				}
			} else {
				local.ipAddress = cgi.remote_addr;
				if (Len(request.cgi.http_x_forwarded_for)) {
					local.ipAddress = request.cgi.http_x_forwarded_for;
				}
				if (ListFind(application.wheels.ipExceptions, local.ipAddress)) {
					local.makeException = true;
				}
			}
		}
		if (!local.makeException) {
			$header(statusCode = 503, statustext = "Service Unavailable");

			// Set the content to be displayed in maintenance mode to a request variable and exit the function.
			// This variable is then checked in the Wheels $request function (which is what sets what to render).
			request.$wheelsAbortContent = $includeAndReturnOutput(
				$template = "#application.wheels.eventPath#/onmaintenance.cfm"
			);
			return;
		}
	}
	if (Right(arguments.targetPage, 4) == ".cfc") {
		StructDelete(this, "onRequest");
		StructDelete(variables, "onRequest");
	}
	if (!application.wheels.cacheModelConfig) {
		local.lockName = "modelLock" & application.applicationName;
		$simpleLock(name = local.lockName, execute = "$clearModelInitializationCache", type = "exclusive");
	}
	if (!application.wheels.cacheControllerConfig) {
		local.lockName = "controllerLock" & application.applicationName;
		$simpleLock(name = local.lockName, execute = "$clearControllerInitializationCache", type = "exclusive");
	}
	if (!application.wheels.cacheDatabaseSchema) {
		$clearCache("sql");
	}
	if (application.wheels.allowCorsRequests) {
		$setCORSHeaders(
			allowOrigin = application.wheels.accessControlAllowOrigin,
			allowCredentials = application.wheels.accessControlAllowCredentials,
			allowHeaders = application.wheels.accessControlAllowHeaders,
			allowMethods = application.wheels.accessControlAllowMethods,
			allowMethodsByRoute = application.wheels.accessControlAllowMethodsByRoute
		);
	}
	$include(template = "#application.wheels.eventPath#/onrequeststart.cfm");
	if (application.wheels.showDebugInformation) {
		$debugPoint("requestStart");
	}

	// Also for CORS compliance, an OPTIONS request must return 200 and the above headers. No data is required.
	// This will be remove when OPTIONS is implemented in the mapper (issue #623)
	if (
		application.wheels.allowCorsRequests
		&& StructKeyExists(request, "CGI")
		&& StructKeyExists(request.CGI, "request_method")
		&& request.CGI.request_method eq "OPTIONS"
	) {
		abort;
	}
}
</cfscript>
