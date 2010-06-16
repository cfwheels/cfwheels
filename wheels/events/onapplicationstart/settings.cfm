<cfscript>
	// rewrite settings based on web server rewrite capabilites
	application.wheels.rewriteFile = "rewrite.cfm";
	if (Right(request.cgi.script_name, 12) == "/" & application.wheels.rewriteFile)
		application.wheels.URLRewriting = "On";
	else if (Len(request.cgi.path_info))
		application.wheels.URLRewriting = "Partial";
	else
		application.wheels.URLRewriting = "Off";

	// set datasource name to same as the folder the app resides in unless the developer has set it with the global setting already
	if (StructKeyExists(this, "dataSource"))
		application.wheels.dataSourceName = this.dataSource;
	else
		application.wheels.dataSourceName = LCase(ListLast(GetDirectoryFromPath(GetBaseTemplatePath()), Right(GetDirectoryFromPath(GetBaseTemplatePath()), 1)));
	application.wheels.dataSourceUserName = "";
	application.wheels.dataSourcePassword = "";
	application.wheels.transactionMode = "commit"; // use 'commit', 'rollback' or 'none' to set default transaction handling for creates, updates and deletes

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
	application.wheels.errorEmailSubject = "Error";
	application.wheels.assetQueryString = false;
	// assetPaths can be struct with two keys,  http and https, if no https struct key, http is used for secure and non-secure
	// ex. {http="asset0.domain1.com,asset2.domain1.com,asset3.domain1.com", https="secure.domain1.com"}
	application.wheels.assetPaths = false;

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
		application.wheels.assetQueryString = true;
	}
	if (application.wheels.environment == "production")
	{
		application.wheels.showErrorInformation = false;
		if (request.cgi.server_name Contains ".")
		{
			application.wheels.sendEmailOnError = true;
			application.wheels.errorEmailAddress = "webmaster@" & Reverse(ListGetAt(Reverse(request.cgi.server_name), 2,".")) & "." & Reverse(ListGetAt(Reverse(request.cgi.server_name), 1, "."));
		}
	}

	// paths
	application.wheels.controllerPath = "controllers";

	// miscellaneous settings
	application.wheels.tableNamePrefix = "";
	application.wheels.obfuscateURLs = false;
	application.wheels.reloadPassword = "";
	application.wheels.softDeleteProperty = "deletedAt";
	application.wheels.timeStampOnCreateProperty = "createdAt";
	application.wheels.timeStampOnUpdateProperty = "updatedAt";
	application.wheels.ipExceptions = "";
	application.wheels.overwritePlugins = true;
	application.wheels.deletePluginDirectories = true;
	application.wheels.loadIncompatiblePlugins = true;
	application.wheels.loadDefaultRoutes = true;
	application.wheels.automaticValidations = true;
	application.wheels.setUpdatedAtOnCreate = true;
	application.wheels.useExpandedColumnAliases = true;

	// caching settings
	application.wheels.maximumItemsToCache = 5000;
	application.wheels.cacheCullPercentage = 10;
	application.wheels.cacheCullInterval = 5;
	application.wheels.defaultCacheTime = 60;
	application.wheels.clearQueryCacheOnReload = true;

	// function defaults
	application.wheels.functions = {};
	application.wheels.functions.$location = {delay=false};
	application.wheels.functions.autoLink = {domains="com,net,org,info,biz,tv,co.uk,de,ro,it,se,ly,nu"};
	application.wheels.functions.average = {distinct=false, parameterize=true, ifNull=""};
	application.wheels.functions.belongsTo = {joinType="inner"};
	application.wheels.functions.buttonTo = {onlyPath=true, host="", protocol="", port=0, text="", confirm="", image="", disable=""};
	application.wheels.functions.buttonTag = {type="submit", value="save", content="Save changes", image="", disable=""};
	application.wheels.functions.caches = {time=60, static=false};
	application.wheels.functions.checkBox = {label=true, labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", checkedValue=1, unCheckedValue=0};
	application.wheels.functions.checkBoxTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", value=1};
	application.wheels.functions.count = {parameterize=true};
	application.wheels.functions.create = {parameterize=true, reload=false};
	application.wheels.functions.dateSelect = {label=true, labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", includeBlank=false, order="month,day,year", separator=" ", startYear=Year(Now())-5, endYear=Year(Now())+5, monthDisplay="names"};
	application.wheels.functions.dateSelectTags = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, order="month,day,year", separator=" ", startYear=Year(Now())-5, endYear=Year(Now())+5, monthDisplay="names"};
	application.wheels.functions.dateTimeSelect = {label=true, labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", includeBlank=false, dateOrder="month,day,year", dateSeparator=" ", startYear=Year(Now())-5, endYear=Year(Now())+5, monthDisplay="names", timeOrder="hour,minute,second", timeSeparator=":", minuteStep=1, separator=" - "};
	application.wheels.functions.dateTimeSelectTags = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, dateOrder="month,day,year", dateSeparator=" ", startYear=Year(Now())-5, endYear=Year(Now())+5, monthDisplay="names", timeOrder="hour,minute,second", timeSeparator=":", minuteStep=1, separator=" - "};
	application.wheels.functions.daySelectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false};
	application.wheels.functions.delete = {parameterize=true};
	application.wheels.functions.deleteAll = {reload=false, parameterize=true, instantiate=false};
	application.wheels.functions.deleteByKey = {reload=false};
	application.wheels.functions.deleteOne = {reload=false};
	application.wheels.functions.distanceOfTimeInWords = {includeSeconds=false};
	application.wheels.functions.errorMessageOn = {prependText="", appendText="", wrapperElement="span", class="error-message"};
	application.wheels.functions.errorMessagesFor = {class="error-messages", showDuplicates=true};
	application.wheels.functions.exists = {reload=false, parameterize=true};
	application.wheels.functions.fileField = {label=true, labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span"};
	application.wheels.functions.fileFieldTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel=""};
	application.wheels.functions.findAll = {reload=false, parameterize=true, perPage=10, order="", group="", returnAs="query", returnIncluded=true};
	application.wheels.functions.findByKey = {reload=false, parameterize=true, returnAs="object"};
	application.wheels.functions.findOne = {reload=false, parameterize=true, returnAs="object"};
	application.wheels.functions.hasMany = {joinType="outer"};
	application.wheels.functions.hasOne = {joinType="outer"};
	application.wheels.functions.hiddenField = {};
	application.wheels.functions.hourSelectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false};
	application.wheels.functions.imageTag = {};
	application.wheels.functions.includePartial = {layout="", spacer=""};
	application.wheels.functions.javaScriptIncludeTag = {type="text/javascript", head=false};
	application.wheels.functions.linkTo = {onlyPath=true, host="", protocol="", port=0};
	application.wheels.functions.mailTo = {encode=false};
	application.wheels.functions.maximum = {parameterize=true, ifNull=""};
	application.wheels.functions.minimum = {parameterize=true, ifNull=""};
	application.wheels.functions.minuteSelectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, minuteStep=1};
	application.wheels.functions.monthSelectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, monthDisplay="names"};
	application.wheels.functions.paginationLinks = {windowSize=2, alwaysShowAnchors=true, anchorDivider=" ... ", linkToCurrentPage=false, prepend="", append="", prependToPage="", prependOnFirst=true, prependOnAnchor=true, appendToPage="", appendOnLast=true, appendOnAnchor=true, classForCurrent="", name="page", showSinglePage=false, pageNumberAsParam=true};
	application.wheels.functions.passwordField = {label=true, labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span"};
	application.wheels.functions.passwordFieldTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel=""};
	application.wheels.functions.radioButton = {label=true, labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span"};
	application.wheels.functions.radioButtonTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel=""};
	application.wheels.functions.redirectTo = {onlyPath=true, host="", protocol="", port=0, addToken=false, statusCode=302, delay=false};
	application.wheels.functions.renderPage = {layout=true};
	application.wheels.functions.renderPageToString = {layout=true};
	application.wheels.functions.renderPartial = {layout=""};
	application.wheels.functions.save = {parameterize=true, reload=false};
	application.wheels.functions.secondSelectTag = {label=true, labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false};
	application.wheels.functions.select = {label=true, labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", includeBlank=false, valueField="", textField=""};
	application.wheels.functions.selectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, multiple=false, valueField="", textField=""};
	application.wheels.functions.sendEmail = {layout=false, detectMultipart=true};
	application.wheels.functions.sendFile = {disposition="attachment"};
	application.wheels.functions.startFormTag = {onlyPath=true, host="", protocol="", port=0, method="post", multipart=false, spamProtection=false};
	application.wheels.functions.styleSheetLinkTag = {type="text/css", media="all", head=false};
	application.wheels.functions.submitTag = {value="Save changes", image="", disable=""};
	application.wheels.functions.sum = {distinct=false, parameterize=true, ifNull=""};
	application.wheels.functions.textArea = {label=true, labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span"};
	application.wheels.functions.textAreaTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel=""};
	application.wheels.functions.textField = {label=true, labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span"};
	application.wheels.functions.textFieldTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel=""};
	application.wheels.functions.timeAgoInWords = {includeSeconds=false};
	application.wheels.functions.timeSelect = {label=true, labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", includeBlank=false, order="hour,minute,second", separator=":", minuteStep=1};
	application.wheels.functions.timeSelectTags = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, order="hour,minute,second", separator=":", minuteStep=1};
	application.wheels.functions.timeUntilInWords = {includeSeconds=false};
	application.wheels.functions.toggle = {save=true};
	application.wheels.functions.truncate = {length=30, truncateString="..."};
	application.wheels.functions.update = {parameterize=true, reload=false};
	application.wheels.functions.updateAll = {reload=false, parameterize=true, instantiate=false};
	application.wheels.functions.updateByKey = {reload=false};
	application.wheels.functions.updateOne = {reload=false};
	application.wheels.functions.updateProperty = {parameterize=true};
	application.wheels.functions.updateProperties = {parameterize=true};
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
	application.wheels.functions.wordTruncate = {length=5, truncateString="..."};
	application.wheels.functions.yearSelectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, startYear=Year(Now())-5, endYear=Year(Now())+5};

	// set a flag to indicate that all settings have been loaded
	application.wheels.initialized = true;

	// mime types
	application.wheels.mimetypes = {
		txt="text/plain"
		,gif="image/gif"
		,jpg="image/jpg"
		,jpeg="image/jpg"
		,pjpeg="image/jpg"
		,png="image/png"
		,wav="audio/wav"
		,mp3="audio/mpeg3"
		,pdf="application/pdf"
		,zip="application/zip"
		,ppt="application/powerpoint"
		,pptx="application/powerpoint"
		,doc="application/word"
		,docx="application/word"
		,xls="application/excel"
		,xlsx="application/excel"
	};
</cfscript>