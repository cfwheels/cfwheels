<cffunction name="dateSelect" returntype="string" access="public" output="false" hint="Builds and returns a string containing three select form controls for a date based on the supplied `objectName` and `property`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		  <p>##dateSelect(objectName="user", property="dateOfBirth")##</p>
		</cfoutput>
	'
	categories="view-helper,forms-object" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,textField,submitTag,radioButton,checkBox,passwordField,hiddenField,textArea,fileField,select,dateTimeSelect,timeSelect">
	<cfargument name="objectName" type="any" required="false" default="" hint="See documentation for @textField.">
	<cfargument name="property" type="string" required="false" default="" hint="See documentation for @textField.">
	<cfargument name="order" type="string" required="false" default="#application.wheels.functions.dateSelect.order#" hint="Use to change the order of or exclude date select tags.">
	<cfargument name="separator" type="string" required="false" default="#application.wheels.functions.dateSelect.separator#" hint="Use to change the character that is displayed between the date select tags.">
	<cfargument name="startYear" type="numeric" required="false" default="#application.wheels.functions.dateSelect.startYear#" hint="First year in select list.">
	<cfargument name="endYear" type="numeric" required="false" default="#application.wheels.functions.dateSelect.endYear#" hint="Last year in select list.">
	<cfargument name="monthDisplay" type="string" required="false" default="#application.wheels.functions.dateSelect.monthDisplay#" hint="Pass in `names`, `numbers` or `abbreviations` to control display.">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.dateSelect.includeBlank#" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.dateSelect.label#" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.dateSelect.labelPlacement#" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.dateSelect.prepend#" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.dateSelect.append#" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.dateSelect.prependToLabel#" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.dateSelect.appendToLabel#" hint="See documentation for @textField.">
	<cfargument name="errorElement" type="string" required="false" default="#application.wheels.functions.dateSelect.errorElement#" hint="See documentation for @textField.">
	<cfscript>
		$insertDefaults(name="dateSelect", input=arguments);
		arguments.$functionName = "dateSelect";
	</cfscript>
	<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="timeSelect" returntype="string" access="public" output="false" hint="Builds and returns a string containing three select form controls for a time based on the supplied `objectName` and `property`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##timeSelect(objectName="business", property="openUntil")##</p>
		</cfoutput>
	'
	categories="view-helper,forms-object" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textField,radioButton,checkBox,passwordField,hiddenField,textArea,fileField,select,dateTimeSelect,dateSelect">
	<cfargument name="objectName" type="any" required="false" default="" hint="See documentation for @textField.">
	<cfargument name="property" type="string" required="false" default="" hint="See documentation for @textField.">
	<cfargument name="order" type="string" required="false" default="#application.wheels.functions.timeSelect.order#" hint="Use to change the order of or exclude time select tags.">
	<cfargument name="separator" type="string" required="false" default="#application.wheels.functions.timeSelect.separator#" hint="Use to change the character that is displayed between the time select tags.">
	<cfargument name="minuteStep" type="numeric" required="false" default="#application.wheels.functions.timeSelect.minuteStep#" hint="Pass in `10` to only show minute 10, 20,30 etc.">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.timeSelect.includeBlank#" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.timeSelect.label#" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.timeSelect.labelPlacement#" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.timeSelect.prepend#" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.timeSelect.append#" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.timeSelect.prependToLabel#" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.timeSelect.appendToLabel#" hint="See documentation for @textField.">
	<cfargument name="errorElement" type="string" required="false" default="#application.wheels.functions.timeSelect.errorElement#" hint="See documentation for @textField.">
	<cfscript>
		$insertDefaults(name="timeSelect", input=arguments);
		arguments.$functionName = "timeSelect";
	</cfscript>
	<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="dateTimeSelect" returntype="string" access="public" output="false" hint="Builds and returns a string containing six select form controls (three for date selection and the remaining three for time selection) based on the supplied `objectName` and `property`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##dateTimeSelect(objectName="article", property="publishedAt")##</p>
		</cfoutput>
	'
	categories="view-helper,forms-object" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textField,radioButton,checkBox,passwordField,hiddenField,textArea,fileField,select,dateSelect,timeSelect">
	<cfargument name="objectName" type="string" required="true" hint="See documentation for @textField.">
	<cfargument name="property" type="string" required="true" hint="See documentation for @textField.">
	<cfargument name="dateOrder" type="string" required="false" default="#application.wheels.functions.dateTimeSelect.dateOrder#" hint="See documentation for @dateSelect.">
	<cfargument name="dateSeparator" type="string" required="false" default="#application.wheels.functions.dateTimeSelect.dateSeparator#" hint="See documentation for @dateSelect.">
	<cfargument name="startYear" type="numeric" required="false" default="#application.wheels.functions.dateTimeSelect.startYear#" hint="See documentation for @dateSelect.">
	<cfargument name="endYear" type="numeric" required="false" default="#application.wheels.functions.dateTimeSelect.endYear#" hint="See documentation for @dateSelect.">
	<cfargument name="monthDisplay" type="string" required="false" default="#application.wheels.functions.dateTimeSelect.monthDisplay#" hint="See documentation for @dateSelect.">
	<cfargument name="timeOrder" type="string" required="false" default="#application.wheels.functions.dateTimeSelect.timeOrder#" hint="See documentation for @timeSelect.">
	<cfargument name="timeSeparator" type="string" required="false" default="#application.wheels.functions.dateTimeSelect.timeSeparator#" hint="See documentation for @timeSelect.">
	<cfargument name="minuteStep" type="numeric" required="false" default="#application.wheels.functions.dateTimeSelect.minuteStep#" hint="See documentation for @timeSelect.">
	<cfargument name="separator" type="string" required="false" default="#application.wheels.functions.dateTimeSelect.separator#" hint="Use to change the character that is displayed between the first and second set of select tags.">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.dateTimeSelect.includeBlank#" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.dateTimeSelect.label#" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.dateTimeSelect.labelPlacement#" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.dateTimeSelect.prepend#" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.dateTimeSelect.append#" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.dateTimeSelect.prependToLabel#" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.dateTimeSelect.appendToLabel#" hint="See documentation for @textField.">
	<cfargument name="errorElement" type="string" required="false" default="#application.wheels.functions.dateTimeSelect.errorElement#" hint="See documentation for @textField.">
	<cfscript>
		$insertDefaults(name="dateTimeSelect", reserved="name", input=arguments);
		arguments.name = $tagName(arguments.objectName, arguments.property);
		arguments.$functionName = "dateTimeSelect";
	</cfscript>
	<cfreturn dateTimeSelectTags(argumentCollection=arguments)>
</cffunction>