<cffunction name="linkTo" returntype="string" access="public" output="false" hint="Creates a link to another page in your application. Pass in a route name to use your configured routes or a controller/action/key combination.">
	<cfargument name="text" type="string" required="false" default="" hint="The text content of the link">
	<cfargument name="confirm" type="string" required="false" default="" hint="Pass a message here to cause a JavaScript confirmation dialog box to pop up containing the message">
	<cfargument name="route" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="controller" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="action" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="key" type="any" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="params" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="anchor" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="onlyPath" type="boolean" required="false" default="true" hint="See documentation for `URLFor`">
	<cfargument name="host" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="protocol" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="port" type="numeric" required="false" default="0" hint="See documentation for `URLFor`">
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

<cffunction name="buttonTo" returntype="string" access="public" output="false" hint="Creates a form containing a single button that submits to the URL. The URL is built the same way as the `linkTo` function.">
	<cfargument name="disable" type="any" required="false" default="" hint="Pass in `true` if you want the button to be disabled when clicked (can help prevent multiple clicks) or pass in a string if you want the button disabled and the text on the button updated (to 'please wait...' for example)">
	<cfargument name="source" type="string" required="false" default="" hint="If you want to use an image for the button pass in the link to it here (relative from the `images` folder)">
	<cfargument name="text" type="string" required="false" default="" hint="See documentation for `linkTo`">
	<cfargument name="confirm" type="string" required="false" default="" hint="See documentation for `linkTo`">
	<cfargument name="route" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="controller" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="action" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="key" type="any" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="params" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="anchor" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="onlyPath" type="boolean" required="false" default="true" hint="See documentation for `URLFor`">
	<cfargument name="host" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="protocol" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="port" type="numeric" required="false" default="0" hint="See documentation for `URLFor`">
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
