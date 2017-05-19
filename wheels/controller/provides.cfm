<cfscript>

/**
 * Defines formats that the controller will respond with upon request.
 * The format can be requested through a URL variable called `format`, by appending the `format` name to the end of a URL as an extension (when URL rewriting is enabled), or in the request header.
 *
 * [section: Controller]
 * [category: Configuration Functions]
 *
 * @formats Formats to instruct the controller to provide. Valid values are `html` (the default), `xml`, `json`, `csv`, `pdf`, and `xls`.
 */
public void function provides(string formats="") {
	$combineArguments(args=arguments, combine="formats,format", required=true);
	arguments.formats = $listClean(arguments.formats);
	local.possibleFormats = StructKeyList($get("formats"));
	local.iEnd = ListLen(arguments.formats);
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		local.item = ListGetAt(arguments.formats, local.i);
		if ($get("showErrorInformation") && !ListFindNoCase(local.possibleFormats, local.item)) {
			Throw(
				type="Wheels.InvalidFormat",
				message="An invalid format of `#local.item#` has been specified.
				The possible values are #local.possibleFormats#."
			);
		}
	}
	variables.$class.formats.default = ListAppend(variables.$class.formats.default, arguments.formats);
}

/**
 * Use this in an individual controller action to define which formats the action will respond with.
 * This can be used to define provides behavior in individual actions or to override a global setting set with `provides` in the controller's `config()`.
 *
 * [section: Controller]
 * [category: Provides Functions]
 *
 * @formats [see:provides].
 * @action Name of action, defaults to current.
 */
public void function onlyProvides(string formats="", string action=variables.params.action) {
	$combineArguments(args=arguments, combine="formats,format", required=true);
	arguments.formats = $listClean(arguments.formats);
	local.possibleFormats = StructKeyList($get("formats"));
	local.iEnd = ListLen(arguments.formats);
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		local.item = ListGetAt(arguments.formats, local.i);
		if ($get("showErrorInformation") && !ListFindNoCase(local.possibleFormats, local.item)) {
			Throw(
				type="Wheels.InvalidFormat",
				message="An invalid format of `#local.item#` has been specified. The possible values are #local.possibleFormats#."
			);
		}
	}
	variables.$class.formats.actions[arguments.action] = arguments.formats;
}

/**
 * Instructs the controller to render the data passed in to the format that is requested.
 * If the format requested is `json` or `xml`, CFWheels will transform the data into that format automatically.
 * For other formats (or to override the automatic formatting), you can also create a view template in this format: `nameofaction.xml.cfm`, `nameofaction.json.cfm`, `nameofaction.pdf.cfm`, etc.
 *
 * [section: Controller]
 * [category: Provides Functions]
 *
 * @data Data to format and render.
 * @controller [see:renderView].
 * @action [see:renderView].
 * @template [see:renderView].
 * @layout [see:renderView].
 * @cache [see:renderView].
 * @returnAs [see:renderView].
 * @hideDebugInformation [see:renderView].
 * @status Force request to return with specific HTTP status code.
 */
