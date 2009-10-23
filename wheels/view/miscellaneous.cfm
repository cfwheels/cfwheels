<cffunction name="cycle" returntype="string" access="public" output="false" hint="Cycles through list values every time it is called.">
	<cfargument name="values" type="string" required="true" hint="List of values to cycle through">
	<cfargument name="name" type="string" required="false" default="default" hint="Name to give the cycle, useful when you use multiple cycles on a page">
	<cfscript>
		var loc = {};
		if (!StructKeyExists(request.wheels, "cycle"))
			request.wheels.cycle = {};
		if (!StructKeyExists(request.wheels.cycle, arguments.name))
		{
			request.wheels.cycle[arguments.name] = ListGetAt(arguments.values, 1);
		}
		else
		{
			loc.foundAt = ListFindNoCase(arguments.values, request.wheels.cycle[arguments.name]);
			if (loc.foundAt == ListLen(arguments.values))
				loc.foundAt = 0;
			request.wheels.cycle[arguments.name] = ListGetAt(arguments.values, loc.foundAt + 1);
		}
		loc.returnValue = request.wheels.cycle[arguments.name]; 
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="resetCycle" returntype="void" access="public" output="false" hint="Resets a cycle so that it starts from the first list value the next time it is called.">
	<cfargument name="name" type="string" required="false" default="default" hint="The name of the cycle to reset">
	<cfscript>
		if (StructKeyExists(request.wheels, "cycle") && StructKeyExists(request.wheels.cycle, arguments.name))
			StructDelete(request.wheels.cycle, arguments.name);
	</cfscript>
</cffunction>

<cffunction name="$tag" returntype="string" access="public" output="false" hint="Creates a HTML tag with attributes.">
	<cfargument name="name" type="string" required="true" hint="The name of the HTML tag.">
	<cfargument name="attributes" type="struct" required="false" default="#StructNew()#" hint="The attributes and their values">
	<cfargument name="close" type="boolean" required="false" default="false" hint="Whether or not to close the tag (self-close) or just end it with a bracket.">
	<cfargument name="skip" type="string" required="false" default="" hint="List of attributes that should not be placed in the HTML tag.">
	<cfargument name="skipStartingWith" type="string" required="false" default="" hint="If you want to skip attributes that start with a specific string you can specify it here.">
	<cfscript>
		var loc = {};
		
		// start the HTML tag and give it its name
		loc.returnValue = "<" & arguments.name;
		
		// if named arguments are passed in we add these to the attributes argument instead so we can handle them all in the same code below
		if (StructCount(arguments) > 5)
		{
			for (loc.key in arguments)
			{
				if (!ListFindNoCase("name,attributes,close,skip,skipStartingWith", loc.key))
					arguments.attributes[loc.key] = arguments[loc.key];	
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
				loc.returnValue = loc.returnValue & " " & LCase(loc.key) & "=""" & arguments.attributes[loc.key] & """";	
		}

		// close the tag (usually done on self-closing tags like "img" for example) or just end it (for tags like "div" for example)
		if (arguments.close)
			loc.returnValue = loc.returnValue & " />";
		else
			loc.returnValue = loc.returnValue & ">";		
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$element" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="attributes" type="struct" required="false" default="#StructNew()#">
	<cfargument name="content" type="string" required="false" default="">
	<cfargument name="skip" type="string" required="false" default="">
	<cfargument name="skipStartingWith" type="string" required="false" default="">
	<cfscript>
		var returnValue = "";
		returnValue = arguments.content;
		StructDelete(arguments, "content");
		returnValue = $tag(argumentCollection=arguments) & returnValue & "</" & arguments.name & ">";
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="$tagId" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="string" required="true">
	<cfscript>
		var loc = {};
		if (IsSimpleValue(arguments.objectName))
		{
			// form element for object(s)
			loc.returnValue = ListLast(arguments.objectName, ".");
			if (Find("[", loc.returnValue))
			{
				// this is a form element for an array of objects so we replace the array position with the primary key value of the object (unless the object is new and has no primary key set)
				loc.key = Evaluate(arguments.objectName).key();
				if (Len(loc.key))
					loc.returnValue = ListFirst(loc.returnValue, "[") & "-" & Evaluate(arguments.objectName).key();
				else
					loc.returnValue = ReplaceList(loc.returnValue, "[,]", "-,");
			}
			loc.returnValue = loc.returnValue & "-" & arguments.property;
		}
		else
		{
			// this is a non object form element
			loc.returnValue = ReplaceList(arguments.property, "[,]", "-,");
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$tagName" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="string" required="true">
	<cfscript>
		var loc = {};
		if (IsSimpleValue(arguments.objectName))
		{
			loc.returnValue = ListLast(arguments.objectName, ".");
			if (Find("[", loc.returnValue))
			{
				loc.key = Evaluate(arguments.objectName).key();
				if (Len(loc.key))
					loc.returnValue = ListFirst(loc.returnValue, "[") & "[" & loc.key & "]";
			}
			loc.returnValue = loc.returnValue & "[" & arguments.property & "]";
		}
		else
		{
			loc.returnValue = arguments.property;
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$addToJavaScriptAttribute" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="content" type="string" required="true">
	<cfargument name="attributes" type="struct" required="true">
	<cfscript>
		var loc = {};
		if (StructKeyExists(arguments.attributes, arguments.name))
		{
			loc.returnValue = arguments.attributes[arguments.name];
			if (Right(loc.returnValue, 1) != ";")
				loc.returnValue = loc.returnValue & ";";
			loc.returnValue = loc.returnValue & arguments.content;
		}
		else
		{
			loc.returnValue = arguments.content;
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>