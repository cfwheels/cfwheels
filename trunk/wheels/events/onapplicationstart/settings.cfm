<cfscript>
	// rewrite settings based on web server rewrite capabilites
	if (Right(cgi.script_name, 12) == "/rewrite.cfm")
		application.wheels.URLRewriting = "On";
	else if (Len(cgi.path_info))
		application.wheels.URLRewriting = "Partial";
	else
		application.wheels.URLRewriting = "Off";
	
	// set datasource name to same as the folder the app resides in
	application.wheels.dataSourceName = LCase(ListLast(this.rootDir, Right(this.rootDir, 1)));
	application.wheels.dataSourceUserName = "";
	application.wheels.dataSourcePassword = "";

	// general settings
	application.wheels.cacheDatabaseSchema = false;
	application.wheels.cacheFileChecking = false;
	application.wheels.cacheImages = false;
	application.wheels.cacheModelInitialization = false;
	application.wheels.cacheControllerInitialization = false;
	application.wheels.cacheRoutes = false;
	application.wheels.cacheActions = false;
	application.wheels.cachePages = false;
	application.wheels.cachePartials = false;
	application.wheels.cacheQueries = false;
	application.wheels.showDebugInformation = true;
	application.wheels.showErrorInformation = true;
	application.wheels.sendEmailOnError = false;
	application.wheels.errorEmailAddress = "";

	// override general settings for specific environments
	if (application.wheels.environment != "design")
	{
		application.wheels.cacheDatabaseSchema = true;
		application.wheels.cacheFileChecking = true;
		application.wheels.cacheImages = true;
		application.wheels.cacheModelInitialization = true;
		application.wheels.cacheControllerInitialization = true;
		application.wheels.cacheRoutes = true;
	}
	if (application.wheels.environment != "design" && application.wheels.environment != "development")
	{
		application.wheels.cacheActions = true;
		application.wheels.cachePages = true;
		application.wheels.cachePartials = true;
		application.wheels.cacheQueries = true;
		application.wheels.showDebugInformation = false;
	}
	if (application.wheels.environment == "production")
	{
		application.wheels.showErrorInformation = false;
		if (cgi.server_name Contains ".")
		{
			application.wheels.sendEmailOnError = true;
			application.wheels.errorEmailAddress = "webmaster@" & Reverse(ListGetAt(Reverse(cgi.server_name), 2,".")) & "." & Reverse(ListGetAt(Reverse(cgi.server_name), 1, "."));
		}
	}

	// miscellaneous settings
	application.wheels.tableNamePrefix = "";
	application.wheels.obfuscateURLs = false;
	application.wheels.reloadPassword = "";
	application.wheels.softDeleteProperty = "deletedAt";
	application.wheels.timeStampOnCreateProperty = "createdAt";
	application.wheels.timeStampOnUpdateProperty = "updatedAt";
	application.wheels.ipExceptions = "";
	
	// caching settings
	application.wheels.maximumItemsToCache = 5000;
	application.wheels.cacheCullPercentage = 10;
	application.wheels.cacheCullInterval = 5;
	application.wheels.defaultCacheTime = 60;

	// imageTag defaults
	application.wheels.imageTag = {};

	// styleSheetLinkTag defaults
	application.wheels.styleSheetLinkTag = {};
	application.wheels.styleSheetLinkTag.type = "text/css";
	application.wheels.styleSheetLinkTag.media = "all";

	// javaScriptIncludeTag defaults
	application.wheels.javaScriptIncludeTag = {};
	application.wheels.javaScriptIncludeTag.type = "text/javascript";
	
	// errorMessageOn defaults
	application.wheels.errorMessageOn = {};
	application.wheels.errorMessageOn.prependText = "";
	application.wheels.errorMessageOn.appendText = "";
	application.wheels.errorMessageOn.wrapperElement = "span";
	application.wheels.errorMessageOn.class = "error-message";

	// errorMessagesFor defaults
	application.wheels.textField = {};
	application.wheels.errorMessagesFor.class = "error-messages";
	
	// passwordField defaults
	application.wheels.passwordField = {};
	application.wheels.passwordField.label = "";
	application.wheels.passwordField.wrapLabel = true;
	application.wheels.passwordField.prepend = "";
	application.wheels.passwordField.append = "";
	application.wheels.passwordField.prependToLabel = "";
	application.wheels.passwordField.appendToLabel = "";
	application.wheels.passwordField.errorElement = "div";

	// fileField defaults
	application.wheels.fileField = {};
	application.wheels.fileField.label = "";
	application.wheels.fileField.wrapLabel = true;
	application.wheels.fileField.prepend = "";
	application.wheels.fileField.append = "";
	application.wheels.fileField.prependToLabel = "";
	application.wheels.fileField.appendToLabel = "";
	application.wheels.fileField.errorElement = "div";

	// startFormTag defaults
	application.wheels.startFormTag = {};
	application.wheels.startFormTag.method = "post";
	application.wheels.startFormTag.multipart = false;
	application.wheels.startFormTag.spamProtection = false;

	// submitTag defaults
	application.wheels.submitTag = {};
	application.wheels.submitTag.value = "Save changes";
	application.wheels.submitTag.image = "";
	application.wheels.submitTag.disable = "";

	// textArea defaults
	application.wheels.textArea = {};
	application.wheels.textArea.label = "";
	application.wheels.textArea.wrapLabel = true;
	application.wheels.textarea.prepend = "";
	application.wheels.textarea.append = "";
	application.wheels.textarea.prependToLabel = "";
	application.wheels.textarea.appendToLabel = "";
	application.wheels.textarea.errorElement = "div";

	// textField defaults
	application.wheels.textField = {};
	application.wheels.textField.label = "";
	application.wheels.textField.wrapLabel = true;
	application.wheels.textField.prepend = "";
	application.wheels.textField.append = "";
	application.wheels.textField.prependToLabel = "";
	application.wheels.textField.appendToLabel = "";
	application.wheels.textField.errorElement = "div";

	// hiddenField defaults
	application.wheels.hiddenField = {};

	// sendEmail defaults
	application.wheels.sendEmail = {};
	application.wheels.sendEmail.layout = false;

	application.wheels.validatesConfirmationOf.message = "[property] should match confirmation";
	application.wheels.validatesExclusionOf.message = "[property] is reserved";
	application.wheels.validatesFormatOf.message = "[property] is invalid";
	application.wheels.validatesInclusionOf.message = "[property] is not included in the list";
	application.wheels.validatesLengthOf.message = "[property] is the wrong length";
	application.wheels.validatesNumericalityOf.message = "[property] is not a number";
	application.wheels.validatesPresenceOf.message = "[property] can't be empty";
	application.wheels.validatesUniquenessOf.message = "[property] has already been taken";
</cfscript>