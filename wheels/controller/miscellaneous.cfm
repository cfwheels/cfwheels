<cfscript>

public any function sendEmail(
	string template="",
	string from="",
	string to="",
	string subject="",
	any layout,
	string file="",
	boolean detectMultipart,
	boolean deliver=true,
	string writeToFile=""
) {
	local.deliver = Duplicate(arguments.deliver);
	local.writeToFile = Duplicate(arguments.writeToFile);
	$args(args=arguments, name="sendEmail", combine="template/templates/!,layout/layouts,file/files", required="template,from,to,subject");
	local.nonPassThruArgs = "writetofile,template,templates,layout,layouts,file,files,detectMultipart,deliver,tagContent";
	local.mailTagArgs = "from,to,bcc,cc,charset,debug,failto,group,groupcasesensitive,mailerid,mailparams,maxrows,mimeattach,password,port,priority,query,replyto,server,spoolenable,startrow,subject,timeout,type,username,useSSL,useTLS,wraptext,remove";

	// If two templates but only one layout was passed in we set the same layout to be used on both.
	if (ListLen(arguments.template) > 1 && ListLen(arguments.layout) == 1) {
		arguments.layout = ListAppend(arguments.layout, arguments.layout);
	}

	// Set the variables that should be available to the email view template (i.e. the custom named arguments passed in by the developer).
	for (local.key in arguments) {
		if (!ListFindNoCase(local.nonPassThruArgs, local.key) && !ListFindNoCase(local.mailTagArgs, local.key)) {
			variables[local.key] = arguments[local.key];
			StructDelete(arguments, local.key);
		}
	}

	// Get the content of the email templates and store them as cfmailparts.
	arguments.mailparts = [];
	local.iEnd = ListLen(arguments.template);
	for (local.i = 1; local.i <= local.iEnd; local.i++) {

		// Include the email template and return it,
		local.item = ListGetAt(arguments.template, local.i);
		local.content = $renderPage($template=local.item, $layout=ListGetAt(arguments.layout, local.i));

		local.mailpart = {};
		local.mailpart.tagContent = local.content;
		if (ArrayIsEmpty(arguments.mailparts)) {
			ArrayAppend(arguments.mailparts, local.mailpart);
		} else {

			// Make sure the text version is the first one in the array.
			local.existingContentCount = ListLen(arguments.mailparts[1].tagContent, "<");
			local.newContentCount = ListLen(local.content, "<");
			if (local.newContentCount < local.existingContentCount) {
				ArrayPrepend(arguments.mailparts, local.mailpart);
			} else {
				ArrayAppend(arguments.mailparts, local.mailpart);
			}
			arguments.mailparts[1].type = "text";
			arguments.mailparts[2].type = "html";

		}
	}

	// Return a struct containing mailpart content using type as the key.
	local.rv = {};
	local.rv["html"] = "";
	local.rv["text"] = "";

	// Figure out if the email should be sent as html or text when only one template is used and the developer did not specify the type explicitly.
	if (ArrayLen(arguments.mailparts) == 1) {
		arguments.tagContent = arguments.mailparts[1].tagContent;
		StructDelete(arguments, "mailparts");
		if (arguments.detectMultipart && !StructKeyExists(arguments, "type")) {
			if (Find("<", arguments.tagContent) && Find(">", arguments.tagContent)) {
				arguments.type = "html";
			} else {
				arguments.type = "text";
			}
		}
		local.rv[arguments.type] = arguments.tagContent;
	} else {
		// return a struct containing mailparts using type the the key
		local.iEnd = ArrayLen(arguments.mailparts);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			local.rv[arguments.mailparts[local.i].type] = arguments.mailparts[local.i].tagContent;
		}
	}

	// attach files using the cfmailparam tag
	if (Len(arguments.file)) {
		arguments.mailparams = [];
		local.iEnd = ListLen(arguments.file);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			local.item = ListGetAt(arguments.file, local.i);
			arguments.mailparams[local.i] = {};
			if (!ReFindNoCase("\\|/", local.item)) {
				// no directory delimiter is present so append the path
				local.item = ExpandPath(get("filePath")) & "/" & local.item;
			}
			arguments.mailparams[local.i].file = local.item;
		}
	}

	// Delete arguments that we don't want to pass through to the cfmail tag.
	local.iEnd = ListLen(local.nonPassThruArgs);
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		local.item = ListGetAt(local.nonPassThruArgs, local.i);
		StructDelete(arguments, local.item);
	}

	// Also return the args passed to cfmail.
	StructAppend(local.rv, arguments);

	// Write the email body to file.
	if (Len(local.writeToFile)) {
		local.output = ListAppend(local.rv.text, local.rv.html, "#Chr(13)##Chr(10)##Chr(13)##Chr(10)#");
		$file(action="write", file="#local.writeToFile#", output="#local.output#");
	}

	// Send the email using the cfmail tag.
	if (local.deliver) {
		$mail(argumentCollection=arguments);
	}

	return local.rv;
}

