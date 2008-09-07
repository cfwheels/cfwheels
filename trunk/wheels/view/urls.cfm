<cffunction name="linkTo" returntype="string" access="public" output="false" hint="View, Helper, Creates a link to another page in your application or externally. Pass in a route name to use your configured routes, controller/action/id to use that Wheels convention or the URL itself.">
	<cfargument name="url" type="string" required="false" default="" hint="If linking to a direct URL, pass in that URL here. This is especially useful for external links or links to non-Wheels application pages. The URL can be absolute, document relative, or site root relative.">
	<cfargument name="text" type="string" required="false" default="" hint="The text content of the link. For all intents and purposes, the blue underlined text.">
	<cfargument name="confirm" type="string" required="false" default="" hint="Pass a message here to cause a JavaScript confirmation dialogue box to pop up containing the message.">
	<cfargument name="route" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="controller" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="action" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="id" type="numeric" required="false" default="0" hint="See documentation for URLFor">
	<cfargument name="params" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="anchor" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="onlyPath" type="boolean" required="false" default="true" hint="See documentation for URLFor">
	<cfargument name="host" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="protocol" type="string" required="false" default="" hint="See documentation for URLFor">

	<!---
		EXAMPLES:
		#linkTo(text="Log Out", controller="account", action="logOut")#
		-> <a href="/account/logout">Log Out</a>

		#linkTo(text="Log Out", action="logOut")#
		-> <a href="/account/logout">Log Out</a> (if you're already in the "account" controller Wheels will assume that's where you want the link to go.)

		#linkTo(text="View Post", controller="blog" action="post", id=99)#
		-> <a href="/blog/post/99">View Post</a>

		#linkTo(text="View Settings", action="settings", params="show=all&sort=asc")#
		-> <a href="/account/settings?show=all&sort=asc">View Settings</a>

		#linkTo(text="Joe's Profile", route="userProfile", userName="joe")#
		-> <a href="/user/joe">Joe's Profile</a> (given that a "userProfile" route has been configured in "config/routes.cfm".)

		#linkTo(url="http://www.google.com", text="Google")#
		-> <a href="http://www.google.com">Google</a>

		#linkTo("http://www.google.com")#
		-> <a href="http://www.google.com">http://www.google.com</a> (When leaving out the text argument Wheels will use the link as the text as well.)

		RELATED:
		 * [linkingPages] (chapter)
		 * [buttonTo buttonTo()] (function)
		 * [linkToUnlessCurrent linkToUnlessCurrent()] (function)
		 * [URLFor URLFor()] (function)
	--->

	<cfscript>
		var loc = {};
		arguments.$namedArguments = "url,text,confirm,route,controller,action,id,params,anchor,onlyPath,host,protocol";
		loc.attributes = $getAttributes(argumentCollection=arguments);
		if (Len(arguments.url) IS NOT 0)
			loc.href = arguments.url;
		else
			loc.href = URLFor(argumentCollection=arguments);
		if (Len(arguments.text) IS 0)
			arguments.text = loc.href;
		if (Len(arguments.confirm) IS NOT 0)
			loc.confirm = " onclick=""return confirm('#arguments.confirm#')"" ";
		else
			loc.confirm = "";
		loc.returnValue = "<a href=""" & loc.href & """" & loc.confirm & loc.attributes & ">" & arguments.text & "</a>";
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="buttonTo" returntype="string" access="public" output="false" hint="View, Helper, Creates a form containing a single button that submits to the URL. The URL is built the same way as the linkTo function.">
	<cfargument name="url" type="string" required="false" default="" hint="If linking to a direct URL, pass in that URL here.">
	<cfargument name="text" type="string" required="false" default="" hint="The text content of the link.">
	<cfargument name="confirm" type="string" required="false" default="" hint="Pass a message here to cause a JavaScript confirmation dialogue box to pop up containing the message.">
	<cfargument name="disable" type="any" required="false" default="" hint="Pass in true if you want the button to be disabled when clicked (can help prevent multiple clicks). Pass in a string if you want the button disabled and the text on the button updated (to 'please wait...' for example).">
	<cfargument name="source" type="string" required="false" default="" hint="If you want to use an image for the button pass in the link to it here (relative from the /images/ folder).">
	<cfargument name="route" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="controller" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="action" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="id" type="numeric" required="false" default="0" hint="See documentation for URLFor">
	<cfargument name="params" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="anchor" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="onlyPath" type="boolean" required="false" default="true" hint="See documentation for URLFor">
	<cfargument name="host" type="string" required="false" default="" hint="See documentation for URLFor">
	<cfargument name="protocol" type="string" required="false" default="" hint="See documentation for URLFor">

	<!---
		EXAMPLES:
		#buttonTo(action="delete", disabled="Wait...")#

		RELATED:
		 * [linkingPages] (chapter)
		 * [linkTo linkTo()] (function)
		 * [URLFor URLFor()] (function)
	--->

	<cfscript>
		var loc = {};
		arguments.$namedArguments = "url,text,confirm,disable,source,route,controller,action,id,params,anchor,onlyPath,host,protocol";
		loc.attributes = $getAttributes(argumentCollection=arguments);
		if (Len(arguments.url) IS NOT 0)
			loc.action = arguments.url;
		else
			loc.action = URLFor(argumentCollection=arguments);
		loc.returnValue = "<form";
		loc.returnValue = loc.returnValue & " action=""#loc.action#"" method=""post""";
		if (Len(arguments.confirm) != 0)
			loc.returnValue = loc.returnValue & " onsubmit=""return confirm('#JSStringFormat(Replace(arguments.confirm, """", '&quot;', 'all'))#');""";
		loc.returnValue = loc.returnValue & ">";
		loc.returnValue = loc.returnValue & "<input";
		if (Len(arguments.source) IS 0)
			loc.returnValue = loc.returnValue & " type=""submit""";
		else
			loc.returnValue = loc.returnValue & " type=""image"" src=""#application.wheels.webPath##application.wheels.imagePath#/#arguments.source#""";
		if (Len(arguments.text) IS NOT 0)
			loc.returnValue = loc.returnValue & " value=""#arguments.text#""";
		if (Len(arguments.disable) IS NOT 0)
		{
			loc.returnValue = loc.returnValue & " onclick=""this.disabled=true;";
			if (Len(arguments.source) IS 0 AND NOT IsBoolean(arguments.disable))
				loc.returnValue = loc.returnValue & "this.value='#arguments.disable#';";
			loc.returnValue = loc.returnValue & "this.form.submit();""";
		}
		loc.returnValue = loc.returnValue & "#loc.attributes# />";
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
		-
	--->

	<cfscript>
		var loc = {};
		loc.linkToArguments = {};
		loc.linkToArguments.url = "mailto:#arguments.emailAddress#";
		if (Len(arguments.name))
			loc.linkToArguments.text = arguments.name;
		else
			loc.linkToArguments.text = arguments.emailAddress;
		loc.returnValue = linkTo(argumentCollection=loc.linkToArguments);
		if (arguments.encode)
		{
			loc.js = "document.write('#trim(loc.returnValue)#');";
			loc.encoded = "";
			loc.iEnd = Len(loc.js);
			for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
			{
				loc.encoded = loc.encoded & "%" & Right("0" & formatBaseN(asc(Mid(loc.js,loc.i,1)),16),2);
			}
			loc.returnValue = "<script type=""text/javascript"" language=""javascript"">eval(unescape('#loc.encoded#'))</script>";

		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>
