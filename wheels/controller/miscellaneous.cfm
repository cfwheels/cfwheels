<!--- PUBLIC CONTROLLER REQUEST FUNCTIONS --->

<cffunction name="$callAction" returntype="void" access="public" output="false">
	<cfargument name="action" type="string" required="true">
	<cfscript>
		var loc = {};

		if (Left(arguments.action, 1) == "$" || ListFindNoCase(application.wheels.protectedControllerMethods, arguments.action))
			$throw(type="Wheels.ActionNotAllowed", message="You are not allowed to execute the `#arguments.action#` method as an action.", extendedInfo="Make sure your action does not have the same name as any of the built-in Wheels functions.");

		if (StructKeyExists(this, arguments.action) && IsCustomFunction(this[arguments.action])) 
		{
			$invoke(method=arguments.action);
		} 
		else if (StructKeyExists(this, "onMissingMethod") && IsCustomFunction(this[arguments.action]))
		{
			loc.argumentCollection = {};
			loc.argumentCollection.missingMethodName = arguments.action;
			loc.argumentCollection.missingMethodArguments = {};
			$invoke(method="onMissingMethod", argumentCollection=loc.argumentCollection);
		}
		if (!StructKeyExists(request.wheels, "response"))
		{
			// a render function has not been called yet so call it here
			try
			{
				renderPage();
			}
			catch(Any e)
			{
				if (FileExists(ExpandPath("#application.wheels.viewPath#/#LCase(variables.wheels.name)#/#LCase(arguments.action)#.cfm")))
				{
					$throw(object=e);
				}
				else
				{
					if (application.wheels.showErrorInformation)
					{
						$throw(type="Wheels.ViewNotFound", message="Could not find the view page for the `#arguments.action#` action in the `#variables.wheels.name#` controller.", extendedInfo="Create a file named `#LCase(arguments.action)#.cfm` in the `views/#LCase(variables.wheels.name)#` directory (create the directory as well if it doesn't already exist).");
					}
					else
					{
						$header(statusCode="404", statusText="Not Found");
						$includeAndOutput(template="#application.wheels.eventPath#/onmissingtemplate.cfm");
						$abort();
					}
				}
			}
		}
	</cfscript>
</cffunction>

<cffunction name="controllerName" returntype="string" access="public" output="false" hint="Returns the name of the controller.">
	<cfreturn variables.wheels.name />
</cffunction>

<cffunction name="isSecure" returntype="boolean" access="public" output="false" hint="Returns whether wheels is communicating over a secure port."
	examples=
	'
		<cfset requestIsSecure = isSecure()>
	'
	categories="controller-request,miscellaneous" chapters="" functions="isGet,isPost,isAjax">
	<cfscript>
		var returnValue = "";
		if (request.cgi.server_port_secure == true)
			returnValue = true;
		else
			returnValue = false;
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="isAjax" returntype="boolean" access="public" output="false" hint="Returns whether the page was called from JavaScript or not."
	examples=
	'
		<cfset requestIsAjax = isAjax()>
	'
	categories="controller-request,miscellaneous" chapters="" functions="isGet,isPost,isSecure">
	<cfscript>
		var returnValue = "";
		if (request.cgi.http_x_requested_with == "XMLHTTPRequest")
			returnValue = true;
		else
			returnValue = false;
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="isGet" returntype="boolean" access="public" output="false" hint="Returns whether the request was a normal (GET) request or not."
	examples=
	'
		<cfset requestIsGet = isGet()>
	'
	categories="controller-request,miscellaneous" chapters="" functions="isAjax,isPost,isSecure">
	<cfscript>
		var returnValue = "";
		if (request.cgi.request_method == "get")
			returnValue = true;
		else
			returnValue = false;
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="isPost" returntype="boolean" access="public" output="false" hint="Returns whether the request came from a form submission or not."
	examples=
	'
		<cfset requestIsPost = isPost()>
	'
	categories="controller-request,miscellaneous" chapters="" functions="isAjax,isGet,isSecure">
	<cfscript>
		var returnValue = "";
		if (request.cgi.request_method == "post")
			returnValue = true;
		else
			returnValue = false;
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="pagination" returntype="struct" access="public" output="false" hint="Returns a struct with information about the specificed paginated query. The variables that will be returned are `currentPage`, `totalPages` and `totalRecords`."
	examples=
	'
		<cfparam name="params.page" default="1">
		<cfset allAuthors = model("author").findAll(page=params.page, perPage=25, order="lastName", handle="authorsData")>
		<cfset paginationData = pagination("authorsData")>
	'
	categories="controller-request,miscellaneous" chapters="getting-paginated-data,displaying-links-for-pagination" functions="paginationLinks,findAll">
	<cfargument name="handle" type="string" required="false" default="query" hint="The handle given to the query to return pagination information for.">
	<cfscript>
		if (application.wheels.showErrorInformation)
		{
			if (!StructKeyExists(request.wheels, arguments.handle))
			{
				$throw(type="Wheels.QueryHandleNotFound", message="Wheels couldn't find a query with the handle of `#arguments.handle#`.", extendedInfo="Make sure your `findAll` call has the `page` argument specified and matching `handle` argument if specified.");
			}
		}
	</cfscript>
	<cfreturn request.wheels[arguments.handle]>