public any function renderWith(
	required any data,
	string controller=variables.params.controller,
	string action=variables.params.action,
	string template="",
	any layout,
	any cache="",
	string returnAs="",
	boolean hideDebugInformation=false,
	any status="200"
) {
	$args(name="renderWith", args=arguments);
	local.contentType = $requestContentType();
	local.acceptableFormats = $acceptableFormats(action=arguments.action);

	// Default to html if the content type found is not acceptable.
	if (!ListFindNoCase(local.acceptableFormats, local.contentType)) {
		local.contentType = "html";
	}

	if (local.contentType == "html") {

		// Call render page when we are just rendering html.
		StructDelete(arguments, "data");
		local.rv = renderView(argumentCollection=arguments);

	} else {
		local.templateName = $generateRenderWithTemplatePath(argumentCollection=arguments, contentType=local.contentType);
		local.templatePathExists = $formatTemplatePathExists($name=local.templateName);
		if (local.templatePathExists) {
			local.content = renderView(argumentCollection=arguments, template=local.templateName, returnAs="string", layout=false, hideDebugInformation=true);
		}

		// Throw an error if we rendered a pdf template and we got here, the cfdocument call should have stopped processing.
		if (local.contentType == "pdf" && $get("showErrorInformation") && local.templatePathExists) {
			Throw(
				type="Wheels.PdfRenderingError",
				message="When rendering the a PDF file, don't specify the filename attribute. This will stream the PDF straight to the browser."
			);
		}

		// Throw an error if we do not have a template to render the content type that we do not have defaults for.
		if (!ListFindNoCase("json,xml", local.contentType) && !StructKeyExists(local, "content") && $get("showErrorInformation")) {
			Throw(
				type="Wheels.RenderingError",
				message="To render the #local.contentType# content type, create the template `#local.templateName#.cfm` for the #arguments.controller# controller."
			);
		}

		// Set our header based on our mime type.
		local.formats = $get("formats");
		local.value = local.formats[local.contentType] & "; charset=utf-8";
		$header(name="content-type", value=local.value, charset="utf-8");

		// If custom statuscode passed in, then set appropriate header.
		// Status may be a numeric value such as 404, or a text value such as "Forbidden".
		if (StructKeyExists(arguments, "status")) {
			local.status=arguments.status;
			if (IsNumeric(local.status)) {
				local.statusCode=local.status;
				local.statusText=$returnStatusText(local.status);
			} else {
				// Try for statuscode;
				local.statusCode=$returnStatusCode(local.status);
				local.statusText=local.status;
			}
			$header(statusCode=local.statusCode, statusText=local.statusText);
		}

		// If we do not have the local.content variable and we are not rendering html then try to create it.
		if (!StructKeyExists(local, "content")) {
			switch (local.contentType) {
				case "json":
					local.namedArgs = {};
					if (StructCount(arguments) > 8) {
						local.namedArgs = $namedArguments(argumentCollection=arguments, $defined="data,controller,action,template,layout,cache,returnAs,hideDebugInformation");
					}
					for (local.key in local.namedArgs) {
						if (local.namedArgs[local.key] == "string") {
							if (IsArray(arguments.data)) {
								local.iEnd = ArrayLen(arguments.data);
								for (local.i = 1; local.i <= local.iEnd; local.i++) {

									// Force to string by wrapping in non printable character (that we later remove again).
									arguments.data[local.i][local.key] = Chr(7) & arguments.data[local.i][local.key] & Chr(7);
								}
							}
						}
					}
					local.content = SerializeJSON(arguments.data);
					if (Find(Chr(7), local.content)) {
						local.content = Replace(local.content, Chr(7), "", "all");
					}
					for (local.key in local.namedArgs) {
						if (local.namedArgs[local.key] == "integer") {

							// Force to integer by removing the .0 part of the number.
							local.content = REReplaceNoCase(local.content, '([{|,]"' & local.key & '":[0-9]*)\.0([}|,"])', "\1\2", "all");

						}
					}
					break;
				case "xml":
					local.content = $toXml(arguments.data);
					break;
			}
		}

		// If the developer passed in returnAs="string" then return the generated content to them.
		if (arguments.returnAs == "string") {
			local.rv = local.content;
		} else {
			renderText(local.content);
		}

	}
	if (StructKeyExists(local,"rv")) {
		return local.rv;
	}
}

/**
 * Internal function.
 */
public string function $acceptableFormats() {
	local.rv = variables.$class.formats.default;
	if (StructKeyExists(variables.$class.formats, arguments.action)) {
		local.rv = variables.$class.formats[arguments.action];
	}
	return local.rv;
}

/**
 * Internal function.
 */
public string function $generateRenderWithTemplatePath(
	required string controller,
	required string action,
	required string template,
	required string contentType
) {
	local.rv = "";
	if (!Len(arguments.template)) {
		local.rv = "/" & ListChangeDelims(arguments.controller, '/', '.') & "/" & arguments.action;
	} else {
		local.rv = arguments.template;
	}
	if (Len(arguments.contentType)) {
		local.rv &= "." & arguments.contentType;
	}
	return local.rv;
}

/**
 * Internal function.
 */
public boolean function $formatTemplatePathExists(required string $name) {
	local.templatePath = $generateIncludeTemplatePath($type="page", $name=arguments.$name, $template=arguments.$name);
	local.rv = false;
	if (!ListFindNoCase(variables.$class.formats.existingTemplates, arguments.$name) && !ListFindNoCase(variables.$class.formats.nonExistingTemplates, arguments.$name)) {
		if (FileExists(ExpandPath(local.templatePath))) {
			local.rv = true;
		}
		if ($get("cacheFileChecking")) {
			if (local.rv) {
				variables.$class.formats.existingTemplates = ListAppend(variables.$class.formats.existingTemplates, arguments.$name);
			} else {
				variables.$class.formats.nonExistingTemplates = ListAppend(variables.$class.formats.nonExistingTemplates, arguments.$name);
			}
		}
	}
	if (!local.rv && ListFindNoCase(variables.$class.formats.existingTemplates, arguments.$name)) {
		local.rv = true;
	}
	return local.rv;
}

