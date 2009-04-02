<cffunction name="linkTo" returntype="string" access="public" output="false" hint="Creates a link to another page in your application. Pass in a route name to use your configured routes or a controller/action/key combination.">
	<cfargument name="text" type="string" required="false" default="" hint="The text content of the link">
	<cfargument name="confirm" type="string" required="false" default="" hint="Pass a message here to cause a JavaScript confirmation dialog box to pop up containing the message">
	<cfargument name="route" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="controller" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="action" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="key" type="any" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="params" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="anchor" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="onlyPath" type="boolean" required="false" default="#application.wheels.linkTo.onlyPath#" hint="See documentation for `URLFor`">
	<cfargument name="host" type="string" required="false" default="#application.wheels.linkTo.host#" hint="See documentation for `URLFor`">
	<cfargument name="protocol" type="string" required="false" default="#application.wheels.linkTo.protocol#" hint="See documentation for `URLFor`">
	<cfargument name="port" type="numeric" required="false" default="#application.wheels.linkTo.port#" hint="See documentation for `URLFor`">
	<cfscript>
		var loc = {};
		arguments = $insertDefaults(name="linkTo", reserved="href", input=arguments);
		if (Len(arguments.confirm))
		{
			loc.onclick = "return confirm('#arguments.confirm#');";
			arguments.onclick = $addToJavaScriptAttribute(name="onclick", content=loc.onclick, attributes=arguments);
		}
		arguments.href = URLFor(argumentCollection=arguments);
		arguments.href = Replace(arguments.href, "&", "&amp;", "all"); // make sure we return XHMTL compliant code
		if (!Len(arguments.text))
			arguments.text = arguments.href;
		loc.returnValue = $element(name="a", skip="text,confirm,route,controller,action,key,params,anchor,onlyPath,host,protocol,port", content=arguments.text, attributes=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="buttonTo" returntype="string" access="public" output="false" hint="Creates a form containing a single button that submits to the URL. The URL is built the same way as the `linkTo` function.">
	<cfargument name="text" type="string" required="false" default="#application.wheels.buttonTo.text#" hint="See documentation for `linkTo`">
	<cfargument name="confirm" type="string" required="false" default="#application.wheels.buttonTo.confirm#" hint="See documentation for `linkTo`">
	<cfargument name="image" type="string" required="false" default="#application.wheels.buttonTo.image#" hint="If you want to use an image for the button pass in the link to it here (relative from the `images` folder)">
	<cfargument name="disable" type="any" required="false" default="#application.wheels.buttonTo.disable#" hint="Pass in `true` if you want the button to be disabled when clicked (can help prevent multiple clicks) or pass in a string if you want the button disabled and the text on the button updated (to 'please wait...' for example)">
	<cfargument name="route" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="controller" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="action" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="key" type="any" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="params" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="anchor" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="onlyPath" type="boolean" required="false" default="#application.wheels.buttonTo.onlyPath#" hint="See documentation for `URLFor`">
	<cfargument name="host" type="string" required="false" default="#application.wheels.buttonTo.host#" hint="See documentation for `URLFor`">
	<cfargument name="protocol" type="string" required="false" default="#application.wheels.buttonTo.protocol#" hint="See documentation for `URLFor`">
	<cfargument name="port" type="numeric" required="false" default="#application.wheels.buttonTo.port#" hint="See documentation for `URLFor`">
	<cfscript>
		var loc = {};
		arguments = $insertDefaults(name="buttonTo", reserved="method", input=arguments);
		arguments.action = URLFor(argumentCollection=arguments);
		arguments.action = Replace(arguments.action, "&", "&amp;", "all"); // make sure we return XHMTL compliant code
		arguments.method = "post";
		if (Len(arguments.confirm))
		{
			loc.onsubmit = "return confirm('#JSStringFormat(Replace(arguments.confirm, """", '&quot;', 'all'))#');";
			arguments.onsubmit = $addToJavaScriptAttribute(name="onsubmit", content=loc.onsubmit, attributes=arguments);
		}
		loc.content = submitTag(value=arguments.text, image=arguments.image, disable=arguments.disable);
		loc.returnValue = $element(name="form", skip="disable,image,text,confirm,route,controller,key,params,anchor,onlyPath,host,protocol,port", content=loc.content, attributes=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>
