<cfscript>

public string function styleSheetLinkTag(string sources="", string type, string media, string head, string delim=",") {
	$args(name="styleSheetLinkTag", args=arguments, combine="sources/source/!", reserved="href,rel");
	if (!Len(arguments.type)) {
		StructDelete(arguments, "type");
	}
	if (!Len(arguments.media)) {
		StructDelete(arguments, "media");
	}
	arguments.rel = "stylesheet";
	local.rv = "";
	arguments.sources = $listClean(list=arguments.sources, returnAs="array", delim=arguments.delim);
	local.iEnd = ArrayLen(arguments.sources);
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		local.item = arguments.sources[local.i];
		if (ReFindNoCase("^(https?:)?\/\/", local.item)) {
			arguments.href = arguments.sources[local.i];
		} else {
			if (Left(local.item, 1) == "/") {
				arguments.href = get("webPath") & Right(local.item, Len(local.item)-1);
			} else {
				arguments.href = get("webPath") & get("stylesheetPath") & "/" & local.item;
			}
			if (!ListFindNoCase("css,cfm", ListLast(local.item, "."))) {
				arguments.href &= ".css";
			}
			arguments.href = $assetDomain(arguments.href) & $appendQueryString();
		}
		local.rv &= $tag(name="link", skip="sources,head,delim", close=true, attributes=arguments) & Chr(10);
	}
	if (arguments.head) {
		$htmlhead(text=local.rv);
		local.rv = "";
	}
	return local.rv;
}

public string function javaScriptIncludeTag(string sources="", string type, string head, string delim=",") {
	$args(name="javaScriptIncludeTag", args=arguments, combine="sources/source/!", reserved="src");
	if (!Len(arguments.type)) {
		StructDelete(arguments, "type");
	}
	local.rv = "";
	arguments.sources = $listClean(list=arguments.sources, returnAs="array", delim=arguments.delim);
	local.iEnd = ArrayLen(arguments.sources);
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		local.item = arguments.sources[local.i];
		if (ReFindNoCase("^(https?:)?\/\/", local.item)) {
			arguments.src = arguments.sources[local.i];
		} else {
			if (Left(local.item, 1) == "/") {
				arguments.src = get("webPath") & Right(local.item, Len(local.item)-1);
			} else {
				arguments.src = get("webPath") & get("javascriptPath") & "/" & local.item;
			}
			if (!ListFindNoCase("js,cfm", ListLast(local.item, "."))) {
				arguments.src &= ".js";
			}
			arguments.src = $assetDomain(arguments.src) & $appendQueryString();
		}
		local.rv &= $element(name="script", skip="sources,head,delim", attributes=arguments) & Chr(10);
	}
	if (arguments.head) {
		$htmlhead(text=local.rv);
		local.rv = "";
	}
	return local.rv;
}

public string function imageTag(
	required string source,
	boolean onlyPath,
	string host,
	string protocol,
	numeric port
) {
	$args(name="imageTag", reserved="src", args=arguments);

	// Ugly fix due to the fact that id can't be passed along to cfinvoke.
	if (StructKeyExists(arguments, "id")) {
		arguments.wheelsId = arguments.id;
		StructDelete(arguments, "id");
	}

	if (get("cacheImages")) {
		local.category = "image";
		local.key = $hashedKey(arguments);
		local.lockName = local.category & local.key & application.applicationName;
		local.conditionArgs = {};
		local.conditionArgs.category = local.category;
		local.conditionArgs.key = local.key;
		local.executeArgs = arguments;
		local.executeArgs.category = local.category;
		local.executeArgs.key = local.key;
		local.rv = $doubleCheckedLock(name=local.lockName, condition="$getFromCache", execute="$addImageTagToCache", conditionArgs=local.conditionArgs, executeArgs=local.executeArgs);
	} else {
		local.rv = $imageTag(argumentCollection=arguments);
	}

	// Ugly fix continued.
	if (StructKeyExists(arguments, "wheelsId")) {
		local.rv = ReplaceNoCase(local.rv, "wheelsId", "id");
	}

	return local.rv;
}

public string function $addImageTagToCache() {
	local.rv = $imageTag(argumentCollection=arguments);
	$addToCache(key=arguments.key, value=local.rv, category=arguments.category);
	return local.rv;
}

