<!--- PUBLIC CONTROLLER REQUEST FUNCTIONS --->

<cffunction name="pagination" returntype="struct" access="public" output="false">
	<cfargument name="handle" type="string" required="false" default="query">
	<cfscript>
		var loc = {};
		if (get("showErrorInformation"))
		{
			if (!StructKeyExists(request.wheels, arguments.handle))
			{
				$throw(type="Wheels.QueryHandleNotFound", message="CFWheels couldn't find a query with the handle of `#arguments.handle#`.", extendedInfo="Make sure your `findAll` call has the `page` argument specified and matching `handle` argument if specified.");
			}
		}
		loc.rv = request.wheels[arguments.handle];
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="sendEmail" returntype="any" access="public" output="false">
	<cfargument name="template" type="string" required="false" default="">
	<cfargument name="from" type="string" required="false" default="">
	<cfargument name="to" type="string" required="false" default="">
	<cfargument name="subject" type="string" required="false" default="">
	<cfargument name="layout" type="any" required="false">
	<cfargument name="file" type="string" required="false" default="">
	<cfargument name="detectMultipart" type="boolean" required="false">
	<cfargument name="$deliver" type="boolean" required="false" default="true">
	<cfscript>
		var loc = {};
		$args(args=arguments, name="sendEmail", combine="template/templates/!,layout/layouts,file/files", required="template,from,to,subject");

		loc.nonPassThruArgs = "template,templates,layout,layouts,file,files,detectMultipart,$deliver";
		loc.mailTagArgs = "from,to,bcc,cc,charset,debug,failto,group,groupcasesensitive,mailerid,maxrows,mimeattach,password,port,priority,query,replyto,server,spoolenable,startrow,subject,timeout,type,username,useSSL,useTLS,wraptext,remove";
		loc.deliver = arguments.$deliver;

		// if two templates but only one layout was passed in we set the same layout to be used on both
		if (ListLen(arguments.template) > 1 && ListLen(arguments.layout) == 1)
		{
			arguments.layout = ListAppend(arguments.layout, arguments.layout);
		}

		// set the variables that should be available to the email view template (i.e. the custom named arguments passed in by the developer)
		for (loc.key in arguments)
		{
			if (!ListFindNoCase(loc.nonPassThruArgs, loc.key) && !ListFindNoCase(loc.mailTagArgs, loc.key))
			{
				variables[loc.key] = arguments[loc.key];
				StructDelete(arguments, loc.key);
			}
		}

		// get the content of the email templates and store them as cfmailparts
		arguments.mailparts = [];
		loc.iEnd = ListLen(arguments.template);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			// include the email template and return it
			loc.item = ListGetAt(arguments.template, loc.i);
			loc.content = $renderPage($template=loc.item, $layout=ListGetAt(arguments.layout, loc.i));
			loc.mailpart = {};
			loc.mailpart.tagContent = loc.content;
			if (ArrayIsEmpty(arguments.mailparts))
			{
				ArrayAppend(arguments.mailparts, loc.mailpart);
			}
			else
			{
				// make sure the text version is the first one in the array
				loc.existingContentCount = ListLen(arguments.mailparts[1].tagContent, "<");
				loc.newContentCount = ListLen(loc.content, "<");
				if (loc.newContentCount < loc.existingContentCount)
				{
					ArrayPrepend(arguments.mailparts, loc.mailpart);
				}
				else
				{
					ArrayAppend(arguments.mailparts, loc.mailpart);
				}
				arguments.mailparts[1].type = "text";
				arguments.mailparts[2].type = "html";
			}
		}

		// figure out if the email should be sent as html or text when only one template is used and the developer did not specify the type explicitly
		if (ArrayLen(arguments.mailparts) == 1)
		{
			arguments.tagContent = arguments.mailparts[1].tagContent;
			StructDelete(arguments, "mailparts");
			if (arguments.detectMultipart && !StructKeyExists(arguments, "type"))
			{
				if (Find("<", arguments.tagContent) && Find(">", arguments.tagContent))
				{
					arguments.type = "html";
				}
				else
				{
					arguments.type = "text";
				}
			}
		}

		// attach files using the cfmailparam tag
		if (Len(arguments.file))
		{
			arguments.mailparams = [];
			loc.iEnd = ListLen(arguments.file);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.item = ListGetAt(arguments.file, loc.i);
				arguments.mailparams[loc.i] = {};
				if (!ReFindNoCase("\\|/", loc.item))
				{
					// no directory delimiter is present so append the path
					loc.item = ExpandPath(get("filePath")) & "/" & loc.item;
				}
				arguments.mailparams[loc.i].file = loc.item;
			}
		}

		// delete arguments that we don't want to pass through to the cfmail tag
		loc.iEnd = ListLen(loc.nonPassThruArgs);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(loc.nonPassThruArgs, loc.i);
			StructDelete(arguments, loc.item);
		}

		// send the email using the cfmail tag
		if (loc.deliver)
		{
			$mail(argumentCollection=arguments);
		}
		else
		{
			loc.rv = arguments;
		}
	</cfscript>
	<cfif StructKeyExists(loc, "rv")>
		<cfreturn loc.rv>
	</cfif>
