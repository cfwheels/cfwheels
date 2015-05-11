<cffunction name="onApplicationStart" returntype="void" access="public" output="false">
	<cfscript>
		var loc = {};

		// abort if called from incorrect file
		$abortInvalidRequest();

		// setup the wheels storage struct for the current request
		$initializeRequestScope();

		// set or reset all settings but make sure to pass along the reload password between forced reloads with "reload=x"
		if (StructKeyExists(application, "wheels") && StructKeyExists(application.wheels, "reloadPassword"))
		{
			loc.oldReloadPassword = application.wheels.reloadPassword;
		}
		application.$wheels = {};
		if (StructKeyExists(loc, "oldReloadPassword"))
		{
			application.$wheels.reloadPassword = loc.oldReloadPassword;
		}

		// check and store server engine name, throw error if using a version that we don't support
		// NB Lucee first as there seems to be some sort of alias in Lucee -> Railo which means server.railo exists
		if (StructKeyExists(server, "lucee"))
		{
			application.$wheels.serverName = "Lucee";
			application.$wheels.serverVersion = server.lucee.version;
		}
		else if (StructKeyExists(server, "railo"))
		{
			application.$wheels.serverName = "Railo";
			application.$wheels.serverVersion = server.railo.version;
		}
		else
		{
			application.$wheels.serverName = "Adobe ColdFusion";
			application.$wheels.serverVersion = server.coldfusion.productVersion;
		}
		loc.upgradeTo = $checkMinimumVersion(engine=application.$wheels.serverName, version=application.$wheels.serverVersion);
		if (Len(loc.upgradeTo))
		{
			$throw(type="Wheels.EngineNotSupported", message="#application.$wheels.serverName# #application.$wheels.serverVersion# is not supported by CFWheels.", extendedInfo="Please upgrade to version #loc.upgradeTo# or higher.");
		}

		// copy over the cgi variables we need to the request scope (since we use some of these to determine URL rewrite capabilities we need to be able to access them directly on application start for example)
		request.cgi = $cgiScope();

		// set up containers for routes, caches, settings etc
		application.$wheels.version = "1.4.1";
		application.$wheels.hostName = CreateObject("java", "java.net.InetAddress").getLocalHost().getHostName();
		application.$wheels.controllers = {};
		application.$wheels.models = {};
		application.$wheels.existingHelperFiles = "";
		application.$wheels.existingLayoutFiles = "";
		application.$wheels.existingObjectFiles = "";
		application.$wheels.nonExistingHelperFiles = "";
		application.$wheels.nonExistingLayoutFiles = "";
		application.$wheels.nonExistingObjectFiles = "";
		application.$wheels.routes = [];
		application.$wheels.namedRoutePositions = {};
		application.$wheels.mixins = {};
		application.$wheels.cache = {};
		application.$wheels.cache.sql = {};
		application.$wheels.cache.image = {};
		application.$wheels.cache.main = {};
		application.$wheels.cache.action = {};
		application.$wheels.cache.page = {};
		application.$wheels.cache.partial = {};
		application.$wheels.cache.query = {};
		application.$wheels.cacheLastCulledAt = Now();

		// set up paths to various folders in the framework
		application.$wheels.webPath = Replace(request.cgi.script_name, Reverse(spanExcluding(Reverse(request.cgi.script_name), "/")), "");
		application.$wheels.rootPath = "/" & ListChangeDelims(application.$wheels.webPath, "/", "/");
		application.$wheels.rootcomponentPath = ListChangeDelims(application.$wheels.webPath, ".", "/");
		application.$wheels.wheelsComponentPath = ListAppend(application.$wheels.rootcomponentPath, "wheels", ".");

		// set environment either from the url or the developer's environment.cfm file
		if (StructKeyExists(URL, "reload") && !IsBoolean(URL.reload) && Len(url.reload) && StructKeyExists(application.$wheels, "reloadPassword") && (!Len(application.$wheels.reloadPassword) || (StructKeyExists(URL, "password") && URL.password == application.$wheels.reloadPassword)))
		{
			application.$wheels.environment = URL.reload;
		}
		else
		{
			$include(template="config/environment.cfm");
		}

		// rewrite settings based on web server rewrite capabilites
		application.$wheels.rewriteFile = "rewrite.cfm";
		if (Right(request.cgi.script_name, 12) == "/" & application.$wheels.rewriteFile)
		{
			application.$wheels.URLRewriting = "On";
		}
		else if (Len(request.cgi.path_info))
		{
			application.$wheels.URLRewriting = "Partial";
		}
		else
		{
			application.$wheels.URLRewriting = "Off";
		}

		// set datasource name to same as the folder the app resides in unless the developer has set it with the global setting already
		if (StructKeyExists(this, "dataSource"))
		{
			application.$wheels.dataSourceName = this.dataSource;
		}
		else
		{
			application.$wheels.dataSourceName = LCase(ListLast(GetDirectoryFromPath(GetBaseTemplatePath()), Right(GetDirectoryFromPath(GetBaseTemplatePath()), 1)));
		}
		application.$wheels.dataSourceUserName = "";
		application.$wheels.dataSourcePassword = "";
		application.$wheels.transactionMode = "commit";

		// cache settings
		application.$wheels.cacheDatabaseSchema = false;
		application.$wheels.cacheFileChecking = false;
		application.$wheels.cacheImages = false;
		application.$wheels.cacheModelInitialization = false;
		application.$wheels.cacheControllerInitialization = false;
		application.$wheels.cacheRoutes = false;
		application.$wheels.cacheActions = false;
		application.$wheels.cachePages = false;
		application.$wheels.cachePartials = false;
		application.$wheels.cacheQueries = false;
		application.$wheels.cachePlugins = true;
		if (application.$wheels.environment != "design")
		{
			application.$wheels.cacheDatabaseSchema = true;
			application.$wheels.cacheFileChecking = true;
			application.$wheels.cacheImages = true;
			application.$wheels.cacheModelInitialization = true;
			application.$wheels.cacheControllerInitialization = true;
			application.$wheels.cacheRoutes = true;
		}
		if (application.$wheels.environment != "design" && application.$wheels.environment != "development")
		{
			application.$wheels.cacheActions = true;
			application.$wheels.cachePages = true;
			application.$wheels.cachePartials = true;
			application.$wheels.cacheQueries = true;
		}

		// debugging and error settings
		application.$wheels.showDebugInformation = true;
		application.$wheels.showErrorInformation = true;
		application.$wheels.sendEmailOnError = false;
		application.$wheels.errorEmailSubject = "Error";
		application.$wheels.excludeFromErrorEmail = "";
		if (Find(".", request.cgi.server_name))
		{
			application.$wheels.errorEmailAddress = "webmaster@" & Reverse(ListGetAt(Reverse(request.cgi.server_name), 2,".")) & "." & Reverse(ListGetAt(Reverse(request.cgi.server_name), 1, "."));
		}
		else
		{
			application.$wheels.errorEmailAddress = "";
		}
		if (application.$wheels.environment == "production")
		{
			application.$wheels.showErrorInformation = false;
			application.$wheels.sendEmailOnError = true;
		}
		if (application.$wheels.environment != "design" && application.$wheels.environment != "development")
		{
			application.$wheels.showDebugInformation = false;
		}

		// asset path settings
		// assetPaths can be struct with two keys,  http and https, if no https struct key, http is used for secure and non-secure
		// ex. {http="asset0.domain1.com,asset2.domain1.com,asset3.domain1.com", https="secure.domain1.com"}
		application.$wheels.assetQueryString = false;
		application.$wheels.assetPaths = false;
		if (application.$wheels.environment != "design" && application.$wheels.environment != "development")
		{
			application.$wheels.assetQueryString = true;
		}

		// configurable paths
		application.$wheels.eventPath = "events";
		application.$wheels.filePath = "files";
		application.$wheels.imagePath = "images";
		application.$wheels.javascriptPath = "javascripts";
		application.$wheels.modelPath = "models";
		application.$wheels.modelComponentPath = "models";
		application.$wheels.pluginPath = "plugins";
		application.$wheels.pluginComponentPath = "plugins";
		application.$wheels.stylesheetPath = "stylesheets";
		application.$wheels.viewPath = "views";
		application.$wheels.controllerPath = "controllers";

		// miscellaneous settings
		application.$wheels.dataAttributeDelimiter = "_";
		application.$wheels.tableNamePrefix = "";
		application.$wheels.obfuscateURLs = false;
		application.$wheels.reloadPassword = "";
		application.$wheels.softDeleteProperty = "deletedAt";
		application.$wheels.timeStampOnCreateProperty = "createdAt";
		application.$wheels.timeStampOnUpdateProperty = "updatedAt";
		application.$wheels.ipExceptions = "";
		application.$wheels.overwritePlugins = true;
		application.$wheels.deletePluginDirectories = true;
		application.$wheels.loadIncompatiblePlugins = true;
		application.$wheels.loadDefaultRoutes = true;
		application.$wheels.automaticValidations = true;
		application.$wheels.setUpdatedAtOnCreate = true;
		application.$wheels.useExpandedColumnAliases = false;
		application.$wheels.modelRequireInit = false;
		application.$wheels.booleanAttributes = "allowfullscreen,async,autofocus,autoplay,checked,compact,controls,declare,default,defaultchecked,defaultmuted,defaultselected,defer,disabled,draggable,enabled,formnovalidate,hidden,indeterminate,inert,ismap,itemscope,loop,multiple,muted,nohref,noresize,noshade,novalidate,nowrap,open,pauseonexit,readonly,required,reversed,scoped,seamless,selected,sortable,spellcheck,translate,truespeed,typemustmatch,visible";

		// if session management is enabled in the application we default to storing flash data in the session scope, if not we use a cookie
		if (StructKeyExists(this, "sessionManagement") && this.sessionManagement)
		{
			application.$wheels.sessionManagement = true;
			application.$wheels.flashStorage = "session";
		}
		else
		{
			application.$wheels.sessionManagement = false;
			application.$wheels.flashStorage = "cookie";
		}

		// caching settings
		application.$wheels.maximumItemsToCache = 5000;
		application.$wheels.cacheCullPercentage = 10;
		application.$wheels.cacheCullInterval = 5;
		application.$wheels.cacheDatePart = "n";
		application.$wheels.defaultCacheTime = 60;
		application.$wheels.clearQueryCacheOnReload = true;
		application.$wheels.clearServerCacheOnReload = true;
		application.$wheels.cacheQueriesDuringRequest = true;

		// possible formats for provides
		application.$wheels.formats = {};
		application.$wheels.formats.html = "text/html";
		application.$wheels.formats.xml = "text/xml";
		application.$wheels.formats.json = "application/json";
		application.$wheels.formats.csv = "text/csv";
		application.$wheels.formats.pdf = "application/pdf";
		application.$wheels.formats.xls = "application/vnd.ms-excel";

		// function defaults
		application.$wheels.functions = {};
		application.$wheels.functions.autoLink = {link="all"};
		application.$wheels.functions.average = {distinct=false, parameterize=true, ifNull=""};
		application.$wheels.functions.belongsTo = {joinType="inner"};
		application.$wheels.functions.buttonTo = {onlyPath=true, host="", protocol="", port=0, text="", confirm="", image="", disable=""};
		application.$wheels.functions.buttonTag = {type="submit", value="save", content="Save changes", image="", disable="", prepend="", append=""};
		application.$wheels.functions.caches = {time=60, static=false};
		application.$wheels.functions.checkBox = {label="useDefaultLabel", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", errorClass="fieldWithErrors", checkedValue=1, unCheckedValue=0};
		application.$wheels.functions.checkBoxTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", value=1};
		application.$wheels.functions.count = {parameterize=true};
		application.$wheels.functions.create = {parameterize=true, reload=false};
		application.$wheels.functions.dateSelect = {label=false, labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", errorClass="fieldWithErrors", includeBlank=false, order="month,day,year", separator=" ", startYear=Year(Now())-5, endYear=Year(Now())+5, monthDisplay="names", monthNames="January,February,March,April,May,June,July,August,September,October,November,December", monthAbbreviations="Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec"};
		application.$wheels.functions.dateSelectTags = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, order="month,day,year", separator=" ", startYear=Year(Now())-5, endYear=Year(Now())+5, monthDisplay="names", monthNames="January,February,March,April,May,June,July,August,September,October,November,December", monthAbbreviations="Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec"};
		application.$wheels.functions.dateTimeSelect = {label=false, labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", errorClass="fieldWithErrors", includeBlank=false, dateOrder="month,day,year", dateSeparator=" ", startYear=Year(Now())-5, endYear=Year(Now())+5, monthDisplay="names", monthNames="January,February,March,April,May,June,July,August,September,October,November,December", monthAbbreviations="Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec", timeOrder="hour,minute,second", timeSeparator=":", minuteStep=1, secondStep=1, separator=" - ", twelveHour=false};
		application.$wheels.functions.dateTimeSelectTags = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, dateOrder="month,day,year", dateSeparator=" ", startYear=Year(Now())-5, endYear=Year(Now())+5, monthDisplay="names", monthNames="January,February,March,April,May,June,July,August,September,October,November,December", monthAbbreviations="Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec", timeOrder="hour,minute,second", timeSeparator=":", minuteStep=1, secondStep=1,separator=" - ", twelveHour=false};
		application.$wheels.functions.daySelectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false};
		application.$wheels.functions.delete = {parameterize=true};
		application.$wheels.functions.deleteAll = {reload=false, parameterize=true, instantiate=false};
		application.$wheels.functions.deleteByKey = {reload=false};
		application.$wheels.functions.deleteOne = {reload=false};
		application.$wheels.functions.distanceOfTimeInWords = {includeSeconds=false};
		application.$wheels.functions.endFormTag = {prepend="", append=""};
		application.$wheels.functions.errorMessageOn = {prependText="", appendText="", wrapperElement="span", class="errorMessage"};
		application.$wheels.functions.errorMessagesFor = {class="errorMessages", showDuplicates=true};
		application.$wheels.functions.excerpt = {radius=100, excerptString="..."};
		application.$wheels.functions.exists = {reload=false, parameterize=true};
		application.$wheels.functions.fileField = {label="useDefaultLabel", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", errorClass="fieldWithErrors"};
		application.$wheels.functions.fileFieldTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel=""};
		application.$wheels.functions.findAll = {reload=false, parameterize=true, perPage=10, order="", group="", returnAs="query", returnIncluded=true};
		application.$wheels.functions.findByKey = {reload=false, parameterize=true, returnAs="object"};
		application.$wheels.functions.findOne = {reload=false, parameterize=true, returnAs="object"};
		application.$wheels.functions.flashKeep = {};
		application.$wheels.functions.flashMessages = {class="flashMessages", includeEmptyContainer="false", lowerCaseDynamicClassValues=false};
		application.$wheels.functions.hasMany = {joinType="outer", dependent=false};
		application.$wheels.functions.hasOne = {joinType="outer", dependent=false};
		application.$wheels.functions.hiddenField = {};
		application.$wheels.functions.highlight = {delimiter=",", tag="span", class="highlight"};
		application.$wheels.functions.hourSelectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, twelveHour=false};
		application.$wheels.functions.imageTag = {};
		application.$wheels.functions.includePartial = {layout="", spacer="", dataFunction=true};
		application.$wheels.functions.javaScriptIncludeTag = {type="text/javascript", head=false};
		application.$wheels.functions.linkTo = {onlyPath=true, host="", protocol="", port=0};
		application.$wheels.functions.mailTo = {encode=false};
		application.$wheels.functions.maximum = {parameterize=true, ifNull=""};
		application.$wheels.functions.minimum = {parameterize=true, ifNull=""};
		application.$wheels.functions.minuteSelectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, minuteStep=1};
		application.$wheels.functions.monthSelectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, monthDisplay="names", monthNames="January,February,March,April,May,June,July,August,September,October,November,December", monthAbbreviations="Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec"};
		application.$wheels.functions.nestedProperties = {autoSave=true, allowDelete=false, sortProperty="", rejectIfBlank=""};
		application.$wheels.functions.paginationLinks = {windowSize=2, alwaysShowAnchors=true, anchorDivider=" ... ", linkToCurrentPage=false, prepend="", append="", prependToPage="", prependOnFirst=true, prependOnAnchor=true, appendToPage="", appendOnLast=true, appendOnAnchor=true, classForCurrent="", name="page", showSinglePage=false, pageNumberAsParam=true};
		application.$wheels.functions.passwordField = {label="useDefaultLabel", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", errorClass="fieldWithErrors"};
		application.$wheels.functions.passwordFieldTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel=""};
		application.$wheels.functions.radioButton = {label="useDefaultLabel", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", errorClass="fieldWithErrors"};
		application.$wheels.functions.radioButtonTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel=""};
		application.$wheels.functions.redirectTo = {onlyPath=true, host="", protocol="", port=0, addToken=false, statusCode=302, delay=false};
		application.$wheels.functions.renderPage = {layout=""};
		application.$wheels.functions.renderWith = {layout=""};
		application.$wheels.functions.renderPageToString = {layout=true};
		application.$wheels.functions.renderPartial = {layout="", dataFunction=true};
		application.$wheels.functions.save = {parameterize=true, reload=false};
		application.$wheels.functions.secondSelectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, secondStep=1};
		application.$wheels.functions.select = {label="useDefaultLabel", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", errorClass="fieldWithErrors", includeBlank=false, valueField="", textField=""};
		application.$wheels.functions.selectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, multiple=false, valueField="", textField=""};
		application.$wheels.functions.sendEmail = {layout=false, detectMultipart=true, from="", to="", subject=""};
		application.$wheels.functions.sendFile = {disposition="attachment"};
		application.$wheels.functions.simpleFormat = {wrap=true};
		application.$wheels.functions.startFormTag = {onlyPath=true, host="", protocol="", port=0, method="post", multipart=false, spamProtection=false, prepend="", append=""};
		application.$wheels.functions.styleSheetLinkTag = {type="text/css", media="all", head=false};
		application.$wheels.functions.submitTag = {value="Save changes", image="", disable="", prepend="", append=""};
		application.$wheels.functions.sum = {distinct=false, parameterize=true, ifNull=""};
		application.$wheels.functions.textArea = {label="useDefaultLabel", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", errorClass="fieldWithErrors"};
		application.$wheels.functions.textAreaTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel=""};
		application.$wheels.functions.textField = {label="useDefaultLabel", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", errorClass="fieldWithErrors"};
		application.$wheels.functions.textFieldTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel=""};
		application.$wheels.functions.timeAgoInWords = {includeSeconds=false};
		application.$wheels.functions.timeSelect = {label=false, labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", errorClass="fieldWithErrors", includeBlank=false, order="hour,minute,second", separator=":", minuteStep=1, secondStep=1, twelveHour=false};
		application.$wheels.functions.timeSelectTags = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, order="hour,minute,second", separator=":", minuteStep=1, secondStep=1, twelveHour=false};
		application.$wheels.functions.timeUntilInWords = {includeSeconds=false};
		application.$wheels.functions.toggle = {save=true};
		application.$wheels.functions.truncate = {length=30, truncateString="..."};
		application.$wheels.functions.update = {parameterize=true, reload=false};
		application.$wheels.functions.updateAll = {reload=false, parameterize=true, instantiate=false};
		application.$wheels.functions.updateByKey = {reload=false};
		application.$wheels.functions.updateOne = {reload=false};
		application.$wheels.functions.updateProperty = {parameterize=true};
		application.$wheels.functions.updateProperties = {parameterize=true};
		application.$wheels.functions.URLFor = {onlyPath=true, host="", protocol="", port=0};
		application.$wheels.functions.validatesConfirmationOf = {message="[property] should match confirmation"};
		application.$wheels.functions.validatesExclusionOf = {message="[property] is reserved", allowBlank=false};
		application.$wheels.functions.validatesFormatOf = {message="[property] is invalid", allowBlank=false};
		application.$wheels.functions.validatesInclusionOf = {message="[property] is not included in the list", allowBlank=false};
		application.$wheels.functions.validatesLengthOf = {message="[property] is the wrong length", allowBlank=false, exactly=0, maximum=0, minimum=0, within=""};
		application.$wheels.functions.validatesNumericalityOf = {message="[property] is not a number", allowBlank=false, onlyInteger=false, odd="", even="", greaterThan="", greaterThanOrEqualTo="", equalTo="", lessThan="", lessThanOrEqualTo=""};
		application.$wheels.functions.validatesPresenceOf = {message="[property] can't be empty"};
		application.$wheels.functions.validatesUniquenessOf = {message="[property] has already been taken", allowBlank=false};
		application.$wheels.functions.verifies = {handler=""};
		application.$wheels.functions.wordTruncate = {length=5, truncateString="..."};
		application.$wheels.functions.yearSelectTag = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, startYear=Year(Now())-5, endYear=Year(Now())+5};

		// mime types
		application.$wheels.mimetypes = {txt="text/plain", gif="image/gif", jpg="image/jpg", jpeg="image/jpg", pjpeg="image/jpg", png="image/png", wav="audio/wav", mp3="audio/mpeg3", pdf="application/pdf", zip="application/zip", ppt="application/powerpoint", pptx="application/powerpoint", doc="application/word", docx="application/word", xls="application/excel", xlsx="application/excel"};

		// set a flag to indicate that all wheels settings have been loaded
		application.$wheels.initialized = true;

		// load general developer settings first, then override with environment specific ones
		$include(template="config/settings.cfm");
		$include(template="config/#application.$wheels.environment#/settings.cfm");

		// clear query (cfquery) and page (cfcache) caches
		if (application.$wheels.clearQueryCacheOnReload)
		{
			$objectcache(action="clear");
		}
		if (application.$wheels.clearServerCacheOnReload)
		{
			$cache(action="flush");
		}

		// add all public controller / view methods to a list of methods that you should not be allowed to call as a controller action from the url
		loc.allowedGlobalMethods = "get,set,addroute,addDefaultRoutes";
		loc.protectedControllerMethods = StructKeyList($createObjectFromRoot(path=application.$wheels.controllerPath, fileName="Wheels", method="$initControllerClass"));
		application.$wheels.protectedControllerMethods = "";
		loc.iEnd = ListLen(loc.protectedControllerMethods);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.method = ListGetAt(loc.protectedControllerMethods, loc.i);
			if (Left(loc.method, 1) != "$" && !ListFindNoCase(loc.allowedGlobalMethods, loc.method))
			{
				application.$wheels.protectedControllerMethods = ListAppend(application.$wheels.protectedControllerMethods, loc.method);
			}
		}

		// reload the plugins each time we reload the application
		$loadPlugins();

		// allow developers to inject plugins into the application variables scope
		if (!StructIsEmpty(application.$wheels.mixins))
		{
			$include(template="wheels/plugins/injection.cfm");
		}

		// load developer routes and adds the default wheels routes (unless the developer has specified not to)
		$loadRoutes();

		// create the dispatcher that will handle all incoming requests
		application.$wheels.dispatch = $createObjectFromRoot(path="wheels", fileName="Dispatch", method="$init");

		// assign it all to the application scope in one atomic call
		application.wheels = application.$wheels;
		StructDelete(application, "$wheels");

		// run the developer's on application start code
		$include(template="#application.wheels.eventPath#/onapplicationstart.cfm");
	</cfscript>
</cffunction>