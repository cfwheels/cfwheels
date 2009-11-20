<cffunction name="styleSheetLinkTag" returntype="string" access="public" output="false"
	hint="Returns a `link` tag based on the supplied arguments."
	examples=
	'
		<!--- view code --->
		<head>
		    ##styleSheetLinkTag("styles")##
		</head>
	'
	categories="view-helper" chapters="miscellaneous-helpers" functions="javaScriptIncludeTag,imageTag">
	<cfargument name="sources" type="string" required="false" default="" hint="The name of one or many CSS files in the `stylesheets` folder, minus the `.css` extension. (Can also be called with the `source` argument)">
	<cfargument name="type" type="string" required="false" default="#application.wheels.functions.styleSheetLinkTag.type#" hint="The `type` attribute for the `link` tag">
	<cfargument name="media" type="string" required="false" default="#application.wheels.functions.styleSheetLinkTag.media#" hint="The `media` attribute for the `link` tag">
	<cfscript>
		var loc = {};
		if (StructKeyExists(arguments, "source"))
			arguments.sources = arguments.source;
		$insertDefaults(name="styleSheetLinkTag", reserved="href,rel", input=arguments);
		arguments.rel = "stylesheet";
		loc.returnValue = "";
		loc.iEnd = ListLen(arguments.sources);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(arguments.sources, loc.i);
			arguments.href = application.wheels.webPath & application.wheels.stylesheetPath & "/" & Trim(loc.item);
			if (ListLast(loc.item, ".") != "css")
				arguments.href = arguments.href & ".css";
			loc.returnValue = loc.returnValue & $tag(name="link", skip="source,sources", close=true, attributes=arguments);
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="javaScriptIncludeTag" returntype="string" access="public" output="false"
	hint="Returns a `script` tag based on the supplied arguments."
	examples=
	'
		<!--- view code --->
		<head>
		    ##javaScriptIncludeTag("main")##
		</head>
	'
	categories="view-helper" chapters="miscellaneous-helpers" functions="styleSheetLinkTag,imageTag">
	<cfargument name="sources" type="string" required="false" default="" hint="The name of one or many JavaScript files in the `javascripts` folder, minus the `.js` extension. (Can also be called with the `source` argument)">
	<cfargument name="type" type="string" required="false" default="#application.wheels.functions.javaScriptIncludeTag.type#" hint="The `type` attribute for the `script` tag">
	<cfscript>
		var loc = {};
		if (StructKeyExists(arguments, "source"))
			arguments.sources = arguments.source;
		$insertDefaults(name="javaScriptIncludeTag", reserved="src", input=arguments);
		loc.returnValue = "";
		loc.iEnd = ListLen(arguments.sources);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(arguments.sources, loc.i);
			arguments.src = application.wheels.webPath & application.wheels.javascriptPath & "/" & Trim(loc.item);
			if (ListLast(loc.item, ".") != "js")
				arguments.src = arguments.src & ".js";
			loc.returnValue = loc.returnValue & $element(name="script", skip="source,sources", attributes=arguments);
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="imageTag" returntype="string" access="public" output="false"
	hint="Returns an image tag and will (if the image is stored in the local `images` folder) set the `width`, `height`, and `alt` attributes automatically for you."
	examples=
	'
		##imageTag("logo.png")##
	'
	categories="view-helper" chapters="miscellaneous-helpers" functions="javaScriptIncludeTag,styleSheetLinkTag">
	<cfargument name="source" type="string" required="true" hint="Image file name if local or full URL if remote">
	<cfscript>
		var loc = {};
		$insertDefaults(name="imageTag", reserved="src", input=arguments);
		if (application.wheels.cacheImages)
		{
			loc.category = "image";
			loc.key = $hashStruct(arguments);
			loc.lockName = loc.category & loc.key;
			loc.conditionArgs = {};
			loc.conditionArgs.category = loc.category;
			loc.conditionArgs.key = loc.key;
			loc.executeArgs = arguments;
			loc.executeArgs.category = loc.category;
			loc.executeArgs.key = loc.key;
			if (StructKeyExists(arguments, "id"))
				loc.executeArgs.wheelsId = arguments.id; // ugly fix due to the fact that id can't be passed along to cfinvoke
			loc.returnValue = $doubleCheckedLock(name=loc.lockName, condition="$getFromCache", execute="$addImageTagToCache", conditionArgs=loc.conditionArgs, executeArgs=loc.executeArgs);
			if (StructKeyExists(arguments, "id"))
				loc.returnValue = ReplaceNoCase(loc.returnValue, "wheelsId", "id"); // ugly fix, see above
		}
		else
		{
			loc.returnValue = $imageTag(argumentCollection=arguments);
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$addImageTagToCache" returntype="string" access="public" output="false">
	<cfscript>
		var returnValue = "";
		returnValue = $imageTag(argumentCollection=arguments);
		$addToCache(key=arguments.key, value=returnValue, category=arguments.category);
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="$imageTag" returntype="string" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.localFile = true;

		if(Left(arguments.source, 7) == "http://" || Left(arguments.source, 8) == "https://")
			loc.localFile = false;

		if (!loc.localFile)
		{
			arguments.src = arguments.source;
		}
		else
		{
			arguments.src = application.wheels.webPath & application.wheels.imagePath & "/" & arguments.source;
			if (application.wheels.showErrorInformation)
			{
				if (loc.localFile && !FileExists(ExpandPath(arguments.src)))
					$throw(type="Wheels.ImageFileNotFound", message="Wheels could not find `#expandPath('#arguments.src#')#` on the local file system.", extendedInfo="Pass in a correct relative path from the `images` folder to an image.");
				else if (loc.localFile && arguments.source Does Not Contain ".jpg" && arguments.source Does Not Contain ".gif" && arguments.source Does Not Contain ".png")
					$throw(type="Wheels.ImageFormatNotSupported", message="Wheels can't read image files with that format.", extendedInfo="Use a GIF, JPG or PNG image instead.");
			}
			if (!StructKeyExists(arguments, "width") || !StructKeyExists(arguments, "height"))
			{
				loc.image = $image(action="info", source=ExpandPath(arguments.src));
				if (loc.image.width > 0 && loc.image.height > 0)
				{
					arguments.width = loc.image.width;
					arguments.height = loc.image.height;
				}
			}
		}
		if (!StructKeyExists(arguments, "alt"))
			arguments.alt = capitalize(ReplaceList(SpanExcluding(Reverse(SpanExcluding(Reverse(arguments.src), "/")), "."), "-,_", " , "));
		loc.returnValue = $tag(name="img", skip="source,key,category", close=true, attributes=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>