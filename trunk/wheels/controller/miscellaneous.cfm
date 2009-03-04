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
		if (cgi.http_x_requested_with IS "XMLHTTPRequest")
			returnValue = true;
		else
			returnValue = false;
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="sendEmail" returntype="void" access="public" output="false" hint="Sends an email using a template and an optional layout to wrap it in.">
	<cfargument name="template" type="string" required="true" hint="Path to email body">
	<cfargument name="layout" type="any" required="false" default="#application.settings.sendEmail.layout#" hint="Layout to wrap body in">
	<cfscript>
		var loc = {};
		loc.defaults = StructCopy(application.settings.sendEmail);
		StructDelete(loc.defaults, "layout");
		for (loc.key in loc.defaults)
		{
			if (!StructKeyExists(arguments, loc.key))
				arguments[loc.key] = loc.defaults[loc.key];
		}
		if (arguments.template Contains "/")
		{
			loc.controller = ListFirst(arguments.template, "/");
			loc.action = ListLast(arguments.template, "/");
		}
		else
		{
			loc.controller = variables.params.controller;
			loc.action = arguments.template;
		}
		loc.attributes = structCopy(arguments);
		for (loc.key in loc.attributes)
		{
			if (!ListFindNoCase("from,to,bcc,cc,charset,debug,failto,group,groupcasesensitive,mailerid,maxrows,mimeattach,password,port,priority,query,replyto,server,spoolenable,startrow,subject,timeout,type,username,useSSL,useTLS,wraptext", loc.key))
			{
				if (!ListFindNoCase("template,layout", loc.key))
					variables[loc.key] = arguments[loc.key];
				StructDelete(loc.attributes, loc.key);
			}
		}
		loc.attributes.body = $renderPage(controller=loc.controller, action=loc.action, layout=arguments.layout);;
		$mail(argumentCollection=loc.attributes);
	</cfscript>
</cffunction>

<cffunction name="sendFile" returntype="void" access="public" output="false" hint="Sends a file to the user.">
	<cfargument name="file" type="string" required="true" hint="The file to send to the user">
	<cfargument name="name" type="string" required="false" default="" hint="The file name to show in the browser download dialog box">
	<cfargument name="type" type="string" required="false" default="" hint="The HTTP content type to deliver the file as">
	<cfargument name="disposition" type="string" required="false" default="attachment" hint="Set to 'inline' to have the browser handle the opening of the file or set to 'attachment' to force a download dialog box">
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
			case "jpg": {loc.type = "image/jpg"; break;}
			case "png": {loc.type = "image/png"; break;}
			case "wav": {loc.type = "audio/wav"; break;}
			case "mp3": {loc.type = "audio/mpeg3"; break;}
			case "pdf": {loc.type = "application/pdf"; break;}
			case "zip": {loc.type = "application/zip"; break;}
			case "ppt": {loc.type = "application/powerpoint"; break;}
			case "doc": {loc.type = "application/word"; break;}
			case "xls": {loc.type = "application/excel"; break;}
			default: {loc.type = "application/octet-stream"; break;}
		}
		$header(name="content-disposition", value="#arguments.disposition#; filename=""#loc.name#""");
		$content(type=loc.type, file=loc.fullPath);
	</cfscript>
</cffunction>