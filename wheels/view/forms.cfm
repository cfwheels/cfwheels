<cfscript>
	/**
	* PUBLIC VIEW HELPER FUNCTIONS
	*/

	public string function endFormTag(string prepend, string append) {
		$args(name="endFormTag", args=arguments);
		if (StructKeyExists(request.wheels, "currentFormMethod"))
		{
			StructDelete(request.wheels, "currentFormMethod");
		}
		local.rv = arguments.prepend & "</form>" & arguments.append;
		return local.rv;
	}

	public string function startFormTag(
		string method,
		boolean multipart,
		string route="",
		string controller="",
		string action="",
		any key="",
		string params="",
		string anchor="",
		boolean onlyPath,
		string host,
		string protocol,
		numeric port,
		string prepend,
		string append
	) {
		$args(name="startFormTag", args=arguments);

		local.routeAndMethodMatch = false;

		// sets a flag to indicate whether we use get or post on this form, used when obfuscating params
		request.wheels.currentFormMethod = arguments.method;

		// if we have a route and method, tap
		if (len(arguments.route) && structKeyExists(arguments, "method")) {

			// throw a nice wheels error if the developer passes in a route that was not generated
			if (application.wheels.showErrorInformation
					&& !StructKeyExists(application.wheels.namedRoutePositions, arguments.route))
				$throw(
						type="Wheels.RouteNotFound"
					, message="Route Not Found"
					, extendedInfo="The route specified `#arguments.route#` does not exist!"
				);

			// check to see if the route specified has a method to match the one passed in
			for (local.position in ListToArray(application.wheels.namedRoutePositions[arguments.route]))
				if (StructKeyExists(application.wheels.routes[local.position], "methods")
						&& ListFindNoCase(application.wheels.routes[local.position].methods, arguments.method))
					local.routeAndMethodMatch = true;

			if (local.routeAndMethodMatch) {

				// save the method passed in
				local.method = arguments.method;

				if (arguments.method != "get")
					arguments.method = "post";
			}
		}

		// set the form's action attribute to the URL that we want to send to
		if (!ReFindNoCase("^https?:\/\/", arguments.action))
		{
			arguments.action = URLFor(argumentCollection=arguments);
		}

		// make sure we return XHMTL compliant code
		arguments.action = toXHTML(arguments.action);

		// set the form to be able to handle file uploads
		if (!StructKeyExists(arguments, "enctype") && arguments.multipart)
		{
			arguments.enctype = "multipart/form-data";
		}

		local.skip = "multipart,spamProtection,route,controller,key,params,anchor,onlyPath,host,protocol,port,prepend,append";

		// variables passed in as route arguments should not be added to the html element
		if (Len(arguments.route))
		{
			local.skip = ListAppend(local.skip, $routeVariables(argumentCollection=arguments));
		}

		// need to re-add action here even if it was removed due to being a route variable above
		if (ListFind(local.skip, "action"))
		{
			local.skip = ListDeleteAt(local.skip, ListFind(local.skip, "action"));
		}

		local.rv = arguments.prepend & $tag(name="form", skip=local.skip, attributes=arguments) & arguments.append;

		if (ListFindNoCase("post,put,patch,delete", arguments.method))
			local.rv &= authenticityTokenField();

		if (structKeyExists(local, "method") && local.method != "get")
			local.rv &= hiddenFieldTag(name="_method", value=local.method);

		return local.rv;
	}

	public string function submitTag(
		string value,
		string image,
		any disable,
		string prepend,
		string append
	) {
		$args(name="submitTag", reserved="type,src", args=arguments);
		local.rv = arguments.prepend;
		local.append = arguments.append;
		if (Len(arguments.disable))
		{
			local.onclick = "this.disabled=true;";
			if (!Len(arguments.image) && !IsBoolean(arguments.disable))
			{
				local.onclick &= "this.value='#JSStringFormat(arguments.disable)#';";
			}
			local.onclick &= "this.form.submit();";
			arguments.onclick = $addToJavaScriptAttribute(name="onclick", content=local.onclick, attributes=arguments);
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
			local.rv &= imageTag(argumentCollection=arguments);
			local.rv = Replace(local.rv, "<img", "<input");
		}
		else
		{
			arguments.type = "submit";
			local.rv &= $tag(name="input", close=true, skip="image,disable,append,prepend", attributes=arguments);
		}
		local.rv &= local.append;
		return local.rv;
	}

	public string function buttonTag(
		string content,
		string type,
		string value,
		string image,
		any disable,
		string prepend,
		string append
	) {
		$args(name="buttonTag", args=arguments);

		// add onclick attribute to disable the form button
		if (Len(arguments.disable))
		{
			local.onclick = "this.disabled=true;";
			if (!Len(arguments.image) && !IsBoolean(arguments.disable))
			{
				local.onclick &= "this.value='#JSStringFormat(arguments.disable)#';";
			}
			local.onclick &= "this.form.submit();";
			arguments.onclick = $addToJavaScriptAttribute(name="onclick", content=local.onclick, attributes=arguments);
		}

		// if image is specified then use that as the content
		if (Len(arguments.image))
		{
			local.args = {};
			local.args.type = "image";
			local.args.source = arguments.image;
			arguments.content = imageTag(argumentCollection=local.args);
		}

		// save necessary info from arguments and delete afterwards
		local.content = arguments.content;
		local.prepend = arguments.prepend;
		local.append = arguments.append;
		StructDelete(arguments, "content");
		StructDelete(arguments, "image");
		StructDelete(arguments, "disable");
		StructDelete(arguments, "prepend");
		StructDelete(arguments, "append");

		// create the button
		local.rv = local.prepend & $element(name="button", content=local.content, attributes=arguments) & local.append;
		return local.rv;
	}

	/**
	* PRIVATE FUNCTIONS
	*/

	public string function $formValue(
		required any objectName,
		required string property,
		boolean applyHtmlEditFormat=true
	) {
		if (IsStruct(arguments.objectName))
		{
			local.rv = arguments.objectName[arguments.property];
		}
		else
		{
			local.object = $getObject(arguments.objectName);
			if (get("showErrorInformation") && !IsObject(local.object))
			{
				$throw(type="Wheels.IncorrectArguments", message="The `#arguments.objectName#` variable is not an object.");
			}
			if (StructKeyExists(local.object, arguments.property))
			{
				local.rv = local.object[arguments.property];
			}
			else
			{
				local.rv = "";
			}
		}
		if (arguments.applyHtmlEditFormat)
		{
			local.rv = HTMLEditFormat(local.rv);
		}
		return local.rv;
	}

	public any function $maxLength(required any objectName, required string property) {
		if (StructKeyExists(arguments, "maxlength"))
		{
			local.rv = arguments.maxlength;
		}
		else if (!IsStruct(arguments.objectName))
		{
			local.object = $getObject(arguments.objectName);
			if (IsObject(local.object))
			{
				local.propertyInfo = local.object.$propertyInfo(arguments.property);
				if (StructCount(local.propertyInfo) && ListFindNoCase("cf_sql_char,cf_sql_varchar", local.propertyInfo.type))
				{
					local.rv = local.propertyInfo.size;
				}
			}
		}
		if (StructKeyExists(local, "rv")) {
			return local.rv;
		}
	}

	public boolean function $formHasError(required any objectName, required string property) {
		local.rv = false;
		if (!IsStruct(arguments.objectName))
		{
			local.object = $getObject(arguments.objectName);
			if (get("showErrorInformation") && !IsObject(local.object))
			{
				$throw(type="Wheels.IncorrectArguments", message="The `#arguments.objectName#` variable is not an object.");
			}
			if (ArrayLen(local.object.errorsOn(arguments.property)))
			{
				local.rv = true;
			}
		}
		return local.rv;
	}

	public string function $createLabel(
		required any objectName,
		required string property,
		required string label,
		required string prependToLabel
	) {
		local.rv = arguments.prependToLabel;
		local.attributes = {};
		for (local.key in arguments)
		{
			if (CompareNoCase(Left(local.key, 5), "label") == 0 && Len(local.key) > 5 && local.key != "labelPlacement")
			{
				local.attributes[ReplaceNoCase(local.key, "label", "")] = arguments[local.key];
			}
		}
		if (StructKeyExists(arguments, "id"))
		{
			local.attributes.for = arguments.id;
		}
		local.rv &= $tag(name="label", attributes=local.attributes);
		local.rv &= arguments.label;
		local.rv &= "</label>";
		return local.rv;
	}

	public string function $formBeforeElement(
		required any objectName,
		required string property,
		required any label,
		required string labelPlacement,
		required string prepend,
		required string append,
		required string prependToLabel,
		required string appendToLabel,
		required string errorElement,
		required string errorClass
	) {
		local.rv = "";
		arguments.label = $getFieldLabel(argumentCollection=arguments);
		if ($formHasError(argumentCollection=arguments) && Len(arguments.errorElement))
		{
			// the input has an error and should be wrapped in a tag so we need to start that wrapper tag
			local.rv &= $tag(name=arguments.errorElement, class=arguments.errorClass);
		}
		if (Len(arguments.label) && arguments.labelPlacement != "after")
		{
			local.rv &= $createLabel(argumentCollection=arguments);
			if (arguments.labelPlacement == "aroundRight")
			{
				// strip out both the label text and closing label tag since it will be placed after the form input
				local.rv = Replace(local.rv, arguments.label & "</label>", "");
			}
			else if (arguments.labelPlacement == "before")
			{
				// since the entire label is created we can append to it
				local.rv &= arguments.appendToLabel;
			}
			else
			{
				// the label argument is either "around" or "aroundLeft" so we only have to strip out the closing label tag
				local.rv = Replace(local.rv, "</label>", "");
			}
		}
		local.rv &= arguments.prepend;
		return local.rv;
	}

	public string function $formAfterElement(
		required any objectName,
		required string property,
		required string label,
		required string labelPlacement,
		required string prepend,
		required string append,
		required string prependToLabel,
		required string appendToLabel,
		required string errorElement
	) {
		local.rv = arguments.append;
		arguments.label = $getFieldLabel(argumentCollection=arguments);
		if (Len(arguments.label) && arguments.labelPlacement != "before")
		{
			if (arguments.labelPlacement == "after")
			{
				// if the label should be placed after the tag we return the entire label tag
				local.rv &= $createLabel(argumentCollection=arguments);
			}
			else if (arguments.labelPlacement == "aroundRight")
			{
				// if the text should be placed to the right of the form input we return both the text and the closing tag
				local.rv &= arguments.label & "</label>";
			}
			else
			{
				// the label argument is either "around" or "aroundLeft" so we only have to return the closing label tag
				local.rv &= "</label>";
			}
			local.rv &= arguments.appendToLabel;
		}
		if ($formHasError(argumentCollection=arguments) && Len(arguments.errorElement))
		{
			// the input has an error and is wrapped in a tag so we need to close that wrapper tag
			local.rv &= "</" & arguments.errorElement & ">";
		}
		return local.rv;
	}

	public string function $getFieldLabel(required any objectName, required string property, required string label) {
		local.object = false;

		if (Compare("false", arguments.label) == 0) {
			local.rv = "";
		} else if (arguments.label == "useDefaultLabel" && !IsStruct(arguments.objectName)) {
			local.object = $getObject(arguments.objectName);

			if (IsObject(local.object)) {
				local.rv = local.object.$label(arguments.property);
			}
		}

		if (!StructKeyExists(local, "rv")) {
			local.rv = arguments.label;
		}

		return local.rv;
	}
</cfscript>
