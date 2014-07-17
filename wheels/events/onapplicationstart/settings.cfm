<cfscript>
	loc.appKey = "wheels";
	if (StructKeyExists(application, "_wheels"))
	{
		loc.appKey = "_wheels";
	}

	// rewrite settings based on web server rewrite capabilites
	application[loc.appKey].rewriteFile = "rewrite.cfm";
	if (Right(request.cgi.script_name, 12) == "/" & application[loc.appKey].rewriteFile)
		application[loc.appKey].URLRewriting = "On";
	else if (Len(request.cgi.path_info))
		application[loc.appKey].URLRewriting = "Partial";
	else
		application[loc.appKey].URLRewriting = "Off";

	// set datasource name to same as the folder the app resides in unless the developer has set it with the global setting already
	if (StructKeyExists(this, "dataSource"))
		application[loc.appKey].dataSourceName = this.dataSource;
	else
		application[loc.appKey].dataSourceName = LCase(ListLast(GetDirectoryFromPath(GetBaseTemplatePath()), Right(GetDirectoryFromPath(GetBaseTemplatePath()), 1)));
	application[loc.appKey].dataSourceUserName = "";
	application[loc.appKey].dataSourcePassword = "";
	application[loc.appKey].transactionMode = "commit"; // use 'commit', 'rollback' or 'none' to set default transaction handling for creates, updates and deletes

	// cache settings
	application[loc.appKey].cacheDatabaseSchema = false;
	application[loc.appKey].cacheFileChecking = false;
	application[loc.appKey].cacheImages = false;
	application[loc.appKey].cacheModelInitialization = false;
	application[loc.appKey].cacheControllerInitialization = false;
	application[loc.appKey].cacheRoutes = false;
	application[loc.appKey].cacheActions = false;
	application[loc.appKey].cachePages = false;
	application[loc.appKey].cachePartials = false;
	application[loc.appKey].cacheQueries = false;
	application[loc.appKey].cachePlugins = true;
	if (application[loc.appKey].environment != "design")
	{
		application[loc.appKey].cacheDatabaseSchema = true;
		application[loc.appKey].cacheFileChecking = true;
		application[loc.appKey].cacheImages = true;
		application[loc.appKey].cacheModelInitialization = true;
		application[loc.appKey].cacheControllerInitialization = true;
		application[loc.appKey].cacheRoutes = true;
	}
	if (application[loc.appKey].environment != "design" && application[loc.appKey].environment != "development")
	{
		application[loc.appKey].cacheActions = true;
		application[loc.appKey].cachePages = true;
		application[loc.appKey].cachePartials = true;
		application[loc.appKey].cacheQueries = true;
	}

	// debugging and error settings
	application[loc.appKey].showDebugInformation = true;
	application[loc.appKey].showErrorInformation = true;
	application[loc.appKey].sendEmailOnError = false;
	application[loc.appKey].errorEmailSubject = "Error";
	application[loc.appKey].excludeFromErrorEmail = "";
	if (request.cgi.server_name Contains ".")
		application[loc.appKey].errorEmailAddress = "webmaster@" & Reverse(ListGetAt(Reverse(request.cgi.server_name), 2,".")) & "." & Reverse(ListGetAt(Reverse(request.cgi.server_name), 1, "."));
	else
		application[loc.appKey].errorEmailAddress = "";
	if (application[loc.appKey].environment == "production")
	{
		application[loc.appKey].showErrorInformation = false;
		application[loc.appKey].sendEmailOnError = true;
	}
	if (application[loc.appKey].environment != "design" && application[loc.appKey].environment != "development")
		application[loc.appKey].showDebugInformation = false;

	// asset path settings
	// assetPaths can be struct with two keys,  http and https, if no https struct key, http is used for secure and non-secure
	// ex. {http="asset0.domain1.com,asset2.domain1.com,asset3.domain1.com", https="secure.domain1.com"}
	application[loc.appKey].assetQueryString = false;
	application[loc.appKey].assetPaths = false;
	if (application[loc.appKey].environment != "design" && application[loc.appKey].environment != "development")
		application[loc.appKey].assetQueryString = true;

	// paths
	application[loc.appKey].controllerPath = "controllers";

	// miscellaneous settings
	application[loc.appKey].dataAttributeDelimiter = "_";
	application[loc.appKey].tableNamePrefix = "";
	application[loc.appKey].obfuscateURLs = false;
	application[loc.appKey].reloadPassword = "";
	application[loc.appKey].softDeleteProperty = "deletedAt";
	application[loc.appKey].timeStampOnCreateProperty = "createdAt";
	application[loc.appKey].timeStampOnUpdateProperty = "updatedAt";
	application[loc.appKey].ipExceptions = "";
	application[loc.appKey].overwritePlugins = true;
	application[loc.appKey].deletePluginDirectories = true;
	application[loc.appKey].loadIncompatiblePlugins = true;
	application[loc.appKey].loadDefaultRoutes = true;
	application[loc.appKey].automaticValidations = true;
	application[loc.appKey].setUpdatedAtOnCreate = true;
	application[loc.appKey].useExpandedColumnAliases = false;
	application[loc.appKey].modelRequireInit = false;
	
	// if session management is enabled in the application we default to storing flash data in the session scope, if not we use a cookie
	if (StructKeyExists(this, "sessionManagement") && this.sessionManagement)
	{
		application[loc.appKey].sessionManagement = true;
		application[loc.appKey].flashStorage = "session";
	}
	else
	{
		application[loc.appKey].sessionManagement = false;
		application[loc.appKey].flashStorage = "cookie";
	}

	// caching settings
	application[loc.appKey].maximumItemsToCache = 5000;
	application[loc.appKey].cacheCullPercentage = 10;
	application[loc.appKey].cacheCullInterval = 5;
	application[loc.appKey].cacheDatePart = "n";
	application[loc.appKey].defaultCacheTime = 60;
	application[loc.appKey].clearQueryCacheOnReload = true;
	application[loc.appKey].cacheQueriesDuringRequest = true;
	
	// possible formats for provides
	application[loc.appKey].formats = {};
	application[loc.appKey].formats.html = "text/html";
	application[loc.appKey].formats.xml = "text/xml";
	application[loc.appKey].formats.json = "application/json";
	application[loc.appKey].formats.csv = "text/csv";
	application[loc.appKey].formats.pdf = "application/pdf";
	application[loc.appKey].formats.xls = "application/vnd.ms-excel";

	// function defaults
	application[loc.appKey].functions = {};
	application[loc.appKey].functions.average = {distinct=false, parameterize=true, ifNull=""};
	application[loc.appKey].functions.belongsTo = {joinType="inner"};
	application[loc.appKey].functions.buttonTo = {onlyPath=true, host="", protocol="", port=0, text="", confirm="", image="", disable=""};
	application[loc.appKey].functions.buttonTag = {type="submit", value="save", content="Save changes", image="", disable=""};
	application[loc.appKey].functions.caches = {time=60, static=false};
	application[loc.appKey].functions.checkBox = {label="useDefaultLabel", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", errorClass="fieldWithErrors", checkedValue=1, unCheckedValue=0};
	application[loc.appKey].functions.checkBoxTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", value=1};
	application[loc.appKey].functions.count = {parameterize=true};
	application[loc.appKey].functions.create = {parameterize=true, reload=false};
	application[loc.appKey].functions.dateSelect = {label=false, labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", errorClass="fieldWithErrors", includeBlank=false, order="month,day,year", separator=" ", startYear=Year(Now())-5, endYear=Year(Now())+5, monthDisplay="names"};
	application[loc.appKey].functions.dateSelectTags = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, order="month,day,year", separator=" ", startYear=Year(Now())-5, endYear=Year(Now())+5, monthDisplay="names"};
	application[loc.appKey].functions.dateTimeSelect = {label=false, labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", errorClass="fieldWithErrors", includeBlank=false, dateOrder="month,day,year", dateSeparator=" ", startYear=Year(Now())-5, endYear=Year(Now())+5, monthDisplay="names", timeOrder="hour,minute,second", timeSeparator=":", minuteStep=1, secondStep=1, separator=" - "};
	application[loc.appKey].functions.dateTimeSelectTags = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, dateOrder="month,day,year", dateSeparator=" ", startYear=Year(Now())-5, endYear=Year(Now())+5, monthDisplay="names", timeOrder="hour,minute,second", timeSeparator=":", minuteStep=1, secondStep=1,separator=" - "};
	application[loc.appKey].functions.daySelectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false};
	application[loc.appKey].functions.delete = {parameterize=true};
	application[loc.appKey].functions.deleteAll = {reload=false, parameterize=true, instantiate=false};
	application[loc.appKey].functions.deleteByKey = {reload=false};
	application[loc.appKey].functions.deleteOne = {reload=false};
	application[loc.appKey].functions.distanceOfTimeInWords = {includeSeconds=false};
	application[loc.appKey].functions.errorMessageOn = {prependText="", appendText="", wrapperElement="span", class="errorMessage"};
	application[loc.appKey].functions.errorMessagesFor = {class="errorMessages", showDuplicates=true};
	application[loc.appKey].functions.exists = {reload=false, parameterize=true};
	application[loc.appKey].functions.fileField = {label="useDefaultLabel", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", errorClass="fieldWithErrors"};
	application[loc.appKey].functions.fileFieldTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel=""};
	application[loc.appKey].functions.findAll = {reload=false, parameterize=true, perPage=10, order="", group="", returnAs="query", returnIncluded=true};
	application[loc.appKey].functions.findByKey = {reload=false, parameterize=true, returnAs="object"};
	application[loc.appKey].functions.findOne = {reload=false, parameterize=true, returnAs="object"};
	application[loc.appKey].functions.flashKeep = {};
	application[loc.appKey].functions.flashMessages = {class="flashMessages", includeEmptyContainer="false", lowerCaseDynamicClassValues=false};
	application[loc.appKey].functions.hasMany = {joinType="outer", dependent=false};
	application[loc.appKey].functions.hasOne = {joinType="outer", dependent=false};
	application[loc.appKey].functions.hiddenField = {};
	application[loc.appKey].functions.highlight = {delimiter=",", tag="span", class="highlight"};
	application[loc.appKey].functions.hourSelectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false};
	application[loc.appKey].functions.imageTag = {};
	application[loc.appKey].functions.includePartial = {layout="", spacer="", dataFunction=true};
	application[loc.appKey].functions.javaScriptIncludeTag = {type="text/javascript", head=false};
	application[loc.appKey].functions.linkTo = {onlyPath=true, host="", protocol="", port=0};
	application[loc.appKey].functions.mailTo = {encode=false};
	application[loc.appKey].functions.maximum = {parameterize=true, ifNull=""};
	application[loc.appKey].functions.minimum = {parameterize=true, ifNull=""};
	application[loc.appKey].functions.minuteSelectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, minuteStep=1};
	application[loc.appKey].functions.monthSelectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, monthDisplay="names"};
	application[loc.appKey].functions.nestedProperties = {autoSave=true, allowDelete=false, sortProperty="", rejectIfBlank=""};
	application[loc.appKey].functions.paginationLinks = {windowSize=2, alwaysShowAnchors=true, anchorDivider=" ... ", linkToCurrentPage=false, prepend="", append="", prependToPage="", prependOnFirst=true, prependOnAnchor=true, appendToPage="", appendOnLast=true, appendOnAnchor=true, classForCurrent="", name="page", showSinglePage=false, pageNumberAsParam=true};
	application[loc.appKey].functions.passwordField = {label="useDefaultLabel", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", errorClass="fieldWithErrors"};
	application[loc.appKey].functions.passwordFieldTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel=""};
	application[loc.appKey].functions.radioButton = {label="useDefaultLabel", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", errorClass="fieldWithErrors"};
	application[loc.appKey].functions.radioButtonTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel=""};
	application[loc.appKey].functions.redirectTo = {onlyPath=true, host="", protocol="", port=0, addToken=false, statusCode=302, delay=false};
	application[loc.appKey].functions.renderPage = {layout=""};
	application[loc.appKey].functions.renderWith = {layout=""};
	application[loc.appKey].functions.renderPageToString = {layout=true};
	application[loc.appKey].functions.renderPartial = {layout="", dataFunction=true};
	application[loc.appKey].functions.save = {parameterize=true, reload=false};
	application[loc.appKey].functions.secondSelectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, secondStep=1};
	application[loc.appKey].functions.select = {label="useDefaultLabel", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", errorClass="fieldWithErrors", includeBlank=false, valueField="", textField=""};
	application[loc.appKey].functions.selectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, multiple=false, valueField="", textField=""};
	application[loc.appKey].functions.sendEmail = {layout=false, detectMultipart=true, from="", to="", subject=""};
	application[loc.appKey].functions.sendFile = {disposition="attachment"};
	application[loc.appKey].functions.startFormTag = {onlyPath=true, host="", protocol="", port=0, method="post", multipart=false, spamProtection=false};
	application[loc.appKey].functions.styleSheetLinkTag = {type="text/css", media="all", head=false};
	application[loc.appKey].functions.submitTag = {value="Save changes", image="", disable="", prepend="", append=""};
	application[loc.appKey].functions.sum = {distinct=false, parameterize=true, ifNull=""};
	application[loc.appKey].functions.textArea = {label="useDefaultLabel", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", errorClass="fieldWithErrors"};
	application[loc.appKey].functions.textAreaTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel=""};
	application[loc.appKey].functions.textField = {label="useDefaultLabel", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", errorClass="fieldWithErrors"};
	application[loc.appKey].functions.textFieldTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel=""};
	application[loc.appKey].functions.timeAgoInWords = {includeSeconds=false};
	application[loc.appKey].functions.timeSelect = {label=false, labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", errorClass="fieldWithErrors", includeBlank=false, order="hour,minute,second", separator=":", minuteStep=1, secondStep=1};
	application[loc.appKey].functions.timeSelectTags = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, order="hour,minute,second", separator=":", minuteStep=1, secondStep=1};
	application[loc.appKey].functions.timeUntilInWords = {includeSeconds=false};
	application[loc.appKey].functions.toggle = {save=true};
	application[loc.appKey].functions.truncate = {length=30, truncateString="..."};
	application[loc.appKey].functions.update = {parameterize=true, reload=false};
	application[loc.appKey].functions.updateAll = {reload=false, parameterize=true, instantiate=false};
	application[loc.appKey].functions.updateByKey = {reload=false};
	application[loc.appKey].functions.updateOne = {reload=false};
	application[loc.appKey].functions.updateProperty = {parameterize=true};
	application[loc.appKey].functions.updateProperties = {parameterize=true};
	application[loc.appKey].functions.URLFor = {onlyPath=true, host="", protocol="", port=0};
	application[loc.appKey].functions.validatesConfirmationOf = {message="[property] should match confirmation"};
	application[loc.appKey].functions.validatesExclusionOf = {message="[property] is reserved", allowBlank=false};
	application[loc.appKey].functions.validatesFormatOf = {message="[property] is invalid", allowBlank=false};
	application[loc.appKey].functions.validatesInclusionOf = {message="[property] is not included in the list", allowBlank=false};
	application[loc.appKey].functions.validatesLengthOf = {message="[property] is the wrong length", allowBlank=false, exactly=0, maximum=0, minimum=0, within=""};
	application[loc.appKey].functions.validatesNumericalityOf = {message="[property] is not a number", allowBlank=false, onlyInteger=false, odd="", even="", greaterThan="", greaterThanOrEqualTo="", equalTo="", lessThan="", lessThanOrEqualTo=""};
	application[loc.appKey].functions.validatesPresenceOf = {message="[property] can't be empty"};
	application[loc.appKey].functions.validatesUniquenessOf = {message="[property] has already been taken", allowBlank=false};
	application[loc.appKey].functions.verifies = {handler=""};
	application[loc.appKey].functions.wordTruncate = {length=5, truncateString="..."};
	application[loc.appKey].functions.yearSelectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, startYear=Year(Now())-5, endYear=Year(Now())+5};

	// set a flag to indicate that all settings have been loaded
	application[loc.appKey].initialized = true;

	// mime types
	application[loc.appKey].mimetypes = {
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