</cffunction>

<cffunction name="sendFile" returntype="any" access="public" output="false">
	<cfargument name="file" type="string" required="true">
	<cfargument name="name" type="string" required="false" default="">
	<cfargument name="type" type="string" required="false" default="">
	<cfargument name="disposition" type="string" required="false">
	<cfargument name="directory" type="string" required="false" default="">
	<cfargument name="deleteFile" type="boolean" required="false" default="false">
	<cfargument name="$testingMode" type="boolean" required="false" default="false">
	<cfscript>
		var loc = {};
		$args(name="sendFile", args=arguments);
		loc.relativeRoot = get("rootPath");
		if (Right(loc.relativeRoot, 1) != "/")
		{
			loc.relativeRoot &= "/";
		}
		loc.root = ExpandPath(loc.relativeRoot);
		loc.folder = arguments.directory;
		if (!Len(loc.folder))
		{
			loc.folder = loc.relativeRoot & get("filePath");
		}
		if (Left(loc.folder, Len(loc.root)) == loc.root)
		{
			loc.folder = RemoveChars(loc.folder, 1, Len(loc.root));
		}
		loc.fullPath = Replace(loc.folder, "\", "/", "all");
		loc.fullPath = ListAppend(loc.fullPath, arguments.file, "/");
		loc.fullPath = ExpandPath(loc.fullPath);
		loc.fullPath = Replace(loc.fullPath, "\", "/", "all");
		loc.file = ListLast(loc.fullPath, "/");
		loc.directory = Reverse(ListRest(Reverse(loc.fullPath), "/"));

		// if the file is not found, try searching for it
		if (!FileExists(loc.fullPath))
		{
			loc.match = $directory(action="list", directory=loc.directory, filter="#loc.file#.*");

			// only extract the extension if we find a single match
			if (loc.match.recordCount == 1)
			{
				loc.file &= "." & ListLast(loc.match.name, ".");
				loc.fullPath = loc.directory & "/" & loc.file;
			}
			else
			{
				$throw(type="Wheels.FileNotFound", message="A file could not be found.", extendedInfo="Make sure a file with the name `#loc.file#` exists in the `#loc.directory#` folder.");
			}
		}

		loc.name = loc.file;
		loc.extension = ListLast(loc.file, ".");

		// replace the display name for the file if supplied
		if (Len(arguments.name))
		{
			loc.name = arguments.name;
		}

		loc.mime = arguments.type;
		if (!Len(loc.mime))
		{
			loc.mime = mimeTypes(loc.extension);
		}

		// if testing, return the variables
		if (arguments.$testingMode)
		{
			StructAppend(loc, arguments, false);
			loc.rv = loc;
		}
		else
		{
			// prompt the user to download the file
			$header(name="content-disposition", value="#arguments.disposition#; filename=""#loc.name#""");
			$content(type=loc.mime, file=loc.fullPath, deleteFile=arguments.deleteFile);
		}
	</cfscript>
	<cfif StructKeyExists(loc, "rv")>
		<cfreturn loc.rv>
	</cfif>
</cffunction>

<cffunction name="isSecure" returntype="boolean" access="public" output="false">
	<cfscript>
		var loc = {};
		if (request.cgi.server_port_secure == "true")
		{
			loc.rv = true;
		}
		else
		{
			loc.rv = false;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="isAjax" returntype="boolean" access="public" output="false">
	<cfscript>
		var loc = {};
		if (request.cgi.http_x_requested_with == "XMLHTTPRequest")
		{
			loc.rv = true;
		}
		else
		{
			loc.rv = false;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="isGet" returntype="boolean" access="public" output="false">
	<cfscript>
		var loc = {};
		if (request.cgi.request_method == "get")
		{
			loc.rv = true;
		}
		else
		{
			loc.rv = false;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="isPost" returntype="boolean" access="public" output="false">
	<cfscript>
		var loc = {};
		if (request.cgi.request_method == "post")
		{
			loc.rv = true;
		}
		else
		{
			loc.rv = false;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>