/**
 * Internal function.
 */
public string function $requestContentType(struct params=variables.params, string httpAccept=request.cgi.http_accept) {
	local.rv = "html";
	if (StructKeyExists(arguments.params, "format")) {
		local.rv = arguments.params.format;
	} else {
		local.formats = $get("formats");
		for (local.item in local.formats) {
			if (FindNoCase(local.formats[local.item], arguments.httpAccept)) {
				local.rv = local.item;
				break;
			}
		}
	}
	return local.rv;
}

/**
 * Returns a response text for any status code.
 */
public string function $returnStatusText(numeric status=200) {
	local.status = arguments.status;
	local.statusCodes = $getStatusCodes();
	local.rv = "";
	if (StructKeyExists(local.statuscodes, local.status)) {
		local.rv = local.statuscodes[local.status];
	} else {
		Throw(
			type="Wheels.RenderingError",
			message="An invalid http response code #local.status# was passed in."
		);
	}
	return local.rv;
}

/**
 * Returns a response code from the status code list.
 */
public string function $returnStatusCode(any status=200) {
	local.status = arguments.status;
	local.statusCodes = $getStatusCodes();
	local.rv = "";
	local.lookup = StructFindValue(local.statuscodes, local.status);
	if (ArrayLen(local.lookup)) {
		local.rv = local.lookup[1]["key"];
	} else {
		Throw(
			type="Wheels.RenderingError",
			message="An invalid http response text #local.status# was passed in."
		);
	}
	return local.rv;
}

/**
 * Returns a list of HTTP status codes and their response names
 */
public struct function $getStatusCodes() {
	local.rv = {
		100 = 'Continue',
		101 = 'Switching Protocols',
		102 = 'Processing',
		200 = 'OK',
		201 = 'Created',
		202 = 'Accepted',
		203 = 'Non-Authoritative Information',
		204 = 'No Content',
		205 = 'Reset Content',
		206 = 'Partial Content',
		207 = 'Multi-Status',
		208 = 'Already Reported',
		226 = 'IM Used',
		300 = 'Multiple Choices',
		301 = 'Moved Permanently',
		302 = 'Found',
		303 = 'See Other',
		304 = 'Not Modified',
		305 = 'Use Proxy',
		306 = 'Reserved',
		307 = 'Temporary Redirect',
		308 = 'Permanent Redirect',
		400 = 'Bad Request',
		401 = 'Unauthorized',
		402 = 'Payment Required',
		403 = 'Forbidden',
		404 = 'Not Found',
		405 = 'Method Not Allowed',
		406 = 'Not Acceptable',
		407 = 'Proxy Authentication Required',
		408 = 'Request Timeout',
		409 = 'Conflict',
		410 = 'Gone',
		411 = 'Length Required',
		412 = 'Precondition Failed',
		413 = 'Request Entity Too Large',
		414 = 'Request-URI Too Long',
		415 = 'Unsupported Media Type',
		416 = 'Requested Range Not Satisfiable',
		417 = 'Expectation Failed',
		422 = 'Unprocessable Entity',
		423 = 'Locked',
		424 = 'Failed Dependency',
		425 = 'Reserved for WebDAV advanced collections expired proposal',
		426 = 'Upgrade Required',
		427 = 'Unassigned',
		428 = 'Precondition Required',
		429 = 'Too Many Requests',
		430 = 'Unassigned',
		431 = 'Request Header Fields Too Large',
		500 = 'Internal Server Error',
		501 = 'Not Implemented',
		502 = 'Bad Gateway',
		503 = 'Service Unavailable',
		504 = 'Gateway Timeout',
		505 = 'HTTP Version Not Supported',
		506 = 'Variant Also Negotiates (Experimental)',
		507 = 'Insufficient Storage',
		508 = 'Loop Detected',
		509 = 'Unassigned',
		510 = 'Not Extended',
		511 = 'Network Authentication Required'
	};
	return local.rv;
}

</cfscript>
