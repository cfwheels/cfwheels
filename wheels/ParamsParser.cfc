<cfcomponent output="false">
	
	<cfinclude template="global/cfml.cfm">
	
	<cffunction name="init">
		<cfreturn this>
	</cffunction>

	<cffunction name="create" returntype="struct" access="public" output="false">
		<cfargument name="path" type="string" required="true">
		<cfargument name="route" type="struct" required="true">
		<cfargument name="formScope" type="struct" required="true">
		<cfargument name="urlScope" type="struct" required="true">
		<cfscript>
			var loc = {};
			loc.params = mergeScopes(argumentCollection=arguments);
			$routeVariables(params=loc.params, pattern=arguments.route.pattern ,path=arguments.path);			
			$decryptParams(loc.params);
			$formCheckBoxes(loc.params);
			$formDates(loc.params);
			// add form variables to the params struct
			$createNestedParamStruct(params=loc.params);
			// find any new structs and convert them
			$createNewArrayStruct(params=loc.params);
			$cleanUp(params=loc.params, route=arguments.route);
		</cfscript>
		<cfreturn loc.params>
	</cffunction>

	<cffunction name="mergeScopes" returntype="struct" access="public" output="false">
		<cfargument name="formScope" type="struct" required="true">
		<cfargument name="urlScope" type="struct" required="true">
		<cfargument name="parameters" type="struct" required="false" default="#Duplicate(GetPageContext().getRequest().getParameterMap())#">
		<cfargument name="multipart" type="any" required="false" default="#form.getPartsArray()#">
		<cfscript>
		var loc = {};

		// merge our coldfusion scopes together
		loc.original = Duplicate(arguments.formScope);
		StructDelete(loc.original, "fieldnames", false);
		StructAppend(loc.original, arguments.urlScope, true);

		// if the form or url scopes were set after the request started,
		// we need to make sure that they are in arrays
		loc.parameters = {};
		for (loc.item in loc.original)
		{
			loc.parameters[loc.item] = [loc.original[loc.item]];
		}

		// get our values from the parameter map
		// this will always contain url variables 
		// and will contain form parameters when not a multipart form
		for (loc.item in arguments.parameters)
		{
			loc.parameters[loc.item] = [];
			loc.iEnd = ArrayLen(arguments.parameters[loc.item]);
			for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
			{
				loc.parameters[loc.item][loc.i] = arguments.parameters[loc.item][loc.i];
			}
		}

		// if the multipart is defined (not null)
		// then we have a multipart form and will be getting our form values from here
		if (StructKeyExists(arguments, "multipart"))
		{
			loc.multipart = {};

			// build our multipart struct
			loc.iEnd = ArrayLen(arguments.multipart);
			for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
			{
				loc.param = arguments.multipart[loc.i];
				if (loc.param.isParam())
				{
					if (!StructKeyExists(loc.multipart, loc.param.getName()))
					{
						loc.multipart[loc.param.getName()] = [];
					}
					ArrayAppend(loc.multipart[loc.param.getName()], loc.param.getStringValue());
				}
			}
			
			// now overwrite our parameters with the multipart values
			StructAppend(loc.parameters, loc.multipart, true);
		}

		// overwrite any parameters in our map with the right values from the url
		for (loc.item in arguments.urlScope)
		{
			loc.parameters[loc.item] = [arguments.urlScope[loc.item]];
		}
		</cfscript>
		<cfreturn loc.parameters />
	</cffunction>
	
	<cffunction name="$decryptParams" access="public" returntype="struct" output="false">
		<cfargument name="params" type="struct" required="true">
		<cfscript>
		// decrypts all values except controller and action
		if (!application.wheels.obfuscateUrls)
		{
			return arguments.params;
		}

		for (loc.key in arguments.params)
		{
			if (loc.key != "controller" && loc.key != "action")
			{
				loc.iEnd = ArrayLen(arguments.params[loc.key]);
				for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
				{
					try
					{
						arguments.params[loc.key][loc.i] = deobfuscateParam(arguments.params[loc.key][loc.i]);
					}
					catch(Any e) 
					{}
				}
			}
		}
		</cfscript>
		<cfreturn arguments.params>
	</cffunction>
	
	<cffunction name="$routeVariables" access="public" returntype="struct" output="false">
		<cfargument name="params" type="struct" required="true">
		<cfargument name="pattern" type="string" required="true">
		<cfargument name="path" type="string" required="true">
		<cfscript>
		var loc = {};
		// go through the matching route pattern and add URL variables from the route to the struct
		loc.iEnd = ListLen(arguments.pattern, "/");
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(arguments.pattern, loc.i, "/");
			if (Left(loc.item, 1) == "[")
			{
				loc.key = ReplaceList(loc.item, "[,]", "");
				arguments.params[loc.key] = [];
				arguments.params[loc.key][1] = ListGetAt(arguments.path, loc.i, "/");
			}
		}
		</cfscript>
		<cfreturn arguments.params>
	</cffunction>

	<cffunction name="$cleanUp" access="public" returntype="struct" output="false">
		<cfargument name="params" type="struct" required="true">
		<cfargument name="route" type="struct" required="true">
		<cfscript>
			// add controller and action unless they already exist
			if (!StructKeyExists(arguments.params, "controller"))
				arguments.params.controller = arguments.route.controller;
			if (!StructKeyExists(arguments.params, "action"))
				arguments.params.action = arguments.route.action;
	
			// convert controller to upperCamelCase and action to normal camelCase
			arguments.params.controller = REReplace(arguments.params.controller, "-([a-z])", "\u\1", "all");
			arguments.params.action = REReplace(arguments.params.action, "-([a-z])", "\u\1", "all");
	
			// add name of route to params if a named route is running
			if (StructKeyExists(arguments.route, "name") && Len(arguments.route.name) && !StructKeyExists(arguments.params, "route"))
				arguments.params.route = arguments.route.name;
		</cfscript>
		<cfreturn arguments.params>
	</cffunction>

	<cffunction name="$createNestedParamStruct" returntype="struct" access="public" output="false">
		<cfargument name="params" type="struct" required="true" />
		<cfscript>
			var loc = {};
			for (loc.key in arguments.params)
			{
				if (Find("[", loc.key) && Right(loc.key, 1) == "]")
				{
					// object form field
					loc.name = SpanExcluding(loc.key, "[");
					// we split the key into an array so the developer can have multiple levels of params passed in
					loc.nested = ListToArray(ReplaceList(loc.key, loc.name & "[,]", ""), "[", true); 
					if (!StructKeyExists(arguments.params, loc.name))
						arguments.params[loc.name] = {};
					loc.struct = arguments.params[loc.name]; // we need a reference to the struct so we can nest other structs if needed
					loc.iEnd = ArrayLen(loc.nested);
					for (loc.i = 1; loc.i lte loc.iEnd; loc.i++) // looping over the array allows for infinite nesting
					{
						loc.item = loc.nested[loc.i];
						if (!Len(loc.item)) // if we have an empty struct item it means that the developer is passing in new items
							loc.item = "new";
						if (!StructKeyExists(loc.struct, loc.item))
							loc.struct[loc.item] = {};
						if (loc.i != loc.iEnd)
							loc.struct = loc.struct[loc.item]; // pass the new reference (structs pass a reference instead of a copy) to the next iteration
						else if (IsArray(arguments.params[loc.key]) && ArrayLen(arguments.params[loc.key]) == 1)
							loc.struct[loc.item] = arguments.params[loc.key][1];
						else if (IsArray(arguments.params[loc.key]))
							loc.struct[loc.item] = $arrayToStruct(arguments.params[loc.key]);
						else
							loc.struct[loc.item] = arguments.params[loc.key];
					}
					// delete the original key so it doesn't show up in the params
					StructDelete(arguments.params, loc.key, false);
				}
				else if (IsArray(arguments.params[loc.key]) && ArrayLen(arguments.params[loc.key]) == 1)
					arguments.params[loc.key] = arguments.params[loc.key][1];
			}	
		</cfscript>
		<cfreturn arguments.params />
	</cffunction>
	
	<cffunction name="$formCheckBoxes" access="public" returntype="struct" output="false">
		<cfargument name="params" type="struct" required="true">
		<cfscript>
		var loc = {};
		for (loc.key in arguments.params)
		{
			if (FindNoCase("($checkbox)", loc.key))
			{
				// if no other form parameter exists with this name
				// it means that the checkbox was left blank and therefore
				// we force the value to the unchecked values for the checkbox
				// (to get around the problem that unchecked checkboxes don't post at all)
				loc.formParamName = ReplaceNoCase(loc.key, "($checkbox)", "");
				if (!StructKeyExists(arguments.params, loc.formParamName))
				{
					arguments.params[loc.formParamName] = [];
					loc.iEnd = ArrayLen(arguments.params[loc.key]);
					for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
						arguments.params[loc.formParamName][loc.i] = arguments.params[loc.key][loc.i];
				}
				StructDelete(arguments.params, loc.key);
			}
		}
		</cfscript>
		<cfreturn arguments.params>
	</cffunction>
	
	<cffunction name="$formDates" access="public" returntype="struct" output="false">
		<cfargument name="params" type="struct" required="true">
		<cfscript>
		var loc = {};
		loc.dates = {};
		for (loc.key in arguments.params)
		{
			if (REFindNoCase(".*\((\$year|\$month|\$day|\$hour|\$minute|\$second)\)$", loc.key))
			{
				loc.temp = ListToArray(loc.key, "(");
				loc.firstKey = loc.temp[1];
				loc.secondKey = SpanExcluding(loc.temp[2], ")");
				
				loc.iEnd = ArrayLen(arguments.params[loc.key]);
				for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
				{
					if (!StructKeyExists(loc.dates, loc.firstKey))
						loc.dates[loc.firstKey] = [];
					loc.dates[loc.firstKey][loc.i][ReplaceNoCase(loc.secondKey, "$", "")] = arguments.params[loc.key][loc.i];
				}
			}
		}
		for (loc.key in loc.dates)
		{
			loc.iEnd = ArrayLen(loc.dates[loc.key]);
			for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
			{
				if (!StructKeyExists(loc.dates[loc.key][loc.i], "year"))
					loc.dates[loc.key][loc.i].year = 1899;
				if (!StructKeyExists(loc.dates[loc.key][loc.i], "month"))
					loc.dates[loc.key][loc.i].month = 1;
				if (!StructKeyExists(loc.dates[loc.key][loc.i], "day"))
					loc.dates[loc.key][loc.i].day = 1;
				if (!StructKeyExists(loc.dates[loc.key][loc.i], "hour"))
					loc.dates[loc.key][loc.i].hour = 0;
				if (!StructKeyExists(loc.dates[loc.key][loc.i], "minute"))
					loc.dates[loc.key][loc.i].minute = 0;
				if (!StructKeyExists(loc.dates[loc.key][loc.i], "second"))
					loc.dates[loc.key][loc.i].second = 0;
				if (!StructKeyExists(arguments.params, loc.key) || !IsArray(arguments.params[loc.key]))
					arguments.params[loc.key] = [];
				try
				{
					arguments.params[loc.key][loc.i] = CreateDateTime(loc.dates[loc.key][loc.i].year, loc.dates[loc.key][loc.i].month, loc.dates[loc.key][loc.i].day, loc.dates[loc.key][loc.i].hour, loc.dates[loc.key][loc.i].minute, loc.dates[loc.key][loc.i].second);
				}
				catch(Any e)
				{
					arguments.params[loc.key][loc.i] = "";
				}
			}
			StructDelete(arguments.params, "#loc.key#($year)", false);
			StructDelete(arguments.params, "#loc.key#($month)", false);
			StructDelete(arguments.params, "#loc.key#($day)", false);
			StructDelete(arguments.params, "#loc.key#($hour)", false);
			StructDelete(arguments.params, "#loc.key#($minute)", false);
			StructDelete(arguments.params, "#loc.key#($second)", false);
		}
		</cfscript>
		<cfreturn arguments.params>
	</cffunction>

	<cffunction name="$createNewArrayStruct" returntype="void" access="public" output="false">
		<cfargument name="params" type="struct" required="true" />
		<cfscript>
			var loc = {};
			
			loc.newStructArray = StructFindKey(arguments.params, "new", "all");
			loc.iEnd = ArrayLen(loc.newStructArray);
			
			for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
			{
				loc.owner = loc.newStructArray[loc.i].owner.new;
				loc.value = loc.newStructArray[loc.i].value;
				loc.map = {};
				$mapStruct(map=loc.map, struct=loc.value);
				
				StructClear(loc.value); // clear the struct now that we have our paths and values
				
				for (loc.item in loc.map) // remap our new struct
				{
					// move the last element to the first
					loc.newPos = loc.item;
					loc.last = Replace(ListLast(loc.newPos, "["), "]", "");
					if (IsNumeric(loc.last))
					{
						loc.newPos = ListDeleteAt(loc.newPos, ListLen(loc.newPos, "["), "[");
						loc.newPos = ListPrepend(loc.newPos, "[" & loc.last, "]");
					}
					else
					{
						loc.newPos = ListPrepend(loc.newPos, "[1", "]");
					}
					loc.map[loc.item].newPos = ListToArray(Replace(loc.newPos, "]", "", "all"), "[", false);
					
					// loop through the position array and build our new struct
					loc.struct = loc.value;
					loc.jEnd = ArrayLen(loc.map[loc.item].newPos);
					for (loc.j = 1; loc.j lte loc.jEnd; loc.j++)
					{
						if (!StructKeyExists(loc.struct, loc.map[loc.item].newPos[loc.j]))
							loc.struct[loc.map[loc.item].newPos[loc.j]] = {};
						if (loc.j != loc.jEnd)
							loc.struct = loc.struct[loc.map[loc.item].newPos[loc.j]];
						else
							loc.struct[loc.map[loc.item].newPos[loc.j]] = loc.map[loc.item].value;
					}
				}
			}
		</cfscript>
	</cffunction>
	
	<!--- helper method to recursively map a structure to build mapping paths and retrieve its values so you can have your way with a deeply nested structure --->
	<cffunction name="$mapStruct" returntype="void" access="public" output="false" mixin="dispatch">
		<cfargument name="map" type="struct" required="true" />
		<cfargument name="struct" type="struct" required="true" />
		<cfargument name="path" type="string" required="false" default="" />
		<cfscript>
			var loc = {};
			for (loc.item in arguments.struct) 
			{
				if (IsStruct(arguments.struct[loc.item])) // go further down the rabit hole
				{
					$mapStruct(map=arguments.map, struct=arguments.struct[loc.item], path="#arguments.path#[#loc.item#]");
				}
				else // map our position and value
				{
					arguments.map["#arguments.path#[#loc.item#]"] = {};
					arguments.map["#arguments.path#[#loc.item#]"].value = arguments.struct[loc.item];
				}
			}
		</cfscript>
	</cffunction>
	
	<!--- convert an array to a structure --->
	<cffunction name="$arrayToStruct" returntype="struct" access="public" output="false">
		<cfargument name="array" type="array" required="true" />
		<cfscript>
			var loc = {};
			loc.struct = {};
			loc.iEnd = ArrayLen(arguments.array);
			for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
				loc.struct[loc.i] = arguments.array[loc.i];
		</cfscript>
		<cfreturn loc.struct />
	</cffunction>

</cfcomponent>