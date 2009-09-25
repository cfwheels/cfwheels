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

	// settings that depend on the environment
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

	// override settings for specific environments
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
	application.wheels.overwritePlugins = true;
	application.wheels.loadIncompatiblePlugins = true;
	
	// caching settings
	application.wheels.maximumItemsToCache = 5000;
	application.wheels.cacheCullPercentage = 10;
	application.wheels.cacheCullInterval = 5;
	application.wheels.defaultCacheTime = 60;

	// function defaults
	application.wheels.functions = {};
	application.wheels.functions.average = {distinct=false};
	application.wheels.functions.belongsTo = {joinType="inner"};
	application.wheels.functions.buttonTo = {onlyPath=true, host="", protocol="", port=0, text="", confirm="", image="", disable=""};
	application.wheels.functions.caches = {time=60};
	application.wheels.functions.checkBox = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", checkedValue=1, unCheckedValue=0};
	application.wheels.functions.checkBoxTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", value=1};
	application.wheels.functions.create = {parameterize=true, defaults=true};
	application.wheels.functions.dateSelect = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", includeBlank=false, order="month,day,year", separator=" ", startYear=Year(Now())-5, endYear=Year(Now())+5, monthDisplay="names"};
	application.wheels.functions.dateSelectTags = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, order="month,day,year", separator=" ", startYear=Year(Now())-5, endYear=Year(Now())+5, monthDisplay="names"};
	application.wheels.functions.dateTimeSelect = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", includeBlank=false, dateOrder="month,day,year", dateSeparator=" ", startYear=Year(Now())-5, endYear=Year(Now())+5, monthDisplay="names", timeOrder="hour,minute,second", timeSeparator=":", minuteStep=1, separator=" - "};
	application.wheels.functions.dateTimeSelectTags = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, dateOrder="month,day,year", dateSeparator=" ", startYear=Year(Now())-5, endYear=Year(Now())+5, monthDisplay="names", timeOrder="hour,minute,second", timeSeparator=":", minuteStep=1, separator=" - "};
	application.wheels.functions.daySelectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false};
	application.wheels.functions.delete = {parameterize=true};
	application.wheels.functions.deleteAll = {parameterize=true, instantiate=false};
	application.wheels.functions.distanceOfTimeInWords = {includeSeconds=false};
	application.wheels.functions.errorMessageOn = {prependText="", appendText="", wrapperElement="span", class="error-message"};
	application.wheels.functions.errorMessagesFor = {class="error-messages", showDuplicates=true};
	application.wheels.functions.exists = {reload=false, parameterize=true};
	application.wheels.functions.fileField = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span"};
	application.wheels.functions.fileFieldTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel=""};
	application.wheels.functions.findAll = {reload=false, parameterize=true, perPage=10, order="", returnAs="query", returnIncluded=true};
	application.wheels.functions.findByKey = {reload=false, parameterize=true, returnAs="object"};
	application.wheels.functions.findOne = {reload=false, parameterize=true, returnAs="object"};
	application.wheels.functions.hasMany = {joinType="outer"};
	application.wheels.functions.hasOne = {joinType="outer"};
	application.wheels.functions.hiddenField = {};
	application.wheels.functions.hourSelectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false};
	application.wheels.functions.imageTag = {};
	application.wheels.functions.includePartial = {layout=""};
	application.wheels.functions.javaScriptIncludeTag = {type="text/javascript"};
	application.wheels.functions.linkTo = {onlyPath=true, host="", protocol="", port=0};
	application.wheels.functions.mailTo = {encode=false};
	application.wheels.functions.minuteSelectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, minuteStep=1};
	application.wheels.functions.monthSelectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, monthDisplay="names"};
	application.wheels.functions.new = {defaults=false};
	application.wheels.functions.paginationLinks = {windowSize=2, alwaysShowAnchors=true, anchorDivider=" ... ", linkToCurrentPage=false, prepend="", append="", prependToPage="", prependOnFirst=true, appendToPage="", appendOnLast=true, classForCurrent="", name="page", showSinglePage=false};
	application.wheels.functions.passwordField = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span"};
	application.wheels.functions.passwordFieldTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel=""};
	application.wheels.functions.radioButton = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span"};
	application.wheels.functions.radioButtonTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel=""};
	application.wheels.functions.redirectTo = {onlyPath=true, host="", protocol="", port=0, addToken=false, statusCode=302};
	application.wheels.functions.renderPage = {layout=true};
	application.wheels.functions.renderPageToString = {layout=true};
	application.wheels.functions.renderPartial = {layout=""};
	application.wheels.functions.save = {parameterize=true, defaults=true};
	application.wheels.functions.secondSelectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false};
	application.wheels.functions.select = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", includeBlank=false, valueField="", textField=""};
	application.wheels.functions.selectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, multiple=false, valueField="", textField=""};
	application.wheels.functions.sendEmail = {layouts=false, detectMultipart=true};
	application.wheels.functions.sendFile = {disposition="attachment"};
	application.wheels.functions.startFormTag = {onlyPath=true, host="", protocol="", port=0, method="post", multipart=false, spamProtection=false};
	application.wheels.functions.styleSheetLinkTag = {type="text/css", media="all"};
	application.wheels.functions.submitTag = {value="Save changes", image="", disable=""};
	application.wheels.functions.sum = {distinct=false};
	application.wheels.functions.textArea = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span"};
	application.wheels.functions.textAreaTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel=""};
	application.wheels.functions.textField = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span"};
	application.wheels.functions.textFieldTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel=""};
	application.wheels.functions.timeAgoInWords = {includeSeconds=false};
	application.wheels.functions.timeSelect = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", includeBlank=false, order="hour,minute,second", separator=":", minuteStep=1};
	application.wheels.functions.timeSelectTags = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, order="hour,minute,second", separator=":", minuteStep=1};
	application.wheels.functions.timeUntilInWords = {includeSeconds=false};
	application.wheels.functions.update = {parameterize=true};
	application.wheels.functions.updateAll = {parameterize=true, instantiate=false};
	application.wheels.functions.URLFor = {onlyPath=true, host="", protocol="", port=0};
	application.wheels.functions.validatesConfirmationOf = {message="[property] should match confirmation"};
	application.wheels.functions.validatesExclusionOf = {message="[property] is reserved", allowBlank=false};
	application.wheels.functions.validatesFormatOf = {message="[property] is invalid", allowBlank=false};
	application.wheels.functions.validatesInclusionOf = {message="[property] is not included in the list", allowBlank=false};
	application.wheels.functions.validatesLengthOf = {message="[property] is the wrong length", allowBlank=false, exactly=0, maximum=0, minimum=0, within=""};
	application.wheels.functions.validatesNumericalityOf = {message="[property] is not a number", allowBlank=false, onlyInteger=false};
	application.wheels.functions.validatesPresenceOf = {message="[property] can't be empty"};
	application.wheels.functions.validatesUniquenessOf = {message="[property] has already been taken", allowBlank=false};
	application.wheels.functions.verifies = {handler=""};
	application.wheels.functions.yearSelectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, startYear=Year(Now())-5, endYear=Year(Now())+5};

	// set a flag to indicate that all settings have been loaded
	application.wheels.initialized = true;
</cfscript>