</cffunction>

<cffunction name="sendEmail" returntype="any" access="public" output="false" hint="Sends an email using a template and an optional layout to wrap it in. Besides the Wheels specific arguments you can also pass in any argument that is accepted by the `cfmail` tag."
	examples=
	'
		<!--- Get a member and send a welcome email passing in a few custom variables to the template --->
		<cfset newMember = model("member").findByKey(params.key)>
		<cfset sendEmail(to=newMember.email, template="myemailtemplate", subject="Thank You for Becoming a Member", recipientName=newMember.name, startDate=newMember.startDate)>
	'
	categories="controller-request,miscellaneous" chapters="sending-email" functions="">
	<cfargument name="template" type="string" required="false" default="" hint="The path to the email template or two paths if you want to send a multipart email. if the `detectMultipart` argument is `false` the template for the text version should be the first one in the list. This argument is also aliased as `templates`.">
	<cfargument name="from" type="string" required="true" hint="Email address to send from.">
	<cfargument name="to" type="string" required="true" hint="Email address to send to.">
	<cfargument name="subject" type="string" required="true" hint="The subject line of the email.">
	<cfargument name="layout" type="any" required="false" hint="Layout(s) to wrap the email template in. This argument is also aliased as `layouts`.">
	<cfargument name="file" type="string" required="false" default="" hint="The name(s) of the file(s) to attach to the email. This argument is also aliased as `files`.">
	<cfargument name="detectMultipart" type="boolean" required="false" hint="When set to `true` and multiple templates are passed in Wheels will detect which of the templates is text and which one is HTML (by counting the `<` characters).">
	<cfargument name="$deliver" type="boolean" required="false" default="true">
	<cfscript>
		var loc = {};
		$args(args=arguments, name="sendEmail", combine="template/templates/!,layout/layouts,file/files");

		loc.nonPassThruArgs = "template,templates,layout,layouts,file,files,detectMultipart,$deliver";
		loc.mailTagArgs = "from,to,bcc,cc,charset,debug,failto,group,groupcasesensitive,mailerid,maxrows,mimeattach,password,port,priority,query,replyto,server,spoolenable,startrow,subject,timeout,type,username,useSSL,useTLS,wraptext";
		loc.deliver = arguments.$deliver;

		// if two templates but only one layout was passed in we set the same layout to be used on both
		if (ListLen(arguments.template) > 1 && ListLen(arguments.layout) == 1)
			arguments.layout = ListAppend(arguments.layout, arguments.layout);

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
			loc.content = $renderPage($template=ListGetAt(arguments.template, loc.i), $layout=ListGetAt(arguments.layout, loc.i));
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
					ArrayPrepend(arguments.mailparts, loc.mailpart);
				else
					ArrayAppend(arguments.mailparts, loc.mailpart);
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
					arguments.type = "html";
				else
					arguments.type = "text";
			}
		}

		// attach files using the cfmailparam tag
		if (Len(arguments.file))
		{
			arguments.mailparams = [];
			loc.iEnd = ListLen(arguments.file);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				arguments.mailparams[loc.i] = {};
				arguments.mailparams[loc.i].file = ExpandPath(application.wheels.filePath) & "/" & ListGetAt(arguments.file, loc.i);
			}
		}

		// delete arguments that we don't want to pass through to the cfmail tag
		loc.iEnd = ListLen(loc.nonPassThruArgs);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			StructDelete(arguments, ListGetAt(loc.nonPassThruArgs, loc.i));
		
		// send the email using the cfmail tag
		if (loc.deliver)
			$mail(argumentCollection=arguments);
		else
			return arguments;
	</cfscript>
