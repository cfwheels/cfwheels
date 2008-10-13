<cffunction name="linkTo" returntype="string" access="public" output="false" hint="View, Helper, Creates a link to another page in your application. Pass in a route name to use your configured routes or a controller/action/key combination.">
	<cfargument name="text" type="string" required="false" default="" hint="The text content of the link.">
	<cfargument name="confirm" type="string" required="false" default="" hint="Pass a message here to cause a JavaScript confirmation dialogue box to pop up containing the message.">
	<cfargument name="route" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="controller" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="action" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="key" type="any" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="params" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="anchor" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="onlyPath" type="boolean" required="false" default="true" hint="See documentation for URLFor">
	<cfargument name="host" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="protocol" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="port" type="numeric" required="false" default="0" hint="See documentation for URLFor">

	<!---
		EXAMPLES:
		#linkTo(text="Log Out", controller="account", action="logOut")#
		-> <a href="/account/logout">Log Out</a>

		#linkTo(text="Log Out", action="logOut")#
		-> <a href="/account/logout">Log Out</a> (if you're already in the "account" controller Wheels will assume that's where you want the link to go.)

		#linkTo(text="View Post", controller="blog" action="post", key=99)#
		-> <a href="/blog/post/99">View Post</a>

		#linkTo(text="View Settings", action="settings", params="show=all&sort=asc")#
		-> <a href="/account/settings?show=all&sort=asc">View Settings</a>

		#linkTo(text="Joe's Profile", route="userProfile", userName="joe")#
		-> <a href="/user/joe">Joe's Profile</a> (given that a "userProfile" route has been configured in "config/routes.cfm".)

		RELATED:
		 * [LinkingPages Linking Pages] (chapter)
		 * [buttonTo buttonTo()] (function)
		 * [URLFor URLFor()] (function)
	--->

	<cfscript>
		var loc = {};
		if (application.settings.environment != "production")
		{
			if (StructKeyExists(arguments, "href"))
				$throw(type="Wheels.IncorrectArguments", message="The 'href' argument is not allowed.", extendedInfo="You can't pass in the 'href' argument since Wheels will determine what to place in the 'href' attribute based on a 'route' or a 'controller' / 'action' / 'key' combination.");
		}

		if (Len(arguments.confirm))
		{
			loc.str = "return confirm('#arguments.confirm#');";
			if (StructKeyExists(arguments, "onclick"))
				arguments.onclick = arguments.onclick & loc.str;
			else
				arguments.onclick = loc.str;
		}
		arguments.href = URLFor(argumentCollection=arguments);
		arguments.href = Replace(arguments.href, "&", "&amp;", "all"); // make sure we return XHMTL compliant code
		if (!Len(arguments.text))
			arguments.text = arguments.href;
		arguments.$namedArguments = "text,confirm,route,controller,action,key,params,anchor,onlyPath,host,protocol,port";
		loc.attributes = $getAttributes(argumentCollection=arguments);
		loc.returnValue = "<a" & loc.attributes & ">" & arguments.text & "</a>";
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="buttonTo" returntype="string" access="public" output="false" hint="View, Helper, Creates a form containing a single button that submits to the URL. The URL is built the same way as the linkTo function.">
	<cfargument name="text" type="string" required="false" default="" hint="The text content of the link.">
	<cfargument name="confirm" type="string" required="false" default="" hint="Pass a message here to cause a JavaScript confirmation dialogue box to pop up containing the message.">
	<cfargument name="disable" type="any" required="false" default="" hint="Pass in true if you want the button to be disabled when clicked (can help prevent multiple clicks). Pass in a string if you want the button disabled and the text on the button updated (to 'please wait...' for example).">
	<cfargument name="source" type="string" required="false" default="" hint="If you want to use an image for the button pass in the link to it here (relative from the /images/ folder).">
	<cfargument name="route" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="controller" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="action" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="key" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="params" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="anchor" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="onlyPath" type="boolean" required="false" default="true" hint="See documentation for URLFor">
	<cfargument name="host" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="protocol" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="port" type="numeric" required="false" default="0" hint="See documentation for URLFor">

	<!---
		EXAMPLES:
		#buttonTo(text="Delete Account", action="perFormDelete", disabled="Wait...")#

		RELATED:
		 * [LinkingPages Linking Pages] (chapter)
		 * [linkTo linkTo()] (function)
		 * [URLFor URLFor()] (function)
	--->

	<cfscript>
		var loc = {};

		arguments.action = URLFor(argumentCollection=arguments);
		arguments.action = Replace(arguments.action, "&", "&amp;", "all"); // make sure we return XHMTL compliant code
		arguments.method = "post";
		if (Len(arguments.confirm))
		{
			loc.str = "return confirm('#JSStringFormat(Replace(arguments.confirm, """", '&quot;', 'all'))#');";
			if (StructKeyExists(arguments, "onsubmit"))
				arguments.onsubmit = arguments.onsubmit & loc.str;
			else
				arguments.onsubmit = loc.str;
		}
		arguments.$namedArguments = "text,confirm,disable,source,route,controller,key,params,anchor,onlyPath,host,protocol,port";
		loc.attributes = $getAttributes(argumentCollection=arguments);
		loc.returnValue = "<form";
		loc.returnValue = loc.returnValue & loc.attributes;
		loc.returnValue = loc.returnValue & ">";
		loc.returnValue = loc.returnValue & "<input";
		if (Len(arguments.source))
			loc.returnValue = loc.returnValue & " type=""image"" src=""#application.wheels.webPath##application.wheels.imagePath#/#arguments.source#""";
		else
			loc.returnValue = loc.returnValue & " type=""submit""";
		if (Len(arguments.text))
			loc.returnValue = loc.returnValue & " value=""#arguments.text#""";
		if (Len(arguments.disable))
		{
			loc.returnValue = loc.returnValue & " onclick=""this.disabled=true;";
			if (!Len(arguments.source) && !IsBoolean(arguments.disable))
				loc.returnValue = loc.returnValue & "this.value='#arguments.disable#';";
			loc.returnValue = loc.returnValue & "this.form.submit();""";
		}
		loc.returnValue = loc.returnValue & " />";
		loc.returnValue = loc.returnValue & "</form>";
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="mailTo" returntype="string" access="public" output="false" hint="View, Helper, Creates a mailto link tag to the specified email address, which is also used as the name of the link unless name is specified.">
	<cfargument name="emailAddress" type="string" required="true" hint="The email address to link to.">
	<cfargument name="name" type="string" required="false" default="" hint="A string to use as the link text ('Joe' or 'Support Department' for example)">
	<cfargument name="encode" type="boolean" required="false" default="false" hint="Pass true here to encode the email address, making it harder for bots to harvest it.">

	<!---
		EXAMPLES:
		#mailTo("support@mysite.com")#

		#mailTo(emailAddress="support@mysite.com", name="Website Support", encode=true)#

		RELATED:
		 * [linkTo linkTo()] (function)
	--->

	<cfscript>
		var loc = {};
		arguments.href = "mailto:#arguments.emailAddress#";
		if (Len(arguments.name))
			loc.text = arguments.name;
		else
			loc.text = arguments.emailAddress;
		arguments.$namedArguments = "emailAddress,name,encode";
		loc.attributes = $getAttributes(argumentCollection=arguments);
		loc.returnValue = "<a" & loc.attributes & ">" & loc.text & "</a>";
		if (arguments.encode)
		{
			loc.js = "document.write('#Trim(loc.returnValue)#');";
			loc.encoded = "";
			loc.iEnd = Len(loc.js);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.encoded = loc.encoded & "%" & Right("0" & FormatBaseN(Asc(Mid(loc.js,loc.i,1)),16),2);
			}
			loc.returnValue = "<script type=""text/javascript"" language=""javascript"">eval(unescape('#loc.encoded#'))</script>";
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>
