<!--- PUBLIC VIEW HELPER FUNCTIONS --->

<cffunction name="endFormTag" returntype="string" access="public" output="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="endFormTag", args=arguments);
		if (StructKeyExists(request.wheels, "currentFormMethod"))
		{
			StructDelete(request.wheels, "currentFormMethod");
		}
		loc.rv = arguments.prepend & "</form>" & arguments.append;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="startFormTag" returntype="string" access="public" output="false">
	<cfargument name="method" type="string" required="false">
	<cfargument name="multipart" type="boolean" required="false">
	<cfargument name="spamProtection" type="boolean" required="false">
	<cfargument name="route" type="string" required="false" default="">
	<cfargument name="controller" type="string" required="false" default="">
	<cfargument name="action" type="string" required="false" default="">
	<cfargument name="key" type="any" required="false" default="">
	<cfargument name="params" type="string" required="false" default="">
	<cfargument name="anchor" type="string" required="false" default="">
	<cfargument name="onlyPath" type="boolean" required="false">
	<cfargument name="host" type="string" required="false">
	<cfargument name="protocol" type="string" required="false">
	<cfargument name="port" type="numeric" required="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="startFormTag", args=arguments);

		// sets a flag to indicate whether we use get or post on this form, used when obfuscating params
		request.wheels.currentFormMethod = arguments.method;

		// set the form's action attribute to the URL that we want to send to
		if (!ReFindNoCase("^https?:\/\/", arguments.action))
		{
			arguments.action = URLFor(argumentCollection=arguments);
		}

		// make sure we return XHMTL compliant code
		arguments.action = toXHTML(arguments.action);

		// deletes the action attribute and instead adds some tricky javascript spam protection to the onsubmit attribute
		if (arguments.spamProtection)
		{
			loc.onsubmit = "this.action='#Left(arguments.action, int((Len(arguments.action)/2)))#'+'#Right(arguments.action, ceiling((Len(arguments.action)/2)))#';";
			arguments.onsubmit = $addToJavaScriptAttribute(name="onsubmit", content=loc.onsubmit, attributes=arguments);
			StructDelete(arguments, "action");
		}

		// set the form to be able to handle file uploads
		if (!StructKeyExists(arguments, "enctype") && arguments.multipart)
		{
			arguments.enctype = "multipart/form-data";
		}

		loc.skip = "multipart,spamProtection,route,controller,key,params,anchor,onlyPath,host,protocol,port,prepend,append";

		// variables passed in as route arguments should not be added to the html element
		if (Len(arguments.route))
		{
			loc.skip = ListAppend(loc.skip, $routeVariables(argumentCollection=arguments));
		}

		// need to re-add action here even if it was removed due to being a route variable above
		if (ListFind(loc.skip, "action"))
		{
			loc.skip = ListDeleteAt(loc.skip, ListFind(loc.skip, "action"));
		}

		loc.rv = arguments.prepend & $tag(name="form", skip=loc.skip, attributes=arguments) & arguments.append;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="submitTag" returntype="string" access="public" output="false">
	<cfargument name="value" type="string" required="false">
	<cfargument name="image" type="string" required="false">
	<cfargument name="disable" type="any" required="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="submitTag", reserved="type,src", args=arguments);
		loc.rv = arguments.prepend;
		loc.append = arguments.append;
		if (Len(arguments.disable))
		{
			loc.onclick = "this.disabled=true;";
			if (!Len(arguments.image) && !IsBoolean(arguments.disable))
			{
				loc.onclick &= "this.value='#JSStringFormat(arguments.disable)#';";
			}
			loc.onclick &= "this.form.submit();";
			arguments.onclick = $addToJavaScriptAttribute(name="onclick", content=loc.onclick, attributes=arguments);
		}
		if (Len(arguments.image))
		{
			// create an img tag and then just replace "img" with "input"
			arguments.type = "image";
			arguments.source = arguments.image;
			StructDelete(arguments, "value");
			StructDelete(arguments, "image");
			StructDelete(arguments, "disable");
			StructDelete(arguments, "append");
			StructDelete(arguments, "prepend");
			loc.rv &= imageTag(argumentCollection=arguments);
			loc.rv = Replace(loc.rv, "<img", "<input");
		}
		else
		{
			arguments.type = "submit";
			loc.rv &= $tag(name="input", close=true, skip="image,disable,append,prepend", attributes=arguments);
		}
		loc.rv &= loc.append;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="buttonTag" returntype="string" access="public" output="false">
	<cfargument name="content" type="string" required="false">
	<cfargument name="type" type="string" required="false">
	<cfargument name="value" type="string" required="false">
	<cfargument name="image" type="string" required="false">
	<cfargument name="disable" type="any" required="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="buttonTag", args=arguments);

		// add onclick attribute to disable the form button
		if (Len(arguments.disable))
		{
			loc.onclick = "this.disabled=true;";
			if (!Len(arguments.image) && !IsBoolean(arguments.disable))
			{
				loc.onclick &= "this.value='#JSStringFormat(arguments.disable)#';";
			}
			loc.onclick &= "this.form.submit();";
			arguments.onclick = $addToJavaScriptAttribute(name="onclick", content=loc.onclick, attributes=arguments);
		}

		// if image is specified then use that as the content
		if (Len(arguments.image))
		{
			loc.args = {};
			loc.args.type = "image";
			loc.args.source = arguments.image;
			arguments.content = imageTag(argumentCollection=loc.args);
		}

		// save necessary info from arguments and delete afterwards
		loc.content = arguments.content;
		loc.prepend = arguments.prepend;
		loc.append = arguments.append;
		StructDelete(arguments, "content");
		StructDelete(arguments, "image");
		StructDelete(arguments, "disable");
		StructDelete(arguments, "prepend");
		StructDelete(arguments, "append");

		// create the button
		loc.rv = loc.prepend & $element(name="button", content=loc.content, attributes=arguments) & loc.append;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<!--- PRIVATE FUNCTIONS --->

