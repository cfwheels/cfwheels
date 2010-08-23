<cffunction name="dateSelectTags" returntype="string" access="public" output="false" hint="Builds and returns a string containing three select form controls (month, day and year)."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##dateSelectTags()##</p>
		</cfoutput>
	'
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,textFieldTag,submitTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="string" required="false" default="" hint="See documentation for @selectTag.">
	<cfargument name="order" type="string" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="separator" type="string" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="startYear" type="numeric" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="endYear" type="numeric" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="monthDisplay" type="string" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="includeBlank" type="any" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="label" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="combine" type="boolean" required="false" hint="See documentation for @dateSelect.">
	<cfscript>
		$args(name="dateSelectTags", args=arguments);
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
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="string" required="false" default="" hint="See documentation for @selectTag.">
	<cfargument name="order" type="string" required="false" hint="See documentation for @timeSelect.">
	<cfargument name="separator" type="string" required="false" hint="See documentation for @timeSelect.">
	<cfargument name="minuteStep" type="numeric" required="false" hint="See documentation for @timeSelect.">
	<cfargument name="includeBlank" type="any" required="false" hint="See documentation for @timeSelect.">
	<cfargument name="label" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="combine" type="boolean" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="twelveHour" type="boolean" required="false" default="false" hint="See documentation for @timeSelect.">
	<cfscript>
		$args(name="timeSelectTags", args=arguments);
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
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="string" required="false" default="" hint="See documentation for @selectTag.">
	<cfargument name="dateOrder" type="string" required="false" hint="See documentation for @dateTimeSelect.">
	<cfargument name="dateSeparator" type="string" required="false" hint="See documentation for @dateTimeSelect.">
	<cfargument name="startYear" type="numeric" required="false" hint="See documentation for @dateTimeSelect.">
	<cfargument name="endYear" type="numeric" required="false" hint="See documentation for @dateTimeSelect.">
	<cfargument name="monthDisplay" type="string" required="false" hint="See documentation for @dateTimeSelect.">
	<cfargument name="timeOrder" type="string" required="false" hint="See documentation for @dateTimeSelect.">
	<cfargument name="timeSeparator" type="string" required="false" hint="See documentation for @dateTimeSelect.">
	<cfargument name="minuteStep" type="numeric" required="false" hint="See documentation for @dateTimeSelect.">
	<cfargument name="separator" type="string" required="false" hint="See documentation for @dateTimeSelect.">
	<cfargument name="includeBlank" type="any" required="false" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="combine" type="boolean" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="twelveHour" type="boolean" required="false" default="false" hint="See documentation for @timeSelect.">
	<cfscript>
		var loc = {};
		$args(name="dateTimeSelectTags", args=arguments);
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
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="string" required="false" default="" hint="The year that should be selected initially.">
	<cfargument name="startYear" type="numeric" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="endYear" type="numeric" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="includeBlank" type="any" required="false" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfscript>
		$args(name="yearSelectTag", args=arguments);
		if (IsNumeric(arguments.selected))
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
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="string" required="false" default="" hint="The month that should be selected initially.">
	<cfargument name="monthDisplay" type="string" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="includeBlank" type="any" required="false" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfscript>
		$args(name="monthSelectTag", args=arguments);
		if (IsNumeric(arguments.selected) and arguments.selected gt 0 and arguments.selected lte 12)
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
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="string" required="false" default="" hint="The day that should be selected initially.">
	<cfargument name="includeBlank" type="any" required="false" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfscript>
		$args(name="daySelectTag", args=arguments);
		if (IsNumeric(arguments.selected) and arguments.selected gt 0 and arguments.selected lte 31)
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
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="string" required="false" default="" hint="The hour that should be selected initially.">
	<cfargument name="includeBlank" type="any" required="false" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="twelveHour" type="boolean" required="false" default="false" hint="See documentation for @timeSelect.">
	<cfscript>
		$args(name="hourSelectTag", args=arguments);
		if (IsNumeric(arguments.selected) and arguments.selected gte 0 and arguments.selected lt 60)
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
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="string" required="false" default="" hint="The minute that should be selected initially.">
	<cfargument name="minuteStep" type="numeric" required="false" hint="See documentation for @timeSelect.">
	<cfargument name="includeBlank" type="any" required="false" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfscript>
		$args(name="minuteSelectTag", args=arguments);
		if (IsNumeric(arguments.selected) and arguments.selected gte 0 and arguments.selected lt 60)
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
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="string" required="false" default="" hint="The second that should be selected initially.">
	<cfargument name="includeBlank" type="any" required="false" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfscript>
		$args(name="secondSelectTag", args=arguments);
		if (IsNumeric(arguments.selected) and arguments.selected gte 0 and arguments.selected lt 60)
			arguments.selected = createTime(Hour(Now()), Minute(Now()), arguments.selected);
		arguments.order = "second";
	</cfscript>
	<cfreturn timeSelectTags(argumentCollection=arguments)>
</cffunction>