public string function $imageTag() {
	local.localFile = true;
	if (Left(arguments.source, 7) == "http://" || Left(arguments.source, 8) == "https://") {
		local.localFile = false;
	}
	if (!local.localFile) {
		arguments.src = arguments.source;
	} else {
		arguments.src = get("webPath") & get("imagePath") & "/" & arguments.source;
		local.file = GetDirectoryFromPath(GetBaseTemplatePath()) & get("imagePath") & "/" & SpanExcluding(arguments.source, "?");
		if (get("showErrorInformation")) {
			if (local.localFile && !FileExists(local.file)) {
				$throw(type="Wheels.ImageFileNotFound", message="CFWheels could not find `#local.file#` on the local file system.", extendedInfo="Pass in a correct relative path from the `images` folder to an image.");
			} else if (!IsImageFile(local.file)) {
				$throw(type="Wheels.ImageFormatNotSupported", message="CFWheels can't read image files with that format.", extendedInfo="Use one of these image types instead: #GetReadableImageFormats()#.");
			}
		}
		if (!StructKeyExists(arguments, "width") || !StructKeyExists(arguments, "height")) {

			// Height and / or width arguments are missing so use cfimage to get them.
			local.image = $image(action="info", source=local.file);
			if (!StructKeyExists(arguments, "width") && local.image.width > 0) {
				arguments.width = local.image.width;
			}
			if (!StructKeyExists(arguments, "height") && local.image.height > 0) {
				arguments.height = local.image.height;
			}

		} else {

			// Remove height and width attributes if false.
			if (!arguments.width) {
				StructDelete(arguments, "width");
			}
			if (!arguments.height) {
				StructDelete(arguments, "height");
			}

		}

		// Only append a query string if the file is local.
		arguments.src = $assetDomain(arguments.src) & $appendQueryString();

		if (!arguments.onlyPath) {
			arguments.src = $prependUrl(path=arguments.src, argumentCollection=arguments);
		}
	}
	if (!StructKeyExists(arguments, "alt")) {
		arguments.alt = capitalize(ReplaceList(SpanExcluding(Reverse(SpanExcluding(Reverse(arguments.src), "/")), "."), "-,_", " , "));
	}
	return $tag(name="img", skip="source,key,category,onlyPath,host,protocol,port", close=true, attributes=arguments);
}

public string function $appendQueryString() {
	local.rv = "";
	local.assetQueryString = get("assetQueryString");

	// If assetQueryString is a boolean value, it means we just reloaded, so create a new query string based off of now.
	// The only problem with this is if the app doesn't get used a lot and the application is left alone for a period longer than the application scope is allowed to exist.
	if (IsBoolean(local.assetQueryString) && YesNoFormat(local.assetQueryString) == "no") {
		return local.rv;
	}
	if (!IsNumeric(local.assetQueryString) && IsBoolean(local.assetQueryString)) {
		local.assetQueryString = Hash(DateFormat(Now(), "yyyymmdd") & TimeFormat(Now(), "HHmmss"));
		set(assetQueryString=local.assetQueryString);
	}

	local.rv &= "?" & local.assetQueryString;
	return local.rv;
}

public string function $assetDomain(required string pathToAsset) {
	local.rv = arguments.pathToAsset;
	local.assetPaths = get("assetPaths");
	if (get("showErrorInformation")) {
		if (!IsStruct(local.assetPaths) && !IsBoolean(local.assetPaths)) {
			$throw(type="Wheels.IncorrectConfiguration", message="The setting `assetsPaths` must be false or a struct.");
		}
		if (IsStruct(local.assetPaths) && !ListFindNoCase(StructKeyList(local.assetPaths), "http")) {
			$throw(type="Wheels.IncorrectConfiguration", message="The `assetPaths` setting struct must contain the key `http`");
		}
	}

	// return nothing if assetPaths is not a struct
	if (!IsStruct(local.assetPaths)) {
		return local.rv;
	}

	local.protocol = "http://";
	local.domainList = local.assetPaths.http;
	if (isSecure()) {
		local.protocol = "https://";
		if (StructKeyExists(local.assetPaths, "https")) {
			local.domainList = local.assetPaths.https;
		}
	}
	local.domainLen = ListLen(local.domainList);
	if (local.domainLen > 1) {
		// now comes the interesting part, lets take the pathToAsset argument, hash it and create a number from it
		// so that we can do mod based off the length of the domain list
		// this is an easy way to apply the same sub-domain to each asset, so we do not create more work for the server
		// at the same time we are getting a very random hash value to rotate the domains over the assets evenly
		local.pathNumber = Right(REReplace(Hash(arguments.pathToAsset), "[A-Za-z]", "", "all"), 5);
		local.position = (local.pathNumber % local.domainLen) + 1;
	} else {
		local.position = local.domainLen;
	}
	local.rv = local.protocol & Trim(ListGetAt(local.domainList, local.position)) & arguments.pathToAsset;
	return local.rv;
}

</cfscript>