public any function sendFile(
	required string file,
	string name="",
	string type="",
	string disposition,
	string directory="",
	boolean deleteFile=false,
	boolean $testingMode=false
) {
	$args(name="sendFile", args=arguments);

	// Check whether the resource is a ram resource or physical file.
	if (!ListFirst(arguments.file, "://") == "ram") {
		local.relativeRoot = get("rootPath");
		if (Right(local.relativeRoot, 1) != "/") {
			local.relativeRoot &= "/";
		}
		local.root = ExpandPath(local.relativeRoot);
		local.folder = arguments.directory;
		if (!Len(local.folder)) {
			local.folder = local.relativeRoot & get("filePath");
		}
		if (Left(local.folder, Len(local.root)) == local.root) {
			local.folder = RemoveChars(local.folder, 1, Len(local.root));
		}
		local.fullPath = Replace(local.folder, "\", "/", "all");
		local.fullPath = ListAppend(local.fullPath, arguments.file, "/");
		local.fullPath = ExpandPath(local.fullPath);
		local.fullPath = Replace(local.fullPath, "\", "/", "all");
		local.file = ListLast(local.fullPath, "/");
		local.directory = Reverse(ListRest(Reverse(local.fullPath), "/"));

		// If the file is not found, try searching for it.
		if (!FileExists(local.fullPath)) {
			local.match = $directory(action="list", directory=local.directory, filter="#local.file#.*");

			// Only extract the extension if we find a single match.
			if (local.match.recordCount == 1) {
				local.file &= "." & ListLast(local.match.name, ".");
				local.fullPath = local.directory & "/" & local.file;
			} else {
				$throw(
					type="Wheels.FileNotFound",
					message="A file could not be found.",
					extendedInfo="Make sure a file with the name `#local.file#` exists in the `#local.directory#` folder."
				);
			}
		}
		local.name = local.file;
	} else {
		local.fullPath = arguments.file;
		local.file = arguments.file;
		// For ram:// resources, skip the physical file check but still check the thing exists
		if (!FileExists(local.fullPath)) {
			$throw(
				type="Wheels.FileNotFound",
				message="ram:// resource could not be found.",
				extendedInfo="Make sure a resource with the name `#local.file#` exists in memory"
			);
		}
		// Make the default display name behaviour the same as physical files
		local.name = Replace(arguments.file, "ram://","","one");
	}

	local.extension = ListLast(local.file, ".");

	// replace the display name for the file if supplied
	if (Len(arguments.name)) {
		local.name = arguments.name;
	}

	local.mime = arguments.type;
	if (!Len(local.mime)) {
		local.mime = mimeTypes(local.extension);
	}

	// if testing, return the variables
	if (arguments.$testingMode) {
		StructAppend(local, arguments, false);
		local.rv = local;
	} else {
		// prompt the user to download the file
		$header(name="content-disposition", value="#arguments.disposition#; filename=""#local.name#""");
		$content(type=local.mime, file=local.fullPath, deleteFile=arguments.deleteFile);
	}
	if (StructKeyExists(local,"rv")) {
		return local.rv;
	}
}

public boolean function isSecure() {
	return request.cgi.server_port_secure == "true";
}

public boolean function isAjax() {
	return request.cgi.http_x_requested_with == "XMLHTTPRequest";
}

public boolean function isGet() {
	return request.cgi.request_method == "get";
}

public boolean function isPost() {
	return request.cgi.request_method == "post";
}

public boolean function isPut() {
	return request.cgi.request_method == "put";
}

public boolean function isPatch() {
	return request.cgi.request_method == "patch";
}

public boolean function isDelete() {
	return request.cgi.request_method == "delete";
}

public boolean function isHead() {
	return request.cgi.request_method == "head";
}

public boolean function isOptions() {
	return request.cgi.request_method == "options";
}

</cfscript>
