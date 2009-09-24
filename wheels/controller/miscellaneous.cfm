<cffunction name="isGet" returntype="boolean" access="public" output="false" hint="Returns whether the request was a normal (GET) request or not.">
	<cfscript>
		var returnValue = "";
		if (cgi.request_method == "get")
			returnValue = true;
		else
			returnValue = false;
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="isPost" returntype="boolean" access="public" output="false" hint="Returns whether the request came from a form submission or not.">
	<cfscript>
		var returnValue = "";
		if (cgi.request_method == "post")
			returnValue = true;
		else
			returnValue = false;
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="isAjax" returntype="boolean" access="public" output="false" hint="Returns whether the page was called from JavaScript or not.">
	<cfscript>
		var returnValue = "";
		if (cgi.http_x_requested_with == "XMLHTTPRequest")
			returnValue = true;
		else
			returnValue = false;
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="sendEmail" returntype="void" access="public" output="false" hint="Sends an email using a template and an optional layout to wrap it in.">
	<cfargument name="templates" type="string" required="false" default="" hint="The path to the email template or two paths if you want to send a multipart email. if the `detectMultipart` argument is `false` the template for the text version should be the first one in the list (can also be called with the `template` argument).">
	<cfargument name="from" type="string" required="true" hint="Email address to send from">
	<cfargument name="to" type="string" required="true" hint="Email address to send to">
	<cfargument name="subject" type="string" required="true" hint="The subject line of the email">
	<cfargument name="layouts" type="any" required="false" default="#application.wheels.functions.sendEmail.layouts#" hint="Layout(s) to wrap body in">
	<cfargument name="detectMultipart" type="boolean" required="false" default="#application.wheels.functions.sendEmail.detectMultipart#" hint="When set to `true` Wheels will detect which of the templates is text and which one is html (by counting the `<` characters)">
	<cfscript>
		var loc = {};

		if (StructKeyExists(arguments, "template") && !Len(arguments.templates))
			arguments.templates = arguments.template;
		if (StructKeyExists(arguments, "layout"))
			arguments.layouts = arguments.layout;
		$insertDefaults(name="sendEmail", input=arguments);

		if (ListLen(arguments.templates) > 1 && ListLen(arguments.layouts) == 1)
			arguments.layouts = ListAppend(arguments.layouts, false);

		// set the variables that should be available to the email view template
		for (loc.key in arguments)
		{
			if (!ListFindNoCase("template,templates,layout,layouts,detectMultipart", loc.key) && !ListFindNoCase("from,to,bcc,cc,charset,debug,failto,group,groupcasesensitive,mailerid,maxrows,mimeattach,password,port,priority,query,replyto,server,spoolenable,startrow,subject,timeout,type,username,useSSL,useTLS,wraptext", loc.key))
			{
				variables[loc.key] = arguments[loc.key];
				StructDelete(arguments, loc.key);
			}
		}

		arguments.body = [];
		loc.iEnd = ListLen(arguments.templates);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			// include the email template and return it
			loc.content = $renderPage($template=ListGetAt(arguments.templates, loc.i), $layout=ListGetAt(arguments.layouts, loc.i));
			if (ArrayIsEmpty(arguments.body))
			{
				ArrayAppend(arguments.body, loc.content);
			}
			else
			{
				if (arguments.detectMultipart)
				{
					// make sure the text version is the first one in the array
					loc.existingContentCount = ListLen(arguments.body[1], "<");
					loc.newContentCount = ListLen(loc.content, "<");
					if (loc.newContentCount < loc.existingContentCount)
						ArrayPrepend(arguments.body, loc.content);
					else
						ArrayAppend(arguments.body, loc.content);
				}
				else
				{
					ArrayAppend(arguments.body, loc.content);
				}
			}
		}

		// delete arguments that we don't need to pass on to cfmail and send the email
		StructDelete(arguments, "template");
		StructDelete(arguments, "templates");
		StructDelete(arguments, "layout");
		StructDelete(arguments, "layouts");
		StructDelete(arguments, "detectMultipart");
		$mail(argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="sendFile" returntype="void" access="public" output="false" hint="Sends a file to the user.">
	<cfargument name="file" type="string" required="true" hint="The file to send to the user">
	<cfargument name="name" type="string" required="false" default="" hint="The file name to show in the browser download dialog box">
	<cfargument name="type" type="string" required="false" default="" hint="The HTTP content type to deliver the file as">
	<cfargument name="disposition" type="string" required="false" default="#application.wheels.functions.sendFile.disposition#" hint="Set to 'inline' to have the browser handle the opening of the file or set to 'attachment' to force a download dialog box">
	<cfscript>
		var loc = {};
		arguments.file = Replace(arguments.file, "\", "/", "all");
		loc.path = Reverse(ListRest(Reverse(arguments.file), "/"));
		loc.folder = application.wheels.filePath;
		if (Len(loc.path))
		{
			loc.folder = loc.folder & "/" & loc.path;
			loc.file = Replace(arguments.file, loc.path, "");
			loc.file = Right(loc.file, Len(loc.file)-1);		
		}
		else
		{
			loc.file = arguments.file;
		}
		loc.folder = ExpandPath(loc.folder);
		if (!FileExists(loc.folder & "/" & loc.file))
		{
			loc.match = $directory(action="list", directory=loc.folder, filter="#loc.file#.*");
			if (loc.match.recordCount)
				loc.file = loc.file & "." & ListLast(loc.match.name, ".");
			else
				$throw(type="Wheels.FileNotFound", message="File Not Found", extendedInfo="Make sure a file with the name '#loc.file#' exists in the '#loc.folder#' folder.");	
		}
		loc.fullPath = loc.folder & "/" & loc.file;
		if (Len(arguments.name))
			loc.name = arguments.name;
		else
			loc.name = loc.file;
		loc.extension = ListLast(loc.file, ".");
		switch(loc.extension)
		{
			case "txt": {loc.type = "text/plain"; break;}
			case "gif": {loc.type = "image/gif"; break;}
			case "jpg": case "jpeg": case "pjpeg": {loc.type = "image/jpg"; break;}
			case "png": {loc.type = "image/png"; break;}
			case "wav": {loc.type = "audio/wav"; break;}
			case "mp3": {loc.type = "audio/mpeg3"; break;}
			case "pdf": {loc.type = "application/pdf"; break;}
			case "zip": {loc.type = "application/zip"; break;}
			case "ppt": case "pptx": {loc.type = "application/powerpoint"; break;}
			case "doc": case "docx": {loc.type = "application/word"; break;}
			case "xls": case "xlsx": {loc.type = "application/excel"; break;}
 			default: {loc.type = "application/octet-stream"; break;}
		}
		$header(name="content-disposition", value="#arguments.disposition#; filename=""#loc.name#""");
		$content(type=loc.type, file=loc.fullPath);
	</cfscript>
</cffunction>