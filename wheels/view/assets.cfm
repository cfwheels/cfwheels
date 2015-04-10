<!--- PUBLIC VIEW HELPER FUNCTIONS --->

<cffunction name="styleSheetLinkTag" returntype="string" access="public" output="false">
	<cfargument name="sources" type="string" required="false" default="">
	<cfargument name="type" type="string" required="false">
	<cfargument name="media" type="string" required="false">
	<cfargument name="head" type="string" required="false">
	<cfargument name="delim" type="string" required="false" default=",">
	<cfscript>
		var loc = {};
		$args(name="styleSheetLinkTag", args=arguments, combine="sources/source/!", reserved="href,rel");
		if (!Len(arguments.type))
		{
			StructDelete(arguments, "type");
		}
		if (!Len(arguments.media))
		{
			StructDelete(arguments, "media");
		}
		arguments.rel = "stylesheet";
		loc.rv = "";
		arguments.sources = $listClean(list=arguments.sources, returnAs="array", delim=arguments.delim);
		loc.iEnd = ArrayLen(arguments.sources);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = arguments.sources[loc.i];
			if (ReFindNoCase("^(https?:)?\/\/", loc.item))
			{
				arguments.href = arguments.sources[loc.i];
			}
			else
			{
				if (Left(loc.item, 1) == "/")
				{
					arguments.href = application.wheels.webPath & Right(loc.item, Len(loc.item)-1);
				}
				else
				{
					arguments.href = application.wheels.webPath & application.wheels.stylesheetPath & "/" & loc.item;
				}
				if (!ListFindNoCase("css,cfm", ListLast(loc.item, ".")))
				{
					arguments.href &= ".css";
				}
				arguments.href = $assetDomain(arguments.href) & $appendQueryString();
			}
			loc.rv &= $tag(name="link", skip="sources,head,delim", close=true, attributes=arguments) & Chr(10);
		}
		if (arguments.head)
		{
			$htmlhead(text=loc.rv);
			loc.rv = "";
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="javaScriptIncludeTag" returntype="string" access="public" output="false">
	<cfargument name="sources" type="string" required="false" default="">
	<cfargument name="type" type="string" required="false">
	<cfargument name="head" type="string" required="false">
	<cfargument name="delim" type="string" required="false" default=",">
	<cfscript>
		var loc = {};
		$args(name="javaScriptIncludeTag", args=arguments, combine="sources/source/!", reserved="src");
		if (!Len(arguments.type))
		{
			StructDelete(arguments, "type");
		}
		loc.rv = "";
		arguments.sources = $listClean(list=arguments.sources, returnAs="array", delim=arguments.delim);
		loc.iEnd = ArrayLen(arguments.sources);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = arguments.sources[loc.i];
			if (ReFindNoCase("^(https?:)?\/\/", loc.item))
			{
				arguments.src = arguments.sources[loc.i];
			}
			else
			{
				if (Left(loc.item, 1) == "/")
				{
					arguments.src = application.wheels.webPath & Right(loc.item, Len(loc.item)-1);
				}
				else
				{
					arguments.src = application.wheels.webPath & application.wheels.javascriptPath & "/" & loc.item;
				}
				if (!ListFindNoCase("js,cfm", ListLast(loc.item, ".")))
				{
					arguments.src &= ".js";
				}
				arguments.src = $assetDomain(arguments.src) & $appendQueryString();
			}
			loc.rv &= $element(name="script", skip="sources,head,delim", attributes=arguments) & Chr(10);
		}
		if (arguments.head)
		{
			$htmlhead(text=loc.rv);
			loc.rv = "";
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="imageTag" returntype="string" access="public" output="false">
	<cfargument name="source" type="string" required="true">
	<cfscript>
		var loc = {};
		$args(name="imageTag", reserved="src", args=arguments);

		// ugly fix due to the fact that id can't be passed along to cfinvoke
		if (StructKeyExists(arguments, "id"))
		{
			arguments.wheelsId = arguments.id;
			StructDelete(arguments, "id");
		}

		if (application.wheels.cacheImages)
		{
			loc.category = "image";
			loc.key = $hashedKey(arguments);
			loc.lockName = loc.category & loc.key & application.applicationName;
			loc.conditionArgs = {};
			loc.conditionArgs.category = loc.category;
			loc.conditionArgs.key = loc.key;
			loc.executeArgs = arguments;
			loc.executeArgs.category = loc.category;
			loc.executeArgs.key = loc.key;
			loc.rv = $doubleCheckedLock(name=loc.lockName, condition="$getFromCache", execute="$addImageTagToCache", conditionArgs=loc.conditionArgs, executeArgs=loc.executeArgs);
		}
		else
		{
			loc.rv = $imageTag(argumentCollection=arguments);
		}

		// ugly fix continued
		if (StructKeyExists(arguments, "wheelsId"))
		{
			loc.rv = ReplaceNoCase(loc.rv, "wheelsId", "id");
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<!--- PRIVATE FUNCTIONS --->

<cffunction name="$addImageTagToCache" returntype="string" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.rv = $imageTag(argumentCollection=arguments);
		$addToCache(key=arguments.key, value=loc.rv, category=arguments.category);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$imageTag" returntype="string" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.localFile = true;
		if (Left(arguments.source, 7) == "http://" || Left(arguments.source, 8) == "https://")
		{
			loc.localFile = false;
		}
		if (!loc.localFile)
		{
			arguments.src = arguments.source;
		}
		else
		{
			arguments.src = application.wheels.webPath & application.wheels.imagePath & "/" & arguments.source;
			if (get("showErrorInformation"))
			{
				if (loc.localFile && !FileExists(ExpandPath(arguments.src)))
				{
					$throw(type="Wheels.ImageFileNotFound", message="CFWheels could not find `#expandPath('#arguments.src#')#` on the local file system.", extendedInfo="Pass in a correct relative path from the `images` folder to an image.");
				}
				else if (!IsImageFile(ExpandPath(arguments.src)))
				{
					$throw(type="Wheels.ImageFormatNotSupported", message="CFWheels can't read image files with that format.", extendedInfo="Use one of these image types instead: #GetReadableImageFormats()#.");
				}
			}
			if (!StructKeyExists(arguments, "width") || !StructKeyExists(arguments, "height"))
			{
				// height and / or width arguments are missing so use cfimage to get them
				loc.image = $image(action="info", source=ExpandPath(arguments.src));
				if (!StructKeyExists(arguments, "width") && loc.image.width > 0)
				{
					arguments.width = loc.image.width;
				}
				if (!StructKeyExists(arguments, "height") && loc.image.height > 0)
				{
					arguments.height = loc.image.height;
				}
			}
			else
			{
				// remove height and width attributes if false
				if (arguments.width EQ false)
				{
					StructDelete(arguments, "width");
				}
				if (arguments.height EQ false)
				{
					StructDelete(arguments, "height");
				}
			}
			// only append a query string if the file is local
			arguments.src = $assetDomain(arguments.src) & $appendQueryString();
		}
		if (!StructKeyExists(arguments, "alt"))
		{
			arguments.alt = capitalize(ReplaceList(SpanExcluding(Reverse(SpanExcluding(Reverse(arguments.src), "/")), "."), "-,_", " , "));
		}
		loc.rv = $tag(name="img", skip="source,key,category", close=true, attributes=arguments);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$appendQueryString" returntype="string" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.rv = "";
		// if assetQueryString is a boolean value, it means we just reloaded, so create a new query string based off of now
		// the only problem with this is if the app doesn't get used a lot and the application is left alone for a period longer than the application scope is allowed to exist
		if (IsBoolean(application.wheels.assetQueryString) && YesNoFormat(application.wheels.assetQueryString) == "no")
		{
			return loc.rv;
		}
		if (!IsNumeric(application.wheels.assetQueryString) && IsBoolean(application.wheels.assetQueryString))
		{
			application.wheels.assetQueryString = Hash(DateFormat(Now(), "yyyymmdd") & TimeFormat(Now(), "HHmmss"));
		}
		loc.rv &= "?" & application.wheels.assetQueryString;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$assetDomain" returntype="string" access="public" output="false">
	<cfargument name="pathToAsset" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = arguments.pathToAsset;
		if (get("showErrorInformation"))
		{
			if (!IsStruct(application.wheels.assetPaths) && !IsBoolean(application.wheels.assetPaths))
			{
				$throw(type="Wheels.IncorrectConfiguration", message="The setting `assetsPaths` must be false or a struct.");
			}
			if (IsStruct(application.wheels.assetPaths) && !ListFindNoCase(StructKeyList(application.wheels.assetPaths), "http"))
			{
				$throw(type="Wheels.IncorrectConfiguration", message="The `assetPaths` setting struct must contain the key `http`");
			}
		}

		// return nothing if assetPaths is not a struct
		if (!IsStruct(application.wheels.assetPaths))
		{
			return loc.rv;
		}

		loc.protocol = "http://";
		loc.domainList = application.wheels.assetPaths.http;
		if (isSecure())
		{
			loc.protocol = "https://";
			if (StructKeyExists(application.wheels.assetPaths, "https"))
			{
				loc.domainList = application.wheels.assetPaths.https;
			}
		}
		loc.domainLen = ListLen(loc.domainList);
		if (loc.domainLen > 1)
		{
			// now comes the interesting part, lets take the pathToAsset argument, hash it and create a number from it
			// so that we can do mod based off the length of the domain list
			// this is an easy way to apply the same sub-domain to each asset, so we do not create more work for the server
			// at the same time we are getting a very random hash value to rotate the domains over the assets evenly
			loc.pathNumber = Right(REReplace(Hash(arguments.pathToAsset), "[A-Za-z]", "", "all"), 5);
			loc.position = (loc.pathNumber % loc.domainLen) + 1;
		}
		else
		{
			loc.position = loc.domainLen;
		}
		loc.rv = loc.protocol & Trim(ListGetAt(loc.domainList, loc.position)) & arguments.pathToAsset;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>