<cffunction name="$formValue" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="applyHtmlEditFormat" type="boolean" required="false" default="true" />
	<cfscript>
		var loc = {};
		if (IsStruct(arguments.objectName))
		{
			loc.rv = arguments.objectName[arguments.property];
		}
		else
		{
			loc.object = $getObject(arguments.objectName);
			if (get("showErrorInformation") && !IsObject(loc.object))
			{
				$throw(type="Wheels.IncorrectArguments", message="The `#arguments.objectName#` variable is not an object.");
			}
			if (StructKeyExists(loc.object, arguments.property))
			{
				loc.rv = loc.object[arguments.property];
			}
			else
			{
				loc.rv = "";
			}
		}
		if (arguments.applyHtmlEditFormat)
		{
			loc.rv = HTMLEditFormat(loc.rv);
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$maxLength" returntype="any" access="public">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="string" required="true">
	<cfscript>
		var loc = {};
		if (StructKeyExists(arguments, "maxlength"))
		{
			loc.rv = arguments.maxlength;
		}
		else if (!IsStruct(arguments.objectName))
		{
			loc.object = $getObject(arguments.objectName);
			if (IsObject(loc.object))
			{
				loc.propertyInfo = loc.object.$propertyInfo(arguments.property);
				if (StructCount(loc.propertyInfo) && ListFindNoCase("cf_sql_char,cf_sql_varchar", loc.propertyInfo.type))
				{
					loc.rv = loc.propertyInfo.size;
				}
			}
		}
	</cfscript>
	<cfif StructKeyExists(loc, "rv")>
		<cfreturn loc.rv>
	</cfif>
</cffunction>

<cffunction name="$formHasError" returntype="boolean" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = false;
		if (!IsStruct(arguments.objectName))
		{
			loc.object = $getObject(arguments.objectName);
			if (get("showErrorInformation") && !IsObject(loc.object))
			{
				$throw(type="Wheels.IncorrectArguments", message="The `#arguments.objectName#` variable is not an object.");
			}
			if (ArrayLen(loc.object.errorsOn(arguments.property)))
			{
				loc.rv = true;
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$createLabel" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="label" type="string" required="true">
	<cfargument name="prependToLabel" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = arguments.prependToLabel;
		loc.attributes = {};
		for (loc.key in arguments)
		{
			if (CompareNoCase(Left(loc.key, 5), "label") == 0 && Len(loc.key) > 5 && loc.key != "labelPlacement")
			{
				loc.attributes[ReplaceNoCase(loc.key, "label", "")] = arguments[loc.key];
			}
		}
		if (StructKeyExists(arguments, "id"))
		{
			loc.attributes.for = arguments.id;
		}
		loc.rv &= $tag(name="label", attributes=loc.attributes);
		loc.rv &= arguments.label;
		loc.rv &= "</label>";
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$formBeforeElement" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="label" type="any" required="true">
	<cfargument name="labelPlacement" type="string" required="true">
	<cfargument name="prepend" type="string" required="true">
	<cfargument name="append" type="string" required="true">
	<cfargument name="prependToLabel" type="string" required="true">
	<cfargument name="appendToLabel" type="string" required="true">
	<cfargument name="errorElement" type="string" required="true">
	<cfargument name="errorClass" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = "";
		arguments.label = $getFieldLabel(argumentCollection=arguments);
		if ($formHasError(argumentCollection=arguments) && Len(arguments.errorElement))
		{
			// the input has an error and should be wrapped in a tag so we need to start that wrapper tag
			loc.rv &= $tag(name=arguments.errorElement, class=arguments.errorClass);
		}
		if (Len(arguments.label) && arguments.labelPlacement != "after")
		{
			loc.rv &= $createLabel(argumentCollection=arguments);
			if (arguments.labelPlacement == "aroundRight")
			{
				// strip out both the label text and closing label tag since it will be placed after the form input
				loc.rv = Replace(loc.rv, arguments.label & "</label>", "");
			}
			else if (arguments.labelPlacement == "before")
			{
				// since the entire label is created we can append to it
				loc.rv &= arguments.appendToLabel;
			}
			else
			{
				// the label argument is either "around" or "aroundLeft" so we only have to strip out the closing label tag
				loc.rv = Replace(loc.rv, "</label>", "");
			}
		}
		loc.rv &= arguments.prepend;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$formAfterElement" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="label" type="string" required="true">
	<cfargument name="labelPlacement" type="string" required="true">
	<cfargument name="prepend" type="string" required="true">
	<cfargument name="append" type="string" required="true">
	<cfargument name="prependToLabel" type="string" required="true">
	<cfargument name="appendToLabel" type="string" required="true">
	<cfargument name="errorElement" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = arguments.append;
		arguments.label = $getFieldLabel(argumentCollection=arguments);
		if (Len(arguments.label) && arguments.labelPlacement != "before")
		{
			if (arguments.labelPlacement == "after")
			{
				// if the label should be placed after the tag we return the entire label tag
				loc.rv &= $createLabel(argumentCollection=arguments);
			}
			else if (arguments.labelPlacement == "aroundRight")
			{
				// if the text should be placed to the right of the form input we return both the text and the closing tag
				loc.rv &= arguments.label & "</label>";
			}
			else
			{
				// the label argument is either "around" or "aroundLeft" so we only have to return the closing label tag
				loc.rv &= "</label>";
			}
			loc.rv &= arguments.appendToLabel;
		}
		if ($formHasError(argumentCollection=arguments) && Len(arguments.errorElement))
		{
			// the input has an error and is wrapped in a tag so we need to close that wrapper tag
			loc.rv &= "</" & arguments.errorElement & ">";
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$getFieldLabel" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="label" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.object = false;
		if (Compare("false", arguments.label) == 0)
		{
			loc.rv = "";
		}
		else
		{
			if (arguments.label == "useDefaultLabel" && !IsStruct(arguments.objectName))
			{
				loc.object = $getObject(arguments.objectName);
				if (IsObject(loc.object))
				{
					loc.rv = loc.object.$label(arguments.property);
				}
			}
		}
		if (!StructKeyExists(loc, "rv"))
		{
			loc.rv = arguments.label;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>