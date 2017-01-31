<cfscript>
	/*
	* PUBLIC VIEW HELPER FUNCTIONS
	*/

	public string function flashMessages(
		string keys,
		string class,
		boolean includeEmptyContainer,
		boolean lowerCaseDynamicClassValues
	) {
		$args(name="flashMessages", args=arguments, combine="keys/key");
		local.flash = $readFlash();
		local.rv = "";

		// if no keys are requested, populate with everything stored in the Flash and sort them
		if (!StructKeyExists(arguments, "keys"))
		{
			local.flashKeys = StructKeyList(local.flash);
			local.flashKeys = ListSort(local.flashKeys, "textnocase");
		}
		else
		{
			// otherwise, generate list based on what was passed as "arguments.keys"
			local.flashKeys = arguments.keys;
		}

		// generate markup for each Flash item in the list
		local.listItems = "";
		local.iEnd = ListLen(local.flashKeys);
		for (local.i=1; local.i <= local.iEnd; local.i++)
		{
			local.item = ListGetAt(local.flashKeys, local.i);
			local.class = local.item & "Message";
			if (arguments.lowerCaseDynamicClassValues)
			{
				local.class = LCase(local.class);
			}
			local.attributes = {class=local.class};
			if (!StructKeyExists(arguments, "key") || arguments.key == local.item)
			{
				local.content = local.flash[local.item];
				if (IsSimpleValue(local.content))
				{
					local.listItems &= $element(name="p", content=local.content, attributes=local.attributes);
				}
			}
		}

		if (Len(local.listItems) || arguments.includeEmptyContainer)
		{
			local.rv = $element(name="div", skip="key,keys,includeEmptyContainer,lowerCaseDynamicClassValues", content=local.listItems, attributes=arguments);
		}
		return local.rv;
	}

	public void function contentFor(any position="last", any overwrite="false") {
		
		// position in the array for the content
		local.position = "last";

		//should we overwrite or insert into the array
		local.overwrite = "false";

		// extract optional arguments
		if (StructKeyExists(arguments, "position"))
		{
			local.position = arguments.position;
			StructDelete(arguments, "position");
		}
		if (StructKeyExists(arguments, "overwrite"))
		{
			local.overwrite = arguments.overwrite;
			StructDelete(arguments, "overwrite");
		}

		// if no other arguments exists, exit
		if (StructIsEmpty(arguments))
		{
			return;
		}

		// since we're not going to know the name of the section, we have to get it dynamically
		local.section = ListFirst(StructKeyList(arguments));
		local.content = arguments[local.section];

		if (!IsBoolean(local.overwrite))
		{
			local.overwrite = "all";
		}

		if (!StructKeyExists(variables.$instance.contentFor, local.section) || local.overwrite == "all")
		{
			// if the section doesn't exists, or they want to overwrite the whole thing
			variables.$instance.contentFor[local.section] = [];
			ArrayAppend(variables.$instance.contentFor[local.section], local.content);
		}
		else
		{
			local.size = ArrayLen(variables.$instance.contentFor[local.section]);
			// they want to append, prepend or insert at a specific point in the array
			// make sure position is within range
			if (!IsNumeric(local.position) && !ListFindNoCase("first,last", local.position))
			{
				local.position = "last";
			}
			if (IsNumeric(local.position))
			{
				if (local.position <= 1)
				{
					local.position = "first";
				}
				else if (local.position >= local.size)
				{
					local.position = "last";
				}
			}
			if (local.overwrite)
			{
				if (local.position == "last")
				{
					local.position = local.size;
				}
				else if (local.position == "first")
				{
					local.position = 1;
				}
				variables.$instance.contentFor[local.section][local.position] = local.content;
			}
			else
			{
				if (local.position == "last")
				{
					ArrayAppend(variables.$instance.contentFor[local.section], local.content);
				}
				else if (local.position == "first")
				{
					ArrayPrepend(variables.$instance.contentFor[local.section], local.content);
				}
				else
				{
					ArrayInsertAt(variables.$instance.contentFor[local.section], local.position, local.content);
				}
			}
		}
	}

	public string function includeLayout(string name="layout") { 
		arguments.partial = arguments.name;
		StructDelete(arguments, "name");
		arguments.$prependWithUnderscore = false;
		return includePartial(argumentCollection=arguments);
	}

	public string function includePartial(
		required any partial,
		string group="",
		any cache="",
		string layout,
		string spacer,
		any dataFunction,
		boolean $prependWithUnderscore=true
	) {
		$args(name="includePartial", args=arguments);
		return $includeOrRenderPartial(argumentCollection=$dollarify(arguments, "partial,group,cache,layout,spacer,dataFunction"));
	}

	public string function contentForLayout() {
		return includeContent("body");
	}

	public string function includeContent(string name="body", string defaultValue="") {
		if (StructKeyExists(arguments, "default"))
		{
			arguments.defaultValue = arguments.default;
			StructDelete(arguments, "default");
		}
		if (StructKeyExists(variables.$instance.contentFor, arguments.name))
		{
			local.rv = ArrayToList(variables.$instance.contentFor[arguments.name], Chr(10));
		}
		else
		{
			local.rv = arguments.defaultValue;
		}
		return local.rv;
	}

	public string function cycle(required string values, string name="default") {
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
			local.foundAt = ListFindNoCase(arguments.values, request.wheels.cycle[arguments.name]);
			if (local.foundAt == ListLen(arguments.values))
			{
				local.foundAt = 0;
			}
			request.wheels.cycle[arguments.name] = ListGetAt(arguments.values, local.foundAt + 1);
		}
		return request.wheels.cycle[arguments.name];
	}

	public void function resetCycle(string name="default") {
		if (StructKeyExists(request.wheels, "cycle") && StructKeyExists(request.wheels.cycle, arguments.name))
		{
			StructDelete(request.wheels.cycle, arguments.name);
		}
	}

	/*
	* PRIVATE FUNCTIONS
	*/

	public string function $tag(
		required string name, 
		struct attributes={}, 
		boolean close=false,
		string skip="",
		string skipStartingWith=""
	) {
		// start the HTML tag and give it its name
		local.rv = "<" & arguments.name;

		// if named arguments are passed in we add these to the attributes argument instead so we can handle them all in the same code below
		if (StructCount(arguments) > 5)
		{
			for (local.key in arguments)
			{
				if (!ListFindNoCase("name,attributes,close,skip,skipStartingWith", local.key))
				{
					arguments.attributes[local.key] = arguments[local.key];
				}
			}
		}

		// add the names of the attributes and their values to the output string with a space in between (class="something" name="somethingelse" etc)
		// since the order of a struct can differ we sort the attributes in alphabetical order before placing them in the HTML tag (we could just place them in random order in the HTML but that would complicate testing for example)
		local.sortedKeys = ListSort(StructKeyList(arguments.attributes), "textnocase");
		local.iEnd = ListLen(local.sortedKeys);
		for (local.i=1; local.i <= local.iEnd; local.i++)
		{
			local.key = ListGetAt(local.sortedKeys, local.i);
			// place the attribute name and value in the string unless it should be skipped according to the arguments or if it's an internal argument (starting with a "$" sign)
			if (!ListFindNoCase(arguments.skip, local.key) && (!Len(arguments.skipStartingWith) || Left(local.key, Len(arguments.skipStartingWith)) != arguments.skipStartingWith) && Left(local.key, 1) != "$")
			{
				local.rv &= $tagAttribute(local.key, arguments.attributes[local.key]);
			}
		}

		// close the tag (usually done on self-closing tags like "img" for example) or just end it (for tags like "div" for example)
		if (arguments.close)
		{
			local.rv &= " />";
		}
		else
		{
			local.rv &= ">";
		}
		return local.rv;
	}

	public string function $tagAttribute(required string name, required string value) {
		// for custom data attributes we convert underscores / camelCase to hyphens to get around the issue with not being able to use a hyphen in an argument name in CFML
		if (Left(arguments.name, 4) == "data")
		{
			local.delim = application.wheels.dataAttributeDelimiter;
			if (Len(local.delim))
			{
				arguments.name = Replace(REReplace(arguments.name, "([a-z])([#local.delim#])", "\1-\2", "all"), "-#local.delim#", "-", "all");
			}
		}
		arguments.name = LCase(arguments.name);

		// set standard attribute name / value to use as the default to return (e.g. name / value part of <input name="value">)
		local.rv = " " & arguments.name & "=""" & arguments.value & """";

		// when attribute can be boolean we handle it accordingly and override the above return value
		if ((!IsBoolean(application.wheels.booleanAttributes) && ListFindNoCase(application.wheels.booleanAttributes, arguments.name)) || (IsBoolean(application.wheels.booleanAttributes) && application.wheels.booleanAttributes))
		{
			if (IsBoolean(arguments.value) || !CompareNoCase(arguments.value, "true") || !CompareNoCase(arguments.value, "false"))
			{
				// value passed in can be handled as a boolean
				if (arguments.value)
				{
					// when value is true we just add the attribute name itself (e.g. <input type="checkbox" checked>)
					local.rv = " " & arguments.name;
				}
				else
				{
					// when value is false we do not add the attribute at all
					local.rv = "";
				}
			}
		}
		return local.rv;
	}

	public string function $element(
		required string name, 
		struct attributes={}, 
		string content="",
		string skip="",
		string skipStartingWith=""
	) {
		local.rv = arguments.content;
		StructDelete(arguments, "content");
		return $tag(argumentCollection=arguments) & local.rv & "</" & arguments.name & ">";
	}

	public any function $objectName(
		required any objectName,
		string association="",
		string position=""
	) {
		local.currentModelObject = false;
		local.hasManyAssociationCount = 0;

		// combine our arguments
		$combineArguments(args=arguments, combine="positions,position");
		$combineArguments(args=arguments, combine="associations,association");

		if (IsObject(arguments.objectName))
		{
			$throw(type="Wheels.InvalidArgument", message="The `objectName` argument passed is not of type string.");
		}

		// only try to create the object name if we have a simple value
		if (IsSimpleValue(arguments.objectName) && ListLen(arguments.associations))
		{
			local.iEnd = ListLen(arguments.associations);
			for (local.i=1; local.i <= local.iEnd; local.i++)
			{
				local.association = ListGetAt(arguments.associations, local.i);
				local.currentModelObject = $getObject(arguments.objectName);
				arguments.objectName &= "['" & local.association & "']";
				local.expanded = local.currentModelObject.$expandedAssociations(include=local.association);
				local.expanded = local.expanded[1];
				if (local.expanded.type == "hasMany")
				{
					local.hasManyAssociationCount++;
					if (get("showErrorInformation") && local.hasManyAssociationCount > ListLen(arguments.positions))
					{
						$throw(type="Wheels.InvalidArgument", message="You passed the hasMany association of `#local.association#` but did not provide a corresponding position.");
					}
					arguments.objectName &= "[" & ListGetAt(arguments.positions, local.hasManyAssociationCount) & "]";
				}
			}
		}
		return arguments.objectName;
	}

	public string function $tagId(
		required any objectName,
		required string property,
		string valueToAppend=""
	) {
		if (IsSimpleValue(arguments.objectName))
		{
			// form element for object(s)
			local.rv = ListLast(arguments.objectName, ".");
			if (Find("[", local.rv))
			{
				local.rv = $swapArrayPositionsForIds(objectName=local.rv);
			}
			if (Find("($", arguments.property))
			{
				arguments.property = ReplaceList(arguments.property, "($,)", "-,");
			}
			if (Find("[", arguments.property))
			{
				local.rv = REReplace(REReplace(local.rv & arguments.property, "[,\[]", "-", "all"), "[""'\]]", "", "all");
			}
			else
			{
				local.rv = REReplace(REReplace(local.rv & "-" & arguments.property, "[,\[]", "-", "all"), "[""'\]]", "", "all");
			}
		}
		else
		{
			local.rv = ReplaceList(arguments.property, "[,($,],',"",)", "-,-,");
		}
		if (Len(arguments.valueToAppend))
		{
			local.rv &= "-" & arguments.valueToAppend;
		}
		return REReplace(local.rv, "-+", "-", "all");
	}

	public string function $tagName(required any objectName, required string property) {
		if (IsSimpleValue(arguments.objectName))
		{
			local.rv = ListLast(arguments.objectName, ".");
			if (Find("[", local.rv))
			{
				local.rv = $swapArrayPositionsForIds(objectName=local.rv);
			}
			if (Find("[", arguments.property))
			{
				local.rv = ReplaceList(local.rv & arguments.property, "',""", "");
			}
			else
			{
				local.rv = ReplaceList(local.rv & "[" & arguments.property & "]", "',""", "");
			}
		}
		else
		{
			local.rv = arguments.property;
		}
		return local.rv;
	}

	public string function $swapArrayPositionsForIds(required any objectName) {
		local.rv = arguments.objectName;

		// we could have multiple nested arrays so we need to traverse the objectName to find where we have array positions and
		// swap all of the out for object ids
		local.array = ListToArray(ReplaceList(local.rv, "],'", ""), "[", true);
		local.iEnd = ArrayLen(local.array);
		for (local.i=1; local.i <= local.iEnd; local.i++)
		{
			// if we find a digit, we need to replace it with an id
			if (REFind("\d", local.array[local.i]))
			{
				// build our object reference
				local.objectReference = "";
				local.jEnd = local.i;
				for (local.j=1; local.j <= local.jEnd; local.j++)
				{
					local.objectReference = ListAppend(local.objectReference, ListGetAt(arguments.objectName, local.j, "["), "[");
				}
				local.rv = ListSetAt(local.rv, local.i, $getObject(local.objectReference).key($returnTickCountWhenNew=true) & "]", "[");
			}
		}
		return local.rv;
	}

	public string function $addToJavaScriptAttribute(
		required string name,
		required string content,
		required struct attributes
	) {
		if (StructKeyExists(arguments.attributes, arguments.name))
		{
			local.rv = arguments.attributes[arguments.name];
			if (Right(local.rv, 1) != ";")
			{
				local.rv &= ";";
			}
			local.rv &= arguments.content;
		}
		else
		{
			local.rv = arguments.content;
		}
		return local.rv;
	}

	public any function $getObject(required string objectname) {
		try
		{
			if (Find(".", arguments.objectName) || Find("[", arguments.objectName))
			{
				// we can't directly invoke objects in structure or arrays of objects so we must evaluate
				local.rv = Evaluate(arguments.objectName);
			}
			else
			{
				local.rv = variables[arguments.objectName];
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
		return local.rv;
	}

	public struct function $innerArgs(required string name, required struct args) {
		local.rv = {};
		local.element = arguments.name;
		for (local.key in arguments.args)
		{
			if (Left(local.key, Len(local.element)) == local.element)
			{
				local.name = LCase(Mid(local.key, Len(local.element)+1, 1)) & Right(local.key, Len(local.key)-Len(local.element)-1);
				local.rv[local.name] = arguments.args[local.key];
				StructDelete(arguments.args, local.key);
			}
		}
		return local.rv;
	}
</cfscript>  