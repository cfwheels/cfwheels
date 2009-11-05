<cffunction name="errorMessagesFor" returntype="string" access="public" output="false" hint="Builds and returns a list (`ul` tag with a class of `error-messages`) containing all the error messages for all the properties of the object, if any. Returns an empty string otherwise."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    ##errorMessageFor(objectName="user")##
		</cfoutput>
	'
	categories="view-helper,errors" chapters="form-helpers-and-showing-errors" functions="errorMessagesOn">
	<cfargument name="objectName" type="string" required="true" hint="The variable name of the object to display error messages for.">
	<cfargument name="class" type="string" required="false" default="#application.wheels.functions.errorMessagesFor.class#" hint="CSS class to set on the `ul` element.">
	<cfargument name="showDuplicates" type="boolean" required="false" default="#application.wheels.functions.errorMessagesFor.showDuplicates#" hint="Whether to show duplicate error messages.">
	<cfscript>
		var loc = {};
		$insertDefaults(name="errorMessagesFor", input=arguments);
		loc.object = Evaluate(arguments.objectName);
		loc.errors = loc.object.allErrors();
		loc.returnValue = "";
		if (!ArrayIsEmpty(loc.errors))
		{
			loc.used = "";
			loc.listItems = "";
			loc.iEnd = ArrayLen(loc.errors);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.msg = loc.errors[loc.i].message;
				if(arguments.showDuplicates)
				{
					loc.listItems = loc.listItems & $element(name="li", content=loc.msg);
				}
				else
				{
					if(!ListFind(loc.used, loc.msg, Chr(7)))
					{
						loc.listItems = loc.listItems & $element(name="li", content=loc.msg);
						loc.used = ListAppend(loc.used, loc.msg, Chr(7));
					}
				}		
			}
			loc.returnValue = $element(name="ul", skip="objectName,showDuplicates", content=loc.listItems, attributes=arguments);			
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="errorMessageOn" returntype="string" access="public" output="false" hint="Returns the error message, if one exists, on the object's property. If multiple error messages exists, the first one is returned."
	examples=
	'
	<!--- view code --->
	<cfoutput>
	    ##errorMessageFor(objectName="user", property="email")##
	</cfoutput>
	'
	categories="view-helper,errors" chapters="form-helpers-and-showing-errors" functions="errorMessagesOn">
	<cfargument name="objectName" type="string" required="true" hint="The variable name of the object to display the error message for.">
	<cfargument name="property" type="string" required="true" hint="The name of the property to display the error message for.">
	<cfargument name="prependText" type="string" required="false" default="#application.wheels.functions.errorMessageOn.prependText#" hint="String to prepend to the error message.">
	<cfargument name="appendText" type="string" required="false" default="#application.wheels.functions.errorMessageOn.appendText#" hint="String to append to the error message.">
	<cfargument name="wrapperElement" type="string" required="false" default="#application.wheels.functions.errorMessageOn.wrapperElement#" hint="HTML element to wrap the error message in.">
	<cfargument name="class" type="string" required="false" default="#application.wheels.functions.errorMessageOn.class#" hint="CSS class to set on the wrapper element.">
	<cfscript>
		var loc = {};
		$insertDefaults(name="errorMessageOn", input=arguments);
		loc.object = Evaluate(arguments.objectName);
		loc.error = loc.object.errorsOn(arguments.property);
		loc.returnValue = "";
		if (!ArrayIsEmpty(loc.error))
		{
			loc.content = arguments.prependText & loc.error[1].message & arguments.appendText;
			loc.returnValue = $element(name=arguments.wrapperElement, skip="objectName,property,prependText,appendText,wrapperElement", content=loc.content, attributes=arguments);
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>