<cffunction name="dateSelectTags" returntype="string" access="public" output="false" hint="Builds and returns a string containing three select form controls (month, day and year)."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##dateSelectTags()##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,textFieldTag,submitTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="date" required="false" default="#Now()#" hint="See documentation for @selectTag.">
	<cfargument name="order" type="string" required="false" default="#application.wheels.functions.dateSelectTags.order#" hint="See documentation for @dateSelect.">
	<cfargument name="separator" type="string" required="false" default="#application.wheels.functions.dateSelectTags.separator#" hint="See documentation for @dateSelect.">
	<cfargument name="startYear" type="numeric" required="false" default="#application.wheels.functions.dateSelectTags.startYear#" hint="See documentation for @dateSelect.">
	<cfargument name="endYear" type="numeric" required="false" default="#application.wheels.functions.dateSelectTags.endYear#" hint="See documentation for @dateSelect.">
	<cfargument name="monthDisplay" type="string" required="false" default="#application.wheels.functions.dateSelectTags.monthDisplay#" hint="See documentation for @dateSelect.">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.dateSelectTags.includeBlank#" hint="See documentation for @dateSelect.">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.dateSelectTags.label#" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.dateSelectTags.labelPlacement#" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.dateSelectTags.prepend#" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.dateSelectTags.append#" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.dateSelectTags.prependToLabel#" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.dateSelectTags.appendToLabel#" hint="See documentation for @textField.">
	<cfscript>
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = arguments.selected;
		StructDelete(arguments, "name");
		StructDelete(arguments, "selected");
		arguments.$functionName = "dateSelectTag";
	</cfscript>
	<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="timeSelectTags" returntype="string" access="public" output="false" hint="Builds and returns a string containing three select form controls for a time based on the supplied `objectName` and `property`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##timeSelectTags(name="timeOfMeeting")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="date" required="false" default="#Now()#" hint="See documentation for @selectTag.">
	<cfargument name="order" type="string" required="false" default="#application.wheels.functions.timeSelectTags.order#" hint="See documentation for @timeSelect.">
	<cfargument name="separator" type="string" required="false" default="#application.wheels.functions.timeSelectTags.separator#" hint="See documentation for @timeSelect.">
	<cfargument name="minuteStep" type="numeric" required="false" default="#application.wheels.functions.timeSelectTags.minuteStep#" hint="See documentation for @timeSelect.">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.timeSelectTags.includeBlank#" hint="See documentation for @timeSelect.">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.timeSelectTags.label#" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.timeSelectTags.labelPlacement#" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.timeSelectTags.prepend#" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.timeSelectTags.append#" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.timeSelectTags.prependToLabel#" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.timeSelectTags.appendToLabel#" hint="See documentation for @textField.">
	<cfscript>
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = arguments.selected;
		StructDelete(arguments, "name");
		StructDelete(arguments, "selected");
		arguments.$functionName = "timeSelectTag";
	</cfscript>
	<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="dateTimeSelectTags" returntype="string" access="public" output="false" hint="Builds and returns a string containing six select form controls (three for date selection and the remaining three for time selection)."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##dateTimeSelectTags()##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateSelectTags,timeSelectTags">
	<cfargument name="dateOrder" type="string" required="false" default="#application.wheels.functions.dateTimeSelectTags.dateOrder#" hint="See documentation for @dateTimeSelect.">
	<cfargument name="dateSeparator" type="string" required="false" default="#application.wheels.functions.dateTimeSelectTags.dateSeparator#" hint="See documentation for @dateTimeSelect.">
	<cfargument name="startYear" type="numeric" required="false" default="#application.wheels.functions.dateTimeSelectTags.startYear#" hint="See documentation for @dateTimeSelect.">
	<cfargument name="endYear" type="numeric" required="false" default="#application.wheels.functions.dateTimeSelectTags.endYear#" hint="See documentation for @dateTimeSelect.">
	<cfargument name="monthDisplay" type="string" required="false" default="#application.wheels.functions.dateTimeSelectTags.monthDisplay#" hint="See documentation for @dateTimeSelect.">
	<cfargument name="timeOrder" type="string" required="false" default="#application.wheels.functions.dateTimeSelectTags.timeOrder#" hint="See documentation for @dateTimeSelect.">
	<cfargument name="timeSeparator" type="string" required="false" default="#application.wheels.functions.dateTimeSelectTags.timeSeparator#" hint="See documentation for @dateTimeSelect.">
	<cfargument name="minuteStep" type="numeric" required="false" default="#application.wheels.functions.dateTimeSelectTags.minuteStep#" hint="See documentation for @dateTimeSelect.">
	<cfargument name="separator" type="string" required="false" default="#application.wheels.functions.dateTimeSelectTags.separator#" hint="See documentation for @dateTimeSelect.">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.dateTimeSelectTags.includeBlank#" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.dateTimeSelectTags.label#" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.dateTimeSelectTags.labelPlacement#" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.dateTimeSelectTags.prepend#" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.dateTimeSelectTags.append#" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.dateTimeSelectTags.prependToLabel#" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.dateTimeSelectTags.appendToLabel#" hint="See documentation for @textField.">
	<cfscript>
		var loc = {};
		loc.returnValue = "";
		loc.separator = arguments.separator;
		arguments.order = arguments.dateOrder;
		arguments.separator = arguments.dateSeparator;
		if (StructKeyExists(arguments, "$functionName") && arguments.$functionName == "dateTimeSelect")
			loc.returnValue = loc.returnValue & dateSelect(argumentCollection=arguments);
		else
			loc.returnValue = loc.returnValue & dateSelectTags(argumentCollection=arguments);
		loc.returnValue = loc.returnValue & loc.separator;
		arguments.order = arguments.timeOrder;
		arguments.separator = arguments.timeSeparator;
		if (StructKeyExists(arguments, "$functionName") && arguments.$functionName == "dateTimeSelect")
			loc.returnValue = loc.returnValue & timeSelect(argumentCollection=arguments);
		else
			loc.returnValue = loc.returnValue & timeSelectTags(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="yearSelectTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing a select form control for a range of years based on the supplied `name`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##yearSelectTag(name="yearOfBirthday")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="date" required="false" default="#Year(Now())#" hint="The year that should be selected initially.">
	<cfargument name="startYear" type="numeric" required="false" default="#application.wheels.functions.yearSelectTag.startYear#" hint="See documentation for @dateSelect.">
	<cfargument name="endYear" type="numeric" required="false" default="#application.wheels.functions.yearSelectTag.endYear#" hint="See documentation for @dateSelect.">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.yearSelectTag.includeBlank#" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.yearSelectTag.label#" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.yearSelectTag.labelPlacement#" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.yearSelectTag.prepend#" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.yearSelectTag.append#" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.yearSelectTag.prependToLabel#" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.yearSelectTag.appendToLabel#" hint="See documentation for @textField.">
	<cfscript>
		arguments.selected = createDate(arguments.selected, Month(Now()), Day(Now()));
		arguments.order = "year";
	</cfscript>
	<cfreturn dateSelectTags(argumentCollection=arguments)>
</cffunction>

<cffunction name="monthSelectTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing a select form control for the months of the year based on the supplied `name`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##monthSelectTag(name="monthOfBirthday")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="date" required="false" default="#Month(Now())#" hint="The month that should be selected initially.">
	<cfargument name="monthDisplay" type="string" required="false" default="#application.wheels.functions.monthSelectTag.monthDisplay#" hint="See documentation for @dateSelect.">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.monthSelectTag.includeBlank#" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.monthSelectTag.label#" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.monthSelectTag.labelPlacement#" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.monthSelectTag.prepend#" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.monthSelectTag.append#" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.monthSelectTag.prependToLabel#" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.monthSelectTag.appendToLabel#" hint="See documentation for @textField.">
	<cfscript>
		arguments.selected = createDate(Year(Now()), arguments.selected, Day(Now()));
		arguments.order = "month";
	</cfscript>
	<cfreturn dateSelectTags(argumentCollection=arguments)>
</cffunction>

<cffunction name="daySelectTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing a select form control for the days of the week based on the supplied `name`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##daySelectTag(name="dayOfWeek")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="date" required="false" default="#Day(Now())#" hint="The day that should be selected initially.">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.daySelectTag.includeBlank#" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.daySelectTag.label#" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.daySelectTag.labelPlacement#" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.daySelectTag.prepend#" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.daySelectTag.append#" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.daySelectTag.prependToLabel#" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.daySelectTag.appendToLabel#" hint="See documentation for @textField.">
	<cfscript>
		arguments.selected = createDate(Year(Now()), Month(Now()), arguments.selected);
		arguments.order = "day";
	</cfscript>
	<cfreturn dateSelectTags(argumentCollection=arguments)>
</cffunction>

<cffunction name="hourSelectTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing one select form control for the hours of the day based on the supplied `name`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##hourSelectTag(name="hourOfMeeting")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="date" required="false" default="#Hour(Now())#" hint="The hour that should be selected initially.">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.hourSelectTag.includeBlank#" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.hourSelectTag.label#" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.hourSelectTag.labelPlacement#" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.hourSelectTag.prepend#" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.hourSelectTag.append#" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.hourSelectTag.prependToLabel#" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.hourSelectTag.appendToLabel#" hint="See documentation for @textField.">
	<cfscript>
		arguments.selected = createTime(arguments.selected, Minute(Now()), Second(Now()));
		arguments.order = "hour";
	</cfscript>
	<cfreturn timeSelectTags(argumentCollection=arguments)>
</cffunction>

<cffunction name="minuteSelectTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing one select form control for the minutes of an hour based on the supplied `name`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##minuteSelectTag(name="minuteOfMeeting")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="date" required="false" default="#Minute(Now())#" hint="The minute that should be selected initially.">
	<cfargument name="minuteStep" type="numeric" required="false" default="#application.wheels.functions.minuteSelectTag.minuteStep#" hint="See documentation for @timeSelect.">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.minuteSelectTag.includeBlank#" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.minuteSelectTag.label#" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.minuteSelectTag.labelPlacement#" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.minuteSelectTag.prepend#" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.minuteSelectTag.append#" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.minuteSelectTag.prependToLabel#" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.minuteSelectTag.appendToLabel#" hint="See documentation for @textField.">
	<cfscript>
		arguments.selected = createTime(Hour(Now()), arguments.selected, Second(Now()));
		arguments.order = "minute";
	</cfscript>
	<cfreturn timeSelectTags(argumentCollection=arguments)>
</cffunction>

<cffunction name="secondSelectTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing one select form control for the seconds of a minute based on the supplied `name`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##secondSelectTag(name="secondsToLaunch")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="date" required="false" default="#Second(Now())#" hint="The second that should be selected initially.">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.secondSelectTag.includeBlank#" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.secondSelectTag.label#" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.secondSelectTag.labelPlacement#" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.secondSelectTag.prepend#" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.secondSelectTag.append#" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.secondSelectTag.prependToLabel#" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.secondSelectTag.appendToLabel#" hint="See documentation for @textField.">
	<cfscript>
		arguments.selected = createTime(Hour(Now()), Minute(Now()), arguments.selected);
		arguments.order = "second";
	</cfscript>
	<cfreturn timeSelectTags(argumentCollection=arguments)>
</cffunction>