<!--- PUBLIC VIEW HELPER FUNCTIONS --->

<cffunction name="errorMessagesFor" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="string" required="true">
	<cfargument name="class" type="string" required="false">
	<cfargument name="showDuplicates" type="boolean" required="false">
	<cfscript>
		var loc = {};
		$args(name="errorMessagesFor", args=arguments);
		loc.object = $getObject(arguments.objectName);
		if (get("showErrorInformation") && !IsObject(loc.object))
		{
			$throw(type="Wheels.IncorrectArguments", message="The `#arguments.objectName#` variable is not an object.");
		}
		loc.errors = loc.object.allErrors();
		loc.rv = "";
		if (!ArrayIsEmpty(loc.errors))
		{
			loc.used = "";
			loc.listItems = "";
			loc.iEnd = ArrayLen(loc.errors);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.msg = loc.errors[loc.i].message;
				if (arguments.showDuplicates)
				{
					loc.listItems &= $element(name="li", content=loc.msg);
				}
				else
				{
					if (!ListFind(loc.used, loc.msg, Chr(7)))
					{
						loc.listItems &= $element(name="li", content=loc.msg);
						loc.used = ListAppend(loc.used, loc.msg, Chr(7));
					}
				}
			}
			loc.rv = $element(name="ul", skip="objectName,showDuplicates", content=loc.listItems, attributes=arguments);
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="errorMessageOn" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="string" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="prependText" type="string" required="false">
	<cfargument name="appendText" type="string" required="false">
	<cfargument name="wrapperElement" type="string" required="false">
	<cfargument name="class" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="errorMessageOn", args=arguments);
		loc.object = $getObject(arguments.objectName);
		if (get("showErrorInformation") && !IsObject(loc.object))
		{
			$throw(type="Wheels.IncorrectArguments", message="The `#arguments.objectName#` variable is not an object.");
		}
		loc.error = loc.object.errorsOn(arguments.property);
		loc.rv = "";
		if (!ArrayIsEmpty(loc.error))
		{
			loc.content = arguments.prependText & loc.error[1].message & arguments.appendText;
			loc.rv = $element(name=arguments.wrapperElement, skip="objectName,property,prependText,appendText,wrapperElement", content=loc.content, attributes=arguments);
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>