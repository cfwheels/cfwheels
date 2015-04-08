<!--- PUBLIC VIEW HELPER FUNCTIONS --->

<cffunction name="flashMessages" returntype="string" access="public" output="false">
	<cfargument name="keys" type="string" required="false">
	<cfargument name="class" type="string" required="false">
	<cfargument name="includeEmptyContainer" type="boolean" required="false">
	<cfargument name="lowerCaseDynamicClassValues" type="boolean" required="false">
	<cfscript>
		var loc = {};
		$args(name="flashMessages", args=arguments, combine="keys/key");
		loc.flash = $readFlash();
		loc.rv = "";

		// if no keys are requested, populate with everything stored in the Flash and sort them
		if (!StructKeyExists(arguments, "keys"))
		{
			loc.flashKeys = StructKeyList(loc.flash);
			loc.flashKeys = ListSort(loc.flashKeys, "textnocase");
		}
		else
		{
			// otherwise, generate list based on what was passed as "arguments.keys"
			loc.flashKeys = arguments.keys;
		}

		// generate markup for each Flash item in the list
		loc.listItems = "";
		loc.iEnd = ListLen(loc.flashKeys);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(loc.flashKeys, loc.i);
			loc.class = loc.item & "Message";
			if (arguments.lowerCaseDynamicClassValues)
			{
				loc.class = LCase(loc.class);
			}
			loc.attributes = {class=loc.class};
			if (!StructKeyExists(arguments, "key") || arguments.key == loc.item)
			{
				loc.content = loc.flash[loc.item];
				if (IsSimpleValue(loc.content))
				{
					loc.listItems &= $element(name="p", content=loc.content, attributes=loc.attributes);
				}
			}
		}

		if (Len(loc.listItems) || arguments.includeEmptyContainer)
		{
			loc.rv = $element(name="div", skip="key,keys,includeEmptyContainer,lowerCaseDynamicClassValues", content=loc.listItems, attributes=arguments);
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="contentFor" returntype="void" access="public" output="false">
	<cfargument name="position" type="any" required="false" default="last">
	<cfargument name="overwrite" type="any" required="false" default="false">
	<cfscript>
		var loc = {};

		// position in the array for the content
		loc.position = "last";

		//should we overwrite or insert into the array
		loc.overwrite = "false";

		// extract optional arguments
		if (StructKeyExists(arguments, "position"))
		{
			loc.position = arguments.position;
			StructDelete(arguments, "position");
		}
		if (StructKeyExists(arguments, "overwrite"))
		{
			loc.overwrite = arguments.overwrite;
			StructDelete(arguments, "overwrite");
		}

		// if no other arguments exists, exit
		if (StructIsEmpty(arguments))
		{
			return;
		}

		// since we're not going to know the name of the section, we have to get it dynamically
		loc.section = ListFirst(StructKeyList(arguments));
		loc.content = arguments[loc.section];

		if (!IsBoolean(loc.overwrite))
		{
			loc.overwrite = "all";
		}

		if (!StructKeyExists(variables.$instance.contentFor, loc.section) || loc.overwrite == "all")
		{
			// if the section doesn't exists, or they want to overwrite the whole thing
			variables.$instance.contentFor[loc.section] = [];
			ArrayAppend(variables.$instance.contentFor[loc.section], loc.content);
		}
		else
		{
			loc.size = ArrayLen(variables.$instance.contentFor[loc.section]);
			// they want to append, prepend or insert at a specific point in the array
			// make sure position is within range
			if (!IsNumeric(loc.position) && !ListFindNoCase("first,last", loc.position))
			{
				loc.position = "last";
			}
			if (IsNumeric(loc.position))
			{
				if (loc.position <= 1)
				{
					loc.position = "first";
				}
				else if (loc.position >= loc.size)
				{
					loc.position = "last";
				}
			}
			if (loc.overwrite)
			{
				if (loc.position == "last")
				{
					loc.position = loc.size;
				}
				else if (loc.position == "first")
				{
					loc.position = 1;
				}
				variables.$instance.contentFor[loc.section][loc.position] = loc.content;
			}
			else
			{
				if (loc.position == "last")
				{
					ArrayAppend(variables.$instance.contentFor[loc.section], loc.content);
				}
				else if (loc.position == "first")
				{
					ArrayPrepend(variables.$instance.contentFor[loc.section], loc.content);
				}
				else
				{
					ArrayInsertAt(variables.$instance.contentFor[loc.section], loc.position, loc.content);
				}
			}
		}
	</cfscript>
</cffunction>

<cffunction name="includeLayout" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="false" default="layout">
	<cfscript>
		arguments.partial = arguments.name;
		StructDelete(arguments, "name");
		arguments.$prependWithUnderscore = false;
		return includePartial(argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="includePartial" returntype="string" access="public" output="false">
	<cfargument name="partial" type="any" required="true">
	<cfargument name="group" type="string" required="false" default="">
	<cfargument name="cache" type="any" required="false" default="">
	<cfargument name="layout" type="string" required="false">
	<cfargument name="spacer" type="string" required="false">
	<cfargument name="dataFunction" type="any" required="false">
	<cfargument name="$prependWithUnderscore" type="boolean" required="false" default="true">
	<cfscript>
		var loc = {};
		$args(name="includePartial", args=arguments);
		loc.rv = $includeOrRenderPartial(argumentCollection=$dollarify(arguments, "partial,group,cache,layout,spacer,dataFunction"));
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="contentForLayout" returntype="string" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.rv = includeContent("body");
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="includeContent" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="false" default="body">
	<cfargument name="defaultValue" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		if (StructKeyExists(arguments, "default"))
		{
			arguments.defaultValue = arguments.default;
			StructDelete(arguments, "default");
		}
		if (StructKeyExists(variables.$instance.contentFor, arguments.name))
		{
			loc.rv = ArrayToList(variables.$instance.contentFor[arguments.name], Chr(10));
		}
		else
		{
			loc.rv = arguments.defaultValue;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="cycle" returntype="string" access="public" output="false">
	<cfargument name="values" type="string" required="true">
	<cfargument name="name" type="string" required="false" default="default">
	<cfscript>
		var loc = {};
		if (!StructKeyExists(request.wheels, "cycle"))
		{
			request.wheels.cycle = {};
		}
		if (!StructKeyExists(request.wheels.cycle, arguments.name))
		{
			request.wheels.cycle[arguments.name] = ListGetAt(arguments.values, 1);
		}
		else
		{
			loc.foundAt = ListFindNoCase(arguments.values, request.wheels.cycle[arguments.name]);
			if (loc.foundAt == ListLen(arguments.values))
			{
				loc.foundAt = 0;
			}
			request.wheels.cycle[arguments.name] = ListGetAt(arguments.values, loc.foundAt + 1);
		}
		loc.rv = request.wheels.cycle[arguments.name];
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="resetCycle" returntype="void" access="public" output="false">
	<cfargument name="name" type="string" required="false" default="default">
	<cfscript>
		if (StructKeyExists(request.wheels, "cycle") && StructKeyExists(request.wheels.cycle, arguments.name))
		{
			StructDelete(request.wheels.cycle, arguments.name);
		}
	</cfscript>
</cffunction>

<!--- PRIVATE FUNCTIONS --->

<cffunction name="$tag" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="attributes" type="struct" required="false" default="#StructNew()#">
	<cfargument name="close" type="boolean" required="false" default="false">
	<cfargument name="skip" type="string" required="false" default="">
	<cfargument name="skipStartingWith" type="string" required="false" default="">
	<cfscript>
		var loc = {};

		// start the HTML tag and give it its name
		loc.rv = "<" & arguments.name;

		// if named arguments are passed in we add these to the attributes argument instead so we can handle them all in the same code below
		if (StructCount(arguments) > 5)
		{
			for (loc.key in arguments)
			{
				if (!ListFindNoCase("name,attributes,close,skip,skipStartingWith", loc.key))
				{
					arguments.attributes[loc.key] = arguments[loc.key];
				}
			}
		}

		// add the names of the attributes and their values to the output string with a space in between (class="something" name="somethingelse" etc)
		// since the order of a struct can differ we sort the attributes in alphabetical order before placing them in the HTML tag (we could just place them in random order in the HTML but that would complicate testing for example)
		loc.sortedKeys = ListSort(StructKeyList(arguments.attributes), "textnocase");
		loc.iEnd = ListLen(loc.sortedKeys);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.key = ListGetAt(loc.sortedKeys, loc.i);
			// place the attribute name and value in the string unless it should be skipped according to the arguments or if it's an internal argument (starting with a "$" sign)
			if (!ListFindNoCase(arguments.skip, loc.key) && (!Len(arguments.skipStartingWith) || Left(loc.key, Len(arguments.skipStartingWith)) != arguments.skipStartingWith) && Left(loc.key, 1) != "$")
			{
				loc.rv &= $tagAttribute(loc.key, arguments.attributes[loc.key]);
			}
		}

		// close the tag (usually done on self-closing tags like "img" for example) or just end it (for tags like "div" for example)
		if (arguments.close)
		{
			loc.rv &= " />";
		}
		else
		{
			loc.rv &= ">";
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$tagAttribute" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="value" type="string" required="true">
	<cfscript>
		var loc = {};

		// for custom data attributes we convert underscores / camelCase to hyphens to get around the issue with not being able to use a hyphen in an argument name in CFML
		if (Left(arguments.name, 4) == "data")
		{
			loc.delim = application.wheels.dataAttributeDelimiter;
			if (Len(loc.delim))
			{
				arguments.name = Replace(REReplace(arguments.name, "([a-z])([#loc.delim#])", "\1-\2", "all"), "-#loc.delim#", "-", "all");
			}
		}
		arguments.name = LCase(arguments.name);

		// set standard attribute name / value to use as the default to return (e.g. name / value part of <input name="value">)
		loc.rv = " " & arguments.name & "=""" & arguments.value & """";

		// when attribute can be boolean we handle it accordingly and override the above return value
		if ((!IsBoolean(application.wheels.booleanAttributes) && ListFindNoCase(application.wheels.booleanAttributes, arguments.name)) || (IsBoolean(application.wheels.booleanAttributes) && application.wheels.booleanAttributes))
		{
			if (IsBoolean(arguments.value) || !CompareNoCase(arguments.value, "true") || !CompareNoCase(arguments.value, "false"))
			{
				// value passed in can be handled as a boolean
				if (arguments.value)
				{
					// when value is true we just add the attribute name itself (e.g. <input type="checkbox" checked>)
					loc.rv = " " & arguments.name;
				}
				else
				{
					// when value is false we do not add the attribute at all
					loc.rv = "";
				}
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$element" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="attributes" type="struct" required="false" default="#StructNew()#">
	<cfargument name="content" type="string" required="false" default="">
	<cfargument name="skip" type="string" required="false" default="">
	<cfargument name="skipStartingWith" type="string" required="false" default="">
	<cfscript>
		var rv = "";
		rv = arguments.content;
		StructDelete(arguments, "content");
		rv = $tag(argumentCollection=arguments) & rv & "</" & arguments.name & ">";
	</cfscript>
	<cfreturn rv>
</cffunction>

<cffunction name="$objectName" returntype="any" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="association" type="string" required="false" default="">
	<cfargument name="position" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		loc.currentModelObject = false;
		loc.hasManyAssociationCount = 0;

		// combine our arguments
		$combineArguments(args=arguments, combine="positions,position");
		$combineArguments(args=arguments, combine="associations,association");

		// only try to create the object name if we have a simple value
		if (IsSimpleValue(arguments.objectName) && ListLen(arguments.associations))
		{
			loc.iEnd = ListLen(arguments.associations);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.association = ListGetAt(arguments.associations, loc.i);
				loc.currentModelObject = $getObject(arguments.objectName);
				arguments.objectName &= "['" & loc.association & "']";
				loc.expanded = loc.currentModelObject.$expandedAssociations(include=loc.association);
				loc.expanded = loc.expanded[1];
				if (loc.expanded.type == "hasMany")
				{
					loc.hasManyAssociationCount++;
					if (get("showErrorInformation") && loc.hasManyAssociationCount > ListLen(arguments.positions))
					{
						$throw(type="Wheels.InvalidArgument", message="You passed the hasMany association of `#loc.association#` but did not provide a corresponding position.");
					}
					arguments.objectName &= "[" & ListGetAt(arguments.positions, loc.hasManyAssociationCount) & "]";
				}
			}
		}
	</cfscript>
	<cfreturn arguments.objectName>
</cffunction>

<cffunction name="$tagId" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="valueToAppend" type="string" default="">
	<cfscript>
		var loc = {};
		if (IsSimpleValue(arguments.objectName))
		{
			// form element for object(s)
			loc.rv = ListLast(arguments.objectName, ".");
			if (Find("[", loc.rv))
			{
				loc.rv = $swapArrayPositionsForIds(objectName=loc.rv);
			}
			if (Find("($", arguments.property))
			{
				arguments.property = ReplaceList(arguments.property, "($,)", "-,");
			}
			if (Find("[", arguments.property))
			{
				loc.rv = REReplace(REReplace(loc.rv & arguments.property, "[,\[]", "-", "all"), "[""'\]]", "", "all");
			}
			else
			{
				loc.rv = REReplace(REReplace(loc.rv & "-" & arguments.property, "[,\[]", "-", "all"), "[""'\]]", "", "all");
			}
		}
		else
		{
			loc.rv = ReplaceList(arguments.property, "[,($,],',"",)", "-,-,");
		}
		if (Len(arguments.valueToAppend))
		{
			loc.rv &= "-" & arguments.valueToAppend;
		}
	</cfscript>
	<cfreturn REReplace(loc.rv, "-+", "-", "all")>
</cffunction>

<cffunction name="$tagName" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="string" required="true">
	<cfscript>
		var loc = {};
		if (IsSimpleValue(arguments.objectName))
		{
			loc.rv = ListLast(arguments.objectName, ".");
			if (Find("[", loc.rv))
			{
				loc.rv = $swapArrayPositionsForIds(objectName=loc.rv);
			}
			if (Find("[", arguments.property))
			{
				loc.rv = ReplaceList(loc.rv & arguments.property, "',""", "");
			}
			else
			{
				loc.rv = ReplaceList(loc.rv & "[" & arguments.property & "]", "',""", "");
			}
		}
		else
		{
			loc.rv = arguments.property;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$swapArrayPositionsForIds" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="true" />
	<cfscript>
		var loc = {};
		loc.rv = arguments.objectName;

		// we could have multiple nested arrays so we need to traverse the objectName to find where we have array positions and
		// swap all of the out for object ids
		loc.array = ListToArray(ReplaceList(loc.rv, "],'", ""), "[", true);
		loc.iEnd = ArrayLen(loc.array);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			// if we find a digit, we need to replace it with an id
			if (REFind("\d", loc.array[loc.i]))
			{
				// build our object reference
				loc.objectReference = "";
				loc.jEnd = loc.i;
				for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
				{
					loc.objectReference = ListAppend(loc.objectReference, ListGetAt(arguments.objectName, loc.j, "["), "[");
				}
				loc.rv = ListSetAt(loc.rv, loc.i, $getObject(loc.objectReference).key($returnTickCountWhenNew=true) & "]", "[");
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$addToJavaScriptAttribute" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="content" type="string" required="true">
	<cfargument name="attributes" type="struct" required="true">
	<cfscript>
		var loc = {};
		if (StructKeyExists(arguments.attributes, arguments.name))
		{
			loc.rv = arguments.attributes[arguments.name];
			if (Right(loc.rv, 1) != ";")
			{
				loc.rv &= ";";
			}
			loc.rv &= arguments.content;
		}
		else
		{
			loc.rv = arguments.content;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$getObject" returntype="any" access="public" output="false">
	<cfargument name="objectName" type="string" required="true">
	<cfscript>
		var loc = {};
		try
		{
			if (Find(".", arguments.objectName) || Find("[", arguments.objectName))
			{
				// we can't directly invoke objects in structure or arrays of objects so we must evaluate
				loc.rv = Evaluate(arguments.objectName);
			}
			else
			{
				loc.rv = variables[arguments.objectName];
			}
		}
		catch (any e)
		{
			if (get("showErrorInformation"))
			{
				$throw(type="Wheels.ObjectNotFound", message="CFWheels tried to find the model object `#arguments.objectName#` for the form helper, but it does not exist.");
			}
			else
			{
				$throw(argumentCollection=e);
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>