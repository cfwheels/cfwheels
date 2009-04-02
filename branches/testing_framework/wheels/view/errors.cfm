<cffunction name="errorMessagesFor" returntype="string" access="public" output="false" hint="Builds and returns a list (`ul` tag with a class of `error-messages`) containing all the error messages for all the properties of the object.">
	<cfargument name="objectName" type="string" required="true" hint="The variable name of the object to display error messages for">
	<cfargument name="class" type="string" required="false" default="#application.wheels.errorMessagesFor.class#" hint="CSS class to set on the `ul` element">
	<cfscript>
		var loc = {};
		arguments = $insertDefaults(name="errorMessagesFor", input=arguments);
		loc.object = Evaluate(arguments.objectName);
		loc.errors = loc.object.allErrors();
		loc.returnValue = "";
		if (!ArrayIsEmpty(loc.errors))
		{
			loc.listItems = "";
			loc.iEnd = ArrayLen(loc.errors);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.listItems = loc.listItems & $element(name="li", content=loc.errors[loc.i].message);			
			}
			loc.returnValue = $element(name="ul", skip="objectName", content=loc.listItems, attributes=arguments);			
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="errorMessageOn" returntype="string" access="public" output="false" hint="Returns the error message, if one exists, on the object's property. If multiple error messages exists, the first one is returned.">
	<cfargument name="objectName" type="string" required="true" hint="The variable name of the object to display the error message for">
	<cfargument name="property" type="string" required="true" hint="The name of the property (database column) to display the error message for">
	<cfargument name="prependText" type="string" required="false" default="#application.wheels.errorMessageOn.prependText#" hint="String to prepend to the error message">
	<cfargument name="appendText" type="string" required="false" default="#application.wheels.errorMessageOn.appendText#" hint="String to append to the error message">
	<cfargument name="wrapperElement" type="string" required="false" default="#application.wheels.errorMessageOn.wrapperElement#" hint="HTML element to wrap the error message in">
	<cfargument name="class" type="string" required="false" default="#application.wheels.errorMessageOn.class#" hint="CSS class to set on the wrapper element">
	<cfscript>
		var loc = {};
		arguments = $insertDefaults(name="errorMessageOn", input=arguments);
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