</cffunction>

<cffunction name="sendFile" returntype="any" access="public" output="false" hint="Sends a file to the user (from the `files` folder by default)."
	examples=
	'
		<!--- Send a PDF file to the user --->
		<cfset sendFile(file="wheels_tutorial_20081028_J657D6HX.pdf")>

		<!--- Send the same file but give the user a different name in the browser dialog window --->
		<cfset sendFile(file="wheels_tutorial_20081028_J657D6HX.pdf", name="Tutorial.pdf")>

		<!--- Send a file that is located outside of the web root --->
		<cfset sendFile(file="../../tutorials/wheels_tutorial_20081028_J657D6HX.pdf")>
	'
	categories="controller-request,miscellaneous" chapters="sending-files" functions="">
	<cfargument name="file" type="string" required="true" hint="The file to send to the user">
	<cfargument name="name" type="string" required="false" default="" hint="The file name to show in the browser download dialog box">
	<cfargument name="type" type="string" required="false" default="" hint="The HTTP content type to deliver the file as">
	<cfargument name="disposition" type="string" required="false" hint="Set to 'inline' to have the browser handle the opening of the file or set to 'attachment' to force a download dialog box">
	<cfargument name="directory" type="string" required="false" default="" hint="directory outside of the webroot where the file exists. must be a fully path">
	<cfargument name="deleteFile" type="boolean" required="false" default="false" hint="should we delete the file after sending it.">
	<cfargument name="$testingMode" type="boolean" required="false" default="false">
	<cfscript>
		var loc = {};
		$insertDefaults(name="sendFile", input=arguments);

		loc.folder = arguments.directory;
		if (!Len(loc.folder))
		{
			loc.folder = ExpandPath(application.wheels.filePath);
		}

		loc.folder = Replace(loc.folder, "\", "/", "all");
		loc.file = Replace(arguments.file, "\", "/", "all");

		// extract the path from the file name
		if (loc.file contains "/")
		{
			loc.path = Reverse(ListRest(Reverse(loc.file), "/"));
			loc.folder = loc.folder & "/" & loc.path;
			loc.file = Replace(loc.file, loc.path, "");
			loc.file = Right(loc.file, Len(loc.file)-1);
		}

		loc.fullPath = loc.folder & "/" & loc.file;

		// if the file is not found, try searching for it
		if (!FileExists(loc.fullPath))
		{
			loc.match = $directory(action="list", directory="#loc.folder#", filter="#loc.file#.*");
			// only extract the extension if we find a single match
			if (loc.match.recordCount == 1)
			{
				loc.file = loc.file & "." & ListLast(loc.match.name, ".");
				loc.fullPath = loc.folder & "/" & loc.file;
			}
			else
			{
				$throw(type="Wheels.FileNotFound", message="A file could not be found.", extendedInfo="Make sure a file with the name `#loc.file#` exists in the `#loc.folder#` folder.");
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

		// if testing, return the varaibles
		if (arguments.$testingMode)
		{
			StructAppend(loc, arguments, false);
			return loc;
		}

		// prompt the user to download the file
		$header(name="content-disposition", value="#arguments.disposition#; filename='#loc.name#'");
		$content(type="#loc.mime#", file="#loc.fullPath#", deleteFile="#arguments.deleteFile#");
	</cfscript>
</cffunction>